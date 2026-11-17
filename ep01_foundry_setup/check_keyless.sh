#!/bin/sh
# Proves the call is keyless: with the Foundry User role removed and a key variable set, first_call.py must be
# refused. Then the role is put back. A role change takes a few minutes to apply, so it waits for the refusal.
#   ep01_foundry_setup/check_keyless.sh
set -u
cd "$(dirname "$0")/.."
. infra/config.sh
PROJECT_ID=$(az cognitiveservices account project show -n "$FOUNDRY_RESOURCE" -g "$RG" --project-name "$PROJECT" --query id -o tsv)
ME=$(az ad signed-in-user show --query id -o tsv)
az role assignment delete --assignee "$ME" --scope "$PROJECT_ID" --role "$FOUNDRY_USER_ROLE"
export AZURE_OPENAI_API_KEY=not-used AZURE_AI_API_KEY=not-used OPENAI_API_KEY=not-used
refused=no
for i in 1 2 3 4 5 6 7 8 9 10; do
  if ! .venv/bin/python ep01_foundry_setup/first_call.py >/dev/null 2>&1; then refused=yes; break; fi
  sleep 60
done
az role assignment create --role "$FOUNDRY_USER_ROLE" --assignee-object-id "$ME" --assignee-principal-type User --scope "$PROJECT_ID" -o none
echo "refused without the role: $refused"
[ "$refused" = yes ]
