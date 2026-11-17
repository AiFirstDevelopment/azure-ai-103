#!/bin/sh
# Month-to-date cost of everything the course ran (resource group rg-ai103), from Azure Cost Management. Cost data
# arrives with a delay of up to a day, so today's runs may not show yet.
set -eu
. "$(dirname "$0")/config.sh"
SUB=$(az account show --query id -o tsv)
az rest --method post \
  --url "https://management.azure.com/subscriptions/$SUB/providers/Microsoft.CostManagement/query?api-version=2023-11-01" \
  --body "{\"type\":\"ActualCost\",\"timeframe\":\"MonthToDate\",\"dataset\":{\"granularity\":\"None\",
    \"aggregation\":{\"totalCost\":{\"name\":\"Cost\",\"function\":\"Sum\"}},
    \"filter\":{\"dimensions\":{\"name\":\"ResourceGroupName\",\"operator\":\"In\",\"values\":[\"$RG\"]}}}}" \
  --query "properties.rows[0] | join(' ', [to_string([0]), [1]])" -o tsv 2>/dev/null | sed 's/^/rg-ai103 month to date: /' \
  || echo "rg-ai103 month to date: no cost recorded yet"
