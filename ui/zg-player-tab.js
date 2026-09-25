// The single-player Advanced Settings Player tab: one row per player carrying
// Leader, Team, Civilization and two Memento slots.
//
// The game's player list is not exported, so this file renders the list itself
// with the game's own components, models and templates (a port of the game's
// AdvancedOptionsPlayerSetup), adding the Team and Memento columns the base tab
// has no room for, and swaps it in through the same Tab.Item hook the Map tab
// uses.
//
// It also applies the two settings the tab's Memento columns stand for: the
// per-player Random flag behind a slot's Random entry, and Game Settings' AI
// Mementos, which fills every AI player's slots at once. The draws themselves
// live in zg-memento-roller.js, shared with the age transition.
import { template, insert } from 'fs://game/core/vendor/solid-js/web/dist/web.js';
import { createMemo, createComponent, createRenderEffect, mergeProps, For, Show } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { ComponentRegistry } from 'fs://game/core/ui-next/services/component-registry.js';
import { multiplayerTeamColors } from 'fs://game/core/ui/utilities/utilities-network-constants.js';
import { openMementoSelect } from './zg-memento-select.js';
import { MEMENTO_PARAM_IDS, MEMENTO_NONE_VALUE, MEMENTO_SLOT_BASE_IMAGE, MEMENTO_SLOT_PLUS_IMAGE, RANDOM_FLAG_PARAM_ID, RANDOM_FLAGS, AI_MEMENTOS_PARAM_ID, AI_MEMENTOS_DEFAULT, aiMementoMode, aiPlayerIds, matchSource, randomFlags, setRandomFlag, rollMemento, sortPossibleValues } from './zg-memento-roller.js';
import { canEditSetup, isAgeTransition } from './zg-shell-context.js';
import { Activatable } from 'fs://game/core/ui-next/components/activatable.js';
import { Button } from 'fs://game/core/ui-next/components/button.js';
import { Dropdown, DropdownItem } from 'fs://game/core/ui-next/components/dropdown.js';
import { Icon } from 'fs://game/core/ui-next/components/icon.js';
import { L10n } from 'fs://game/core/ui-next/components/l10n.js';
import { ScrollArea } from 'fs://game/core/ui-next/components/scroll-area.js';
import { SpatialSlot } from 'fs://game/core/ui-next/components/slot.js';
import { Tooltip, TooltipHorizontalPosition } from 'fs://game/core/ui-next/components/tooltip.js';
import { AgeSelectModel } from 'fs://game/core/ui-next/screens/create-game/age-select-model.js';
import { AttributeIcon } from 'fs://game/core/ui-next/screens/create-game/attribute-icon.js';
import { CivSelectModel } from 'fs://game/core/ui-next/screens/create-game/civ-select-model.js';
import { LeaderSelectModel } from 'fs://game/core/ui-next/screens/create-game/leader-select-model.js';
import { PlayerSetupParametersModel } from 'fs://game/core/ui-next/screens/create-game/game-parameters-model.js';
import { TicketBox } from 'fs://game/core/ui-next/screens/create-game/ticket-box.js';
import 'fs://game/core/ui-next/components/tab.js';
import './zg-map-tab.js';

const OVERRIDE_PRIORITY = 110;
const PLAYER_TAB_NAME = "advanced-options-player";
// INTERIM: mods that render their own Player tab, by mod id as their modinfo
// declares it. One of these being enabled is not a conflict to resolve but a tab
// to concede, so this file stands aside and lets their tab body show.
//
// This is a stopgap held on this side while those authors have not handled the
// overlap on theirs, and is meant to be removed rather than grown. To drop it,
// delete this list and the `claimingMod` branch at the tab hook below; nothing
// else refers to either.
const PLAYER_TAB_MODS = ["Enable_Custom_Map_Start_Locations"];
const MEMENTO_DEFAULT_ICON = "mem_min_leader.png";
// An empty slot gets a crossed-out circle rather than a memento's own art. The
// game's only such image is its "cannot place" cursor, which ships on every
// platform. It is red, so it is tinted to sit beside the Random icon; set the
// tint to "" to leave it in the game's own red.
const MEMENTO_NONE_ICON = "fs://game/core/ui/cursors/macos/cantplace.png";
const MEMENTO_NONE_TINT = "#8c7e62";
const RANDOM_OPTION = { value: "ZG_RANDOM", name: "LOC_ADVANCED_OPTIONS_RANDOM", description: "LOC_ADVANCED_OPTIONS_RANDOM", icon: null, sortIndex: -Infinity };
// A team is a plain int on the player configuration, carrying no list of
// choices, so the options are built here the way the lobby builds its own.
const TEAM_NONE_VALUE = -1;
// The lobby offers eight teams, hard-coded, and so does this.
const TEAM_COUNT = 8;
const POLL_MS = 250;
// Column proportions shared by the header and the rows. Team and the Mementos
// each show one icon, so they need room for that and the dropdown arrow and no
// more; the two name columns take what is left.
// A memento slot is a fixed box, so its columns do not grow: each is the box
// plus the same 1rem of margin the dropdowns carry, and the shared heading is
// sized to the pair so it centers over them.
const SLOT_BOX_REM = 3.5;
const SLOT_COLUMN_REM = SLOT_BOX_REM + 1;
const COLUMN_FLEX = [2, 0.68, 2, 0, 0];
const flexOf = (grow) => (grow > 0 ? `${grow} 1 0` : "0 0 auto");
const fixedRemOf = (columns) => columns.filter((index) => COLUMN_FLEX[index] == 0).length * SLOT_COLUMN_REM;
// One header can sit over more than one column: the two memento slots share a
// single "Mementos" heading.
const COLUMN_HEADERS = [
	{ text: "LOC_GENERIC_LEADER", columns: [0] },
	{ text: "LOC_ZG_TEAM_NAME", columns: [1] },
	{ text: "LOC_GENERIC_CIVILIZATION", columns: [2] },
	{ text: "LOC_ZG_MEMENTOS_NAME", columns: [3, 4] },
];

const resolve = (handle) => GameSetup.resolveString(handle) ?? "";
const functionalDescriptionName = GameSetup.findString("FunctionalDescription");

// Templates, as in the game's advanced-options.js.
const tplTitle = template(`<div class="uppercase text-secondary-1 font-title mb-2 self-center"></div>`);
const tplTags = template(`<div class="flex flex-row items-center justify-start mb-4 self-center"></div>`);
const tplSubtitle = template(`<div class="uppercase text-secondary-1 text-sm font-title"></div>`);
const tplRandom = template(`<div class="uppercase text-secondary-1 text-sm font-title flex items-center justify-center py-4"></div>`);
const tplTagIcon = template(`<div class="create-game-civ-card-icon flex items-center justify-center"></div>`);
const tplTagText = template(`<div class="uppercase ml-2 mr-4"></div>`);
const tplBonusTitle = template(`<div class="uppercase text-secondary-1 text-sm font-title mt-4"></div>`);
const tplBonusRow = template(`<div class="flex flex-row mt-1 items-center"></div>`);
const tplOption = template(`<div class="flex flex-row items-center min-w-0"></div>`);
// A long name has to be able to shrink, or it runs under the dropdown arrow.
const tplOptionText = template(`<div class="min-w-0 flex-1 truncate"></div>`);
const tplHeader = template(`<div class="flex flex-row mt-4"><div class=w-10></div><div class="flex flex-row flex-auto pl-1 pr-6"></div><div class=w-14 style="position:relative;left:0.525rem"></div></div>`);
const tplHeaderCell = template(`<div class="m-2 flex items-center justify-center uppercase font-title tracking-150 pointer-events-auto" role=columnheader></div>`);
const tplColumn = template(`<div class="flex flex-row"></div>`);
const tplAddPlayer = template(`<div class="flex-auto flex flex-row justify-start items-center"><div class="advanced-options_add-player-plus bg-no-repeat bg-contain size-12 m-3"></div></div>`);
const tplCloseBg = template(`<div class="close-button__bg absolute inset-0"></div>`);
const tplCloseHover = template(`<div class="close-button__bg-hover absolute inset-0 opacity-0 group-hover\\:opacity-100 group-focus\\:opacity-100 transition-opacity"></div>`);
const tplClosePressed = template(`<div class="close-button__bg-pressed absolute inset-0 opacity-0 group-active\\:opacity-100 group-pressed\\:opacity-100"></div>`);
const tplRow = template(`<div class="flex flex-row"><div class="w-10 flex items-center justify-start text-base font-title"></div><div class="flex flex-row flex-auto pl-1 pr-6"></div><div class=w-14 style="position:relative;left:0.525rem"></div></div>`);
const tplMementoIcon = template(`<div class="size-8 mr-3 ml-2 bg-contain bg-center bg-no-repeat"></div>`);
const tplMementoText = template(`<div class="mt-2"></div>`);

// ------------------------------------------------------------ tooltips --

function tagList(items) {
	const el = tplTags();
	insert(el, createComponent(For, {
		get each() { return items(); },
		children: (attribute) => [
			(() => { const icon = tplTagIcon(); insert(icon, createComponent(AttributeIcon, { class: "size-8", attribute })); return icon; })(),
			(() => { const text = tplTagText(); insert(text, createComponent(L10n.Compose, { text: attribute })); return text; })(),
		],
	}));
	return el;
}

function titleLine(text) {
	const el = tplTitle();
	insert(el, createComponent(L10n.Compose, { get text() { return text(); } }));
	return el;
}

function randomBox(text) {
	return createComponent(TicketBox, {
		get children() { const el = tplRandom(); insert(el, createComponent(L10n.Compose, { text })); return el; },
	});
}

const LeaderTooltip = (props) => {
	const model = LeaderSelectModel.get();
	const leaderType = createMemo(() => props.data.value);
	const leader = createMemo(() => model.leaders.find((entry) => entry.leaderID == leaderType()));
	const isRandom = createMemo(() => leaderType() == "RANDOM");
	return createComponent(Tooltip.Frame, {
		class: "flex flex-col relative max-w-128",
		get children() {
			return [
				createComponent(Show, { get when() { return !isRandom(); }, get children() { return titleLine(() => leader()?.name); } }),
				tagList(() => leader()?.tags),
				createComponent(Show, {
					get when() { return !isRandom(); },
					get children() {
						return createComponent(TicketBox, {
							class: "px-6 pt-4 pb-6",
							get children() {
								return [
									(() => { const el = tplSubtitle(); insert(el, createComponent(L10n.Compose, { get text() { return leader()?.abilityTitle ?? ""; } })); return el; })(),
									createComponent(L10n.Stylize, { class: "create-game-markup mt-2", get text() { return leader()?.abilityTextTag; } }),
								];
							},
						});
					},
				}),
				createComponent(Show, { get when() { return isRandom(); }, get children() { return randomBox("LOC_LEADER_RANDOM_NAME"); } }),
			];
		},
	});
};

const CivTooltip = (props) => {
	const civModel = CivSelectModel.get();
	const age = AgeSelectModel.get().selectedAge;
	const civType = createMemo(() => props.data.value);
	const civilization = createMemo(() => civModel.civs.find((entry) => entry.civID == civType()));
	const activeAbility = createMemo(() => civilization()?.perAgeAbilities.find((a) => a.age == age.type) ?? civilization()?.perAgeAbilities.find((a) => !a.age));
	const isRandom = createMemo(() => civType() == "RANDOM");
	const bonusRows = (items) => createComponent(For, {
		get each() { return items(); },
		children: (bonus) => {
			const el = tplBonusRow();
			insert(el, createComponent(Icon, { class: "size-8 mr-2", get name() { return bonus.icon; } }), null);
			insert(el, createComponent(L10n.Compose, { get text() { return bonus.title; } }), null);
			return el;
		},
	});
	return createComponent(Tooltip.Frame, {
		class: "flex flex-col relative max-w-128",
		get children() {
			return [
				createComponent(Show, { get when() { return !isRandom(); }, get children() { return titleLine(() => civilization()?.name); } }),
				tagList(() => civilization()?.traits),
				createComponent(Show, {
					get when() { return !isRandom(); },
					get children() {
						return createComponent(TicketBox, {
							class: "px-6 pt-4 pb-6",
							get children() {
								return [
									(() => { const el = tplSubtitle(); insert(el, createComponent(L10n.Compose, { get text() { return activeAbility()?.abilityTitle ?? ""; } })); return el; })(),
									createComponent(L10n.Stylize, { class: "create-game-markup tight mt-2", get text() { return activeAbility()?.abilityText ?? ""; } }),
									(() => { const el = tplBonusTitle(); insert(el, createComponent(L10n.Compose, { text: "LOC_CREATE_CIV_UNIQUE_BONUSES_SUBTITLE" })); return el; })(),
									bonusRows(() => civilization()?.buildings),
									bonusRows(() => civilization()?.units),
								];
							},
						});
					},
				}),
				createComponent(Show, { get when() { return isRandom(); }, get children() { return randomBox("LOC_CIVILIZATION_RANDOM_NAME"); } }),
			];
		},
	});
};

const MementoTooltip = (props) => {
	const functional = () => props.data.additionalProperties?.find((entry) => entry.name === functionalDescriptionName)?.value;
	if (props.data === RANDOM_OPTION) {
		return createComponent(Tooltip.Frame, { class: "flex flex-col relative max-w-128", get children() { return randomBox(RANDOM_OPTION.name); } });
	}
	return createComponent(Tooltip.Frame, {
		class: "flex flex-col relative max-w-128",
		get children() {
			return [
				titleLine(() => resolve(props.data.name)),
				createComponent(L10n.Stylize, { class: "create-game-markup", get text() { return resolve(props.data.description); } }),
				createComponent(Show, {
					get when() { return functional(); },
					get children() { const el = tplMementoText(); insert(el, createComponent(L10n.Stylize, { class: "create-game-markup tight", get text() { return functional(); } })); return el; },
				}),
			];
		},
	});
};

// ------------------------------------------------------------- options --

function optionText(child) {
	const el = tplOptionText();
	insert(el, child);
	return el;
}

const PlayerOption = (props) => {
	const el = tplOption();
	insert(el, createComponent(Icon, {
		get class() { return props.param.value == "RANDOM" ? "size-8 mr-3 ml-2" : "size-12 mr-1"; },
		get name() { return props.param.value == "RANDOM" ? "LEADER_RANDOM" : props.param.value; },
	}), null);
	insert(el, optionText(createComponent(L10n.Stylize, { get text() { return resolve(props.param.name); } })), null);
	return el;
};

function addMementoIcon(el, props) {
	if (props.param === RANDOM_OPTION) {
		insert(el, createComponent(Icon, { class: "size-8 mr-3 ml-2", name: "LEADER_RANDOM" }), null);
		return;
	}
	const icon = tplMementoIcon();
	createRenderEffect(() => {
		if (props.param.value == MEMENTO_NONE_VALUE) {
			icon.style.backgroundImage = `url("${MEMENTO_NONE_ICON}")`;
			if (MEMENTO_NONE_TINT) {
				icon.style.setProperty("fxs-background-image-tint", MEMENTO_NONE_TINT);
			} else {
				icon.style.removeProperty("fxs-background-image-tint");
			}
			return;
		}
		icon.style.backgroundImage = `url("fs://game/${resolve(props.param.icon) || MEMENTO_DEFAULT_ICON}")`;
		icon.style.removeProperty("fxs-background-image-tint");
	});
	el.appendChild(icon);
}

// A memento is shown by its icon alone, in the closed dropdown and in the open
// list. Hovering either still gives the full memento tooltip.
const MementoIcon = (props) => {
	const el = tplOption();
	addMementoIcon(el, props);
	return el;
};

// ------------------------------------------------------- memento slots --

// A memento slot drawn the way the Overview hub draws its own: the panel box,
// the filigree and rollover, and either the memento's icon or, for an empty
// slot, the slot base image. Clicking one opens the game's memento picker, the
// one with the search bar and attribute filter, for the player this row stands
// for, over Advanced Options (ui/zg-memento-select.js, shared with the lobby).
const SLOT_PLUS_REM = 1.6;
const SLOT_ICON_CLASSES = "w-full h-full absolute inset-1";
const tplSlotBox = template(`<div class="flex items-center justify-center p-1 img-unit-panelbox relative"><div class="absolute inset-0 bg-center bg-no-repeat"></div><div class="img-rollover-highlight absolute inset-0 opacity-0 group-focus\\:opacity-100 group-hover\\:opacity-100 group-pressed\\:opacity-100 pointer-events-none"></div></div>`);

function MementoSlotCell(props) {
	const current = () => props.param()?.value;
	const isEmpty = () => (current()?.value ?? MEMENTO_NONE_VALUE) == MEMENTO_NONE_VALUE;
	return createComponent(Tooltip.Text, {
		get text() { return isEmpty() ? "LOC_MEMENTO_NONE_NAME" : resolve(current()?.name); },
		get children() {
			return createComponent(Activatable, {
				class: "flex flex-row group relative mx-2 my-1",
				onActivate: () => openMementoSelect(props.playerId, props.slotIndex),
				get children() {
					const box = tplSlotBox();
					box.style.width = `${SLOT_BOX_REM}rem`;
					box.style.height = `${SLOT_BOX_REM}rem`;
					const plus = box.firstChild;
					plus.style.backgroundImage = MEMENTO_SLOT_PLUS_IMAGE;
					plus.style.backgroundSize = `${SLOT_PLUS_REM}rem ${SLOT_PLUS_REM}rem`;
					const highlight = box.lastChild;
					insert(box, createComponent(Show, {
						get when() { return isEmpty(); },
						get fallback() {
							return createComponent(Icon, {
								get name() { return `url('blp:${resolve(current()?.icon)}')`; },
								isUrl: true,
								class: SLOT_ICON_CLASSES,
							});
						},
						get children() {
							return createComponent(Icon, { name: MEMENTO_SLOT_BASE_IMAGE, isUrl: true, class: `${SLOT_ICON_CLASSES} opacity-60` });
						},
					}), highlight);
					return box;
				},
			});
		},
	});
}

// ---------------------------------------------------------------- teams --

// The choices for one player's team. An int parameter carries no list of its
// own, so this mirrors the multiplayer lobby's own dropdown: a blank entry for
// no team, then a fixed eight teams regardless of the map's player count.
function teamChoices() {
	const choices = [{ value: TEAM_NONE_VALUE, sortIndex: -1 }];
	for (let team = 0; team < TEAM_COUNT; team++) {
		choices.push({ value: team, sortIndex: team });
	}
	return choices;
}

// A parameter-shaped view of a player's team, so it can drive the same dropdown
// the Leader and Civilization columns use. The team is read and written through
// the player configuration rather than the setup parameter: the multiplayer
// lobby is the only part of the game that sets a team, and that is the path it
// uses, so it is the one known to reach the engine.
function teamParameter(playerId) {
	const choices = teamChoices();
	const current = Configuration.getPlayer(playerId)?.team;
	const selected = choices.find((choice) => choice.value == current) ?? choices[0];
	return {
		domain: { possibleValues: choices },
		value: selected,
		setValue: (value) => Configuration.editPlayer(playerId)?.setTeam(value),
	};
}

// The multiplayer lobby's team badge: one tinted image for the ring, a second
// tinted with the team's color inside it, and the team number over the top.
const TEAM_IMAGE = "url('fs://game/mp_lobby_teamcolor.png')";
const TEAM_RING_TINT = "#8c7e62";
// The ring fills its box edge to edge, where leader portraits and civilization
// symbols carry their own margin inside the image, so the badge adds the inset.
const tplTeamBadge = template(`<div class="relative size-12 ml-2 flex items-center justify-center"><div class="absolute inset-0 bg-cover"></div><div class="absolute bg-cover" style="left:0.25rem;top:0.25rem;right:0.25rem;bottom:0.25rem"></div><div class="relative font-title text-base"></div></div>`);
const tplTeamNumber = template(`<div class="flex flex-row items-center font-title text-base"></div>`);

// Colour index 0 is the empty badge, so a team maps one past it.
const teamColor = (value) => multiplayerTeamColors[(value < 0 ? 0 : value + 1) % multiplayerTeamColors.length];
const teamNumber = (value) => (value < 0 ? "" : `${value + 1}`);

const TeamBadge = (props) => {
	const el = tplTeamBadge();
	const ring = el.firstChild, fill = ring.nextSibling, label = fill.nextSibling;
	ring.style.backgroundImage = TEAM_IMAGE;
	ring.style.setProperty("fxs-background-image-tint", TEAM_RING_TINT);
	fill.style.backgroundImage = TEAM_IMAGE;
	createRenderEffect(() => {
		fill.style.setProperty("fxs-background-image-tint", teamColor(props.param.value));
		label.textContent = teamNumber(props.param.value);
	});
	return el;
};

const TeamNumber = (props) => {
	const el = tplTeamNumber();
	createRenderEffect(() => { el.textContent = teamNumber(props.param.value); });
	return el;
};

const TeamTooltip = () => createComponent(Tooltip.Frame, {
	class: "flex flex-col relative max-w-128",
	get children() { return createComponent(L10n.Compose, { text: "LOC_ZG_TEAM_DESCRIPTION" }); },
});

// A row cell sized by the shared column proportions.
function column(index, child) {
	const el = tplColumn();
	el.style.flex = flexOf(COLUMN_FLEX[index]);
	if (COLUMN_FLEX[index] == 0) {
		el.style.width = `${fixedRemOf([index])}rem`;
	}
	insert(el, child);
	return el;
}

// A dropdown over a setup parameter, with the given option and tooltip components.
// `random` (optional) adds a Random item: { isRandom, setRandom }.
// `listOption` (optional) draws the items in the open list when they should look
// different from the selected one, as the team badge does.
function parameterDropdown(param, option, tooltip, side, classes, random, listOption) {
	const withTooltip = (value, trigger) => createComponent(Tooltip, {
		initialHPosition: side,
		get children() {
			return [
				createComponent(Tooltip.Trigger, { get children() { return trigger(); } }),
				createComponent(Tooltip.Content, { get children() { return createComponent(tooltip, { data: value }); } }),
			];
		},
	});
	const items = () => {
		const values = sortPossibleValues(param().domain.possibleValues) ?? [];
		return random ? [RANDOM_OPTION, ...values] : values;
	};
	return createComponent(Dropdown, {
		class: classes,
		get defaultValue() { return random?.isRandom() ? RANDOM_OPTION : param().value; },
		selectedItemTemplate: (value) => withTooltip(value, () => createComponent(option, { param: value })),
		onItemSelected: (value) => {
			if (value === RANDOM_OPTION) {
				random.setRandom(true);
			} else {
				random?.setRandom(false);
				param().setValue(value.value);
			}
		},
		get children() {
			const item = listOption ?? option;
			return createComponent(For, {
				get each() { return items(); },
				children: (value) => withTooltip(value, () => createComponent(DropdownItem, { value, get children() { return createComponent(item, { param: value }); } })),
			});
		},
	});
}

// --------------------------------------------------------- AI mementos --

// AI slots hold RANDOM for the whole setup screen: the engine only resolves them
// at game creation, after this screen has handed off, and nothing here can see
// the result. A match mode therefore reaches only the players whose leader or
// civilization was chosen by hand; the rest have no attributes to match and fall
// back to an unrestricted draw.
function applyAiMementos(mode, playerId) {
	const attributes = mode.attributes?.().get(matchSource(mode, playerId)) ?? [];
	MEMENTO_PARAM_IDS.forEach((id, slotIndex) => {
		setRandomFlag(playerId, slotIndex, mode.random === true);
		if (mode.random) {
			rolledThisSession.delete(`${playerId}:${slotIndex}`);
		} else if (mode.sourceId) {
			rollMemento(playerId, slotIndex, attributes[slotIndex]);
		} else {
			GameSetup.setPlayerParameterValue(playerId, id, MEMENTO_NONE_VALUE);
		}
	});
}

// Rolls every slot flagged Random once per game session, so each new game
// starts from a fresh pick while the choice itself is kept, and applies AI
// Mementos whenever it changes. Both adopt whatever the screen already holds on
// the first pass, so a restored setup keeps the mementos it was saved with.
const rolledThisSession = new Set();
const appliedSources = new Map();
let lastRevision = -1;
let appliedValue = null;
setInterval(() => {
	// An age transition runs through this same shell; the AI's mementos there
	// are Age Transition AI Mementos' to settle, in zg-age-transition-mementos.js.
	// In multiplayer only the host holds the setup.
	const revision = GameSetup.currentRevision;
	if (revision == lastRevision || isAgeTransition() || !canEditSetup()) {
		return;
	}
	// A fresh setup screen restarts the revision counter. Forget what was rolled
	// so the next game picks again, rather than keeping the last game's mementos
	// for as long as the app stays open.
	if (revision < lastRevision) {
		rolledThisSession.clear();
		appliedSources.clear();
		appliedValue = null;
	}
	lastRevision = revision;

	const value = GameSetup.findGameParameter(AI_MEMENTOS_PARAM_ID)?.value?.value ?? AI_MEMENTOS_DEFAULT;
	const mode = aiMementoMode();
	const changed = appliedValue != null && value != appliedValue;
	if (changed) {
		appliedSources.clear();
	}
	appliedValue = value;
	for (const playerId of aiPlayerIds()) {
		// In a match mode the slots follow the leader or civilization they matched,
		// so a later change to it draws again.
		const source = matchSource(mode, playerId);
		if (changed || (appliedSources.has(playerId) && appliedSources.get(playerId) !== source)) {
			applyAiMementos(mode, playerId);
		}
		appliedSources.set(playerId, source);
	}

	for (const playerId of Configuration.getGame()?.participatingPlayerIDs ?? []) {
		randomFlags(playerId).forEach((isRandom, slotIndex) => {
			const key = `${playerId}:${slotIndex}`;
			if (isRandom && !rolledThisSession.has(key)) {
				rolledThisSession.add(key);
				rollMemento(playerId, slotIndex);
			}
		});
	}
}, POLL_MS);

// ---------------------------------------------------------- player list --

const PlayerSetup = () => {
	const playerOptions = PlayerSetupParametersModel.get().players;
	const slots = PlayerSetupParametersModel.get().configuration;
	const hasOpenSlots = createMemo(() => slots.openSlots().length > 0);
	const closeSlot = (slot) => {
		if (slots.activeSlots().length <= 2) return;
		slot.setSlotStatus(SlotStatus.SS_CLOSED);
		slots.reload();
	};
	const openSlot = () => {
		if (hasOpenSlots()) {
			slots.openSlots()[0].setSlotStatus(SlotStatus.SS_COMPUTER);
			slots.reload();
		}
	};
	const playerParam = (slot, id) => playerOptions[slot.playerId]?.[id];
	const randomFor = (slot, slotIndex) => ({
		isRandom: () => (RANDOM_FLAGS[playerParam(slot, RANDOM_FLAG_PARAM_ID)?.value?.value] ?? RANDOM_FLAGS.ZG_RANDOM_MEMENTOS_NONE)[slotIndex],
		setRandom: (isRandom) => {
			setRandomFlag(slot.playerId, slotIndex, isRandom);
			if (isRandom) {
				rollMemento(slot.playerId, slotIndex);
			}
		},
	});

	const header = () => {
		const el = tplHeader();
		const cells = el.firstChild.nextSibling;
		COLUMN_HEADERS.forEach(({ text, columns }) => {
			const cell = tplHeaderCell();
			const grow = columns.reduce((total, index) => total + COLUMN_FLEX[index], 0);
			cell.style.flex = flexOf(grow);
			if (grow == 0) {
				// Less the cell's own m-2 margins.
				cell.style.width = `${fixedRemOf(columns) - 1}rem`;
			}
			insert(cell, createComponent(L10n.Compose, { text }));
			cells.appendChild(cell);
		});
		return el;
	};

	const row = (slot, slotNum) => {
		const el = tplRow();
		const number = el.firstChild, controls = number.nextSibling, close = controls.nextSibling;
		insert(number, () => slotNum() + 1);
		controls.appendChild(column(0, parameterDropdown(() => playerParam(slot, "PlayerLeader"), PlayerOption, LeaderTooltip, TooltipHorizontalPosition.RIGHT, "my-2 mr-2 flex-auto")));
		controls.appendChild(column(1, parameterDropdown(() => teamParameter(slot.playerId), TeamBadge, TeamTooltip, TooltipHorizontalPosition.LEFT, "my-2 mx-2 flex-auto", null, TeamNumber)));
		controls.appendChild(column(2, parameterDropdown(() => playerParam(slot, "PlayerCivilization"), PlayerOption, CivTooltip, TooltipHorizontalPosition.LEFT, "my-2 mx-2 flex-auto")));
		MEMENTO_PARAM_IDS.forEach((id, slotIndex) => {
			controls.appendChild(column(3 + slotIndex, createComponent(Show, {
				get when() { return playerParam(slot, id)?.domain?.possibleValues?.length > 0; },
				get children() { return createComponent(MementoSlotCell, { get playerId() { return slot.playerId; }, param: () => playerParam(slot, id), slotIndex }); },
			})));
		});
		insert(close, createComponent(Show, {
			get when() { return !slot.isLocalPlayer; },
			get children() {
				return createComponent(Activatable, {
					class: "m-2 size-12 cursor-pointer group relative",
					onActivate: () => closeSlot(slot),
					get children() { return [tplCloseBg(), tplCloseHover(), tplClosePressed()]; },
				});
			},
		}));
		return el;
	};

	return createComponent(ScrollArea, {
		class: "flex-auto",
		get children() {
			return createComponent(SpatialSlot, {
				name: "advanced-player-options-slot",
				class: "flex flex-col flex-auto w-full pr-8",
				get children() {
					return [
						header(),
						createComponent(For, { get each() { return slots.activeSlots(); }, children: row }),
						createComponent(Button, {
							class: "mt-4 my-10",
							onActivate: openSlot,
							get disabled() { return !hasOpenSlots(); },
							get children() {
								const el = tplAddPlayer();
								insert(el, createComponent(L10n.Compose, { text: "LOC_ADVANCED_OPTIONS_ADD_PLAYER" }), null);
								createRenderEffect(() => el.firstChild.classList.toggle("opacity-50", !hasOpenSlots()));
								return el;
							},
						}),
					];
				},
			});
		},
	});
};

// ------------------------------------------------------------ tab hook --

// INTERIM, removed with PLAYER_TAB_MODS above.
//
// Tab.Item is a single component shared by every tab, so its override priority
// cannot be set per tab: whoever holds the registration holds all of them. To
// leave one tab to another mod, this file skips its own registration entirely
// rather than lowering a priority, which would give away the Map and Pace tabs
// registered by zg-map-tab.js as well.
const claimingMod = Modding.getInstalledMods().find((mod) => mod.enabled && PLAYER_TAB_MODS.includes(mod.id));

const tabItem = ComponentRegistry.get("Tab.Item");
// `factory` is a signal accessor returning the currently registered factory.
// Read it once here to capture the previous implementation before this module
// overrides the registration; reading it later would return our own factory.
const createPreviousTabItem = tabItem?.factory?.();
if (claimingMod) {
	console.warn(`ZG-ASP player tab: leaving the Player tab to '${claimingMod.id}'`);
} else if (createPreviousTabItem) {
	ComponentRegistry.register({
		name: "Tab.Item",
		overridePriority: OVERRIDE_PRIORITY,
		createInstance: (props) => {
			if (props?.name != PLAYER_TAB_NAME) {
				return createPreviousTabItem(props);
			}
			return createPreviousTabItem(mergeProps(props, { body: () => createComponent(PlayerSetup, {}) }));
		},
	});
}
