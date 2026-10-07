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
		console.warn(`ZG-ASP setup: ${canEdit ? "editing" : "read-only"} (network ${!!game?.isNetworkMultiplayer}, host ${host}, local ${GameContext.localPlayerID})`);
	}
	return canEdit;
}
