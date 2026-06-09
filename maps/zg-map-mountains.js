// Applies the Mountains setup setting when a map script places mountains.
// Mirrors the base addMountains, which turns land above a fractal height
// percentile into mountains (default cutoff 90 = the tallest ~10% of land).
// A higher cutoff yields fewer mountains, a lower cutoff more; Disabled skips
// mountain placement entirely. Default keeps the base behavior unchanged.
import { g_MountainFractal, g_HillFractal, g_MountainTerrain, g_FlatTerrain } from 'fs://game/base-standard/maps/map-globals.js';
import { addVolcanoes, addTundraVolcanoes } from 'fs://game/base-standard/maps/volcano-generator.js';

const MOUNTAINS_SETTING_KEY = "MountainsKey";
const MOUNTAINS_DISABLED = "ZG_DISABLED_MOUNTAINS";
// Fractal height percentile cutoff per tier; higher = fewer mountains.
const MOUNTAIN_TIER_CUTOFF = {
	ZG_LESS_MOUNTAINS: 95,
	ZG_MORE_MOUNTAINS: 80,
};
const BASE_CUTOFF = 93;
const BASE_ADJUSTMENT = 3;

export function zgMountainsDisabled() {
	return Configuration.getGameValue(MOUNTAINS_SETTING_KEY) == MOUNTAINS_DISABLED;
}

export function zgAddVolcanoes(iWidth, iHeight) {
	if (zgMountainsDisabled()) {
		console.log("ZG-ASP mountains 'ZG_DISABLED_MOUNTAINS': skipping volcanoes (boundary mountains)");
		return;
	}
	addVolcanoes(iWidth, iHeight);
}

export function zgAddTundraVolcanoes(iWidth, iHeight) {
	if (zgMountainsDisabled()) {
		return;
	}
	addTundraVolcanoes(iWidth, iHeight);
}

export function zgAddMountains(iWidth, iHeight) {
	const setting = Configuration.getGameValue(MOUNTAINS_SETTING_KEY);
	if (setting == MOUNTAINS_DISABLED) {
		console.log("ZG-ASP mountains setting 'ZG_DISABLED_MOUNTAINS': skipping mountain generation");
		return;
	}
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
