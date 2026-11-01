---
name: pr-quiz
description: Before I open a PR, explain my branch's changes like a short textbook (diffs interleaved with context, tradeoffs and key decisions), then quiz me with five medium questions. Use ONLY when I ask for a PR quiz or to check I understand my changes.
disable-model-invocation: true
---

Goal: I only send code for review if I understand it. Idea from Geoffrey Litt, "Understanding is the new bottleneck": the quiz is a speed regulator, so I move at the speed of understanding, not just correctness.

## 1. Find the changes

- Diff the current branch against its base (`git merge-base HEAD origin/main`, or the base I name). Include uncommitted changes if there are any, and say so.
- If the diff is very large, list the files and ask which part to cover first.

## 2. Explain

Write a short explainer in the chat, in this order:

1. **What and why**: two or three sentences on what the change does and the problem it solves.
2. **Walkthrough**: the important hunks in a sensible reading order (not file order). For each one, show the relevant diff lines, then explain them in context: what the surrounding code does and why this change was needed.
3. **Key decisions and tradeoffs**: the choices made, the alternatives, and what we give up. Flag anything risky or surprising.
4. **What is not covered**: missing tests, edge cases, follow-ups.

Explain; don't review. Fixes go in a separate list at the end, only if something looks wrong.

## 3. Quiz

- Five questions, medium difficulty, about *this* change: why, how it behaves, what would break, tradeoffs. No trivia.
- Ask them one at a time and wait for my answer.
- After each answer, say right / partly / wrong, and give the correct answer in one or two lines with the file and line it comes from.

## 4. Verdict

- **Pass** (4/5 or more): say I'm ready to open the PR.
- **Not yet**: list what I got wrong and the files to reread, and offer another round on those parts.

Never open, push or comment on the PR yourself. This skill only reads the code and talks to me.
