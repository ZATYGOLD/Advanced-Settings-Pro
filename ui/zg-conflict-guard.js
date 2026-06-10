// Reusable mod conflict guard for Sid Meier's Civilization VII.
//
// Drop this file unchanged into a mod's ui/ folder, list it in the modinfo
// <UIScripts> (before the mod's own entry script), then from that entry call:
//
//   import { registerModConflicts } from './zg-conflict-guard.js';
//   registerModConflicts([
//     { workshopId: "123456789", modId: "some-conflicting-mod" },
//     "another-mod-id",
//   ]);
//
// Behavior:
//   - On load, any enabled conflicting mod is disabled silently.
//   - If a conflict is still enabled when Continue / New Game / Load Game /
//     Multiplayer is activated, that action is blocked and a dialog lists the
//     conflicts with a one-click disable.
//
// Several mods can each register their own conflicts. A single guard kept on
// globalThis merges every registration, so there is only ever one event
// listener and one combined dialog no matter how many mods include this file.
//
// Localization: the dialog uses the tags below by default. Define them in the
// mod's text, or override any of them via the options.text argument:
//   LOC_ZG_MOD_CONFLICT_TITLE, LOC_ZG_MOD_CONFLICT_BODY_HEADER,
//   LOC_ZG_MOD_CONFLICT_BODY_FOOTER, LOC_ZG_MOD_CONFLICT_DISABLE

import { DialogBoxManager } from 'fs://game/core/ui/dialog-box/manager-dialog-box.js';

const GLOBAL_KEY = "__zgModConflictGuard";

// Main menu buttons that gate on active conflicts, identified by their stable
// audio attribute. The game sets data-audio-activate-ref to "data-audio-clicked-"
// plus each button's audio key.
const DEFAULT_GUARDED_BUTTON_REFS = [
	"data-audio-clicked-continue",     // Continue
	"data-audio-clicked-create-game",  // New Game
	"data-audio-clicked-load-game",    // Load Game
	"data-audio-clicked-multiplayer",  // Multiplayer
];

const DEFAULT_TEXT = {
	title: "LOC_ZG_MOD_CONFLICT_TITLE",
	header: "LOC_ZG_MOD_CONFLICT_BODY_HEADER",
	footer: "LOC_ZG_MOD_CONFLICT_BODY_FOOTER",
	disable: "LOC_ZG_MOD_CONFLICT_DISABLE",
};

function createGuard() {
	const guard = {
		conflictIds: new Set(),
		guardedRefs: new Set(DEFAULT_GUARDED_BUTTON_REFS),
		text: { ...DEFAULT_TEXT },
		listenerInstalled: false,
	};

	guard.getActiveConflicts = () =>
		Modding.getInstalledMods().filter((mod) => mod.enabled && guard.conflictIds.has(mod.id));

	guard.disable = (mods) => {
		if (mods.length === 0) {
			return;
		}
		console.warn(`ZG conflict guard disabling: ${mods.map((mod) => mod.id).join(", ")}`);
		Modding.disableMods(mods.map((mod) => mod.handle));
	};

	guard.showDialog = (mods) => {
		const items = mods.map((mod) => `[LI]${Locale.compose(mod.name)}`).join("");
		const body =
			Locale.compose(guard.text.header) +
			`[N][BLIST]  ${items}[/BLIST][N]` +
			Locale.compose(guard.text.footer);
		DialogBoxManager.createDialog_MultiOption({
			title: guard.text.title,
			body: body,
			canClose: false,
			displayQueue: "SystemMessage",
			addToFront: true,
			options: [
				{
					actions: ["accept"],
					label: guard.text.disable,
					callback: () => guard.disable(mods)
				}
			]
		});
	};

	// Capture-phase handler. Fast path reads the audio ref off the target itself
	// to avoid a DOM walk; closest() is only used when the event came from a
	// child element with no ref of its own. When a conflict is active the menu
	// action is stopped so the dialog is seen before any navigation happens.
	guard.onActivate = (event) => {
		const target = event.target;
		if (!target || !target.getAttribute) {
			return;
		}
		const ownRef = target.getAttribute("data-audio-activate-ref");
		let guarded = ownRef != null && guard.guardedRefs.has(ownRef);
		if (!guarded && ownRef == null && target.closest) {
			const button = target.closest("[data-audio-activate-ref]");
			guarded = button != null && guard.guardedRefs.has(button.getAttribute("data-audio-activate-ref"));
		}
		if (!guarded) {
			return;
		}
		const conflicts = guard.getActiveConflicts();
		if (conflicts.length === 0) {
			return;
		}
		event.preventDefault();
		event.stopImmediatePropagation();
		guard.showDialog(conflicts);
	};

	return guard;
}

function getGuard() {
	let guard = globalThis[GLOBAL_KEY];
	if (!guard) {
		guard = createGuard();
		globalThis[GLOBAL_KEY] = guard;
	}
	return guard;
}

// Register a mod's conflicting mod ids with the shared guard. Accepts an array
// of either plain id strings or { modId } objects (extra fields such as
// workshopId are ignored). Options:
//   text               - partial override of the dialog LOC tags (see above)
//   guardedButtonRefs  - extra data-audio-activate-ref values to gate on
//   logInstalledMods   - log every installed mod's id to the console once
export function registerModConflicts(conflicts, options = {}) {
	const guard = getGuard();

	for (const entry of conflicts) {
		const id = typeof entry === "string" ? entry : entry && entry.modId;
		if (id) {
			guard.conflictIds.add(id);
		}
	}
	if (options.guardedButtonRefs) {
		for (const ref of options.guardedButtonRefs) {
			guard.guardedRefs.add(ref);
		}
	}
	if (options.text) {
		Object.assign(guard.text, options.text);
	}

	if (options.logInstalledMods) {
		console.warn("ZG conflict guard: installed mods:");
		for (const mod of Modding.getInstalledMods()) {
			console.warn(`ZG   id='${mod.id}' enabled=${mod.enabled} name='${Locale.compose(mod.name)}'`);
		}
	}

	if (!guard.listenerInstalled) {
		document.addEventListener("action-activate", guard.onActivate, true);
		guard.listenerInstalled = true;
	}

	// On load: silently disable any registered conflict that is currently enabled.
	const active = guard.getActiveConflicts();
	if (active.length > 0) {
		console.warn(`ZG conflict guard detected on load: ${active.map((mod) => mod.id).join(", ")}`);
		guard.disable(active);
	}
}
