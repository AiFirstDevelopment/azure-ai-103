# Episode 1 (tag s4e1): Microsoft Foundry setup and your first model call

The instructor's brief `/tutor` loads for this episode: what it builds, why, how the exam asks about it, and where
Microsoft says so. Answers about episode 1 come from this file, the code in this folder, `infra/`, and the pages
linked below.

## The exam skills it covers (Microsoft's words)

From "Plan and manage an Azure AI solution", "Set up AI solutions in Foundry" (study guide, skills measured as of
April 16, 2026):

- Design Azure infrastructure for AI apps and agent-based solutions
- Choose appropriate deployment options
- Configure model and agent deployments
- Configure an application to connect to a Foundry project

## What you should have when you're done

| Requirement | Why the lesson needs it | `check.sh` |
|---|---|---|
| Resource group `rg-ai103` | everything for the course in one place, deleted in one step by `infra/down.sh` | resource group exists |
| A Foundry resource: kind `AIServices`, project management on, a system-assigned managed identity | the Foundry resource holds your models, agents and tools; without project management it holds no projects; the identity lets it reach other Azure services | kind, project management, identity |
| A project, `ai103` | a project holds the models, agents and other resources a team uses; your code connects to the project, not the resource | project exists |
| A deployment of `gpt-5-mini`, type Global Standard | most models need a deployment first, and its name is the name your code uses; Microsoft's advice is to start with Global Standard | deployment type, ready |
| The Foundry User role for you, on the project | the least-privileged role that can call models in a project; Owner alone has no data actions, so a keyless call is refused | role assignment |
| `.env` with `FOUNDRY_PROJECT_ENDPOINT` and `FOUNDRY_MODEL_DEPLOYMENT` | the project endpoint (ends in `api/projects/<project>`) and the deployment's name are all the code needs | endpoint in `.env` |
| No key anywhere | the code signs in with `DefaultAzureCredential` (your `az login`); a key in code or `.env` misses the point of the lesson | no key |
| `first_call.py` answers | the whole chain works: token, role, endpoint, deployment | first call |

## Key ideas, to answer questions from

- **Microsoft Foundry** is Azure's platform for building AI apps and agents: one Azure resource (the Foundry
  resource) with projects inside it. Networking and policies are set on the resource; access can be granted on the
  whole resource or on one project.
- **The portal** has the current view (Foundry projects, where Microsoft says new work is focused) and a classic
  view for older hub-based projects. This course uses Foundry projects.
- **Deployment types** decide where your data is processed and how you pay: Global Standard (any Azure region, pay
  per token, start here), Data Zone Standard (inside one data zone: the United States, the European Union, or Asia
  Pacific), Standard (one Azure geography), provisioned (reserved capacity for steady high volume and lower latency
  variance), batch (half the price, results within 24 hours). The exam's choice: residency, throughput, cost.
- **A token** is a word, part of a word, or a piece of punctuation: the unit a model reads and writes and you pay for.
- **Keyless calls:** the app asks Microsoft Entra ID for a token as whoever `DefaultAzureCredential` finds first
  (here, your `az login`), sends it to the project endpoint, and the project checks the token for a role.
- **The SDK:** `AIProjectClient` (package `azure-ai-projects`) hands back an OpenAI client pointed at the project
  (`get_openai_client()`); one `responses.create` call with the deployment's name as the model. The answer is in
  `output_text`, the token counts in `usage`.
- **Instant access models (preview)** can be called by name with no deployment; this lesson deploys one.

## How the exam asks about this

The study guide's skills are about choices, so expect scenarios: a requirement, and the option that meets it. The
decisions this episode teaches, each with the rule that settles it:

- **Which deployment type?** Data must stay in the EU or the US: Data Zone Standard (a data zone) or Standard (one
  geography). Steady, high, predictable volume with low latency variance: provisioned. Large jobs that can wait up
  to 24 hours, cheapest: batch. No constraint stated: Global Standard, Microsoft's default advice.
- **Which role lets an app or a developer call a model in a project, with least privilege?** Foundry User on the
  project. Owner or Contributor manage resources but carry no data actions, so they don't let you call the model.
- **Where is access granted?** On the Foundry resource (every project in it) or on one project (just that one). One
  team's app should get the project.
- **Where are networking and policies set?** On the Foundry resource, not the project.
- **How should an app authenticate?** Keyless, with Microsoft Entra ID: `DefaultAzureCredential` locally (your
  `az login`), a managed identity in Azure. Keys are the thing to avoid.
- **What does an app need to connect?** The project endpoint and the deployment's name (not the model's catalog
  name, unless it's an instant access model in preview).
- **Which portal?** The current Foundry portal for Foundry projects (new work); the classic view only for older
  hub-based projects.

Questions an instructor might ask you (original, not from the exam):

- Your company's customer data may not leave the European Union. Which deployment type fits, and why not Global
  Standard?
- A developer is the subscription's Owner, and her app's keyless call gets a 403. What's missing?
- Two teams share one Foundry resource. How do you let team A's app call models in its project but not team B's?
- Overnight, you need to classify a million documents as cheaply as possible. Which deployment type?

## Common failures

- **403 on the first call:** the Foundry User role is missing, or it was just assigned (a role assignment can take
  up to 10 minutes to take effect). Being the subscription's Owner is not enough.
- **404 "deployment does not exist":** the deployment's name in `.env` does not match, the endpoint is the
  resource's instead of the project's, or the deployment is still being created. A resource re-created under a name
  you just deleted can answer 404 for over an hour: `infra/down.sh` forgets the name so `up.sh` picks a new one.
- **`az cognitiveservices account project` not found:** the Azure CLI is older than 2.80.
- **`DefaultAzureCredential` fails:** not signed in (`az login`), or signed in to a different tenant or
  subscription than the one holding the resource.
- **Built in the portal with your own names:** put them in `.env` (`FOUNDRY_RESOURCE=...`) and set `AI103_RG` /
  `AI103_PROJECT` when you run `check.sh`.

## Cost

One Global Standard deployment billed per token: this episode's calls cost cents. `infra/down.sh` deletes the
resource group when you're done; nothing more is billed. `infra/cost.sh` shows what was billed (Cost Management lags
by up to a day).

## Microsoft's pages

- What Foundry is: https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry
- Deployment types: https://learn.microsoft.com/en-us/azure/foundry/foundry-models/concepts/deployment-types
- Creating the resource, project, deployment and role with the CLI: https://learn.microsoft.com/en-us/azure/foundry/tutorials/quickstart-create-foundry-resources
- Foundry roles (Owner has no data actions; Foundry User does): https://learn.microsoft.com/en-us/azure/foundry/concepts/rbac-foundry
- The SDK quickstart: https://learn.microsoft.com/en-us/azure/foundry/quickstarts/get-started-code
- How `DefaultAzureCredential` picks a credential: https://learn.microsoft.com/en-us/azure/developer/python/sdk/authentication/credential-chains
- Role assignments taking effect: https://learn.microsoft.com/en-us/azure/role-based-access-control/troubleshooting
- Managed identities: https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview
- Tokens: https://learn.microsoft.com/en-us/dotnet/ai/conceptual/understanding-tokens
- The study guide: https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-103
