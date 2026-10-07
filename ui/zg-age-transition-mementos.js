// Age Transition AI Mementos: what becomes of the AI players' mementos when an
// age turns over.
//
//   Maintain  leaves every AI's slots as they are.
//   Adapt     draws them again by the AI Mementos rule, against the leader and
//             civilization the player holds in the new age.
//
// The AI's mementos are ordinary player parameters at the transition, the same
// ones the Player tab writes. zg-age-transition.js calls this just before the
// next age starts, after the civilizations are settled, so Civilization Match
// sees the new civilization.

import { MEMENTO_PARAM_IDS, aiMementoMode, drawMementos } from './zg-memento-roller.js';

const PARAM_ID = "ZG_AgeTransitionMementos";
const ADAPT_VALUE = "ZG_AGE_TRANSITION_MEMENTOS_ADAPT";
const LOG_PREFIX = "ZG-ASP age transition mementos:";

const settingValue = () => GameSetup.findGameParameter(PARAM_ID)?.value?.value;
const playerValue = (playerId, id) => GameSetup.findPlayerParameter(playerId, id)?.value?.value;
const slotValues = (playerId) => MEMENTO_PARAM_IDS.map((id) => playerValue(playerId, id)).join(", ");

export function settleAiMementos(aiPlayerIds) {
	const value = settingValue();
	console.warn(`${LOG_PREFIX} ${value ?? "unset"}`);
	if (value != ADAPT_VALUE) {
		return;
	}
	const mode = aiMementoMode();
	for (const playerId of aiPlayerIds) {
		const before = slotValues(playerId);
		const drew = drawMementos(mode, playerId);
		const who = `${playerValue(playerId, "PlayerLeader")} / ${playerValue(playerId, "PlayerCivilization")}`;
		const choices = GameSetup.findPlayerParameter(playerId, MEMENTO_PARAM_IDS[0])?.domain?.possibleValues?.length ?? 0;
		console.warn(`${LOG_PREFIX} player ${playerId} (${who}, ${choices} choices) ${drew ? `${before} -> ${slotValues(playerId)}` : `kept ${before} (AI Mementos is None)`}`);
	}
}
