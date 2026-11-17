#!/bin/sh
# Creates (or updates) a monthly budget on your current subscription, with alerts by email to the subscription's
# owners: at 80% of the amount spent, and when the month's forecast passes 100%. A budget warns; it doesn't stop
# anything, and cost data arrives up to a day late. Allow azure-noreply@microsoft.com so the alerts aren't junked.
#   sh infra/budget.sh [amount in your billing currency, default 50]
# Uses the Budgets REST API: `az consumption budget create` has no alert settings.
set -eu
AMOUNT=${1:-50}
NAME=${AI103_BUDGET_NAME:-ai103-monthly}
SUB=$(az account show --query id -o tsv)
START=$(date -u +%Y-%m-01)
END=$(( $(date -u +%Y) + 5 ))-$(date -u +%m)-01
BODY=$(cat <<JSON
{"properties": {"category": "Cost", "amount": $AMOUNT, "timeGrain": "Monthly",
  "timePeriod": {"startDate": "${START}T00:00:00Z", "endDate": "${END}T00:00:00Z"},
  "notifications": {
    "actual80": {"enabled": true, "operator": "GreaterThanOrEqualTo", "threshold": 80, "thresholdType": "Actual",
                 "contactEmails": [], "contactRoles": ["Owner"]},
    "forecast100": {"enabled": true, "operator": "GreaterThanOrEqualTo", "threshold": 100, "thresholdType": "Forecasted",
                    "contactEmails": [], "contactRoles": ["Owner"]}}}}
JSON
)
az rest --method put --url "https://management.azure.com/subscriptions/$SUB/providers/Microsoft.Consumption/budgets/$NAME?api-version=2024-08-01" \
  --body "$BODY" --query "{budget:name, amount:properties.amount, alerts:length(values(properties.notifications))}" -o tsv
echo "budget $NAME: $AMOUNT a month, alerts to the subscription's owners at 80% spent and 100% forecast"
