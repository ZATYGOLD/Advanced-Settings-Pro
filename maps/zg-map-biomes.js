// Applies the Map Temperature setup setting when a map script assigns biomes.
// Port of {base-standard}maps/feature-biome-generator.js designateBiomes with
// per-setting biome bands on each plot's effective latitude. Hot lets Tropical
// and Desert reach further from the equator; Cold starts Tundra closer to it.
// Plains and Grassland keep their standard edges except where a neighboring
// band grows into them. The rainfall extremes that force Desert and Tropical
// are unchanged.
import { g_PlainsLatitude, g_MarineBiome, g_DesertBiome, g_MountainTerrain, g_TropicalBiome, g_PlainsBiome, g_GrasslandBiome, g_TundraBiome } from 'fs://game/base-standard/maps/map-globals.js';

const TEMPERATURE_SETTING_KEY = "MapTemperatureKey";
// Upper bounds of the Tropical, Plains, Desert, and Grassland bands; Tundra lies beyond.
const STANDARD_BANDS = [17, 33, 44, 58];
const TEMPERATURE_BANDS = {
	ZG_COLD_TEMPERATURE: [17, 33, 44, 50],
	ZG_HOT_TEMPERATURE: [25, 33, 51, 58],
};

function temperatureBands() {
	const setting = Configuration.getGameValue(TEMPERATURE_SETTING_KEY);
	const bands = TEMPERATURE_BANDS[setting] ?? STANDARD_BANDS;
	console.log(`ZG-ASP temperature setting '${setting}': biome bands ${bands.join("/")}`);
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
