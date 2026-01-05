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
        ('MPAdvancedSettlementLimitOptions', 'LOC_GROUPID_ZG_SETTLEMENTLIMITOPTIONS');

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
        ('ZG_IndependentCount', 'LOC_ZG_INDEPENDENT_COUNT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION','ZG_IndependentCountDomain', 'ZG_DEFAULT', 1, 'Game', 'IndependentCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 70),
        ('ZG_IndependentSpace', 'LOC_ZG_INDEPENDENT_SPACE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION','ZG_IndependentSpaceDomain', 'ZG_DEFAULT', 1, 'Game', 'IndependentSpaceKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 71),
        ('ZG_IndependentUnitsCount', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_DESCRIPTION','ZG_IndependentUnitsCountDomain', 'ZG_DEFAULT', 1, 'Game', 'IndependentUnitsCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 72);

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
-- Disasters Toggle
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ('DisasterOptions', 'LOC_ZG_DISASTER_SETTINGS_NAME', 'LOC_ZG_DISASTER_SETTINGS_DESCRIPTION','ZG_DisasterSettingsDomain', 'ZG_DEFAULT', 1, 'Game', 'DisasterSettingsKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3009);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_DisasterSettingsDomain', 'ZG_ENABLED_DISASTERS', 'LOC_ZG_ENABLED_NAME', '', 10),
        ('ZG_DisasterSettingsDomain', 'ZG_DISABLED_DISASTERS', 'LOC_ZG_DISABLED_NAME', '', 20);

INSERT OR IGNORE INTO ParameterDependencies (ParameterID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
    VALUES ('DisasterIntensity', 'Game', 'DisasterSettingsKey', 'Equals', 'ZG_ENABLED_DISASTERS');

--*******************************************************
--************* SETTLEMENT LIMIT SETTINGS ***************
--*******************************************************
------------------------------
-- Settlement Limit Parameters
------------------------------
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES ('ZG_SettlementLimit', 'LOC_ZG_SETTLEMENT_LIMIT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitKey', 'SettlementLimitOptions', 'MPAdvancedSettlementLimitOptions', 0, 65);
-- -- Settlement Limit Options
-- INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
--     VALUES 
--     ('ZG_SettlementLimitAntiquity', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_AntiquitySettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitAntiquityKey', 'SettlementLimitOptions', 'MPAdvancedSettlementLimitOptions', 0, 4200),
--     ('ZG_SettlementLimitExploration', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_ExplorationSettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitExplorationKey', 'SettlementLimitOptions', 'MPAdvancedSettlementLimitOptions', 0, 4210),
--     ('ZG_SettlementLimitModern', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_ModernSettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitModernKey', 'SettlementLimitOptions', 'MPAdvancedSettlementLimitOptions', 0, 4220);

-----------------------
-- ParameterDependencies
-----------------------
-- INSERT OR IGNORE INTO ParameterDependencies (ParameterID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
-- VALUES
--     ('ZG_SettlementLimitAntiquityCustom', 'Game', 'ZG_SettlementLimitDomain', 'Equals', 'ZG_CUSTOM_SETTLEMENT_LIMIT_COUNT');

-----------------
-- DomainValues
-----------------
-- Standard Options
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_SettlementLimitDomain', 'ZG_LESS_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_LESS_NAME', '', 30);
--      ('ZG_SettlementLimitDomain', 'ZG_CUSTOM_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_CUSTOM_NAME', '', 100);

-- -- Custom Antiquity Options
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_AntiquitySettlementLimitDomain', 'ZG_CUSTOM_ANTIQUITY_SETTLEMENT_LIMIT_DEFAULT', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_DEFAULT', '', 10);
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_AntiquitySettlementLimitDomain', 'ZG_CUSTOM_ANTIQUITY_SETTLEMENT_LIMIT_MORE', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_MORE', '', 20);
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_AntiquitySettlementLimitDomain', 'ZG_CUSTOM_ANTIQUITY_SETTLEMENT_LIMIT_LESS', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_LESS', '', 30);

-- -- Custom Exploration Options
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_ExplorationSettlementLimitDomain', 'ZG_CUSTOM_EXPLORATION_SETTLEMENT_LIMIT_DEFAULT', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_DEFAULT', '', 10);
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_ExplorationSettlementLimitDomain', 'ZG_CUSTOM_EXPLORATION_SETTLEMENT_LIMIT_MORE', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_MORE', '', 20);
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_ExplorationSettlementLimitDomain', 'ZG_CUSTOM_EXPLORATION_SETTLEMENT_LIMIT_LESS', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_LESS', '', 30);

-- -- Custom Modern Options
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_ModernSettlementLimitDomain', 'ZG_CUSTOM_MODERN_SETTLEMENT_LIMIT_DEFAULT', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_DEFAULT', '', 10);
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_ModernSettlementLimitDomain', 'ZG_CUSTOM_MODERN_SETTLEMENT_LIMIT_MORE', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_MORE', '', 20);
-- INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
--     VALUES ('ZG_ModernSettlementLimitDomain', 'ZG_CUSTOM_MODERN_SETTLEMENT_LIMIT_LESS', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_LESS', '', 30);

-----------------------
-- ConfigurationUpdates
-----------------------
-- -- When primary = DEFAULT, set all ages = DEFAULT
-- INSERT OR IGNORE INTO ConfigurationUpdates (SourceGroup, SourceKey, SourceValue, TargetGroup, TargetKey, TargetValue, Hash)
-- VALUES
--   ('Game','SettlementLimitKey','ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitAntiquityKey', 'ZG_CUSTOM_ANTIQUITY_SETTLEMENT_LIMIT_DEFAULT', 1),
--   ('Game','SettlementLimitKey','ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitExplorationKey', 'ZG_CUSTOM_EXPLORATION_SETTLEMENT_LIMIT_DEFAULT', 1),
--   ('Game','SettlementLimitKey','ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitModernKey', 'ZG_CUSTOM_MODERN_SETTLEMENT_LIMIT_DEFAULT', 1);

-- -- When primary = MORE, set all ages = MORE
-- INSERT OR IGNORE INTO ConfigurationUpdates (SourceGroup, SourceKey, SourceValue, TargetGroup, TargetKey, TargetValue, Hash)
-- VALUES
--   ('Game','SettlementLimitKey','ZG_MORE_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitAntiquityKey','ZG_CUSTOM_ANTIQUITY_SETTLEMENT_LIMIT_MORE', 1),
--   ('Game','SettlementLimitKey','ZG_MORE_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitExplorationKey','ZG_CUSTOM_EXPLORATION_SETTLEMENT_LIMIT_MORE', 1),
--   ('Game','SettlementLimitKey','ZG_MORE_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitModernKey','ZG_CUSTOM_MODERN_SETTLEMENT_LIMIT_MORE', 1);

-- -- When primary = LESS, set all ages = LESS
-- INSERT OR IGNORE INTO ConfigurationUpdates (SourceGroup, SourceKey, SourceValue, TargetGroup, TargetKey, TargetValue, Hash)
-- VALUES
--   ('Game','SettlementLimitKey','ZG_LESS_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitAntiquityKey','ZG_CUSTOM_ANTIQUITY_SETTLEMENT_LIMIT_LESS', 1),
--   ('Game','SettlementLimitKey','ZG_LESS_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitExplorationKey','ZG_CUSTOM_EXPLORATION_SETTLEMENT_LIMIT_LESS', 1),
--   ('Game','SettlementLimitKey','ZG_LESS_SETTLEMENT_LIMIT_COUNT','Game','SettlementLimitModernKey','ZG_CUSTOM_MODERN_SETTLEMENT_LIMIT_LESS', 1);
