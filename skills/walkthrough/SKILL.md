---
name: walkthrough
description: Build one interactive HTML report that explains a subject or prepares a decision, and composes a reply that the user pastes back into the session. Use only when the user asks for it, for example "walkthrough", "make an HTML report of this", "explain this in an HTML report", or "build me a report to decide this". Do not offer it unasked.
disable-model-invocation: false
---

# Walkthrough

The user asks for a walkthrough when the chat cannot carry the subject: the answer is too dense, the user is tired, or the subject is new to the user. The report makes the subject easy to understand, or the decision easy to take, and gives the user a way to answer.

- Simple is better than complex. The first screen says what the report is about, gives the short answer, and says what needs the user. Keep only what the purpose needs.
- Use progressive disclosure: start from the overview, and let the user open each part for its detail, then the detail of that detail. The depth is there when the user asks for it, and never in the way.
- Give a hover to each concept, issue, and decision that the report names: the meaning of the concept, the title and the state of the issue, the question of the decision. The user never has to remember what an ID stands for.
- Make it an immersive experience, with the interactions that help the user understand or decide, such as a diagram to click through, a flow to step through, options side by side, or a toggle that shows what changes. An interaction replaces text, and does not add to it.
- When the decision is about the order, the dependencies, or the grouping of steps or issues, give a canvas with one box per item. The user can draw and remove the dependency arrows, edit the text, set the priority, and assign a project, a milestone, or an initiative, from the values in the tracker.
- Give a way to answer. The user can comment on any part, and on each decision choose an option or write another one. The report composes one reply in markdown that holds only what the user changed or wrote, each item named by its ID, and copies it for the user to paste into the session. The browser keeps the work of the user, so that a reload loses nothing.
- The page never writes to the tracker or to a file: it only composes the reply, and the session applies it. Other editable tools are out of scope, unless the user asks for one.

Put the report in `reports/` at the root of the workspace, as one self-contained file. Check in a browser that it works, then open it for the user. When a decision in the session changes what the report says, rewrite the report at its final state with `pipe-skills:final-state`, without a request, and open it again.
