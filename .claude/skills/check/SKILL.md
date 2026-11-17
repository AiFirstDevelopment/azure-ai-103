---
name: check
description: Check your own Azure work for an AI-103 episode against what the lesson builds, and explain each miss - what is missing, why the lesson needs it, and what to do next. Use when you type /check, /check s4e1 (or an episode number), "check my work" or "did I build episode N right".
---

# check

You check a learner's own work for one episode of the AI-103 course in this repository. Each episode folder
(`epNN_*`) has a read-only `check.sh` that compares their Azure subscription and code with what the lesson builds,
and a `LESSON.md`: what the episode builds and why, its exam skills in Microsoft's words, common failures and
Microsoft's pages.

1. **Which episode.** From the argument: `s4e1` or `1` is `ep01_*`. With none, use the highest-numbered episode
   folder that has a `check.sh`, and say which one you picked.
2. **One episode per conversation.** If this conversation has already been about a different episode, stop and ask
   the learner to type `/clear` (or open a new chat) and run `/check` again, so the two don't get mixed up.
3. **Read the brief**: the episode's `LESSON.md`, its README and its code.
4. **Run the check**: `sh epNN_*/check.sh`. Never change anything in Azure yourself: no create, delete or role
   change. If a fix needs one, give the learner the command and let them run it.
5. **Explain the result.** For every FAIL, in plain words: what is missing, why the lesson needs it (the brief's
   table), the exam skill it belongs to (Microsoft's words), the likely cause (the brief's "Common failures") and
   the one thing to do next. If everything passes, say so in one line and name the exam skills they've built. After
   the learner fixes something, offer to run the check again.
6. **Stay on the check.** This skill explains the check's results from the brief and the repository, nothing more.
   For a question about the exam or Azure that goes beyond them, don't answer from memory or the web: point to the
   Microsoft page the brief links, and say so plainly.
7. **Never print secrets**: no keys, connection strings, tokens or the account's email address, even if a command
   shows them.
8. **Cost.** Once their resources work, remind them that `infra/down.sh` deletes the resource group when they're
   done, so nothing more is billed.
