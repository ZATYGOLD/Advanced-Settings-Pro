// What the shell is doing right now, for scripts that run throughout it.
//
// The mod's setup scripts poll GameSetup for as long as the shell is up, which
// covers single-player setup, the multiplayer Create Game screen, the lobby a
// client has joined, and the shell that runs an age transition. Two questions
// decide whether a script should act:
//   canEditSetup   only the host writes setup parameters in multiplayer; a
//                  joined client sees every change arrive and must not answer
//                  it with writes of its own. Outside multiplayer, always.
//   isAgeTransition the shell is between ages rather than setting up a game.
//
// "A joined client" is read narrowly: a network game with a host on record who
// is someone else. The multiplayer Create Game screen already counts as a
// network game while no session exists yet and no host is recorded, and the
// one setting the game up there must be able to edit it.

export const isAgeTransition = () => Modding.getTransitionInProgress() == TransitionType.Age;

let lastCanEdit = null;

export function canEditSetup() {
	const game = Configuration.getGame();
	const host = Network.getHostPlayerId();
	const canEdit = !game?.isNetworkMultiplayer || !(host >= 0) || host == GameContext.localPlayerID;
	if (canEdit !== lastCanEdit) {
		lastCanEdit = canEdit;
		console.log(`ZG-ASP setup: ${canEdit ? "editing" : "read-only"} (network ${!!game?.isNetworkMultiplayer}, host ${host}, local ${GameContext.localPlayerID})`);
	}
	return canEdit;
}

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

// Base for Controls.decorate decorators: the panel calls all four hooks, so a
// decorator overrides only the ones it uses.
export class Decorator {
	beforeAttach() {}
	afterAttach() {}
	beforeDetach() {}
	afterDetach() {}
}
