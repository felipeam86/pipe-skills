# GitHub tracker

The project `CLAUDE.md` names the GitHub project that holds the states: `- Track work in GitHub Issues, on the GitHub project **Roadmap** of `acme`.` The issues live in the repository of the current checkout, `<repository>` = `gh repo view --json nameWithOwner --jq .nameWithOwner`, and `gh api repos/{owner}/{repo}/...` fills that repository in by itself. `<owner>` is the owner of the project, which can differ from the owner of the repository. When `gh project` fails for the `project` scope, stop and name `pipe-skills:setup`.

## Identifier

`#42` in prose and in the pull request body, and `<repository owner>/<repository>#42`, with the owner of that repository, for an issue of another repository. A commit message, the pull request title, and the squash title start with `GH-42`, because git drops a message line that starts with `#`, and GitHub links `GH-42` to the issue. The worktree name is `gh-42`.

## Project fields

Look these up once per session, and keep the IDs:

- The project number and node ID: `gh project list --owner <owner> --limit 1000 --format json`, matched by title, because an organization holds more projects than the first page.
- The `Status` field and its option IDs, and the `Priority` field when the project has one: `gh project field-list <number> --owner <owner> --format json`.

The states are the options of `Status`, with the names of the GitHub project templates: `Todo` is `Ready`, `In Progress` is `In progress`, `In Review` is `In review`, and `Backlog` and `Done` keep their names. A project with its own lanes maps a state to an existing option in one more line of the project `CLAUDE.md`: `- The pipeline states map to the Status options: `Todo` = `To Do`, `In Progress` = `Doing`, `In Review` = `Review`.` Use the mapped name where the line gives one. When an option is missing, stop and name `pipe-skills:setup`.

The priority is the `Priority` field: its options in their order, the first one the highest, whatever their names.

## Operations

- **Read an issue.** `gh issue view <n> --json number,title,body,state,url,comments,milestone,projectItems`. The state is `.projectItems[].status.name` of the item in the project.
- **File an issue.** `gh issue create --title <title> --body-file <file> --assignee @me --milestone <name>`, then set the state, set `Priority` when the project has the field, and add each "blocked by" relation. Read the state back, because the `Item added to project` workflow of a project can set its own state after yours. Give the number and the URL.
- **Edit the description.** `gh issue edit <n> --body-file <file>`.
- **Comment.** `gh issue comment <n> --body-file <file>`.
- **Set a state.** Add the issue to the project, which returns its item ID and keeps its state when it is already there: `gh project item-add <number> --owner <owner> --url <issue-url> --format json --jq .id`. Then `gh project item-edit --id <item> --project-id <project-node-id> --field-id <status-field-id> --single-select-option-id <option-id>`.
- **Add a sub-issue to a parent issue.** `gh api graphql -f query='mutation($a:ID!,$b:ID!){addSubIssue(input:{issueId:$a,subIssueId:$b}){clientMutationId}}' -f a=<parent-id> -f b=<child-id>`, with the node IDs.
- **Add a "blocked by" relation.** Take the node IDs with `gh issue view <n> --json id --jq .id`, then `gh api graphql -f query='mutation($a:ID!,$b:ID!){addBlockedBy(input:{issueId:$a,blockingIssueId:$b}){clientMutationId}}' -f a=<blocked-id> -f b=<blocker-id>`.
- **File an outcome.** An outcome is a milestone of the repository: `gh api repos/{owner}/{repo}/milestones -f title=<title> -f description=<sections> -f due_on=<YYYY-MM-DD>T00:00:00Z`.
- **List the outcomes.** `gh api repos/{owner}/{repo}/milestones --jq '.[] | {title, description, due_on}'`, which gives the open milestones.
- **Name the branch.** `<n>-<title in kebab case>`, at most 50 characters. Create it on the remote with `gh issue develop <n> --name <branch> --base <target>`, which also links it to the issue and fetches it. `--base` needs the target branch on the remote. When `gh issue develop <n> --list` already shows a branch, use it: `git fetch origin <branch>`.
- **Link the pull request.** The pull request body starts with `Part of #<n>.` Do not use a closing keyword: it closes the issue only on a merge into the default branch, and `ship` closes the issue.
- **Link a follow-up.** The first line of the new issue names the closed issue as `#<n>`, which GitHub links both ways.
- **Find the blockers.** `gh api repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by --jq '[.[] | select(.state == "open") | .number]'`.
- **List the queue.** `gh project item-list <number> --owner <owner> --query 'is:issue is:open status:Ready repo:<repository>' --limit 500 --format json`, with the option name of `Todo`, in double quotes when it holds a space. Each item holds `content.number`, and one key per field in lowercase, such as `status` and `priority`, when the field has a value. Order by the `Priority` field, in the order of its options in `field-list`, then the items with no priority. Within one priority, the lowest issue number first, because it is the oldest. Without a `Priority` field, order by issue number only. Leave out a parent issue, which has `gh api repos/{owner}/{repo}/issues/<n> --jq .sub_issues_summary.total` above 0: its sub-issues are the work.
- **Cancel.** `gh issue close <n> --reason "not planned"`, or `--duplicate-of <m>` for a duplicate.
- **Close.** `gh issue close <n> --reason completed`, then set the state `Done`. Post a comment with `gh issue comment`, never with `gh issue close --comment`: the `Auto-close issue` workflow of a project closes an issue when its state becomes `Done`, and `gh issue close` on a closed issue drops its comment.
