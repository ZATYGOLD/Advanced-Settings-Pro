// Applies the Map Age setup setting when a map script raises its rough ground.
// Port of {base-standard}maps/elevation-terrain-generator.js addHills.
//
// A New world is still broken: more rough ground, less flat. An Old world is worn
// down: less rough ground, broader plains. Standard leaves the base terrain
// alone. Map Age moves rough ground (TERRAIN_HILL in the data) only; peaks are
// the Mountains setting's, so the two never pull on the same tiles.
import { g_HillTerrain } from 'fs://game/base-standard/maps/map-globals.js';
import { zgForEachTile, zgSettingTier } from './zg-map-utils.js';

const MAP_AGE_SETTING_KEY = "MapAgeKey";

// addHills scores each land tile by how much its elevation differs from its
// neighbors and roughens it wherever that score clears a threshold. A lower threshold
// catches gentler ground, so it yields more rough tiles; Standard is the base
// game's own 950 - 3 * 20.
const MAP_AGE_TIERS = {
	ZG_MAP_AGE_NEW: 790,
	ZG_MAP_AGE_STANDARD: 890,
	ZG_MAP_AGE_OLD: 990,
};

export function zgAddRough(iWidth, iHeight) {
	const threshold = zgSettingTier(MAP_AGE_TIERS, MAP_AGE_SETTING_KEY, "ZG_MAP_AGE_STANDARD");
	console.log(`ZG-ASP map age: rough score threshold ${threshold}`);
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		if (GameplayMap.isWater(iX, iY) || GameplayMap.isMountain(iX, iY)) {
			return;
		}
		const location = { x: iX, y: iY };
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
	});
}
