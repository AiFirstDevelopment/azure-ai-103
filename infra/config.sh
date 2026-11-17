# Shared by up.sh, down.sh and cost.sh. The names are the course's; the resource name is made unique once and kept
# in .env (never committed), because a Foundry resource's custom domain must be unique across Azure.
RG=rg-ai103
PROJECT=ai103
REGION=${AI103_REGION:-eastus2}            # chosen in ENVIRONMENT.md step 6
MODEL=${AI103_MODEL:-gpt-5-mini}           # the chat model episode 1 deploys
MODEL_VERSION=${AI103_MODEL_VERSION:-2025-08-07}
DEPLOY_SKU=GlobalStandard                  # Microsoft: "For most workloads, start with Global Standard"
CAPACITY=${AI103_CAPACITY:-10}             # thousands of tokens a minute
FOUNDRY_USER_ROLE=53ca6127-db72-4b80-b1b0-d745d6d5456d   # Foundry User, by id: the role names were renamed in 2026
ROOT=$(cd "$(dirname "$0")/.." && pwd)
ENV_FILE="$ROOT/.env"
if [ -f "$ENV_FILE" ]; then . "$ENV_FILE"; fi
