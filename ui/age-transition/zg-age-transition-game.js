// The mod's hook into a single-player age transition, in game.
//
// Since patch 1.5 the human makes their age transition choices in game. Once
// they confirm them (SET_AGE_TRANSITION_DATA, Finished), the engine carries
// every player's AgeTransitionPlayer parameters into the next age and loads
// straight into it, without the shell. This wraps that request and, on the
// human's confirmation, settles the AI into the same parameters first
// (zg-age-transition-settle.js). The request is the one both the game's own
// screen and Zatygold's Spectator send.

import { playerValue } from '../shared/zg-config.js';
import { AGE_TRANSITION_SLOTS } from '../shared/zg-memento-roller.js';
import { settleAiPlayers } from './zg-age-transition-settle.js';

// The age after the current one, or none in the last.
function nextAgeType() {
	const current = GameInfo.Ages.lookup(Game.age);
	const later = GameInfo.Ages.filter((age) => age.ChronologyIndex > (current?.ChronologyIndex ?? Infinity));
	return later.sort((a, b) => a.ChronologyIndex - b.ChronologyIndex)[0]?.AgeType;
}

// The game scope loads afresh with every game, so one age is one transition.
let settledAge = null;

const isConfirmation = (playerId, type, args) =>
	type == PlayerOperationTypes.SET_AGE_TRANSITION_DATA && args?.Finished && playerId == GameContext.localPlayerID;

const sendRequest = Game.PlayerOperations.sendRequest;
Game.PlayerOperations.sendRequest = function (playerId, type, args, ...rest) {
	const ageType = isConfirmation(playerId, type, args) ? nextAgeType() : null;
	if (ageType && ageType != settledAge) {
		settledAge = ageType;
		settleAiPlayers(ageType, AGE_TRANSITION_SLOTS, playerValue(GameContext.localPlayerID, AGE_TRANSITION_SLOTS.civilization));
	}
	return sendRequest.call(this, playerId, type, args, ...rest);
};
