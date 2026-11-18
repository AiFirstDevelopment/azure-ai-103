# AI-103 on Azure, built not memorised

The code for a hands-on course for Microsoft's exam **AI-103, Developing AI Apps and Agents on Azure**. Every skill
in Microsoft's outline is built here in a real Azure subscription, in Python, one episode at a time. Each episode is a
video on YouTube and a tag in this repository (`s4e1` to `s4e18`): check out the tag and you have exactly the code
on screen, and `transcripts/` holds what it printed when it ran.

**Independent course. Not affiliated with or endorsed by Microsoft.** The outline is Microsoft's, from the study
guide: https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/ai-103 (skills measured as
of April 16, 2026). Microsoft's free practice assessment: https://aka.ms/AI103-PA. Every video in order:
https://joelstevick.com

## The course

All eighteen episodes, in the outline's order. Each is marked out (with its video) or coming.

| # | Episode | Status | Tag | Outline skills it builds |
|---|---|---|---|---|
| 1 | What the exam covers, and your first model call in Microsoft Foundry | coming | `s4e1` | Design Azure infrastructure for AI apps and agent-based solutions<br>Choose appropriate deployment options<br>Configure model and agent deployments<br>Configure an application to connect to a Foundry project |
| 2 | Choosing the model and the Foundry service for the job | coming | `s4e2` | Choose an appropriate model for each task, including large language models (LLMs), small language models, multimodal models, and Foundry Tools<br>Choose the appropriate Foundry services for generative tasks, grounding, vector search, agent workflows, or multimodal processing<br>Choose an appropriate method for retrieval and indexing<br>Choose appropriate memory, tool, and knowledge integration services for agent solutions |
| 3 | Managed identity, keyless credentials, quotas and cost | coming | `s4e3` | Manage quotas, scaling, rate limits, and cost footprints for model and agent workloads<br>Monitor model performance, drift, safety events, and grounding quality<br>Monitor data ingestion quality, search index health, and relevance performance<br>Configure security, including managed identity, private networking, keyless credentials, and role policies<br>Integrate Foundry projects with continuous integration and continuous deployment (CI/CD) pipelines |
| 4 | Content filters, guardrails and audit | coming | `s4e4` | Configure safety filters, guardrails, risk detection, and content moderation<br>Apply responsible AI instrumentation, including evaluators, safety evaluations, and explanation tooling<br>Implement auditing through trace logging, provenance metadata, and approval workflows<br>Govern agent behavior with oversight modes, constraints, and tool-access controls |
| 5 | Deploy and call models from code with the Foundry SDK | coming | `s4e5` | Deploy and consume LLMs, small models, code models, and multimodal models<br>Integrate generative workflows into applications by using Foundry SDKs and connectors |
| 6 | RAG on Azure: an app that answers from your documents | coming | `s4e6` | Implement retrieval-augmented generation (RAG) in an application<br>Design workflows, tool-augmented flows, and multistep reasoning pipelines |
| 7 | Evaluate it: fabrications, relevance, quality, safety | coming | `s4e7` | Evaluate models and apps, including detecting fabrications, relevance, quality, and safety<br>Apply responsible AI instrumentation, including evaluators, safety evaluations, and explanation tooling |
| 8 | Your first agent: role, tools, memory | coming | `s4e8` | Define agent roles, goals, conversation-tracking approach, and tool schemas<br>Build agents that integrate retrieval, function-calling, and conversation memory |
| 9 | Agent tools: APIs, knowledge, search, custom functions | coming | `s4e9` | Integrate agent tools, including APIs, knowledge stores, search, content understanding, and custom functions<br>Connect retrieval pipelines directly to workflows and agent tools |
| 10 | Multi-agent orchestration and approval flows | coming | `s4e10` | Implement orchestrated multi-agent solutions<br>Build autonomous or semiautonomous workflows with safeguards and approval flow controls<br>Govern agent behavior with oversight modes, constraints, and tool-access controls |
| 11 | Tracing, token analytics and tuning | coming | `s4e11` | Tune generation behavior, such as prompt engineering and adjusting model parameters<br>Implement model reflection, chain-of-thought evaluations, and self-critique loops<br>Set up observability by implementing tracing, token analytics, safety signals, and latency breakdowns<br>Orchestrate multiple models, flows, or hybrid LLM and rules engines<br>Integrate monitoring into deployed agents, evaluate agent behavior, and perform error analysis |
| 12 | Generate and edit images and video | coming | `s4e12` | Implement a solution that generates images from text prompts and reference media<br>Implement a solution that generates videos from text prompts and reference media<br>Configure image-editing workflows, including inpainting, mask‑based edits, and prompt‑driven modifications<br>Implement workflows to edit generated videos<br>Select and apply appropriate generation and editing controls provided by the platform |
| 13 | Read images and video: captions, visual questions, Content Understanding | coming | `s4e13` | Build a solution that analyzes visual context by using multimodal models<br>Configure apps to produce concise or detailed captions for single or multiple images<br>Implement a solution that enables question‑answering grounded in visual evidence<br>Configure generation of alt‑text and extended image descriptions aligned to accessibility guidelines<br>Implement visual understanding by configuring Azure Content Understanding in Foundry Tools to extract visual characteristics<br>Implement video analysis workflows to process and interpret video segments<br>Configure single‑task and pro‑mode Content Understanding pipelines<br>Implement solutions that identify objects, components, or regions within images or video<br>Implement filters to classify unsafe or disallowed visual content<br>Detect and mitigate indirect prompt injection by using embedded text in images<br>Enforce visual policy rules, such as applying watermarks, flagging prohibited symbols, upholding brand usage requirements, and detecting potentially inappropriate content |
| 14 | Entities, summaries, structured JSON, sentiment, translation | coming | `s4e14` | Implement solutions to extract entities, topics, summaries, and structured JSON outputs by using generative prompting and Foundry Tools<br>Configure detection of sentiment, tone, safety issues, and sensitive content<br>Build solutions that translate text by using Azure Translator in Foundry Tools or LLM‑powered translation flows<br>Customize language model outputs for domain tasks, such as compliance summarization and domain extraction |
| 15 | Speech to text, text to speech, speech as an agent's input | coming | `s4e15` | Implement workflows to convert speech to text and text to speech for agentic interactions<br>Integrate speech as an agent modality, including custom speech models<br>Enable multimodal reasoning from audio inputs<br>Translate speech into other languages by using language models and Foundry Tools |
| 16 | Index anything: vector, hybrid and semantic search, skills, OCR | coming | `s4e16` | Ingest and index content, such as documents, images, audio, and video<br>Configure semantic search, hybrid search, and vector search for grounding<br>Implement enrichment by using custom or built-in skills for text, images, and layout<br>Configure RAG ingestion flow, including documents and using optical character recognition (OCR) |
| 17 | Extract documents: OCR, layout, fields, analyzers | coming | `s4e17` | Extract information by using multimodal pipelines that combine OCR, layout analysis, and field extraction<br>Produce clean, grounded representations to use with agents and RAG by using Content Understanding<br>Implement analyzers for generating structured or markdown outputs for downstream reasoning by using Content Understanding |
| 18 | The exam itself: the sandbox, the practice assessment, a map of what you built | coming | `s4e18` | Every objective, pointed back to the episode that built it |

## Set up

**With Claude Code** (a paid Claude plan or an Anthropic Console account): install it (https://code.claude.com/docs/en/setup),
then

```sh
git clone https://github.com/AiFirstDevelopment/azure-ai-103 && cd azure-ai-103 && git checkout s4e1
claude
```

and type `/setup`. It installs what's missing (git, Python 3.12, the course's virtual environment and packages, the
Azure CLI), signs you in to Azure, picks your subscription, checks your model quota and sets a budget, doing each
step itself where it can and handing you the few it can't: creating the Azure account and entering a card. It ends
with `sh infra/doctor.sh`, which anyone can run to see what's ready.

**By hand:** git; Python 3.12 (https://www.python.org/downloads/; Ubuntu 24.04: `apt install python3.12
python3.12-venv`); the Azure CLI 2.80 or later (https://learn.microsoft.com/cli/azure/install-azure-cli); an Azure
subscription. Use pay-as-you-go: a free trial subscription can have no quota for OpenAI models and cannot ask for more, so episode 1's model
can't be deployed on it (upgrading the free account keeps its credit). Then:

```sh
python3.12 -m venv .venv && .venv/bin/python -m pip install -r requirements.txt
az login --output none
sh infra/budget.sh 50                         # alerts to the subscription's owners; it warns, it doesn't stop anything
sh infra/doctor.sh                            # every line PASS
```

## Follow along

```sh
infra/up.sh                                   # resource group rg-ai103, a Foundry resource and project, one model
.venv/bin/python ep01_foundry_setup/first_call.py
infra/down.sh                                 # deletes everything; exits 1 if anything is left
```

No key is ever used or stored: the code signs in with your `az login` through `DefaultAzureCredential`, and
`infra/up.sh` gives your account the Foundry User role on the project. `.env` (written by `up.sh`, ignored by git)
holds names only.

## Check your work (free)

Build each episode yourself, then open [Claude Code](https://claude.com/claude-code) in this repository and type:

```
/check s4e1
```

It compares your own Azure work with what the lesson builds (each check PASS or FAIL, tied to its exam skill) and
explains anything missing: what, why the lesson needs it, and what to do next, from the episode's `LESSON.md`. It
only reads; it never changes anything in Azure (`.claude/skills/check/`). Without Claude Code, the check runs on its
own: `sh ep01_foundry_setup/check.sh`.

## The exam tutor (free)

`/tutor s4e1` checks your work the same way, then answers your questions about the episode and the exam, with the
sources of every answer: Microsoft's documentation and the course's lessons, never a guess. It needs the tutor
connected once: sign up at https://joelstevick.com/learn/ai-103-tutor and run the one-line `claude mcp add ...` the
page shows. It's free: up to 30 answers a day. You can also ask it on that page once you're signed in.

## Practice questions (free)

https://joelstevick.com/learn/ai-103-practice: 320 practice questions of our own, five for every skill in Microsoft's
study guide, each answer explained with the Microsoft Learn page behind it. Practise one skill area or a mixed set of
50 weighted like the exam, retest what you missed, and see which episode to watch for what you haven't got right yet.
Not Microsoft's questions and not the exam's; Microsoft's free practice assessment (https://aka.ms/AI103-PA) is the
next step.

## What it costs

Everything lives in one resource group, `rg-ai103`. The Foundry resource and project cost nothing on their own; a
model deployment of type Global Standard is billed per token, a few cents for an episode's runs. Each episode's README
lists what it creates and its price on the day it was built. Delete everything after a session with
`infra/down.sh`, and see the month so far with `infra/cost.sh`. Set a budget with alerts before you start (Cost
Management > Budgets in the Azure portal).

## The documents

`docs/` holds the product and policy documents of a made-up lantern shop, Howard's Lantern (the Firefly 220 and the
rest), the same documents as the series "From engineer to AI engineer"
(https://github.com/AiFirstDevelopment/engineer-to-ai-engineer), so the RAG, search and agent episodes answer from
one corpus on a second stack.

## License

MIT.
