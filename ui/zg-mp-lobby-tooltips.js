// Fuller civilization and leader tooltips in the multiplayer lobby.
//
// The lobby builds both tooltips in MPLobbyDataModel (model-mp-staging-new.js)
// from the same data the single-player pickers use, but leaves out parts of it.
// Its two builders are wrapped here at runtime, so the base file stays the
// game's own and a patch to it carries straight through:
//   Leader          the ability's name above its text, and the civilizations
//                   the leader is suggested for in each age: Historical first,
//                   then Geographic, strongest first. These are the same
//                   associations the Historical age-transition option follows
//                   (zg-age-transition-civs.js), under the same labels.
//   Civilization    the ability's name above its text, and, when the civ is a
//                   Historical or Geographic choice for the leader in that
//                   row, that label ahead of the game's own reason line.

import { MPLobbyDataModel } from 'fs://game/core/ui/shell/mp-staging/model-mp-staging-new.js';
import { GetCivilizationData } from 'fs://game/core/ui/shell/create-panels/age-civ-select-model.js';
import { getLeaderData } from 'fs://game/core/ui/shell/create-panels/leader-select-model.js';
import { CHOICE_TIERS, leaderAssociations } from './zg-age-transition-civs.js';

const SUGGESTED_TITLE = "LOC_ZG_LOBBY_SUGGESTED_CIVS";
const MAX_CIVS_PER_AGE = 3;
const LOG_PREFIX = "ZG-ASP lobby tooltips:";

const tierLabel = (tierName) => Locale.compose(CHOICE_TIERS.find((tier) => tier.name == tierName)?.label ?? "");
const composed = (text) => (text ? Locale.compose(text) : "");

function query(sql) {
	try {
		return Database.query("config", sql) ?? [];
	} catch (error) {
		console.error(`${LOG_PREFIX} query failed: ${error}`);
		return [];
	}
}

// Built once per shell session; the config database does not change under it.
let lookups = null;
function getLookups() {
	if (lookups) {
		return lookups;
	}
	const ages = query("SELECT Name, PlayerCivilizationDomain, ChronologyIndex FROM Ages ORDER BY ChronologyIndex");
	const civNames = new Map(query("SELECT CivilizationType, CivilizationName FROM Civilizations").map((row) => [row.CivilizationType, row.CivilizationName]));
	lookups = { ages, civNames, associations: leaderAssociations(), leaders: new Map(), civs: new Map() };
	return lookups;
}

// Puts a bold ability name ahead of the ability text the base tooltip already holds.
function withAbilityTitle(tooltip, title, text) {
	const composedText = composed(text);
	if (!tooltip || !title || !composedText || !tooltip.includes(composedText)) {
		return tooltip;
	}
	return tooltip.replace(composedText, `[B]${composed(title)}[/B][N]${composedText}`);
}

function suggestedCivilizations(leaderType) {
	const { ages, civNames, associations } = getLookups();
	const rows = associations.get(leaderType) ?? [];
	const lines = [];
	for (const age of ages) {
		const inAge = rows
			.filter((row) => row.domain == age.PlayerCivilizationDomain)
			.sort((a, b) => CHOICE_TIERS.findIndex((t) => t.name == a.tier) - CHOICE_TIERS.findIndex((t) => t.name == b.tier) || b.bias - a.bias)
			.slice(0, MAX_CIVS_PER_AGE);
		if (inAge.length > 0) {
			const civs = inAge.map((row) => `${composed(civNames.get(row.civ) ?? row.civ)} (${tierLabel(row.tier)})`).join(", ");
			lines.push(`[B]${composed(age.Name)}:[/B] ${civs}`);
		}
	}
	return lines.length > 0 ? `[N][STYLE:text-secondary][STYLE:font-title-base]${composed(SUGGESTED_TITLE)}[/S][/S][N]${lines.join("[N]")}` : "";
}

const baseLeaderTooltip = MPLobbyDataModel.prototype.getLeaderTooltip;
MPLobbyDataModel.prototype.getLeaderTooltip = function (leaderType) {
	const tooltip = baseLeaderTooltip.call(this, leaderType);
	if (!tooltip) {
		return tooltip;
	}
	const { leaders } = getLookups();
	if (!leaders.has(leaderType)) {
		const data = getLeaderData(false).find((leader) => leader.leaderID == leaderType);
		leaders.set(leaderType, withAbilityTitle(tooltip, data?.abilityTitle, data?.abilityText) + suggestedCivilizations(leaderType));
	}
	return leaders.get(leaderType);
};

const baseCivilizationTooltip = MPLobbyDataModel.prototype.getCivilizationTooltip;
MPLobbyDataModel.prototype.getCivilizationTooltip = function (civilizationType, playerID) {
	let tooltip = baseCivilizationTooltip.call(this, civilizationType, playerID);
	if (!tooltip) {
		return tooltip;
	}
	const { civs, associations } = getLookups();
	if (!civs.has(civilizationType)) {
		civs.set(civilizationType, GetCivilizationData(false).find((civ) => civ.civID == civilizationType) ?? null);
	}
	const data = civs.get(civilizationType);
	tooltip = withAbilityTitle(tooltip, data?.abilityTitle, data?.abilityText);

	const leaderType = this.findPlayerParameter(playerID, this.PlayerLeaderStringHandle)?.value?.value;
	const association = (associations.get(leaderType) ?? []).find((row) => row.civ == civilizationType);
	if (association) {
		const label = `[N][STYLE:text-secondary][B]${tierLabel(association.tier)}[/B][/S]`;
		const reason = composed(this.cacheLeaderCivilizationBias.get(leaderType)?.get(civilizationType));
		tooltip = reason && tooltip.endsWith(`[N]${reason}`)
			? `${tooltip.slice(0, -(reason.length + 3))}${label} ${reason}`
			: `${tooltip}${label}`;
	}
	return tooltip;
};
