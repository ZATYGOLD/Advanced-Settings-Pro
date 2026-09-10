-- Slow: milestones and future techs/civics add half their age progress.
UPDATE AgeProgressionEvents
SET Points = MAX(1, ROUND(Points * 0.5))
WHERE AgeProgressionEventType IN ('AGE_PROGRESSION_PLAYER_MILESTONE_1', 'AGE_PROGRESSION_PLAYER_MILESTONE_2', 'AGE_PROGRESSION_PLAYER_MILESTONE_3', 'AGE_PROGRESSION_FUTURE_CIVIC', 'AGE_PROGRESSION_FUTURE_TECH');
