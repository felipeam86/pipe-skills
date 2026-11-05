---
name: review
description: Review a pull request, or a branch against its target, and end with a merge verdict and the findings, each classed by its relation to the issue. Use when the user asks "review PR N", "review this branch", "is it ready for merge?", or asks whether a change is ready to ship.
disable-model-invocation: false
---

# Review

Answer one question: is the change ready to merge? Change no file.

1. Read the diff: `gh pr diff <n>` with a pull request, `git diff <target>...<branch>` without one. Read the linked issue, which is the specification, with the tracker file that the project `CLAUDE.md` names, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`. Read every `CLAUDE.md` on the path of a changed file.
2. On a re-review, check the findings of the earlier review first. Then report only new findings: those that the fixes caused or that the earlier review missed.
3. Prove each finding with a concrete failure: the input, the state, and the wrong result. Drop a finding you cannot make concrete.
4. Class each finding by its relation to the issue. You do not decide when it gets fixed.
   - **Blocker.** The change is wrong, does not do what the issue asks, or breaks a `CLAUDE.md` rule.
   - **In scope.** A real bug or a clear improvement with the same root cause as the issue, or in the code this change touches.
   - **Out of scope.** A real problem with a different root cause, such as a bug that was already in the target branch. It never blocks the merge.

Report the verdict first, ready or not ready, with one sentence of reason. Then the blockers, each with file, line and failure, and the in-scope and out-of-scope findings, one line each. List failures only, not the checks that passed.
