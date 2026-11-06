// Snow pass that applies the mod's climate (zg-map-climate.js).
// Port of {base-standard}maps/snow-generator.js generateSnow.
//
// The base lays permanent snow in rows inward from each polar edge: from the
// first land row past the polar water down to latitude 60, the chance of any
// snow falls from 90% to 30% and heavy snow gives way to medium and light. Here
// the same curve is laid by each land tile's Heat Source latitude plus the Map
// Temperature shift instead of its row, so snow follows the cold wherever it
// lies. With Standard on both settings the base pass runs unchanged.
import { g_PolarWaterRows } from 'fs://game/base-standard/maps/map-globals.js';
import { generateSnow } from 'fs://game/base-standard/maps/snow-generator.js';
import { zgClimate } from './zg-map-climate.js';

const SNOW_LATITUDE_MIN = 60;
const ANY_SNOW_CHANCE = 90;
const CHANCE_SPAN = 60;
// Light, medium, and heavy at the coldest edge; across the span light and
// medium each gain what heavy loses.
const WEIGHT_CHANCES = [10, 30, 60];

const snowEffect = (weight) => MapPlotEffects.getPlotEffectTypesContainingTags(["SNOW", weight, "PERMANENT"])?.[0] ?? -1;

// The latitude where the base's first snow row lies, just past the polar water.
function coldestSnowLatitude(iHeight) {
	const halfHeight = iHeight / 2;
	return Math.round(90 - (g_PolarWaterRows / halfHeight) * 90);
}

export function zgGenerateSnow(iWidth, iHeight) {
	const climate = zgClimate();
	if (climate.engineLatitude && climate.shift == 0) {
		generateSnow(iWidth, iHeight);
		return;
	}
	console.log("Generating permanent snow by climate latitude");
	const effects = ["LIGHT", "MEDIUM", "HEAVY"].map(snowEffect);
	const coldest = coldestSnowLatitude(iHeight);
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			if (GameplayMap.isWater(iX, iY)) {
				continue;
			}
			const latitude = Math.abs(climate.latitude(iX, iY)) + climate.shift;
			if (latitude < SNOW_LATITUDE_MIN) {
				continue;
			}
			// 0 at the coldest edge, 1 at latitude 60.
			const progress = Math.min(1, Math.max(0, (coldest - latitude) / (coldest - SNOW_LATITUDE_MIN)));
			if (TerrainBuilder.getRandomNumber(100, "Any Snow") > ANY_SNOW_CHANCE - CHANCE_SPAN * progress) {
				continue;
			}
			const heavy = WEIGHT_CHANCES[2] - CHANCE_SPAN * progress;
			const chances = [WEIGHT_CHANCES[0] + CHANCE_SPAN * progress, WEIGHT_CHANCES[1] + CHANCE_SPAN * progress, heavy];
			let roll = TerrainBuilder.getRandomNumber(100, "Snow Weight");
			for (let weight = chances.length - 1; weight >= 0; --weight) {
				if (roll < chances[weight]) {
					MapPlotEffects.addPlotEffect(GameplayMap.getIndexFromXY(iX, iY), effects[weight]);
					break;
				}
				roll -= chances[weight];
			}
		}
	}
}
