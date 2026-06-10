// Advanced Settings Pro entry point for the shared mod conflict guard.
// All conflict-handling logic lives in zg-conflict-guard.js; this file only
// supplies the list of mods that conflict with Advanced Settings Pro.
//
// Conflicting mods are keyed by their immutable Steam Workshop id for reference,
// but the game only exposes a mod's .modinfo <Mod id> at runtime, so modId is
// what the guard matches against. To find a new mod's id, pass
// { logInstalledMods: true } as the second argument, launch to the main menu,
// and read the ids from the console / UI.log.
import { registerModConflicts } from './zg-conflict-guard.js';

registerModConflicts([
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
]);
