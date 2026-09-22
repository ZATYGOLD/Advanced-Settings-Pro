// Advanced Settings Pro entry point for the shared mod conflict guard.
// All conflict-handling logic lives in zg-conflict-guard.js; this file only
// supplies the list of mods that conflict with Advanced Settings Pro.
//
// Grouped by the setting each mod collides with rather than by when it was
// found. Conflicts cluster into a handful of settings while the mods that cause
// them do not, so the grouping is what stays reviewable as the list grows.
//
// Conflicting mods are keyed by their immutable Steam Workshop id for reference,
// but the game only exposes a mod's .modinfo <Mod id> at runtime, so modId is
// what the guard matches against. To find a new mod's id, pass
// { logInstalledMods: true } as the second argument, launch to the main menu,
// and read the ids from the console / UI.log.
//
// parameterPatterns is a second way to recognise a mod, by the setup parameters
// it adds, so a renamed mod is still caught. Three rules, each learned from a
// real failure:
//
//   1. Name parameters in full. A "BmdResource%" footprint matched an unrelated
//      mod's BmdResourcePreset and locked those players out of New Game.
//   2. Never name a parameter the base game ships. Aventura Era Turn Target
//      edits the base AgeLength, which is present on every install, so a
//      footprint on it would report a conflict for everyone.
//   3. Check the name is really there. A typo matches nothing and says nothing.
//
// outputs/guard_entry.py generates an entry from an installed Workshop folder
// with all three already applied.
import { registerModConflicts } from './zg-conflict-guard.js';

registerModConflicts([
	// --- Settlement Limit and Settlement Distance ---------------------------
	{ workshopId: "3542861519", modId: "mws-settlement-limit-settings" },
	{ workshopId: "3737965906", modId: "phaetom-Settlement" },
	{ workshopId: "3639453691", modId: "mg-settlement-spacing" },
	{ workshopId: "3578252971", modId: "e1c2d3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f" }, // 4_Tile_Cities
	{ workshopId: "3509594994", modId: "5 TILES MIN CITY RANGE VERSION 2 BY ENIO" },
	{
		workshopId: "3768448251",
		modId: "custom-settlement-limits",
		parameterPatterns: ["SettlementLimitOption"],
		nameHints: ["custom settlement limits"],
	},
	{
		workshopId: "3794139950",
		modId: "aventura-city-capacity",
		parameterPatterns: ["AventuraCityCapacity"],
		nameHints: ["city capacity", "aventura"],
	},

	// --- Age Length and Age Progress Rate -----------------------------------
	{ workshopId: "3736792223", modId: "eras-plus", parameterPatterns: ["ErasPlus%"], nameHints: ["eras+", "eras plus"] },
	{ workshopId: "3730342877", modId: "phaetom_Longer_Long_Ages" },
	{ workshopId: "3603609022", modId: "phaetom_Longer_Long_Ages" }, // same mod, second Workshop entry
	{ workshopId: "3508138597", modId: "jnr-age-progression-customization" },
	{ workshopId: "3682416391", modId: "extended-age-lengths" },
	// Also edits the base AgeLength parameter, which ships with the game, so
	// only its own parameter is named here.
	{
		workshopId: "3744582898",
		modId: "aventura-era-turn-target",
		parameterPatterns: ["AventuraEraProgressTarget"],
		nameHints: ["era turn target", "aventura"],
	},

	// --- Crises and Crisis Timing -------------------------------------------
	{ workshopId: "3538838949", modId: "leugi_shorter_crisis" },
	{ workshopId: "3735004833", modId: "phaetom-Longer-Age-Crisis" },
	// Forces every crisis to Disabled as setup initializes, fighting the Crises
	// setting and the per-crisis list it keeps in sync. Adds no setup parameter
	// of its own, so there is no footprint to match on.
	{ workshopId: "3763044817", modId: "crisis-disabler" },

	// --- Natural Wonders ----------------------------------------------------
	{ workshopId: "3601908082", modId: "Mattifus's Natural Wonder Setting" },
	{ workshopId: "3542338658", modId: "more-natural-wonders" },
	{ workshopId: "3684060469", modId: "NaturalWonderManager" },
	{ workshopId: "3558906672", modId: "natural-wonder-spawn-fixes" },

	// --- Resources ----------------------------------------------------------
	// Replaces the base resource generator, which this mod's map copies no
	// longer call, so its density and clustering settings would show in setup
	// and do nothing.
	{
		workshopId: "3773880144",
		modId: "naxts-bmd-resource-density",
		parameterPatterns: ["BmdResourceDensity", "BmdResourceClustering"],
		nameHints: ["resource density"],
	},

	// --- Independent Powers -------------------------------------------------
	{ workshopId: "3736806530", modId: "independent-powers-plus" },

	// --- Mementos and the Player tab ----------------------------------------
	// Both fill the same per-player memento slots the Player tab writes to and
	// the AI Mementos setting rolls. Those slots are the base game's
	// PlayerMementoMajorSlot and PlayerMementoMinorSlot1, which exist with or
	// without them, so neither mod can be matched on that footprint.
	{ workshopId: "3739160866", modId: "scapehs-better-memento-setup" },
	{
		workshopId: "3509318341",
		modId: "slothoth-setup-improved",
		parameterPatterns: ["AiMementos", "AiMementosLock"],
		nameHints: ["ai memento", "slothoth"],
	},

	// --- Triumph Set and Victory Project Cost -------------------------------
	{
		workshopId: "3747759512",
		modId: "PEN_SelectableVictory",
		parameterPatterns: [
			"PenSelectableCulture",
			"PenSelectableEconomic",
			"PenSelectableMilitary",
			"PenSelectableScience",
			"PenSelectableScore",
		],
		nameHints: ["selectable victory"],
	},
	{
		workshopId: "3799035703",
		modId: "Advanced-Victory-Settings",
		parameterPatterns: ["VictoryCountdownLength", "TriumphScoringAmount", "MinorTriumphsEnabled"],
		nameHints: ["advanced victory"],
	},

	// --- Several settings at once -------------------------------------------
	{ workshopId: "3736762795", modId: "game-setup-plus" },
	// City limit and research cost multipliers scale what Settlement Limit and
	// Technology Cost set.
	{
		workshopId: "3796057068",
		modId: "lobby-setup-enhancements",
		parameterPatterns: ["VNCityLimitMultiplier", "VNResearchCostMultiplier"],
		nameHints: ["lobby setup"],
	},
	// Building placement and city density, which this mod does not set. Named in
	// full rather than as CompactCities%: the prefix is the author's, not the
	// setting's, and a wildcard would claim anything else they ship.
	{
		workshopId: "3781288701",
		modId: "compact-cities",
		parameterPatterns: ["CompactCities-RingLock", "CompactCities-Density", "CompactCitiesToggle"],
		nameHints: ["compact cities"],
	},
	// Raises Huge maps to 32 players and randomizes the roster. It adds map
	// sizes rather than setup parameters, so there is no footprint to match on.
	{ workshopId: "3805458999", modId: "huge-earth-player-expansion-bmd" },
]);
