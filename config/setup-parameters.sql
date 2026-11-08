--*******************************************************
--***************** SINGLE PLAYER ONLY ******************
--*******************************************************
-- This mod applies to single player only; multiplayer settings come from
-- Better Balanced Multiplayer. Every ZG_ parameter is closed to multiplayer at the end
-- of this file, so ZG_SinglePlayerSetup, a hidden flag, exists only in single
-- player: the queries and dependencies below and the modinfo's game criteria
-- key on it.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, Hidden, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SinglePlayerSetup', 'LOC_ZG_SINGLE_PLAYER_SETUP_NAME', '', 'bool', 1, 0, 'Game', 'ZGSinglePlayerSetup', 'GameOptions', 1, 0, 9000);

-- The base settings this mod changes are split the way the base game splits Map
-- and Game Speed: the row as shipped stays for multiplayer and hotseat, and a
-- single-player copy (SupportsSinglePlayer = 1) takes this file's changes.
-- SingleAgeGame and MementosEnabled are multiplayer-only in the base game, so
-- their copies open them to single player.
INSERT INTO Parameters (Key1, Key2, ParameterID, Name, Description, Domain, Hash, Array, DefaultValue, ConfigurationGroup, ConfigurationKey, DomainConfigurationKey, PossibleValuesConfigurationKey, ValueConfigurationKey, ValueNameConfigurationKey, ValueHashConfigurationKey, ValueDomainConfigurationKey, NameArrayConfigurationKey, GroupID, GroupIDMultiplayerOverride, Hidden, ReadOnly, SupportsSinglePlayer, SupportsLANMultiplayer, SupportsInternetMultiplayer, SupportsHotseatMultiplayer, IsUGC, ChangeableAfterGameStart, ChangeableAfterAgeTransition, UxHint, SortIndex)
SELECT Key1, Key2, ParameterID, Name, Description, Domain, Hash, Array, DefaultValue, ConfigurationGroup, ConfigurationKey, DomainConfigurationKey, PossibleValuesConfigurationKey, ValueConfigurationKey, ValueNameConfigurationKey, ValueHashConfigurationKey, ValueDomainConfigurationKey, NameArrayConfigurationKey, GroupID, NULL, Hidden, ReadOnly, 1, 0, 0, 0, IsUGC, ChangeableAfterGameStart, ChangeableAfterAgeTransition, UxHint, SortIndex
FROM Parameters
WHERE ParameterID IN ('AgeLength', 'Crises', 'IndependentHostility', 'LegacySets', 'MementosEnabled', 'SingleAgeGame') AND Key1 IS NULL;

UPDATE Parameters SET SupportsSinglePlayer = 0
WHERE ParameterID IN ('AgeLength', 'Crises', 'IndependentHostility', 'LegacySets', 'MementosEnabled', 'SingleAgeGame') AND Key1 IS NULL
AND (SupportsLANMultiplayer = 1 OR SupportsInternetMultiplayer = 1 OR SupportsHotseatMultiplayer = 1);

--*******************************************************
--***************** PARAMETER GROUPS ********************
--*******************************************************
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name)
    VALUES
        ('UnitOptions', 'LOC_GROUPID_ZG_UNITOPTIONS'),
        ('IndependentPowerOptions', 'LOC_GROUPID_ZG_INDEPENDENTPOWEROPTIONS'),
        ('SettlementOptions', 'LOC_GROUPID_ZG_SETTLEMENTOPTIONS'),
        ('NaturalWonderSelectionOptions', 'LOC_GROUPID_ZG_NATURALWONDERSELECTIONOPTIONS'),
        ('CrisisOptions', 'LOC_GROUPID_ZG_CRISISOPTIONS'),
        ('GamePacingOptions', 'LOC_GROUPID_ZG_GAMEPACINGOPTIONS'),
        ('PacingAntiquityOptions', 'LOC_AGE_ANTIQUITY_NAME'),
        ('PacingExplorationOptions', 'LOC_AGE_EXPLORATION_NAME'),
        ('PacingModernOptions', 'LOC_AGE_MODERN_NAME'),
        ('TerrainOptions', 'LOC_GROUPID_ZG_TERRAINOPTIONS'),
        ('MementoOptions', 'LOC_GROUPID_ZG_MEMENTOOPTIONS'),
        ('TradeOptions', 'LOC_GROUPID_ZG_TRADEOPTIONS');

-- The disaster group no longer holds the crisis settings, so it is renamed to
-- Disaster Settings. Only single player shows it: every base setting in it
-- carries a multiplayer group (MPAdvancedDisasterOptions).
UPDATE ParameterGroups SET Name = 'LOC_GROUPID_ZG_DISASTEROPTIONS' WHERE GroupID = 'DisasterOptions';

--*******************************************************
--***************** GAME SPEEDS *************************
--*******************************************************
-- Online 2.0 and Marathon 2.0 are retired but must still resolve for saves that
-- use them. ZG_RetiredGameSpeeds is a domain nothing reads, so the rows stay
-- resolvable but out of the Game Speed dropdown (which reads StandardGameSpeeds).
-- The speeds themselves are in data/game-speeds/new-game-speeds.sql.
INSERT OR IGNORE INTO GameSpeeds (Domain, GameSpeedType, Name, Description, SortIndex)
    VALUES
        ('ZG_RetiredGameSpeeds', 'GAMESPEED_ZG_MARATHON_2', 'LOC_ZG_GAMESPEED_MARATHON_2_NAME', 'LOC_ZG_GAMESPEED_MARATHON_2_DESCRIPTION', 60),
        ('ZG_RetiredGameSpeeds', 'GAMESPEED_ZG_ONLINE_2', 'LOC_ZG_GAMESPEED_ONLINE_2_NAME', 'LOC_ZG_GAMESPEED_ONLINE_2_DESCRIPTION', 5);

--*******************************************************
--***************** AGE LENGTH *************************
--*******************************************************
-- The base Age Length setting moves to the Pace tab, gains Swift, Balanced,
-- Extended and Custom, and drives the per-age Age Length rows
-- (zg-setup-rules.js). Each option applies a data/ages file that sets the
-- same point total for every base length, so the engine's own choice never
-- changes the result; Custom applies the per-age rows' files instead. The
-- options live in ZG_AgeLengthDomain, the base lengths with this mod's
-- descriptions and the four above, which only the single-player copy reads.
UPDATE Parameters SET GroupId = 'GamePacingOptions', SortIndex = 30, Domain = 'ZG_AgeLengthDomain' WHERE ParameterID = 'AgeLength' AND SupportsSinglePlayer = 1;

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_AGE_LENGTH_SWIFT_DESC', 7),
        ('ZG_AgeLengthDomain', 'AGE_LENGTH_ABBREVIATED', 'LOC_ADVANCED_OPTIONS_ABBREVIATED', 'LOC_ZG_AGE_LENGTH_ABBREVIATED_DESC', 10),
        ('ZG_AgeLengthDomain', 'AGE_LENGTH_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_AGE_LENGTH_STANDARD_DESC', 20),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_AGE_LENGTH_BALANCED_DESC', 25),
        ('ZG_AgeLengthDomain', 'AGE_LENGTH_LONG', 'LOC_ADVANCED_OPTIONS_LONG', 'LOC_ZG_AGE_LENGTH_LONG_DESC', 30),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_AGE_LENGTH_EXTENDED_DESC', 37),
        ('ZG_AgeLengthDomain', 'ZG_AGE_LENGTH_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_AGE_LENGTH_CUSTOM_DESC', 40);

--*******************************************************
--***************** UNIT SETTINGS ********************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlerMovementSpeed', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION', 'ZG_SettlerMovementDomain','ZG_SETTLER_MOVES_DEFAULT', 1, 'Game', 'SettlerMovementKey', 'UnitOptions', 0, 4800),
        ('ZG_TreasureMovementSpeed', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION', 'ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 1, 'Game','TreasureMovementKey', 'UnitOptions', 0, 4801),
        ('ZG_CombatUnitCost', 'LOC_ZG_COMBAT_UNIT_COST_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION', 'ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_STANDARD', 1, 'Game','CombatUnitCostKey', 'UnitOptions', 0, 4802),
        ('ZG_CivilianUnitCost', 'LOC_ZG_CIVILIAN_UNIT_COST_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION', 'ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_STANDARD', 1, 'Game','CivilianUnitCostKey', 'UnitOptions', 0, 4803);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_SLOW', 10),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_DEFAULT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_QUICK', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_QUICK', 30),
        ('ZG_SettlerMovementDomain', 'ZG_SETTLER_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_SETTLER_MOVEMENT_SPEED_DESCRIPTION_FAST', 40),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_SLOW', 10),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_DEFAULT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_DEFAULT', 20),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_QUICK', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_QUICK', 30),
        ('ZG_TreasureMovementDomain', 'ZG_TREASURE_MOVES_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_TREASURE_MOVEMENT_SPEED_DESCRIPTION_FAST', 40),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_LOW', 10),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_MEDIUM', 'LOC_ZG_MEDIUM_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_MEDIUM', 25),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_HIGH', 30),
        ('ZG_CombatUnitCostDomain', 'ZG_COMBAT_UNIT_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_COMBAT_UNIT_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_LOW', 10),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_MEDIUM', 'LOC_ZG_MEDIUM_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_MEDIUM', 25),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_HIGH', 30),
        ('ZG_CivilianUnitCostDomain', 'ZG_CIVILIAN_UNIT_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_CIVILIAN_UNIT_COST_DESCRIPTION_DOUBLE', 40);


--*******************************************************
--************* INDEPENDENT POWER SETTINGS **************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_IndependentCount', 'LOC_ZG_INDEPENDENT_COUNT_NAME', 'LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION','ZG_IndependentCountDomain', 'ZG_DEFAULT_INDEPENDENTS', 1, 'Game', 'IndependentCountKey', 'IndependentPowerOptions', 0, 4701),
        ('ZG_IndependentSpace', 'LOC_ZG_INDEPENDENT_SPACE_NAME', 'LOC_ZG_INDEPENDENT_SPACE_DESCRIPTION','ZG_IndependentSpaceDomain', 'ZG_DEFAULT_INDEPENDENTS_SPACING', 1, 'Game', 'IndependentSpaceKey', 'IndependentPowerOptions', 0, 4702),
        ('ZG_IndependentAggression', 'LOC_ZG_INDEPENDENT_AGGRESSION_NAME', 'LOC_ZG_INDEPENDENT_AGGRESSION_DESCRIPTION','ZG_IndependentAggressionDomain', 'ZG_DEFAULT_AGGRESSION', 1, 'Game', 'IndependentAggressionKey', 'IndependentPowerOptions', 0, 4703);

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
-- themselves hold a real memento rolled by zg-player-tab.js.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_PlayerRandomMementos', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 'ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_NONE', 0, 'Player', 'ZGRandomMementos', 'PlayerOptions', 0, 3040);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_NONE', 'LOC_ZG_NONE_NAME', '', 10),
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_MAJOR', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 20),
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_MINOR', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 30),
        ('ZG_RandomMementosDomain', 'ZG_RANDOM_MEMENTOS_BOTH', 'LOC_ZG_RANDOM_MEMENTOS_NAME', '', 40);

-- Memento Settings gathers every memento control, the base Mementos toggle
-- included. The toggle is multiplayer-only in the base game; its single-player
-- copy (see the top of this file) lets a single-player game turn mementos off.
-- AI Mementos (applied by zg-player-tab.js) follows it.
--
-- Groups appear in the order their first setting does. On the General tab the
-- base game's groups come first (Game Settings, Difficulty, Triumph Settings
-- at 180, Crisis Settings at 490, Victory Settings at 4000), then this mod's
-- from 4500 (Memento, Settlement, Independent Power, Unit, Trade Settings),
-- and Civilization Selection stays last at 5020, where the base game has it.
UPDATE Parameters SET GroupId = 'MementoOptions', SortIndex = 4500 WHERE ParameterID = 'MementosEnabled' AND SupportsSinglePlayer = 1;

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_AIMementos', 'LOC_ZG_AI_MEMENTOS_NAME', 'LOC_ZG_AI_MEMENTOS_DESCRIPTION', 'ZG_AIMementosDomain', 'ZG_AI_MEMENTOS_NONE', 1, 'Game', 'AIMementosKey', 'MementoOptions', 0, 4501);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_AIMementosDomain', 'ZG_AI_MEMENTOS_NONE', 'LOC_ZG_NONE_NAME', 'LOC_ZG_AI_MEMENTOS_DESCRIPTION_NONE', 10),
        ('ZG_AIMementosDomain', 'ZG_AI_MEMENTOS_RANDOM', 'LOC_ADVANCED_OPTIONS_RANDOM', 'LOC_ZG_AI_MEMENTOS_DESCRIPTION_RANDOM', 20),
        ('ZG_AIMementosDomain', 'ZG_AI_MEMENTOS_LEADER', 'LOC_ZG_AI_MEMENTOS_LEADER_NAME', 'LOC_ZG_AI_MEMENTOS_DESCRIPTION_LEADER', 30),
        ('ZG_AIMementosDomain', 'ZG_AI_MEMENTOS_CIVILIZATION', 'LOC_ZG_AI_MEMENTOS_CIVILIZATION_NAME', 'LOC_ZG_AI_MEMENTOS_DESCRIPTION_CIVILIZATION', 40);

-- What becomes of those slots when an age turns over. Maintain is the base
-- game's behavior and so the default. Adapt re-draws each AI's slots through the
-- AI Mementos setting above, which is the first point where that setting's
-- Leader Match and Civilization Match can reach an AI at all: both stay RANDOM
-- for the whole setup screen and are only resolved once the game runs.
--
-- Neither option needs guarding against AI Mementos being None. Maintain keeps
-- whatever an AI holds, which is nothing; Adapt re-applies that same setting,
-- which draws nothing. Both stay truthful on their own, so there is no sentinel
-- value and no rule tying the two settings together.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_AgeTransitionMementos', 'LOC_ZG_AGE_TRANSITION_MEMENTOS_NAME', 'LOC_ZG_AGE_TRANSITION_MEMENTOS_DESCRIPTION', 'ZG_AgeTransitionMementosDomain', 'ZG_AGE_TRANSITION_MEMENTOS_MAINTAIN', 1, 'Game', 'AgeTransitionMementosKey', 'MementoOptions', 0, 4502);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_AgeTransitionMementosDomain', 'ZG_AGE_TRANSITION_MEMENTOS_MAINTAIN', 'LOC_ZG_AGE_TRANSITION_MEMENTOS_MAINTAIN_NAME', 'LOC_ZG_AGE_TRANSITION_MEMENTOS_DESCRIPTION_MAINTAIN', 20),
        ('ZG_AgeTransitionMementosDomain', 'ZG_AGE_TRANSITION_MEMENTOS_ADAPT', 'LOC_ZG_AGE_TRANSITION_MEMENTOS_ADAPT_NAME', 'LOC_ZG_AGE_TRANSITION_MEMENTOS_DESCRIPTION_ADAPT', 30);

-- A fifth value for the game's own AI Civ Selection, Age Transition setting.
-- The engine decides the AI's civilizations for the four values it knows; this
-- one it does not know, so zg-age-transition-civs.js writes every AI's
-- civilization itself just before the next age starts, from the leader's
-- associations in LeaderCivilizationBias: Historical by Bias, else Geographic,
-- never Strategic; taken ones passed over, duplicates last; ties to the age's
-- own civilization. The AI persists when its pick is the civilization it holds.
-- Filtered out of every setup but single player.
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('AgeTransitionCivSelectionMode', 'AGE_TRANSITION_CIV_SELECTION_MODE_ZG_HISTORICAL', 'LOC_ZG_CIV_CHOICE_HISTORICAL', 'LOC_ZG_AGE_TRANSITION_CIVS_DESCRIPTION_HISTORICAL', 5);

INSERT OR IGNORE INTO Queries (QueryID, Type, SQL)
    VALUES ('ZGSinglePlayerCivSelection', 'DomainValueFilters', 'SELECT ''AgeTransitionCivSelectionMode'' AS Domain, ''AGE_TRANSITION_CIV_SELECTION_MODE_ZG_HISTORICAL'' AS Value, ''Difference'' AS Filter');

INSERT OR IGNORE INTO QueryCriteria (QueryID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
    VALUES ('ZGSinglePlayerCivSelection', 'Game', 'ZGSinglePlayerSetup', 'NotEquals', 1);

--*******************************************************
--************* PACE SET *******************************
--*******************************************************
-- Preset selector in Game Settings, after Rule Set, mirrored by ZG_PaceSetMirror
-- at the top of Pace Settings on the Pace tab. Each preset sets the Pace
-- Settings to the values it stands for (zg-setup-rules.js); changing one of
-- them afterwards switches the preset to Custom.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_PacePreset', 'LOC_ZG_PACE_PRESET_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION', 'ZG_PacePresetDomain', 'ZG_PACE_PRESET_STANDARD', 1, 'Game', 'PacePresetKey', 'GameOptions', 0, 15),
        ('ZG_PaceSetMirror', 'LOC_ZG_PACE_PRESET_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION', 'ZG_PacePresetDomain', 'ZG_PACE_PRESET_STANDARD', 1, 'Game', 'PaceSetMirrorKey', 'GamePacingOptions', 0, 28);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_SWIFT', 'LOC_ZG_PACE_PRESET_SWIFT_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_SWIFT', 5),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_STANDARD', 'LOC_ZG_PACE_PRESET_STANDARD_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_STANDARD', 10),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_BALANCED', 'LOC_ZG_PACE_PRESET_BALANCED_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_BALANCED', 20),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_EXTENDED', 'LOC_ZG_PACE_PRESET_EXTENDED_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_EXTENDED', 25),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_MULTIPLAYER', 'LOC_ZG_PACE_PRESET_MULTIPLAYER_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_MULTIPLAYER', 30),
        ('ZG_PacePresetDomain', 'ZG_PACE_PRESET_CUSTOM', 'LOC_ZG_PACE_PRESET_CUSTOM_NAME', 'LOC_ZG_PACE_PRESET_DESCRIPTION_CUSTOM', 40);

--*******************************************************
--************* PACE SETTINGS ***************************
--*******************************************************
-- Shown on the Pace tab (zg-map-tab.js): All Ages holds the primaries
-- (Age Length above and the settings below); the Antiquity,
-- Exploration, and Modern groups hold each setting's per-age row, used when the
-- primary is Custom and synced by zg-setup-rules.js.

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_AgeLengthAntiquity', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeLengthAgeDomain', 'ZG_AL_140', 1, 'Game', 'AgeLengthAntiquityKey', 'PacingAntiquityOptions', 0, 100),
        ('ZG_AgeLengthExploration', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeLengthAgeDomain', 'ZG_AL_140', 1, 'Game', 'AgeLengthExplorationKey', 'PacingExplorationOptions', 0, 110),
        ('ZG_AgeLengthModern', 'LOC_ADVANCED_OPTIONS_AGE_LENGTH', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeLengthAgeDomain', 'ZG_AL_140', 1, 'Game', 'AgeLengthModernKey', 'PacingModernOptions', 0, 120),
        ('ZG_AgeProgressRate', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION', 'ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateKey', 'GamePacingOptions', 0, 32),
        ('ZG_AgeProgressRateAntiquity', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateAntiquityKey', 'PacingAntiquityOptions', 0, 101),
        ('ZG_AgeProgressRateExploration', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateExplorationKey', 'PacingExplorationOptions', 0, 111),
        ('ZG_AgeProgressRateModern', 'LOC_ZG_AGE_PROGRESS_RATE_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 1, 'Game', 'AgeProgressRateModernKey', 'PacingModernOptions', 0, 121),
        ('ZG_TechnologyCost', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION', 'ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostKey', 'GamePacingOptions', 0, 36),
        ('ZG_TechnologyCostAntiquity', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostAntiquityKey', 'PacingAntiquityOptions', 0, 102),
        ('ZG_TechnologyCostExploration', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostExplorationKey', 'PacingExplorationOptions', 0, 112),
        ('ZG_TechnologyCostModern', 'LOC_ZG_TECHNOLOGY_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 1, 'Game', 'TechnologyCostModernKey', 'PacingModernOptions', 0, 122),
        ('ZG_CivicCost', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION', 'ZG_CivicCostDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostKey', 'GamePacingOptions', 0, 40),
        ('ZG_CivicCostAntiquity', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostAntiquityKey', 'PacingAntiquityOptions', 0, 103),
        ('ZG_CivicCostExploration', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostExplorationKey', 'PacingExplorationOptions', 0, 113),
        ('ZG_CivicCostModern', 'LOC_ZG_CIVIC_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 1, 'Game', 'CivicCostModernKey', 'PacingModernOptions', 0, 123),
        ('ZG_BuildingCost', 'LOC_ZG_BUILDING_COST_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION', 'ZG_BuildingCostDomain', 'ZG_BUILDING_COST_STANDARD', 1, 'Game', 'BuildingCostKey', 'GamePacingOptions', 0, 42),
        ('ZG_BuildingCostAntiquity', 'LOC_ZG_BUILDING_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_STANDARD', 1, 'Game', 'BuildingCostAntiquityKey', 'PacingAntiquityOptions', 0, 104),
        ('ZG_BuildingCostExploration', 'LOC_ZG_BUILDING_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_STANDARD', 1, 'Game', 'BuildingCostExplorationKey', 'PacingExplorationOptions', 0, 114),
        ('ZG_BuildingCostModern', 'LOC_ZG_BUILDING_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_STANDARD', 1, 'Game', 'BuildingCostModernKey', 'PacingModernOptions', 0, 124),
        ('ZG_CityGrowth', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION', 'ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthKey', 'GamePacingOptions', 0, 46),
        ('ZG_CityGrowthAntiquity', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthAntiquityKey', 'PacingAntiquityOptions', 0, 106),
        ('ZG_CityGrowthExploration', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthExplorationKey', 'PacingExplorationOptions', 0, 116),
        ('ZG_CityGrowthModern', 'LOC_ZG_CITY_GROWTH_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 1, 'Game', 'CityGrowthModernKey', 'PacingModernOptions', 0, 126),
        ('ZG_Roads', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_ROADS_DESCRIPTION', 'ZG_RoadsDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsKey', 'GamePacingOptions', 0, 48),
        ('ZG_RoadsAntiquity', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsAntiquityKey', 'PacingAntiquityOptions', 0, 107),
        ('ZG_RoadsExploration', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsExplorationKey', 'PacingExplorationOptions', 0, 117),
        ('ZG_RoadsModern', 'LOC_ZG_ROADS_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 1, 'Game', 'RoadsModernKey', 'PacingModernOptions', 0, 127),
        ('ZG_VictoryProjectCost', 'LOC_ZG_VICTORY_PROJECT_COST_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION', 'ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 1, 'Game', 'VictoryProjectCostKey', 'GamePacingOptions', 0, 44),
        ('ZG_VictoryProjectCostAntiquity', 'LOC_ZG_VICTORY_PROJECT_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 1, 'Game', 'VictoryProjectCostAntiquityKey', 'PacingAntiquityOptions', 0, 105),
        ('ZG_VictoryProjectCostExploration', 'LOC_ZG_VICTORY_PROJECT_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 1, 'Game', 'VictoryProjectCostExplorationKey', 'PacingExplorationOptions', 0, 115),
        ('ZG_VictoryProjectCostModern', 'LOC_ZG_VICTORY_PROJECT_COST_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 1, 'Game', 'VictoryProjectCostModernKey', 'PacingModernOptions', 0, 125);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_90', 'LOC_ZG_NUM_90', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_90', 10),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_100', 'LOC_ZG_NUM_100', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_100', 20),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_110', 'LOC_ZG_NUM_110', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_110', 30),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_120', 'LOC_ZG_NUM_120', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_120', 40),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_130', 'LOC_ZG_NUM_130', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_130', 50),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_140', 'LOC_ZG_NUM_140', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_140', 60),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_150', 'LOC_ZG_NUM_150', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_150', 70),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_160', 'LOC_ZG_NUM_160', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_160', 100),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_170', 'LOC_ZG_NUM_170', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_170', 120),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_180', 'LOC_ZG_NUM_180', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_180', 130),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_190', 'LOC_ZG_NUM_190', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_190', 140),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_200', 'LOC_ZG_NUM_200', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_200', 160),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_220', 'LOC_ZG_NUM_220', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_220', 170),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_240', 'LOC_ZG_NUM_240', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_240', 180),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_260', 'LOC_ZG_NUM_260', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_260', 190),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_280', 'LOC_ZG_NUM_280', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_280', 200),
        ('ZG_AgeLengthAgeDomain', 'ZG_AL_300', 'LOC_ZG_NUM_300', 'LOC_ZG_AGE_LENGTH_POINTS_DESC_300', 210),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_SLOW', 10),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_STANDARD', 20),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_BALANCED', 30),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_DESCRIPTION_FAST', 40),
        ('ZG_AgeProgressRateDomain', 'ZG_AGE_PROGRESS_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_AGE_DESC_SLOW', 10),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_AGE_PROGRESS_RATE_AGE_DESC_STANDARD', 20),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_AGE_DESC_BALANCED', 30),
        ('ZG_AgeProgressRateAgeDomain', 'ZG_AGE_PROGRESS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_AGE_PROGRESS_RATE_AGE_DESC_FAST', 40),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_LOW', 10),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_MEDIUM', 'LOC_ZG_MEDIUM_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_MEDIUM', 25),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_HIGH', 30),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_SWIFT', 43),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_BALANCED', 45),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_TECHNOLOGY_COST_DESCRIPTION_EXTENDED', 47),
        ('ZG_TechnologyCostDomain', 'ZG_TECHNOLOGY_COST_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_TECHNOLOGY_COST_AGE_DESC_MINUS_25', 10),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_25', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_TECHNOLOGY_COST_AGE_DESC_PLUS_25', 30),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_TECHNOLOGY_COST_AGE_DESC_PLUS_50', 60),
        ('ZG_TechnologyCostAgeDomain', 'ZG_TECHNOLOGY_COST_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_TECHNOLOGY_COST_AGE_DESC_PLUS_100', 100),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_LOW', 10),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_MEDIUM', 'LOC_ZG_MEDIUM_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_MEDIUM', 25),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_HIGH', 30),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_SWIFT', 43),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_BALANCED', 45),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_CIVIC_COST_DESCRIPTION_EXTENDED', 47),
        ('ZG_CivicCostDomain', 'ZG_CIVIC_COST_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_CIVIC_COST_AGE_DESC_MINUS_25', 10),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_25', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_CIVIC_COST_AGE_DESC_PLUS_25', 30),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_CIVIC_COST_AGE_DESC_PLUS_50', 60),
        ('ZG_CivicCostAgeDomain', 'ZG_CIVIC_COST_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_CIVIC_COST_AGE_DESC_PLUS_100', 100),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_LOW', 10),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_MEDIUM', 'LOC_ZG_MEDIUM_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_MEDIUM', 25),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_HIGH', 30),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_SWIFT', 43),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_BALANCED', 45),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_BUILDING_COST_DESCRIPTION_EXTENDED', 47),
        ('ZG_BuildingCostDomain', 'ZG_BUILDING_COST_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_BUILDING_COST_AGE_DESC_MINUS_25', 10),
        ('ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_PLUS_25', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_BUILDING_COST_AGE_DESC_PLUS_25', 30),
        ('ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_BUILDING_COST_AGE_DESC_PLUS_50', 60),
        ('ZG_BuildingCostAgeDomain', 'ZG_BUILDING_COST_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_BUILDING_COST_AGE_DESC_PLUS_100', 100),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SLOW', 10),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_STANDARD', 20),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_QUICK', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_QUICK', 30),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_FAST', 40),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SWIFT', 43),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_BALANCED', 45),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_EXTENDED', 47),
        ('ZG_CityGrowthDomain', 'ZG_CITY_GROWTH_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_SLOW', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_SLOW', 10),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_STANDARD', 20),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_QUICK', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_QUICK', 30),
        ('ZG_CityGrowthAgeDomain', 'ZG_CITY_GROWTH_FAST', 'LOC_ZG_PCT_MINUS_50', 'LOC_ZG_CITY_GROWTH_DESCRIPTION_FAST', 40),
        ('ZG_RoadsDomain', 'ZG_ROADS_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_ROADS_DESCRIPTION_SLOW', 10),
        ('ZG_RoadsDomain', 'ZG_ROADS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_ROADS_DESCRIPTION_STANDARD', 20),
        ('ZG_RoadsDomain', 'ZG_ROADS_QUICK', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_ROADS_DESCRIPTION_QUICK', 30),
        ('ZG_RoadsDomain', 'ZG_ROADS_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_ROADS_DESCRIPTION_FAST', 40),
        ('ZG_RoadsDomain', 'ZG_ROADS_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_ROADS_DESCRIPTION_SWIFT', 43),
        ('ZG_RoadsDomain', 'ZG_ROADS_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_ROADS_DESCRIPTION_BALANCED', 45),
        ('ZG_RoadsDomain', 'ZG_ROADS_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_ROADS_DESCRIPTION_EXTENDED', 47),
        ('ZG_RoadsDomain', 'ZG_ROADS_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_SLOW', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_ROADS_DESCRIPTION_SLOW', 10),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_ROADS_DESCRIPTION_STANDARD', 20),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_QUICK', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_ROADS_DESCRIPTION_QUICK', 30),
        ('ZG_RoadsAgeDomain', 'ZG_ROADS_FAST', 'LOC_ZG_PCT_MINUS_50', 'LOC_ZG_ROADS_DESCRIPTION_FAST', 40),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_LOW', 'LOC_ZG_LOW_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_LOW', 10),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_MEDIUM', 'LOC_ZG_MEDIUM_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_MEDIUM', 25),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_HIGH', 'LOC_ZG_HIGH_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_HIGH', 30),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_DOUBLE', 'LOC_ZG_DOUBLE_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_DOUBLE', 40),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_SWIFT', 43),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_BALANCED', 45),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_VICTORY_PROJECT_COST_DESCRIPTION_EXTENDED', 47),
        ('ZG_VictoryProjectCostDomain', 'ZG_VICTORY_PROJECT_COST_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 50),
        ('ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_VICTORY_PROJECT_COST_AGE_DESC_MINUS_25', 10),
        ('ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_COST_DESCRIPTION_STANDARD', 20),
        ('ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_PLUS_25', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_VICTORY_PROJECT_COST_AGE_DESC_PLUS_25', 35),
        ('ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_VICTORY_PROJECT_COST_AGE_DESC_PLUS_50', 40),
        ('ZG_VictoryProjectCostAgeDomain', 'ZG_VICTORY_PROJECT_COST_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_VICTORY_PROJECT_COST_AGE_DESC_PLUS_100', 50);

--*******************************************************
--************* INDEPENDENT HOSTILITY *******************
--*******************************************************
-- The base Initial Independent Hostility setting belongs with the other
-- Independent Power settings.
UPDATE Parameters SET GroupId = 'IndependentPowerOptions', SortIndex = 4700 WHERE ParameterID = 'IndependentHostility' AND SupportsSinglePlayer = 1;

--*******************************************************
--************* TRIUMPH SETS ****************************
--*******************************************************
-- Adds Custom to the base Triumph Set setting. While Custom is selected the
-- engine reads the ZG_LEGACY_SET_CUSTOM set, which data/triumphs fills with
-- the set chosen for the age being played. Filtered out of every setup but
-- single player.
INSERT OR IGNORE INTO LegacySets (LegacySetType, Name, Description, SortIndex)
    VALUES
        ('ZG_LEGACY_SET_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_TRIUMPH_SET_DESCRIPTION_CUSTOM', 5);

INSERT OR IGNORE INTO Queries (QueryID, Type, SQL)
    VALUES ('ZGSinglePlayerLegacySets', 'DomainValueFilters', 'SELECT ''StandardLegacySets'' AS Domain, ''ZG_LEGACY_SET_CUSTOM'' AS Value, ''Difference'' AS Filter');

INSERT OR IGNORE INTO QueryCriteria (QueryID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
    VALUES ('ZGSinglePlayerLegacySets', 'Game', 'ZGSinglePlayerSetup', 'NotEquals', 1);

-- The base Triumph Set moves from 10 to 180, after Game Settings and
-- Difficulty, with the per-age rows right behind it.
UPDATE Parameters SET SortIndex = 180 WHERE ParameterID = 'LegacySets' AND SupportsSinglePlayer = 1;

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_TriumphSetAntiquity', 'LOC_AGE_ANTIQUITY_NAME', 'LOC_ZG_TRIUMPH_SET_AGE_DESCRIPTION', 'ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 1, 'Game', 'TriumphSetAntiquityKey', 'TriumphSettings', 0, 181),
        ('ZG_TriumphSetExploration', 'LOC_AGE_EXPLORATION_NAME', 'LOC_ZG_TRIUMPH_SET_AGE_DESCRIPTION', 'ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 1, 'Game', 'TriumphSetExplorationKey', 'TriumphSettings', 0, 182),
        ('ZG_TriumphSetModern', 'LOC_AGE_MODERN_NAME', 'LOC_ZG_TRIUMPH_SET_AGE_DESCRIPTION', 'ZG_TriumphSetAgeDomain', 'ZG_TRIUMPHS_DEFAULT', 1, 'Game', 'TriumphSetModernKey', 'TriumphSettings', 0, 183);

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
-- Custom. The base parameter is hidden in single player, through a dependency
-- on ZG_SinglePlayerSetup; each option below sets every intensity tier to its
-- frequencies, so whichever intensity the engine sees gives the same result.
-- Custom uses the per-age settings that follow.
INSERT OR IGNORE INTO ParameterDependencies (ParameterID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
    VALUES ('DisasterIntensity', 'Game', 'ZGSinglePlayerSetup', 'NotEquals', 1);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_DisasterFrequency', 'LOC_ZG_DISASTER_SETTINGS_NAME', 'LOC_ADVANCED_OPTIONS_DISASTER_INTENSITY_DESC', 'ZG_DisasterFrequencyDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisasterFrequencyKey', 'DisasterOptions', 0, 3010),
        ('ZG_DisastersAntiquity', 'LOC_AGE_ANTIQUITY_NAME', 'LOC_ZG_DISASTER_AGE_DESCRIPTION', 'ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisastersAntiquityKey', 'DisasterOptions', 0, 3011),
        ('ZG_DisastersExploration', 'LOC_AGE_EXPLORATION_NAME', 'LOC_ZG_DISASTER_AGE_DESCRIPTION', 'ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisastersExplorationKey', 'DisasterOptions', 0, 3012),
        ('ZG_DisastersModern', 'LOC_AGE_MODERN_NAME', 'LOC_ZG_DISASTER_AGE_DESCRIPTION', 'ZG_DisasterAgeDomain', 'ZG_DISASTERS_LIGHT', 1, 'Game', 'DisastersModernKey', 'DisasterOptions', 0, 3013);

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
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES

        ('ZG_SettlementLimit', 'LOC_ZG_SETTLEMENT_LIMIT_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION','ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 1, 'Game', 'SettlementLimitKey', 'SettlementOptions', 0, 4610),
        ('ZG_SettlementDistance', 'LOC_ZG_SETTLEMENT_DISTANCE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION','ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 1, 'Game', 'SettlementDistanceKey', 'SettlementOptions', 0, 4600);


INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlementLimitDomain', 'ZG_LESS_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_LESS', 10),
        ('ZG_SettlementLimitDomain', 'ZG_DEFAULT_SETTLEMENT_LIMIT_COUNT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlementLimitDomain', 'ZG_MORE_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_MORE', 30),
        ('ZG_SettlementLimitDomain', 'ZG_CUSTOM_SETTLEMENT_LIMIT_COUNT', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_DESCRIPTION_CUSTOM', 40),
        ('ZG_SettlementDistanceDomain', 'ZG_LESS_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_LESS_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION_LESS', 10),
        ('ZG_SettlementDistanceDomain', 'ZG_DEFAULT_SETTLEMENT_DISTANCE_COUNT', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION_DEFAULT', 20),
        ('ZG_SettlementDistanceDomain', 'ZG_MORE_SETTLEMENT_DISTANCE_COUNT', 'LOC_ZG_MORE_NAME', 'LOC_ZG_SETTLEMENT_DISTANCE_DESCRIPTION_MORE', 30);

-- Trade Range scales each age's land and sea trade range (TradeSystemParameterSets),
-- one value for all three ages or, on Custom, a row per age.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_TradeRange', 'LOC_ZG_TRADE_RANGE_NAME', 'LOC_ZG_TRADE_RANGE_DESCRIPTION', 'ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_STANDARD', 1, 'Game', 'TradeRangeKey', 'TradeOptions', 0, 4900),
        ('ZG_TradeRangeAntiquity', 'LOC_AGE_ANTIQUITY_NAME', 'LOC_ZG_TRADE_RANGE_AGE_DESCRIPTION', 'ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_STANDARD', 1, 'Game', 'TradeRangeAntiquityKey', 'TradeOptions', 0, 4901),
        ('ZG_TradeRangeExploration', 'LOC_AGE_EXPLORATION_NAME', 'LOC_ZG_TRADE_RANGE_AGE_DESCRIPTION', 'ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_STANDARD', 1, 'Game', 'TradeRangeExplorationKey', 'TradeOptions', 0, 4902),
        ('ZG_TradeRangeModern', 'LOC_AGE_MODERN_NAME', 'LOC_ZG_TRADE_RANGE_AGE_DESCRIPTION', 'ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_STANDARD', 1, 'Game', 'TradeRangeModernKey', 'TradeOptions', 0, 4903);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_MINUS_50', 'LOC_ZG_PCT_MINUS_50', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_MINUS_50', 10),
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_MINUS_25', 20),
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_STANDARD', 30),
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_PLUS_25', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_PLUS_25', 40),
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_PLUS_50', 50),
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_PLUS_100', 60),
        ('ZG_TradeRangeDomain', 'ZG_TRADE_RANGE_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_CUSTOM', 70),
        ('ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_MINUS_50', 'LOC_ZG_PCT_MINUS_50', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_MINUS_50', 10),
        ('ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_MINUS_25', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_MINUS_25', 20),
        ('ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_STANDARD', 30),
        ('ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_PLUS_25', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_PLUS_25', 40),
        ('ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_PLUS_50', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_PLUS_50', 50),
        ('ZG_TradeRangeAgeDomain', 'ZG_TRADE_RANGE_PLUS_100', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_TRADE_RANGE_DESCRIPTION_PLUS_100', 60);

-- Trade Speed: how Merchants start trade routes, by travelling at a set
-- movement or from a distance (Instant), as the Modern Age does by default.
-- One value for every age or, on Custom, a row per age (Pace tab).
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_TradeSpeed', 'LOC_ZG_TRADE_SPEED_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION', 'ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_STANDARD', 1, 'Game', 'TradeSpeedKey', 'GamePacingOptions', 0, 50),
        ('ZG_TradeSpeedAntiquity', 'LOC_ZG_TRADE_SPEED_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_STANDARD', 1, 'Game', 'TradeSpeedAntiquityKey', 'PacingAntiquityOptions', 0, 108),
        ('ZG_TradeSpeedExploration', 'LOC_ZG_TRADE_SPEED_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_STANDARD', 1, 'Game', 'TradeSpeedExplorationKey', 'PacingExplorationOptions', 0, 118),
        ('ZG_TradeSpeedModern', 'LOC_ZG_TRADE_SPEED_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_INSTANT', 1, 'Game', 'TradeSpeedModernKey', 'PacingModernOptions', 0, 128);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_SLOW', 'LOC_ZG_SLOW_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_SLOW', 10),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_DEFAULT', 20),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_QUICK', 'LOC_ZG_QUICK_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_QUICK', 30),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_FAST', 'LOC_ZG_FAST_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_FAST', 40),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_INSTANT', 'LOC_ZG_INSTANT_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_INSTANT', 50),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_SWIFT', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_SWIFT', 53),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_BALANCED', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_BALANCED', 55),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_EXTENDED', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_EXTENDED', 57),
        ('ZG_TradeSpeedDomain', 'ZG_TRADE_SPEED_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 60),
        ('ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_SLOW', 'LOC_ZG_PCT_MINUS_25', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_SLOW', 10),
        ('ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_STANDARD', 20),
        ('ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_QUICK', 'LOC_ZG_PCT_PLUS_25', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_QUICK', 30),
        ('ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_FAST', 'LOC_ZG_PCT_PLUS_50', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_FAST', 40),
        ('ZG_TradeSpeedAgeDomain', 'ZG_TRADE_SPEED_INSTANT', 'LOC_ZG_INSTANT_NAME', 'LOC_ZG_TRADE_SPEED_DESCRIPTION_INSTANT', 50);

-- Raze Speed: how long a captured settlement takes to raze, as districts razed per turn
-- (CITY_RAZE_DISTRICTS_PER_TURN), scaled for the current age.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_RazeTime', 'LOC_ZG_RAZE_TIME_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION', 'ZG_RazeTimeDomain', 'ZG_STANDARD_RAZE_TIME', 1, 'Game', 'RazeTimeKey', 'GamePacingOptions', 0, 52),
        ('ZG_RazeTimeAntiquity', 'LOC_ZG_RAZE_TIME_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RazeTimeAgeDomain', 'ZG_STANDARD_RAZE_TIME', 1, 'Game', 'RazeTimeAntiquityKey', 'PacingAntiquityOptions', 0, 109),
        ('ZG_RazeTimeExploration', 'LOC_ZG_RAZE_TIME_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RazeTimeAgeDomain', 'ZG_STANDARD_RAZE_TIME', 1, 'Game', 'RazeTimeExplorationKey', 'PacingExplorationOptions', 0, 119),
        ('ZG_RazeTimeModern', 'LOC_ZG_RAZE_TIME_NAME', 'LOC_ZG_PACING_AGE_DESCRIPTION', 'ZG_RazeTimeAgeDomain', 'ZG_STANDARD_RAZE_TIME', 1, 'Game', 'RazeTimeModernKey', 'PacingModernOptions', 0, 129);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_RazeTimeDomain', 'ZG_INSTANT_RAZE_TIME', 'LOC_ZG_INSTANT_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION_INSTANT', 30),
        ('ZG_RazeTimeDomain', 'ZG_SHORTER_RAZE_TIME', 'LOC_ZG_FAST_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION_SHORTER', 20),
        ('ZG_RazeTimeDomain', 'ZG_STANDARD_RAZE_TIME', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_RAZE_TIME_DESCRIPTION_STANDARD', 10),
        ('ZG_RazeTimeDomain', 'ZG_SWIFT_RAZE_TIME', 'LOC_ZG_SWIFT_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION_SWIFT', 33),
        ('ZG_RazeTimeDomain', 'ZG_BALANCED_RAZE_TIME', 'LOC_ZG_BALANCED_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION_BALANCED', 35),
        ('ZG_RazeTimeDomain', 'ZG_EXTENDED_RAZE_TIME', 'LOC_ZG_EXTENDED_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION_EXTENDED', 37),
        ('ZG_RazeTimeDomain', 'ZG_CUSTOM_RAZE_TIME', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_PACING_DESCRIPTION_CUSTOM', 40),
        ('ZG_RazeTimeAgeDomain', 'ZG_INSTANT_RAZE_TIME', 'LOC_ZG_INSTANT_NAME', 'LOC_ZG_RAZE_TIME_DESCRIPTION_INSTANT', 30),
        ('ZG_RazeTimeAgeDomain', 'ZG_SHORTER_RAZE_TIME', 'LOC_ZG_PCT_PLUS_100', 'LOC_ZG_RAZE_TIME_DESCRIPTION_SHORTER', 20),
        ('ZG_RazeTimeAgeDomain', 'ZG_STANDARD_RAZE_TIME', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_RAZE_TIME_DESCRIPTION_STANDARD', 10);


INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_SettlementLimitAntiquity', 'LOC_ZG_SETTLEMENT_LIMIT_ANTIQUITY_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_3', 1, 'Game', 'SettlementLimitAntiquityKey', 'SettlementOptions', 0, 4611),
        ('ZG_SettlementLimitExploration', 'LOC_ZG_SETTLEMENT_LIMIT_EXPLORATION_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_8', 1, 'Game', 'SettlementLimitExplorationKey', 'SettlementOptions', 0, 4612),
        ('ZG_SettlementLimitModern', 'LOC_ZG_SETTLEMENT_LIMIT_MODERN_NAME', 'LOC_ZG_SETTLEMENT_LIMIT_AGE_DESCRIPTION', 'ZG_SettlementLimitValueDomain', 'ZG_SL_16', 1, 'Game', 'SettlementLimitModernKey', 'SettlementOptions', 0, 4613);

-- 1-25 step by 1, then 30-75 step by 5.
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_1', 'LOC_ZG_NUM_1', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 10),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_2', 'LOC_ZG_NUM_2', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 20),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_3', 'LOC_ZG_NUM_3', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 30),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_4', 'LOC_ZG_NUM_4', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 40),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_5', 'LOC_ZG_NUM_5', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 50),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_6', 'LOC_ZG_NUM_6', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 60),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_7', 'LOC_ZG_NUM_7', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 70),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_8', 'LOC_ZG_NUM_8', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 80),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_9', 'LOC_ZG_NUM_9', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 90),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_10', 'LOC_ZG_NUM_10', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 100),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_11', 'LOC_ZG_NUM_11', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 110),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_12', 'LOC_ZG_NUM_12', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 120),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_13', 'LOC_ZG_NUM_13', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 130),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_14', 'LOC_ZG_NUM_14', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 140),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_15', 'LOC_ZG_NUM_15', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 150),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_16', 'LOC_ZG_NUM_16', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 160),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_17', 'LOC_ZG_NUM_17', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 170),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_18', 'LOC_ZG_NUM_18', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 180),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_19', 'LOC_ZG_NUM_19', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 190),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_20', 'LOC_ZG_NUM_20', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 200),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_21', 'LOC_ZG_NUM_21', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 210),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_22', 'LOC_ZG_NUM_22', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 220),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_23', 'LOC_ZG_NUM_23', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 230),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_24', 'LOC_ZG_NUM_24', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 240),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_25', 'LOC_ZG_NUM_25', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 250),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_30', 'LOC_ZG_NUM_30', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 300),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_35', 'LOC_ZG_NUM_35', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 350),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_40', 'LOC_ZG_NUM_40', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 400),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_45', 'LOC_ZG_NUM_45', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 450),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_50', 'LOC_ZG_NUM_50', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 500),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_55', 'LOC_ZG_NUM_55', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 550),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_60', 'LOC_ZG_NUM_60', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 600),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_65', 'LOC_ZG_NUM_65', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 650),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_70', 'LOC_ZG_NUM_70', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 700),
        ('ZG_SettlementLimitValueDomain', 'ZG_SL_75', 'LOC_ZG_NUM_75', 'LOC_ZG_SETTLEMENT_LIMIT_VALUE_DESCRIPTION', 750);

--*******************************************************
--************* CRISIS SETTINGS *************************
--*******************************************************
-- In single player the crisis settings get their own group after the game and
-- difficulty settings, keeping them on the General tab while the disaster
-- settings show on the Map tab. The base Crises multiselect renders as a titled
-- list, so it must stay last in its group.
UPDATE Parameters SET GroupId = 'CrisisOptions', SortIndex = 510, Name = 'LOC_ZG_CRISIS_SELECTION_NAME' WHERE ParameterID = 'Crises' AND SupportsSinglePlayer = 1;

-- Master switch for crises. It drives the base per-crisis selection through
-- zg-setup-rules.js, so the game applies it through its own ExcludeCrises key.
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_Crises', 'LOC_ZG_CRISES_NAME', 'LOC_ZG_CRISES_DESCRIPTION', 'ZG_CrisesDomain', 'ZG_ENABLED', 1, 'Game', 'CrisesKey', 'CrisisOptions', 0, 490);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_CrisesDomain', 'ZG_ENABLED', 'LOC_ZG_ENABLED_NAME', 'LOC_ZG_CRISES_DESCRIPTION_ENABLED', 10),
        ('ZG_CrisesDomain', 'ZG_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_CRISES_DESCRIPTION_DISABLED', 20);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_CrisisTiming', 'LOC_ZG_CRISIS_TIMING_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION', 'ZG_CrisisTimingDomain', 'ZG_DEFAULT_CRISIS_TIMING', 0, 'Game', 'CrisisTimingKey', 'CrisisOptions', 0, 500);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_CrisisTimingDomain', 'ZG_DISABLED_CRISIS_TIMING', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_DISABLED', 10),
        ('ZG_CrisisTimingDomain', 'ZG_EARLY_CRISIS_TIMING', 'LOC_ZG_EARLY_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_EARLY', 20),
        ('ZG_CrisisTimingDomain', 'ZG_DEFAULT_CRISIS_TIMING', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_DEFAULT', 30),
        ('ZG_CrisisTimingDomain', 'ZG_LATE_CRISIS_TIMING', 'LOC_ZG_LATE_NAME', 'LOC_ZG_CRISIS_TIMING_DESCRIPTION_LATE', 40);


--*******************************************************
--************* MAP SETTINGS ****************************
--*******************************************************
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_LakeGeneration', 'LOC_ZG_LAKE_GENERATION_NAME', 'LOC_ZG_LAKE_GENERATION_DESCRIPTION','ZG_LakeGenerationDomain', 'ZG_DEFAULT_LAKE_GENERATION', 0, 'Game', 'LakeGenerationKey', 'TerrainOptions', 0, 150);

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
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_NaturalWondersCount', 'LOC_ZG_NATURAL_WONDER_COUNT_NAME', 'LOC_ZG_NATURAL_WONDER_COUNT_DESCRIPTION','ZG_NaturalWonderCountDomain', 'ZG_DEFAULT_NATURAL_WONDER_COUNT', 1, 'Game', 'NaturalWonderCountKey', 'MapOptions', 0, 1034),
        ('ZG_NW_BarrierReef', 'LOC_FEATURE_BARRIER_REEF_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWBarrierReefKey', 'NaturalWonderSelectionOptions', 0, 200),
        ('ZG_NW_BermudaTriangle', 'LOC_FEATURE_BERMUDA_TRIANGLE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWBermudaTriangleKey', 'NaturalWonderSelectionOptions', 0, 210),
        ('ZG_NW_GrandCanyon', 'LOC_FEATURE_GRAND_CANYON_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWGrandCanyonKey', 'NaturalWonderSelectionOptions', 0, 220),
        ('ZG_NW_GreatBlueHole', 'LOC_FEATURE_GREAT_BLUE_HOLE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWGreatBlueHoleKey', 'NaturalWonderSelectionOptions', 0, 230),
        ('ZG_NW_Gullfoss', 'LOC_FEATURE_GULLFOSS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWGullfossKey', 'NaturalWonderSelectionOptions', 0, 240),
        ('ZG_NW_Hoerikwaggo', 'LOC_FEATURE_HOERIKWAGGO_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWHoerikwaggoKey', 'NaturalWonderSelectionOptions', 0, 250),
        ('ZG_NW_IguazuFalls', 'LOC_FEATURE_IGUAZU_FALLS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWIguazuFallsKey', 'NaturalWonderSelectionOptions', 0, 260),
        ('ZG_NW_Kilimanjaro', 'LOC_FEATURE_KILIMANJARO_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWKilimanjaroKey', 'NaturalWonderSelectionOptions', 0, 270),
        ('ZG_NW_Machapuchare', 'LOC_FEATURE_MACHAPUCHARE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMachapuchareKey', 'NaturalWonderSelectionOptions', 0, 280),
        ('ZG_NW_MapuAVaeaBlowholes', 'LOC_FEATURE_MAPU_A_VAEA_BLOWHOLES_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMapuAVaeaBlowholesKey', 'NaturalWonderSelectionOptions', 0, 290),
        ('ZG_NW_MountEverest', 'LOC_FEATURE_MOUNT_EVEREST_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMountEverestKey', 'NaturalWonderSelectionOptions', 0, 300),
        ('ZG_NW_MountFuji', 'LOC_FEATURE_MOUNT_FUJI_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWMountFujiKey', 'NaturalWonderSelectionOptions', 0, 310),
        ('ZG_NW_NachiFalls', 'LOC_FEATURE_NACHI_FALLS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWNachiFallsKey', 'NaturalWonderSelectionOptions', 0, 315),
        ('ZG_NW_RedwoodForest', 'LOC_FEATURE_REDWOOD_FOREST_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWRedwoodForestKey', 'NaturalWonderSelectionOptions', 0, 320),
        ('ZG_NW_SeongsanIlchulbong', 'LOC_FEATURE_SEONGSAN_ILCHULBONG_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWSeongsanIlchulbongKey', 'NaturalWonderSelectionOptions', 0, 325),
        ('ZG_NW_Thera', 'LOC_FEATURE_THERA_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWTheraKey', 'NaturalWonderSelectionOptions', 0, 330),
        ('ZG_NW_TorresDelPaine', 'LOC_FEATURE_TORRES_DEL_PAINE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWTorresDelPaineKey', 'NaturalWonderSelectionOptions', 0, 340),
        ('ZG_NW_Uluru', 'LOC_FEATURE_ULURU_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWUluruKey', 'NaturalWonderSelectionOptions', 0, 350),
        ('ZG_NW_ValleyOfFlowers', 'LOC_FEATURE_VALLEY_OF_FLOWERS_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWValleyOfFlowersKey', 'NaturalWonderSelectionOptions', 0, 360),
        ('ZG_NW_Vihren', 'LOC_FEATURE_VIHREN_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWVihrenKey', 'NaturalWonderSelectionOptions', 0, 370),
        ('ZG_NW_Vinicunca', 'LOC_FEATURE_VINICUNCA_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWVinicuncaKey', 'NaturalWonderSelectionOptions', 0, 380),
        ('ZG_NW_Zhangjiajie', 'LOC_FEATURE_ZHANGJIAJIE_NAME', 'LOC_ZG_NATURAL_WONDER_TOGGLE_DESCRIPTION', 'ZG_WonderToggleDomain', 'ZG_ENABLED', 1, 'Game', 'ZGNWZhangjiajieKey', 'NaturalWonderSelectionOptions', 0, 390);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_WonderToggleDomain', 'ZG_ENABLED', 'LOC_ZG_ENABLED_NAME', 'LOC_ZG_WONDER_TOGGLE_DESCRIPTION_ENABLED', 10),
        ('ZG_WonderToggleDomain', 'ZG_DISABLED', 'LOC_ZG_DISABLED_NAME', 'LOC_ZG_WONDER_TOGGLE_DESCRIPTION_DISABLED', 20);

INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey, GroupId, ChangeableAfterGameStart, SortIndex)
    VALUES
        ('ZG_MapTemperature', 'LOC_ZG_MAP_TEMPERATURE_NAME', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION', 'ZG_MapTemperatureDomain', 'ZG_STANDARD_TEMPERATURE', 0, 'Game', 'MapTemperatureKey', 'MapOptions', 0, 1032),
        ('ZG_MapZones', 'LOC_ZG_MAP_ZONES_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION', 'ZG_MapZonesDomain', 'ZG_MAP_ZONES_STANDARD', 0, 'Game', 'MapZonesKey', 'MapOptions', 0, 1033),
        ('ZG_Rivers', 'LOC_ZG_RIVERS_NAME', 'LOC_ZG_RIVERS_DESCRIPTION','ZG_RiversDomain', 'ZG_DEFAULT_RIVERS', 0, 'Game', 'RiversKey', 'TerrainOptions', 0, 151),
        ('ZG_Mountains', 'LOC_ZG_MOUNTAINS_NAME', 'LOC_ZG_MOUNTAINS_DESCRIPTION','ZG_MountainsDomain', 'ZG_DEFAULT_MOUNTAINS', 0, 'Game', 'MountainsKey', 'TerrainOptions', 0, 152),
        ('ZG_MapAge', 'LOC_ZG_MAP_AGE_NAME', 'LOC_ZG_MAP_AGE_DESCRIPTION', 'ZG_MapAgeDomain', 'ZG_MAP_AGE_STANDARD', 0, 'Game', 'MapAgeKey', 'MapOptions', 0, 1031),
        ('ZG_Resources', 'LOC_ZG_RESOURCES_NAME', 'LOC_ZG_RESOURCES_DESCRIPTION', 'ZG_ResourcesDomain', 'ZG_RESOURCES_STANDARD', 0, 'Game', 'ResourcesKey', 'MapOptions', 0, 1035);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_MapTemperatureDomain', 'ZG_FRIGID_TEMPERATURE', 'LOC_ZG_FRIGID_NAME', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION_FRIGID', 10),
        ('ZG_MapTemperatureDomain', 'ZG_COLD_TEMPERATURE', 'LOC_ZG_COLD_NAME', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION_COLD', 20),
        ('ZG_MapTemperatureDomain', 'ZG_STANDARD_TEMPERATURE', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION_STANDARD', 30),
        ('ZG_MapTemperatureDomain', 'ZG_HOT_TEMPERATURE', 'LOC_ZG_HOT_NAME', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION_HOT', 40),
        ('ZG_MapTemperatureDomain', 'ZG_SCORCHING_TEMPERATURE', 'LOC_ZG_SCORCHING_NAME', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION_SCORCHING', 50),
        ('ZG_MapTemperatureDomain', 'ZG_RANDOM_TEMPERATURE', 'LOC_ADVANCED_OPTIONS_RANDOM', 'LOC_ZG_MAP_TEMPERATURE_DESCRIPTION_RANDOM', 60),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_MAP_ZONES_DESCRIPTION_STANDARD', 10),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_HOT_POLES', 'LOC_ZG_MAP_ZONES_HOT_POLES_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION_HOT_POLES', 20),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_HOT_EDGE', 'LOC_ZG_MAP_ZONES_HOT_EDGE_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION_HOT_EDGE', 30),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_HOT_CENTER', 'LOC_ZG_MAP_ZONES_HOT_CENTER_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION_HOT_CENTER', 40),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_COLD_CENTER', 'LOC_ZG_MAP_ZONES_COLD_CENTER_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION_COLD_CENTER', 50),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_WARM_RING', 'LOC_ZG_MAP_ZONES_WARM_RING_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION_WARM_RING', 60),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_PATCHWORK', 'LOC_ZG_MAP_ZONES_PATCHWORK_NAME', 'LOC_ZG_MAP_ZONES_DESCRIPTION_PATCHWORK', 70),
        ('ZG_MapZonesDomain', 'ZG_MAP_ZONES_RANDOM', 'LOC_ADVANCED_OPTIONS_RANDOM', 'LOC_ZG_MAP_ZONES_DESCRIPTION_RANDOM', 80),
        ('ZG_RiversDomain', 'ZG_WADI_RIVERS', 'LOC_ZG_RIVERS_WADI_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_WADI', 10),
        ('ZG_RiversDomain', 'ZG_LESS_RIVERS', 'LOC_ZG_RIVERS_ARID_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_ARID', 20),
        ('ZG_RiversDomain', 'ZG_CHANNEL_RIVERS', 'LOC_ZG_RIVERS_CHANNEL_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_CHANNEL', 30),
        ('ZG_RiversDomain', 'ZG_SHALLOW_RIVERS', 'LOC_ZG_RIVERS_SHALLOW_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_SHALLOW', 40),
        ('ZG_RiversDomain', 'ZG_DEFAULT_RIVERS', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_RIVERS_DESCRIPTION_DEFAULT', 50),
        ('ZG_RiversDomain', 'ZG_WATERWAY_RIVERS', 'LOC_ZG_RIVERS_WATERWAY_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_WATERWAY', 60),
        ('ZG_RiversDomain', 'ZG_STREAM_RIVERS', 'LOC_ZG_RIVERS_STREAM_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_STREAM', 70),
        ('ZG_RiversDomain', 'ZG_MORE_RIVERS', 'LOC_ZG_RIVERS_RIVERLAND_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_RIVERLAND', 80),
        ('ZG_RiversDomain', 'ZG_DEEP_RIVERS', 'LOC_ZG_RIVERS_DEEP_NAME', 'LOC_ZG_RIVERS_DESCRIPTION_DEEP', 90);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES
        ('ZG_MountainsDomain', 'ZG_LESS_MOUNTAINS', 'LOC_ZG_LESS_NAME', 'LOC_ZG_MOUNTAINS_DESCRIPTION_LESS', 20),
        ('ZG_MountainsDomain', 'ZG_DEFAULT_MOUNTAINS', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_MOUNTAINS_DESCRIPTION_DEFAULT', 30),
        ('ZG_MountainsDomain', 'ZG_MORE_MOUNTAINS', 'LOC_ZG_MORE_NAME', 'LOC_ZG_MOUNTAINS_DESCRIPTION_MORE', 40),
        ('ZG_MapAgeDomain', 'ZG_MAP_AGE_OLD', 'LOC_ADVANCED_OPTIONS_OLD', 'LOC_ZG_MAP_AGE_DESCRIPTION_OLD', 10),
        ('ZG_MapAgeDomain', 'ZG_MAP_AGE_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_MAP_AGE_DESCRIPTION_STANDARD', 20),
        ('ZG_MapAgeDomain', 'ZG_MAP_AGE_NEW', 'LOC_ADVANCED_OPTIONS_NEW', 'LOC_ZG_MAP_AGE_DESCRIPTION_NEW', 30),
        ('ZG_ResourcesDomain', 'ZG_RESOURCES_SPARSE', 'LOC_ADVANCED_OPTIONS_SPARSE', 'LOC_ZG_RESOURCES_DESCRIPTION_SPARSE', 10),
        ('ZG_ResourcesDomain', 'ZG_RESOURCES_STANDARD', 'LOC_ADVANCED_OPTIONS_STANDARD', 'LOC_ZG_RESOURCES_DESCRIPTION_STANDARD', 20),
        ('ZG_ResourcesDomain', 'ZG_RESOURCES_ABUNDANT', 'LOC_ADVANCED_OPTIONS_ABUNDANT', 'LOC_ZG_RESOURCES_DESCRIPTION_ABUNDANT', 30);

--*******************************************************
--************* CLOSED TO MULTIPLAYER *******************
--*******************************************************
-- Every setting this mod adds stays out of multiplayer and hotseat.
UPDATE Parameters
SET SupportsLANMultiplayer = 0, SupportsInternetMultiplayer = 0, SupportsHotseatMultiplayer = 0
WHERE ParameterID LIKE 'ZG\_%' ESCAPE '\';
