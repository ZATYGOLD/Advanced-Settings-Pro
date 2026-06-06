import { DialogBoxManager } from 'fs://game/core/ui/dialog-box/manager-dialog-box.js';

// Mod ids that conflict with Zatygold's Advanced Settings Pro.
// Use the conflicting mod's id exactly as declared in its .modinfo <Mod id="...">.
const CONFLICTING_MOD_IDS = [
	"mws-settlement-limit-settings",       // Settlement Limit Settings
	"Mattifus's Natural Wonder Setting",   // Natural Wonders Setting
	"more-natural-wonders",                // More Natural Wonders
	"NaturalWonderManager",                // Natural Wonder Manager
];

// Set true to log every installed mod id to UI.log when hunting for new ids.
const LOG_INSTALLED_MODS = false;

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
				callback: () => Modding.disableMods(conflicts.map((mod) => mod.handle))
			},
			{
				actions: ["cancel", "keyboard-escape"],
				label: "LOC_ZG_MOD_CONFLICT_IGNORE",
				callback: () => Modding.disableMods(conflicts.map((mod) => mod.handle))
			}
		]
	});
}

function checkForModConflicts() {
	const installed = Modding.getInstalledMods();
	if (LOG_INSTALLED_MODS) {
		console.warn("ZG-ASP conflict check running. Installed mods:");
		for (const mod of installed) {
			console.warn(`ZG-ASP   id='${mod.id}' enabled=${mod.enabled} name='${Locale.compose(mod.name)}'`);
		}
	}
	const conflicts = installed.filter(
		(mod) => mod.enabled && CONFLICTING_MOD_IDS.includes(mod.id)
	);
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

checkForModConflicts();
