---
name: setup
description: Make a project ready for the pipe-skills pipeline on Linear or GitHub Issues. Checks the tracker, the team and its project or initiative, or the GitHub project, its states and its priority, fixes what is missing after the user's go, and writes the tracker line in the project CLAUDE.md. Use only when the user runs /pipe-skills:setup or says "set up pipe-skills in this project" or "connect this repository to Linear" or "to a GitHub project".
disable-model-invocation: true
---

# Set up a project

Make the project ready for `pipe-skills:prd`, `pipe-skills:implement`, `pipe-skills:ship` and `pipe-skills:autonomous-loop`, and change nothing else. Running it again on a ready project changes nothing.

1. Read the `CLAUDE.md` at the root of the repository. When it names a tracker, show the tracker line and ask the user to keep it or to change the scope; on keep, take that tracker, team, and project or initiative. On change, or when it names no tracker, ask the user: Linear or GitHub Issues, and which team and project, or team and initiative, or which GitHub project and owner. Offer the projects or initiatives that exist, and a new one as the last option. On change, the map line that exists does not apply to the new scope.
2. Read the tracker file, `${CLAUDE_PLUGIN_ROOT}/trackers/linear.md` or `${CLAUDE_PLUGIN_ROOT}/trackers/github.md`, and its setup file, `${CLAUDE_SKILL_DIR}/linear.md` or `${CLAUDE_SKILL_DIR}/github.md`. Check each item of the **Requirements** of the setup file, read-only.
3. Report one line per requirement: ready, or missing with the fix. Name what the user must do by hand, and what you can do.
4. After the user's go, run the fixes of the **Setup** section of the setup file. When a state has no option of its own, or the scope changed, the Setup maps every state again as if no map line exists; on keep, the entry of the old map line is the default answer, unless another state already takes that option. Then check the requirements again.
5. Write the tracker line in the project `CLAUDE.md` in place of the tracker line that exists, if any. On change, or when the Setup mapped the states again, write the map line that the Setup made in place of the map line that exists, or remove the old line when it made none. Write them in the form that the tracker file shows, next to the rules they belong with, and with the user's names. Do not commit them: say that they are ready to commit.

End with the state of each requirement and the first command to run, for example `/pipe-skills:prd`.
