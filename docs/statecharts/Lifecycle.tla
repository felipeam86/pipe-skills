---- MODULE Lifecycle ----
\* The lifecycle of one piece of work through the pipe-skills pipeline.
\* status is the Linear state of the issue, sub is where the work is inside it.
VARIABLES status, sub, mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped
vars == <<status, sub, mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped>>
rest == <<mode, prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped>>

Init ==
    /\ status = "none" /\ sub = "idea" /\ mode = "none"
    /\ prdGo = FALSE /\ filed = FALSE /\ reviewClean = FALSE
    /\ warned = FALSE /\ shipGo = FALSE /\ merged = FALSE /\ followups = FALSE
    /\ isFollowup \in BOOLEAN
    /\ versionBumped = FALSE

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
    /\ UNCHANGED <<mode, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped>>

YouRunImplement ==
    /\ sub \in {"waiting", "backlog"} /\ Move("In Progress", "building")
    /\ mode' = "manual"
    /\ UNCHANGED <<prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped>>

TheLoopTakesIt ==
    /\ sub = "waiting" /\ Move("In Progress", "building")
    /\ mode' = "auto"
    /\ UNCHANGED <<prdGo, filed, reviewClean, warned, shipGo, merged, isFollowup, followups, versionBumped>>

TheSubagentJudgesItNotWorthIt ==
    /\ sub = "waiting" /\ Move("Backlog", "backlog")
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
    /\ UNCHANGED <<mode, prdGo, filed, warned, shipGo, merged, isFollowup, followups, versionBumped>>

TheReviewDoesNotConverge ==
    /\ sub = "reviewing" /\ Move("In Progress", "stuck")
    /\ UNCHANGED rest

\* ship files a follow-up only when the closed issue is not itself a follow-up.
Ship ==
    /\ Move("Done", "done")
    /\ merged' = TRUE
    /\ followups' \in (IF isFollowup THEN {FALSE} ELSE BOOLEAN)
    /\ UNCHANGED <<mode, prdGo, filed, reviewClean, warned, isFollowup, versionBumped>>

YouRunShipAndGiveTheGo ==
    /\ sub = "gate" /\ mode = "manual" /\ shipGo' = TRUE /\ Ship

\* autonomous-loop ships without a go, also when the review is not clean.
TheSubagentShipsIt ==
    /\ sub \in {"gate", "stuck"} /\ mode = "auto" /\ Ship /\ UNCHANGED shipGo

ClaudeWarnsTheReviewIsNotClean ==
    /\ sub = "stuck" /\ mode = "manual" /\ ~warned /\ warned' = TRUE
    /\ UNCHANGED <<status, sub, mode, prdGo, filed, reviewClean, shipGo, merged, isFollowup, followups, versionBumped>>

YouGiveTheGoAnyway ==
    /\ sub = "stuck" /\ warned /\ shipGo' = TRUE /\ Ship

Finished == sub = "done" /\ UNCHANGED vars

Next ==
    \/ YouAskForAdvice \/ YouAskForAnInterview \/ YouRunPrd \/ YouGiveTheGoToFile
    \/ YouRunImplement \/ TheLoopTakesIt \/ TheSubagentJudgesItNotWorthIt \/ YouMoveItBackToTodo
    \/ ADiscoveryChangesThePlan \/ TheIssueIsRewritten \/ TheStepsAreCommitted
    \/ TheReviewFindsWorkToFix \/ TheReviewIsClean \/ TheReviewDoesNotConverge
    \/ YouRunShipAndGiveTheGo \/ TheSubagentShipsIt
    \/ ClaudeWarnsTheReviewIsNotClean \/ YouGiveTheGoAnyway \/ Finished

Spec == Init /\ [][Next]_vars

NoMergeBeforeCleanReviewUnlessYouSawAWarningOrRanTheLoop == merged => (reviewClean \/ warned \/ mode = "auto")
NoMergeWithoutYourGo == merged => (shipGo \/ mode = "auto")
NoIssueBeforeYourGo == filed => prdGo
DoneOnlyAfterMerge == status = "Done" => merged
FollowUpsOnlyFromShipAndNeverFromAFollowUp == followups => (merged /\ ~isFollowup)
NoVersionBumpOrRelease == ~versionBumped
====
