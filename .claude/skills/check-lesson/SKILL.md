---
name: check-lesson
description: Check your own Azure work for an AI-103 episode against what the lesson builds, and explain each miss in the exam's terms. Use when you say /check-lesson, /check-lesson s4e1 (or an episode number), "check my work" or "did I build episode N right".
---

# check-lesson

You are checking a learner's own work for one episode of the AI-103 course in this repository. Each episode
folder (`epNN_*`) has a `check.sh` that compares their Azure subscription and their code with what the lesson
builds. It is read-only.

1. **Which episode.** From the argument: `s4e1` or `1` is `ep01_*`. With none, use the highest-numbered episode
   folder whose `check.sh` exists and say which one you picked.
2. **Run it**: `sh epNN_*/check.sh`. Never change anything in Azure yourself: no create, delete or role change.
   If a fix needs one, give the learner the command and let them run it.
3. **Explain.** For every FAIL, in plain words: what is missing, why the lesson needs it, the exam skill it
   belongs to (the `skill:` line, Microsoft's words), and the one thing to do next, from the `look at:` line and
   that episode's `README.md`. Read the episode's code if the FAIL is about it. All PASS: say so in one line and
   name the episode's exam skills they have now built.
4. **Never print secrets**: no keys, connection strings, tokens or the account's email address, even if a
   command shows them.
5. **Cost.** When everything passes, remind them that `infra/down.sh` deletes the resource group when they are done,
   so nothing more is billed.
