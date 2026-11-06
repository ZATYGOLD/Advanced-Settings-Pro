// The Advanced Settings layout both setup screens share: the single-player one
// (zg-map-tab.js, zg-seed-randomizer.js) and the multiplayer Create Game screen
// (zg-mp-create-game.js).

// Multiplayer resolves a parameter's group to its GroupIDMultiplayerOverride
// when it has one: these "MPAdvanced" ids, set in config/setup-parameters.sql.
// A setting with no override keeps its single-player group, as the settings a
// map script adds usually do, so each tab claims both.
export const MP_GROUP_PREFIX = "MPAdvanced";
const withMultiplayerGroups = (groups) => new Set(groups.flatMap((group) => [group, MP_GROUP_PREFIX + group]));

// The extra tabs, in display order, each claiming the parameter groups it shows;
// General keeps every group no extra tab claims.
export const SETUP_TABS = [
	{
		key: "pace",
		title: "LOC_ZG_ADVANCED_OPTIONS_AGES",
		groups: withMultiplayerGroups(["GamePacingOptions", "PacingAntiquityOptions", "PacingExplorationOptions", "PacingModernOptions"]),
	},
	{
		key: "map",
		title: "LOC_ZG_ADVANCED_OPTIONS_MAP_SETTINGS",
		groups: withMultiplayerGroups(["MapOptions", "TerrainOptions", "DisasterOptions", "NaturalWonderSelectionOptions"]),
	},
];

// The seed settings that get a Random button, and the seed it draws.
export const SEED_PARAM_IDS = ["GameRandomSeed", "MapRandomSeed"];
export const SEED_BUTTON_TEXT = "LOC_ADVANCED_OPTIONS_RANDOM";
const MAX_SEED = 2 ** 31 - 1;
export const randomSeed = () => 1 + Math.floor(Math.random() * (MAX_SEED - 1));
