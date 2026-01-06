-- data/crisis/pacing/CrisisFaster.sql
-- Author: Zatygold

-- Fast: 80%, 85%, 90%
UPDATE AgeCrisisStages
SET
  AgeProgressTriggerPercent = CASE Stage
    WHEN 1 THEN 80
    WHEN 2 THEN 85
    WHEN 3 THEN 90
    WHEN 4 THEN 100
    ELSE AgeProgressTriggerPercent
  END,
  AgeProgressEndPercent = CASE Stage
    WHEN 1 THEN 85
    WHEN 2 THEN 90
    WHEN 3 THEN 100
    WHEN 4 THEN 100
    ELSE AgeProgressEndPercent
  END
WHERE Stage IN (1,2,3,4);
