// What the host set in Advanced Settings Pro, shown to everyone in the lobby.
//
// The lobby's own summaries list a fixed set of base rules (rule set, map,
// speed, turn timer and so on), so a player who joins cannot see any of this
// mod's settings. Two places are extended, both from the same list below:
//   View All Rules      a list beside the screen's mods list, each scrolling on
//                       its own, of every setting changed from its default, in
//                       the setup tabs' order. Per-age rows are listed only while their
//                       setting is Custom, since otherwise the setting already
//                       says what they hold, and the wonder toggles collapse
//                       into one count.
//   Game Options box    Pace Set and Map Age, after Game Speed, always shown.
// Both read the live setup, so a change by the host shows the next time the
// rules open, or within half a second in the Game Options box.

const RULES_SCREEN = "screen-mp-game-rules";
const LOBBY_SCREEN = "screen-mp-lobby";
// The section is titled with this mod's name as the game lists enabled mods.
const MOD_ID = "AdvancedSettingsPro";
const SUMMARY_PARAM_IDS = ["ZG_PacePreset", "ZG_MapAge"];
const SUMMARY_ANCHOR = "LOC_UI_MP_LOBBY_GAME_SPEED";
const MOD_PREFIX = "ZG_";
// Base settings this mod moves onto its own tabs, which the base rules omit.
const BASE_PARAM_IDS = new Set(["AgeLength", "LegacySets", "MapSeaLevel", "IndependentHostility", "MementosEnabled", "AgeTransitionCivSelectionMode"]);
// Shown through another row: the Pace tab's copy of Pace Set, and per-player flags.
const SKIPPED_PARAM_IDS = new Set(["ZG_PaceSetMirror", "ZG_PlayerRandomMementos"]);
const WONDER_PREFIX = "ZG_NW_";
const WONDER_COUNT_PARAM_ID = "ZG_NaturalWondersCount";
const AGE_SUFFIX = /(Antiquity|Exploration|Modern)$/;
// A per-age row's setting, where it is not the row's own id less the age.
const AGE_PARENTS = { ZG_Disasters: "ZG_DisasterFrequency", ZG_TriumphSet: "LegacySets", ZG_AgeLength: "AgeLength" };
const CUSTOM_MARKER = "CUSTOM";
const REFRESH_MS = 500;
const LOG_PREFIX = "ZG-ASP lobby rules:";

function query(sql) {
	try {
		return Database.query("config", sql) ?? [];
	} catch (error) {
		console.error(`${LOG_PREFIX} query failed: ${error}`);
		return [];
	}
}

// Defaults and sort order, once per shell session.
let lookups = null;
function getLookups() {
	if (lookups) {
		return lookups;
	}
	const defaults = new Map();
	const sortIndex = new Map();
	for (const row of query("SELECT ParameterID, DefaultValue, SortIndex FROM Parameters")) {
		if (!defaults.has(row.ParameterID)) {
			defaults.set(row.ParameterID, row.DefaultValue);
			sortIndex.set(row.ParameterID, row.SortIndex ?? 0);
		}
	}
	lookups = { defaults, sortIndex };
	return lookups;
}

const paramId = (param) => GameSetup.resolveString(param.ID) ?? "";
const rawValue = (param) => param?.value?.value;
const sameValue = (a, b) => String(a).toLowerCase() == String(b).toLowerCase() || (a === true && b == 1) || (a === false && b == 0);

function settingValueText(param) {
	const value = rawValue(param);
	if (typeof value == "boolean") {
		return Locale.compose(value ? "LOC_ZG_ENABLED_NAME" : "LOC_ZG_DISABLED_NAME");
	}
	return Locale.compose(GameSetup.resolveString(param.value?.name) ?? String(value ?? ""));
}

function ageParentId(id) {
	const stem = id.replace(AGE_SUFFIX, "");
	return AGE_PARENTS[stem] ?? stem;
}

function isListed(param) {
	const id = paramId(param);
	if (param.hidden || param.invalidReason != GameSetupParameterInvalidReason.Valid) {
		return false;
	}
	if (!(id.startsWith(MOD_PREFIX) || BASE_PARAM_IDS.has(id)) || SKIPPED_PARAM_IDS.has(id) || id.startsWith(WONDER_PREFIX)) {
		return false;
	}
	if (param.array || ![GameSetupDomainType.Select, GameSetupDomainType.Boolean].includes(param.domain?.type)) {
		return false;
	}
	if (id.startsWith(MOD_PREFIX) && AGE_SUFFIX.test(id)) {
		const parent = String(rawValue(GameSetup.findGameParameter(ageParentId(id))) ?? "");
		return parent.toUpperCase().includes(CUSTOM_MARKER);
	}
	const fallback = getLookups().defaults.get(id);
	return fallback == null || !sameValue(rawValue(param), fallback);
}

// "N of M enabled" when any natural wonder has been switched off.
function wonderSummary(parameters) {
	const wonders = parameters.filter((param) => paramId(param).startsWith(WONDER_PREFIX) && !param.hidden);
	const enabled = wonders.filter((param) => rawValue(param) === true || String(rawValue(param)).toUpperCase().includes("ENABLED")).length;
	if (wonders.length == 0 || enabled == wonders.length) {
		return null;
	}
	const label = GameSetup.findGameParameter(WONDER_COUNT_PARAM_ID)?.name;
	return { label: `${Locale.compose(GameSetup.resolveString(label) ?? "")}:`, value: `${enabled} / ${wonders.length}` };
}

// Per-age rows read "Setting (Age)", whether the row is named for the setting
// (the Pace rows) or for the age (the Triumph Set rows).
function rowLabel(param, id) {
	const age = id.match(AGE_SUFFIX)?.[1];
	if (!age) {
		return Locale.compose(GameSetup.resolveString(param.name) ?? id);
	}
	const setting = Locale.compose(GameSetup.resolveString(GameSetup.findGameParameter(ageParentId(id))?.name) ?? "");
	return `${setting} (${Locale.compose(`LOC_AGE_${age.toUpperCase()}_NAME`)})`;
}

// The changed settings, as [{ label, value }] in the setup tabs' order.
function changedSettings() {
	const { sortIndex } = getLookups();
	const parameters = [...GameSetup.getGameParameters()];
	const rows = parameters
		.filter(isListed)
		.sort((a, b) => (sortIndex.get(paramId(a)) ?? 0) - (sortIndex.get(paramId(b)) ?? 0))
		.map((param) => ({ label: `${rowLabel(param, paramId(param))}:`, value: settingValueText(param) }));
	const wonders = wonderSummary(parameters);
	return wonders ? [...rows, wonders] : rows;
}

// ------------------------------------------------------------ rules screen --

function modTitle() {
	const game = Configuration.getGame();
	for (let index = 0; index < game.enabledModCount; index++) {
		if (game.getEnabledModId(index) == MOD_ID) {
			return Locale.unpack(game.getEnabledModTitle(index));
		}
	}
	return "";
}

// The window may grow past the base 64rem to fit the two lists side by side,
// each a fixed width so the window, not the rules above, sets their size.
const FRAME_MAX_WIDTH = "80rem";
const LIST_WIDTH = "23rem";
const LIST_BORDER = "0.0833rem solid rgba(140, 126, 98, 0.6)";
const LIST_GAP = "2rem";

// The screen's own mods header: a title over a pair of dividers.
function sectionHeader() {
	const header = document.createElement("div");
	header.className = "mb-2";
	header.innerHTML = '<div class="font-title-base text-center text-gradient-secondary -mb-3 uppercase whitespace-nowrap"></div><div class="flow-row justify-center"><div class="img-unit-panel-divider -scale-y-100"></div><div class="img-unit-panel-divider -scale-100"></div></div>';
	header.firstChild.textContent = modTitle();
	return header;
}

// A list's scroll area inside a thin frame, so the two lists read as separate.
function frameList(scrollable) {
	const frame = document.createElement("div");
	frame.className = "flex-auto flow-column p-2";
	Object.assign(frame.style, { minHeight: "0", border: LIST_BORDER });
	scrollable.insertAdjacentElement("beforebegin", frame);
	frame.appendChild(scrollable);
	return frame;
}

// One of the two lists: the same width whatever each holds.
function asColumn(el) {
	el.classList.remove("flex-auto");
	Object.assign(el.style, { flex: `0 0 ${LIST_WIDTH}`, width: LIST_WIDTH, minHeight: "0" });
}

// Rows as the base rules draw them, left-aligned: label and value side by side
// on one line, each wrapping within its own space only when the line is too
// narrow for it.
function addRow(component, list, label, value) {
	const row = component.addRule(list, label, value);
	if (!row) {
		return;
	}
	row.classList.remove("max-w-96", "min-w-60", "px-2", "items-center");
	row.classList.add("w-full", "items-start", "mb-1");
	const [labelEl, valueEl] = [row.firstChild, row.lastChild];
	for (const part of [labelEl, valueEl]) {
		part.classList.remove("font-fit-shrink", "flex-auto", "whitespace-nowrap");
		part.style.minWidth = "0";
	}
	labelEl.style.flex = "0 1 auto";
	valueEl.style.flex = "1 1 auto";
}

function createSection(component) {
	const rows = changedSettings();
	if (rows.length == 0) {
		return null;
	}
	const section = document.createElement("div");
	section.className = "flow-column";
	section.appendChild(sectionHeader());
	const scrollable = document.createElement("fxs-scrollable");
	scrollable.className = "flex-auto";
	scrollable.setAttribute("handle-gamepad-pan", "true");
	const list = document.createElement("div");
	list.className = "flow-column items-start px-2";
	for (const { label, value } of rows) {
		addRow(component, list, label, value);
	}
	scrollable.appendChild(list);
	section.appendChild(scrollable);
	frameList(scrollable);
	return section;
}

class RulesSection {
	constructor(component) {
		this.component = component;
	}

	// Two framed lists of equal width under the base rules, the mods on the left
	// and this mod's settings on the right, each scrolling on its own.
	afterAttach() {
		const root = this.component.Root;
		const mods = root.querySelector(".mods-container");
		const section = mods ? createSection(this.component) : null;
		if (!section) {
			return;
		}
		const frameContainer = root.querySelector(".mp-game-rules-frame-container");
		if (frameContainer) {
			frameContainer.style.maxWidth = FRAME_MAX_WIDTH;
		}
		const modsScroll = mods.querySelector(".mp-game-rules__mods-scrollable");
		if (modsScroll) {
			frameList(modsScroll);
		}
		const modsList = mods.querySelector(".mp-game-rules__mods");
		modsList?.classList.replace("items-center", "items-start");
		const row = document.createElement("div");
		row.className = "flex-auto flow-row justify-center";
		row.style.minHeight = "0";
		mods.insertAdjacentElement("beforebegin", row);
		row.append(mods, section);
		asColumn(mods);
		asColumn(section);
		if (!mods.classList.contains("hidden")) {
			mods.style.marginRight = LIST_GAP;
		}
	}

	beforeAttach() {}
	beforeDetach() {}
	afterDetach() {}
	onAttributeChanged() {}
}

Controls.decorate(RULES_SCREEN, (component) => new RulesSection(component));

// ------------------------------------------------------ Game Options box --

function summaryRow(template) {
	const row = template.cloneNode(true);
	const [label, valueWrap] = row.children;
	label.removeAttribute("data-l10n-id");
	label.removeAttribute("data-bind-attributes");
	const value = valueWrap.querySelector("[data-bind-attributes]") ?? valueWrap.firstElementChild;
	value.removeAttribute("data-bind-attributes");
	value.removeAttribute("data-l10n-id");
	return { row, label, value };
}

class LobbySummary {
	constructor(component) {
		this.component = component;
		this.rows = [];
		this.timer = null;
		this.lastRevision = -1;
	}

	afterAttach() {
		const anchor = this.component.Root.querySelector(`[data-l10n-id="${SUMMARY_ANCHOR}"]`)?.parentElement;
		if (!anchor || this.rows.length > 0) {
			return;
		}
		let after = anchor;
		for (const id of SUMMARY_PARAM_IDS) {
			const entry = summaryRow(anchor);
			entry.id = id;
			after.insertAdjacentElement("afterend", entry.row);
			after = entry.row;
			this.rows.push(entry);
		}
		this.refresh();
		this.timer = setInterval(() => this.refresh(), REFRESH_MS);
	}

	refresh() {
		if (GameSetup.currentRevision == this.lastRevision) {
			return;
		}
		this.lastRevision = GameSetup.currentRevision;
		for (const entry of this.rows) {
			const param = GameSetup.findGameParameter(entry.id);
			entry.row.classList.toggle("hidden", !param);
			if (param) {
				entry.label.textContent = `${Locale.compose(GameSetup.resolveString(param.name) ?? "")}:`;
				entry.value.textContent = settingValueText(param);
			}
		}
	}

	beforeDetach() {
		clearInterval(this.timer);
		this.timer = null;
		this.rows.forEach((entry) => entry.row.remove());
		this.rows = [];
		this.lastRevision = -1;
	}

	beforeAttach() {}
	afterDetach() {}
	onAttributeChanged() {}
}

Controls.decorate(LOBBY_SCREEN, (component) => new LobbySummary(component));
