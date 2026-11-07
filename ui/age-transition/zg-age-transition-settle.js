// Settles the AI for the age being entered, in order:
//   1. civilizations  (AI Civ Selection, Age Transition: Historical)
//   2. mementos       (Age Transition AI Mementos)
// Civilizations go first so a Civilization Match memento draw sees the new one.
// Shared by the shell and in-game hooks, which name the slots to write and the
// civilization the human picked, so no AI takes it while another is free; each
// hook settles once per transition. Multiplayer is left to the game. An error
// here is logged rather than allowed to stop the game from starting the age.
import { isMultiplayer } from '../shared/zg-config.js';
import { aiPlayerIds } from '../shared/zg-memento-roller.js';
import { isHistoricalProgression, settleAiCivilizations } from './zg-age-transition-civs.js';
import { settleAiMementos } from './zg-age-transition-mementos.js';

const LOG_PREFIX = "ZG-ASP age transition:";

// The configuration also seats the independent powers between ages; only major
// civilizations transition.
const transitionAiPlayerIds = () => aiPlayerIds().filter((playerId) =>
	Configuration.getPlayer(playerId)?.civilizationLevelTypeID == CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV);

export function settleAiPlayers(ageType, slots, humanCiv) {
	if (!ageType || isMultiplayer()) {
		return;
	}
	try {
		const players = transitionAiPlayerIds();
		console.log(`${LOG_PREFIX} settling ${players.length} AI for ${ageType} (human ${humanCiv})`);
		if (isHistoricalProgression()) {
			settleAiCivilizations(players, new Set([humanCiv]), ageType, slots);
		}
		settleAiMementos(players, slots);
	} catch (error) {
		console.error(`${LOG_PREFIX} ${error}`);
	}
}
