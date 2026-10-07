// Remembers the mod's settings from one single-player setup to the next.
//
// The game saves the New Game settings it shows on its main setup screen
// (difficulty, speed, map) and loads them back as single-player setup opens,
// through GameSetup.loadCreateGameSettings. It saves nothing else, so every
// setting this mod adds came back at its default. This saves them alongside:
//   restore   once loadCreateGameSettings has run, the saved values are put
//             back, each only if the setting still offers it;
//   remember  while single-player setup is open, every change is saved;
//   forget    Reset to Defaults (resetSavedCreateGameSettings) clears them.
// Multiplayer, hotseat and age transitions are never read or written.
//
// Storage follows the convention mods share in the shell: one "modSettings"
// localStorage key holding an object with a key per mod. A second top-level
// key makes the shell drop all of localStorage, every mod's settings included.

import { isAgeTransition } from './zg-shell-context.js';

const STORAGE_KEY = "modSettings";
const MOD_KEY = "ZG_AdvancedSettingsProSetup";
const PARAM_PREFIX = "ZG_";
// Game settings this mod places on its own tabs and remembers with its own.
const BASE_PARAM_IDS = new Set(["AgeLength", "Crises", "DisasterIntensity", "IndependentHostility", "LegacySets", "MapSeaLevel"]);
const LOG_PREFIX = "ZG-ASP setup memory:";

let active = false;
let restorePending = false;
let lastSaved = null;

// ---------------------------------------------------------------- storage --

function readAll() {
	try {
		return JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}") ?? {};
	} catch (error) {
		console.error(`${LOG_PREFIX} could not read saved settings: ${error}`);
		return {};
	}
}

function writeAll(all) {
	try {
		localStorage.setItem(STORAGE_KEY, JSON.stringify(all));
	} catch (error) {
		console.error(`${LOG_PREFIX} could not save settings: ${error}`);
	}
}

function writeSaved(saved) {
	const all = readAll();
	if (saved) {
		all[MOD_KEY] = saved;
	} else {
		delete all[MOD_KEY];
	}
	writeAll(all);
}

// ------------------------------------------------------------- parameters --

const isRemembered = (id) => id.startsWith(PARAM_PREFIX) || BASE_PARAM_IDS.has(id);
const isSinglePlayerSetup = () => !Configuration.getGame()?.isAnyMultiplayer && !isAgeTransition();

function rememberedParameters() {
	const out = [];
	for (const param of GameSetup.getGameParameters() ?? []) {
		const id = GameSetup.resolveString(param.ID);
		if (id && isRemembered(id) && !param.readOnly) {
			out.push([id, param]);
		}
	}
	return out;
}

function snapshot() {
	const saved = {};
	for (const [id, param] of rememberedParameters()) {
		saved[id] = param.array ? (param.values ?? []).map((entry) => entry.value) : param.value?.value;
	}
	return saved;
}

// A saved value goes back only if the setting still offers it; an array keeps
// the entries still offered.
function restoreValue(id, param, saved) {
	const offered = (param.domain?.possibleValues ?? []).map((entry) => entry.value);
	if (param.array) {
		if (!Array.isArray(saved)) return;
		const kept = saved.filter((value) => offered.includes(value));
		const current = (param.values ?? []).map((entry) => entry.value);
		if (kept.length != current.length || kept.some((value) => !current.includes(value))) {
			GameSetup.setGameParameterValue(id, kept);
		}
	} else if (saved != null && saved != param.value?.value && (offered.length == 0 || offered.includes(saved))) {
		GameSetup.setGameParameterValue(id, saved);
	}
}

// ---------------------------------------------------------------- session --

// Puts the saved values back once single-player setup has loaded. Returns
// whether it ran, so the caller can treat the restored values as its baseline.
export function restoreSetup() {
	if (!restorePending || !isSinglePlayerSetup()) {
		return false;
	}
	const params = rememberedParameters();
	if (params.length == 0) {
		return false;
	}
	restorePending = false;
	active = true;
	const saved = readAll()[MOD_KEY];
	if (saved && typeof saved == "object") {
		for (const [id, param] of params) {
			if (id in saved) {
				try {
					restoreValue(id, param, saved[id]);
				} catch (error) {
					console.warn(`${LOG_PREFIX} could not restore ${id}: ${error}`);
				}
			}
		}
	}
	lastSaved = null;
	return true;
}

// Saves the current values while single-player setup is open.
export function rememberSetup() {
	if (!active || restorePending || !isSinglePlayerSetup()) {
		return;
	}
	const saved = JSON.stringify(snapshot());
	if (saved != lastSaved) {
		lastSaved = saved;
		writeSaved(JSON.parse(saved));
	}
}

// Wraps one of GameSetup's own calls, running `after` once it returns.
function after(name, run) {
	const base = GameSetup[name];
	if (typeof base != "function") {
		return false;
	}
	const wrapped = function (...args) {
		const result = base.apply(this, args);
		run();
		return result;
	};
	try {
		GameSetup[name] = wrapped;
	} catch (error) {
		// Reported below.
	}
	return GameSetup[name] === wrapped;
}

const loadHooked = after("loadCreateGameSettings", () => {
	restorePending = true;
	active = false;
});
after("resetSavedCreateGameSettings", () => {
	writeSaved(null);
	lastSaved = null;
});
if (!loadHooked) {
	// Without the hook, the first single-player setup of the session restores.
	console.warn(`${LOG_PREFIX} could not hook loadCreateGameSettings; restoring once per session`);
	restorePending = true;
}
