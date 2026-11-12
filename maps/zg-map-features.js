// Feature pass that applies the mod's climate (zg-map-climate.js).
// Port of {base-standard}maps/feature-biome-generator.js addFeatures.
//
// Sea ice, reefs, and open-water features read the Map Zones latitude plus
// the Map Temperature shift, so a colder step pushes ice toward the equator and
// a hotter one carries reefs toward the poles. Land features follow the biomes
// and are placed as in the base. Every random roll keeps the base order, so a
// Standard map matches the base exactly. With Climate Controls enabled, its
// feature pass runs instead.
import { addFeatures } from 'fs://game/base-standard/maps/feature-biome-generator.js';
import { isAdjacentToNaturalWonder } from 'fs://game/base-standard/maps/map-utilities.js';
import { zgClimate, zgClimateControlActive } from './zg-map-climate.js';
import { zgForEachTile } from './zg-map-utils.js';

const ICE_LATITUDE_MIN = 78;
const ATOLL_GROWTH_LATITUDE = 15;

// Set once per map by zgAddFeatures: the climate, and each placement class's
// features in ascending index order, so a tile tests only its own class.
let climate = null;
let featuresByClass = null;

function indexFeaturesByClass() {
	const byClass = new Map();
	for (let featIdx = 0; featIdx < GameInfo.Features.length; featIdx++) {
		const placementClass = GameInfo.Features[featIdx].PlacementClass;
		byClass.set(placementClass, [...(byClass.get(placementClass) ?? []), featIdx]);
	}
	return byClass;
}

// Feature latitude: distance from the equator plus the temperature shift, never
// below the equator itself. Ice keeps the base game's southern hemisphere
// offset of 5 degrees.
function featureLatitude(iX, iY, southOffset = 0) {
	const signed = climate.latitude(iX, iY);
	return Math.max(0, (signed < 0 ? -signed - southOffset : signed) + climate.shift);
}

const inLatitude = (featIdx, latitude) => GameInfo.Features[featIdx].MinLatitude <= latitude && GameInfo.Features[featIdx].MaxLatitude > latitude;

// The first feature of a class the tile can take, or -1. Given a latitude, the
// feature's band must hold it; an isolated feature keeps away from its own kind.
function firstPlaceable(iX, iY, placementClass, latitude = null, isolated = false) {
	for (const featIdx of featuresByClass.get(placementClass) ?? []) {
		if (TerrainBuilder.canHaveFeature(iX, iY, featIdx)
			&& (latitude == null || inLatitude(featIdx, latitude))
			&& (!isolated || !GameplayMap.isAdjacentToFeature(iX, iY, featIdx))) {
			return featIdx;
		}
	}
	return -1;
}

function setFeature(iX, iY, featIdx) {
	TerrainBuilder.setFeatureType(iX, iY, { Feature: featIdx, Direction: -1, Elevation: 0 });
}

function addFeature(iX, iY, featIdx, iRandomRollMax, logMsg) {
	if (TerrainBuilder.getRandomNumber(iRandomRollMax, logMsg) < GameInfo.Features[featIdx].PlacementDensity) {
		setFeature(iX, iY, featIdx);
	}
}

function shallowWaterAdjacencyCheck(iX, iY, log) {
	return !GameplayMap.isAdjacentToShallowWater(iX, iY) || TerrainBuilder.getRandomNumber(100, log) < 30;
}

const isOpenLand = (iX, iY) => !GameplayMap.isWater(iX, iY) && GameplayMap.getFeatureType(iX, iY) == FeatureTypes.NO_FEATURE && !GameplayMap.isNavigableRiver(iX, iY);
const isOpenWater = (iX, iY) => GameplayMap.isWater(iX, iY) && GameplayMap.getFeatureType(iX, iY) == FeatureTypes.NO_FEATURE;

function addPositionalFeatures(iWidth, iHeight) {
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		if (!isOpenLand(iX, iY)) {
			return;
		}
		let featIdx;
		if (GameplayMap.isCoastalLand(iX, iY)) {
			featIdx = firstPlaceable(iX, iY, "COASTAL");
		} else if (GameplayMap.isAdjacentToRivers(iX, iY, 2)) {
			featIdx = firstPlaceable(iX, iY, "NEARRIVER");
		} else if (GameplayMap.isAdjacentToRivers(iX, iY, 1)) {
			return;
		} else {
			featIdx = firstPlaceable(iX, iY, "ISOLATED", null, true);
		}
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, 100, "Feature Scatter");
		}
	});
}

function scatterFeatures(iWidth, iHeight) {
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		const featIdx = isOpenLand(iX, iY) ? firstPlaceable(iX, iY, "SCATTER") : -1;
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, 100, "Feature Scatter");
		}
	});
}

function addIce(iWidth, iHeight) {
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		if (!isOpenWater(iX, iY)) {
			return;
		}
		const latitude = featureLatitude(iX, iY, 5);
		if (latitude <= ICE_LATITUDE_MIN) {
			return;
		}
		const featIdx = firstPlaceable(iX, iY, "ICE");
		if (featIdx < 0) {
			return;
		}
		let iScore = TerrainBuilder.getRandomNumber(100, "Feature Ice") + latitude;
		if (GameplayMap.isAdjacentToLand(iX, iY) || isAdjacentToNaturalWonder(iX, iY)) {
			iScore = 0;
		}
		if (iScore > GameInfo.Features[featIdx].PlacementDensity) {
			setFeature(iX, iY, featIdx);
		}
	});
}

function addReefs(iWidth, iHeight) {
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		if (!isOpenWater(iX, iY)) {
			return;
		}
		const latitude = featureLatitude(iX, iY);
		const featIdx = firstPlaceable(iX, iY, "REEF", latitude);
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, (latitude + 50) * 2, "Feature Reef");
		}
	});
}

function addOpenWaterFeatures(iWidth, iHeight) {
	// Kept as the base has it: a grown atoll off the first row skips every later
	// tile in its column past the first row, so the rolls stay in the base order.
	const skipColumns = new Set();
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		if (iY && skipColumns.has(iX)) {
			return;
		}
		if (!isOpenWater(iX, iY)) {
			return;
		}
		const latitude = featureLatitude(iX, iY);
		const featIdx = firstPlaceable(iX, iY, "OPEN_WATERS", latitude);
		if (featIdx < 0 || !shallowWaterAdjacencyCheck(iX, iY, "Feature Atoll Spawn Chance")) {
			return;
		}
		addFeature(iX, iY, featIdx, 100, "Feature Atoll");
		const neighbors = GameplayMap.getPlotIndicesInRadius(iX, iY, 1);
		const clusterSize = TerrainBuilder.getRandomNumber(neighbors.length, "Feature Atoll Size");
		const growthChancePercent = latitude <= ATOLL_GROWTH_LATITUDE ? 15 : 5;
		for (let plotIndex = 0; plotIndex < clusterSize; ++plotIndex) {
			const location = GameplayMap.getLocationFromIndex(neighbors[plotIndex]);
			if (TerrainBuilder.canHaveFeature(location.x, location.y, featIdx)
				&& shallowWaterAdjacencyCheck(location.x, location.y, "Feature Atoll Spawn Chance")
				&& TerrainBuilder.getRandomNumber(100, "Feature Atoll") < growthChancePercent) {
				addFeature(location.x, location.y, featIdx, 30, "Feature Atoll");
				if (location.y) {
					skipColumns.add(location.x);
				}
			}
		}
	});
}

function addLakeFeatures(iWidth, iHeight) {
	zgForEachTile(iWidth, iHeight, (iX, iY) => {
		const featIdx = isOpenWater(iX, iY) ? firstPlaceable(iX, iY, "IN_LAKE") : -1;
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, 100, "Feature Lotus");
		}
	});
}

export function zgAddFeatures(iWidth, iHeight) {
	if (zgClimateControlActive()) {
		addFeatures(iWidth, iHeight);
		return;
	}
	console.log("Features");
	climate = zgClimate();
	featuresByClass = indexFeaturesByClass();
	addPositionalFeatures(iWidth, iHeight);
	scatterFeatures(iWidth, iHeight);
	addIce(iWidth, iHeight);
	addReefs(iWidth, iHeight);
	addOpenWaterFeatures(iWidth, iHeight);
	addLakeFeatures(iWidth, iHeight);
}
