// Adds Ages and Map tabs to the single-player Advanced Settings screen.
//
// The screen hard-codes its General and Player tabs, so the tabs are injected
// through the game's own override mechanisms instead of replacing any file:
//   1. GameSetupParameterGroupsModel is wrapped so its groups are filtered by
//      whichever tab is currently rendering (unfiltered when none is).
//   2. Tab.Item is wrapped so the General item also emits one item per extra
//      tab, each rendering the same game-setup body, which then sees only that
//      tab's groups. General shows every group no extra tab claims.
//
// Every option row, the Player tab, and the multiplayer screen remain the
// game's own code.
import { createSignal, createComponent, mergeProps, onCleanup } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { ComponentRegistry } from 'fs://game/core/ui-next/services/component-registry.js';
import { ModelRegistry, ModelLifecycle } from 'fs://game/core/ui-next/services/model-registry.js';
import { L10n } from 'fs://game/core/ui-next/components/l10n.js';
import 'fs://game/core/ui-next/components/tab.js';
import 'fs://game/core/ui-next/screens/create-game/game-parameters-model.js';

const OVERRIDE_PRIORITY = 100;
const GENERAL_TAB_NAME = "advanced-options-general";

// Extra tabs, in display order, each claiming the parameter groups it shows.
const EXTRA_TABS = [
	{
		name: "zg-advanced-options-ages",
		title: "LOC_ZG_ADVANCED_OPTIONS_AGES",
		groups: new Set(["GamePacingOptions", "PacingAntiquityOptions", "PacingExplorationOptions", "PacingModernOptions"]),
	},
	{
		name: "zg-advanced-options-map",
		title: "LOC_ZG_ADVANCED_OPTIONS_MAP_SETTINGS",
		groups: new Set(["MapOptions", "DisasterOptions", "NaturalWonderSelectionOptions"]),
	},
];

// The tab whose body is rendering: an EXTRA_TABS entry, GENERAL_TAB_NAME, or null.
const [activeTab, setActiveTab] = createSignal(null);

function groupBelongsToTab(groupId, tab) {
	if (tab == null) return true;
	if (tab == GENERAL_TAB_NAME) return !EXTRA_TABS.some((extra) => extra.groups.has(groupId));
	return tab.groups.has(groupId);
}

// 1. Model facade: same groupNames, groups narrowed to the active tab.
//    The game's model is created only when first read, exactly as the game does
//    it: creating it at script load (before a game mode exists) would pull
//    multiplayer-only settings into single-player setup.
const groupsModel = ModelRegistry.get("GameSetupParameterGroupsModel");
const createBaseGroupsModel = groupsModel?.factory;
if (createBaseGroupsModel) {
	ModelRegistry.register("GameSetupParameterGroupsModel", ModelLifecycle.Singleton, () => {
		let base = null;
		const resolve = () => (base ??= createBaseGroupsModel());
		return {
			get groupNames() { return resolve().groupNames; },
			get groups() {
				const groups = resolve().groups;
				const tab = activeTab();
				const filtered = {};
				for (const groupId of Object.keys(groups)) {
					if (groupBelongsToTab(groupId, tab)) {
						filtered[groupId] = groups[groupId];
					}
				}
				return filtered;
			},
		};
	}, OVERRIDE_PRIORITY);
}

// 2. Tab.Item wrapper: General renders filtered, plus one sibling item per extra tab.
function tabBody(tab, body) {
	return () => {
		setActiveTab(tab);
		onCleanup(() => { if (activeTab() == tab) setActiveTab(null); });
		return body();
	};
}

const tabItem = ComponentRegistry.get("Tab.Item");
const createBaseTabItem = tabItem?.factory;
if (createBaseTabItem) {
	ComponentRegistry.register({
		name: "Tab.Item",
		overridePriority: OVERRIDE_PRIORITY,
		createInstance: (props) => {
			if (props.name != GENERAL_TAB_NAME || typeof props.body != "function") {
				return createBaseTabItem(props);
			}
			const body = props.body;
			return [
				createBaseTabItem(mergeProps(props, { body: tabBody(GENERAL_TAB_NAME, body) })),
				...EXTRA_TABS.map((tab) => createBaseTabItem({
					name: tab.name,
					title: () => createComponent(L10n.Compose, { text: tab.title }),
					body: tabBody(tab, body),
				})),
			];
		},
	});
}
