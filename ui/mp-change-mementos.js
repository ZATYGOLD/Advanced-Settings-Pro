import { i } from "/core/ui/shell/mp-staging/model-mp-staging-new.chunk.js";

const parameterID = "ZG_ChangeMementos"; 

const desc = Object.getOwnPropertyDescriptor(i, 'canEditMementos');
const baseGet = desc?.get?.bind(i);

// Read the game-setup parameter
function isChangeMementosEnabled() {
  try {
    const parameter = GameSetup.findGameParameter(parameterID);
    const defaultValue = parameter.value.default;
    // if (parameter.domain.possibleValues) {

    // }
  // GameSetup.setGameParameterValue(parameter.ID, newValues)
    if (defaultValue) {
      return true;
    }

    const handle = GameSetup.makeString("ChangeMementosKey");
    const p = GameSetup.findGameParameter(handle);
    return p?.value?.value === "ZG_ENABLE_CHANGE_MEMENTOS";
  } catch (_) {}

  return false;
}

Object.defineProperty(i, 'canEditMementos', {
    configurable: true,
    enumerable: true,
    get() {
      const base = baseGet ? baseGet() : false;

      return isChangeMementosEnabled() ? !i.isLocalPlayerReady : base;
    }
  });
