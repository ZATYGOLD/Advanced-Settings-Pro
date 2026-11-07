// What the shell is doing right now, for scripts that run throughout it.
//
// The mod's setup scripts poll GameSetup for as long as the shell is up, which
// covers single-player setup, every multiplayer and hotseat screen, and the
// shell that runs an age transition. They act only on a single-player setup:
// multiplayer settings come from Better Balanced Multiplayer, and an age transition
// is settled by ui/age-transition/.

import { isMultiplayer } from '../../shared/zg-config.js';

const isAgeTransition = () => Modding.getTransitionInProgress() == TransitionType.Age;

export const isSinglePlayerSetup = () => !isMultiplayer() && !isAgeTransition();

// One poll of the setup shared by every script that follows it, running only
// while something listens. onSetupPoll calls back on every poll; onSetupRevision
// only when the setup's revision has moved, with whether it went backwards (a
// fresh setup screen restarts the count). A revision passed while `ready` says
// no is held over until it says yes. Each returns its unsubscribe.
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
	return onSetupPoll(() => {
		const revision = GameSetup.currentRevision;
		if (revision == lastRevision || !ready()) {
			return;
		}
		const restarted = revision < lastRevision;
		lastRevision = revision;
		listener(restarted);
	});
}
