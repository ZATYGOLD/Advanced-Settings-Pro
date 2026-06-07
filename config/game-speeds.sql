--*******************************************************
--************* GAME SPEEDS *****************************
--*******************************************************
-- Adds the Online 2.0 and Marathon 2.0 speeds to the Game Speed dropdown.

INSERT OR IGNORE INTO GameSpeeds (GameSpeedType, Name, Description, SortIndex)
    VALUES
        ('GAMESPEED_ZG_ONLINE_2', 'LOC_ZG_GAMESPEED_ONLINE_2_NAME', 'LOC_ZG_GAMESPEED_ONLINE_2_DESCRIPTION', 5),
        ('GAMESPEED_ZG_MARATHON_2', 'LOC_ZG_GAMESPEED_MARATHON_2_NAME', 'LOC_ZG_GAMESPEED_MARATHON_2_DESCRIPTION', 60);
