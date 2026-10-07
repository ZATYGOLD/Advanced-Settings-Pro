// Applies the Mountains setup setting when a map script places mountains.
// Mirrors the base addMountains, which turns land above a fractal height
// percentile into mountains (default cutoff 90 = the tallest ~10% of land).
// A higher cutoff yields fewer mountains, a lower cutoff more; Standard keeps
// the base behavior unchanged.
import { g_MountainFractal, g_HillFractal, g_MountainTerrain, g_HillTerrain, g_FlatTerrain } from 'fs://game/base-standard/maps/map-globals.js';

const MOUNTAINS_SETTING_KEY = "MountainsKey";
// Fractal height percentile cutoff per tier; higher = fewer mountains.
const MOUNTAIN_TIER_CUTOFF = {
	ZG_LESS_MOUNTAINS: 95,
	ZG_MORE_MOUNTAINS: 80,
};
const BASE_CUTOFF = 93;
const BASE_ADJUSTMENT = 3;

export function zgAddMountains(iWidth, iHeight) {
	const setting = Configuration.getGameValue(MOUNTAINS_SETTING_KEY);
	const iFlags = 0;
	const grainAmount = 5;
	let extraMountains = 0;
	const liveEventDBRow = GameInfo.GlobalParameters.lookup("REGISTERED_MARVELOUS_MOUNTAINS_EVENT");
	if (liveEventDBRow && liveEventDBRow.Value != "0") {
		extraMountains = 40;
	}
	const cutoff = MOUNTAIN_TIER_CUTOFF[setting] ?? (BASE_CUTOFF - BASE_ADJUSTMENT);
	const mountains = cutoff - extraMountains;
	console.log(`ZG-ASP mountains setting '${setting}': height percentile ${mountains}`);
	FractalBuilder.create(g_MountainFractal, iWidth, iHeight, grainAmount, iFlags);
	FractalBuilder.create(g_HillFractal, iWidth, iHeight, grainAmount, iFlags);
	const iMountainThreshold = FractalBuilder.getHeightFromPercent(g_MountainFractal, mountains);
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			let terrain = GameplayMap.getTerrainType(iX, iY);
			if (GameplayMap.isWater(iX, iY) == false) {
				const iMountainHeight = FractalBuilder.getHeight(g_MountainFractal, iX, iY);
				if (iMountainHeight >= iMountainThreshold) {
					terrain = g_MountainTerrain;
				}
				if (terrain != g_FlatTerrain) {
					TerrainBuilder.setTerrainType(iX, iY, terrain);
				}
			}
		}
	}
}

// Voronoi maps take their mountains from the Voronoi simulation rather than
// from zgAddMountains, so the tier is applied afterwards as a second pass over
// the terrain the simulation produced. Tiles are picked by how many mountain
// neighbours they have, eroding the most isolated peaks for Less and growing
// existing ranges outward for More, which keeps ranges contiguous. The ordering
// is stable and uses no random numbers, so a map seed still reproduces exactly.
//
// This runs after the Map Age pass rather than on the simulated hex tiles: rough
// ground does not exist until then, and More has nothing to promote without it.
const MOUNTAIN_TIER_SCALE = {
	ZG_LESS_MOUNTAINS: 0.5,
	ZG_MORE_MOUNTAINS: 2,
};

function countMountainNeighbours(x, y) {
	const location = GameplayMap.getLocationFromIndex(GameplayMap.getIndexFromXY(x, y));
	let count = 0;
	for (let direction = 0; direction < DirectionTypes.NUM_DIRECTION_TYPES; direction++) {
		const adjacent = GameplayMap.getAdjacentPlotLocation(location, direction);
		if (adjacent.x < 0 || adjacent.y < 0) {
			continue;
		}
		if (GameplayMap.isMountain(adjacent.x, adjacent.y)) {
			count++;
		}
	}
	return count;
}

export function zgAdjustMountains(iWidth, iHeight) {
	const setting = Configuration.getGameValue(MOUNTAINS_SETTING_KEY);
	const scale = MOUNTAIN_TIER_SCALE[setting];
	if (!scale) {
		return;
	}
	const mountains = [];
	const rough = [];
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			if (GameplayMap.isWater(iX, iY)) {
				continue;
			}
			if (GameplayMap.isMountain(iX, iY)) {
				mountains.push({ x: iX, y: iY });
			} else if (GameplayMap.getTerrainType(iX, iY) == g_HillTerrain) {
				rough.push({ x: iX, y: iY });
			}
		}
	}
	// Counted once up front: the comparator runs many times, and using the
	// pre-adjustment counts keeps the result independent of processing order.
	const neighbourCount = new Map();
	for (const tile of mountains.concat(rough)) {
		neighbourCount.set(tile, countMountainNeighbours(tile.x, tile.y));
	}
	const byNeighbours = (ascending) => (a, b) => {
		const diff = neighbourCount.get(a) - neighbourCount.get(b);
		if (diff !== 0) {
			return ascending ? diff : -diff;
		}
		return (a.y - b.y) || (a.x - b.x);
	};
	const target = Math.round(mountains.length * scale);
	let changed = 0;
	if (scale < 1) {
		mountains.sort(byNeighbours(true));
		changed = Math.max(0, mountains.length - target);
		for (let i = 0; i < changed; i++) {
			TerrainBuilder.setTerrainType(mountains[i].x, mountains[i].y, g_HillTerrain);
		}
	} else {
		rough.sort(byNeighbours(false));
		changed = Math.max(0, Math.min(rough.length, target - mountains.length));
		for (let i = 0; i < changed; i++) {
			TerrainBuilder.setTerrainType(rough[i].x, rough[i].y, g_MountainTerrain);
		}
	}
	console.log(`ZG-ASP mountains setting '${setting}': ${mountains.length} mountain tiles and ${rough.length} rough adjusted by ${scale < 1 ? "-" : "+"}${changed}`);
}
