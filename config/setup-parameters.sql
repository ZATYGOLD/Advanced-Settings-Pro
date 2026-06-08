--*******************************************************
--***************** PARAMETER GROUPS ********************
--*******************************************************
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name)
    VALUES
        ('UnitOptions', 'LOC_GROUPID_ZG_UNITOPTIONS'),
        ('MPAdvancedUnitOptions', 'LOC_GROUPID_ZG_UNITOPTIONS'),
        ('IndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('MPAdvancedIndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('SettlementOptions', 'LOC_GROUPID_ZG_SETTLEMENTOPTIONS'),
        ('MPAdvancedSettlementOptions', 'LOC_GROUPID_ZG_SETTLEMENTOPTIONS'),
        ('NaturalWonderSelectionOptions', 'LOC_GROUPID_ZG_NATURALWONDERSELECTIONOPTIONS'),
        ('MPAdvancedNaturalWonderSelectionOptions', 'LOC_GROUPID_ZG_NATURALWONDERSELECTIONOPTIONS');

--*******************************************************
--***************** SINGLE AGE SETTINGS *****************
--*******************************************************
UPDATE Parameters SET SupportsSinglePlayer = 1 WHERE ParameterID = 'SingleAgeGame';

--*******************************************************
--***************** AGE LENGTH *************************
--*******************************************************
-- Replaces the base Age Length setting with an extended version that adds
-- Brief (90) and Doubled (280) to the existing three options. The base
-- parameter is hidden so only one Age Length control is shown; it stays at
-- its Standard default while each option below sets the actual point total.
UPDATE Parameters SET Hidden = 1 WHERE ParameterID = 'AgeLength';

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_AgeLength', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH_DESC', 'ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_STANDARD', 1, 'Game', 'AgeLengthKey', 'GameOptions', 'MPAdvancedGameOptions', 0, 140);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_BRIEF', 'LOC_ZG_AGE_LENGTH_BRIEF_NAME', 'LOC_ZG_AGE_LENGTH_BRIEF_DESC', 10),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_ABBREVIATED', 'LOC_ADVANCED_OPTIONS_ABBREVIATED', 'LOC_ADVANCED_OPTIONS_ABBREVIATED_DESC', 20),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD_DESC', 30),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_LONG', 'LOC_ADVANCED_OPTIONS_LONG', 'LOC_ADVANCED_OPTIONS_LONG_DESC', 40),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_DOUBLED', 'LOC_ZG_AGE_LENGTH_DOUBLED_NAME', 'LOC_ZG_AGE_LENGTH_DOUBLED_DESC', 50);

--*******************************************************
--***************** UNIT SETTINGS ********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlerMovementSpeed', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 'ZG_SettlerMovementDomain','ZG_SETTLER_MOVES_DEFAULT', 1, 'Game', 'SettlerMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1050),
        ('ZG_TreasureMovementSpeed', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 'ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 1, 'Game','TreasureMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1051),
        ('ZG_CombatUnitCost', 'LOC_ZG_COMBAT_UNIT_COST_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 'ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DEFAULT', 1, 'Game','CombatUnitCostKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1052),
        ('ZG_CivilianUnitCost', 'LOC_ZG_CIVILIAN_UNIT_COST_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 'ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_DEFAULT', 1, 'Game','CivilianUnitCostKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1053);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 10),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 20),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 30),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 10),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 20),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_LESS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 10),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 20),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_MORE', 'LOC_ZG_MORE_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_EXPENSIVE', 'LOC_ZG_EXPENSIVE_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 40),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_LESS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 10),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 20),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_MORE', 'LOC_ZG_MORE_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 30),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_EXPENSIVE', 'LOC_ZG_EXPENSIVE_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 40);


--*******************************************************
--************* INDEPENDENT POWER SETTINGS **************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_IndependentCount', 'LOC_ZG_INDEPENDENT_COUNT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION','ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 1, 'Game', 'IndependentCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 700),
        ('ZG_IndependentSpace', 'LOC_ZG_INDEPENDENT_SPACE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION','ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 1, 'Game', 'IndependentSpaceKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 7010),
        ('ZG_IndependentUnitsCount', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_COUNT_DESCRIPTION','ZG_IndependentUnitsCountDomain', 'ZG_DEFAULT_INDEPENDENTS_UNIT_COUNT', 1, 'Game', 'IndependentUnitsCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 7020);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_IndependentCountDomain', 'ZG_NONE_INDEPENDENTS', 'LOC_ZG_NONE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 10),
        ('ZG_IndependentCountDomain', 'ZG_LESS_INDEPENDENTS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 20),
        ('ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 30),
        ('ZG_IndependentCountDomain', 'ZG_MORE_INDEPENDENTS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 40),
        ('ZG_IndependentSpaceDomain', 'ZG_LESS_INDEPENDENTS_SPACING', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_LESS', 10),
        ('ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_DEFAULT', 20),
        ('ZG_IndependentSpaceDomain', 'ZG_MORE_INDEPENDENTS_SPACING', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_MORE', 30),
        ('ZG_IndependentUnitsCountDomain', 'ZG_LESS_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_DESCRIPTION_LESS', 10),
        ('ZG_IndependentUnitsCountDomain', 'ZG_DEFAULT_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_DESCRIPTION_DEFAULT', 20),
        ('ZG_IndependentUnitsCountDomain', 'ZG_MORE_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_DESCRIPTION_MORE', 30);


--*******************************************************
--************* DISASTER INTENSITY SETTINGS *************
--*******************************************************
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('StandardDisasterIntensities', 'ZG_DISABLED_DISASTERS', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_DISASTER_SETTINGS_DESCRIPTION', 40);

--*******************************************************
--************* SETTLEMENT SETTINGS *********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES

        ('ZG_SettlementLimit', 'LOC_ZG_SETTLEMENT_LIMIT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 610),
        ('ZG_SettlementDistance', 'LOC_ZG_SETTLEMENT_DISTANCE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION','ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 1, 'Game', 'SettlementDistanceKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 600);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlementLimitDomain', 'ZG_LESS_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_LESS', 10),
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_MORE', 30),
        ('ZG_SettlementLimitDomain', 'ZG_CUSTOM_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_CUSTOM', 40),
        ('ZG_SettlementDistanceDomain', 'ZG_LESS_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION', 10),
        ('ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION', 20),
        ('ZG_SettlementDistanceDomain', 'ZG_MORE_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION', 30);


INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlementLimitAntiquity', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_3', 1, 'Game', 'SettlementLimitAntiquityKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 611),
        ('ZG_SettlementLimitExploration', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_8', 1, 'Game', 'SettlementLimitExplorationKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 612),
        ('ZG_SettlementLimitModern', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_16', 1, 'Game', 'SettlementLimitModernKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 613);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_1', 'LOC_ZG_NUM_1', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 10),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_2', 'LOC_ZG_NUM_2', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 20),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_3', 'LOC_ZG_NUM_3', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 30),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_4', 'LOC_ZG_NUM_4', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 40),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_5', 'LOC_ZG_NUM_5', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 50),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_6', 'LOC_ZG_NUM_6', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 60),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_7', 'LOC_ZG_NUM_7', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 70),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_8', 'LOC_ZG_NUM_8', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 80),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_9', 'LOC_ZG_NUM_9', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 90),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_10', 'LOC_ZG_NUM_10', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 100),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_11', 'LOC_ZG_NUM_11', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 110),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_12', 'LOC_ZG_NUM_12', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 120),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_13', 'LOC_ZG_NUM_13', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 130),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_14', 'LOC_ZG_NUM_14', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 140),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_15', 'LOC_ZG_NUM_15', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 150),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_16', 'LOC_ZG_NUM_16', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 160),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_17', 'LOC_ZG_NUM_17', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 170),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_18', 'LOC_ZG_NUM_18', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 180),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_19', 'LOC_ZG_NUM_19', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 190),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_20', 'LOC_ZG_NUM_20', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 200),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_21', 'LOC_ZG_NUM_21', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 210),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_22', 'LOC_ZG_NUM_22', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 220),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_23', 'LOC_ZG_NUM_23', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 230),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_24', 'LOC_ZG_NUM_24', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 240),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_25', 'LOC_ZG_NUM_25', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 250),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_26', 'LOC_ZG_NUM_26', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 260),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_27', 'LOC_ZG_NUM_27', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 270),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_28', 'LOC_ZG_NUM_28', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 280),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_29', 'LOC_ZG_NUM_29', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 290),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_30', 'LOC_ZG_NUM_30', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 300),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_31', 'LOC_ZG_NUM_31', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 310),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_32', 'LOC_ZG_NUM_32', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 320),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_33', 'LOC_ZG_NUM_33', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 330),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_34', 'LOC_ZG_NUM_34', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 340),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_35', 'LOC_ZG_NUM_35', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 350),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_36', 'LOC_ZG_NUM_36', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 360),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_37', 'LOC_ZG_NUM_37', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 370),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_38', 'LOC_ZG_NUM_38', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 380),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_39', 'LOC_ZG_NUM_39', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 390),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_40', 'LOC_ZG_NUM_40', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 400),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_41', 'LOC_ZG_NUM_41', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 410),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_42', 'LOC_ZG_NUM_42', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 420),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_43', 'LOC_ZG_NUM_43', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 430),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_44', 'LOC_ZG_NUM_44', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 440),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_45', 'LOC_ZG_NUM_45', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 450),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_46', 'LOC_ZG_NUM_46', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 460),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_47', 'LOC_ZG_NUM_47', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 470),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_48', 'LOC_ZG_NUM_48', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 480),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_49', 'LOC_ZG_NUM_49', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 490),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_50', 'LOC_ZG_NUM_50', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 500);

--*******************************************************
--************* CRISIS SETTINGS *************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
         ('ZG_CrisisSpeed', 'LOC_ZG_CRISIS_SPEED_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION','ZG_CrisisSpeedDomain', 'ZG_DEFAULT_CRISIS_SPEED', 0, 'Game', 'CrisisSpeedKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3029);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_CrisisSpeedDomain', 'ZG_CRAWL_CRISIS_SPEED', 'LOC_ZG_CRAWL_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_CRAWL', 10),
        ('ZG_CrisisSpeedDomain', 'ZG_SLOW_CRISIS_SPEED', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_SLOW', 20),
        ('ZG_CrisisSpeedDomain', 'ZG_DEFAULT_CRISIS_SPEED', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_DEFAULT', 30),
        ('ZG_CrisisSpeedDomain', 'ZG_QUICK_CRISIS_SPEED', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_QUICK', 40),
        ('ZG_CrisisSpeedDomain', 'ZG_FAST_CRISIS_SPEED', 'LOC_ZG_FAST_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_FAST', 50);


--*******************************************************
--************* MAP SETTINGS ****************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_LakeGeneration', 'LOC_ZG_LAKE_GENERATION_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION','ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 0, 'Game', 'LakeGenerationKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1033);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_NaturalWonderCountDomain', 'ZG_NONE_NATURAL_WONDER_COUNT', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_NONE', 10),
        ('ZG_NaturalWonderCountDomain', 'ZG_HALF_NATURAL_WONDER_COUNT', 'LOC_ZG_HALF_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_HALF', 20),
        ('ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_DEFAULT', 30),
        ('ZG_NaturalWonderCountDomain', 'ZG_MORE_NATURAL_WONDER_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_MORE', 40),
        ('ZG_NaturalWonderCountDomain', 'ZG_DOUBLE_NATURAL_WONDER_COUNT', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_DOUBLE', 50),
        ('ZG_LakeGenerationDomain', 'ZG_DISABLED_LAKE_GENERATION', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION_DISABLED', 10),
        ('ZG_LakeGenerationDomain', 'ZG_LESS_LAKE_GENERATION', 'LOC_ZG_LESS_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION', 20),
        ('ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION', 30),
        ('ZG_LakeGenerationDomain', 'ZG_MORE_LAKE_GENERATION', 'LOC_ZG_MORE_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION', 40);

--*******************************************************
--************* NATURAL WONDER TOGGLES ******************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_NaturalWondersCount', 'LOC_ZG_NATURAL_WONDER_COUNT_NAME', 'LOC_ZG_NATURAL_WONDER_COUNT_DESCRIPTION','ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 1, 'Game', 'NaturalWonderCountKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 190),
        ('ZG_NW_BarrierReef', 'LOC_FEATURE_BARRIER_REEF_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWBarrierReefKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 200),
        ('ZG_NW_BermudaTriangle', 'LOC_FEATURE_BERMUDA_TRIANGLE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWBermudaTriangleKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 210),
        ('ZG_NW_GrandCanyon', 'LOC_FEATURE_GRAND_CANYON_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWGrandCanyonKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 220),
        ('ZG_NW_GreatBlueHole', 'LOC_FEATURE_GREAT_BLUE_HOLE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWGreatBlueHoleKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 230),
        ('ZG_NW_Gullfoss', 'LOC_FEATURE_GULLFOSS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWGullfossKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 240),
        ('ZG_NW_Hoerikwaggo', 'LOC_FEATURE_HOERIKWAGGO_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWHoerikwaggoKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 250),
        ('ZG_NW_IguazuFalls', 'LOC_FEATURE_IGUAZU_FALLS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWIguazuFallsKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 260),
        ('ZG_NW_Kilimanjaro', 'LOC_FEATURE_KILIMANJARO_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWKilimanjaroKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 270),
        ('ZG_NW_Machapuchare', 'LOC_FEATURE_MACHAPUCHARE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMachapuchareKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 280),
        ('ZG_NW_MapuAVaeaBlowholes', 'LOC_FEATURE_MAPU_A_VAEA_BLOWHOLES_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMapuAVaeaBlowholesKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 290),
        ('ZG_NW_MountEverest', 'LOC_FEATURE_MOUNT_EVEREST_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMountEverestKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 300),
        ('ZG_NW_MountFuji', 'LOC_FEATURE_MOUNT_FUJI_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMountFujiKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 310),
        ('ZG_NW_RedwoodForest', 'LOC_FEATURE_REDWOOD_FOREST_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWRedwoodForestKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 320),
        ('ZG_NW_Thera', 'LOC_FEATURE_THERA_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWTheraKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 330),
        ('ZG_NW_TorresDelPaine', 'LOC_FEATURE_TORRES_DEL_PAINE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWTorresDelPaineKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 340),
        ('ZG_NW_Uluru', 'LOC_FEATURE_ULURU_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWUluruKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 350),
        ('ZG_NW_ValleyOfFlowers', 'LOC_FEATURE_VALLEY_OF_FLOWERS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWValleyOfFlowersKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 360),
        ('ZG_NW_Vihren', 'LOC_FEATURE_VIHREN_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWVihrenKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 370),
        ('ZG_NW_Vinicunca', 'LOC_FEATURE_VINICUNCA_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWVinicuncaKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 380),
        ('ZG_NW_Zhangjiajie', 'LOC_FEATURE_ZHANGJIAJIE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWZhangjiajieKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 390);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_WonderToggleDomain', 'ZG_ENABLED', 'LOC_ZG_ENABLED_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 10),
        ('ZG_WonderToggleDomain', 'ZG_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 20);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_Rivers', 'LOC_ZG_RIVERS_NAME', 'LOC_ZG_RIVERS_DESCRIPTION','ZG_RiversDomain', 'ZG_DEFAULT_RIVERS', 0, 'Game', 'RiversKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1034);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_RiversDomain', 'ZG_DISABLED_RIVERS', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_DISABLED', 10),
        ('ZG_RiversDomain', 'ZG_LESS_RIVERS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_LESS', 20),
        ('ZG_RiversDomain', 'ZG_DEFAULT_RIVERS', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_DEFAULT', 30),
        ('ZG_RiversDomain', 'ZG_MORE_RIVERS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_MORE', 40);