---
name: final-state
description: Edit a document, an issue, or a comment so that it states only the settled decision. Removes the trace of what was overruled, and keeps the rationale and the plan. Use when the user says "remove any trace of the correction", "I only care about the final state", "I don't care about the past", "state it as a final decision", or after a design changes mid-document.
disable-model-invocation: false
---

# Final state

A document states the design that holds today. Read the whole document first, because a trace in one section often has a partner in another.

- Cut the decision history: "we first used X", "no longer", "unlike the previous version". A reader who arrives today does not know X.
- Keep the rationale, stated forward: why the design is what it is.
- Keep the plan.

The history goes in a commit message or a new comment, not in the document.
