// The mod's hook into a single-player age transition, in the shell.
//
// An age transition that returns to the shell pushes the game's
// age-transition-civ-select panel; the human picks a civilization there, may
// edit their own mementos, and its startGame() begins the next age. Every AI's
// leader, civilization and mementos are ordinary player parameters at that
// point, so this wraps startGame() and, on the call that actually starts the
// age, settles the AI in order:
//   1. civilizations  (AI Civ Selection, Age Transition: Historical)
//   2. mementos       (Age Transition AI Mementos)
// Civilizations go first so a Civilization Match memento draw sees the new one.
// A transition made in game is settled by zg-age-transition-game.js instead.
//
// The panel binds startGame to its Choose button in its constructor, before
// any decorator exists, so the wrap goes on the prototype: the button and the
// gamepad shortcut then both reach it.
//
// Multiplayer transitions run through the staging screen instead and are not
// touched. The panel only exists during a transition, so the wrap is inert in
// an ordinary shell session.

import AgeTransitionCivSelect from 'fs://game/core/ui/shell/age-transition/age-transition-civ-select.js';
import { aiPlayerIds } from '../shell/shared/zg-memento-roller.js';
import { isHistoricalProgression, settleAiCivilizations } from './zg-age-transition-civs.js';
import { settleAiMementos } from './zg-age-transition-mementos.js';

const AGE_PARAM_ID = "Age";

function settleAiPlayers(humanCiv) {
	const players = aiPlayerIds();
	if (isHistoricalProgression()) {
		settleAiCivilizations(players, new Set([humanCiv]), GameSetup.findGameParameter(AGE_PARAM_ID)?.value?.value);
	}
	settleAiMementos(players);
}

const startGame = AgeTransitionCivSelect.prototype.startGame;
AgeTransitionCivSelect.prototype.startGame = function (...args) {
	// startGame() itself does nothing without a valid pick; mirror that so the
	// AI is settled once, on the call that starts the age.
	const civ = this.selectedCivInfo;
	if (civ && !civ.isLocked) {
		settleAiPlayers(civ.civID);
	}
	return startGame.apply(this, args);
};
