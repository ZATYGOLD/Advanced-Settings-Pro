// Keeps related setup parameters consistent with each other.
//
// Natural wonders:
//   1. Count set to Disabled        -> every wonder toggle becomes Disabled.
//   2. Count leaves Disabled        -> every wonder toggle becomes Enabled.
//   3. Every toggle Disabled        -> count becomes Disabled.
//   4. Too few wonders enabled to support the tier on the current map size
//      -> every wonder toggle is reset to Enabled.
//
// Settlement limits:
//   5. A curated tier is selected   -> the per-age limits show that tier's values.
//   6. A per-age limit is changed away from the curated tier's values
//      -> the Settlement Limit setting switches to Custom.
//
// Disasters and Triumph Sets (shared tier/age sync):
//   7. A tier is selected           -> every age shows that tier.
//   8. An age is changed away from the selected tier
//      -> the primary setting switches to Custom.
//
// Pace Set:
//   9. A preset is selected         -> every All Ages setting takes the preset's value.
//  10. An All Ages setting no longer matches the selected preset
//      -> Pace Set switches to Custom.
//  11. Age Length leaves Custom      -> every other All Ages setting returns to Standard.
//  12. Pace Set (General) and Pace Set (Pace tab) mirror each other.
//
// Crises:
//  13. Crises set to Disabled       -> every crisis in the selection is excluded.
//  14. Crises leaves Disabled       -> every crisis in the selection is included.
//  15. Every crisis excluded        -> Crises becomes Disabled; any crisis included
//      while it says Disabled       -> Crises becomes Enabled.
//  16. Crises Disabled              -> Crisis Timing shows Disabled; Crises Enabled
//      while the timing says Disabled -> the timing returns to Default.
//  17. Crisis Timing set to Disabled -> Crises becomes Disabled; the timing leaves
//      Disabled                     -> Crises becomes Enabled.

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

const SL_PARAM_ID = "ZG_SettlementLimit";
const SL_AGE_PARAM_IDS = ["ZG_SettlementLimitAntiquity", "ZG_SettlementLimitExploration", "ZG_SettlementLimitModern"];
// Values applied by the curated tiers' SQL, in age order (Antiquity, Exploration, Modern).
const SL_TIER_VALUES = {
	"LOC_ZG_LESS_NAME": [1, 4, 10],
	"LOC_ADVANCED_OPTIONS_STANDARD": [3, 8, 16],
	"LOC_ZG_MORE_NAME": [5, 12, 20],
};

const AGE_LENGTH_PARAM_ID = "AgeLength";

// Per-age value names for primaries whose age rows use a different scale.
const AGE_LENGTH_AGE_NAMES = {
	"LOC_ZG_AGE_LENGTH_BRIEF_NAME": "LOC_ZG_NUM_90",
	"LOC_ADVANCED_OPTIONS_ABBREVIATED": "LOC_ZG_NUM_120",
	"LOC_ADVANCED_OPTIONS_STANDARD": "LOC_ZG_NUM_140",
	"LOC_ADVANCED_OPTIONS_LONG": "LOC_ZG_NUM_160",
	"LOC_ZG_AGE_LENGTH_DOUBLED_NAME": "LOC_ZG_NUM_280",
};
const COST_AGE_NAMES = {
	"LOC_ZG_LOW_NAME": "LOC_ZG_PCT_MINUS_25",
	"LOC_ADVANCED_OPTIONS_STANDARD": "LOC_ADVANCED_OPTIONS_STANDARD",
	"LOC_ZG_HIGH_NAME": "LOC_ZG_PCT_PLUS_50",
	"LOC_ZG_DOUBLE_NAME": "LOC_ZG_PCT_PLUS_100",
};

// Primary settings whose per-age values are kept in step (rules 7 & 8).
// ageNames maps a primary value name to its per-age value name (identity when absent).
const TIER_AGE_SYNCS = [
	{ tierId: "ZG_DisasterFrequency", ageIds: ["ZG_DisastersAntiquity", "ZG_DisastersExploration", "ZG_DisastersModern"], lastTier: null },
	{ tierId: "LegacySets", ageIds: ["ZG_TriumphSetAntiquity", "ZG_TriumphSetExploration", "ZG_TriumphSetModern"], lastTier: null },
	{ tierId: AGE_LENGTH_PARAM_ID, ageIds: ["ZG_AgeLengthAntiquity", "ZG_AgeLengthExploration", "ZG_AgeLengthModern"], ageNames: AGE_LENGTH_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_AgeProgressRate", ageIds: ["ZG_AgeProgressRateAntiquity", "ZG_AgeProgressRateExploration", "ZG_AgeProgressRateModern"], lastTier: null },
	{ tierId: "ZG_TechnologyCost", ageIds: ["ZG_TechnologyCostAntiquity", "ZG_TechnologyCostExploration", "ZG_TechnologyCostModern"], ageNames: COST_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_CivicCost", ageIds: ["ZG_CivicCostAntiquity", "ZG_CivicCostExploration", "ZG_CivicCostModern"], ageNames: COST_AGE_NAMES, lastTier: null },
	{ tierId: "ZG_CityGrowth", ageIds: ["ZG_CityGrowthAntiquity", "ZG_CityGrowthExploration", "ZG_CityGrowthModern"], lastTier: null },
	{ tierId: "ZG_Roads", ageIds: ["ZG_RoadsAntiquity", "ZG_RoadsExploration", "ZG_RoadsModern"], lastTier: null },
	{ tierId: "ZG_VictoryProjectCost", ageIds: ["ZG_VictoryProjectCostAntiquity", "ZG_VictoryProjectCostExploration", "ZG_VictoryProjectCostModern"], ageNames: COST_AGE_NAMES, lastTier: null },
];

// Pace Set presets (rules 9 & 10): each All Ages setting's value by name,
// or a per-age list (Antiquity, Exploration, Modern) that puts it on Custom.
const PACE_PARAM_ID = "ZG_PacePreset";
const PACE_MIRROR_PARAM_ID = "ZG_PaceSetMirror";
const PACE_CUSTOM = "LOC_ZG_PACE_PRESET_CUSTOM_NAME";
const PACE_STANDARD = {
	[AGE_LENGTH_PARAM_ID]: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_AgeProgressRate: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_TechnologyCost: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_CivicCost: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_CityGrowth: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_Roads: "LOC_ADVANCED_OPTIONS_STANDARD",
	ZG_VictoryProjectCost: "LOC_ADVANCED_OPTIONS_STANDARD",
};
const PACE_PRESETS = {
	"LOC_ZG_PACE_PRESET_STANDARD_NAME": PACE_STANDARD,
	// Eras+ Balanced Extended+: age caps 153/166/196, its milestone curve, 1.5x techs and civics.
	"LOC_ZG_PACE_PRESET_BALANCED_NAME": {
		...PACE_STANDARD,
		[AGE_LENGTH_PARAM_ID]: ["LOC_ZG_NUM_153", "LOC_ZG_NUM_166", "LOC_ZG_NUM_196"],
		ZG_AgeProgressRate: "LOC_ZG_BALANCED_NAME",
		ZG_TechnologyCost: "LOC_ZG_HIGH_NAME",
		ZG_CivicCost: "LOC_ZG_HIGH_NAME",
	},
	// Eras+ MP Pace: age caps 140/155/190, its milestone curve, techs 1.35/1.5/1.75x,
	// civics 1.45/1.6/1.85x, slightly slower growth, faster roads and Modern railroads,
	// victory projects 1.2x.
	"LOC_ZG_PACE_PRESET_MULTIPLAYER_NAME": {
		...PACE_STANDARD,
		[AGE_LENGTH_PARAM_ID]: ["LOC_ZG_NUM_140", "LOC_ZG_NUM_155", "LOC_ZG_NUM_190"],
		ZG_AgeProgressRate: "LOC_ZG_BALANCED_NAME",
		ZG_TechnologyCost: ["LOC_ZG_PCT_PLUS_35", "LOC_ZG_PCT_PLUS_50", "LOC_ZG_PCT_PLUS_75"],
		ZG_CivicCost: ["LOC_ZG_PCT_PLUS_45", "LOC_ZG_PCT_PLUS_60", "LOC_ZG_PCT_PLUS_85"],
		ZG_CityGrowth: "LOC_ZG_SLOW_NAME",
		ZG_Roads: ["LOC_ZG_FAST_NAME", "LOC_ZG_FAST_NAME", "LOC_ZG_ROADS_EXPRESS_NAME"],
		ZG_VictoryProjectCost: ["LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ADVANCED_OPTIONS_STANDARD", "LOC_ZG_PCT_PLUS_20"],
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
const TOGGLE_DISABLED = "LOC_ZG_DISABLED_NAME";

// Base wonder counts per map size (Maps.NumNaturalWonders).
const BASE_WONDERS = { TINY: 3, SMALL: 4, STANDARD: 5, LARGE: 6, HUGE: 7 };

const POLL_MS = 250;
let lastRevision = -1;
let nwLastTier = null;
let slLastTier = null;
let crisesLastToggle = null;
let crisisTimingLast = null;
let applying = false;

function resolveName(handle) {
	return GameSetup.resolveString(handle) ?? "";
}

function currentValueName(param) {
	const current = param?.value?.value;
	const possible = param?.domain?.possibleValues ?? [];
	const hit = possible.find((entry) => entry.value == current);
	return hit ? resolveName(hit.name) : "";
}

function valueForName(param, nameTag) {
	const possible = param?.domain?.possibleValues ?? [];
	const hit = possible.find((entry) => resolveName(entry.name) == nameTag);
	return hit ? hit.value : null;
}

function setParamByName(paramId, nameTag) {
	const param = GameSetup.findGameParameter(paramId);
	const value = valueForName(param, nameTag);
	if (param && value != null && param.value?.value != value) {
		GameSetup.setGameParameterValue(paramId, value);
	}
}

function numberFromName(nameTag) {
	const match = /^LOC_ZG_NUM_(\d+)$/.exec(nameTag);
	return match ? parseInt(match[1], 10) : null;
}

// ---------------------------------------------------------------- wonders --

function getBaseWonders() {
	const sizeName = currentValueName(GameSetup.findGameParameter(MAP_SIZE_PARAM_ID)).toUpperCase();
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
	const tier = currentValueName(countParam);
	const enabled = toggles.filter((entry) => currentValueName(entry.param) == TOGGLE_ENABLED).length;

	// 1 & 2: the player changed the count tier; cascade to the toggles.
	if (nwLastTier != null && tier != nwLastTier) {
		if (tier == TIER_DISABLED) {
			toggles.forEach((entry) => setParamByName(entry.id, TOGGLE_DISABLED));
		} else if (nwLastTier == TIER_DISABLED) {
			toggles.forEach((entry) => setParamByName(entry.id, TOGGLE_ENABLED));
		}
		nwLastTier = tier;
		return;
	}
	nwLastTier = tier;
	// 3: every wonder disabled; the count must say so.
	if (enabled == 0 && tier != TIER_DISABLED) {
		setParamByName(NW_COUNT_PARAM_ID, TIER_DISABLED);
		nwLastTier = TIER_DISABLED;
		return;
	}
	// 4: too few wonders enabled to support the tier; reset the selection.
	if (enabled > 0 && requiredWonders(tier, getBaseWonders()) > enabled) {
		toggles.forEach((entry) => setParamByName(entry.id, TOGGLE_ENABLED));
	}
}

// ------------------------------------------------------- settlement limits --

function syncSettlementLimits() {
	const tierParam = GameSetup.findGameParameter(SL_PARAM_ID);
	if (!tierParam) {
		return;
	}
	const ageParams = SL_AGE_PARAM_IDS.map((id) => GameSetup.findGameParameter(id));
	if (ageParams.some((param) => !param)) {
		return;
	}
	const tier = currentValueName(tierParam);
	const prescribed = SL_TIER_VALUES[tier];

	// 5: the player changed the tier; show that tier's values on the age rows.
	if (slLastTier != null && tier != slLastTier) {
		if (prescribed) {
			ageParams.forEach((param, i) => setParamByName(SL_AGE_PARAM_IDS[i], `LOC_ZG_NUM_${prescribed[i]}`));
		}
		slLastTier = tier;
		return;
	}
	slLastTier = tier;
	// 6: an age row no longer matches the curated tier; switch to Custom.
	if (prescribed) {
		const values = ageParams.map((param) => numberFromName(currentValueName(param)));
		if (values.some((value, i) => value != prescribed[i])) {
			setParamByName(SL_PARAM_ID, TIER_CUSTOM);
			slLastTier = TIER_CUSTOM;
		}
	}
}

// ------------------------------------------------------- tier / age sync --

function syncTierWithAges(sync) {
	const tierParam = GameSetup.findGameParameter(sync.tierId);
	if (!tierParam) {
		return;
	}
	const ageParams = sync.ageIds.map((id) => GameSetup.findGameParameter(id));
	if (ageParams.some((param) => !param)) {
		return;
	}
	const tier = currentValueName(tierParam);
	const isCurated = tier != TIER_CUSTOM;
	const ageName = sync.ageNames?.[tier] ?? tier;

	// 7: the player changed the tier; every age follows it.
	if (sync.lastTier != null && tier != sync.lastTier) {
		if (isCurated) {
			sync.ageIds.forEach((id) => setParamByName(id, ageName));
		}
		sync.lastTier = tier;
		return;
	}
	sync.lastTier = tier;
	// 8: an age no longer matches the tier; switch to Custom.
	if (isCurated && ageParams.some((param) => currentValueName(param) != ageName)) {
		setParamByName(sync.tierId, TIER_CUSTOM);
		sync.lastTier = TIER_CUSTOM;
	}
}

// -------------------------------------------------------------- game pace --

function paceAgeIds(settingId) {
	return TIER_AGE_SYNCS.find((sync) => sync.tierId == settingId)?.ageIds ?? [];
}

function applyPacePreset(preset) {
	for (const [settingId, expected] of Object.entries(preset)) {
		if (Array.isArray(expected)) {
			setParamByName(settingId, TIER_CUSTOM);
			paceAgeIds(settingId).forEach((ageId, index) => setParamByName(ageId, expected[index]));
		} else {
			setParamByName(settingId, expected);
		}
	}
}

function matchesPacePreset(preset) {
	return Object.entries(preset).every(([settingId, expected]) => {
		const tier = currentValueName(GameSetup.findGameParameter(settingId));
		if (!Array.isArray(expected)) {
			return tier == expected;
		}
		return tier == TIER_CUSTOM
			&& paceAgeIds(settingId).every((ageId, index) => currentValueName(GameSetup.findGameParameter(ageId)) == expected[index]);
	});
}

// 12: the two Pace Set dropdowns share one value; whichever changed wins.
function syncPaceMirror() {
	const pace = currentValueName(GameSetup.findGameParameter(PACE_PARAM_ID));
	const mirror = currentValueName(GameSetup.findGameParameter(PACE_MIRROR_PARAM_ID));
	const paceChanged = lastPace != null && pace != lastPace;
	const mirrorChanged = lastPaceMirror != null && mirror != lastPaceMirror;
	if (mirrorChanged && !paceChanged) {
		setParamByName(PACE_PARAM_ID, mirror);
	} else if (pace != mirror) {
		setParamByName(PACE_MIRROR_PARAM_ID, pace);
	}
	lastPaceMirror = currentValueName(GameSetup.findGameParameter(PACE_MIRROR_PARAM_ID));
}

function syncPacePreset() {
	const paceParam = GameSetup.findGameParameter(PACE_PARAM_ID);
	if (!paceParam) {
		return;
	}
	const pace = currentValueName(paceParam);
	const preset = PACE_PRESETS[pace];
	const ageLength = currentValueName(GameSetup.findGameParameter(AGE_LENGTH_PARAM_ID));
	const leftCustomAgeLength = lastAgeLength == TIER_CUSTOM && ageLength != TIER_CUSTOM;
	lastAgeLength = ageLength;

	// 9: the player chose a preset; every pacing setting takes its value.
	if (lastPace != null && pace != lastPace) {
		if (preset) {
			applyPacePreset(preset);
			lastAgeLength = null;
		}
		lastPace = pace;
		return;
	}
	lastPace = pace;
	// 11: Age Length left Custom; the other pacing settings return to Standard.
	if (leftCustomAgeLength) {
		applyPacePreset(Object.fromEntries(Object.entries(PACE_STANDARD).filter(([id]) => id != AGE_LENGTH_PARAM_ID)));
	}
	// 10: a pacing setting no longer matches the preset; it becomes Custom.
	if (preset && !matchesPacePreset(preset)) {
		setParamByName(PACE_PARAM_ID, PACE_CUSTOM);
		lastPace = PACE_CUSTOM;
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
	const toggle = currentValueName(toggleParam);
	const excluded = (selectionParam.values ?? []).map((entry) => entry.value);
	const allExcluded = possible.every((value) => excluded.includes(value));
	const timingParam = GameSetup.findGameParameter(CRISIS_TIMING_PARAM_ID);
	const timing = timingParam ? currentValueName(timingParam) : null;

	// 13 & 14: the player changed the toggle; cascade to the selection and timing.
	if (crisesLastToggle != null && toggle != crisesLastToggle) {
		if (toggle == TOGGLE_DISABLED) {
			GameSetup.setGameParameterValue(CRISES_SELECTION_PARAM_ID, possible);
			setParamByName(CRISIS_TIMING_PARAM_ID, TIER_DISABLED);
		} else if (crisesLastToggle == TOGGLE_DISABLED) {
			GameSetup.setGameParameterValue(CRISES_SELECTION_PARAM_ID, []);
			if (timing == TIER_DISABLED) {
				setParamByName(CRISIS_TIMING_PARAM_ID, TIER_STANDARD);
			}
		}
		crisesLastToggle = toggle;
		crisisTimingLast = null;
		return;
	}
	crisesLastToggle = toggle;
	// 17: the player changed the timing to or from Disabled; the toggle follows.
	if (timing != null && crisisTimingLast != null && timing != crisisTimingLast) {
		if (timing == TIER_DISABLED && toggle != TOGGLE_DISABLED) {
			setParamByName(CRISES_PARAM_ID, TOGGLE_DISABLED);
		} else if (crisisTimingLast == TIER_DISABLED && toggle == TOGGLE_DISABLED) {
			setParamByName(CRISES_PARAM_ID, TOGGLE_ENABLED);
		}
		crisisTimingLast = timing;
		return;
	}
	crisisTimingLast = timing;
	// 15 & 16: keep the toggle truthful about the selection, and the timing about the toggle.
	if (allExcluded && toggle != TOGGLE_DISABLED) {
		setParamByName(CRISES_PARAM_ID, TOGGLE_DISABLED);
		setParamByName(CRISIS_TIMING_PARAM_ID, TIER_DISABLED);
		crisesLastToggle = TOGGLE_DISABLED;
		crisisTimingLast = null;
	} else if (!allExcluded && toggle == TOGGLE_DISABLED) {
		setParamByName(CRISES_PARAM_ID, TOGGLE_ENABLED);
		if (timing == TIER_DISABLED) {
			setParamByName(CRISIS_TIMING_PARAM_ID, TIER_STANDARD);
		}
		crisesLastToggle = TOGGLE_ENABLED;
		crisisTimingLast = null;
	} else if (timing != null && (timing == TIER_DISABLED) != (toggle == TOGGLE_DISABLED)) {
		// Loaded configurations can disagree; the toggle wins.
		setParamByName(CRISIS_TIMING_PARAM_ID, toggle == TOGGLE_DISABLED ? TIER_DISABLED : TIER_STANDARD);
		crisisTimingLast = null;
	}
}

// ------------------------------------------------------------------ poller --

setInterval(() => {
	const revision = GameSetup.currentRevision;
	if (revision == lastRevision || applying) {
		return;
	}
	lastRevision = revision;
	applying = true;
	try {
		syncNaturalWonderSetup();
	} catch (e) {
		console.warn(`ZG-ASP wonder sync error: ${e}`);
	}
	try {
		syncSettlementLimits();
	} catch (e) {
		console.warn(`ZG-ASP settlement sync error: ${e}`);
	}
	try {
		syncPaceMirror();
		syncPacePreset();
	} catch (e) {
		console.warn(`ZG-ASP pace set sync error: ${e}`);
	}
	for (const sync of TIER_AGE_SYNCS) {
		try {
			syncTierWithAges(sync);
		} catch (e) {
			console.warn(`ZG-ASP ${sync.tierId} sync error: ${e}`);
		}
	}
	try {
		syncCrises();
	} catch (e) {
		console.warn(`ZG-ASP crises sync error: ${e}`);
	}
	applying = false;
}, POLL_MS);
