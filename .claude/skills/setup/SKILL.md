---
name: setup
description: Set up this machine for the AI-103 course - installs and checks git, Python 3.12, the course's virtual environment and packages, and the Azure CLI, signs you in to Azure, picks your subscription, checks your model quota and sets a budget, doing each step itself where it can and handing you the few it can't. Use when you type /setup, or say "set me up", "get me ready for the course" or "what do I need to install".
---

# setup

You set up the learner's machine for the AI-103 course in this repository, one step at a time, doing each step
yourself where you can. Say briefly what each step is for, run it, check it worked, then move on. Skip whatever is
already there. `sh infra/doctor.sh` (read-only) is the check: run it first to see what's missing, and last to show
everything passes.

## Ground rules

- **Commands are shown before they run.** In Claude Code's Manual permission mode the learner approves each one;
  say so once at the start.
- **sudo can't ask for a password here.** When a command needs sudo, show it and ask the learner to type it with the
  `!` prefix (for example `! sudo apt-get install -y python3.12 python3.12-venv`), then check. If `id -u` prints 0,
  drop `sudo`.
- **Each command runs in a fresh shell**: an activated venv or an `export` doesn't carry over. Always call
  `.venv/bin/python` (Windows: `.venv\Scripts\python.exe`) directly.
- **Never**: create an Azure account or subscription, enter payment details, ask for or accept a password or key in
  the chat, or print the account's email address or a token. Use `--output none` or `--query` on every `az` command
  that would show the signed-in user.
- **The system decides the commands.** Find it first: `uname -s` (Darwin, Linux) or Windows; on Linux read
  `/etc/os-release`; WSL shows "microsoft" in `uname -r`.

## Steps

1. **What's there.** `sh infra/doctor.sh` (on Windows without Git Bash, run the checks one by one in PowerShell).
   Tell the learner which steps below are needed; do only those.

2. **Git.**
   - macOS: `xcode-select --install` opens a dialog and returns at once; ask the learner to click Install, then poll
     `xcode-select -p` until it succeeds. Or `brew install git` if Homebrew is there.
   - Windows: `winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements`. It isn't on
     PATH in this session until the terminal restarts: use `"C:\Program Files\Git\cmd\git.exe"`, or ask the learner
     to restart the terminal and run `claude --continue`.
   - Ubuntu or Debian: `sudo apt-get update && sudo apt-get install -y git` (via `!` if sudo needs a password).

3. **Python 3.12.**
   - macOS: `brew install python@3.12`; without Homebrew, give https://www.python.org/downloads/ (the 3.12 macOS
     installer), wait for the learner, then check `python3.12 --version`.
   - Windows: `winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements`,
     then use `py -3.12` (there is no `python3.12` command on Windows).
   - Ubuntu 24.04: `sudo apt-get install -y python3.12 python3.12-venv` (the venv module is a separate package).
     Another release without a `python3.12` package: say so plainly, and offer `uv python install 3.12` (install uv
     from https://docs.astral.sh/uv/) or the deadsnakes PPA on Ubuntu.

4. **The course's environment.** In the repository folder:
   `python3.12 -m venv .venv` (Windows: `py -3.12 -m venv .venv`), then
   `.venv/bin/python -m pip install -r requirements.txt`, then check with
   `.venv/bin/python -c "import azure.ai.projects, azure.identity, openai"`. The packages are pinned to the versions
   the course was recorded with.

5. **The Azure CLI, 2.80 or later.** Check `az version --query '"azure-cli"' -o tsv`.
   - macOS: `brew install azure-cli` (or `brew upgrade azure-cli`).
   - Windows: `winget install -e --id Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements`
     (a UAC prompt appears; tell the learner). Then `"C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"`
     until the terminal restarts.
   - Ubuntu or Debian: Microsoft's script, run by the learner because it uses sudo:
     `! curl -fsSL 'https://azurecliprod.blob.core.windows.net/$root/deb_install.sh' | sudo bash` (without `sudo` as
     root; needs `curl`; Ubuntu 22.04, 24.04 and 26.04, Debian 11 and 12).
   - Older than 2.80: `az upgrade --yes` (or the package manager's upgrade).

6. **Sign in.** First `az config set core.login_experience_v2=off` (so login doesn't stop to ask for a subscription).
   Then ask the learner to type `! az login --output none`: the browser opens and they pick their account. In a
   container, over SSH or in WSL: `! az login --use-device-code --output none`, and they enter the code shown at
   the address shown. Check with `az account show --query name -o tsv`.

7. **The subscription.**
   - None: you can't create one. Explain: an Azure account with a pay-as-you-go subscription
     (https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go). The free account
     (https://azure.microsoft.com/free) gives 200 dollars of credit for 30 days, but a free trial subscription gets
     no quota for OpenAI models, so episode 1's model can't be deployed on it; upgrading the free account to
     pay-as-you-go keeps the credit. Wait for the learner, then sign in again and check.
   - Several: list them with `az account list --query "[].{name:name, id:id, state:state}" -o table`, ask which one
     the course should use, then `az account set --subscription <id>`.
   - Check the model quota episode 1 needs:
     `az cognitiveservices usage list -l eastus2 --query "[?name.value=='OpenAI.GlobalStandard.gpt-5-mini'].limit | [0]" -o tsv`.
     0 or nothing: explain the free trial limit above.

8. **A budget.** Ask the monthly amount (the course uses 50). Run `sh infra/budget.sh <amount>`: alerts go by email
   to the subscription's owners at 80% spent and at a 100% forecast. Say plainly: a budget warns, it doesn't stop
   anything; cost data arrives up to a day late; allow azure-noreply@microsoft.com so alerts aren't junked; what
   stops the billing is deleting what you made, which every episode does with `infra/down.sh`. If it fails on a
   brand-new subscription (Cost Management can take up to 48 hours) or an offer without budgets (Azure for
   Students, Sponsorship), say so, give the portal path (Subscriptions, your subscription, Budgets) and move on.

9. **VS Code's Python extension**, if VS Code is installed: `code --install-extension ms-python.python`. No `code`
   command on macOS often only means it isn't on PATH (VS Code: "Shell Command: Install 'code' command in PATH"):
   mention it and move on.

10. **Done.** `sh infra/doctor.sh`: every line should be PASS. Then point them to episode 1: `infra/up.sh`,
    `.venv/bin/python ep01_foundry_setup/first_call.py`, and `/check s4e1` to check their work.
