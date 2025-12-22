-- config/unit_movement/SettlerParameters.sql
-- Author: Zatygold

-- Group ID
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("UnitMovementOptions", "LOC_GROUPID_MOVEMENT_SETTINGS");

INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("MPAdvancedUnitMovementOptions", "LOC_GROUPID_MOVEMENT_SETTINGS");

-- Settler Movement Settings
-- Left Side | Setting Title Information
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_SettlerMovementSpeed", "LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME", "LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION", 
            "ZG_SettlerMovementDomain","ZG_SETTLER_MOVES_DEFAULT", 1, "Game","SettlerMovementKey", "UnitMovementOptions", "MPAdvancedUnitMovementOptions", 0, 1050);

-- Right Side | Setting Options, Description, and Additional Information
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_SettlerMovementDomain", "ZG_SETTLER_MOVES_DEFAULT", "LOC_ZG_DEFAULT_NAME", "", 10);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_SettlerMovementDomain", "ZG_SETTLER_MOVES_FAST", "LOC_ZG_FAST_NAME", "", 20);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_SettlerMovementDomain", "ZG_SETTLER_MOVES_SLOW", "LOC_ZG_SLOW_NAME", "", 30);