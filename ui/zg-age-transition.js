// The mod's hook into a single-player age transition.
//
// An age transition returns to the shell, which pushes the game's
// age-transition-civ-select panel; the human picks a civilization there, may
// edit their own mementos, and its startGame() begins the next age. Every AI's
// leader, civilization and mementos are ordinary player parameters at that
// point, so this wraps startGame() and, on the click that actually starts the
// age, settles the AI in order:
//   1. civilizations  (AI Historical Progression, zg-age-transition-civs.js)
//   2. mementos       (Age Transition AI Mementos, zg-age-transition-mementos.js)
// Civilizations go first so a Civilization Match memento draw sees the new one.
//
// Multiplayer transitions run through the staging screen instead and are not
// touched. The panel only exists during a transition, so the decorator is
// inert in an ordinary shell session.

import { aiPlayerIds } from './zg-memento-roller.js';
import { isHistoricalProgression, settleAiCivilizations } from './zg-age-transition-civs.js';
import { settleAiMementos } from './zg-age-transition-mementos.js';

const PANEL_NAME = "age-transition-civ-select";

function settleAiPlayers(humanCiv) {
	const players = aiPlayerIds();
	if (isHistoricalProgression()) {
		settleAiCivilizations(players, new Set([humanCiv]));
	}
	settleAiMementos(players);
}

class AgeTransitionHook {
	constructor(component) {
		this.component = component;
	}

	// Before onAttach, which is where the panel binds startGame to its button.
	beforeAttach() {
		const startGame = this.component.startGame;
		this.component.startGame = (...args) => {
			// startGame() itself does nothing without a valid pick; mirror that so
			// the AI is settled once, on the click that starts the age.
			const civ = this.component.selectedCivInfo;
			if (civ && !civ.isLocked) {
				settleAiPlayers(civ.civID);
			}
			return startGame.apply(this.component, args);
		};
	}

	afterAttach() {}
	beforeDetach() {}
	afterDetach() {}
	onAttributeChanged() {}
}

Controls.decorate(PANEL_NAME, (component) => new AgeTransitionHook(component));
