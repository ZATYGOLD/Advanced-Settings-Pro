// Applies the Lakes setup setting when a map script generates its lakes.
// Less/Default/More still work through LakeGenerationFrequency in the
// gameplay database; Disabled skips lake generation entirely, since the
// game treats a frequency of 0 as "use the default of 25".
import { generateLakes } from 'fs://game/base-standard/maps/elevation-terrain-generator.js';

const LAKES_SETTING_KEY = "LakeGenerationKey";
const LAKES_DISABLED = "ZG_DISABLED_LAKE_GENERATION";

export function zgGenerateLakes(iWidth, iHeight, iTilesPerLake) {
	if (Configuration.getGameValue(LAKES_SETTING_KEY) == LAKES_DISABLED) {
		console.log("ZG-ASP lakes setting 'ZG_DISABLED_LAKE_GENERATION': skipping lake generation");
		return;
	}
	generateLakes(iWidth, iHeight, iTilesPerLake);
}
