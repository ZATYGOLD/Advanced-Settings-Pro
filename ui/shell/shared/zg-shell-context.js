// What the shell is doing right now, for scripts that run throughout it.
//
// The mod's setup scripts poll GameSetup for as long as the shell is up, which
// covers single-player setup, every multiplayer and hotseat screen, and the
// shell that runs an age transition. They act only on a single-player setup:
// multiplayer settings come from Better Balanced Multiplayer, and an age transition
// is settled by ui/age-transition/.
import { ContextManager } from 'fs://game/core/ui/context-manager/context-manager.js';
import { isMultiplayer } from '../../shared/zg-config.js';

export const SETUP_SCREEN = "create-game-sp";

const isAgeTransition = () => Modding.getTransitionInProgress() == TransitionType.Age;

const isSinglePlayerSetup = () => !isMultiplayer() && !isAgeTransition();
// The single-player setup screen is open, not just a single-player configuration
// (the main menu's reset and Load Game write one too).
export const isSinglePlayerSetupOpen = () => ContextManager.hasInstanceOf(SETUP_SCREEN) && isSinglePlayerSetup();

// One poll of the setup shared by every script that follows it, running only
// while something listens. onSetupPoll calls back on every poll; onSetupRevision
// only when the setup's revision has moved, with whether this is a fresh start:
// the revision went backwards (a new setup restarts the count) or `ready` has
// just turned true. A revision passed while `ready` says no is held over until
// it says yes. Each returns its unsubscribe.
const SETUP_POLL_MS = 250;
const pollListeners = new Set();
let pollTimer = null;

export function onSetupPoll(listener) {
	pollListeners.add(listener);
	pollTimer ??= setInterval(() => pollListeners.forEach((poll) => {
		try {
			poll();
		} catch (error) {
			console.error(`ZG-ASP setup poll: ${error}`);
		}
	}), SETUP_POLL_MS);
	return () => {
		pollListeners.delete(listener);
		if (pollListeners.size == 0) {
			clearInterval(pollTimer);
			pollTimer = null;
		}
	};
}

export function onSetupRevision(listener, ready = () => true) {
	let lastRevision = -1;
	let wasReady = false;
	return onSetupPoll(() => {
		if (!ready()) {
			wasReady = false;
			return;
		}
		const revision = GameSetup.currentRevision;
		const restarted = !wasReady || revision < lastRevision;
		if (revision == lastRevision && !restarted) {
			return;
		}
		wasReady = true;
		lastRevision = revision;
		listener(restarted);
	});
}
