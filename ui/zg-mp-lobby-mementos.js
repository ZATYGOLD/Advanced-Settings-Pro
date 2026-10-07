// Memento slots under the leader name in the multiplayer lobby.
//
// Each human row of the lobby shows its mementos as small generic diamonds
// inside the leader dropdown, and the only way to change them is the Choose
// Mementos button. This turns those diamonds into memento slots, drawn like the
// single-player Player tab's: the slot base and a "+" when empty, the memento's
// own art when filled, its name and effect on hover. They show on human rows
// and, whenever mementos are on, on AI rows too. On your own row, and on AI
// rows for the host, a slot opens the single-player memento picker on that
// slot (ui/zg-memento-select.js).
// Nothing else in the row moves: the slots take the diamonds' place.
//
// The slots sit inside the leader dropdown, which opens on a left click or tap
// anywhere in it. A slot answers those inputs itself and stops them there, so a
// click on a slot never reaches the dropdown and a click beside it still opens
// the dropdown as before. Other players' slots are left to pass clicks through,
// exactly as the diamonds did. Controller users keep the Choose Mementos button,
// which opens the same picker.

import { Audio } from 'fs://game/core/ui/audio-base/audio-support.js';
import { openMementoSelect } from './zg-memento-select.js';
import { MEMENTO_PARAM_IDS as PARAM_IDS, MEMENTO_NONE_VALUE as NONE_VALUE, MEMENTO_SLOT_BASE_IMAGE as BASE_IMAGE, MEMENTO_SLOT_PLUS_IMAGE as PLUS_IMAGE, mementoTooltip, aiPlayerIds } from './zg-memento-roller.js';
import { canEditSetup } from './zg-shell-context.js';

const DROPDOWN_NAME = "leader-dropdown";
const LOBBY_NAME = "screen-mp-lobby";
// The unit panel box the Overview slots use is a nine-slice image drawn for
// 7rem slots; at this size its edge slices meet in the middle and draw a bar
// across the slot. A plain frame in the same gold takes its place.
const SLOT_REM = 2.75;
const PLUS_REM = 1.3;
const SLOT_FRAME = { border: "0.0833rem solid #8c7e62", backgroundColor: "rgba(13, 15, 20, 0.6)" };
const CLICK_INPUTS = new Set(["mousebutton-left", "touch-tap"]);
const REFRESH_MS = 500;

// Every row's slots, refreshed together when the setup changes: an AI row's
// mementos change without the lobby telling its dropdown anything.
const liveSlots = new Set();
let lastRevision = -1;
setInterval(() => {
	if (liveSlots.size == 0 || GameSetup.currentRevision == lastRevision) {
		return;
	}
	lastRevision = GameSetup.currentRevision;
	liveSlots.forEach((slots) => slots.refresh());
}, REFRESH_MS);

function mementoValue(playerId, slotIndex) {
	return GameSetup.findPlayerParameter(playerId, PARAM_IDS[slotIndex])?.value;
}

function createSlot() {
	const slot = document.createElement("div");
	slot.className = "relative flex items-center justify-center pointer-events-auto group mr-2";
	Object.assign(slot.style, SLOT_FRAME, { width: `${SLOT_REM}rem`, height: `${SLOT_REM}rem` });
	const art = document.createElement("div");
	art.className = "absolute inset-0 bg-center bg-no-repeat bg-contain";
	const highlight = document.createElement("div");
	highlight.className = "img-rollover-highlight absolute inset-0 opacity-0 group-hover\\:opacity-100 pointer-events-none";
	slot.append(art, highlight);
	return slot;
}

function paintSlot(slot, value) {
	const art = slot.firstChild;
	const isEmpty = !value || value.value == NONE_VALUE;
	const icon = isEmpty ? "" : GameSetup.resolveString(value.icon);
	if (icon) {
		art.style.backgroundImage = `url('blp:${icon}')`;
		art.style.backgroundSize = "";
		art.style.opacity = "1";
	} else {
		art.style.backgroundImage = `${PLUS_IMAGE}, ${BASE_IMAGE}`;
		art.style.backgroundSize = `${PLUS_REM}rem ${PLUS_REM}rem, contain`;
		art.style.opacity = "0.6";
	}
	slot.setAttribute("data-tooltip-content", mementoTooltip(value));
}

class LobbyMementoSlots {
	constructor(component) {
		this.component = component;
		this.slots = [];
		const onAttributeChanged = component.onAttributeChanged.bind(component);
		component.onAttributeChanged = (name, oldValue, newValue) => {
			onAttributeChanged(name, oldValue, newValue);
			if (name == "mementos" || name == "data-player-id") {
				this.refresh();
			}
		};
	}

	playerId() {
		return parseInt(this.component.Root.getAttribute("data-player-id") ?? "-1");
	}

	isLocal() {
		return this.playerId() == GameContext.localPlayerID;
	}

	isAI() {
		return aiPlayerIds().includes(this.playerId());
	}

	// Your own slots, and the AI's for the host, who sets up the AI.
	isEditable() {
		return this.isLocal() || (this.isAI() && canEditSetup());
	}

	// The lobby lists mementos for humans only; the AI's are read here, so AI
	// Mementos shows on the AI rows too, whenever mementos are on.
	isShown() {
		if (!Configuration.getGame()?.isMementosEnabled) {
			return false;
		}
		return this.isAI() || (this.component.Root.getAttribute("mementos") ?? "") != "";
	}

	// The dropdown builds its memento row in render(); the slots replace its
	// children the first time there is something to show.
	ensureSlots() {
		const container = this.component.mementoContainer;
		if (!container || this.slots.length > 0) {
			return this.slots.length > 0;
		}
		container.innerHTML = "";
		container.classList.add("items-center");
		for (let slotIndex = 0; slotIndex < PARAM_IDS.length; slotIndex++) {
			const slot = createSlot();
			slot.addEventListener("engine-input", (event) => this.onSlotInput(event, slotIndex));
			container.appendChild(slot);
			this.slots.push(slot);
		}
		return true;
	}

	onSlotInput(event, slotIndex) {
		if (!this.isEditable() || !CLICK_INPUTS.has(event.detail.name)) {
			return;
		}
		event.stopPropagation();
		event.preventDefault();
		if (event.detail.status == InputActionStatuses.FINISH) {
			Audio.playSound("data-audio-activate", "data-audio-activate-ref");
			openMementoSelect(this.playerId(), slotIndex);
		}
	}

	refresh() {
		const shown = this.isShown();
		if (!shown) {
			if (this.slots.length > 0) {
				this.component.mementoContainer?.classList.add("hidden");
			}
			return;
		}
		if (!this.ensureSlots()) {
			return;
		}
		this.component.mementoContainer.classList.remove("hidden");
		const playerId = this.playerId();
		const editable = this.isEditable();
		this.slots.forEach((slot, slotIndex) => {
			paintSlot(slot, mementoValue(playerId, slotIndex));
			slot.classList.toggle("cursor-pointer", editable);
		});
	}

	beforeAttach() {}
	afterAttach() {
		liveSlots.add(this);
		this.refresh();
	}
	beforeDetach() {
		liveSlots.delete(this);
	}
	afterDetach() {}
	onAttributeChanged() {}
}

Controls.decorate(DROPDOWN_NAME, (component) => new LobbyMementoSlots(component));

// The lobby's Choose Mementos button, and its controller hotkey, open the same
// picker as the slots, on the local player's first slot, instead of the older
// memento editor.
class LobbyChooseMementos {
	constructor(component) {
		component.openMementos = () => openMementoSelect(GameContext.localPlayerID, 0);
	}

	beforeAttach() {}
	afterAttach() {}
	beforeDetach() {}
	afterDetach() {}
	onAttributeChanged() {}
}

Controls.decorate(LOBBY_NAME, (component) => new LobbyChooseMementos(component));
