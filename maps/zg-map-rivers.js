// Applies the Rivers setup setting when a map script models its rivers.
// The setting is stored as a plain string (Hash 0), so it can be read
// directly, matching the pattern used by AgeTransitionSettingName.
//
// One setting covers both halves of river generation. Every tier scales the
// map script's own intensity, and the tiers that shift how much of the water is
// navigable additionally re-run the base game's river finalisation with their
// own large river share, above or below the base 25. Standard sets neither
// field, so the default path is exactly what the base game produces.
import { g_NavigableRiverTerrain } from 'fs://game/base-standard/maps/map-globals.js';

const RIVERS_SETTING_KEY = "RiversKey";
// scale multiplies the map script's own river percent; largeRiverPercent, when
// present, re-finalises the rivers at that share instead of the base 25, so a
// higher value yields more navigable water and a lower value less.
// Listed in the order the setup screen shows them: grouped by river count,
// fewest first, and within each group by how much of that water is navigable.
const RIVER_TIER = {
	ZG_WADI_RIVERS: { scale: 0.5, largeRiverPercent: 12 },
	ZG_LESS_RIVERS: { scale: 0.5 },
	ZG_CHANNEL_RIVERS: { scale: 0.5, largeRiverPercent: 45 },
	ZG_SHALLOW_RIVERS: { largeRiverPercent: 12 },
	ZG_WATERWAY_RIVERS: { largeRiverPercent: 45 },
	ZG_STREAM_RIVERS: { scale: 1.5, largeRiverPercent: 12 },
	ZG_MORE_RIVERS: { scale: 1.5 },
	ZG_DEEP_RIVERS: { scale: 1.5, largeRiverPercent: 45 },
};
const MIN_PERCENT = 2.5;
const MAX_PERCENT = 80;
// Matches the base GenerationContext, which is the only place these are set.
const MIN_NAV_RIVER_LENGTH = 2;
const MIN_UPSTREAM_MINOR_RIVERS = 2;

export function zgModelRivers(defaultLength, defaultPercent) {
	const setting = Configuration.getGameValue(RIVERS_SETTING_KEY);
	const tier = RIVER_TIER[setting] ?? {};
	const percent = tier.scale
		? Math.max(MIN_PERCENT, Math.min(MAX_PERCENT, Math.round(defaultPercent * tier.scale)))
		: defaultPercent;
	console.log(`ZG-ASP rivers setting '${setting}': modelRivers(${defaultLength}, ${percent})`);
	TerrainBuilder.modelRivers(defaultLength, percent, g_NavigableRiverTerrain);
	if (tier.largeRiverPercent) {
		console.log(`ZG-ASP rivers setting '${setting}': finalizeRivers at ${tier.largeRiverPercent}% large rivers`);
		TerrainBuilder.finalizeRivers(true, tier.largeRiverPercent, MIN_NAV_RIVER_LENGTH, MIN_UPSTREAM_MINOR_RIVERS);
	}
}
