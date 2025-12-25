-- config/SetupParameters.sql
-- Author: Zatygold

-- New Parameter Groups
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("UnitMovementOptions", "LOC_GROUPID_UNITMOVEMENTOPTIONS");
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("MPAdvancedUnitMovementOptions", "LOC_GROUPID_UNITMOVEMENTOPTIONS");
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("IndependentPowerOptions", "LOC_GROUPID_INDEPENDENTPOWEROPTIONS");
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("MPAdvancedIndependentPowerOptions", "LOC_GROUPID_INDEPENDENTPOWEROPTIONS");
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("MementoOptions", "LOC_GROUPID_MEMENTOOPTIONS");
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES ("MPAdvancedMementoOptions", "LOC_GROUPID_MEMENTOOPTIONS");

--*******************************************************
--***************** SETTLER SETTINGS ********************
--*******************************************************
-- Settler Movement Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_SettlerMovementSpeed", "LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME", "LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION", "ZG_SettlerMovementDomain","ZG_DEFAULT", 1, "Game", "SettlerMovementKey", "UnitMovementOptions", "MPAdvancedUnitMovementOptions", 0, 1050);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_SettlerMovementDomain", "ZG_SETTLER_MOVES_DEFAULT", "LOC_ZG_DEFAULT_NAME", "", 10);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_SettlerMovementDomain", "ZG_SETTLER_MOVES_FAST", "LOC_ZG_FAST_NAME", "", 20);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_SettlerMovementDomain", "ZG_SETTLER_MOVES_SLOW", "LOC_ZG_SLOW_NAME", "", 30);

--*******************************************************
--************** TREASURE CONVOY SETTINGS ***************
--*******************************************************
-- Treasure Convoy Movement Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_TreasureMovementSpeed", "LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME", "LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION", "ZG_TreasureMovementDomain", "ZG_DEFAULT", 1, "Game","TreasureMovementKey", "UnitMovementOptions", "MPAdvancedUnitMovementOptions", 0, 1051);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_TreasureMovementDomain", "ZG_TREASURE_MOVES_DEFAULT", "LOC_ZG_DEFAULT_NAME", "", 10);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_TreasureMovementDomain", "ZG_TREASURE_MOVES_FAST", "LOC_ZG_FAST_NAME", "", 20);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_TreasureMovementDomain", "ZG_TREASURE_MOVES_SLOW", "LOC_ZG_SLOW_NAME", "", 30);

--*******************************************************
--************* INDEPENDENT POWER SETTINGS **************
--*******************************************************
-- Independent Power Count Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_IndependentCount", "LOC_ZG_INDEPENDENT_COUNT_NAME", "LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION","ZG_IndependentCountDomain", "ZG_DEFAULT", 1, "Game", "IndependentCountKey", "IndependentPowerOptions", "MPAdvancedIndependentPowerOptions", 0, 70);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_DEFAULT_INDEPENDENTS", "LOC_ZG_DEFAULT_NAME", "LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION", 10);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_MORE_INDEPENDENTS", "LOC_ZG_MORE_NAME", "LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION", 20);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_NONE_INDEPENDENTS", "LOC_ZG_NONE_NAME", "LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION", 30);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_LESS_INDEPENDENTS", "LOC_ZG_LESS_NAME", "LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION", 40);

-- Independent Power Spacing Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_IndependentSpace", "LOC_ZG_INDEPENDENT_SPACE_NAME", "LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION","ZG_IndependentSpaceDomain", "ZG_DEFAULT", 1, "Game", "IndependentSpaceKey", "IndependentPowerOptions", "MPAdvancedIndependentPowerOptions", 0, 71);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentSpaceDomain", "ZG_DEFAULT_INDEPENDENTS_SPACING", "LOC_ZG_DEFAULT_NAME", "LOC_ZG_INDEPENDENT_SPACE_ADDITIONAL_DESCRIPTION_DEFAULT", 10);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentSpaceDomain", "ZG_MORE_INDEPENDENTS_SPACING", "LOC_ZG_MORE_NAME", "LOC_ZG_INDEPENDENT_SPACE_ADDITIONAL_DESCRIPTION_MORE", 20);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentSpaceDomain", "ZG_LESS_INDEPENDENTS_SPACING", "LOC_ZG_LESS_NAME", "LOC_ZG_INDEPENDENT_SPACE_ADDITIONAL_DESCRIPTION_LESS", 30);

-- Independent Power Initial Units Count Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_IndependentUnitsCount", "LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_NAME", "LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_DESCRIPTION","ZG_IndependentUnitsCountDomain", "ZG_DEFAULT", 1, "Game", "IndependentUnitsCountKey", "IndependentPowerOptions", "MPAdvancedIndependentPowerOptions", 0, 72);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentUnitsCountDomain", "ZG_DEFAULT_INDEPENDENTS_UNIT_COUNT", "LOC_ZG_DEFAULT_NAME", "LOC_ZG_INDEPENDENT_INITIAL_UNITS_ADDITIONAL_DESCRIPTION_DEFAULT", 10);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentUnitsCountDomain", "ZG_MORE_INDEPENDENTS_UNIT_COUNT", "LOC_ZG_MORE_NAME", "LOC_ZG_INDEPENDENT_INITIAL_UNITS_ADDITIONAL_DESCRIPTION_MORE", 20);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentUnitsCountDomain", "ZG_LESS_INDEPENDENTS_UNIT_COUNT", "LOC_ZG_LESS_NAME", "LOC_ZG_INDEPENDENT_INITIAL_UNITS_ADDITIONAL_DESCRIPTION_LESS", 30);

--*******************************************************
--****************** MEMENTO SETTINGS *******************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_ChangeMementos", "LOC_ZG_CHANGE_MEMENTOS_NAME", "LOC_ZG_CHANGE_MEMENTOS_DESCRIPTION","ZG_ChangeMementosDomain", "ZG_DEFAULT", 1, "Game", "ChangeMementosKey", "MementoOptions", "MPAdvancedMementoOptions", 0, 5000);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_ChangeMementosDomain", "ZG_DISABLE_CHANGE_MEMENTOS", "LOC_ZG_DISABLE_NAME", "", 10);
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_ChangeMementosDomain", "ZG_ENABLE_CHANGE_MEMENTOS", "LOC_ZG_ENABLE_NAME", "", 20);