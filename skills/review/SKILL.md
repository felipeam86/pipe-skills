---
name: review
description: Review a pull request, or a branch against its target, and end with a merge verdict, plus the findings that are worth a fix. Use when the user asks "review PR N", "review this branch", "is it ready for merge?", or asks whether a change is ready to ship.
disable-model-invocation: false
---

# Review PR

A review that answers one question: is this ready for merge?

## Method

1. **Read the diff and the intent.** With a pull request: `gh pr view <n>` and `gh pr diff <n>`. With a branch only: `git diff <target>...<branch>`. Read the linked issue, in Linear or wherever the project tracks its work. The issue is the specification, so a change that does not match it is a finding.
2. **Read the rules that govern the code.** Every `CLAUDE.md` on the path of a changed file. A violation of a stated project principle is a finding, and it is a strong one.
3. **Find, then verify.** For each finding, try to prove it wrong before you report it. Give the concrete failure: the input, the state, and the wrong result. Drop a finding you cannot make concrete.
4. **Grade each finding.**
   - **Blocker** — the change is wrong, or it breaks a stated principle.
   - **Defer** — a real bug, or a feature of high value, that does not have to block the merge. The author fixes it in the same branch by default.
   - **Note** — anything else: an edge case that no real data and no likely input reaches, a cosmetic choice, a matter of wording or taste. Say so, and do not push it.

## Report

Give this shape, and nothing more:

- **Verdict**: ready for merge, or not ready. One sentence for the reason.
- **Blockers**: each with file, line, and the failure it causes.
- **Defer**: each in one line, with the failure it causes or the value it adds.
- **Notes**: at most three lines.

## Rules

- The verdict comes first. Do not make the reader search for it.
- Keep the defer list short. Each item costs a fix or an issue, so a finding that is not a real bug or a feature of high value is a note.
- Be ready to be wrong. If the user asks "are you sure?", re-derive the finding from the code. Do not defend it, and do not fold to the question either. Answer with the evidence.
- Do not fix anything during a review. The review ends with the report.
- Say plainly when you found nothing. A short review is a valid result.
