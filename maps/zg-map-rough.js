// Applies the Map Age setup setting when a map script raises its rough ground.
//
// A New world is freshly buckled and still broken: more rough ground, less flat.
// An Old world has been worn down: less rough ground, broader plains. Standard
// leaves the base game's own terrain alone.
//
// Rough is TERRAIN_HILL in the game's data, which is why the base symbols and
// the hill score below keep that name; everything the player reads says rough.
//
// Map Age moves rough ground only. Mountains are the Mountains setting's
// business, so the two never pull on the same tiles: pick a map age for how
// broken the ground is, and Mountains for how many peaks rise out of it.
import { g_HillTerrain } from 'fs://game/base-standard/maps/map-globals.js';
import { zgSettingTier } from './zg-map-settings.js';

const MAP_AGE_SETTING_KEY = "MapAgeKey";

// Port of {base-standard}maps/elevation-terrain-generator.js addHills, which
// scores each land tile by how much its elevation differs from its neighbours
// and roughens it wherever that score clears a threshold. A lower threshold
// catches gentler ground, so it yields more rough tiles; Standard is the base
// game's own 950 - 3 * 20.
const ROUGH_TIER_THRESHOLD = {
	ZG_MAP_AGE_NEW: 790,
	ZG_MAP_AGE_STANDARD: 890,
	ZG_MAP_AGE_OLD: 990,
};

export function zgAddRough(iWidth, iHeight) {
	const threshold = zgSettingTier(ROUGH_TIER_THRESHOLD, MAP_AGE_SETTING_KEY, "ZG_MAP_AGE_STANDARD");
	console.log(`ZG-ASP map age: rough score threshold ${threshold}`);
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			if (GameplayMap.isWater(iX, iY) || GameplayMap.isMountain(iX, iY)) {
				continue;
			}
			const location = GameplayMap.getLocationFromIndex(GameplayMap.getIndexFromXY(iX, iY));
			const elevation = GameplayMap.getElevation(iX, iY);
			let score = 0;
			for (let direction = 0; direction < DirectionTypes.NUM_DIRECTION_TYPES; direction++) {
				if (GameplayMap.isCliffCrossing(iX, iY, direction)) {
					continue;
				}
				const adjacent = GameplayMap.getAdjacentPlotLocation(location, direction);
				score += Math.abs(GameplayMap.getElevation(adjacent.x, adjacent.y) - elevation);
			}
			if (score > threshold) {
				TerrainBuilder.setTerrainType(iX, iY, g_HillTerrain);
			}
		}
	}
}
