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
--***************** UNIT SETTINGS ********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlerMovementSpeed', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 'ZG_SettlerMovementDomain','ZG_SETTLER_MOVES_DEFAULT', 1, 'Game', 'SettlerMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1050),
        ('ZG_TreasureMovementSpeed', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 'ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 1, 'Game','TreasureMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1051),
        ('ZG_CombatUnitCost', 'LOC_ZG_COMBAT_UNIT_COST_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 'ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DEFAULT', 1, 'Game','CombatUnitCostKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1052);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 10),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 20),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 30),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 10),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 20),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DEFAULT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 10),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_MORE', 'LOC_ZG_MORE_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 20),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_LESS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 30);


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
        ('ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 10),
        ('ZG_IndependentCountDomain', 'ZG_MORE_INDEPENDENTS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 20),
        ('ZG_IndependentCountDomain', 'ZG_NONE_INDEPENDENTS', 'LOC_ZG_NONE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 30),
        ('ZG_IndependentCountDomain', 'ZG_LESS_INDEPENDENTS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION', 40),
        ('ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_DEFAULT', 10),
        ('ZG_IndependentSpaceDomain', 'ZG_MORE_INDEPENDENTS_SPACING', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_MORE', 20),
        ('ZG_IndependentSpaceDomain', 'ZG_LESS_INDEPENDENTS_SPACING', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_LESS', 30),
        ('ZG_IndependentUnitsCountDomain', 'ZG_DEFAULT_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_DESCRIPTION_DEFAULT', 10),
        ('ZG_IndependentUnitsCountDomain', 'ZG_MORE_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_DESCRIPTION_MORE', 20),
        ('ZG_IndependentUnitsCountDomain', 'ZG_LESS_INDEPENDENTS_UNIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_INITIAL_UNITS_DESCRIPTION_LESS', 30);


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

        ('ZG_SettlementLimit', 'LOC_ZG_SETTLEMENT_LIMIT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 600),
        ('ZG_SettlementDistance', 'LOC_ZG_SETTLEMENT_DISTANCE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION','ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 1, 'Game', 'SettlementDistanceKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 6010);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_DEFAULT', 10),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_MORE', 20),
        ('ZG_SettlementLimitDomain', 'ZG_LESS_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_LESS', 30),
        ('ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION', 10),
        ('ZG_SettlementDistanceDomain', 'ZG_MORE_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION', 20),
        ('ZG_SettlementDistanceDomain', 'ZG_LESS_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION', 30);


--*******************************************************
--************* CRISIS SETTINGS *************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
         ('ZG_CrisisSpeed', 'LOC_ZG_CRISIS_SPEED_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION','ZG_CrisisSpeedDomain', 'ZG_DEFAULT_CRISIS_SPEED', 0, 'Game', 'CrisisSpeedKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3029);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_CrisisSpeedDomain', 'ZG_DEFAULT_CRISIS_SPEED', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_DEFAULT', 10),
        ('ZG_CrisisSpeedDomain', 'ZG_QUICK_CRISIS_SPEED', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_QUICK', 20),
        ('ZG_CrisisSpeedDomain', 'ZG_SLOW_CRISIS_SPEED', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_SLOW', 50),
        ('ZG_CrisisSpeedDomain', 'ZG_FAST_CRISIS_SPEED', 'LOC_ZG_FAST_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_FAST', 30),
        ('ZG_CrisisSpeedDomain', 'ZG_CRAWL_CRISIS_SPEED', 'LOC_ZG_CRAWL_NAME', 'LOC_ZG_CRISIS_SPEED_DESCRIPTION_CRAWL', 40);


--*******************************************************
--************* MAP SETTINGS ****************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_LakeGeneration', 'LOC_ZG_LAKE_GENERATION_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION','ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 1, 'Game', 'LakeGenerationKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1033);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_DEFAULT', 10),
        ('ZG_NaturalWonderCountDomain', 'ZG_MORE_NATURAL_WONDER_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_MORE', 20),
        ('ZG_NaturalWonderCountDomain', 'ZG_DOUBLE_NATURAL_WONDER_COUNT', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_DOUBLE', 30),
        ('ZG_NaturalWonderCountDomain', 'ZG_NONE_NATURAL_WONDER_COUNT', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_NONE', 40),
        ('ZG_NaturalWonderCountDomain', 'ZG_HALF_NATURAL_WONDER_COUNT', 'LOC_ZG_HALF_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_HALF', 50),
        ('ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 'LOC_ZG_DEFAULT_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION', 10),
        ('ZG_LakeGenerationDomain', 'ZG_MORE_LAKE_GENERATION', 'LOC_ZG_MORE_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION', 20),
        ('ZG_LakeGenerationDomain', 'ZG_LESS_LAKE_GENERATION', 'LOC_ZG_LESS_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION', 30);

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
