-- config/unit_movement/TreasureConvoyParameters.sql
-- Author: Zatygold

-- Treasure Convoy Movement Settings
-- Left Side | Setting Title Information
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, Hash, DefaultValue, ConfigurationGroup, ConfigurationKey,	GroupId, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_TreasureMovementSpeed", "LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME", "LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION", 
            "ZG_TreasureMovementDomain", 0, "ZG_TREASURE_MOVES_DEFAULT", "Game","TreasureMovementKey" , "ZGOptions", 0, 1051);

-- Right Side | Setting Options, Description, and Additional Information
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_TreasureMovementDomain", "ZG_TREASURE_MOVES_DEFAULT", "LOC_ZG_DEFAULT_NAME", "", 10);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_TreasureMovementDomain", "ZG_TREASURE_MOVES_SLOW", "LOC_ZG_SLOW_NAME", "", 30);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_TreasureMovementDomain", "ZG_TREASURE_MOVES_FAST", "LOC_ZG_FAST_NAME", "", 20);