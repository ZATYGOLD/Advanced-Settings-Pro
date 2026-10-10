// Remembers the mod's settings from one single-player setup to the next.
//
// The game remembers only the settings on its main setup screen (difficulty,
// speed, map); every setting this mod adds came back at its default. This keeps
// them, tied to the single-player setup screen (create-game-sp) and nothing else:
//   restore   when the screen opens, wait for the game to finish loading its own
//             saved settings, put the remembered values back, and keep putting
//             back any the game overwrites in the moments after;
//   remember  while the screen is open and the restore is done, save every change.
// Only values seen on that screen are ever saved, so nothing else can overwrite
// them: the reset the main menu runs when you leave, a save being loaded,
// multiplayer, hotseat, or an age transition. Reset to Defaults resets the
// screen, and the defaults are then remembered like any other change.
//
// Storage follows the convention mods share in the shell: one "modSettings"
// localStorage key holding an object with a key per mod. A second top-level
// key makes those mods clear all of localStorage, every mod's settings included.

import { ContextManager } from 'fs://game/core/ui/context-manager/context-manager.js';
import { StartCampaignEventName } from 'fs://game/core/ui/events/shell-events.js';
import { isAgeTransition } from './zg-shell-context.js';

const STORAGE_KEY = "modSettings";
const MOD_KEY = "ZG_AdvancedSettingsProSetup";
const STORAGE_VERSION = 2;
const SETUP_SCREEN = "create-game-sp";
const PARAM_PREFIX = "ZG_";
// Game settings this mod places on its own tabs and remembers with its own.
const BASE_PARAM_IDS = new Set(["AgeLength", "Crises", "DisasterIntensity", "IndependentHostility", "LegacySets", "MapSeaLevel"]);
// The game's own saved settings land over several revisions after the screen
// opens. The restore waits for this many quiet polls, then guards its values
// for this long against anything that lands late.
const SETTLE_POLLS = 3;
const GUARD_MS = 2500;
const LOG_PREFIX = "ZG-ASP setup memory:";

const Phase = { CLOSED: "closed", SETTLING: "settling", GUARDING: "guarding", OPEN: "open" };
let phase = Phase.CLOSED;
let settleRevision = -1;
let quietPolls = 0;
let targets = null;
let guardUntil = 0;
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

// Version 1 (0.9.03) stored the values object itself.
function readSaved() {
	const saved = readAll()[MOD_KEY];
	if (!saved || typeof saved != "object") return null;
	return saved.version == STORAGE_VERSION ? saved.values : saved;
}

function writeSaved(values) {
	const all = readAll();
	all[MOD_KEY] = { version: STORAGE_VERSION, values };
	try {
		localStorage.setItem(STORAGE_KEY, JSON.stringify(all));
	} catch (error) {
		console.error(`${LOG_PREFIX} could not save settings: ${error}`);
	}
}

// ------------------------------------------------------------- parameters --

const isRemembered = (id) => id.startsWith(PARAM_PREFIX) || BASE_PARAM_IDS.has(id);
const isSetupOpen = () => ContextManager.hasInstanceOf(SETUP_SCREEN) && !Configuration.getGame()?.isAnyMultiplayer && !isAgeTransition();

function rememberedParameters() {
	const out = new Map();
	for (const param of GameSetup.getGameParameters() ?? []) {
		const id = GameSetup.resolveString(param.ID);
		if (id && isRemembered(id) && !param.readOnly) {
			out.set(id, param);
		}
	}
	return out;
}

const currentValue = (param) => (param.array ? (param.values ?? []).map((entry) => entry.value) : param.value?.value);

function snapshot() {
	const values = {};
	for (const [id, param] of rememberedParameters()) {
		values[id] = currentValue(param);
	}
	return values;
}

// The value a saved entry restores to, or undefined when the setting no longer
// offers it; an array keeps the entries still offered.
function restorable(param, saved) {
	const offered = (param.domain?.possibleValues ?? []).map((entry) => entry.value);
	if (param.array) {
		return Array.isArray(saved) ? saved.filter((value) => offered.includes(value)) : undefined;
	}
	return saved != null && (offered.length == 0 || offered.includes(saved)) ? saved : undefined;
}

function matches(param, target) {
	const current = currentValue(param);
	if (!param.array) return current == target;
	return current.length == target.length && target.every((value) => current.includes(value));
}

// Writes every target the setup does not already hold. Returns whether any was written.
function applyTargets() {
	const params = rememberedParameters();
	let wrote = false;
	for (const [id, target] of targets) {
		const param = params.get(id);
		if (!param || matches(param, target)) continue;
		try {
			GameSetup.setGameParameterValue(id, target);
			wrote = true;
		} catch (error) {
			console.warn(`${LOG_PREFIX} could not restore ${id}: ${error}`);
			targets.delete(id);
		}
	}
	return wrote;
}

function buildTargets() {
	const saved = readSaved();
	const out = new Map();
	if (!saved) return out;
	for (const [id, param] of rememberedParameters()) {
		if (!(id in saved)) continue;
		const target = restorable(param, saved[id]);
		if (target !== undefined) out.set(id, target);
	}
	return out;
}

// ---------------------------------------------------------------- session --

// Runs once per poll. Returns whether it changed the setup or finished a
// restore, so the caller can treat the current values as its new baseline.
export function tickSetupMemory() {
	if (!isSetupOpen()) {
		phase = Phase.CLOSED;
		return false;
	}
	switch (phase) {
		case Phase.CLOSED:
			phase = Phase.SETTLING;
			settleRevision = GameSetup.currentRevision;
			quietPolls = 0;
			return false;
		case Phase.SETTLING: {
			const revision = GameSetup.currentRevision;
			if (revision != settleRevision || rememberedParameters().size == 0) {
				settleRevision = revision;
				quietPolls = 0;
				return false;
			}
			if (++quietPolls < SETTLE_POLLS) return false;
			targets = buildTargets();
			console.warn(`${LOG_PREFIX} restoring ${targets.size} remembered settings`);
			phase = Phase.GUARDING;
			guardUntil = Date.now() + GUARD_MS;
			applyTargets();
			return true;
		}
		case Phase.GUARDING:
			if (Date.now() < guardUntil) {
				return applyTargets();
			}
			phase = Phase.OPEN;
			targets = null;
			lastSaved = null;
			return true;
		default:
			return false;
	}
}

// Whether a restore is under way; the setup rules wait for it.
export const isRestoringSetup = () => phase == Phase.SETTLING || phase == Phase.GUARDING;

// Saves the current values while the setup screen is open and restored.
export function rememberSetup() {
	if (phase != Phase.OPEN || !isSetupOpen()) {
		return;
	}
	const values = snapshot();
	const serialized = JSON.stringify(values);
	if (serialized != lastSaved) {
		lastSaved = serialized;
		writeSaved(values);
	}
}

// Starting the game is the last chance to see the final values.
window.addEventListener(StartCampaignEventName, () => {
	try {
		rememberSetup();
	} catch (error) {
		console.warn(`${LOG_PREFIX} could not save at game start: ${error}`);
	}
});
