// Wraps a component registered with the game's ui-next ComponentRegistry.
//
// `wrap` receives the factory registered so far and returns its replacement.
// That factory is read once, here, before this registration: `factory` is a
// signal accessor, so reading it later would return the wrapper itself.
// Returns whether the component was found to wrap.
import { ComponentRegistry } from 'fs://game/core/ui-next/services/component-registry.js';

// Override priorities: the screen's tabs and fields, then the Player tab and its
// memento model, which wrap what the screen's overrides registered.
export const SCREEN_OVERRIDE_PRIORITY = 100;
export const PLAYER_OVERRIDE_PRIORITY = 110;

export function zgWrapComponent(name, overridePriority, wrap) {
	const previous = ComponentRegistry.get(name)?.factory?.();
	if (!previous) {
		return false;
	}
	ComponentRegistry.register({ name, overridePriority, createInstance: wrap(previous) });
	return true;
}
