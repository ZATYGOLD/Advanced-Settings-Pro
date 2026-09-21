// Applies the World Age setup setting when a map script raises its rough ground.
//
// A New world is freshly buckled and still broken: more rough ground, less flat.
// An Old world has been worn down: less rough ground, broader plains. Standard
// leaves the base game's own terrain alone.
//
// Rough is TERRAIN_HILL in the game's data, which is why the base symbols and
// the hill score below keep that name; everything the player reads says rough.
//
// World Age moves rough ground only. Mountains are the Mountains setting's
// business, so the two never pull on the same tiles: pick a world age for how
// broken the ground is, and Mountains for how many peaks rise out of it.
import { g_HillTerrain } from 'fs://game/base-standard/maps/map-globals.js';
import { TerrainType } from 'fs://game/base-standard/scripts/voronoi-types.js';
import { zgSettingTier } from './zg-map-settings.js';

const WORLD_AGE_SETTING_KEY = "WorldAgeKey";

// Port of {base-standard}maps/elevation-terrain-generator.js addHills, which
// scores each land tile by how much its elevation differs from its neighbours
// and roughens it wherever that score clears a threshold. A lower threshold
// catches gentler ground, so it yields more rough tiles; Standard is the base
// game's own 950 - 3 * 20.
const ROUGH_TIER_THRESHOLD = {
	ZG_WORLD_AGE_NEW: 790,
	ZG_WORLD_AGE_STANDARD: 890,
	ZG_WORLD_AGE_OLD: 990,
};

// Voronoi maps get their terrain from the simulation instead of from addHills,
// so the tier is applied to the hex map before it is written out. Rough tiles
// are traded against Flat ones the way zgAdjustHexMountains trades Mountainous
// against Rough, and by the same rule: convert the tiles with the most like
// neighbours first, so the result grows existing ground rather than speckling
// the map. The ordering is stable and uses no random numbers, so a map seed
// still reproduces exactly.
const ROUGH_TIER_HEX_SCALE = {
	ZG_WORLD_AGE_NEW: 1.5,
	ZG_WORLD_AGE_OLD: 0.6,
};

export function zgAddRough(iWidth, iHeight) {
	const threshold = zgSettingTier(ROUGH_TIER_THRESHOLD, WORLD_AGE_SETTING_KEY, "ZG_WORLD_AGE_STANDARD");
	console.log(`ZG-ASP world age: rough score threshold ${threshold}`);
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

function countNeighboursOfType(hexMap, tile, terrainType) {
	const neighbours = [];
	hexMap.appendNeighbors(tile, neighbours, (neighbour) => neighbour.terrainType === terrainType);
	return neighbours.length;
}

export function zgAdjustHexRough(hexMap) {
	const scale = zgSettingTier(ROUGH_TIER_HEX_SCALE, WORLD_AGE_SETTING_KEY, "ZG_WORLD_AGE_STANDARD");
	if (!scale) {
		return;
	}
	const rough = [];
	const flat = [];
	for (const row of hexMap.getTiles()) {
		for (const tile of row) {
			if (tile.terrainType === TerrainType.Rough) {
				rough.push(tile);
			} else if (tile.terrainType === TerrainType.Flat) {
				flat.push(tile);
			}
		}
	}
	// Counted once up front: the comparator runs many times, and using the
	// pre-adjustment counts keeps the result independent of processing order.
	const neighbourCount = new Map();
	for (const tile of rough.concat(flat)) {
		neighbourCount.set(tile, countNeighboursOfType(hexMap, tile, TerrainType.Rough));
	}
	const byNeighbours = (ascending) => (a, b) => {
		const diff = neighbourCount.get(a) - neighbourCount.get(b);
		if (diff !== 0) {
			return ascending ? diff : -diff;
		}
		return (a.coord.y - b.coord.y) || (a.coord.x - b.coord.x);
	};
	const target = Math.round(rough.length * scale);
	let changed = 0;
	if (scale < 1) {
		// Wear the most isolated rough ground down to flat first.
		rough.sort(byNeighbours(true));
		changed = Math.max(0, rough.length - target);
		for (let i = 0; i < changed; i++) {
			rough[i].terrainType = TerrainType.Flat;
		}
	} else {
		// Roughen the flat ground that already borders the most rough tiles.
		flat.sort(byNeighbours(false));
		changed = Math.max(0, Math.min(flat.length, target - rough.length));
		for (let i = 0; i < changed; i++) {
			flat[i].terrainType = TerrainType.Rough;
		}
	}
	console.log(`ZG-ASP world age: ${rough.length} rough tiles adjusted by ${scale < 1 ? "-" : "+"}${changed}`);
}
