// The game's memento picker, the one with the search bar and attribute filter,
// opened on its own for any player, over whatever screen is up.
//
// In single-player setup the picker is the memento-select screen of the
// create-game flow, which supplies everything around it. Anywhere else (the
// multiplayer lobby) nothing does, so this supplies each thing it needs:
//   a backdrop      the picker's own background is the create-game 3D stage,
//                   which only exists in that flow;
//   a panel         for focus, and for Escape or right-click to close it;
//   a screen flow   its Back and Confirm call activatePrev and activateNext,
//                   and its header reads the step count; here every one of
//                   those closes the picker, and the count is empty;
//   its model       MementoSelectModel, as overridden by
//                   ui/zg-memento-select-model.js to read and write any player:
//                   the create-game screen's own instance when there is one,
//                   pointed at the player for as long as the picker is up and
//                   back at the human when it closes.
// The picker itself, its search and filters, are the game's own code.
//
// Hotseat skips mementos in the game's own flow: the picker closes itself the
// moment it mounts there, so hotseat opens the game's older editor instead.

import { createComponent } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { ContextManager } from 'fs://game/core/ui/context-manager/context-manager.js';
import { defineLegacyComponent } from 'fs://game/core/ui-next/components/fxs-solid-component.js';
import { Panel } from 'fs://game/core/ui-next/components/panel.js';
import { ScreenFlowContext } from 'fs://game/core/ui-next/components/screen-flow.js';
import { MementoSelect } from 'fs://game/core/ui-next/screens/create-game/memento-select.js';
import { MementoSelectModel, MementoSelectModelContext } from 'fs://game/core/ui-next/screens/create-game/memento-select-model.js';
import { currentMementoModel } from './zg-memento-select-model.js';

const SCREEN_NAME = "zg-memento-select";
const OLD_EDITOR_NAME = "memento-editor";
const BACKDROP_COLOR = "rgba(10, 11, 15, 0.96)";

let opening = { playerId: null, slotIndex: 0 };
let openModel = null;

function close() {
	ContextManager.pop(SCREEN_NAME);
	openModel?.retarget?.(null);
	openModel = null;
}

// Only what the picker and its stage header read from a flow.
const standaloneFlow = {
	activateNext: close,
	activatePrev: close,
	activate: close,
	close,
	start: close,
	clearHub: () => {},
	active: () => ({ name: "memento-select" }),
	currentStep: () => 0,
	numSteps: () => 0,
	isStartActive: () => false,
	isHubActive: () => false,
	wasHubVisited: () => false,
};

function backdrop() {
	const el = document.createElement("div");
	el.className = "absolute inset-0 pointer-events-auto";
	el.style.backgroundColor = BACKDROP_COLOR;
	return el;
}

defineLegacyComponent(SCREEN_NAME, { classNames: ["fullscreen"] }, () => {
	const model = currentMementoModel() ?? MementoSelectModel.get();
	model.retarget?.(opening.playerId, opening.slotIndex);
	openModel = model;
	return [backdrop(), createComponent(Panel, {
		id: SCREEN_NAME,
		name: SCREEN_NAME,
		class: "fullscreen",
		onCancelInput: close,
		get children() {
			return createComponent(ScreenFlowContext.Provider, {
				value: standaloneFlow,
				get children() {
					return createComponent(MementoSelectModelContext.Provider, {
						value: model,
						get children() {
							return createComponent(MementoSelect, {});
						},
					});
				},
			});
		},
	})];
});

// Opens the picker for a player (the local one by default) on one slot.
export function openMementoSelect(playerId = GameContext.localPlayerID, slotIndex = 0) {
	if (Configuration.getGame()?.isHotseat) {
		ContextManager.push(OLD_EDITOR_NAME, { singleton: true, createMouseGuard: true, attributes: { blackOut: true }, panelOptions: { slotIndex } });
		return;
	}
	opening = { playerId, slotIndex };
	ContextManager.push(SCREEN_NAME, { singleton: true, createMouseGuard: true });
}
