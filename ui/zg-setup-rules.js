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

const NW_COUNT_PARAM_ID = "ZG_NaturalWondersCount";
const MAP_SIZE_PARAM_ID = "MapSize";
const WONDER_PARAM_IDS = [
	"ZG_NW_BarrierReef", "ZG_NW_BermudaTriangle", "ZG_NW_GrandCanyon", "ZG_NW_GreatBlueHole",
	"ZG_NW_Gullfoss", "ZG_NW_Hoerikwaggo", "ZG_NW_IguazuFalls", "ZG_NW_Kilimanjaro",
	"ZG_NW_Machapuchare", "ZG_NW_MapuAVaeaBlowholes", "ZG_NW_MountEverest", "ZG_NW_MountFuji",
	"ZG_NW_RedwoodForest", "ZG_NW_Thera", "ZG_NW_TorresDelPaine", "ZG_NW_Uluru",
	"ZG_NW_ValleyOfFlowers", "ZG_NW_Vihren", "ZG_NW_Vinicunca", "ZG_NW_Zhangjiajie",
];

const SL_PARAM_ID = "ZG_SettlementLimit";
const SL_AGE_PARAM_IDS = ["ZG_SettlementLimitAntiquity", "ZG_SettlementLimitExploration", "ZG_SettlementLimitModern"];
// Values applied by the curated tiers' SQL, in age order (Antiquity, Exploration, Modern).
const SL_TIER_VALUES = {
	"LOC_ZG_LESS_NAME": [1, 4, 10],
	"LOC_ZG_DEFAULT_NAME": [3, 8, 16],
	"LOC_ZG_MORE_NAME": [5, 12, 20],
};

const TIER_DISABLED = "LOC_ZG_DISABLED_NAME";
const TIER_HALF = "LOC_ZG_HALF_NAME";
const TIER_DEFAULT = "LOC_ZG_DEFAULT_NAME";
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
		case TIER_DEFAULT: return base;
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
	applying = false;
}, POLL_MS);
