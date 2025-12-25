import { i } from "/core/ui/shell/mp-staging/model-mp-staging-new.chunk.js";

Object.defineProperty(i, 'canEditMementos', {
    configurable: true,
    enumerable: true,
    get() {
      return !i.isLocalPlayerReady;
    }
  });
