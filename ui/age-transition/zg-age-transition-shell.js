// The mod's hook into a single-player age transition, in the shell.
//
// An age transition that returns to the shell pushes the game's
// age-transition-civ-select panel; the human picks a civilization there and its
// startGame() begins the next age. This wraps startGame() and, on the call that
// actually starts the age, settles the AI in the setup's own parameters first
// (zg-age-transition-settle.js). A transition made in game is settled by
// zg-age-transition-game.js instead.
//
// The panel binds startGame to its Choose button in its constructor, before
// any decorator exists, so the wrap goes on the prototype: the button and the
// gamepad shortcut then both reach it.
//
// The panel only exists during a transition, so the wrap is inert in an
// ordinary shell session.
import AgeTransitionCivSelect from 'fs://game/core/ui/shell/age-transition/age-transition-civ-select.js';
import { gameValue } from '../shared/zg-config.js';
import { SETUP_SLOTS } from '../shared/zg-memento-roller.js';
import { settleAiPlayers } from './zg-age-transition-settle.js';

const AGE_PARAM_ID = "Age";

// The shell stays loaded across games, so the guard is the panel: one per transition.
const settledPanels = new WeakSet();

const startGame = AgeTransitionCivSelect.prototype.startGame;
AgeTransitionCivSelect.prototype.startGame = function (...args) {
	// startGame() itself does nothing without a valid pick; mirror that.
	const civ = this.selectedCivInfo;
	if (civ && !civ.isLocked && !settledPanels.has(this)) {
		settledPanels.add(this);
		settleAiPlayers(gameValue(AGE_PARAM_ID), SETUP_SLOTS, civ.civID);
	}
	return startGame.apply(this, args);
};
