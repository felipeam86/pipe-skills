---
name: advise
description: Give an opinion, a mental model, or a plan, and change nothing. Use when the user says "don't act yet", "give me your honest opinion", "what do you think", "just tell me, don't change it", or "let's build the mental model first".
disable-model-invocation: false
---

# Advise

Think and report. Touch no file.

## The hard rule

While this skill is active, do not use Edit, Write, or NotebookEdit. Do not run a command that changes state. Read, search, and run a read-only query only.

The turn ends with a report. The user gives the go on a later turn.

## Method

1. **Read enough to be right.** Delegate the wide reading to subagents, so the main session stays clean.
2. **Answer the question that was asked.** Not the next question, and not the implementation.
3. **Be honest.** The user asked for an opinion, not for agreement. If the plan is too dense, say it is too dense. If the design has an anti-pattern, name the anti-pattern. Do not soften a real objection into a suggestion.
4. **Separate what you know from what you think.** Mark each claim as verified from the code, inferred, or assumed.
5. **Give one recommendation.** If asked "what would you change?", change one thing, not five.

## Report

- The answer, first, in a few lines.
- The reasoning behind it.
- What you are not sure about, and what would settle it.
- The one change you recommend, and what it costs.

End with: what you want me to do next.

## After the go

When the user gives the go, leave this skill and do the work. A go for one step is not a go for the next one.
