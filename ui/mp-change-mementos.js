import { i } from "/core/ui/shell/mp-staging/model-mp-staging-new.chunk.js";

//const descriptor = Object.getOwnPropertyDescriptor(i, 'canEditMementos');
//const originalFunction = descriptor?.get?.bind(i);

Object.defineProperty(i, 'canEditMementos', {
    configurable: true,
    enumerable: true,
    get() {
      return !i.isLocalPlayerReady;
    }
  });
