import { state as fullState, group as fullGroup } from "./view.mjs";

// The loop and assess charts start at the filed issue: the main chart already shows how it is written.
const beforeFiling = ["idea", "advice", "interview", "draft"];
export const state = (v) => beforeFiling.includes(v.sub) ? ["No issue yet", "Written with /prd"] : fullState(v);
export const group = (v) => beforeFiling.includes(v.sub) ? "specify" : fullGroup(v);
