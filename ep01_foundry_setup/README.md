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

## Talk to it

```sh
.venv/bin/python ep01_foundry_setup/chat.py
```

The episode opens on this: the same connection in a loop. Type a question and watch the answer arrive as it is
written; an empty line quits. It streams (`stream=True`, printing each `response.output_text.delta` with
`flush=True`, the typewriter effect) and shows a "Thinking..." spinner while the model reasons before its first words.

`ep01_foundry_setup/check_keyless.sh` removes your Foundry User role, sets key variables, and shows the same call
refused; then it puts the role back.

Check your work: `/check s4e1` in Claude Code runs the check and explains anything missing (`LESSON.md` is its
brief). Without Claude Code: `sh ep01_foundry_setup/check.sh`. Built by hand in the portal instead? Put your resource's name in `.env` as `FOUNDRY_RESOURCE=...` first.

Afterwards: `infra/down.sh`.
