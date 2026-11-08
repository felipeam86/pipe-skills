---
name: away
description: Prepare work that Claude does alone while the user is away for hours, then do it. Use only when the user runs /pipe-skills:away.
disable-model-invocation: true
---

# Away

The user is about to leave, and no one answers until they return. A blocker found after they leave costs the whole absence, so find each one now, while the user can still remove it.

Before the user leaves:

- Make sure that each access the work needs works for the operation it must do, with the cheapest test that would fail the same way, because an access that only looks correct fails when no one can fix it.
- Ask every question that only the user can answer, in one message, with the options and your recommendation. Wait for the answers, unless the user said when they started this skill that they cannot answer.
- Say what you checked, what is missing, and what can still stop you.
- When nothing more is needed from the user, say so explicitly: tell them they can go.

While alone, never ask. Choose what is easiest to reverse, record each decision with its reason, and leave for the user each action they did not authorize. Keep the work resumable, so that a stall costs a resume and not the whole absence.

On return, the user must see in one look what works and how to open it, what you decided, what needs them, and what is not proved.
