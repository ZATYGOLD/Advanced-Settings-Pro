// Applies the Rivers setup setting when a map script models its rivers.
// The setting is stored as a plain string (Hash 0), so it can be read
// directly, matching the pattern used by AgeTransitionSettingName.
import { g_NavigableRiverTerrain } from 'fs://game/base-standard/maps/map-globals.js';

const RIVERS_SETTING_KEY = "RiversKey";
const RIVERS_DISABLED = "ZG_DISABLED_RIVERS";
// Gentle scaling of the map script's own intensity; Default keeps it unchanged.
// 1.0 is Default (5, 15)
const RIVER_TIER_SCALE = {
	ZG_LESS_RIVERS: 0.5,
	ZG_MORE_RIVERS: 1.5, //(7.5, 22.5)
};
const MIN_PERCENT = 2.5;
const MAX_PERCENT = 80;

export function zgModelRivers(defaultLength, defaultPercent) {
	const setting = Configuration.getGameValue(RIVERS_SETTING_KEY);
	if (setting == RIVERS_DISABLED) {
		console.log("ZG-ASP rivers setting 'ZG_DISABLED_RIVERS': skipping river modeling");
		return;
	}
	const scale = RIVER_TIER_SCALE[setting];
	const percent = scale ? Math.max(MIN_PERCENT, Math.min(MAX_PERCENT, Math.round(defaultPercent * scale))) : defaultPercent;
	console.log(`ZG-ASP rivers setting '${setting}': modelRivers(${defaultLength}, ${percent})`);
	TerrainBuilder.modelRivers(defaultLength, percent, g_NavigableRiverTerrain);
}
