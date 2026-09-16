// Applies the Mountains setup setting when a map script places mountains.
// Mirrors the base addMountains, which turns land above a fractal height
// percentile into mountains (default cutoff 90 = the tallest ~10% of land).
// A higher cutoff yields fewer mountains, a lower cutoff more; Standard keeps
// the base behavior unchanged.
import { g_MountainFractal, g_HillFractal, g_MountainTerrain, g_FlatTerrain } from 'fs://game/base-standard/maps/map-globals.js';
import { TerrainType } from 'fs://game/base-standard/scripts/voronoi-types.js';

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
// from zgAddMountains, so the tier is applied to the hex map before it is
// written to the terrain builder. Tiles are picked by how many mountain
// neighbours they have, eroding the most isolated peaks for Less and growing
// existing ranges outward for More, which keeps ranges contiguous. The ordering
// is stable and uses no random numbers, so a map seed still reproduces exactly.
const MOUNTAIN_TIER_HEX_SCALE = {
	ZG_LESS_MOUNTAINS: 0.5,
	ZG_MORE_MOUNTAINS: 2,
};

function countMountainNeighbours(hexMap, tile) {
	const neighbours = [];
	hexMap.appendNeighbors(tile, neighbours, (neighbour) => neighbour.terrainType === TerrainType.Mountainous);
	return neighbours.length;
}

export function zgAdjustHexMountains(hexMap) {
	const setting = Configuration.getGameValue(MOUNTAINS_SETTING_KEY);
	const scale = MOUNTAIN_TIER_HEX_SCALE[setting];
	if (!scale) {
		return;
	}
	const mountains = [];
	const rough = [];
	for (const row of hexMap.getTiles()) {
		for (const tile of row) {
			if (tile.terrainType === TerrainType.Mountainous) {
				mountains.push(tile);
			} else if (tile.terrainType === TerrainType.Rough) {
				rough.push(tile);
			}
		}
	}
	// Counted once up front: the comparator runs many times, and using the
	// pre-adjustment counts keeps the result independent of processing order.
	const neighbourCount = new Map();
	for (const tile of mountains) {
		neighbourCount.set(tile, countMountainNeighbours(hexMap, tile));
	}
	for (const tile of rough) {
		neighbourCount.set(tile, countMountainNeighbours(hexMap, tile));
	}
	const byNeighbours = (ascending) => (a, b) => {
		const diff = neighbourCount.get(a) - neighbourCount.get(b);
		if (diff !== 0) {
			return ascending ? diff : -diff;
		}
		return (a.coord.y - b.coord.y) || (a.coord.x - b.coord.x);
	};
	const target = Math.round(mountains.length * scale);
	let changed = 0;
	if (scale < 1) {
		mountains.sort(byNeighbours(true));
		changed = Math.max(0, mountains.length - target);
		for (let i = 0; i < changed; i++) {
			mountains[i].terrainType = TerrainType.Rough;
		}
	} else {
		rough.sort(byNeighbours(false));
		changed = Math.max(0, Math.min(rough.length, target - mountains.length));
		for (let i = 0; i < changed; i++) {
			rough[i].terrainType = TerrainType.Mountainous;
		}
	}
	console.log(`ZG-ASP mountains setting '${setting}': ${mountains.length} mountain tiles adjusted by ${scale < 1 ? "-" : "+"}${changed}`);
}
