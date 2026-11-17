#!/bin/sh
# Is this machine ready for the course? Read-only: it installs nothing and changes nothing.
#   sh infra/doctor.sh
# PASS or FAIL for each thing episode 1 needs, and on a FAIL what to do (or run /setup in Claude Code, which does it).
# Exit code: the number of FAILs. Never prints the account's email address.
cd "$(dirname "$0")/.."
REGION=${AI103_REGION:-eastus2}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; echo "      fix: $2"; fails=$((fails + 1)); }

if command -v git >/dev/null 2>&1; then pass "git ($(git --version | awk '{print $3}'))"
else fail "git" "install it from https://git-scm.com/downloads"; fi

PY=""
for c in python3.12 "py -3.12"; do
  if $c -c 'import sys; assert sys.version_info[:2] == (3, 12)' >/dev/null 2>&1; then PY=$c; break; fi
done
if [ -n "$PY" ]; then pass "Python 3.12 ($PY)"
else fail "Python 3.12" "https://www.python.org/downloads/ (or your package manager); Ubuntu 24.04: apt install python3.12 python3.12-venv"; fi

VPY=.venv/bin/python; [ -x "$VPY" ] || VPY=.venv/Scripts/python.exe
if [ -x "$VPY" ] && "$VPY" -c 'import azure.ai.projects, azure.identity, openai' >/dev/null 2>&1; then
  pass ".venv with the course's packages"
else
  fail ".venv with the course's packages" "python3.12 -m venv .venv, then .venv/bin/python -m pip install -r requirements.txt"
fi

if ! command -v az >/dev/null 2>&1; then
  fail "Azure CLI" "https://learn.microsoft.com/cli/azure/install-azure-cli"
  echo "$fails failed"; exit "$fails"
fi
v=$(az version --query '"azure-cli"' -o tsv 2>/dev/null)
major=${v%%.*}; minor=${v#*.}; minor=${minor%%.*}
if [ -n "$v" ] && { [ "$major" -gt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -ge 80 ]; }; }; then pass "Azure CLI $v"
else fail "Azure CLI 2.80 or later (found ${v:-none})" "az upgrade, or reinstall from Microsoft's install page"; fi

id=$(az account show --query id -o tsv 2>/dev/null)
if [ -z "$id" ]; then
  fail "signed in to Azure" "az login --output none (in a container or over SSH: add --use-device-code)"
  echo "$fails failed"; exit "$fails"
fi
name=$(az account show --query name -o tsv); state=$(az account show --query state -o tsv)
pass "signed in to Azure"
if [ "$state" = Enabled ]; then pass "subscription \"$name\" is enabled"
else fail "subscription \"$name\" is enabled (it is $state)" "the Azure portal, Subscriptions: a disabled free trial is upgraded to pay-as-you-go"; fi

lim=$(az cognitiveservices usage list -l "$REGION" --query "[?name.value=='OpenAI.GlobalStandard.gpt-5-mini'].limit | [0]" -o tsv 2>/dev/null)
if [ -n "$lim" ] && [ "${lim%.*}" -gt 0 ] 2>/dev/null; then pass "quota for gpt-5-mini Global Standard in $REGION (${lim%.*}K tokens a minute)"
else fail "quota for gpt-5-mini Global Standard in $REGION (found ${lim:-none})" "a free trial subscription can have no quota for OpenAI models and cannot ask for more: upgrade to pay-as-you-go (your credit is kept)"; fi

notes=$(az rest --method get --url "https://management.azure.com/subscriptions/$id/providers/Microsoft.Consumption/budgets?api-version=2024-08-01" \
  --query "length(value[?properties.notifications && length(values(properties.notifications)[?length(contactEmails || \`[]\`) > \`0\` || length(contactRoles || \`[]\`) > \`0\`]) > \`0\`])" -o tsv 2>/dev/null)
if [ -n "$notes" ] && [ "$notes" -gt 0 ] 2>/dev/null; then pass "a budget with an alert"
else fail "a budget with an alert" "/setup creates one; or the portal: Subscriptions, your subscription, Budgets (it warns, it doesn't stop anything)"; fi

echo "$fails failed"
exit "$fails"
