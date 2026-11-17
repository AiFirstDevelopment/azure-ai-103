# Episode 1: your first model call in Microsoft Foundry

Outline skills: Design Azure infrastructure for AI apps and agent-based solutions; Choose appropriate deployment
options; Configure model and agent deployments; Configure an application to connect to a Foundry project.

## What it shows

`infra/up.sh` creates a resource group, a Foundry resource with project management on, a project, a Global Standard
model deployment and the Foundry User role for you on the project. `first_call.py` then calls the model through the
Foundry SDK with `DefaultAzureCredential`: your `az login` is the credential, and no key is read.

## Run it

```sh
az login
infra/up.sh
.venv/bin/python ep01_foundry_setup/first_call.py
```

You should see the question, the model's answer, and the token counts. The run recorded for the video is
`transcripts/s4e1-foundry-setup.txt`.

`ep01_foundry_setup/check_keyless.sh` removes your Foundry User role, sets key variables, and shows the same call
refused; then it puts the role back.

Your tutor: `/tutor s4e1` in Claude Code checks your work, then answers your questions about this episode and the
exam (`LESSON.md` is its brief). Without Claude Code: `sh ep01_foundry_setup/check.sh`. Built by hand in the portal instead? Put your resource's name in `.env` as `FOUNDRY_RESOURCE=...` first.

Afterwards: `infra/down.sh`.
