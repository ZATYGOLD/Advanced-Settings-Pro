// Memento draws shared by the Player tab and the age transition.
//
// Two settings hand out mementos: the per-player Random flag behind a slot's
// Random entry, and Game Settings' AI Mementos, which fills every AI player's
// slots by one rule (at random, or matched to the attributes of the player's
// leader or civilization). The Player tab applies both while a game is set up;
// zg-age-transition-mementos.js applies AI Mementos again when an age turns
// over and Age Transition AI Mementos says to. This module holds the pieces
// both need and nothing about either screen.

export const MEMENTO_PARAM_IDS = ["PlayerMementoMajorSlot", "PlayerMementoMinorSlot1"];
export const MEMENTO_NONE_VALUE = "NONE";
// A memento slot's empty look, shared by every screen that draws one.
export const MEMENTO_SLOT_BASE_IMAGE = "url('blp:memento_slot-base.png')";
export const MEMENTO_SLOT_PLUS_IMAGE = "url('blp:shell_memento-maj-plus.png')";
// Random is not a memento the game knows: the mod keeps a per-player flag and
// rolls a real memento into the slot, once per game session.
export const RANDOM_FLAG_PARAM_ID = "ZG_PlayerRandomMementos";
export const RANDOM_FLAGS = { ZG_RANDOM_MEMENTOS_NONE: [false, false], ZG_RANDOM_MEMENTOS_MAJOR: [true, false], ZG_RANDOM_MEMENTOS_MINOR: [false, true], ZG_RANDOM_MEMENTOS_BOTH: [true, true] };
// Game Settings' AI Mementos, which fills every AI player's slots at once.
export const AI_MEMENTOS_PARAM_ID = "ZG_AIMementos";
export const AI_MEMENTOS_DEFAULT = "ZG_AI_MEMENTOS_NONE";
const TRAIT_PREFIX = "TAG_TRAIT_";
const ATTRIBUTE_PREFIX = "LOC_ATTRIBUTE_";
// Leaders and civilizations call the diplomatic attribute "political"; mementos
// call it "diplomatic". Every other attribute is named the same on both sides.
const ATTRIBUTE_ALIASES = { POLITICAL: "DIPLOMATIC" };

const resolve = (handle) => GameSetup.resolveString(handle) ?? "";

// Sorted, with each value listed once (the memento domain repeats its "none" entry).
export function sortPossibleValues(possibleValues) {
	if (!possibleValues) return;
	const seen = new Set();
	return [...possibleValues]
		.filter((entry) => !seen.has(entry.value) && seen.add(entry.value))
		.sort((a, b) => {
			if (a.sortIndex != b.sortIndex) return a.sortIndex - b.sortIndex;
			return Locale.compare(Locale.compose(resolve(a.name)), Locale.compose(resolve(b.name)));
		});
}

// ------------------------------------------------------ random mementos --

export function randomFlags(playerId) {
	const value = GameSetup.findPlayerParameter(playerId, RANDOM_FLAG_PARAM_ID)?.value?.value;
	return RANDOM_FLAGS[value] ?? RANDOM_FLAGS.ZG_RANDOM_MEMENTOS_NONE;
}

export function setRandomFlag(playerId, slotIndex, isRandom) {
	const flags = [...randomFlags(playerId)];
	flags[slotIndex] = isRandom;
	const value = Object.keys(RANDOM_FLAGS).find((key) => RANDOM_FLAGS[key].every((flag, i) => flag == flags[i]));
	GameSetup.setPlayerParameterValue(playerId, RANDOM_FLAG_PARAM_ID, value);
}

// Draws a memento at random into one slot, from the slot's own choices so that
// only mementos the player has actually unlocked are picked. An attribute, when
// given, narrows the draw to the mementos carrying it; a slot with none of them
// falls back to the unrestricted draw rather than staying empty.
export function rollMemento(playerId, slotIndex, attribute) {
	const param = GameSetup.findPlayerParameter(playerId, MEMENTO_PARAM_IDS[slotIndex]);
	const choices = (sortPossibleValues(param?.domain?.possibleValues) ?? []).filter((entry) => entry.value != MEMENTO_NONE_VALUE);
	const matching = attribute ? choices.filter((entry) => mementoAttributes().get(entry.value) == attribute) : [];
	const pool = matching.length > 0 ? matching : choices;
	if (pool.length > 0) {
		GameSetup.setPlayerParameterValue(playerId, MEMENTO_PARAM_IDS[slotIndex], pool[Math.floor(Math.random() * pool.length)].value);
	}
}

// --------------------------------------------------------- AI mementos --

// The configuration database does not change while the shell is open, so each
// lookup below is built on first use and kept.
function cached(build) {
	let value;
	return () => (value ??= build());
}

function query(sql) {
	try {
		return Database.query("config", sql) ?? [];
	} catch (error) {
		console.error(`ZG-ASP mementos: query failed: ${error}`);
		return [];
	}
}

function attributeOf(tagType) {
	const name = tagType.slice(TRAIT_PREFIX.length);
	return ATTRIBUTE_PREFIX + (ATTRIBUTE_ALIASES[name] ?? name);
}

// Leader or civilization type to its attributes, in the order the game lists
// them; every leader and civilization carries exactly two.
function groupAttributes(rows, column) {
	const out = new Map();
	for (const row of rows) {
		if (!row.TagType?.startsWith(TRAIT_PREFIX)) {
			continue;
		}
		const attributes = out.get(row[column]) ?? [];
		const attribute = attributeOf(row.TagType);
		if (!attributes.includes(attribute)) {
			attributes.push(attribute);
		}
		out.set(row[column], attributes);
	}
	return out;
}

// Memento type to the attribute it carries.
const mementoAttributes = cached(() => new Map(query("SELECT Type, Tag FROM Mementos").map((row) => [row.Type, row.Tag])));
const leaderAttributes = cached(() => groupAttributes(query("SELECT LeaderType, TagType FROM LeaderTags"), "LeaderType"));
const civilizationAttributes = cached(() => groupAttributes(query("SELECT CivilizationType, TagType FROM CivilizationTags"), "CivilizationType"));

// `random` leaves the slots on the Random flag so they roll again each session.
// A match mode names the player parameter it reads and the attributes for that
// parameter's value; each slot draws from the attribute in its own position.
const AI_MEMENTO_MODES = {
	ZG_AI_MEMENTOS_NONE: {},
	ZG_AI_MEMENTOS_RANDOM: { random: true },
	ZG_AI_MEMENTOS_LEADER: { sourceId: "PlayerLeader", attributes: leaderAttributes },
	ZG_AI_MEMENTOS_CIVILIZATION: { sourceId: "PlayerCivilization", attributes: civilizationAttributes },
};

// The rule AI Mementos currently names.
export const aiMementoMode = () => AI_MEMENTO_MODES[GameSetup.findGameParameter(AI_MEMENTOS_PARAM_ID)?.value?.value] ?? AI_MEMENTO_MODES[AI_MEMENTOS_DEFAULT];

// The AI players: every participating slot held by the computer. Humans are
// left alone, the local player and, in multiplayer, everyone who has joined.
export function aiPlayerIds() {
	return (Configuration.getGame()?.participatingPlayerIDs ?? []).filter((playerId) => Configuration.getPlayer(playerId)?.isAI === true);
}

export const matchSource = (mode, playerId) => (mode.sourceId ? GameSetup.findPlayerParameter(playerId, mode.sourceId)?.value?.value : null);

// Draws both of a player's slots by a rule. Random draws freely; a match mode
// draws each slot from the attribute in its position. None draws nothing and
// leaves the slots as they are. Returns whether anything was drawn.
export function drawMementos(mode, playerId) {
	if (!mode.random && !mode.sourceId) {
		return false;
	}
	const attributes = mode.attributes?.().get(matchSource(mode, playerId)) ?? [];
	MEMENTO_PARAM_IDS.forEach((id, slotIndex) => rollMemento(playerId, slotIndex, mode.random ? undefined : attributes[slotIndex]));
	return true;
}
