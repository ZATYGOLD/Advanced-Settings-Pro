// The mod's hook into a single-player age transition, in game.
//
// Since patch 1.5 the human makes their age transition choices in game. Once
// they confirm them (SET_AGE_TRANSITION_DATA, Finished), the engine carries
// every player's AgeTransitionPlayer parameters into the next age and loads
// straight into it, without the shell. This wraps that request and, on the
// human's confirmation, settles the AI into the same parameters first:
//   1. civilizations  (AI Civ Selection, Age Transition: Historical)
//   2. mementos       (Age Transition AI Mementos)
// The request is the one both the game's own screen and Zatygold's Spectator
// send. Multiplayer is not touched.

import { AGE_TRANSITION_SLOTS, aiPlayerIds } from '../shell/shared/zg-memento-roller.js';
import { isHistoricalProgression, settleAiCivilizations } from './zg-age-transition-civs.js';
import { settleAiMementos } from './zg-age-transition-mementos.js';

const LOG_PREFIX = "ZG-ASP age transition:";

let settledAge = null;

// The age after the current one, or none in the last.
function nextAgeType() {
	const current = GameInfo.Ages.lookup(Game.age);
	const later = GameInfo.Ages.filter((age) => age.ChronologyIndex > (current?.ChronologyIndex ?? Infinity));
	return later.sort((a, b) => a.ChronologyIndex - b.ChronologyIndex)[0]?.AgeType;
}

// Once per age, however often the confirmation is sent.
function settleAiPlayers() {
	const ageType = nextAgeType();
	if (!ageType || settledAge == Game.age) {
		return;
	}
	settledAge = Game.age;
	// The configuration also seats the independent powers; only major civilizations transition.
	const players = aiPlayerIds().filter((playerId) => Players.get(playerId)?.isMajor);
	const humanCiv = GameSetup.findPlayerParameter(GameContext.localPlayerID, AGE_TRANSITION_SLOTS.civilization)?.value?.value;
	console.warn(`${LOG_PREFIX} settling ${players.length} AI for ${ageType} (human ${humanCiv})`);
	if (isHistoricalProgression()) {
		settleAiCivilizations(players, new Set([humanCiv]), ageType, AGE_TRANSITION_SLOTS);
	}
	settleAiMementos(players, AGE_TRANSITION_SLOTS);
	const readBack = (playerId) => GameSetup.findPlayerParameter(playerId, AGE_TRANSITION_SLOTS.civilization)?.value?.value;
	console.warn(`${LOG_PREFIX} written ${players.map((playerId) => `${playerId}:${readBack(playerId)}`).join(" ")}`);
}

const isConfirmation = (playerId, type, args) =>
	type == PlayerOperationTypes.SET_AGE_TRANSITION_DATA && args?.Finished && playerId == GameContext.localPlayerID;

const sendRequest = Game.PlayerOperations.sendRequest;
Game.PlayerOperations.sendRequest = function (playerId, type, args, ...rest) {
	if (isConfirmation(playerId, type, args) && !Configuration.getGame()?.isAnyMultiplayer) {
		try {
			settleAiPlayers();
		} catch (error) {
			console.error(`${LOG_PREFIX} ${error}`);
		}
	}
	return sendRequest.call(this, playerId, type, args, ...rest);
};
console.warn(`${LOG_PREFIX} hook ${Game.PlayerOperations.sendRequest == sendRequest ? "not installed" : "installed"}`);
