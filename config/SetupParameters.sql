-- config/SetupParameters.sql
-- Author: Zatygold

-- New Parameter Groups
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES 
        ('UnitMovementOptions', 'LOC_GROUPID_ZG_UNITMOVEMENTOPTIONS'),
        ('MPAdvancedUnitMovementOptions', 'LOC_GROUPID_ZG_UNITMOVEMENTOPTIONS'),
        ('IndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('MPAdvancedIndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('SettlementLimitOptions', 'LOC_GROUPID_ZG_SETTLEMENTLIMITOPTIONS'),
        ('MPAdvancedSettlementLimitOptions', 'LOC_GROUPID_ZG_SETTLEMENTLIMITOPTIONS'),
        ('MementoOptions', 'LOC_GROUPID_ZG_MEMENTOOPTIONS'),
        ('MPAdvancedMementoOptions', 'LOC_GROUPID_ZG_MEMENTOOPTIONS');

--*******************************************************
--***************** SETTLER SETTINGS ********************
--*******************************************************
-- Settler Movement Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ('ZG_SettlerMovementSpeed', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 'ZG_SettlerMovementDomain','ZG_DEFAULT', 1, 'Game', 'SettlerMovementKey', 'UnitMovementOptions', 'MPAdvancedUnitMovementOptions', 0, 1050);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_FAST', 'LOC_ZG_FAST_NAME', '', 20),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', '', 30);

--*******************************************************
--************** TREASURE CONVOY SETTINGS ***************
--*******************************************************
-- Treasure Convoy Movement Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ('ZG_TreasureMovementSpeed', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 'ZG_TreasureMovementDomain', 'ZG_DEFAULT', 1, 'Game','TreasureMovementKey', 'UnitMovementOptions', 'MPAdvancedUnitMovementOptions', 0, 1051);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_FAST', 'LOC_ZG_FAST_NAME', '', 20),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', '', 30);

--*******************************************************
--************* INDEPENDENT POWER SETTINGS **************
--*******************************************************
-- Independent Power Count Options
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES 
        ('ZG_IndependentCount', 'LOC_ZG_INDEPENDENT_COUNT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION','ZG_IndependentCountDomain', 'ZG_DEFAULT', 1, 'Game', 'IndependentCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 700),
        ('ZG_IndependentSpace', 'LOC_ZG_INDEPENDENT_SPACE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION','ZG_IndependentSpaceDomain', 'ZG_DEFAULT', 1, 'Game', 'IndependentSpaceKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 7010),
        ('ZG_IndependentUnitsCount', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_DESCRIPTION','ZG_IndependentUnitsCountDomain', 'ZG_DEFAULT', 1, 'Game', 'IndependentUnitsCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 7020);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION', 10),
        ('ZG_IndependentCountDomain', 'ZG_MORE_INDEPENDENTS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION', 20),
        ('ZG_IndependentCountDomain', 'ZG_NONE_INDEPENDENTS', 'LOC_ZG_NONE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION', 30),
        ('ZG_IndependentCountDomain', 'ZG_LESS_INDEPENDENTS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_COUNT_ADDITIONAL_DESCRIPTION', 40),
        ('ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_SPACE_ADDITIONAL_DESCRIPTION_DEFAULT', 10),
        ('ZG_IndependentSpaceDomain', 'ZG_MORE_INDEPENDENTS_SPACING', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_ADDITIONAL_DESCRIPTION_MORE', 20),
        ('ZG_IndependentSpaceDomain', 'ZG_LESS_INDEPENDENTS_SPACING', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_SPACE_ADDITIONAL_DESCRIPTION_LESS', 30),
        ('ZG_IndependentUnitsCountDomain', 'ZG_DEFAULT_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_ADDITIONAL_DESCRIPTION_DEFAULT', 10),
        ('ZG_IndependentUnitsCountDomain', 'ZG_MORE_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_ADDITIONAL_DESCRIPTION_MORE', 20),
        ('ZG_IndependentUnitsCountDomain', 'ZG_LESS_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_ADDITIONAL_DESCRIPTION_LESS', 30);

--*******************************************************
--************* DISASTER INTENSITY SETTINGS *************
--*******************************************************
-- Disasters Disabled
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ('StandardDisasterIntensities', 'ZG_DISABLED_DISASTERS', 'LOC_ZG_DISABLED_NAME', '', 40);

--*******************************************************
--************* SETTLEMENT LIMIT SETTINGS ***************
--*******************************************************
------------------------------
-- Settlement Limit Parameters
------------------------------
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ('ZG_SettlementLimit', 'LOC_ZG_SETTLEMENT_LIMIT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitKey', 'SettlementLimitOptions', 'MPAdvancedSettlementLimitOptions', 0, 600);

-----------------
-- DomainValues
-----------------
-- Standard Options
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_ADDITIONAL_DESCRIPTION_DEFAULT', 10),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_ADDITIONAL_DESCRIPTION_MORE', 20),
        ('ZG_SettlementLimitDomain', 'ZG_LESS_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_ADDITIONAL_DESCRIPTION_LESS', 30);

--*******************************************************
--***************** MEMENTO SETTINGS ********************
--*******************************************************
--------------
-- Parameters
--------------
UPDATE Parameters SET GroupId = 'MementoOptions', GroupIDMultiplayerOverride = 'MPAdvancedMementoOptions', SupportsSinglePlayer = 1, SortIndex = '500' Where ParameterID = 'MementosEnabled';
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ('ZG_MementoSlots', 'LOC_ZG_MEMENTO_SLOTS_NAME', 'LOC_ZG_MEMENTO_SLOTS_DESCRIPTION','ZG_MementoSlotsDomain', 'ZG_DEFAULT', 0, 'Player', 'MementoSlotsKey', 'MementoOptions', 'MPAdvancedMementoOptions', 0, 5010);

-------------------------
-- ParametersDependencies
-------------------------
INSERT OR IGNORE INTO ParameterDependencies (ParameterID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
    VALUES ('ZG_MementoSlots', 'Game', 'MementosEnabled', 'Equals', '1');

-----------------
-- DomainValues
-----------------
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_MementoSlotsDomain', 'ZG_DEFAULT_MEMENTO_SLOTS', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_MementoSlotsDomain', 'ZG_MORE_MEMENTO_SLOTS', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_MementoSlotsDomain', 'ZG_LESS_MEMENTO_SLOTS', 'LOC_ZG_LESS_NAME', '', 30);