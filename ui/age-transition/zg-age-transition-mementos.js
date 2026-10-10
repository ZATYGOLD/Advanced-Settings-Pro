// Age Transition AI Mementos: what becomes of the AI players' mementos when an
// age turns over.
//
//   Maintain  keeps every AI's slots as they are.
//   Adapt     draws them again by the AI Mementos rule, against the leader and
//             civilization the player holds in the new age.
//
// The caller names the slots (zg-memento-roller.js). The setup's own already
// hold the AI's mementos, so Maintain leaves them; the AgeTransitionPlayer ones
// are filled by the engine otherwise, so Maintain copies the current mementos in.
// Called after the civilizations are settled, so Civilization Match sees the
// new civilization.

import { SETUP_SLOTS, aiMementoMode, drawMementos } from '../shell/shared/zg-memento-roller.js';

const PARAM_ID = "ZG_AgeTransitionMementos";
const ADAPT_VALUE = "ZG_AGE_TRANSITION_MEMENTOS_ADAPT";
const LOG_PREFIX = "ZG-ASP age transition mementos:";

const settingValue = () => GameSetup.findGameParameter(PARAM_ID)?.value?.value;
const playerValue = (playerId, id) => GameSetup.findPlayerParameter(playerId, id)?.value?.value;
const slotValues = (playerId, slots) => slots.mementos.map((id) => playerValue(playerId, id)).join(", ");

// Copies the AI's current mementos into `slots`; nothing to do for the setup's own.
function keepMementos(playerId, slots) {
	slots.mementos.forEach((id, slotIndex) => {
		const current = playerValue(playerId, SETUP_SLOTS.mementos[slotIndex]);
		if (id != SETUP_SLOTS.mementos[slotIndex] && current) {
			GameSetup.setPlayerParameterValue(playerId, id, current);
		}
	});
}

export function settleAiMementos(aiPlayerIds, slots = SETUP_SLOTS) {
	const value = settingValue();
	const mode = aiMementoMode();
	console.warn(`${LOG_PREFIX} ${value ?? "unset"}`);
	for (const playerId of aiPlayerIds) {
		const before = slotValues(playerId, slots);
		const drew = value == ADAPT_VALUE && drawMementos(mode, playerId, slots);
		if (!drew) {
			keepMementos(playerId, slots);
		}
		const who = `${playerValue(playerId, slots.leader)} / ${playerValue(playerId, slots.civilization)}`;
		const choices = GameSetup.findPlayerParameter(playerId, slots.mementos[0])?.domain?.possibleValues?.length ?? 0;
		console.warn(`${LOG_PREFIX} player ${playerId} (${who}, ${choices} choices) ${drew ? "drew" : "kept"} ${before} -> ${slotValues(playerId, slots)}`);
	}
}
