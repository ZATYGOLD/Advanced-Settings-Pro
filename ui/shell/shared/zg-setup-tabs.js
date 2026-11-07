// The single-player Advanced Settings layout (zg-map-tab.js, zg-seed-randomizer.js).

// The extra tabs, in display order, each claiming the parameter groups it shows;
// General keeps every group no extra tab claims.
export const SETUP_TABS = [
	{
		key: "pace",
		title: "LOC_ZG_ADVANCED_OPTIONS_AGES",
		groups: new Set(["GamePacingOptions", "PacingAntiquityOptions", "PacingExplorationOptions", "PacingModernOptions"]),
	},
	{
		key: "map",
		title: "LOC_ZG_ADVANCED_OPTIONS_MAP_SETTINGS",
		groups: new Set(["MapOptions", "TerrainOptions", "DisasterOptions", "NaturalWonderSelectionOptions"]),
	},
];

// The seed settings that get a Random button, and the seed it draws.
export const SEED_PARAM_IDS = ["GameRandomSeed", "MapRandomSeed"];
export const SEED_BUTTON_TEXT = "LOC_ADVANCED_OPTIONS_RANDOM";
const MAX_SEED = 2 ** 31 - 1;
export const randomSeed = () => 1 + Math.floor(Math.random() * (MAX_SEED - 1));
