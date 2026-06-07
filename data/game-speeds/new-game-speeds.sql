-- Online 2.0: 150% faster than Standard (cost multiplier 40 vs 100).
-- Marathon 2.0: 400% slower than Standard (cost multiplier 500 vs 100).
-- Calendar pacing is copied from the closest base speed, so patch changes
-- to those tables carry over automatically.

INSERT OR IGNORE INTO Types (Type, Kind)
    VALUES
        ('GAMESPEED_ZG_ONLINE_2', 'KIND_GAMESPEED'),
        ('GAMESPEED_ZG_MARATHON_2', 'KIND_GAMESPEED');

INSERT OR IGNORE INTO GameSpeeds (GameSpeedType, Name, Description, CostMultiplier)
    VALUES
        ('GAMESPEED_ZG_ONLINE_2', 'LOC_ZG_GAMESPEED_ONLINE_2_NAME', 'LOC_ZG_GAMESPEED_ONLINE_2_DESCRIPTION', 40),
        ('GAMESPEED_ZG_MARATHON_2', 'LOC_ZG_GAMESPEED_MARATHON_2_NAME', 'LOC_ZG_GAMESPEED_MARATHON_2_DESCRIPTION', 500);

INSERT INTO GameSpeed_Turns (GameSpeedType, MonthIncrement, TurnsPerIncrement, Age)
SELECT 'GAMESPEED_ZG_ONLINE_2', MonthIncrement, TurnsPerIncrement, Age
FROM GameSpeed_Turns
WHERE GameSpeedType = 'GAMESPEED_ONLINE';

INSERT INTO GameSpeed_Turns (GameSpeedType, MonthIncrement, TurnsPerIncrement, Age)
SELECT 'GAMESPEED_ZG_MARATHON_2', MonthIncrement, TurnsPerIncrement, Age
FROM GameSpeed_Turns
WHERE GameSpeedType = 'GAMESPEED_MARATHON';

-- Duration scaling follows the base game's pattern: timed effects scale
-- about half as aggressively as costs so they stay playable at the extremes.
INSERT OR IGNORE INTO GameSpeed_Scalings (GameSpeedScalingType, GameSpeedType, ScalingType, DefaultCostMultiplier)
    VALUES
        ('ZG_ONLINE_2_HALF', 'GAMESPEED_ZG_ONLINE_2', 'SCALING_HALF', 53),
        ('ZG_ONLINE_2_SLIGHT', 'GAMESPEED_ZG_ONLINE_2', 'SCALING_SLIGHT', 75),
        ('ZG_MARATHON_2_HALF', 'GAMESPEED_ZG_MARATHON_2', 'SCALING_HALF', 300),
        ('ZG_MARATHON_2_SLIGHT', 'GAMESPEED_ZG_MARATHON_2', 'SCALING_SLIGHT', 130);

INSERT OR IGNORE INTO GameSpeed_Durations (GameSpeedScalingType, NumberOfTurnsOnStandard, NumberOfTurnsScaled)
    VALUES
        ('ZG_ONLINE_2_HALF', 5, 4),
        ('ZG_ONLINE_2_HALF', 10, 6),
        ('ZG_ONLINE_2_HALF', 15, 8),
        ('ZG_ONLINE_2_HALF', 29, 16),
        ('ZG_ONLINE_2_HALF', 30, 17),
        ('ZG_ONLINE_2_HALF', 60, 33),
        ('ZG_MARATHON_2_HALF', 5, 20),
        ('ZG_MARATHON_2_HALF', 10, 35),
        ('ZG_MARATHON_2_HALF', 15, 45),
        ('ZG_MARATHON_2_HALF', 29, 89),
        ('ZG_MARATHON_2_HALF', 30, 90),
        ('ZG_MARATHON_2_HALF', 60, 180);
