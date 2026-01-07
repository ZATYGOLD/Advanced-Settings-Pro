-- config/SetupParameters.sql
-- Author: Zatygold

-- New Parameter Groups
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name) 
    VALUES 
        ('UnitOptions', 'LOC_GROUPID_ZG_UNITOPTIONS'),
        ('MPAdvancedUnitOptions', 'LOC_GROUPID_ZG_UNITOPTIONS'),
        ('IndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('MPAdvancedIndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('SettlementOptions', 'LOC_GROUPID_ZG_SETTLEMENTOPTIONS'),
        ('MPAdvancedSettlementOptions', 'LOC_GROUPID_ZG_SETTLEMENTOPTIONS');


--*******************************************************
--***************** SINGLE AGE SETTINGS *****************
--*******************************************************
UPDATE Parameters SET SupportsSinglePlayer = 1 WHERE ParameterID = 'SingleAgeGame';

--*******************************************************
--***************** UNIT SETTINGS ********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES 
        ('ZG_SettlerMovementSpeed', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 'ZG_SettlerMovementDomain','ZG_DEFAULT', 1, 'Game', 'SettlerMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1050),
        ('ZG_TreasureMovementSpeed', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 'ZG_TreasureMovementDomain', 'ZG_DEFAULT', 1, 'Game','TreasureMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1051),
        ('ZG_CombatUnitCost', 'LOC_ZG_COMBAT_UNIT_COST_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 'ZG_CombatUnitCostDomain', 'ZG_DEFAULT', 1, 'Game','CombatUnitCostKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1052);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_FAST', 'LOC_ZG_FAST_NAME', '', 20),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', '', 30),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_FAST', 'LOC_ZG_FAST_NAME', '', 20),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', '', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DEFAULT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_MORE', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_LESS', 'LOC_ZG_LESS_NAME', '', 30);

--*******************************************************
--************* INDEPENDENT POWER SETTINGS **************
--*******************************************************
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
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('StandardDisasterIntensities', 'ZG_DISABLED_DISASTERS', 'LOC_ZG_DISABLED_NAME', '', 40);

--*******************************************************
--************* SETTLEMENT SETTINGS *********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES 
        ('ZG_SettlementLimit', 'LOC_ZG_SETTLEMENT_LIMIT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 600),
        ('ZG_SettlementDistance', 'LOC_ZG_SETTLEMENT_DISTANCE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION','ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 1, 'Game', 'SettlementDistanceKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 6010);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_ADDITIONAL_DESCRIPTION_DEFAULT', 10),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_ADDITIONAL_DESCRIPTION_MORE', 20),
        ('ZG_SettlementLimitDomain', 'ZG_LESS_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_ADDITIONAL_DESCRIPTION_LESS', 30),
        ('ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_SettlementDistanceDomain', 'ZG_MORE_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_SettlementDistanceDomain', 'ZG_LESS_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_LESS_NAME', '', 30);

--*******************************************************
--************* CRISIS SETTINGS *************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES 
         ('ZG_CrisisSpeed', 'LOC_ZG_CRISIS_SPEED_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION','ZG_CrisisSpeedDomain', 'ZG_DEFAULT_CRISIS_SPEED_COUNT', 0, 'Game', 'CrisisSpeedKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3029);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_CrisisSpeedDomain', 'ZG_DEFAULT_CRISIS_SPEED', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_CRISIS_SPEED_ADDITIONAL_DESCRIPTION_DEFAULT', 10),
        ('ZG_CrisisSpeedDomain', 'ZG_QUICK_CRISIS_SPEED', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_CRISIS_SPEED_ADDITIONAL_DESCRIPTION_QUICK', 20),
        ('ZG_CrisisSpeedDomain', 'ZG_SLOW_CRISIS_SPEED', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_CRISIS_SPEED_ADDITIONAL_DESCRIPTION_SLOW', 50),
        ('ZG_CrisisSpeedDomain', 'ZG_FAST_CRISIS_SPEED', 'LOC_ZG_FAST_NAME', 'LOC_ZG_CRISIS_SPEED_ADDITIONAL_DESCRIPTION_FAST', 30),
        ('ZG_CrisisSpeedDomain', 'ZG_CRAWL_CRISIS_SPEED', 'LOC_ZG_CRAWL_NAME', 'LOC_ZG_CRISIS_SPEED_ADDITIONAL_DESCRIPTION_CRAWL', 40);

--*******************************************************
--************* MAP SETTINGS ****************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex) 
    VALUES 
        ('ZG_NaturalWondersCount', 'LOC_ZG_NATURAL_WONDER_COUNT_NAME', 'LOC_ZG_NATURAL_WONDER_COUNT_DESCRIPTION','ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 1, 'Game', 'NaturalWonderCountKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1031),
        ('ZG_OceanWidth', 'LOC_ZG_OCEAN_WIDTH_NAME', 'LOC_ZG_OCEAN_WIDTH_DESCRIPTION','ZG_OceanWidthDomain', 'ZG_DEFAULT_OCEAN_WIDTH', 1, 'Game', 'OceanWidthKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1032),
        ('ZG_LakeGeneration', 'LOC_ZG_LAKE_GENERATION_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION','ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 1, 'Game', 'LakeGenerationKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1033);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES 
        ('ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_NaturalWonderCountDomain', 'ZG_MORE_NATURAL_WONDER_COUNT', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_NaturalWonderCountDomain', 'ZG_DOUBLE_NATURAL_WONDER_COUNT', 'LOC_ZG_DOUBLE_NAME', '', 30),
        ('ZG_NaturalWonderCountDomain', 'ZG_NONE_NATURAL_WONDER_COUNT', 'LOC_ZG_NONE_NAME', '', 40),
        ('ZG_NaturalWonderCountDomain', 'ZG_HALF_NATURAL_WONDER_COUNT', 'LOC_ZG_HALF_NAME', '', 50),
        ('ZG_OceanWidthDomain', 'ZG_DEFAULT_OCEAN_WIDTH', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_OceanWidthDomain', 'ZG_MORE_OCEAN_WIDTH', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_OceanWidthDomain', 'ZG_LESS_OCEAN_WIDTH', 'LOC_ZG_LESS_NAME', '', 30),
        ('ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 'LOC_ZG_DEFAULT_NAME', '', 10),
        ('ZG_LakeGenerationDomain', 'ZG_MORE_LAKE_GENERATION', 'LOC_ZG_MORE_NAME', '', 20),
        ('ZG_LakeGenerationDomain', 'ZG_DOUBLE_LAKE_GENERATION', 'LOC_ZG_DOUBLE_NAME', '', 30),
        ('ZG_LakeGenerationDomain', 'ZG_NONE_LAKE_GENERATION', 'LOC_ZG_NONE_NAME', '', 40),
        ('ZG_LakeGenerationDomain', 'ZG_HALF_LAKE_GENERATION', 'LOC_ZG_HALF_NAME', '', 50);
