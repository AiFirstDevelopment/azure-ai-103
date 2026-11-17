#!/bin/sh
# Deletes everything the course created: the resource group rg-ai103 and all in it, then purges the soft-deleted
# Foundry resource (Azure keeps a deleted one for 48 days, holding its name and quota). Exits 1 if the group is
# still there at the end, so a teardown that did not happen cannot look like one that did.
set -u
. "$(dirname "$0")/config.sh"

if [ "$(az group exists --name "$RG")" = true ]; then
  echo "== deleting $RG (a few minutes)"
  az group delete --name "$RG" --yes
fi

for name in $(az cognitiveservices account list-deleted --query "[?tags.course=='ai103' || starts_with(name, 'ai103-')].name" -o tsv 2>/dev/null); do
  loc=$(az cognitiveservices account list-deleted --query "[?name=='$name'].location | [0]" -o tsv)
  echo "== purging soft-deleted $name"
  az cognitiveservices account purge --name "$name" --resource-group "$RG" --location "$loc"
done

# Forget the resource's name, so the next up.sh makes a new one: a Foundry resource re-created under a name just
# purged answered "The API deployment for this resource does not exist" for over an hour (2026-11-16).
if [ -f "$ENV_FILE" ]; then grep -v '^FOUNDRY_' "$ENV_FILE" > "$ENV_FILE.tmp"; mv "$ENV_FILE.tmp" "$ENV_FILE"; fi

left=$(az group exists --name "$RG")
echo "rg-ai103 exists: $left"
left_deleted=$(az cognitiveservices account list-deleted --query "[?starts_with(name, 'ai103-')].name" -o tsv 2>/dev/null)
[ -n "$left_deleted" ] && echo "still soft-deleted: $left_deleted"
[ "$left" = false ] && [ -z "$left_deleted" ]
