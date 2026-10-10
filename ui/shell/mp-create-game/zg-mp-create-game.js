// The single-player tab layout, and the seed Random buttons, on the multiplayer
// Create Game screen (screen-mp-create-game): General, Pace, Map and Add-Ons,
// with the game's Advanced tab folded into General.
//
// A decorator is built after the panel's constructor and before onInitialize,
// which builds the tabs from the index-aligned `navControlButtonInfo` and
// `slotIDs`, so both are reshaped here. Groups are routed to tabs through
// getTabContainerForParam; the seed buttons hang off createParamEleLabel.

import { Decorator } from '../shared/zg-shell-context.js';

const PANEL_NAME = "screen-mp-create-game";
const SEED_PARAM_IDS = new Set(["GameRandomSeed", "MapRandomSeed"]);
const MAX_SEED = 2 ** 31 - 1;
const RANDOM_TEXT = "LOC_ADVANCED_OPTIONS_RANDOM";
// The screen's tabs: Game Settings first, Advanced second, Add-Ons last.
const ADVANCED_INDEX = 1;
const ADVANCED_PANEL_ID = "advanced-setup-mp__advanced";
const ADDONS_PANEL_ID = "advanced-setup-mp__add-ons";
const GENERAL_CONTAINER = ".advanced-setup__game-options-container";
const MP_ADVANCED_PREFIX = "MPAdvanced";
// The screen's tab buttons carry a 16.7rem minimum width, sized for its three
// tabs; four fit at less.
const NAV_BUTTON_MIN_WIDTH = "11rem";
// The button's frame is a nine-slice image whose ends are 5.33rem each, drawn
// for the 16.7rem button; at 11rem the ends meet and leave a seam down the
// middle, so they are scaled with the width.
const NAV_BUTTON_BORDER_WIDTH = "0.8889rem 3.5rem 2rem 3.5rem";
// A row-height Random button beside the seed field, rather than the full-size
// fxs-button (min-h-11.5, text-base, px-4).
const SEED_BUTTON_STYLE = { width: "7rem", minWidth: "0", minHeight: "2rem", padding: "0", fontSize: "0.75rem", flex: "0 0 auto" };

// Multiplayer resolves a parameter's group to its GroupIDMultiplayerOverride
// when it has one, so these are the "MPAdvanced" ids of the groups the
// single-player tabs hold. Map, Map Size and Start Position are moved onto
// MPAdvancedMapOptions, and the crisis settings onto their own
// MPAdvancedCrisisOptions, in config/setup-parameters.sql.
// A setting with no override keeps its single-player group, as the settings a
// map script adds usually do (GroupId MapOptions), so each tab claims the
// single-player ids too.
const TABS = [
	{
		id: "zg-advanced-setup-mp__pace",
		title: "LOC_ZG_ADVANCED_OPTIONS_AGES",
		containerClass: "zg-advanced-setup__mp-pace-container",
		groups: new Set([
			"MPAdvancedGamePacingOptions", "MPAdvancedPacingAntiquityOptions", "MPAdvancedPacingExplorationOptions", "MPAdvancedPacingModernOptions",
			"GamePacingOptions", "PacingAntiquityOptions", "PacingExplorationOptions", "PacingModernOptions",
		]),
	},
	{
		id: "zg-advanced-setup-mp__map",
		title: "LOC_ZG_ADVANCED_OPTIONS_MAP_SETTINGS",
		containerClass: "zg-advanced-setup__mp-map-container",
		groups: new Set([
			"MPAdvancedMapOptions", "MPAdvancedTerrainOptions", "MPAdvancedDisasterOptions", "MPAdvancedNaturalWonderSelectionOptions",
			"MapOptions", "TerrainOptions", "DisasterOptions", "NaturalWonderSelectionOptions",
		]),
	},
];

const randomSeed = () => 1 + Math.floor(Math.random() * (MAX_SEED - 1));

// The same shape as the screen's own createGameSetupPanel.
function createPanel(tab) {
	const panel = document.createElement("fxs-vslot");
	panel.classList.add("flex", "flex-col");
	panel.id = tab.id;
	const scrollable = document.createElement("fxs-scrollable");
	scrollable.classList.add("flex-auto");
	scrollable.setAttribute("allow-mouse-panning", "true");
	panel.appendChild(scrollable);
	const container = document.createElement("div");
	container.classList.add(tab.containerClass, "flex-auto", "mx-8");
	scrollable.appendChild(container);
	return panel;
}

function seedButton(parameterId) {
	const button = document.createElement("fxs-button");
	button.classList.add("mr-4");
	Object.assign(button.style, SEED_BUTTON_STYLE);
	button.setAttribute("caption", RANDOM_TEXT);
	button.addEventListener("action-activate", () => GameSetup.setGameParameterValue(parameterId, randomSeed()));
	return button;
}

class MpCreateGameLayout extends Decorator {
	constructor(component) {
		super();
		this.component = component;
		this.panels = TABS.map(createPanel);
		this.reshapeTabs();
		this.fitNavButtons();
		this.routeGroups();
		this.addSeedButtons();
	}

	// Advanced out, Pace and Map in its place.
	reshapeTabs() {
		const component = this.component;
		component.slotIDs.splice(ADVANCED_INDEX, 1, ...TABS.map((tab) => tab.id));
		component.navControlButtonInfo.splice(ADVANCED_INDEX, 1, ...TABS.map((tab, index) => ({
			category: tab.title,
			isActive: false,
			eventHandler: () => component.goToNewPanel(this.panels[index]),
		})));
		for (const panel of this.panels) {
			component.setupSlotGroup.appendChild(panel);
		}
		// These read slotIDs[1] and slotIDs[2], which now name the tabs above.
		const createAdvancedPanel = component.createAdvancedPanel.bind(component);
		component.createAdvancedPanel = () => {
			createAdvancedPanel();
			component.mpAdvancedSetupPanel.id = ADVANCED_PANEL_ID;
		};
		const createAddOnsPanel = component.createAddOnsPanel.bind(component);
		component.createAddOnsPanel = () => {
			createAddOnsPanel();
			component.addOnsSetupPanel.id = ADDONS_PANEL_ID;
		};
	}

	fitNavButtons() {
		const component = this.component;
		const createTopNav = component.createTopNav.bind(component);
		component.createTopNav = () => {
			const nav = createTopNav();
			for (const button of component.navControlTabs) {
				button.style.minWidth = NAV_BUTTON_MIN_WIDTH;
				button.style.borderImageWidth = NAV_BUTTON_BORDER_WIDTH;
			}
			return nav;
		};
	}

	// Pace and Map take their groups; the other "MPAdvanced" groups go to General;
	// anything else keeps the screen's own answer, which is how the game's unlisted
	// Legacy Paths group stays out of sight.
	routeGroups() {
		const component = this.component;
		const getTabContainerForParam = component.getTabContainerForParam.bind(component);
		component.getTabContainerForParam = (param) => {
			const groupId = GameSetup.resolveString(component.resolveParamGroup(param)) ?? "";
			const index = TABS.findIndex((tab) => tab.groups.has(groupId));
			if (index >= 0) {
				return this.panels[index].querySelector(`.${TABS[index].containerClass}`);
			}
			return groupId.startsWith(MP_ADVANCED_PREFIX) ? component.Root.querySelector(GENERAL_CONTAINER) : getTabContainerForParam(param);
		};
	}

	addSeedButtons() {
		const component = this.component;
		const createParamEleLabel = component.createParamEleLabel.bind(component);
		component.createParamEleLabel = (setupParam, paramEle) => {
			const row = createParamEleLabel(setupParam, paramEle);
			const parameterId = GameSetup.resolveString(setupParam.ID);
			if (SEED_PARAM_IDS.has(parameterId) && !setupParam.readOnly) {
				row.appendChild(seedButton(parameterId));
			}
			return row;
		};
	}
}

Controls.decorate(PANEL_NAME, (component) => new MpCreateGameLayout(component));
