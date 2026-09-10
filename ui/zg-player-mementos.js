// Adds Memento selection for AI players to the single-player Advanced Settings
// Player tab, on the same row as Leader and Civilization.
//
// The game's player list is not exported, so this file renders the list itself
// with the game's own components, models and templates (a port of the game's
// AdvancedOptionsPlayerSetup) plus a Mementos column, and swaps it in for the
// Player tab through the same Tab.Item hook the Map tab uses.
import { template, insert, className } from 'fs://game/core/vendor/solid-js/web/dist/web.js';
import { createMemo, createComponent, createRenderEffect, mergeProps, For, Show } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { ComponentRegistry } from 'fs://game/core/ui-next/services/component-registry.js';
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
const MEMENTO_PARAM_IDS = ["PlayerMementoMajorSlot", "PlayerMementoMinorSlot1"];
const MEMENTO_HEADERS = ["LOC_ZG_MEMENTO_1_NAME", "LOC_ZG_MEMENTO_2_NAME"];
const MEMENTO_DEFAULT_ICON = "mem_min_leader.png";
const MEMENTO_NONE_VALUE = "NONE";
const MEMENTO_NONE_NAME = "LOC_ZG_NONE_NAME";
// Random is not a memento the game knows: the mod keeps a per-player flag and
// rolls a real memento into the slot, once per game session.
const RANDOM_FLAG_PARAM_ID = "ZG_PlayerRandomMementos";
const RANDOM_FLAGS = { ZG_RANDOM_MEMENTOS_NONE: [false, false], ZG_RANDOM_MEMENTOS_MAJOR: [true, false], ZG_RANDOM_MEMENTOS_MINOR: [false, true], ZG_RANDOM_MEMENTOS_BOTH: [true, true] };
const RANDOM_OPTION = { value: "ZG_RANDOM", name: "LOC_ADVANCED_OPTIONS_RANDOM", description: "LOC_ADVANCED_OPTIONS_RANDOM", icon: null, sortIndex: -Infinity };
const POLL_MS = 250;
// Column proportions shared by the header and the rows: Leader, Civilization, Memento 1, Memento 2.
const COLUMN_FLEX = ["2 1 0", "2 1 0", "1.5 1 0", "1.5 1 0"];

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
const tplOption = template(`<div class="flex flex-row items-center"></div>`);
const tplHeader = template(`<div class="flex flex-row mt-4"><div class=w-12></div><div class="flex flex-row flex-auto px-6"></div><div class=w-14></div></div>`);
const tplHeaderCell = template(`<div class="m-2 flex items-center justify-center uppercase font-title tracking-150 pointer-events-auto" role=columnheader></div>`);
const tplColumn = template(`<div class="flex flex-row"></div>`);
const tplAddPlayer = template(`<div class="flex-auto flex flex-row justify-start items-center"><div class="advanced-options_add-player-plus bg-no-repeat bg-contain size-12 m-3"></div></div>`);
const tplCloseBg = template(`<div class="close-button__bg absolute inset-0"></div>`);
const tplCloseHover = template(`<div class="close-button__bg-hover absolute inset-0 opacity-0 group-hover\\:opacity-100 group-focus\\:opacity-100 transition-opacity"></div>`);
const tplClosePressed = template(`<div class="close-button__bg-pressed absolute inset-0 opacity-0 group-active\\:opacity-100 group-pressed\\:opacity-100"></div>`);
const tplRow = template(`<div class="flex flex-row"><div class="w-12 flex items-center justify-start text-base font-title"></div><div class="flex flex-row flex-auto px-6"></div><div class=w-14></div></div>`);
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

const PlayerOption = (props) => {
	const el = tplOption();
	insert(el, createComponent(Icon, {
		get class() { return props.param.value == "RANDOM" ? "size-8 mr-3 ml-2" : "size-12 mr-1"; },
		get name() { return props.param.value == "RANDOM" ? "LEADER_RANDOM" : props.param.value; },
	}), null);
	insert(el, createComponent(L10n.Stylize, { get text() { return resolve(props.param.name); } }), null);
	return el;
};

const MementoOption = (props) => {
	const el = tplOption();
	if (props.param === RANDOM_OPTION) {
		insert(el, createComponent(Icon, { class: "size-8 mr-3 ml-2", name: "LEADER_RANDOM" }), null);
		insert(el, createComponent(L10n.Compose, { text: RANDOM_OPTION.name }), null);
		return el;
	}
	const icon = tplMementoIcon();
	createRenderEffect(() => {
		icon.style.backgroundImage = `url("fs://game/${resolve(props.param.icon) || MEMENTO_DEFAULT_ICON}")`;
	});
	el.appendChild(icon);
	insert(el, createComponent(L10n.Compose, { get text() { return props.param.value == MEMENTO_NONE_VALUE ? MEMENTO_NONE_NAME : resolve(props.param.name); } }), null);
	return el;
};

// Sorted, with each value listed once (the memento domain repeats its "none" entry).
function sortPossibleValues(possibleValues) {
	if (!possibleValues) return;
	const seen = new Set();
	return [...possibleValues]
		.filter((entry) => !seen.has(entry.value) && seen.add(entry.value))
		.sort((a, b) => {
			if (a.sortIndex != b.sortIndex) return a.sortIndex - b.sortIndex;
			return Locale.compare(Locale.compose(resolve(a.name)), Locale.compose(resolve(b.name)));
		});
}

// A row cell sized by the shared column proportions.
function column(index, child) {
	const el = tplColumn();
	el.style.flex = COLUMN_FLEX[index];
	insert(el, child);
	return el;
}

// A dropdown over a setup parameter, with the given option and tooltip components.
// `random` (optional) adds a Random item: { isRandom, setRandom }.
function parameterDropdown(param, option, tooltip, side, classes, random) {
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
			return createComponent(For, {
				get each() { return items(); },
				children: (value) => withTooltip(value, () => createComponent(DropdownItem, { value, get children() { return createComponent(option, { param: value }); } })),
			});
		},
	});
}

// ------------------------------------------------------ random mementos --

function randomFlags(playerId) {
	const value = GameSetup.findPlayerParameter(playerId, RANDOM_FLAG_PARAM_ID)?.value?.value;
	return RANDOM_FLAGS[value] ?? RANDOM_FLAGS.ZG_RANDOM_MEMENTOS_NONE;
}

function setRandomFlag(playerId, slotIndex, isRandom) {
	const flags = [...randomFlags(playerId)];
	flags[slotIndex] = isRandom;
	const value = Object.keys(RANDOM_FLAGS).find((key) => RANDOM_FLAGS[key].every((flag, i) => flag == flags[i]));
	GameSetup.setPlayerParameterValue(playerId, RANDOM_FLAG_PARAM_ID, value);
}

function rollMemento(playerId, slotIndex) {
	const param = GameSetup.findPlayerParameter(playerId, MEMENTO_PARAM_IDS[slotIndex]);
	const choices = (sortPossibleValues(param?.domain?.possibleValues) ?? []).filter((entry) => entry.value != MEMENTO_NONE_VALUE);
	if (choices.length > 0) {
		GameSetup.setPlayerParameterValue(playerId, MEMENTO_PARAM_IDS[slotIndex], choices[Math.floor(Math.random() * choices.length)].value);
	}
}

// Rolls every slot flagged Random once per game session, so each new game
// starts from a fresh pick while the choice itself is kept.
const rolledThisSession = new Set();
let lastRevision = -1;
setInterval(() => {
	const revision = GameSetup.currentRevision;
	if (revision == lastRevision) {
		return;
	}
	lastRevision = revision;
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
		["LOC_GENERIC_LEADER", "LOC_GENERIC_CIVILIZATION", ...MEMENTO_HEADERS].forEach((text, index) => {
			const cell = tplHeaderCell();
			cell.style.flex = COLUMN_FLEX[index];
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
		controls.appendChild(column(1, parameterDropdown(() => playerParam(slot, "PlayerCivilization"), PlayerOption, CivTooltip, TooltipHorizontalPosition.LEFT, "my-2 mx-2 flex-auto")));
		MEMENTO_PARAM_IDS.forEach((id, slotIndex) => {
			controls.appendChild(column(2 + slotIndex, createComponent(Show, {
				get when() { return !slot.isLocalPlayer && playerParam(slot, id)?.domain?.possibleValues?.length > 0; },
				get children() { return parameterDropdown(() => playerParam(slot, id), MementoOption, MementoTooltip, TooltipHorizontalPosition.LEFT, "my-2 ml-2 flex-auto", randomFor(slot, slotIndex)); },
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

const tabItem = ComponentRegistry.get("Tab.Item");
const createPreviousTabItem = tabItem?.factory;
if (createPreviousTabItem) {
	ComponentRegistry.register({
		name: "Tab.Item",
		overridePriority: OVERRIDE_PRIORITY,
		createInstance: (props) => {
			if (props.name != PLAYER_TAB_NAME) {
				return createPreviousTabItem(props);
			}
			return createPreviousTabItem(mergeProps(props, { body: () => createComponent(PlayerSetup, {}) }));
		},
	});
}
