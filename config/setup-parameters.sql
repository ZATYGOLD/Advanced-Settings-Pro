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
        ('MPAdvancedNaturalWonderSelectionOptions', 'LOC_GROUPID_ZG_NATURALWONDERSELECTIONOPTIONS'),
        ('CrisisOptions', 'LOC_GROUPID_ZG_CRISISOPTIONS'),
        ('GamePacingOptions', 'LOC_GROUPID_ZG_GAMEPACINGOPTIONS'),
        ('MPAdvancedGamePacingOptions', 'LOC_GROUPID_ZG_GAMEPACINGOPTIONS'),
        ('PacingAntiquityOptions', 'LOC_AGE_ANTIQUITY_NAME'),
        ('MPAdvancedPacingAntiquityOptions', 'LOC_AGE_ANTIQUITY_NAME'),
        ('PacingExplorationOptions', 'LOC_AGE_EXPLORATION_NAME'),
        ('MPAdvancedPacingExplorationOptions', 'LOC_AGE_EXPLORATION_NAME'),
        ('PacingModernOptions', 'LOC_AGE_MODERN_NAME'),
        ('MPAdvancedPacingModernOptions', 'LOC_AGE_MODERN_NAME');

-- The single-player disaster group no longer holds the crisis settings, so it is
-- renamed to Disaster Settings. Multiplayer keeps the base name.
UPDATE ParameterGroups SET Name = 'LOC_GROUPID_ZG_DISASTEROPTIONS' WHERE GroupID = 'DisasterOptions';

--*******************************************************
--***************** SINGLE AGE SETTINGS *****************
--*******************************************************
UPDATE Parameters SET SupportsSinglePlayer = 1 WHERE ParameterID = 'SingleAgeGame';

--*******************************************************
--***************** AGE LENGTH *************************
--*******************************************************
-- The base Age Length setting moves to All Ages on the Pace tab, gains Brief
-- (90), Doubled (280), and Custom, and drives the per-age Age Length rows
-- (ui/zg-setup-rules.js). Each option applies a data/ages file that sets the
-- same point total for every base length, so the engine's own choice never
-- changes the result; Custom applies the per-age rows' files instead.
UPDATE Parameters SET GroupId = 'GamePacingOptions', GroupIDMultiplayerOverride = 'MPAdvancedGamePacingOptions', SortIndex = 30 WHERE ParameterID = 'AgeLength';

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('StandardAgeLengths', 'ZG_AGE_LENGTH_BRIEF', 'LOC_ZG_AGE_LENGTH_BRIEF_NAME', 'LOC_ZG_AGE_LENGTH_BRIEF_DESC', 5),
        ('StandardAgeLengths', 'ZG_AGE_LENGTH_DOUBLED', 'LOC_ZG_AGE_LENGTH_DOUBLED_NAME', 'LOC_ZG_AGE_LENGTH_DOUBLED_DESC', 35),
        ('StandardAgeLengths', 'ZG_AGE_LENGTH_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 40);

UPDATE DomainValues SET Description = 'LOC_ZG_AGE_LENGTH_ABBREVIATED_DESC' WHERE Domain = 'StandardAgeLengths' AND Value = 'AGE_LENGTH_ABBREVIATED';
UPDATE DomainValues SET Description = 'LOC_ZG_AGE_LENGTH_STANDARD_DESC' WHERE Domain = 'StandardAgeLengths' AND Value = 'AGE_LENGTH_STANDARD';
UPDATE DomainValues SET Description = 'LOC_ZG_AGE_LENGTH_LONG_DESC' WHERE Domain = 'StandardAgeLengths' AND Value = 'AGE_LENGTH_LONG';

--*******************************************************
--***************** UNIT SETTINGS ********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlerMovementSpeed', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 'ZG_SettlerMovementDomain','ZG_SETTLER_MOVES_DEFAULT', 1, 'Game', 'SettlerMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1050),
        ('ZG_TreasureMovementSpeed', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 'ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 1, 'Game','TreasureMovementKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1051),
        ('ZG_CombatUnitCost', 'LOC_ZG_COMBAT_UNIT_COST_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 'ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_STANDARD', 1, 'Game','CombatUnitCostKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1052),
        ('ZG_CivilianUnitCost', 'LOC_ZG_CIVILIAN_UNIT_COST_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 'ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_STANDARD', 1, 'Game','CivilianUnitCostKey', 'UnitOptions', 'MPAdvancedUnitOptions', 0, 1053);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_SLOW', 10),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_DEFAULT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_FAST', 30),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_SLOW', 10),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_DEFAULT', 20),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_FAST', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_LOW', 10),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_HIGH', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_LOW', 10),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_HIGH', 30),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_DOUBLE', 40);


--*******************************************************
--************* INDEPENDENT POWER SETTINGS **************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_IndependentCount', 'LOC_ZG_INDEPENDENT_COUNT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION','ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 1, 'Game', 'IndependentCountKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 700),
        ('ZG_IndependentSpace', 'LOC_ZG_INDEPENDENT_SPACE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION','ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 1, 'Game', 'IndependentSpaceKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 7010),
        ('ZG_IndependentAggression', 'LOC_ZG_INDEPENDENT_AGGRESSION_NAME', 'LOC_ZG_INDEPENDENT_AGGRESSION_DESCRIPTION','ZG_IndependentAggressionDomain', 'ZG_DEFAULT_AGGRESSION', 1, 'Game', 'IndependentAggressionKey', 'IndependentPowerOptions', 'MPAdvancedIndependentPowerOptions', 0, 7030);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_IndependentCountDomain', 'ZG_NONE_INDEPENDENTS', 'LOC_ZG_NONE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION_NONE', 10),
        ('ZG_IndependentCountDomain', 'ZG_LESS_INDEPENDENTS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION_LESS', 20),
        ('ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION_DEFAULT', 30),
        ('ZG_IndependentCountDomain', 'ZG_MORE_INDEPENDENTS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION_MORE', 40),
        ('ZG_IndependentSpaceDomain', 'ZG_LESS_INDEPENDENTS_SPACING', 'LOC_ZG_LESS_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_LESS', 10),
        ('ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_DEFAULT', 20),
        ('ZG_IndependentSpaceDomain', 'ZG_MORE_INDEPENDENTS_SPACING', 'LOC_ZG_MORE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION_MORE', 30),
        ('ZG_IndependentAggressionDomain', 'ZG_CALM_AGGRESSION', 'LOC_ZG_INDEPENDENT_AGGRESSION_CALM_NAME', 'LOC_ZG_INDEPENDENT_AGGRESSION_DESCRIPTION_CALM', 10),
        ('ZG_IndependentAggressionDomain', 'ZG_DEFAULT_AGGRESSION', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_INDEPENDENT_AGGRESSION_DESCRIPTION_DEFAULT', 20),
        ('ZG_IndependentAggressionDomain', 'ZG_RAGING_AGGRESSION', 'LOC_ZG_INDEPENDENT_AGGRESSION_RAGING_NAME', 'LOC_ZG_INDEPENDENT_AGGRESSION_DESCRIPTION_RAGING', 30);


--*******************************************************
--************* RANDOM MEMENTOS *************************
--*******************************************************
-- Remembers which of an AI player's memento slots are set to Random; the slots
-- themselves hold a real memento rolled by ui/zg-player-mementos.js.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_PlayerRandomMementos', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 'ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_NONE', 0, 'Player', 'ZGRandomMementos', 'PlayerOptions', NULL, 0, 3040);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_NONE', 'LOC_ZG_NONE_NAME', '', 10),
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_MAJOR', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 20),
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_MINOR', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 30),
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_BOTH', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 40);

--*******************************************************
--************* PACE PRESET *****************************
--*******************************************************
-- Preset selector in Game Settings. Each preset sets the All Ages settings on
-- the Pace tab to the values it stands for (ui/zg-setup-rules.js); changing
-- one of them afterwards switches the preset to Custom.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_PacePreset', 'LOC_ZG_PACE_PRESET_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION', 'ZG_PacePresetDomain', 'ZG_PACE_PRESET_STANDARD', 1, 'Game', 'PacePresetKey', 'GameOptions', 'MPAdvancedGameOptions', 0, 138);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_PACE_PRESET_DESCRIPTION_STANDARD', 10),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_BALANCED', 20),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_MULTIPLAYER', 'LOC_ZG_PACE_PRESET_MULTIPLAYER_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_MULTIPLAYER', 30),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_CUSTOM', 40);

--*******************************************************
--************* GAME PACING *****************************
--*******************************************************
-- Shown on the Pace tab (ui/zg-map-tab.js): All Ages holds the primaries
-- (Age Length above and the settings below); the Antiquity,
-- Exploration, and Modern groups hold each setting's per-age row, used when the
-- primary is Custom and synced by ui/zg-setup-rules.js. Victory Project Cost is
-- Modern-only, so it has no rows.

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_AgeLengthAntiquity', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeLengthAgeDomain', 'ZG_AGE_LENGTH_STANDARD', 1, 'Game', 'AgeLengthAntiquityKey', 'PacingAntiquityOptions', 'MPAdvancedPacingAntiquityOptions', 0, 100),
        ('ZG_AgeLengthExploration', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeLengthAgeDomain', 'ZG_AGE_LENGTH_STANDARD', 1, 'Game', 'AgeLengthExplorationKey', 'PacingExplorationOptions', 'MPAdvancedPacingExplorationOptions', 0, 110),
        ('ZG_AgeLengthModern', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeLengthAgeDomain', 'ZG_AGE_LENGTH_STANDARD', 1, 'Game', 'AgeLengthModernKey', 'PacingModernOptions', 'MPAdvancedPacingModernOptions', 0, 120),
        ('ZG_AgeProgressRate', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION', 'ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateKey', 'GamePacingOptions', 'MPAdvancedGamePacingOptions', 0, 32),
        ('ZG_AgeProgressRateAntiquity', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateAntiquityKey', 'PacingAntiquityOptions', 'MPAdvancedPacingAntiquityOptions', 0, 101),
        ('ZG_AgeProgressRateExploration', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateExplorationKey', 'PacingExplorationOptions', 'MPAdvancedPacingExplorationOptions', 0, 111),
        ('ZG_AgeProgressRateModern', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateModernKey', 'PacingModernOptions', 'MPAdvancedPacingModernOptions', 0, 121),
        ('ZG_TechnologyCost', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION', 'ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostKey', 'GamePacingOptions', 'MPAdvancedGamePacingOptions', 0, 36),
        ('ZG_TechnologyCostAntiquity', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostAntiquityKey', 'PacingAntiquityOptions', 'MPAdvancedPacingAntiquityOptions', 0, 102),
        ('ZG_TechnologyCostExploration', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostExplorationKey', 'PacingExplorationOptions', 'MPAdvancedPacingExplorationOptions', 0, 112),
        ('ZG_TechnologyCostModern', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostModernKey', 'PacingModernOptions', 'MPAdvancedPacingModernOptions', 0, 122),
        ('ZG_CivicCost', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION', 'ZG_CivicCostDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostKey', 'GamePacingOptions', 'MPAdvancedGamePacingOptions', 0, 40),
        ('ZG_CivicCostAntiquity', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostAntiquityKey', 'PacingAntiquityOptions', 'MPAdvancedPacingAntiquityOptions', 0, 103),
        ('ZG_CivicCostExploration', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostExplorationKey', 'PacingExplorationOptions', 'MPAdvancedPacingExplorationOptions', 0, 113),
        ('ZG_CivicCostModern', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostModernKey', 'PacingModernOptions', 'MPAdvancedPacingModernOptions', 0, 123),
        ('ZG_CityGrowth', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION', 'ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthKey', 'GamePacingOptions', 'MPAdvancedGamePacingOptions', 0, 44),
        ('ZG_CityGrowthAntiquity', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthAntiquityKey', 'PacingAntiquityOptions', 'MPAdvancedPacingAntiquityOptions', 0, 104),
        ('ZG_CityGrowthExploration', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthExplorationKey', 'PacingExplorationOptions', 'MPAdvancedPacingExplorationOptions', 0, 114),
        ('ZG_CityGrowthModern', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthModernKey', 'PacingModernOptions', 'MPAdvancedPacingModernOptions', 0, 124),
        ('ZG_Roads', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_ROADS_DESCRIPTION', 'ZG_RoadsDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsKey', 'GamePacingOptions', 'MPAdvancedGamePacingOptions', 0, 48),
        ('ZG_RoadsAntiquity', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsAntiquityKey', 'PacingAntiquityOptions', 'MPAdvancedPacingAntiquityOptions', 0, 105),
        ('ZG_RoadsExploration', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsExplorationKey', 'PacingExplorationOptions', 'MPAdvancedPacingExplorationOptions', 0, 115),
        ('ZG_RoadsModern', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsModernKey', 'PacingModernOptions', 'MPAdvancedPacingModernOptions', 0, 125),
        ('ZG_VictoryProjectCost', 'LOC_ZG_VICTORY_PROJECT_COST_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION', 'ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 1, 'Game', 'VictoryProjectCostKey', 'GamePacingOptions', 'MPAdvancedGamePacingOptions', 0, 52);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_90', 'LOC_ZG_NUM_90', 'LOC_ZG_NUM_90', 10),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_100', 'LOC_ZG_NUM_100', 'LOC_ZG_NUM_100', 20),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_110', 'LOC_ZG_NUM_110', 'LOC_ZG_NUM_110', 30),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_120', 'LOC_ZG_NUM_120', 'LOC_ZG_NUM_120', 40),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_130', 'LOC_ZG_NUM_130', 'LOC_ZG_NUM_130', 50),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_140', 'LOC_ZG_NUM_140', 'LOC_ZG_NUM_140', 60),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_150', 'LOC_ZG_NUM_150', 'LOC_ZG_NUM_150', 70),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_153', 'LOC_ZG_NUM_153', 'LOC_ZG_NUM_153', 80),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_155', 'LOC_ZG_NUM_155', 'LOC_ZG_NUM_155', 90),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_160', 'LOC_ZG_NUM_160', 'LOC_ZG_NUM_160', 100),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_166', 'LOC_ZG_NUM_166', 'LOC_ZG_NUM_166', 110),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_170', 'LOC_ZG_NUM_170', 'LOC_ZG_NUM_170', 120),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_180', 'LOC_ZG_NUM_180', 'LOC_ZG_NUM_180', 130),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_190', 'LOC_ZG_NUM_190', 'LOC_ZG_NUM_190', 140),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_196', 'LOC_ZG_NUM_196', 'LOC_ZG_NUM_196', 150),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_200', 'LOC_ZG_NUM_200', 'LOC_ZG_NUM_200', 160),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_220', 'LOC_ZG_NUM_220', 'LOC_ZG_NUM_220', 170),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_240', 'LOC_ZG_NUM_240', 'LOC_ZG_NUM_240', 180),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_260', 'LOC_ZG_NUM_260', 'LOC_ZG_NUM_260', 190),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_280', 'LOC_ZG_NUM_280', 'LOC_ZG_NUM_280', 200),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_300', 'LOC_ZG_NUM_300', 'LOC_ZG_NUM_300', 210),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_SLOW', 10),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_STANDARD', 20),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_BALANCED', 30),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_FAST', 40),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_SLOW', 10),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_STANDARD', 20),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_BALANCED', 30),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_FAST', 40),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_COST_DESCRIPTION_LOW', 10),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_COST_DESCRIPTION_HIGH', 30),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 10),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_35', 'LOC_ZG_PCT_PLUS_35', 'LOC_ZG_PCT_PLUS_35', 40),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_45', 'LOC_ZG_PCT_PLUS_45', 'LOC_ZG_PCT_PLUS_45', 50),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 60),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_60', 'LOC_ZG_PCT_PLUS_60', 'LOC_ZG_PCT_PLUS_60', 70),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_75', 'LOC_ZG_PCT_PLUS_75', 'LOC_ZG_PCT_PLUS_75', 80),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_85', 'LOC_ZG_PCT_PLUS_85', 'LOC_ZG_PCT_PLUS_85', 90),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 100),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_COST_DESCRIPTION_LOW', 10),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_COST_DESCRIPTION_HIGH', 30),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 10),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_35', 'LOC_ZG_PCT_PLUS_35', 'LOC_ZG_PCT_PLUS_35', 40),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_45', 'LOC_ZG_PCT_PLUS_45', 'LOC_ZG_PCT_PLUS_45', 50),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 60),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_60', 'LOC_ZG_PCT_PLUS_60', 'LOC_ZG_PCT_PLUS_60', 70),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_75', 'LOC_ZG_PCT_PLUS_75', 'LOC_ZG_PCT_PLUS_75', 80),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_85', 'LOC_ZG_PCT_PLUS_85', 'LOC_ZG_PCT_PLUS_85', 90),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 100),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_SLOWER', 'LOC_ZG_SLOWER_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SLOWER', 10),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SLOW', 20),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_STANDARD', 30),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_FAST', 40),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_SLOWER', 'LOC_ZG_SLOWER_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SLOWER', 10),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SLOW', 20),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_STANDARD', 30),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_FAST', 40),
        ('ZG_RoadsDomain', 'ZG_ROADS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_ROADS_DESCRIPTION_STANDARD', 10),
        ('ZG_RoadsDomain', 'ZG_ROADS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_ROADS_DESCRIPTION_FAST', 20),
        ('ZG_RoadsDomain', 'ZG_ROADS_EXPRESS', 'LOC_ZG_ROADS_EXPRESS_NAME', 'LOC_ZG_ROADS_DESCRIPTION_EXPRESS', 30),
        ('ZG_RoadsDomain', 'ZG_ROADS_FASTER', 'LOC_ZG_FASTER_NAME', 'LOC_ZG_ROADS_DESCRIPTION_FASTER', 40),
        ('ZG_RoadsDomain', 'ZG_ROADS_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_ROADS_DESCRIPTION_STANDARD', 10),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_ROADS_DESCRIPTION_FAST', 20),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_EXPRESS', 'LOC_ZG_ROADS_EXPRESS_NAME', 'LOC_ZG_ROADS_DESCRIPTION_EXPRESS', 30),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_FASTER', 'LOC_ZG_FASTER_NAME', 'LOC_ZG_ROADS_DESCRIPTION_FASTER', 40),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_COST_DESCRIPTION_LOW', 10),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_PLUS_20', 'LOC_ZG_PCT_PLUS_20', 'LOC_ZG_COST_DESCRIPTION_PLUS_20', 30),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_COST_DESCRIPTION_HIGH', 40),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_COST_DESCRIPTION_DOUBLE', 50);

--*******************************************************
--************* INDEPENDENT HOSTILITY *******************
--*******************************************************
-- The base Initial Independent Hostility setting belongs with the other
-- Independent Power settings.
UPDATE Parameters SET GroupId = 'IndependentPowerOptions', GroupIDMultiplayerOverride = 'MPAdvancedIndependentPowerOptions', SortIndex = 690 WHERE ParameterID = 'IndependentHostility';

--*******************************************************
--************* TRIUMPH SETS ****************************
--*******************************************************
-- Adds Custom to the base Triumph Set setting. While Custom is selected the
-- engine reads the ZG_LEGACY_SET_CUSTOM set, which data/triumphs fills with
-- the set chosen for the age being played.
INSERT OR IGNORE INTO LegacySets (LegacySetType, Name, Description, SortIndex)
    VALUES
        ('ZG_LEGACY_SET_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_TRIUMPH_SET_DESCRIPTION_CUSTOM', 5);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_TriumphSetAntiquity', 'LOC_AGE_ANTIQUITY_NAME', 'LOC_ZG_TRIUMPH_SET_AGE_DESCRIPTION', 'ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 1, 'Game', 'TriumphSetAntiquityKey', 'TriumphSettings', NULL, 0, 11),
        ('ZG_TriumphSetExploration', 'LOC_AGE_EXPLORATION_NAME', 'LOC_ZG_TRIUMPH_SET_AGE_DESCRIPTION', 'ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 1, 'Game', 'TriumphSetExplorationKey', 'TriumphSettings', NULL, 0, 12),
        ('ZG_TriumphSetModern', 'LOC_AGE_MODERN_NAME', 'LOC_ZG_TRIUMPH_SET_AGE_DESCRIPTION', 'ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 1, 'Game', 'TriumphSetModernKey', 'TriumphSettings', NULL, 0, 13);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 'LOC_TRIUMPH_SET_DEFAULT_NAME', 'LOC_TRIUMPH_SET_DEFAULT_DESCRIPTION', 10),
        ('ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_CLASSIC', 'LOC_TRIUMPH_SET_CLASSIC_NAME', 'LOC_TRIUMPH_SET_CLASSIC_DESCRIPTION', 20),
        ('ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_RACE', 'LOC_TRIUMPH_SET_RACE_NAME', 'LOC_TRIUMPH_SET_RACE_DESCRIPTION', 30),
        ('ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_CONQUEROR', 'LOC_TRIUMPH_SET_CONQUEROR_NAME', 'LOC_TRIUMPH_SET_CONQUEROR_DESCRIPTION', 40),
        ('ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_EXPLORER', 'LOC_TRIUMPH_SET_EXPLORER_NAME', 'LOC_TRIUMPH_SET_EXPLORER_DESCRIPTION', 50),
        ('ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_NONE', 'LOC_TRIUMPH_SET_NONE_NAME', 'LOC_TRIUMPH_SET_NONE_DESCRIPTION', 60);

--*******************************************************
--************* DISASTER FREQUENCY **********************
--*******************************************************
-- Replaces the base Disaster Intensity setting with one that adds Disabled and
-- Custom. The base parameter is hidden and stays at its Light default; each
-- option below sets the actual frequencies, so the engine always sees a valid
-- intensity. Custom uses the per-age settings that follow.
UPDATE Parameters SET Hidden = 1 WHERE ParameterID = 'DisasterIntensity';

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_DisasterFrequency', 'LOC_ZG_DISASTER_SETTINGS_NAME', 'LOC_ADVANCED_OPTIONS_DISASTER_INTENSITY_DESC', 'ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisasterFrequencyKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3010),
        ('ZG_DisastersAntiquity', 'LOC_AGE_ANTIQUITY_NAME', 'LOC_ZG_DISASTER_AGE_DESCRIPTION', 'ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisastersAntiquityKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3011),
        ('ZG_DisastersExploration', 'LOC_AGE_EXPLORATION_NAME', 'LOC_ZG_DISASTER_AGE_DESCRIPTION', 'ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisastersExplorationKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3012),
        ('ZG_DisastersModern', 'LOC_AGE_MODERN_NAME', 'LOC_ZG_DISASTER_AGE_DESCRIPTION', 'ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisastersModernKey', 'DisasterOptions', 'MPAdvancedDisasterOptions', 0, 3013);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_DISASTER_SETTINGS_DESCRIPTION', 10),
        ('ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_LIGHT', 'LOC_ADVANCED_OPTIONS_LIGHT', 'LOC_ADVANCED_OPTIONS_LIGHT_TOOLTIP', 20),
        ('ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_MODERATE', 'LOC_ADVANCED_OPTIONS_MODERATE', 'LOC_ADVANCED_OPTIONS_MODERATE_TOOLTIP', 30),
        ('ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_CATASTROPHIC', 'LOC_ADVANCED_OPTIONS_CATASTROPHIC', 'LOC_ADVANCED_OPTIONS_CATASTROPHIC_TOOLTIP', 40),
        ('ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_DISASTER_FREQUENCY_DESCRIPTION_CUSTOM', 50),
        ('ZG_DisasterAgeDomain', 'ZG_DISASTERS_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_DISASTER_SETTINGS_DESCRIPTION', 10),
        ('ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 'LOC_ADVANCED_OPTIONS_LIGHT', 'LOC_ADVANCED_OPTIONS_LIGHT_TOOLTIP', 20),
        ('ZG_DisasterAgeDomain', 'ZG_DISASTERS_MODERATE', 'LOC_ADVANCED_OPTIONS_MODERATE', 'LOC_ADVANCED_OPTIONS_MODERATE_TOOLTIP', 30),
        ('ZG_DisasterAgeDomain', 'ZG_DISASTERS_CATASTROPHIC', 'LOC_ADVANCED_OPTIONS_CATASTROPHIC', 'LOC_ADVANCED_OPTIONS_CATASTROPHIC_TOOLTIP', 40);

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
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_MORE', 30),
        ('ZG_SettlementLimitDomain', 'ZG_CUSTOM_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_CUSTOM', 40),
        ('ZG_SettlementDistanceDomain', 'ZG_LESS_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION_LESS', 10),
        ('ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlementDistanceDomain', 'ZG_MORE_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION_MORE', 30);


INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlementLimitAntiquity', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_3', 1, 'Game', 'SettlementLimitAntiquityKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 611),
        ('ZG_SettlementLimitExploration', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_8', 1, 'Game', 'SettlementLimitExplorationKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 612),
        ('ZG_SettlementLimitModern', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_16', 1, 'Game', 'SettlementLimitModernKey', 'SettlementOptions', 'MPAdvancedSettlementOptions', 0, 613);

-- 1-25 step by 1, then 30-75 step by 5.
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_1', 'LOC_ZG_NUM_1', 'LOC_ZG_NUM_1', 10),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_2', 'LOC_ZG_NUM_2', 'LOC_ZG_NUM_2', 20),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_3', 'LOC_ZG_NUM_3', 'LOC_ZG_NUM_3', 30),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_4', 'LOC_ZG_NUM_4', 'LOC_ZG_NUM_4', 40),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_5', 'LOC_ZG_NUM_5', 'LOC_ZG_NUM_5', 50),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_6', 'LOC_ZG_NUM_6', 'LOC_ZG_NUM_6', 60),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_7', 'LOC_ZG_NUM_7', 'LOC_ZG_NUM_7', 70),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_8', 'LOC_ZG_NUM_8', 'LOC_ZG_NUM_8', 80),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_9', 'LOC_ZG_NUM_9', 'LOC_ZG_NUM_9', 90),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_10', 'LOC_ZG_NUM_10', 'LOC_ZG_NUM_10', 100),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_11', 'LOC_ZG_NUM_11', 'LOC_ZG_NUM_11', 110),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_12', 'LOC_ZG_NUM_12', 'LOC_ZG_NUM_12', 120),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_13', 'LOC_ZG_NUM_13', 'LOC_ZG_NUM_13', 130),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_14', 'LOC_ZG_NUM_14', 'LOC_ZG_NUM_14', 140),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_15', 'LOC_ZG_NUM_15', 'LOC_ZG_NUM_15', 150),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_16', 'LOC_ZG_NUM_16', 'LOC_ZG_NUM_16', 160),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_17', 'LOC_ZG_NUM_17', 'LOC_ZG_NUM_17', 170),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_18', 'LOC_ZG_NUM_18', 'LOC_ZG_NUM_18', 180),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_19', 'LOC_ZG_NUM_19', 'LOC_ZG_NUM_19', 190),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_20', 'LOC_ZG_NUM_20', 'LOC_ZG_NUM_20', 200),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_21', 'LOC_ZG_NUM_21', 'LOC_ZG_NUM_21', 210),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_22', 'LOC_ZG_NUM_22', 'LOC_ZG_NUM_22', 220),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_23', 'LOC_ZG_NUM_23', 'LOC_ZG_NUM_23', 230),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_24', 'LOC_ZG_NUM_24', 'LOC_ZG_NUM_24', 240),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_25', 'LOC_ZG_NUM_25', 'LOC_ZG_NUM_25', 250),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_30', 'LOC_ZG_NUM_30', 'LOC_ZG_NUM_30', 300),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_35', 'LOC_ZG_NUM_35', 'LOC_ZG_NUM_35', 350),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_40', 'LOC_ZG_NUM_40', 'LOC_ZG_NUM_40', 400),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_45', 'LOC_ZG_NUM_45', 'LOC_ZG_NUM_45', 450),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_50', 'LOC_ZG_NUM_50', 'LOC_ZG_NUM_50', 500),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_55', 'LOC_ZG_NUM_55', 'LOC_ZG_NUM_55', 550),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_60', 'LOC_ZG_NUM_60', 'LOC_ZG_NUM_60', 600),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_65', 'LOC_ZG_NUM_65', 'LOC_ZG_NUM_65', 650),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_70', 'LOC_ZG_NUM_70', 'LOC_ZG_NUM_70', 700),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_75', 'LOC_ZG_NUM_75', 'LOC_ZG_NUM_75', 750);

--*******************************************************
--************* CRISIS SETTINGS *************************
--*******************************************************
-- In single player the crisis settings get their own group after the game and
-- difficulty settings, keeping them on the General tab while the disaster
-- settings show on the Map tab. The base Crises multiselect renders as a titled
-- list, so it must stay last in its group. Multiplayer grouping is unchanged.
UPDATE Parameters SET GroupId = 'CrisisOptions', SortIndex = 510, Name = 'LOC_ZG_CRISIS_SELECTION_NAME' WHERE ParameterID = 'Crises';

-- Master switch for crises. It drives the base per-crisis selection through
-- ui/zg-setup-rules.js, so the game applies it through its own ExcludeCrises key.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_Crises', 'LOC_ZG_CRISES_NAME', 'LOC_ZG_CRISES_DESCRIPTION', 'ZG_CrisesDomain', 'ZG_ENABLED', 1, 'Game', 'CrisesKey', 'CrisisOptions', 'MPAdvancedDisasterOptions', 0, 490);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_CrisesDomain', 'ZG_ENABLED', 'LOC_ZG_ENABLED_NAME', 'LOC_ZG_ENABLED_NAME', 10),
        ('ZG_CrisesDomain', 'ZG_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_DISABLED_NAME', 20);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_CrisisTiming', 'LOC_ZG_CRISIS_TIMING_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION', 'ZG_CrisisTimingDomain', 'ZG_DEFAULT_CRISIS_TIMING', 0, 'Game', 'CrisisTimingKey', 'CrisisOptions', 'MPAdvancedDisasterOptions', 0, 500);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_CrisisTimingDomain', 'ZG_DISABLED_CRISIS_TIMING', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_DISABLED', 10),
        ('ZG_CrisisTimingDomain', 'ZG_EARLY_CRISIS_TIMING', 'LOC_ZG_EARLY_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_EARLY', 20),
        ('ZG_CrisisTimingDomain', 'ZG_DEFAULT_CRISIS_TIMING', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_DEFAULT', 30),
        ('ZG_CrisisTimingDomain', 'ZG_LATE_CRISIS_TIMING', 'LOC_ZG_LATE_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_LATE', 40);


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
        ('ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_DEFAULT', 30),
        ('ZG_NaturalWonderCountDomain', 'ZG_MORE_NATURAL_WONDER_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_MORE', 40),
        ('ZG_NaturalWonderCountDomain', 'ZG_DOUBLE_NATURAL_WONDER_COUNT', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_NATURAL_WONDER_DESCRIPTION_DOUBLE', 50),
        ('ZG_LakeGenerationDomain', 'ZG_LESS_LAKE_GENERATION', 'LOC_ZG_LESS_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION_LESS', 20),
        ('ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION_DEFAULT', 30),
        ('ZG_LakeGenerationDomain', 'ZG_MORE_LAKE_GENERATION', 'LOC_ZG_MORE_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION_MORE', 40);

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
        ('ZG_NW_NachiFalls', 'LOC_FEATURE_NACHI_FALLS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWNachiFallsKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 315),
        ('ZG_NW_RedwoodForest', 'LOC_FEATURE_REDWOOD_FOREST_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWRedwoodForestKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 320),
        ('ZG_NW_SeongsanIlchulbong', 'LOC_FEATURE_SEONGSAN_ILCHULBONG_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWSeongsanIlchulbongKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 325),
        ('ZG_NW_Thera', 'LOC_FEATURE_THERA_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWTheraKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 330),
        ('ZG_NW_TorresDelPaine', 'LOC_FEATURE_TORRES_DEL_PAINE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWTorresDelPaineKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 340),
        ('ZG_NW_Uluru', 'LOC_FEATURE_ULURU_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWUluruKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 350),
        ('ZG_NW_ValleyOfFlowers', 'LOC_FEATURE_VALLEY_OF_FLOWERS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWValleyOfFlowersKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 360),
        ('ZG_NW_Vihren', 'LOC_FEATURE_VIHREN_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWVihrenKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 370),
        ('ZG_NW_Vinicunca', 'LOC_FEATURE_VINICUNCA_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWVinicuncaKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 380),
        ('ZG_NW_Zhangjiajie', 'LOC_FEATURE_ZHANGJIAJIE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWZhangjiajieKey', 'NaturalWonderSelectionOptions', 'MPAdvancedNaturalWonderSelectionOptions', 0, 390);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_WonderToggleDomain', 'ZG_ENABLED', 'LOC_ZG_ENABLED_NAME', 'LOC_ZG_ENABLED_NAME', 10),
        ('ZG_WonderToggleDomain', 'ZG_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_DISABLED_NAME', 20);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, GroupIDMultiplayerOverride, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_Rivers', 'LOC_ZG_RIVERS_NAME', 'LOC_ZG_RIVERS_DESCRIPTION','ZG_RiversDomain', 'ZG_DEFAULT_RIVERS', 0, 'Game', 'RiversKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1034),
        ('ZG_Mountains', 'LOC_ZG_MOUNTAINS_NAME', 'LOC_ZG_MOUNTAINS_DESCRIPTION','ZG_MountainsDomain', 'ZG_DEFAULT_MOUNTAINS', 0, 'Game', 'MountainsKey', 'MapOptions', 'MPAdvancedMapOptions', 0, 1035);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_RiversDomain', 'ZG_LESS_RIVERS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_LESS', 20),
        ('ZG_RiversDomain', 'ZG_DEFAULT_RIVERS', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_RIVERS_DESCRIPTION_DEFAULT', 30),
        ('ZG_RiversDomain', 'ZG_MORE_RIVERS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_MORE', 40);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_MountainsDomain', 'ZG_LESS_MOUNTAINS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_MOUNTAINS_DESCRIPTION_LESS', 20),
        ('ZG_MountainsDomain', 'ZG_DEFAULT_MOUNTAINS', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_MOUNTAINS_DESCRIPTION_DEFAULT', 30),
        ('ZG_MountainsDomain', 'ZG_MORE_MOUNTAINS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_MOUNTAINS_DESCRIPTION_MORE', 40);