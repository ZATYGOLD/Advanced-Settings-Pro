// Keeps related setup parameters consistent with each other.
//
// Natural wonders:
//   1. Count set to Disabled        -> every wonder toggle becomes Disabled.
//   2. Count leaves Disabled        -> every wonder toggle becomes Enabled.
//   3. Every toggle Disabled        -> count becomes Disabled.
//   4. Too few wonders enabled to support the tier on the current map size
//      -> every wonder toggle is reset to Enabled.
//
// Settlement Limit, Disasters, Triumph Sets, Trade, Raze Speed, and the Pace
// tab's settings (shared tier/age sync):
//   5. A tier is selected           -> every age shows that tier's values.
//   6. An age is changed away from the selected tier
//      -> the primary setting switches to Custom.
//
// Pace Set:
//   7. A preset is selected         -> every All Ages setting takes the preset's value.
//   8. An All Ages setting no longer matches the selected preset
//      -> Pace Set switches to Custom.
//   9. Age Length leaves Custom      -> every other All Ages setting returns to Standard.
//  10. Pace Set (General) and Pace Set (Pace tab) mirror each other.
//
// Crises:
//  11. Crises set to Disabled       -> every crisis in the selection is excluded.
//  12. Crises leaves Disabled       -> every crisis in the selection is included.
//  13. Every crisis excluded        -> Crises becomes Disabled; any crisis included
//      while it says Disabled       -> Crises becomes Enabled.
//  14. Crises Disabled              -> Crisis Timing shows Disabled; Crises Enabled
//      while the timing says Disabled -> the timing returns to Standard.
//  15. Crisis Timing set to Disabled -> Crises becomes Disabled; the timing leaves
//      Disabled                     -> Crises becomes Enabled.
//  16. On the first pass of a setup -> Crises wins: the selection and timing
//      follow it, so a remembered Crises value is kept.
//
// Each rule compares against the last pass, and skips a pass until the options
// it compares with have loaded. The rules run only while the single-player
// setup screen is open. While remembered settings are put back
// (zg-setup-memory.js) they wait, and the comparisons then start over, so the
// restored values are the baseline rather than a change to answer.
import { gameValue, resolveName } from '../../shared/zg-config.js';
import { isSinglePlayerSetupOpen, onSetupPoll, onSetupRevision } from '../shared/zg-shell-context.js';
import { tickSetupMemory, isRestoringSetup, rememberSetup } from './zg-setup-memory.js';

const LOG_PREFIX = "ZG-ASP setup rules:";
const NW_COUNT_PARAM_ID = "ZG_NaturalWondersCount";
const MAP_SIZE_PARAM_ID = "MapSize";
const WONDER_PARAM_IDS = [
	"ZG_NW_BarrierReef", "ZG_NW_BermudaTriangle", "ZG_NW_GrandCanyon", "ZG_NW_GreatBlueHole",
	"ZG_NW_Gullfoss", "ZG_NW_Hoerikwaggo", "ZG_NW_IguazuFalls", "ZG_NW_Kilimanjaro",
	"ZG_NW_Machapuchare", "ZG_NW_MapuAVaeaBlowholes", "ZG_NW_MountEverest", "ZG_NW_MountFuji",
	"ZG_NW_NachiFalls", "ZG_NW_RedwoodForest", "ZG_NW_SeongsanIlchulbong", "ZG_NW_Thera",
	"ZG_NW_TorresDelPaine", "ZG_NW_Uluru", "ZG_NW_ValleyOfFlowers", "ZG_NW_Vihren",
	"ZG_NW_Vinicunca", "ZG_NW_Zhangjiajie",
];

// Settlement Limit's curated tiers as the limits their SQL applies, in age order.
const SETTLEMENT_LIMIT_AGE_NAMES = Object.fromEntries(Object.entries({
	LOC_ZG_LESS_NAME: [1, 4, 10],
	LOC_ADVANCED_OPTIONS_STANDARD: [3, 8, 16],
	LOC_ZG_MORE_NAME: [5, 12, 20],
}).map(([tier, limits]) => [tier, limits.map((limit) => `LOC_ZG_NUM_${limit}`)]));

const AGE_LENGTH_PARAM_ID = "AgeLength";

// Per-age value names for primaries whose age rows use a different scale.
// A mapped value may be one name for every age, or one name per age
// (Antiquity, Exploration, Modern) when the curated option differs by age.
const AGE_LENGTH_AGE_NAMES = {
	"LOC_ADVANCED_OPTIONS_ABBREVIATED": "LOC_ZG_NUM_120",
	"LOC_ADVANCED_OPTIONS_STANDARD": "LOC_ZG_NUM_140",
	"LOC_ZG_BALANCED_NAME": ["LOC_ZG_NUM_150", "LOC_ZG_NUM_170", "LOC_ZG_NUM_200"],
	"LOC_ADVANCED_OPTIONS_LONG": "LOC_ZG_NUM_160",
	"LOC_ZG_SWIFT_NAME": ["LOC_ZG_NUM_90", "LOC_ZG_NUM_100", "LOC_ZG_NUM_110"],
	"LOC_ZG_EXTENDED_NAME": ["LOC_ZG_NUM_240", "LOC_ZG_NUM_260", "LOC_ZG_NUM_280"],
};
const COST_AGE_NAMES = {
	"LOC_ZG_LOW_NAME": "LOC_ZG_PCT_MINUS_25",
	"LOC_ADVANCED_OPTIONS_STANDARD": "LOC_ADVANCED_OPTIONS_STANDARD",
	"LOC_ZG_MEDIUM_NAME": "LOC_ZG_PCT_PLUS_25",
	"LOC_ZG_HIGH_NAME": "LOC_ZG_PCT_PLUS_50",
	"LOC_ZG_DOUBLE_NAME": "LOC_ZG_PCT_PLUS_100",
};
// Each setting's Balanced option expands to its own per-age shape, so the four
// costs and the two speeds each need their own map rather than a shared one.
const TECHNOLOGY_AGE_NAMES = {
	...COST_AGE_NAMES,
	// Front-loaded: dearer early, standard mid, cheaper late.
	"LOC_ZG_BALANCED_NAME": ["LOC_ZG_PCT_PLUS_25", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_PCT_MINUS_25"],
	"LOC_ZG_SWIFT_NAME": ["LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25", "LOC_ADVANCED_OPTIONS_STANDARD"],
	"LOC_ZG_EXTENDED_NAME": ["LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_50"],
};
const CIVIC_AGE_NAMES = {
	...COST_AGE_NAMES,
	// Back-loaded: standard early, dearer once the tree opens up.
	"LOC_ZG_BALANCED_NAME": ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_25"],
	"LOC_ZG_SWIFT_NAME": ["LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25", "LOC_ADVANCED_OPTIONS_STANDARD"],
	"LOC_ZG_EXTENDED_NAME": ["LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_50"],
};
const BUILDING_AGE_NAMES = {
	...COST_AGE_NAMES,
	// Dearer while settlements lay down their first districts, standard after.
	"LOC_ZG_BALANCED_NAME": ["LOC_ZG_PCT_PLUS_25", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD"],
	"LOC_ZG_SWIFT_NAME": ["LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25"],
	"LOC_ZG_EXTENDED_NAME": ["LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_50"],
};
const VICTORY_AGE_NAMES = {
	...COST_AGE_NAMES,
	"LOC_ZG_BALANCED_NAME": ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25"],
	"LOC_ZG_SWIFT_NAME": ["LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25", "LOC_ZG_PCT_MINUS_25"],
	"LOC_ZG_EXTENDED_NAME": ["LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_25"],
};
// Settlement Growth and Road Speed name their age rows by tier (Slow, Quick,
// Fast), so only the presets need a per-age shape.
const CITY_GROWTH_AGE_NAMES = {
	// Cities catch up early, then settle to standard in Modern.
	"LOC_ZG_BALANCED_NAME": ["LOC_ZG_QUICK_NAME", "LOC_ZG_QUICK_NAME", "LOC_ADVANCED_OPTIONS_STANDARD"],
	"LOC_ZG_SWIFT_NAME": "LOC_ZG_QUICK_NAME",
	"LOC_ZG_EXTENDED_NAME": "LOC_ZG_SLOW_NAME",
};
const ROADS_AGE_NAMES = {
	// Roads only start to matter once the map is large and railroads arrive.
	"LOC_ZG_BALANCED_NAME": ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_QUICK_NAME"],
	"LOC_ZG_SWIFT_NAME": ["LOC_ZG_QUICK_NAME", "LOC_ZG_FAST_NAME", "LOC_ZG_FAST_NAME"],
	"LOC_ZG_EXTENDED_NAME": ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_QUICK_NAME"],
};

// Speed age rows are named by the change to the game value: Merchant movement
// for Trade Speed, districts razed per turn for Raze Speed. Trade Speed's
// Standard is the game's own: Merchants travel in Antiquity and Exploration,
// and Modern trade routes start from a distance.
const TRADE_SPEED_AGE_NAMES = {
	"LOC_ZG_SLOW_NAME": "LOC_ZG_PCT_MINUS_25",
	"LOC_ADVANCED_OPTIONS_STANDARD": ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_INSTANT_NAME"],
	"LOC_ZG_QUICK_NAME": "LOC_ZG_PCT_PLUS_25",
	"LOC_ZG_FAST_NAME": "LOC_ZG_PCT_PLUS_50",
	"LOC_ZG_SWIFT_NAME": "LOC_ZG_INSTANT_NAME",
	"LOC_ZG_BALANCED_NAME": ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_INSTANT_NAME"],
	"LOC_ZG_EXTENDED_NAME": "LOC_ZG_PCT_MINUS_25",
};
const RAZE_SPEED_AGE_NAMES = {
	"LOC_ZG_FAST_NAME": "LOC_ZG_PCT_PLUS_100",
	"LOC_ZG_SWIFT_NAME": "LOC_ZG_INSTANT_NAME",
	"LOC_ZG_BALANCED_NAME": "LOC_ADVANCED_OPTIONS_STANDARD",
	"LOC_ZG_EXTENDED_NAME": "LOC_ADVANCED_OPTIONS_STANDARD",
};

// Primary settings whose per-age values are kept in step (rules 5 & 6).
// ageNames maps a primary value name to its per-age value name (identity when absent).
const TIER_AGE_SYNCS = [
	{ tierId: "ZG_SettlementLimit", ageIds: ["ZG_SettlementLimitAntiquity", "ZG_SettlementLimitExploration", "ZG_SettlementLimitModern"], ageNames: SETTLEMENT_LIMIT_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_DisasterFrequency", ageIds: ["ZG_DisastersAntiquity", "ZG_DisastersExploration", "ZG_DisastersModern"], lastTier: null },
	{ tierId: "LegacySets", ageIds: ["ZG_TriumphSetAntiquity", "ZG_TriumphSetExploration", "ZG_TriumphSetModern"], lastTier: null },
	{ tierId: "ZG_TradeRange", ageIds: ["ZG_TradeRangeAntiquity", "ZG_TradeRangeExploration", "ZG_TradeRangeModern"], lastTier: null },
	{ tierId: "ZG_TradeSpeed", ageIds: ["ZG_TradeSpeedAntiquity", "ZG_TradeSpeedExploration", "ZG_TradeSpeedModern"], ageNames: TRADE_SPEED_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_RazeTime", ageIds: ["ZG_RazeTimeAntiquity", "ZG_RazeTimeExploration", "ZG_RazeTimeModern"], ageNames: RAZE_SPEED_AGE_NAMES, lastTier: null },
	{ tierId: AGE_LENGTH_PARAM_ID, ageIds: ["ZG_AgeLengthAntiquity", "ZG_AgeLengthExploration", "ZG_AgeLengthModern"], ageNames: AGE_LENGTH_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_AgeProgressRate", ageIds: ["ZG_AgeProgressRateAntiquity", "ZG_AgeProgressRateExploration", "ZG_AgeProgressRateModern"], lastTier: null },
	{ tierId: "ZG_TechnologyCost", ageIds: ["ZG_TechnologyCostAntiquity", "ZG_TechnologyCostExploration", "ZG_TechnologyCostModern"], ageNames: TECHNOLOGY_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_CivicCost", ageIds: ["ZG_CivicCostAntiquity", "ZG_CivicCostExploration", "ZG_CivicCostModern"], ageNames: CIVIC_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_BuildingCost", ageIds: ["ZG_BuildingCostAntiquity", "ZG_BuildingCostExploration", "ZG_BuildingCostModern"], ageNames: BUILDING_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_CityGrowth", ageIds: ["ZG_CityGrowthAntiquity", "ZG_CityGrowthExploration", "ZG_CityGrowthModern"], ageNames: CITY_GROWTH_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_Roads", ageIds: ["ZG_RoadsAntiquity", "ZG_RoadsExploration", "ZG_RoadsModern"], ageNames: ROADS_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_VictoryProjectCost", ageIds: ["ZG_VictoryProjectCostAntiquity", "ZG_VictoryProjectCostExploration", "ZG_VictoryProjectCostModern"], ageNames: VICTORY_AGE_NAMES, lastTier: null },
];

// Pace Set presets (rules 7 & 8): each All Ages setting's value by name,
// or a per-age list (Antiquity, Exploration, Modern) that puts it on Custom.
const PACE_PARAM_ID = "ZG_PacePreset";
const PACE_MIRROR_PARAM_ID = "ZG_PaceSetMirror";
const PACE_CUSTOM = "LOC_ZG_PACE_PRESET_CUSTOM_NAME";
const PACE_STANDARD = {
	[AGE_LENGTH_PARAM_ID]: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_AgeProgressRate: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_TechnologyCost: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_CivicCost: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_BuildingCost: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_VictoryProjectCost: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_CityGrowth: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_Roads: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_TradeSpeed: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_RazeTime: "LOC_ADVANCED_OPTIONS_STANDARD",
};
const PACE_PRESETS = {
	// A 90 point age with full price research would cut the tree short, so Swift
	// scales the costs down with the age and lets cities grow into it faster.
	"LOC_ZG_PACE_PRESET_SWIFT_NAME": {
		...PACE_STANDARD,
		[AGE_LENGTH_PARAM_ID]: "LOC_ZG_SWIFT_NAME",
		ZG_TechnologyCost: "LOC_ZG_SWIFT_NAME",
		ZG_CivicCost: "LOC_ZG_SWIFT_NAME",
		ZG_BuildingCost: "LOC_ZG_SWIFT_NAME",
		ZG_CityGrowth: "LOC_ZG_SWIFT_NAME",
		ZG_Roads: "LOC_ZG_SWIFT_NAME",
		ZG_VictoryProjectCost: "LOC_ZG_SWIFT_NAME",
		// Short ages leave no time for walking Merchants or slow razing.
		ZG_TradeSpeed: "LOC_ZG_SWIFT_NAME",
		ZG_RazeTime: "LOC_ZG_SWIFT_NAME",
	},
	"LOC_ZG_PACE_PRESET_STANDARD_NAME": PACE_STANDARD,
	// Eras+ Balanced Extended+: age caps 150/170/200, its milestone curve, 1.25x techs
	// and civics, and cities that grow a quarter faster to keep pace with the longer ages.
	// Triumph projects get 25% cheaper in the two later ages so the longer Exploration
	// and Modern caps do not push a victory out of reach. Roads stay standard.
	"LOC_ZG_PACE_PRESET_BALANCED_NAME": {
		...PACE_STANDARD,
		[AGE_LENGTH_PARAM_ID]: "LOC_ZG_BALANCED_NAME",
		ZG_AgeProgressRate: "LOC_ZG_BALANCED_NAME",
		ZG_TechnologyCost: "LOC_ZG_BALANCED_NAME",
		ZG_CivicCost: "LOC_ZG_BALANCED_NAME",
		ZG_BuildingCost: "LOC_ZG_BALANCED_NAME",
		ZG_CityGrowth: "LOC_ZG_BALANCED_NAME",
		ZG_Roads: "LOC_ZG_BALANCED_NAME",
		ZG_VictoryProjectCost: "LOC_ZG_BALANCED_NAME",
		ZG_TradeSpeed: "LOC_ZG_BALANCED_NAME",
		ZG_RazeTime: "LOC_ZG_BALANCED_NAME",
	},
	// A 280 point age runs out of tree long before it ends, so Extended raises the
	// research and triumph costs to fill it.
	"LOC_ZG_PACE_PRESET_EXTENDED_NAME": {
		...PACE_STANDARD,
		[AGE_LENGTH_PARAM_ID]: "LOC_ZG_EXTENDED_NAME",
		ZG_TechnologyCost: "LOC_ZG_EXTENDED_NAME",
		ZG_CivicCost: "LOC_ZG_EXTENDED_NAME",
		ZG_BuildingCost: "LOC_ZG_EXTENDED_NAME",
		ZG_CityGrowth: "LOC_ZG_EXTENDED_NAME",
		ZG_Roads: "LOC_ZG_EXTENDED_NAME",
		ZG_VictoryProjectCost: "LOC_ZG_EXTENDED_NAME",
		// Merchants travel slowly in every age, Modern included.
		ZG_TradeSpeed: "LOC_ZG_EXTENDED_NAME",
		ZG_RazeTime: "LOC_ZG_EXTENDED_NAME",
	},
	// Eras+ MP Pace: age caps 140/160/180, its milestone curve, dearer research and
	// civics that climb with the age, slightly slower growth, faster roads and Modern
	// railroads, and pricier Modern victory projects, on the shared cost steps.
	"LOC_ZG_PACE_PRESET_MULTIPLAYER_NAME": {
		...PACE_STANDARD,
		[AGE_LENGTH_PARAM_ID]: ["LOC_ZG_NUM_140", "LOC_ZG_NUM_160", "LOC_ZG_NUM_180"],
		ZG_AgeProgressRate: "LOC_ZG_BALANCED_NAME",
		ZG_TechnologyCost: ["LOC_ZG_PCT_PLUS_25", "LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_100"],
		ZG_CivicCost: ["LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_100"],
		ZG_CityGrowth: "LOC_ZG_SLOW_NAME",
		ZG_Roads: ["LOC_ZG_QUICK_NAME", "LOC_ZG_QUICK_NAME", "LOC_ZG_FAST_NAME"],
		ZG_VictoryProjectCost: ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_PCT_PLUS_25"],
	},
};
let lastPace = null;
let lastPaceMirror = null;
let lastAgeLength = null;

const CRISES_PARAM_ID = "ZG_Crises";
// The base multiselect lists excluded crises (UxHint InvertSelection).
const CRISES_SELECTION_PARAM_ID = "Crises";
const CRISIS_TIMING_PARAM_ID = "ZG_CrisisTiming";

const TIER_DISABLED = "LOC_ZG_DISABLED_NAME";
const TIER_HALF = "LOC_ZG_HALF_NAME";
const TIER_STANDARD = "LOC_ADVANCED_OPTIONS_STANDARD";
const TIER_MORE = "LOC_ZG_MORE_NAME";
const TIER_DOUBLE = "LOC_ZG_DOUBLE_NAME";
const TIER_CUSTOM = "LOC_ZG_CUSTOM_NAME";
const TOGGLE_ENABLED = "LOC_ZG_ENABLED_NAME";
const TOGGLE_DISABLED = TIER_DISABLED;

// Base wonder counts per map size (Maps.NumNaturalWonders).
const BASE_WONDERS = { TINY: 3, SMALL: 4, STANDARD: 5, LARGE: 6, HUGE: 7 };

let nwLastTier = null;
let crisesLastToggle = null;
let crisisTimingLast = null;

// The rules are written by option name, which per-age rows share across
// settings, and compare and write option values. Each setting's names resolve
// to values once per setup.
const optionsCache = new Map();

function options(paramId) {
	let found = optionsCache.get(paramId);
	if (!found) {
		const possible = GameSetup.findGameParameter(paramId)?.domain?.possibleValues ?? [];
		found = {
			byName: new Map(possible.map((entry) => [resolveName(entry.name), entry.value])),
			byValue: new Map(possible.map((entry) => [entry.value, resolveName(entry.name)])),
		};
		if (possible.length > 0) {
			optionsCache.set(paramId, found);
		}
	}
	return found;
}

// The value a setting's option name stands for, or null when it offers none.
const valueOf = (paramId, nameTag) => options(paramId).byName.get(nameTag) ?? null;
// The option name a setting holds, or "".
const nameOf = (paramId) => options(paramId).byValue.get(gameValue(paramId)) ?? "";
// Whether a setting holds the named option.
const holds = (paramId, nameTag) => gameValue(paramId) == valueOf(paramId, nameTag);

function setOption(paramId, nameTag) {
	const value = valueOf(paramId, nameTag);
	if (value != null && gameValue(paramId) != value) {
		GameSetup.setGameParameterValue(paramId, value);
	}
}

// ---------------------------------------------------------------- wonders --

function getBaseWonders() {
	// Map Size is hashed, so it is read by its option name.
	const sizeName = nameOf(MAP_SIZE_PARAM_ID).toUpperCase();
	for (const key of Object.keys(BASE_WONDERS)) {
		if (sizeName.includes(key)) {
			return BASE_WONDERS[key];
		}
	}
	return BASE_WONDERS.STANDARD;
}

// Mirrors the tier math in data/natural-wonders/natural-wonder-count-*.sql.
function requiredWonders(tier, base) {
	switch (tier) {
		case TIER_HALF: return base <= 1 ? 1 : Math.floor(base / 2);
		case TIER_STANDARD: return base;
		case TIER_MORE: return Math.floor(base * 1.5);
		case TIER_DOUBLE: return base * 2;
		default: return 0;
	}
}

function syncNaturalWonderSetup() {
	const countParam = GameSetup.findGameParameter(NW_COUNT_PARAM_ID);
	if (!countParam) {
		return;
	}
	const toggles = WONDER_PARAM_IDS
		.map((id) => ({ id, param: GameSetup.findGameParameter(id) }))
		.filter((entry) => entry.param);
	if (toggles.length == 0) {
		return;
	}
	const tier = gameValue(NW_COUNT_PARAM_ID);
	const disabled = valueOf(NW_COUNT_PARAM_ID, TIER_DISABLED);
	// Every toggle shares one domain.
	const toggleOn = valueOf(toggles[0].id, TOGGLE_ENABLED);
	if (tier == null || disabled == null || toggleOn == null) {
		return;
	}
	const enabled = toggles.filter((entry) => entry.param.value?.value == toggleOn).length;

	// 1 & 2: the player changed the count tier; cascade to the toggles.
	if (nwLastTier != null && tier != nwLastTier) {
		if (tier == disabled) {
			toggles.forEach((entry) => setOption(entry.id, TOGGLE_DISABLED));
		} else if (nwLastTier == disabled) {
			toggles.forEach((entry) => setOption(entry.id, TOGGLE_ENABLED));
		}
		nwLastTier = tier;
		return;
	}
	nwLastTier = tier;
	// 3: every wonder disabled; the count must say so.
	if (enabled == 0 && tier != disabled) {
		setOption(NW_COUNT_PARAM_ID, TIER_DISABLED);
		nwLastTier = disabled;
		return;
	}
	// 4: too few wonders enabled to support the tier; reset the selection.
	if (enabled > 0 && requiredWonders(nameOf(NW_COUNT_PARAM_ID), getBaseWonders()) > enabled) {
		toggles.forEach((entry) => setOption(entry.id, TOGGLE_ENABLED));
	}
}

// ------------------------------------------------------- tier / age sync --

function syncTierWithAges(sync) {
	const tierParam = GameSetup.findGameParameter(sync.tierId);
	if (!tierParam) {
		return;
	}
	if (sync.ageIds.some((id) => !GameSetup.findGameParameter(id))) {
		return;
	}
	const tier = gameValue(sync.tierId);
	const custom = valueOf(sync.tierId, TIER_CUSTOM);
	if (tier == null || custom == null) {
		return;
	}
	const isCurated = tier != custom;
	const tierName = nameOf(sync.tierId);
	const mapped = sync.ageNames?.[tierName] ?? tierName;
	// A curated option is either one name shared by all three ages, or one per age.
	const ageNameAt = (index) => Array.isArray(mapped) ? mapped[index] : mapped;

	// 5: the player changed the tier; every age follows it.
	if (sync.lastTier != null && tier != sync.lastTier) {
		if (isCurated) {
			sync.ageIds.forEach((id, index) => setOption(id, ageNameAt(index)));
		}
		sync.lastTier = tier;
		return;
	}
	sync.lastTier = tier;
	// 6: an age no longer matches the tier; switch to Custom.
	if (isCurated && sync.ageIds.some((id, index) => gameValue(id) != valueOf(id, ageNameAt(index)))) {
		setOption(sync.tierId, TIER_CUSTOM);
		sync.lastTier = custom;
	}
}

// -------------------------------------------------------------- game pace --

function paceAgeIds(settingId) {
	return TIER_AGE_SYNCS.find((sync) => sync.tierId == settingId)?.ageIds ?? [];
}

function applyPacePreset(preset) {
	for (const [settingId, expected] of Object.entries(preset)) {
		if (Array.isArray(expected)) {
			setOption(settingId, TIER_CUSTOM);
			paceAgeIds(settingId).forEach((ageId, index) => setOption(ageId, expected[index]));
		} else {
			setOption(settingId, expected);
		}
	}
}

function matchesPacePreset(preset) {
	return Object.entries(preset).every(([settingId, expected]) => {
		if (!Array.isArray(expected)) {
			return holds(settingId, expected);
		}
		return holds(settingId, TIER_CUSTOM)
			&& paceAgeIds(settingId).every((ageId, index) => holds(ageId, expected[index]));
	});
}

// 10: the two Pace Set dropdowns share one domain and value; whichever changed wins.
function syncPaceMirror() {
	const pace = gameValue(PACE_PARAM_ID);
	const mirror = gameValue(PACE_MIRROR_PARAM_ID);
	if (pace == null || mirror == null) {
		return;
	}
	const paceChanged = lastPace != null && pace != lastPace;
	const mirrorChanged = lastPaceMirror != null && mirror != lastPaceMirror;
	if (mirrorChanged && !paceChanged) {
		GameSetup.setGameParameterValue(PACE_PARAM_ID, mirror);
	} else if (pace != mirror) {
		GameSetup.setGameParameterValue(PACE_MIRROR_PARAM_ID, pace);
	}
	lastPaceMirror = gameValue(PACE_MIRROR_PARAM_ID);
}

function syncPacePreset() {
	const paceParam = GameSetup.findGameParameter(PACE_PARAM_ID);
	if (!paceParam) {
		return;
	}
	const pace = gameValue(PACE_PARAM_ID);
	const preset = PACE_PRESETS[nameOf(PACE_PARAM_ID)];
	const ageLength = gameValue(AGE_LENGTH_PARAM_ID);
	const customAgeLength = valueOf(AGE_LENGTH_PARAM_ID, TIER_CUSTOM);
	if (pace == null || ageLength == null || customAgeLength == null || valueOf(PACE_PARAM_ID, PACE_CUSTOM) == null) {
		return;
	}
	const leftCustomAgeLength = lastAgeLength == customAgeLength && ageLength != customAgeLength;
	lastAgeLength = ageLength;

	// 7: the player chose a preset; every pacing setting takes its value.
	if (lastPace != null && pace != lastPace) {
		if (preset) {
			applyPacePreset(preset);
			lastAgeLength = null;
		}
		lastPace = pace;
		return;
	}
	lastPace = pace;
	// 9: Age Length left Custom; the other pacing settings return to Standard.
	if (leftCustomAgeLength) {
		applyPacePreset(Object.fromEntries(Object.entries(PACE_STANDARD).filter(([id]) => id != AGE_LENGTH_PARAM_ID)));
	}
	// 8: a pacing setting no longer matches the preset; it becomes Custom.
	if (preset && !matchesPacePreset(preset)) {
		setOption(PACE_PARAM_ID, PACE_CUSTOM);
		lastPace = valueOf(PACE_PARAM_ID, PACE_CUSTOM);
	}
}

// ------------------------------------------------------------------ crises --

function syncCrises() {
	const toggleParam = GameSetup.findGameParameter(CRISES_PARAM_ID);
	const selectionParam = GameSetup.findGameParameter(CRISES_SELECTION_PARAM_ID);
	if (!toggleParam || !selectionParam) {
		return;
	}
	const possible = (selectionParam.domain?.possibleValues ?? []).map((entry) => entry.value);
	if (possible.length == 0) {
		return;
	}
	const toggle = gameValue(CRISES_PARAM_ID);
	const toggleOff = valueOf(CRISES_PARAM_ID, TOGGLE_DISABLED);
	const toggleOn = valueOf(CRISES_PARAM_ID, TOGGLE_ENABLED);
	if (toggle == null || toggleOff == null || toggleOn == null) {
		return;
	}
	const excluded = (selectionParam.values ?? []).map((entry) => entry.value);
	const allExcluded = possible.every((value) => excluded.includes(value));
	const timingParam = GameSetup.findGameParameter(CRISIS_TIMING_PARAM_ID);
	const timingOff = valueOf(CRISIS_TIMING_PARAM_ID, TIER_DISABLED);
	// Without its options loaded the timing is left alone.
	const timing = timingParam && timingOff != null ? gameValue(CRISIS_TIMING_PARAM_ID) : null;

	// 11, 12 & 14: the player changed the toggle; cascade to the selection and timing.
	if (crisesLastToggle != null && toggle != crisesLastToggle) {
		if (toggle == toggleOff) {
			GameSetup.setGameParameterValue(CRISES_SELECTION_PARAM_ID, possible);
			setOption(CRISIS_TIMING_PARAM_ID, TIER_DISABLED);
		} else if (crisesLastToggle == toggleOff) {
			GameSetup.setGameParameterValue(CRISES_SELECTION_PARAM_ID, []);
			if (timing == timingOff) {
				setOption(CRISIS_TIMING_PARAM_ID, TIER_STANDARD);
			}
		}
		crisesLastToggle = toggle;
		crisisTimingLast = null;
		return;
	}
	const firstPass = crisesLastToggle == null;
	crisesLastToggle = toggle;
	// 16: the first pass of a setup keeps Crises and brings the rest in line.
	if (firstPass) {
		if (toggle == toggleOff && !allExcluded) {
			GameSetup.setGameParameterValue(CRISES_SELECTION_PARAM_ID, possible);
		} else if (toggle != toggleOff && allExcluded) {
			GameSetup.setGameParameterValue(CRISES_SELECTION_PARAM_ID, []);
		}
		if (timing != null && (timing == timingOff) != (toggle == toggleOff)) {
			setOption(CRISIS_TIMING_PARAM_ID, toggle == toggleOff ? TIER_DISABLED : TIER_STANDARD);
		}
		return;
	}
	// 15: the player changed the timing to or from Disabled; the toggle follows.
	if (timing != null && crisisTimingLast != null && timing != crisisTimingLast) {
		if (timing == timingOff && toggle != toggleOff) {
			setOption(CRISES_PARAM_ID, TOGGLE_DISABLED);
		} else if (crisisTimingLast == timingOff && toggle == toggleOff) {
			setOption(CRISES_PARAM_ID, TOGGLE_ENABLED);
		}
		crisisTimingLast = timing;
		return;
	}
	crisisTimingLast = timing;
	// 13 & 14: keep the toggle truthful about the selection, and the timing about the toggle.
	if (allExcluded && toggle != toggleOff) {
		setOption(CRISES_PARAM_ID, TOGGLE_DISABLED);
		setOption(CRISIS_TIMING_PARAM_ID, TIER_DISABLED);
		crisesLastToggle = toggleOff;
		crisisTimingLast = null;
	} else if (!allExcluded && toggle == toggleOff) {
		setOption(CRISES_PARAM_ID, TOGGLE_ENABLED);
		if (timing == timingOff) {
			setOption(CRISIS_TIMING_PARAM_ID, TIER_STANDARD);
		}
		crisesLastToggle = toggleOn;
		crisisTimingLast = null;
	} else if (timing != null && (timing == timingOff) != (toggle == toggleOff)) {
		// Loaded configurations can disagree; the toggle wins.
		setOption(CRISIS_TIMING_PARAM_ID, toggle == toggleOff ? TIER_DISABLED : TIER_STANDARD);
		crisisTimingLast = null;
	}
}

// ------------------------------------------------------------------ poller --

// Every rule's memory of the last pass, cleared so the next pass is a baseline.
function resetBaselines() {
	nwLastTier = null;
	lastPace = null;
	lastPaceMirror = null;
	lastAgeLength = null;
	crisesLastToggle = null;
	crisisTimingLast = null;
	TIER_AGE_SYNCS.forEach((sync) => { sync.lastTier = null; });
	optionsCache.clear();
}

// Runs one rule, logging rather than letting a throw stop the others.
function run(label, rule) {
	try {
		rule();
	} catch (e) {
		console.warn(`${LOG_PREFIX} ${label} failed: ${e}`);
	}
}

// Remembered settings go back first, and the rules wait until they have:
// answering the defaults the screen opens with would cascade over them.
onSetupPoll(() => run("setup memory restore", () => {
	if (tickSetupMemory()) {
		resetBaselines();
	}
}));

onSetupRevision((restarted) => {
	// A fresh setup, or the end of a restore: the last values are no baseline.
	if (restarted) {
		resetBaselines();
	}
	run("natural wonders", syncNaturalWonderSetup);
	run("pace set", () => {
		syncPaceMirror();
		syncPacePreset();
	});
	for (const sync of TIER_AGE_SYNCS) {
		run(sync.tierId, () => syncTierWithAges(sync));
	}
	run("crises", syncCrises);
	run("setup memory save", rememberSetup);
}, () => isSinglePlayerSetupOpen() && !isRestoringSetup());
