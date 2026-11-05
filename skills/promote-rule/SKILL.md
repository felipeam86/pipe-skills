---
name: promote-rule
description: Propose to turn a lasting principle the user states into a rule, at the correct level, and write it only after the user agrees. Use when the user says "from now on", "always", "never", "add that rule", "record this", or "remember this", or states a principle that outlives the current work.
---

# Promote rule

Propose a rule only for a principle that outlives the current work. A decision for one piece of work goes in its issue or its code, not in a rule file.

Choose the level by scope:

- Every project: `~/.claude/CLAUDE.md`.
- One repository: the `CLAUDE.md` at its root.
- One repeated workflow: the skill that runs it.

Read the target file first. When a rule there already covers the principle, sharpen or replace it instead of adding one.

Propose at most one rule per turn, in one message: the exact line, the file, and why that level fits. For example: "I suggest that we promote this as a rule: <rule>. It goes in the repository `CLAUDE.md`, because it holds only for this repository. What do you think?"

Write only after a yes, in the user's words when they change yours. After a no, do not propose it again in this session. An explicit request to record a rule is the yes.

Write the rule in at most two lines, in the present tense, with its reason, next to the rules it belongs with.
