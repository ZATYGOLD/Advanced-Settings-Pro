import { DialogBoxManager } from 'fs://game/core/ui/dialog-box/manager-dialog-box.js';

// Conflicting mods, keyed by their immutable Steam Workshop id.
// The game only exposes a mod's .modinfo <Mod id> at runtime (the modding
// database and install paths are not accessible from scripts), so modId is the
// value the check matches against. It is a cached lookup result: if a mod
// changes its modId in an update, set LOG_INSTALLED_MODS to true, launch to
// the main menu once, and refresh the value from UI.log.
const CONFLICTING_MODS = [
	{ workshopId: "3542861519", modId: "mws-settlement-limit-settings" },
	{ workshopId: "3601908082", modId: "Mattifus's Natural Wonder Setting" },
	{ workshopId: "3542338658", modId: "more-natural-wonders" },
	{ workshopId: "3684060469", modId: "NaturalWonderManager" },
	{ workshopId: "3737965906", modId: "phaetom-Settlement" },
	{ workshopId: "3736792223", modId: "eras-plus" },
	{ workshopId: "3639453691", modId: "mg-settlement-spacing" },
	{ workshopId: "3730342877", modId: "phaetom_Longer_Long_Ages" },
	{ workshopId: "3603609022", modId: "phaetom_Longer_Long_Ages" },
	{ workshopId: "3508138597", modId: "jnr-age-progression-customization" },
	{ workshopId: "3682416391", modId: "extended-age-lengths" },
	{ workshopId: "3538838949", modId: "leugi_shorter_crisis" },
	{ workshopId: "3578252971", modId: "e1c2d3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f" }, // 4_Tile_Cities
	{ workshopId: "3509594994", modId: "5 TILES MIN CITY RANGE VERSION 2 BY ENIO" },
	{ workshopId: "3735004833", modId: "phaetom-Longer-Age-Crisis" },
	{ workshopId: "3558906672", modId: "natural-wonder-spawn-fixes" },
	{ workshopId: "3736806530", modId: "independent-powers-plus" },
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
		`[N][BLIST]  ${items}[/BLIST][N]` +
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

// When Continue, New Game, Load Game or Multiplayer is activated, bring up the
// conflict dialog for any conflicting mods that are still enabled at that point.
// Runs in the capture phase: closest() finds the guarded button even when the
// event originates from a child element, and when a conflict is active we stop
// the event so the menu action (e.g. opening New Game) is gated behind the
// dialog instead of navigating away before it can be seen.
function guardMainMenuButtons() {
	document.addEventListener("action-activate", (event) => {
		const target = event.target;
		if (!target || !target.closest) {
			return;
		}
		const button = target.closest("[data-audio-activate-ref]");
		if (!button) {
			return;
		}
		const audioRef = button.getAttribute("data-audio-activate-ref");
		if (!GUARDED_BUTTON_AUDIO_REFS.includes(audioRef)) {
			return;
		}
		const conflicts = getActiveConflicts();
		if (conflicts.length === 0) {
			return;
		}
		event.preventDefault();
		event.stopImmediatePropagation();
		showConflictDialog(conflicts);
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
	// On load: silently disable conflicts without a dialog. The dialog is only
	// shown later if a conflict is still enabled when a guarded main-menu button
	// is clicked (see guardMainMenuButtons).
	console.warn(`ZG-ASP conflict detected on load: ${conflicts.map((mod) => mod.id).join(", ")}`);
	disableConflicts(conflicts);
}

guardMainMenuButtons();
checkForModConflicts();
