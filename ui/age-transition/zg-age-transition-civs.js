// Historical, the mod's fifth value for the game's AI Civ Selection, Age
// Transition setting.
//
// The engine decides the AI's next civilization for the four values it knows
// (mirror the human, persist, switch to an apex civilization, or a coin flip
// between the two). It does not know this one, so when it is set every AI's
// civilization is written here before the next age starts, into the slots the
// caller names (zg-memento-roller.js). Experimental: since patch 1.5 the engine
// may still choose the AI's civilization itself.
//
// Each AI keeps to its leader's history: it moves on when the new age offers
// the leader a Historical civilization, holds its own when that is the
// Historical one, and otherwise takes the game's usual path forward. Leader
// associations come from LeaderCivilizationBias, the table the civilization
// picker uses to mark a leader's Historical, Geographic and Strategic choices,
// each with a Bias of 1 to 4. The first step with a civilization on offer wins:
//   1. Historical: one native to the new age, or the AI's own civilization,
//      highest Bias first.
//   2. Geographic and on the path: native to the new age and unlocked by the
//      AI's civilization (CivilizationUnlocks), highest Bias first.
//   3. On the path: any new-age civilization the AI's civilization unlocks.
//   4. Geographic: any native to the new age, highest Bias first.
//   5. The AI's own civilization, if the new age lets it persist.
//   6. Any new-age civilization at random.
// Within a step a tie goes to the new age's civilization, then to the most
// direct successor (Ming, reached only from Han, over Mongolia), then at random.
// A civilization already taken by the human or an AI seated earlier in this
// pass is passed over; only when every step is taken is a duplicate seated.
// So Hatshepsut stays Egypt, Isabella goes Rome, Spain, Spain, Yi Sun-sin goes
// Silla, Goryeo, Joseon, and Confucius follows Han to Ming and then Qing.
//
// Which civilizations the new age offers is read from the choices of the
// civilization slot, which the engine has already narrowed; with none listed,
// the new age's civilizations and the AI's own are assumed. The age's own
// civilizations come from Ages.PlayerCivilizationDomain.
import { cached, gameValue, playerValue, queryConfig } from '../shared/zg-config.js';
import { leaderAssociations } from '../shared/zg-civ-associations.js';
import { SETUP_SLOTS } from '../shared/zg-memento-roller.js';

const PARAM_ID = "AgeTransitionCivSelectionMode";
const HISTORICAL_VALUE = "AGE_TRANSITION_CIV_SELECTION_MODE_ZG_HISTORICAL";
const RANDOM_VALUE = "RANDOM";
const LOG_PREFIX = "ZG-ASP age transition civs:";

export const isHistoricalProgression = () => gameValue(PARAM_ID) == HISTORICAL_VALUE;

const draw = (list) => list[Math.floor(Math.random() * list.length)];

// The game's path between ages (CivilizationUnlocks): each civilization's
// successors, and how many civilizations lead to each one.
function buildCivilizationLineage() {
	const successors = new Map();
	const predecessors = new Map();
	for (const row of queryConfig("SELECT CivilizationType, Type FROM CivilizationUnlocks WHERE Kind = 'KIND_CIVILIZATION'")) {
		const next = successors.get(row.CivilizationType) ?? new Set();
		next.add(row.Type);
		successors.set(row.CivilizationType, next);
		predecessors.set(row.Type, (predecessors.get(row.Type) ?? 0) + 1);
	}
	return { successors, predecessors };
}
const civilizationLineage = cached(buildCivilizationLineage);

// The civilizations native to an age.
const civilizationsByAge = cached(() => {
	const byDomain = new Map();
	for (const row of queryConfig("SELECT CivilizationType, Domain FROM Civilizations")) {
		byDomain.set(row.Domain, (byDomain.get(row.Domain) ?? new Set()).add(row.CivilizationType));
	}
	return new Map(queryConfig("SELECT AgeType, PlayerCivilizationDomain FROM Ages")
		.map((age) => [age.AgeType, byDomain.get(age.PlayerCivilizationDomain) ?? new Set()]));
});
const ageCivilizations = (ageType) => civilizationsByAge().get(ageType) ?? new Set();

// The steps of the rule above, each a list of { civ, bias } candidates.
function candidateSteps(rows, current, offered, native, unlocked) {
	const nextAge = (civ) => native.has(civ);
	const onPath = (civ) => native.has(civ) && unlocked.has(civ);
	const associated = (tier, keep) => rows.filter((row) => row.tier == tier && offered.has(row.civ) && keep(row.civ));
	const plain = (keep) => [...offered].filter(keep).map((civ) => ({ civ, bias: 0 }));
	return [
		{ how: "historical", candidates: associated("historical", (civ) => nextAge(civ) || civ == current) },
		{ how: "geographic on path", candidates: associated("geographic", onPath) },
		{ how: "on path", candidates: plain(onPath) },
		{ how: "geographic", candidates: associated("geographic", nextAge) },
		{ how: "persisted", candidates: plain((civ) => civ == current) },
		{ how: "random", candidates: plain(nextAge) },
	];
}

// Keeps the candidates scoring highest.
function topBy(candidates, score) {
	const best = Math.max(...candidates.map(score));
	return candidates.filter((candidate) => score(candidate) == best);
}

// Highest Bias among the candidates; a tie goes to the new age's civilization,
// then to the most direct successor (the fewest civilizations leading to it),
// and is then drawn at random.
function bestOf(candidates, native, predecessors) {
	let top = topBy(candidates, (candidate) => candidate.bias);
	top = topBy(top, (candidate) => (native.has(candidate.civ) ? 1 : 0));
	top = topBy(top, (candidate) => -(predecessors.get(candidate.civ) ?? 0));
	return { civ: draw(top).civ, tie: top.length > 1 };
}

// The first step with an open civilization; only then a duplicate.
function choose(steps, takenCivs, native, predecessors) {
	for (const allowTaken of [false, true]) {
		for (const step of steps) {
			const pool = allowTaken ? step.candidates : step.candidates.filter((candidate) => !takenCivs.has(candidate.civ));
			if (pool.length > 0) {
				const { civ, tie } = bestOf(pool, native, predecessors);
				return { civ, how: `${step.how}${allowTaken ? " (duplicate)" : ""}${tie ? " (tie)" : ""}` };
			}
		}
	}
	return null;
}

// The civilizations a slot offers, or with none listed the new age's and the
// AI's own.
function offeredCivilizations(param, ageCivs, current) {
	const listed = (param?.domain?.possibleValues ?? []).map((entry) => entry.value).filter((civ) => civ != RANDOM_VALUE);
	return listed.length > 0 ? { offered: new Set(listed), source: "listed" } : { offered: new Set([...ageCivs, current].filter(Boolean)), source: "assumed" };
}

// Seats every AI for `ageType`, writing each pick to `slots.civilization`.
// The AI's civilization so far is its setup PlayerCivilization. `takenCivs`
// holds the human's pick and grows with each AI seated here.
export function settleAiCivilizations(aiPlayerIds, takenCivs, ageType, slots = SETUP_SLOTS) {
	const associations = leaderAssociations();
	const { successors, predecessors } = civilizationLineage();
	const ageCivs = ageCivilizations(ageType);
	for (const playerId of aiPlayerIds) {
		const leader = playerValue(playerId, slots.leader);
		const current = playerValue(playerId, SETUP_SLOTS.civilization);
		const { offered, source } = offeredCivilizations(GameSetup.findPlayerParameter(playerId, slots.civilization), ageCivs, current);
		const native = new Set([...offered].filter((civ) => ageCivs.has(civ)));
		const rows = associations.get(leader) ?? [];
		const pick = choose(candidateSteps(rows, current, offered, native, successors.get(current) ?? new Set()), takenCivs, native, predecessors);
		if (pick) {
			takenCivs.add(pick.civ);
			GameSetup.setPlayerParameterValue(playerId, slots.civilization, pick.civ);
		}
		const known = rows.map((row) => `${row.civ}:${row.bias}${row.tier[0]}`).join(" ") || "none";
		console.log(`${LOG_PREFIX} player ${playerId} (${leader}, was ${current}; rows ${known}; ${offered.size} ${source}, ${native.size} new-age) ${pick ? `${pick.how} -> ${pick.civ}${pick.civ == current ? " (persists)" : ""}` : "nothing offered; left to the game"}`);
	}
}
