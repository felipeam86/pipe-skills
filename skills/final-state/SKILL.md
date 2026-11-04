---
name: final-state
description: Edit a document, an issue, or a comment so that it states only the settled decision. Removes the trace of what was overruled, and keeps the rationale and the plan. Use when the user says "remove any trace of the correction", "I only care about the final state", "state it as a final decision", or after a design changes mid-document.
disable-model-invocation: false
---

# Final state

A document states the design that holds today. It never argues against the design it replaced.

## The difference that matters

Two things look alike and are not the same. Cut one, keep the other.

- **Decision history — cut it.** "We first used X, but that failed, so now we use Y." "Corrected from the earlier proposal." "Unlike the previous version." A reader who arrives today does not know X and does not need to.
- **Rationale — keep it.** *Why* the design is what it is, stated forward: "Y holds because a roll-up of a rank measure is not the value over the window." This is the reasoning, and it is the most valuable text in the document.
- **The plan — keep it.** An implementation plan is never noise.

## Method

1. Read the whole document first. A trace in one section often has a partner in another.
2. Find each artefact of a change: a "no longer", a "previously", a "we changed", a comparison against a rejected option, a hedge that only makes sense against a past draft.
3. Rewrite the sentence forward. State the rule, then the reason for the rule. Do not name the thing it replaced.
4. Check the parts that a rewrite breaks: a heading, a cross-reference, a numbered step, a diagram label.
5. Report what you cut, in a list. The user must be able to see that no rationale was lost.

## Where the history goes

The history is not deleted from the world, only from the document.

- For an issue: the description becomes clean, and the change goes on a new comment.
- For a pull request: the branch commit messages hold what was tried and what the validation found.
- For a chat answer: the user often *does* want the story of the mistakes. This skill governs artefacts, not conversation.
