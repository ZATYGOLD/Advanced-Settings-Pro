// Adds Pace and Map tabs to the single-player Advanced Settings screen.
//
// The screen hard-codes its General and Player tabs, so the tabs are injected
// through the game's own override mechanisms instead of replacing any file:
//   1. GameSetupParameterGroupsModel is wrapped so its groups are filtered by
//      whichever tab is currently rendering (unfiltered when none is).
//   2. Tab.Item is wrapped so the General item also emits one item per extra
//      tab, each rendering the same game-setup body, which then sees only that
//      tab's groups. General shows every group no extra tab claims.
//
// Every option row and the Player tab remain the game's own code. Multiplayer
// and hotseat set up through the older shell screens, which this never touches.
import { createSignal, createComponent, mergeProps, onCleanup } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { ModelRegistry, ModelLifecycle } from 'fs://game/core/ui-next/services/model-registry.js';
import { L10n } from 'fs://game/core/ui-next/components/l10n.js';
import 'fs://game/core/ui-next/components/tab.js';
import 'fs://game/core/ui-next/screens/create-game/game-parameters-model.js';
import { SCREEN_OVERRIDE_PRIORITY, zgWrapComponent } from './zg-component-override.js';

const GENERAL_TAB_NAME = "advanced-options-general";

// The extra tabs, in display order, each claiming the parameter groups it shows;
// General keeps every group no extra tab claims.
const EXTRA_TABS = [
	{
		name: "zg-advanced-options-pace",
		title: "LOC_ZG_ADVANCED_OPTIONS_AGES",
		groups: new Set(["ZG_GamePacingOptions", "ZG_PacingAntiquityOptions", "ZG_PacingExplorationOptions", "ZG_PacingModernOptions"]),
	},
	{
		name: "zg-advanced-options-map",
		title: "LOC_ZG_ADVANCED_OPTIONS_MAP_SETTINGS",
		groups: new Set(["ZG_SpawnOptions", "MapOptions", "ZG_ClimateControlOptions", "ZG_TerrainOptions", "DisasterOptions", "ZG_NaturalWonderSelectionOptions"]),
	},
];

// The tab whose body is rendering: an EXTRA_TABS entry, GENERAL_TAB_NAME, or null.
const [activeTab, setActiveTab] = createSignal(null);

function groupBelongsToTab(groupId, tab) {
	if (tab == null) return true;
	if (tab == GENERAL_TAB_NAME) return !EXTRA_TABS.some((extra) => extra.groups.has(groupId));
	return tab.groups.has(groupId);
}

// The game's model is one store for the whole shell session and only ever adds
// to it: a setting that exists in one game mode and not the next (the lobby's
// Game Name after a multiplayer setup, say) stays in its group, still marked
// visible, once single-player setup opens. Only settings GameSetup still knows
// are passed through.
//
// The view is live, not a copy: a screen may keep a group it read once and
// expect it to update as settings come and go (a map script's own settings
// appearing when that map is picked, say), and a copy would freeze it. Reading
// keys through the view reads the game's store, so it tracks as the store does.
const presentViews = new WeakMap();
const isPresent = (key) => key == "name" || typeof key != "string" || !!GameSetup.findGameParameter(key);

function presentOnly(group) {
	let view = presentViews.get(group);
	if (!view) {
		view = new Proxy(group, {
			ownKeys: (target) => Reflect.ownKeys(target).filter(isPresent),
			getOwnPropertyDescriptor: (target, key) => (isPresent(key) ? Reflect.getOwnPropertyDescriptor(target, key) : undefined),
			has: (target, key) => isPresent(key) && Reflect.has(target, key),
		});
		presentViews.set(group, view);
	}
	return view;
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
						filtered[groupId] = presentOnly(groups[groupId]);
					}
				}
				return filtered;
			},
		};
	}, SCREEN_OVERRIDE_PRIORITY);
}

// 2. Tab.Item wrapper: General renders filtered, plus one sibling item per extra tab.
function tabBody(tab, body) {
	return () => {
		setActiveTab(tab);
		onCleanup(() => { if (activeTab() == tab) setActiveTab(null); });
		return body();
	};
}

zgWrapComponent("Tab.Item", SCREEN_OVERRIDE_PRIORITY, (createBaseTabItem) => (props) => {
	if (props?.name != GENERAL_TAB_NAME || typeof props?.body != "function") {
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
});
