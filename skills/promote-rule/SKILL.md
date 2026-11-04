---
name: promote-rule
description: Turn a correction the user just made into a durable rule, at the correct level. Use when the user corrects you, states a new principle, or says "add that rule", "record this", or "remember this". Run it as soon as the correction lands, not at the end of the session.
---

# Promote rule

A correction that is only in the conversation is lost at the end of the session. Write it down at once.

## Choose the level

Guidance sits at the level it governs. The test is scope, not convenience.

| The rule holds for... | It goes in... |
|---|---|
| every project, and every session | `~/.claude/CLAUDE.md` |
| one repository | `CLAUDE.md` at the repository root |
| one directory, and one consumer | `CLAUDE.md` in that directory |
| how the collaboration works, and it repeats | a skill in `~/.claude/skills` |
| a fact about the user, the project, or a resource | a memory file |

A rule that a second consumer would also need belongs one level up. A rule that only one tool insists on belongs one level down.

## Write it

- State the rule as a rule, in the present tense.
- Give the reason forward. Never justify it against the mistake that raised it. See `final-state`.
- Name the case that raised it only when the case makes the rule concrete, and name it as an example, not as an apology.
- Put it beside the rules it belongs with. Do not append every new rule to the end.
- Never hard-wrap the line.

## Check first

Read the file before you add to it. A rule that already exists gets sharpened, not duplicated. A rule that the new correction contradicts gets replaced, and you say so.

## Report

One line: the rule, and the file it landed in.
