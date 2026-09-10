// Adds a Map tab to the single-player Advanced Settings screen.
//
// The screen hard-codes its General and Player tabs, so the tab is injected
// through the game's own override mechanisms instead of replacing any file:
//   1. GameSetupParameterGroupsModel is wrapped so its groups are filtered by
//      whichever tab is currently rendering (unfiltered when neither is).
//   2. Tab.Item is wrapped so the General item also emits a Map item that
//      renders the same game-setup body, which then sees only the map groups.
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
const MAP_TAB_NAME = "zg-advanced-options-map";
const MAP_TAB_TITLE = "LOC_ZG_ADVANCED_OPTIONS_MAP_SETTINGS";

// Parameter groups shown on the Map tab; everything else stays on General.
const MAP_GROUP_IDS = new Set([
	"MapOptions",
	"DisasterOptions",
	"NaturalWonderSelectionOptions",
]);

const TAB_GENERAL = "general";
const TAB_MAP = "map";
const [activeTab, setActiveTab] = createSignal(null);

function groupBelongsToTab(groupId, tab) {
	return tab == null || MAP_GROUP_IDS.has(groupId) == (tab == TAB_MAP);
}

// 1. Model facade: same groupNames, groups narrowed to the active tab.
const groupsModel = ModelRegistry.get("GameSetupParameterGroupsModel");
const createBaseGroupsModel = groupsModel?.factory;
if (createBaseGroupsModel) {
	ModelRegistry.register("GameSetupParameterGroupsModel", ModelLifecycle.Singleton, () => {
		const base = createBaseGroupsModel();
		return {
			get groupNames() { return base.groupNames; },
			get groups() {
				const tab = activeTab();
				const filtered = {};
				for (const groupId of Object.keys(base.groups)) {
					if (groupBelongsToTab(groupId, tab)) {
						filtered[groupId] = base.groups[groupId];
					}
				}
				return filtered;
			},
		};
	}, OVERRIDE_PRIORITY);
}

// 2. Tab.Item wrapper: General renders filtered, plus a sibling Map item.
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
				createBaseTabItem(mergeProps(props, { body: tabBody(TAB_GENERAL, body) })),
				createBaseTabItem({
					name: MAP_TAB_NAME,
					title: () => createComponent(L10n.Compose, { text: MAP_TAB_TITLE }),
					body: tabBody(TAB_MAP, body),
				}),
			];
		},
	});
}
