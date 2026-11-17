#!/bin/sh
# Creates everything episode 1 needs, in one resource group: a Foundry resource with project management on, a project,
# one chat model deployment, and the Foundry User role for you on the project, so the code calls the model with no key.
# Safe to run again: each step skips what already exists. Needs the Azure CLI 2.80 or later and `az login`.
set -eu
. "$(dirname "$0")/config.sh"

if [ -z "${FOUNDRY_RESOURCE:-}" ]; then
  FOUNDRY_RESOURCE="ai103-$(LC_ALL=C tr -dc a-z0-9 </dev/urandom | head -c 6)"
  echo "FOUNDRY_RESOURCE=$FOUNDRY_RESOURCE" >> "$ENV_FILE"
fi

echo "== resource group $RG in $REGION"
az group create --name "$RG" --location "$REGION" --tags course=ai103 --query properties.provisioningState -o tsv

echo "== Foundry resource"
if ! az cognitiveservices account show -n "$FOUNDRY_RESOURCE" -g "$RG" >/dev/null 2>&1; then
  az cognitiveservices account create --name "$FOUNDRY_RESOURCE" --resource-group "$RG" --location "$REGION" \
    --kind AIServices --sku S0 --custom-domain "$FOUNDRY_RESOURCE" --assign-identity \
    --allow-project-management true --tags course=ai103 --query properties.provisioningState -o tsv
fi

echo "== project $PROJECT"
if ! az cognitiveservices account project show -n "$FOUNDRY_RESOURCE" -g "$RG" --project-name "$PROJECT" >/dev/null 2>&1; then
  az cognitiveservices account project create --name "$FOUNDRY_RESOURCE" --resource-group "$RG" \
    --project-name "$PROJECT" --location "$REGION" --query properties.provisioningState -o tsv
fi

echo "== model deployment $MODEL ($DEPLOY_SKU, $CAPACITY)"
if ! az cognitiveservices account deployment show -n "$FOUNDRY_RESOURCE" -g "$RG" --deployment-name "$MODEL" >/dev/null 2>&1; then
  az cognitiveservices account deployment create --name "$FOUNDRY_RESOURCE" --resource-group "$RG" \
    --deployment-name "$MODEL" --model-name "$MODEL" --model-version "$MODEL_VERSION" --model-format OpenAI \
    --sku-name "$DEPLOY_SKU" --sku-capacity "$CAPACITY" --query properties.provisioningState -o tsv
fi

echo "== Foundry User for you on the project (keyless: your az login is the credential)"
PROJECT_ID=$(az cognitiveservices account project show -n "$FOUNDRY_RESOURCE" -g "$RG" --project-name "$PROJECT" --query id -o tsv)
ME=$(az ad signed-in-user show --query id -o tsv)
if [ -z "$(az role assignment list --assignee "$ME" --scope "$PROJECT_ID" --role "$FOUNDRY_USER_ROLE" --query '[].id' -o tsv)" ]; then
  az role assignment create --role "$FOUNDRY_USER_ROLE" --assignee-object-id "$ME" --assignee-principal-type User \
    --scope "$PROJECT_ID" --query roleDefinitionName -o tsv
  echo "(a new role assignment can take a few minutes to apply)"
fi

ENDPOINT=$(az cognitiveservices account project show -n "$FOUNDRY_RESOURCE" -g "$RG" --project-name "$PROJECT" \
  --query 'properties.endpoints."AI Foundry API"' -o tsv)
grep -v '^FOUNDRY_PROJECT_ENDPOINT=\|^FOUNDRY_MODEL_DEPLOYMENT=' "$ENV_FILE" > "$ENV_FILE.tmp" || true
{ cat "$ENV_FILE.tmp"; echo "FOUNDRY_PROJECT_ENDPOINT=$ENDPOINT"; echo "FOUNDRY_MODEL_DEPLOYMENT=$MODEL"; } > "$ENV_FILE"
rm -f "$ENV_FILE.tmp"
echo "== ready: project $PROJECT, deployment $MODEL (endpoint written to .env)"
