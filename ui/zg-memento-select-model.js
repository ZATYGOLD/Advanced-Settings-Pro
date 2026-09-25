// The memento picker's model, made to open for any player.
//
// The Overview screen's picker, the one with the search bar and attribute
// filter, is the memento-select screen of the create-game flow. It is driven by
// MementoSelectModel, which the base game builds around GameContext.localPlayerID
// in five places: it reads the human's slot parameters, and every equip writes
// back to the human. The Player tab wants that same screen for each AI row.
//
// This is a copy of the base createMementoModel with one substitution: the
// player it reads and writes is a target, which starts as the human and is
// moved by the model's retarget(playerId) as ui/zg-memento-select.js opens the
// picker. The model refreshes its slots through the same reconcile the base
// runs after an equip, so the screen shows the target's mementos.
//
// Registered over the base model at the priority the Player tab already uses
// for its own overrides; ComponentRegistry and ModelRegistry both resolve the
// higher priority, and the create-game screen picks the model up through the
// registry. Everything not to do with the player is the base code, so re-sync
// this copy after a patch that changes memento-select-model.js.
import { createSignal } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { createMutable, modifyMutable, reconcile } from 'fs://game/core/vendor/solid-js/store/dist/store.js';
import { ModelRegistry, ModelLifecycle } from 'fs://game/core/ui-next/services/model-registry.js';
import { FullTextSearch } from 'fs://game/core/ui-next/utilities/search-utils.js';
import { MEMENTO_NONE_VALUE as NONE_VALUE } from './zg-memento-roller.js';

const OVERRIDE_PRIORITY = 110;
const MODEL_NAME = "MementoSelectModel";

const funcDescName = GameSetup.findString("FunctionalDescription");

function resolveMemento(value, mementoData) {
	const funcDescProp = value.additionalProperties?.find((v) => v.name === funcDescName);
	const metadata = mementoData.find((m) => m.mementoTypeId == value.value);
	return {
		value: value.value.toString(),
		name: GameSetup.resolveString(value.name),
		description: GameSetup.resolveString(value.description),
		functionalDescription: funcDescProp?.value,
		icon: GameSetup.resolveString(value.icon),
		isFavorite: metadata?.isFavorite ?? false,
		isNew: metadata?.isNewAndUnseenByPlayer ?? false,
		isLocked: metadata?.displayType == DisplayType.DISPLAY_LOCKED,
		unlockTitle: metadata?.unlockTitle ?? "",
		unlockReason: metadata?.unlockReason ?? "",
	};
}

// The instance the create-game screen is using. PerInstance means .get() would
// build a fresh model rather than reach this one, so the factory records it.
let activeModel = null;

function createMementoModel() {
	const isAgeTransition = UI.isInGame();
	const mementos = Online.Metaprogression.getMementosData();
	let targetPlayer = GameContext.localPlayerID;
	const mementoSlots = getMementoSlotInfo();
	const mutableMementos = createMutable(mementoSlots);
	const [selectedSlot, setSelectedSlot] = createSignal(0);

	function getMementoSlotInfo() {
		const mementoSlotParameters = GameSetup.getMementoFilteredPlayerParameters(targetPlayer);
		const mementoPlayerParameters = GameSetup.getPlayerParameters(targetPlayer);
		const mementoSlotMetadata = Online.Metaprogression.getMementoSlotData();
		const mementoData = [];
		for (const mementoSlotParam of mementoSlotParameters) {
			if (!mementoSlotParam.hidden && mementoSlotParam.invalidReason == GameSetupParameterInvalidReason.Valid) {
				const paramId = GameSetup.resolveString(mementoSlotParam.ID);
				const metadata = mementoSlotMetadata.find((m) => m.mementoTypeId == paramId);
				if (metadata) {
					const isLocked = metadata.displayType == DisplayType.DISPLAY_LOCKED;
					const isMajor = paramId?.startsWith("PlayerMementoMajorSlot");
					const paramName = GameSetup.resolveString(mementoSlotParam.ID) ?? "";
					const resolvedParamName = isAgeTransition ? `AgeTransition${paramName}` : paramName;
					const resolvedParam = mementoPlayerParameters.find((p) => GameSetup.resolveString(p.ID) == resolvedParamName) ?? mementoSlotParam;
					mementoData.push({
						gameParameter: resolvedParamName,
						slotType: isMajor ? 0 : 1,
						isLocked,
						unlockReason: metadata.unlockTitle,
						currentMemento: resolveMemento(resolvedParam.value, mementos),
						availableMementos: isLocked ? [] : resolvedParam.domain.possibleValues.map((v) => resolveMemento(v, mementos)),
						hotkey: mementoData.length == 0 ? "nav-previous" : "nav-next",
					});
				} else {
					console.log(`Unable to find memento slot metadata for ${paramId}`);
				}
			}
		}
		return mementoData;
	}

	const refreshSlots = () => modifyMutable(mutableMementos, reconcile(getMementoSlotInfo()));

	function clearNew(memento) {
		if (memento.isNewAndUnseenByPlayer) {
			Online.Metaprogression.setSeenMemento(memento.mementoTypeId);
		}
	}
	function clearAllNew() {
		for (const memento of mementos) {
			clearNew(memento);
		}
	}

	const equipMemento = (memento) => {
		const slotParameter = mutableMementos[selectedSlot()].gameParameter;
		if (memento.mementoTypeId == mutableMementos[selectedSlot()].currentMemento.value) {
			GameSetup.setPlayerParameterValue(targetPlayer, slotParameter, NONE_VALUE);
		} else {
			for (const mementoSlot of mutableMementos) {
				if (mementoSlot.currentMemento.value == memento.mementoTypeId) {
					GameSetup.setPlayerParameterValue(targetPlayer, mementoSlot.gameParameter, NONE_VALUE);
				}
			}
			GameSetup.setPlayerParameterValue(targetPlayer, slotParameter, memento.mementoTypeId);
		}
		clearNew(memento);
		memento.isNewAndUnseenByPlayer = false;
		refreshSlots();
		const nextEmptySlot = mementoSlots.findIndex(
			(s, i) => i != selectedSlot() && !s.isLocked && s.currentMemento.value == NONE_VALUE
		);
		if (nextEmptySlot >= 0) {
			setSelectedSlot(nextEmptySlot);
		}
	};

	// Moves the model onto another player. Slots are rebuilt from that player's
	// parameters and the selection returns to the first slot, so the screen opens
	// the way it does for the human.
	const retarget = (playerId, slotIndex = 0) => {
		targetPlayer = playerId ?? GameContext.localPlayerID;
		refreshSlots();
		setSelectedSlot(Math.max(0, Math.min(slotIndex, mutableMementos.length - 1)));
		console.warn(`ZG-ASP mementos: picker targeting player ${targetPlayer}`);
	};

	const yieldIconPattern = /\[icon:(YIELD_(?:FOOD|PRODUCTION|GOLD|SCIENCE|CULTURE|HAPPINESS|DIPLOMACY))\]/g;
	const search = new FullTextSearch("MementoSelectFilter");
	search.addSearchData(
		mementos.map((m) => {
			const functionalTextDesc = Locale.plainText(
				Locale.compose(Locale.compose(m.functionalTextDesc).replaceAll(yieldIconPattern, "{LOC_$1_NAME}"))
			);
			return {
				key: m.mementoTypeId,
				title: Locale.plainText(m.mementoName),
				fullText: Locale.toLower(`${Locale.plainText(functionalTextDesc)}`),
			};
		})
	);
	const fulltextSearch = (text) => search.find(text);

	activeModel = {
		slots: mutableMementos,
		mementos,
		selectedSlot,
		setSelectedSlot,
		equipMemento,
		clearAllNew,
		fulltextSearch,
		retarget,
		get targetPlayer() { return targetPlayer; },
	};
	return activeModel;
}

ModelRegistry.register(MODEL_NAME, ModelLifecycle.PerInstance, createMementoModel, OVERRIDE_PRIORITY);

// The model the create-game screen built, when one exists this session. The
// picker reuses it rather than building a second, so the Overview's own memento
// display follows every change made through the picker.
export const currentMementoModel = () => activeModel;
