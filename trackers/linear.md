# Linear tracker

The project `CLAUDE.md` names the team and the scope of the work, in one of two forms, which the word after `Linear` tells apart:

- `- Track work in the Linear project **Acme Web** of the team `ACM`.` One project holds the work, and an outcome is a milestone of that project.
- `- Track work in the Linear initiative **Web Platform** of the team `ACM`.` The projects directly under the initiative hold the work, not the projects of its child initiatives, and an outcome is one of those projects. An issue gets no milestone in this form, because the user sets milestones by hand.

Use the tools of the Linear MCP server; load them with ToolSearch first. The state parameter of `save_issue` is `state`, never `status`. When no Linear MCP tool is found, or the team has no state that a step needs, stop and name `pipe-skills:setup`.

## Identifier

`ACM-42`. A commit message, the pull request title, and the squash title start with it. The worktree name is the identifier in lowercase, `acm-42`.

## Operations

- **Read an issue.** `get_issue` with `includeRelations: true`, and `list_comments` with `orderBy: "createdAt"`.
- **File an issue.** `save_issue` with `team`, `project` (the project of the tracker line, or the outcome in the initiative form), `milestone` (its name, in the project form only), `assignee: "me"`, `state`, `priority` (1 `Urgent`, 2 `High`, 3 `Medium`, 4 `Low`), `blockedBy: ["ACM-40"]`, and `parentId` (the parent identifier) on a child of a parent issue. Give the identifier and the URL. When Linear says the project is not in the team, read the team of the project with `list_projects`.
- **Edit the description.** `save_issue` with `id` and `patch: [{op: "replace", old_string, new_string}]`, or with `description` for a full rewrite. When the patch fails, read the issue again and copy the text exactly.
- **Comment.** `save_comment` with `issueId` and `body`.
- **Set a state.** `save_issue` with `id` and `state`: `Todo`, `In Progress`, `In Review`, `Backlog`, or `Done`.
- **Cancel.** `state: "Canceled"`. For a duplicate, `duplicateOf: "ACM-40"` and `state: "Duplicate"`: Linear refuses the state without the relation.
- **File an outcome.** In the project form, `save_milestone` with `project`, `name`, `description`, and `targetDate: "YYYY-MM-DD"`. In the initiative form, `save_project` with `name`, `description`, `addTeams: ["ACM"]`, `addInitiatives: ["Web Platform"]`, `lead` (the user that `whoami` gives), `state: "planned"`, and `targetDate: "YYYY-MM-DD"`, then confirm that **List the outcomes** finds it.
- **List the outcomes.** In the project form, `list_milestones` with `project`. In the initiative form, `list_projects` with `initiative`, `limit: 50`, and `fields` that hold `name`, `description`, `status`, `targetDate`, and `initiatives`, and read the next page while the result gives a cursor. Keep a project when its `initiatives` hold the initiative itself, not only a child initiative, and when its `status.type` is `planned` or `started`, because the status names differ in each team.
- **Name the branch.** The `gitBranchName` of the issue.
- **Link the pull request.** `save_issue` with `id` and `links: [{url: "<pull request URL>", title: "PR #<n>: <title>"}]`. `create_attachment` uploads a file; do not use it for a link.
- **Link a follow-up.** `relatedTo: ["ACM-42"]` on the new issue, and the `project` of the closed issue, which `get_issue` gives.
- **Find the blockers.** The `relations.blockedBy` of `get_issue`, which holds no state: read each blocker with `get_issue`. A blocker is open when its state is not `Done`, `Canceled`, or `Duplicate`.
- **List the queue.** `list_issues` with `project` (in the initiative form, the outcome that the user names), `state: "Todo"`, `limit: 250`, and `fields` that hold `priority` and `createdAt`. Leave out a parent issue that has children: its children are the work. Order by priority: `Urgent`, `High`, `Medium`, `Low`, then `No priority` (0), and the oldest first within one priority.
- **Close.** Set the state `Done`.
