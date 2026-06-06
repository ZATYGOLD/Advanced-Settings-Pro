-- Quick: 75%, 85%, 95%
UPDATE AgeCrisisStages
SET
  AgeProgressTriggerPercent = CASE Stage
    WHEN 1 THEN 75
    WHEN 2 THEN 85
    WHEN 3 THEN 95
    WHEN 4 THEN 100
    ELSE AgeProgressTriggerPercent
  END,
  AgeProgressEndPercent = CASE Stage
    WHEN 1 THEN 85
    WHEN 2 THEN 95
    WHEN 3 THEN 100
    WHEN 4 THEN 100
    ELSE AgeProgressEndPercent
  END,
  MinDuration = 2
WHERE Stage IN (1,2,3,4);
