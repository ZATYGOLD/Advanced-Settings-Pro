// Applies the Resources and Guaranteed Resources settings when a map script
// places its resources.
//
// Copy of {base-standard}maps/resource-generator.js generateResources with three
// substitutions; every other step stays stock and is imported from the base
// module, so the phase order, profiling and logging match the base exactly:
//
//   1. the density target handed to buildBlueNoiseWindows is scaled,
//   2. effectiveMinimums overrides each resource's own MinimumPerLandmass,
//   3. placed deposits are collected through the base onResourcePlaced hook and
//      grown into small patches.
//
// The base game offers no hook around its density calculation, so the function
// has to be copied rather than wrapped. Re-sync it from the shipped file after a
// patch that touches resource generation; everything outside a ZG block is stock.
import { replaceIslandResources } from 'fs://game/base-standard/maps/map-utilities.js';
import { prepareResourceSet, buildPlacementContext, VERBOSE_LOGGING, tileClassFromId, tileClassLabel, buildBlueNoiseWindows, MAX_DENSITY, DENSITY_TARGET, placeResourcesWithBlueNoise, isResourceAllowedOnLandmass, NUM_LANDMASS_GROUPS } from 'fs://game/base-standard/maps/resource-placement-common.js';
import { profileScope } from 'fs://game/base-standard/scripts/profiling.js';
import { zgSettingTier } from './zg-map-settings.js';

const RESOURCES_SETTING_KEY = "ResourcesKey";
const MINIMUM_SETTING_KEY = "ResourceMinimumKey";

// One setting covers both how many resources are placed and how they sit on the
// map. percent scales the base game's own density target, the share of eligible
// tiles that receive a resource; chance is the odds a deposit grows into a patch
// and max is how many tiles that patch reaches, counting the original.
//
// Sparse is scarce but concentrated, so what there is rewards looking for it.
// Abundant is plentiful and evenly spread. Standard is the base game untouched:
// full density, no clustering.
//
// percent is the total after clustering has grown its extra tiles, not the
// number of seeds placed: clusterCompensation divides the target back down so
// the two halves of each tier stay independent.
const RESOURCES_TIER = {
	ZG_RESOURCES_SPARSE: { percent: 50, chance: 75, max: 3 },
	ZG_RESOURCES_STANDARD: { percent: 100, chance: 0, max: 1 },
	ZG_RESOURCES_ABUNDANT: { percent: 150, chance: 0, max: 1 },
};

// Added to the guaranteed count per landmass, and only for the resources that
// already have one: ten empire resources, each guaranteed 3. A resource the base
// game does not guarantee never gains a floor here.
const MINIMUM_TIER = {
	ZG_RESOURCE_MINIMUM_SPARSE: { modifier: -1 },
	ZG_RESOURCE_MINIMUM_STANDARD: { modifier: 0 },
	ZG_RESOURCE_MINIMUM_ABUNDANT: { modifier: 1 },
};

// Share of a patch's attempted neighbours that actually take a resource. The
// rest are refused because they already hold one, sit on the wrong landmass, or
// fail canHaveResource. Used only to scale the density back down.
const CLUSTER_SUCCESS_RATE = 0.6;
const MIN_GUARANTEED = 1;
const MAX_GUARANTEED = 255;


// Clustering adds tiles on top of the density target, so the target is divided
// by the number of tiles a deposit is expected to become. The two settings then
// stay independent: clustering changes the shape, density changes the amount.
function clusterCompensation(chance, max) {
	if (chance <= 0 || max <= 1) {
		return 1;
	}
	return 1 + (chance / 100) * (max - 1) * CLUSTER_SUCCESS_RATE;
}

// The array buildBlueNoiseWindows reads as config.effectiveMinimums, indexed by
// resource. Returns undefined when nothing changes, so the base game reads each
// resource's own MinimumPerLandmass instead.
function effectiveMinimums(modifier) {
	if (modifier === 0) {
		return undefined;
	}
	const minimums = new Array(GameInfo.Resources.length).fill(0);
	let adjusted = 0;
	// Indexed rather than iterated: the base game's own resource passes read
	// GameInfo.Resources by index, so nothing here relies on it being iterable.
	for (let i = 0; i < GameInfo.Resources.length; i++) {
		const def = GameInfo.Resources[i];
		const base = def?.MinimumPerLandmass ?? 0;
		if (base <= 0) {
			continue;
		}
		minimums[def.$index] = Math.max(MIN_GUARANTEED, Math.min(MAX_GUARANTEED, base + modifier));
		adjusted++;
	}
	console.log(`ZG-ASP resources: guaranteed per landmass ${modifier > 0 ? "+" : ""}${modifier} on ${adjusted} resources`);
	return minimums;
}

// Seed and grow. Each placed deposit may copy itself onto empty neighbours that
// accept it, up to the patch size. Grown tiles are not themselves seeds, so a
// patch cannot chain past its cap. The starting direction is rolled so patches
// do not all grow the same way, and every roll goes through TerrainBuilder for
// determinism.
function growClusters(seeds, resourceSet, chance, max) {
	if (chance <= 0 || max <= 1 || seeds.length === 0) {
		return;
	}
	const directions = DirectionTypes.NUM_DIRECTION_TYPES;
	let grownSeeds = 0;
	let added = 0;
	for (const seed of seeds) {
		if (TerrainBuilder.getRandomNumber(100, "ZG Cluster Roll") >= chance) {
			continue;
		}
		const start = TerrainBuilder.getRandomNumber(directions, "ZG Cluster Direction");
		const origin = { x: seed.x, y: seed.y };
		let grown = 0;
		for (let step = 0; step < directions && grown < max - 1; step++) {
			const adjacent = GameplayMap.getAdjacentPlotLocation(origin, (start + step) % directions);
			if (adjacent.x < 0 || adjacent.y < 0) {
				continue;
			}
			if (GameplayMap.getResourceType(adjacent.x, adjacent.y) != ResourceTypes.NO_RESOURCE) {
				continue;
			}
			let regionId = GameplayMap.getLandmassRegionId(adjacent.x, adjacent.y);
			if (regionId == LandmassRegion.LANDMASS_REGION_NONE) {
				regionId = 0;
			}
			if (!isResourceAllowedOnLandmass(resourceSet.resourceAssignedLandmass[seed.resourceIdx], regionId, NUM_LANDMASS_GROUPS)) {
				continue;
			}
			if (!ResourceBuilder.canHaveResource(adjacent.x, adjacent.y, seed.resourceIdx, true)) {
				continue;
			}
			ResourceBuilder.setResourceType(adjacent.x, adjacent.y, seed.resourceIdx);
			grown++;
			added++;
		}
		if (grown > 0) {
			grownSeeds++;
		}
	}
	console.log(`ZG-ASP resources: clustering grew ${grownSeeds} of ${seeds.length} deposits, adding ${added} tiles`);
}

export function zgGenerateResources(iWidth, iHeight, minMarineResourceTypesOverride = 3) {
	const gatherResourceDataScope = new profileScope("generateResources Resource Data");
	const resourcesHashes = ResourceBuilder.getGeneratedMapResources(minMarineResourceTypesOverride);
	console.log("Resources considered for generation in the current age:");
	for (const resourceHash of resourcesHashes) {
		const resourceInfo = GameInfo.Resources.lookup(resourceHash);
		console.log(`  ${resourceInfo?.Name}, class: ${resourceInfo?.ResourceClassType}, hash: ${resourceHash}`);
	}
	const resourceSet = prepareResourceSet(resourcesHashes);
	gatherResourceDataScope.end();
	const gatherMapDataScope = new profileScope("generateResources Map Data");
	const ctx = buildPlacementContext(iWidth, iHeight);
	const { maxPlayerRegion, nonOceanTileCount } = ctx;
	if (VERBOSE_LOGGING) {
		console.log("Tile counts by classification:");
		const logStrings = [];
		for (let key = 0; key < ctx.groupCount.length; key++) {
			const count = ctx.groupCount[key];
			const adjacentToLandCount = ctx.groupAdjCount[key];
			if (count === 0) continue;
			const adjSuffix = adjacentToLandCount > 0 ? ` (${adjacentToLandCount} adj-to-land)` : "";
			const tileClass = tileClassFromId(ctx.groupRawId[key]);
			logStrings.push(`  ${tileClassLabel(tileClass)}: ${count}${adjSuffix}`);
		}
		logStrings.sort();
		logStrings.forEach((s) => console.log(s));
	}
	console.log(`Landmass regions: player 1..${maxPlayerRegion}, (${maxPlayerRegion} player landmasses)`);
	gatherMapDataScope.end();
	const calculateDensityScope = new profileScope("generateResources Density Calculation");

	// --- ZG: the two settings, read once and applied to the base plan ---
	const resources = zgSettingTier(RESOURCES_TIER, RESOURCES_SETTING_KEY, "ZG_RESOURCES_STANDARD");
	const minimum = zgSettingTier(MINIMUM_TIER, MINIMUM_SETTING_KEY, "ZG_RESOURCE_MINIMUM_STANDARD");
	const compensation = clusterCompensation(resources.chance, resources.max);
	const densityTarget = DENSITY_TARGET * (resources.percent / 100) / compensation;
	console.log(`ZG-ASP resources: density ${resources.percent}%, clustering ${resources.chance}% chance up to ${resources.max} tiles`);
	console.log(`ZG-ASP resources: density target ${DENSITY_TARGET.toFixed(4)} -> ${densityTarget.toFixed(4)} (clustering compensation /${compensation.toFixed(2)})`);
	// --- end ZG ---

	const blueNoisePlan = buildBlueNoiseWindows(ctx, resourceSet, {
		densityTarget: densityTarget,
		maxDensity: MAX_DENSITY,
		effectiveMinimums: effectiveMinimums(minimum.modifier),
	});
	if (VERBOSE_LOGGING) {
		console.log("Eligible tile counts per active resource:");
		for (const typeIdx of resourceSet.activeResourceIndices) {
			const eligible = blueNoisePlan.metrics.resourceEligibleTileCounts[typeIdx];
			if (eligible <= 0) continue;
			const resName = GameInfo.Resources[typeIdx]?.ResourceType ?? `Unknown(${typeIdx})`;
			console.log(`  ${resName}: ${eligible} eligible tiles`);
		}
		console.log(`Resource density calculation (${nonOceanTileCount} non-ocean tiles, densityTarget=${densityTarget}):`);
		for (const typeIdx of resourceSet.activeResourceIndices) {
			const def = GameInfo.Resources[typeIdx];
			if (!def) continue;
			const desired = blueNoisePlan.metrics.resourceDesiredCount[typeIdx];
			const weight = resourceSet.resourceWeight[typeIdx];
			const eligible = blueNoisePlan.metrics.resourceEligibleTileCounts[typeIdx];
			const guaranteed = blueNoisePlan.metrics.resourceMinimumPerLandmass[typeIdx];
			console.log(`  ${def.ResourceType}: desired=${desired.toFixed(2)}, weight=${weight.toFixed(2)}, min=${guaranteed}, eligible=${eligible}`);
		}
	}
	calculateDensityScope.end();
	const placementScope = new profileScope("generateResources Placement");
	const seed = GameplayMap.getRandomSeed();
	const offsetX = seed & 127;
	const offsetY = seed >>> 7 & 127;

	// --- ZG: every placement is a candidate patch seed. onResourcePlaced is the
	// base game's own hook, so this costs one push per deposit and no extra scan. ---
	const seeds = [];
	placeResourcesWithBlueNoise(ctx, resourceSet, blueNoisePlan, {
		offsetX,
		offsetY,
		onResourcePlaced: (x, y, resourceIdx) => seeds.push({ x, y, resourceIdx }),
	});
	growClusters(seeds, resourceSet, resources.chance, resources.max);
	// --- end ZG ---

	placementScope.end();
	const replacementScope = new profileScope("generateResources Replacement");
	const definition = GameInfo.Ages.lookup(Game.age);
	if (definition) {
		const mapType = Configuration.getMapValue("Name");
		for (const option of GameInfo.MapIslandBehavior) {
			if (option.MapType != mapType || option.AgeType != definition.AgeType) continue;
			// The base game scans the whole map twice here to log island resource
			// counts before and after. The replacement itself is unchanged; only
			// those two logging scans are left out.
			replaceIslandResources(iWidth, iHeight, option.ResourceClassType);
		}
	}
	replacementScope.end();
}
