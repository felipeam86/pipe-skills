const where = {
  idea: ["No issue yet", "Idea"],
  advice: ["No issue yet", "Getting an opinion"],
  interview: ["No issue yet", "Being interviewed"],
  draft: ["No issue yet", "Draft shown to you"],
  waiting: ["Todo", "Waiting"],
  backlog: ["Backlog", "Judged not worth it"],
  building: ["In Progress", "Building in steps"],
  replanning: ["In Progress", "Rewriting the plan"],
  reviewing: ["In Progress", "Under review"],
  stuck: ["In Progress", "Stopped, Claude asks you"],
  gate: ["In Review", "At the merge gate"],
  done: ["Done", "Merged and closed"],
  closed: ["Done", "Closed, the code already does it"],
  canceled: ["Canceled", "Canceled"],
  skipped: ["Todo", "Skipped, verdict in the loop report"],
};
export const state = (v) => {
  if (v.sub === "stuck" && v.warned) return ["In Progress", "Warned the review is not clean"];
  if (v.sub === "verdicts") return [v.status, "Verdicts shown to you"];
  return where[v.sub];
};

const phase = {
  idea: "talk", advice: "talk", interview: "talk", draft: "specify",
  waiting: "specify", backlog: "specify", skipped: "specify",
  building: "build", replanning: "build", stuck: "build",
  reviewing: "review", gate: "review", done: "ship",
  verdicts: "sweep", closed: "sweep", canceled: "sweep",
};
export const group = (v) => phase[v.sub];
export const colors = { talk: "purple", specify: "blue", build: "orange", review: "yellow", ship: "teal", sweep: "tan" };
export const title = "One piece of work, from idea to merge";

const labels = {
  YouAskForAdvice: "you ask for an opinion (/advise)",
  YouAskForAnInterview: "you ask for an interview (/interview)",
  YouRunPrd: "you run /prd",
  YouGiveTheGoToFile: "you give the go, Claude files the issue",
  YouRunImplement: "you run /implement",
  TheLoopTakesIt: "/autonomous-loop takes it, /assess says current",
  TheLoopSkipsAStaleIssue: "/autonomous-loop skips it, /assess says not current",
  TheSubagentJudgesItNotWorthIt: "the subagent judges it not worth its cost",
  YouMoveItBackToTodo: "you move it back to Todo",
  ADiscoveryChangesThePlan: "a discovery changes the plan",
  TheIssueIsRewritten: "the issue is rewritten (/final-state)",
  TheStepsAreCommitted: "the steps are committed, a fresh reviewer starts",
  TheReviewFindsWorkToFix: "a finding is worth another round",
  TheFindingsComeBackInOneArea: "findings come back in one area, Claude changes its method",
  TheReviewIsClean: "no finding is worth another round",
  TheReviewDoesNotConverge: "3 rounds pass, or the method needs you, Claude asks you",
  YouAnswerAndTheWorkContinues: "you answer, the work continues",
  YouRunShipAndGiveTheGo: "you run /ship and give the go",
  TheSubagentShipsIt: "the subagent ships it [in /autonomous-loop]",
  ClaudeWarnsTheReviewIsNotClean: "you run /ship",
  YouGiveTheGoAnyway: "you give the go anyway",
  YouRunAssessOrSweep: "you run /assess or /sweep",
  YouApproveCurrentOrDrifted: "you approve current or drifted",
  YouApproveDone: "you approve done",
  YouApproveSupersededOrObsolete: "you approve superseded or obsolete",
  YouRejectTheVerdict: "you reject it",
  Finished: null,
};
export const step = (action) => labels[action];
