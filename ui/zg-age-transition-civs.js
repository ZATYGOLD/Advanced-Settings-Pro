// Historical, the mod's fifth value for the game's AI Civ Selection, Age
// Transition setting.
//
// The engine decides the AI's next civilization for the four values it knows
// (mirror the human, persist, switch to an apex civilization, or a coin flip
// between the two). It does not know this one, so when it is set every AI's
// civilization is written here, just before the next age starts, and the engine
// has nothing left to decide.
//
// Each AI follows its leader's associations, the game's own reading of them:
// LeaderCivilizationBias, the table the civilization picker uses to mark a
// leader's Historical, Geographic and Strategic choices for a human, each with
// a Bias of 1 to 4. Of the civilizations the new age offers the AI:
//   1. a Historical one, highest Bias first, then the next highest;
//   2. none Historical: a Geographic one, highest first. Strategic never.
//   3. Within a tier, one already taken by the human or an AI seated earlier
//      in this pass is passed over for the next; only when every civilization
//      of the tier is taken is a duplicate seated, as the last resort.
//   4. A tie at the top Bias goes to the civilization native to the new age
//      (the apex choice); no such civilization among the tied, or several,
//      and the tie is drawn at random.
// The pick becomes the AI's civilization; when it is the one the AI already
// holds, the AI persists. So Augustus, Rome at Bias 4, stays Rome for as long
// as an age still offers him Rome, while Napoleon leaves the Gauls for Spain
// and then the French Empire. A leader with no Historical or Geographic row on
// offer persists where the new age allows and otherwise takes a random
// civilization.
//
// Which civilizations the new age offers is read from the AI's own
// PlayerCivilization parameter, whose choices the engine has already narrowed
// to that age; the age's own civilizations come from Ages.PlayerCivilizationDomain.

const PARAM_ID = "AgeTransitionCivSelectionMode";
const HISTORICAL_VALUE = "AGE_TRANSITION_CIV_SELECTION_MODE_ZG_HISTORICAL";
const AGE_PARAM_ID = "Age";
const CIVILIZATION_PARAM_ID = "PlayerCivilization";
const LEADER_PARAM_ID = "PlayerLeader";
const RANDOM_VALUE = "RANDOM";
// In the order they are tried. Strategic rows are not associations and are left
// out. Matched on the prefix: one shipped row spells its type without "_CHOICE".
const CHOICE_TIERS = [
	{ name: "historical", choicePrefix: "LOC_CREATE_GAME_HISTORICAL" },
	{ name: "geographic", choicePrefix: "LOC_CREATE_GAME_GEOGRAPHIC" },
];
const LOG_PREFIX = "ZG-ASP age transition civs:";

const settingValue = () => GameSetup.findGameParameter(PARAM_ID)?.value?.value;
export const isHistoricalProgression = () => settingValue() == HISTORICAL_VALUE;

const draw = (list) => list[Math.floor(Math.random() * list.length)];

function query(sql) {
	try {
		return Database.query("config", sql) ?? [];
	} catch (error) {
		console.error(`${LOG_PREFIX} query failed: ${error}`);
		return [];
	}
}

// Leader type to its Historical and Geographic rows across every age, highest
// Bias first. The row's domain says which age the civilization is native to.
function leaderAssociations() {
	const out = new Map();
	for (const row of query("SELECT LeaderType, CivilizationType, CivilizationDomain, Bias, ChoiceType FROM LeaderCivilizationBias ORDER BY Bias DESC")) {
		const tier = CHOICE_TIERS.find((candidate) => row.ChoiceType?.startsWith(candidate.choicePrefix));
		if (!tier) {
			continue;
		}
		const rows = out.get(row.LeaderType) ?? [];
		if (!rows.some((known) => known.civ == row.CivilizationType)) {
			rows.push({ civ: row.CivilizationType, domain: row.CivilizationDomain, bias: row.Bias, tier: tier.name });
		}
		out.set(row.LeaderType, rows);
	}
	return out;
}

// The civilization domain native to the age being started.
function apexDomain() {
	const age = GameSetup.findGameParameter(AGE_PARAM_ID)?.value?.value;
	return query(`SELECT PlayerCivilizationDomain FROM Ages WHERE AgeType = '${age}'`)[0]?.PlayerCivilizationDomain;
}

// The association to seat a leader on, from the rows the new age offers, or
// null when it offers none of the leader's associations.
function chooseAssociation(rows, offered, takenCivs, apex) {
	for (const tier of CHOICE_TIERS) {
		const onOffer = rows.filter((row) => row.tier == tier.name && offered.has(row.civ));
		if (onOffer.length == 0) {
			continue;
		}
		const open = onOffer.filter((row) => !takenCivs.has(row.civ));
		const pool = open.length > 0 ? open : onOffer;
		let top = pool.filter((row) => row.bias == pool[0].bias);
		if (top.length > 1) {
			const native = top.filter((row) => row.domain == apex);
			top = native.length > 0 ? native : top;
		}
		return { civ: draw(top).civ, how: `${tier.name}${open.length == 0 ? " (duplicate)" : ""}${top.length > 1 ? " (tie)" : ""}` };
	}
	return null;
}

// Seats every AI for the new age. `takenCivs` holds the human's pick and grows
// with each AI seated here.
export function settleAiCivilizations(aiPlayerIds, takenCivs) {
	const associations = leaderAssociations();
	const apex = apexDomain();
	for (const playerId of aiPlayerIds) {
		const leader = GameSetup.findPlayerParameter(playerId, LEADER_PARAM_ID)?.value?.value;
		const civParam = GameSetup.findPlayerParameter(playerId, CIVILIZATION_PARAM_ID);
		const current = civParam?.value?.value;
		const offered = new Set((civParam?.domain?.possibleValues ?? []).map((entry) => entry.value).filter((civ) => civ != RANDOM_VALUE));
		const rows = associations.get(leader) ?? [];
		let pick = chooseAssociation(rows, offered, takenCivs, apex);
		if (!pick && current && offered.has(current)) {
			pick = { civ: current, how: "no association on offer; persisted" };
		}
		if (!pick && offered.size > 0) {
			const open = [...offered].filter((civ) => !takenCivs.has(civ));
			pick = { civ: draw(open.length > 0 ? open : [...offered]), how: "no association on offer; random" };
		}
		if (pick) {
			takenCivs.add(pick.civ);
			GameSetup.setPlayerParameterValue(playerId, CIVILIZATION_PARAM_ID, pick.civ);
		}
		const known = rows.map((row) => `${row.civ}:${row.bias}${row.tier[0]}`).join(" ") || "none";
		console.warn(`${LOG_PREFIX} player ${playerId} (${leader}, was ${current}; rows ${known}; ${offered.size} offered, apex ${apex}) ${pick ? `${pick.how} -> ${pick.civ}${pick.civ == current ? " (persists)" : ""}` : "nothing offered; left to the game"}`);
	}
}
