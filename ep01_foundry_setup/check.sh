#!/bin/sh
# Checks your own episode 1 work against what the lesson builds, read-only: it changes nothing in Azure.
#   ep01_foundry_setup/check.sh
# Each check prints PASS or FAIL, the exam skill it belongs to, and on a FAIL what to look at. Exit code: the
# number of FAILs. Built with infra/up.sh, or by hand in the portal: set FOUNDRY_RESOURCE in .env to your
# resource's name either way (AI103_RG and AI103_PROJECT if you named those differently too).
set -u
cd "$(dirname "$0")/.."
. infra/config.sh
RG=${AI103_RG:-$RG}
PROJECT=${AI103_PROJECT:-$PROJECT}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; echo "      skill: $2"; echo "      look at: $3"; fails=$((fails + 1)); }
S_INFRA="Design Azure infrastructure for AI apps and agent-based solutions"
S_DEPLOY="Choose appropriate deployment options"
S_CONFIG="Configure model and agent deployments / configure an application to connect to a Foundry project"

if ! az account show >/dev/null 2>&1; then
  fail "signed in to Azure" "$S_INFRA" "run az login (ENVIRONMENT step 7 in the course repo's README)"
  exit "$fails"
fi
pass "signed in to Azure"

if [ "$(az group exists -n "$RG" 2>/dev/null)" = true ]; then pass "resource group $RG exists"
else fail "resource group $RG exists" "$S_INFRA" "infra/up.sh step 1, or create it in the portal"; fi

if [ -z "${FOUNDRY_RESOURCE:-}" ]; then
  fail "FOUNDRY_RESOURCE is set in .env" "$S_INFRA" "infra/up.sh writes it; by hand, add FOUNDRY_RESOURCE=<your resource's name>"
  exit "$fails"
fi
res=$(az cognitiveservices account show -n "$FOUNDRY_RESOURCE" -g "$RG" \
  --query "[kind, properties.allowProjectManagement, identity.type]" -o tsv 2>/dev/null | tr '\n\t' '  ')
if [ -z "$res" ]; then
  fail "Foundry resource $FOUNDRY_RESOURCE exists" "$S_INFRA" "infra/up.sh step 2: kind AIServices"
else
  case "$res" in AIServices*) pass "Foundry resource is kind AIServices";;
    *) fail "Foundry resource is kind AIServices (found: ${res%% *})" "$S_INFRA" "a Foundry resource is kind AIServices; an older Azure OpenAI resource is not one";; esac
  case "$res" in *True*|*true*) pass "project management is on";;
    *) fail "project management is on" "$S_INFRA" "--allow-project-management: without it the resource holds no projects";; esac
  case "$res" in *SystemAssigned*) pass "the resource has a managed identity";;
    *) fail "the resource has a managed identity" "$S_INFRA" "--assign-identity (projects and agents use it to reach other services)";; esac
fi

pid=$(az cognitiveservices account project show -n "$FOUNDRY_RESOURCE" -g "$RG" --project-name "$PROJECT" --query id -o tsv 2>/dev/null)
if [ -n "$pid" ]; then pass "project $PROJECT exists"
else fail "project $PROJECT exists" "$S_INFRA" "infra/up.sh step 3: az cognitiveservices account project create"; fi

dep=$(az cognitiveservices account deployment show -n "$FOUNDRY_RESOURCE" -g "$RG" --deployment-name "$MODEL" \
  --query "[sku.name, properties.model.name, properties.provisioningState]" -o tsv 2>/dev/null | tr '\n\t' '  ')
if [ -z "$dep" ]; then
  fail "deployment $MODEL exists" "$S_CONFIG" "infra/up.sh step 4; the deployment's name is the name your code uses"
else
  case "$dep" in GlobalStandard*) pass "deployment type is Global Standard";;
    *) fail "deployment type is Global Standard (found: ${dep%% *})" "$S_DEPLOY" "Microsoft's advice: start with Global Standard unless residency, reserved throughput or batch says otherwise";; esac
  case "$dep" in *Succeeded*) pass "deployment is ready";;
    *) fail "deployment is ready ($dep)" "$S_CONFIG" "wait a minute and run this again";; esac
fi

if [ -n "$pid" ]; then
  me=$(az ad signed-in-user show --query id -o tsv 2>/dev/null)
  if [ -n "$(az role assignment list --assignee "$me" --scope "$pid" --role "$FOUNDRY_USER_ROLE" --query '[].id' -o tsv 2>/dev/null)" ]; then
    pass "you have the Foundry User role on the project"
  else
    fail "you have the Foundry User role on the project" "$S_INFRA" "infra/up.sh step 5; Owner alone has no data actions, so keyless calls are refused"
  fi
fi

if grep -q '^FOUNDRY_PROJECT_ENDPOINT=https://' .env 2>/dev/null; then pass ".env has the project endpoint"
else fail ".env has the project endpoint" "$S_CONFIG" "the project's Foundry endpoint, not the resource's (infra/up.sh writes it)"; fi

if grep -qiE 'api[_-]?key' .env ep01_foundry_setup/*.py 2>/dev/null; then
  fail "no key in .env or the code" "$S_CONFIG" "the lesson connects with DefaultAzureCredential: remove the key"
else pass "no key in .env or the code"; fi

if [ -x .venv/bin/python ] && out=$(.venv/bin/python ep01_foundry_setup/first_call.py 2>&1); then
  pass "first_call.py gets an answer from the model"
else
  code=$(echo "${out:-}" | grep -oE "Error code: [0-9]+" | head -1)
  fail "first_call.py gets an answer from the model ${code:+($code)}" "$S_CONFIG" \
    "403: the role (it can take minutes to apply); 404: the deployment's name or the endpoint; no .venv: the README's setup"
fi

echo "$fails failed"
exit "$fails"
