// Snow pass that applies the mod's climate (zg-map-climate.js).
// Port of {base-standard}maps/snow-generator.js generateSnow.
//
// The base lays permanent snow in rows from latitude 53 to each polar edge: the
// snow chance climbs from 0 to 100 across them, varied by a random amount, and
// its thresholds pick no, light, medium or heavy snow. Here the same curve is
// laid by each land tile's Map Zones latitude plus the Map Temperature shift
// instead of its row, so snow follows the cold wherever it lies. The base's own
// SnowGenConfig supplies the figures. With Standard on both settings, or with
// Climate Controls enabled (whose pass replaces the base), the base pass runs.
import { SnowGenConfig, generateSnow } from 'fs://game/base-standard/maps/snow-generator.js';
import { zgClimate, zgClimateControlActive } from './zg-map-climate.js';
import { zgForEachTile, zgInterpolate } from './zg-map-utils.js';

const POLE_LATITUDE = 90;

const snowEffect = (weight) => MapPlotEffects.getPlotEffectTypesContainingTags(["SNOW", weight, "PERMANENT"])?.[0] ?? -1;

export function zgGenerateSnow(iWidth, iHeight) {
	const climate = zgClimateControlActive() ? null : zgClimate();
	if (!climate || (climate.engineLatitude && climate.shift == 0)) {
		generateSnow(iWidth, iHeight);
		return;
	}
	console.log("ZG-ASP snow: laid by climate latitude");
	const config = new SnowGenConfig();
	const effects = ["LIGHT", "MEDIUM", "HEAVY"].map(snowEffect);
	const variation = config.snowDensityVariation;
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		if (GameplayMap.isWater(iX, iY)) {
			return;
		}
		const signedLatitude = climate.latitude(iX, iY);
		const start = signedLatitude < 0 ? config.snowLatitudeSouth : config.snowLatitudeNorth;
		const latitude = Math.abs(signedLatitude) + climate.shift;
		if (latitude < start) {
			return;
		}
		const chance = zgInterpolate(latitude, start, POLE_LATITUDE, 0, 100)
			+ TerrainBuilder.getRandomNumber(variation * 2, "Any Snow") - variation;
		let weight = config.snowThresholds.length - 1;
		while (weight >= 0 && chance < config.snowThresholds[weight]) {
			--weight;
		}
		if (weight >= 0) {
			MapPlotEffects.addPlotEffect(GameplayMap.getIndexFromXY(iX, iY), effects[weight]);
		}
	});
}
