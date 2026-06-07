import { DialogBoxManager } from 'fs://game/core/ui/dialog-box/manager-dialog-box.js';

// Conflicting mods, keyed by their immutable Steam Workshop id.
// The game only exposes a mod's .modinfo <Mod id> at runtime (the modding
// database and install paths are not accessible from scripts), so modId is the
// value the check matches against. It is a cached lookup result: if a mod
// changes its modId in an update, set LOG_INSTALLED_MODS to true, launch to
// the main menu once, and refresh the value from UI.log.
const CONFLICTING_MODS = [
	{ workshopId: "3542861519", modId: "mws-settlement-limit-settings" },     // Settlement Limit Settings
	{ workshopId: "3601908082", modId: "Mattifus's Natural Wonder Setting" }, // Natural Wonders Setting
	{ workshopId: "3542338658", modId: "more-natural-wonders" },              // More Natural Wonders
	{ workshopId: "3684060469", modId: "NaturalWonderManager" },              // Natural Wonder Manager
];

const CONFLICTING_MOD_IDS = CONFLICTING_MODS.map((entry) => entry.modId);

// Main menu buttons that auto-disable active conflicts when clicked,
// identified by their stable audio attribute.
const GUARDED_BUTTON_AUDIO_REFS = [
	"data-audio-clicked-continue",     // Continue
	"data-audio-clicked-create-game",  // New Game
	"data-audio-clicked-load-game",    // Load Game
	"data-audio-clicked-multiplayer",  // Multiplayer
];

// Set true to log every installed mod id to UI.log when hunting for new ids.
const LOG_INSTALLED_MODS = false;

function getActiveConflicts() {
	return Modding.getInstalledMods().filter(
		(mod) => mod.enabled && CONFLICTING_MOD_IDS.includes(mod.id)
	);
}

function disableConflicts(conflicts) {
	console.warn(`ZG-ASP disabling conflicting mods: ${conflicts.map((mod) => mod.id).join(", ")}`);
	Modding.disableMods(conflicts.map((mod) => mod.handle));
}

function showConflictDialog(conflicts) {
	const items = conflicts.map((mod) => `[LI]${Locale.compose(mod.name)}`).join("");
	const body =
		Locale.compose("LOC_ZG_MOD_CONFLICT_BODY_HEADER") +
		`[N][BLIST]${items}[/BLIST][N]` +
		Locale.compose("LOC_ZG_MOD_CONFLICT_BODY_FOOTER");
	DialogBoxManager.createDialog_MultiOption({
		title: "LOC_ZG_MOD_CONFLICT_TITLE",
		body: body,
		canClose: false,
		displayQueue: "SystemMessage",
		addToFront: true,
		options: [
			{
				actions: ["accept"],
				label: "LOC_ZG_MOD_CONFLICT_DISABLE",
				callback: () => disableConflicts(conflicts)
			}
		]
	});
}

// Safety net: when Continue, New Game, Load Game or Multiplayer is activated,
// silently disable any conflicting mods that are still enabled. The capture
// phase runs before the button's own handler starts the chosen flow.
function guardMainMenuButtons() {
	document.addEventListener("action-activate", (event) => {
		const target = event.target;
		if (!target || !target.getAttribute) {
			return;
		}
		const audioRef = target.getAttribute("data-audio-activate-ref");
		if (!audioRef || !GUARDED_BUTTON_AUDIO_REFS.includes(audioRef)) {
			return;
		}
		const conflicts = getActiveConflicts();
		if (conflicts.length > 0) {
			disableConflicts(conflicts);
		}
	}, true);
}

function checkForModConflicts() {
	if (LOG_INSTALLED_MODS) {
		console.warn("ZG-ASP conflict check running. Installed mods:");
		for (const mod of Modding.getInstalledMods()) {
			console.warn(`ZG-ASP   id='${mod.id}' enabled=${mod.enabled} name='${Locale.compose(mod.name)}'`);
		}
	}
	const conflicts = getActiveConflicts();
	if (conflicts.length == 0) {
		return;
	}
	console.warn(`ZG-ASP conflict detected: ${conflicts.map((mod) => mod.id).join(", ")}`);

	// The dialog system is only usable once the main menu UI is mounted, which
	// happens after this shell script first runs. Wait for it before showing.
	let frames = 0;
	const waitForMainMenu = () => {
		if (document.querySelector("main-menu")) {
			showConflictDialog(conflicts);
		} else if (frames++ < 600) {
			requestAnimationFrame(waitForMainMenu);
		} else {
			console.warn("ZG-ASP: main menu never appeared; conflict dialog not shown");
		}
	};
	waitForMainMenu();
}

guardMainMenuButtons();
checkForModConflicts();
