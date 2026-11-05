---- MODULE Lifecycle ----
\* The lifecycle of one piece of work through the pipe-skills pipeline.
\* status is the state of the issue in the tracker, sub is where the work is inside it.
VARIABLES status, sub, mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged
vars == <<status, sub, mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>
rest == <<mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>

Init ==
    /\ status = "none" /\ sub = "idea" /\ mode = "none"
    /\ prdGo = FALSE /\ filed = FALSE /\ reviewClean = FALSE
    /\ warned = FALSE /\ shipGo = FALSE /\ merged = FALSE /\ followups = FALSE
    /\ isFollowup \in BOOLEAN
    /\ versionBumped = FALSE
    /\ sweepGo = FALSE /\ sweepChanged = FALSE

Move(st, s) == status' = st /\ sub' = s

YouAskForAdvice ==
    /\ sub = "idea" /\ Move("none", "advice")
    /\ UNCHANGED rest

YouAskForAnInterview ==
    /\ sub \in {"idea", "advice"} /\ Move("none", "interview")
    /\ UNCHANGED rest

YouRunPrd ==
    /\ sub \in {"idea", "advice", "interview"} /\ Move("none", "draft")
    /\ UNCHANGED rest

YouGiveTheGoToFile ==
    /\ sub = "draft" /\ Move("Todo", "waiting")
    /\ prdGo' = TRUE /\ filed' = TRUE
    /\ UNCHANGED <<mode, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>

YouRunImplement ==
    /\ sub \in {"waiting", "backlog", "skipped"} /\ Move("In Progress", "building")
    /\ mode' = "manual"
    /\ UNCHANGED <<prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>

TheLoopTakesIt ==
    /\ sub \in {"waiting", "skipped"} /\ Move("In Progress", "building")
    /\ mode' = "auto"
    /\ UNCHANGED <<prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>

\* The loop has no user to approve a verdict, so it changes nothing on a stale issue.
TheLoopSkipsAStaleIssue ==
    /\ sub = "waiting" /\ sub' = "skipped" /\ UNCHANGED status
    /\ UNCHANGED rest

TheSubagentJudgesItNotWorthIt ==
    /\ sub \in {"waiting", "skipped"} /\ Move("Backlog", "backlog")
    /\ UNCHANGED rest

YouMoveItBackToTodo ==
    /\ sub = "backlog" /\ Move("Todo", "waiting")
    /\ UNCHANGED rest

ADiscoveryChangesThePlan ==
    /\ sub = "building" /\ Move("In Progress", "replanning")
    /\ UNCHANGED rest

TheIssueIsRewritten ==
    /\ sub = "replanning" /\ Move("In Progress", "building")
    /\ UNCHANGED rest

TheStepsAreCommitted ==
    /\ sub = "building" /\ Move("In Progress", "reviewing")
    /\ UNCHANGED rest

TheReviewFindsWorkToFix ==
    /\ sub = "reviewing" /\ Move("In Progress", "building")
    /\ UNCHANGED rest

TheReviewIsClean ==
    /\ sub = "reviewing" /\ Move("In Review", "gate")
    /\ reviewClean' = TRUE
    /\ UNCHANGED <<mode, prdGo, filed, warned, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>

TheReviewDoesNotConverge ==
    /\ sub = "reviewing" /\ Move("In Progress", "stuck")
    /\ UNCHANGED rest

\* ship files a follow-up only when the closed issue is not itself a follow-up.
Ship ==
    /\ Move("Done", "done")
    /\ merged' = TRUE
    /\ followups' \in (IF isFollowup THEN {FALSE} ELSE BOOLEAN)
    /\ UNCHANGED <<mode, prdGo, filed, reviewClean, warned, isFollowup, versionBumped, sweepGo, sweepChanged>>

YouRunShipAndGiveTheGo ==
    /\ sub = "gate" /\ mode = "manual" /\ shipGo' = TRUE /\ Ship

\* autonomous-loop ships without a go, also when the review is not clean.
TheSubagentShipsIt ==
    /\ sub \in {"gate", "stuck"} /\ mode = "auto" /\ Ship /\ UNCHANGED shipGo

ClaudeWarnsTheReviewIsNotClean ==
    /\ sub = "stuck" /\ mode = "manual" /\ ~warned /\ warned' = TRUE
    /\ UNCHANGED <<status, sub, mode, prdGo, filed, reviewClean, shipGo, merged, isFollowup, followups, versionBumped, sweepGo, sweepChanged>>

YouGiveTheGoAnyway ==
    /\ sub = "stuck" /\ warned /\ shipGo' = TRUE /\ Ship

\* sweep reports the verdicts and changes nothing in the tracker before your go.
Resting == IF status = "Todo" THEN "waiting" ELSE "backlog"
noSweep == <<mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped>>

YouRunSweep ==
    /\ sub \in {"waiting", "backlog", "skipped"} /\ sub' = "verdicts" /\ UNCHANGED status
    /\ sweepGo' = FALSE /\ sweepChanged' = FALSE
    /\ UNCHANGED noSweep

YouApproveCurrentOrDrifted ==
    /\ sub = "verdicts" /\ sub' = Resting /\ UNCHANGED status
    /\ sweepGo' = TRUE /\ sweepChanged' = TRUE
    /\ UNCHANGED noSweep

YouApproveDone ==
    /\ sub = "verdicts" /\ Move("Done", "closed")
    /\ sweepGo' = TRUE /\ sweepChanged' = TRUE
    /\ UNCHANGED noSweep

YouApproveSupersededOrObsolete ==
    /\ sub = "verdicts" /\ Move("Canceled", "canceled")
    /\ sweepGo' = TRUE /\ sweepChanged' = TRUE
    /\ UNCHANGED noSweep

YouRejectTheVerdict ==
    /\ sub = "verdicts" /\ sub' = Resting /\ UNCHANGED status
    /\ UNCHANGED <<sweepGo, sweepChanged>> /\ UNCHANGED noSweep

Finished == sub \in {"done", "closed", "canceled"} /\ UNCHANGED vars

Next ==
    \/ YouAskForAdvice \/ YouAskForAnInterview \/ YouRunPrd \/ YouGiveTheGoToFile
    \/ YouRunImplement \/ TheLoopTakesIt \/ TheLoopSkipsAStaleIssue \/ TheSubagentJudgesItNotWorthIt \/ YouMoveItBackToTodo
    \/ ADiscoveryChangesThePlan \/ TheIssueIsRewritten \/ TheStepsAreCommitted
    \/ TheReviewFindsWorkToFix \/ TheReviewIsClean \/ TheReviewDoesNotConverge
    \/ YouRunShipAndGiveTheGo \/ TheSubagentShipsIt
    \/ ClaudeWarnsTheReviewIsNotClean \/ YouGiveTheGoAnyway
    \/ YouRunSweep \/ YouApproveCurrentOrDrifted \/ YouApproveDone \/ YouApproveSupersededOrObsolete \/ YouRejectTheVerdict
    \/ Finished

Spec == Init /\ [][Next]_vars

NoMergeBeforeCleanReviewUnlessYouSawAWarningOrRanTheLoop == merged => (reviewClean \/ warned \/ mode = "auto")
NoMergeWithoutYourGo == merged => (shipGo \/ mode = "auto")
NoIssueBeforeYourGo == filed => prdGo
DoneOnlyAfterMergeOrAnApprovedDoneVerdict == status = "Done" => (merged \/ (sub = "closed" /\ sweepGo))
NoSweepChangeWithoutYourGo == sweepChanged => sweepGo
ASkippedIssueStaysInTodo == sub = "skipped" => status = "Todo"
FollowUpsOnlyFromShipAndNeverFromAFollowUp == followups => (merged /\ ~isFollowup)
NoVersionBumpOrRelease == ~versionBumped
====
