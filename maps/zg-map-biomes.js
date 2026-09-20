// Applies the Map Temperature setup setting when a map script assigns biomes.
// Port of {base-standard}maps/feature-biome-generator.js designateBiomes with
// per-setting biome bands on each plot's effective latitude.
//
// Hot is a drier, warmer world: the Desert band widens and Tundra is pushed
// further toward the poles. Cold is the reverse, a narrower Desert and Tundra
// reaching closer to the equator. Tropical and Plains hold their standard edges
// in every tier, and the rainfall extremes that force Desert and Tropical
// outright are untouched, so only the latitude bands move.
import { g_PlainsLatitude, g_MarineBiome, g_DesertBiome, g_MountainTerrain, g_TropicalBiome, g_PlainsBiome, g_GrasslandBiome, g_TundraBiome } from 'fs://game/base-standard/maps/map-globals.js';
import { zgSettingTier } from './zg-map-settings.js';

const TEMPERATURE_SETTING_KEY = "MapTemperatureKey";
const TEMPERATURE_RANDOM = "ZG_RANDOM_TEMPERATURE";
// Upper bounds of the Tropical, Plains, Desert, and Grassland bands; Tundra lies
// beyond the last. Standard carries the base game's own bands, so Random has a
// real third tier to draw rather than only the two extremes.
//
// Only the third and fourth bounds move. Desert runs from the Plains edge to the
// third, so Hot widens it by 7 degrees and Cold narrows it by the same; Tundra
// begins at the fourth, so Hot pushes it 7 degrees poleward and Cold brings it 8
// degrees equatorward. Grassland keeps a width of 13 to 14 in every tier.
const TEMPERATURE_BANDS = {
	ZG_COLD_TEMPERATURE: [17, 33, 37, 50],
	ZG_STANDARD_TEMPERATURE: [17, 33, 44, 58],
	ZG_HOT_TEMPERATURE: [17, 33, 51, 65],
};

function temperatureBands() {
	const bands = zgSettingTier(TEMPERATURE_BANDS, TEMPERATURE_SETTING_KEY, "ZG_STANDARD_TEMPERATURE", TEMPERATURE_RANDOM);
	console.log(`ZG-ASP temperature: biome bands ${bands.join("/")}`);
	return bands;
}

export function zgDesignateBiomes(iWidth, iHeight) {
	console.log("Biomes");
	const [tropicalMax, plainsMax, desertMax, grasslandMax] = temperatureBands();
	let iTotalLandPlots = 0;
	let iTotalLandPlotsAbove = 0;
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			const latitude = GameplayMap.getPlotLatitude(iX, iY);
			if (!GameplayMap.isWater(iX, iY)) {
				iTotalLandPlots++;
				if (g_PlainsLatitude < latitude) {
					iTotalLandPlotsAbove++;
				}
			}
		}
	}
	if (Math.round(iTotalLandPlots / 5 * 2 * 0.75) > iTotalLandPlotsAbove) {
		console.log(`Less  iTotalLandPlots: ${iTotalLandPlots} iTotalLandPlotsAbove: ${iTotalLandPlotsAbove}`);
	}
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			if (GameplayMap.isWater(iX, iY)) {
				TerrainBuilder.setBiomeType(iX, iY, g_MarineBiome);
				continue;
			}
			let latitude = Math.abs(GameplayMap.getPlotLatitude(iX, iY));
			latitude += Math.round(GameplayMap.getElevation(iX, iY) / 120);
			const rainfall = GameplayMap.getRainfall(iX, iY);
			if (rainfall < 25) {
				TerrainBuilder.setBiomeType(iX, iY, g_DesertBiome);
			} else if (rainfall > 250 && GameplayMap.getTerrainType(iX, iY) != g_MountainTerrain) {
				TerrainBuilder.setBiomeType(iX, iY, g_TropicalBiome);
			} else {
				if (rainfall < 100) {
					latitude += (100 - rainfall) / 10;
				} else if (rainfall > 100) {
					latitude -= (rainfall - 100) / 10;
				}
				if (GameplayMap.isRiver(iX, iY)) {
					latitude -= 10;
				} else if (GameplayMap.isAdjacentToRivers(iX, iY, 1)) {
					latitude -= 5;
				}
				if (latitude < tropicalMax) {
					TerrainBuilder.setBiomeType(iX, iY, g_TropicalBiome);
				} else if (latitude < plainsMax) {
					TerrainBuilder.setBiomeType(iX, iY, g_PlainsBiome);
				} else if (latitude < desertMax) {
					TerrainBuilder.setBiomeType(iX, iY, g_DesertBiome);
				} else if (latitude < grasslandMax) {
					TerrainBuilder.setBiomeType(iX, iY, g_GrasslandBiome);
				} else {
					TerrainBuilder.setBiomeType(iX, iY, g_TundraBiome);
				}
			}
		}
	}
}
