// A leader's civilization associations, the game's own reading of them in
// LeaderCivilizationBias: the Historical and Geographic choices the civilization
// picker marks for a human. Shared by the age transition's Historical mode and
// the multiplayer lobby tooltips.

import { cached, queryConfig } from './zg-config.js';

// In the order they are tried. Strategic rows are not associations and are left
// out. Matched on the prefix: one shipped row spells its type without "_CHOICE".
export const CHOICE_TIERS = [
	{ name: "historical", choicePrefix: "LOC_CREATE_GAME_HISTORICAL", label: "LOC_ZG_CIV_CHOICE_HISTORICAL" },
	{ name: "geographic", choicePrefix: "LOC_CREATE_GAME_GEOGRAPHIC", label: "LOC_ZG_CIV_CHOICE_GEOGRAPHIC" },
];

// Leader type to its Historical and Geographic rows across every age, highest
// Bias first. The row's domain says which age the civilization is native to.
function buildLeaderAssociations() {
	const out = new Map();
	for (const row of queryConfig("SELECT LeaderType, CivilizationType, CivilizationDomain, Bias, ChoiceType FROM LeaderCivilizationBias ORDER BY Bias DESC")) {
		const tier = CHOICE_TIERS.find((candidate) => row.ChoiceType?.startsWith(candidate.choicePrefix));
		if (!tier) {
			continue;
		}
		const rows = out.get(row.LeaderType) ?? [];
		if (!rows.some((known) => known.civ == row.CivilizationType)) {
			rows.push({ civ: row.CivilizationType, domain: row.CivilizationDomain, bias: row.Bias, tier: tier.name });
		}
		out.set(row.LeaderType, rows);
	}
	return out;
}
export const leaderAssociations = cached(buildLeaderAssociations);
