// Age Transition AI Mementos: what becomes of the AI players' mementos when an
// age turns over.
//
// A single-player age transition returns to the shell, which pushes the game's
// age-transition-civ-select panel; the human picks a civilization there, may
// edit their own mementos, and its startGame() begins the next age. The AI's
// mementos are ordinary player parameters at that point, the same ones the
// Player tab writes, so this hooks startGame() and settles them just before the
// hand-off:
//   Maintain  leaves every AI's slots as they are.
//   Adapt     draws them again by the AI Mementos rule, against the leader and
//             civilization the player holds now.
// Multiplayer transitions run through the staging screen instead and are not
// touched.

import { MEMENTO_PARAM_IDS, aiMementoMode, aiPlayerIds, drawMementos } from './zg-memento-roller.js';

const PARAM_ID = "ZG_AgeTransitionMementos";
const ADAPT_VALUE = "ZG_AGE_TRANSITION_MEMENTOS_ADAPT";
const PANEL_NAME = "age-transition-civ-select";
const LOG_PREFIX = "ZG-ASP age transition mementos:";

const settingValue = () => GameSetup.findGameParameter(PARAM_ID)?.value?.value;
const playerValue = (playerId, id) => GameSetup.findPlayerParameter(playerId, id)?.value?.value;
const slotValues = (playerId) => MEMENTO_PARAM_IDS.map((id) => playerValue(playerId, id)).join(", ");

function adaptAiMementos() {
	const mode = aiMementoMode();
	for (const playerId of aiPlayerIds()) {
		const before = slotValues(playerId);
		const drew = drawMementos(mode, playerId);
		const who = `${playerValue(playerId, "PlayerLeader")} / ${playerValue(playerId, "PlayerCivilization")}`;
		const choices = GameSetup.findPlayerParameter(playerId, MEMENTO_PARAM_IDS[0])?.domain?.possibleValues?.length ?? 0;
		console.warn(`${LOG_PREFIX} player ${playerId} (${who}, ${choices} choices) ${drew ? `${before} -> ${slotValues(playerId)}` : `kept ${before} (AI Mementos is None)`}`);
	}
}

class AgeTransitionMementos {
	constructor(component) {
		this.component = component;
	}

	// Before onAttach, which is where the panel binds startGame to its button.
	beforeAttach() {
		const startGame = this.component.startGame;
		this.component.startGame = (...args) => {
			// startGame() itself does nothing without a valid pick; mirror that so
			// the draw happens once, on the click that starts the age.
			const civ = this.component.selectedCivInfo;
			if (civ && !civ.isLocked) {
				const value = settingValue();
				console.warn(`${LOG_PREFIX} ${value ?? "unset"}`);
				if (value == ADAPT_VALUE) {
					adaptAiMementos();
				}
			}
			return startGame.apply(this.component, args);
		};
	}

	afterAttach() {}
	beforeDetach() {}
	afterDetach() {}
	onAttributeChanged() {}
}

// The panel only ever exists during a transition; the decorator is inert otherwise.
Controls.decorate(PANEL_NAME, (component) => new AgeTransitionMementos(component));
