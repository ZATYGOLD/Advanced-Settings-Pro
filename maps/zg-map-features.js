// Feature pass that applies the mod's climate (zg-map-climate.js).
// Port of {base-standard}maps/feature-biome-generator.js addFeatures.
//
// Sea ice, reefs, and open-water features read the Heat Source latitude plus
// the Map Temperature shift, so a colder step pushes ice toward the equator and
// a hotter one carries reefs toward the poles. Land features follow the biomes
// and are placed as in the base. Every random roll keeps the base order, so a
// Standard map matches the base exactly.
import { isAdjacentToNaturalWonder } from 'fs://game/base-standard/maps/map-utilities.js';
import { zgClimate } from './zg-map-climate.js';

const ICE_LATITUDE_MIN = 78;
const ATOLL_GROWTH_LATITUDE = 15;

// Feature latitude: distance from the equator plus the temperature shift, never
// below the equator itself. Ice keeps the base game's southern hemisphere
// offset of 5 degrees.
function featureLatitude(iX, iY, southOffset = 0) {
	const { latitude, shift } = zgClimate();
	const signed = latitude(iX, iY);
	return Math.max(0, (signed < 0 ? -signed - southOffset : signed) + shift);
}

function canPlace(iX, iY, featIdx, placementClass) {
	return GameInfo.Features[featIdx].PlacementClass == placementClass && TerrainBuilder.canHaveFeature(iX, iY, featIdx);
}

// The first feature of a class the tile can take, or -1.
function firstPlaceable(iX, iY, placementClass, accept = () => true) {
	for (let featIdx = 0; featIdx < GameInfo.Features.length; featIdx++) {
		if (canPlace(iX, iY, featIdx, placementClass) && accept(featIdx)) {
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
const inLatitude = (featIdx, latitude) => GameInfo.Features[featIdx].MinLatitude <= latitude && GameInfo.Features[featIdx].MaxLatitude > latitude;

function forEachTile(iWidth, iHeight, visit) {
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			visit(iX, iY);
		}
	}
}

function addPositionalFeatures(iWidth, iHeight) {
	forEachTile(iWidth, iHeight, (iX, iY) => {
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
			featIdx = firstPlaceable(iX, iY, "ISOLATED", (candidate) => !GameplayMap.isAdjacentToFeature(iX, iY, candidate));
		}
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, 100, "Feature Scatter");
		}
	});
}

function scatterFeatures(iWidth, iHeight) {
	forEachTile(iWidth, iHeight, (iX, iY) => {
		const featIdx = isOpenLand(iX, iY) ? firstPlaceable(iX, iY, "SCATTER") : -1;
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, 100, "Feature Scatter");
		}
	});
}

function addIce(iWidth, iHeight) {
	forEachTile(iWidth, iHeight, (iX, iY) => {
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
	forEachTile(iWidth, iHeight, (iX, iY) => {
		if (!isOpenWater(iX, iY)) {
			return;
		}
		const latitude = featureLatitude(iX, iY);
		const featIdx = firstPlaceable(iX, iY, "REEF", (candidate) => inLatitude(candidate, latitude));
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, (latitude + 50) * 2, "Feature Reef");
		}
	});
}

function addOpenWaterFeatures(iWidth, iHeight) {
	const skipPlotIndices = [];
	let skipPlot = false;
	forEachTile(iWidth, iHeight, (iX, iY) => {
		// Kept as the base has it: a grown atoll skips any later tile in its column
		// past the first row, so the rolls stay in the base order.
		for (const skipPlotIndex of skipPlotIndices) {
			const plot = GameplayMap.getLocationFromIndex(skipPlotIndex);
			if (plot.x == iX && plot.y && iY) {
				skipPlot = true;
				break;
			}
		}
		if (skipPlot) {
			skipPlot = false;
			return;
		}
		if (!isOpenWater(iX, iY)) {
			return;
		}
		const latitude = featureLatitude(iX, iY);
		const featIdx = firstPlaceable(iX, iY, "OPEN_WATERS", (candidate) => inLatitude(candidate, latitude));
		if (featIdx < 0 || !shallowWaterAdjacencyCheck(iX, iY, "Feature Atoll Spawn Chance")) {
			return;
		}
		addFeature(iX, iY, featIdx, 100, "Feature Atoll");
		const neighbors = GameplayMap.getPlotIndicesInRadius(iX, iY, 1);
		const clusterSize = TerrainBuilder.getRandomNumber(neighbors.length, "Feature Atoll Size");
		const growthChancePercent = latitude <= ATOLL_GROWTH_LATITUDE ? 15 : 5;
		for (let plotIndex = 0; plotIndex < clusterSize; ++plotIndex) {
			const location = GameplayMap.getLocationFromIndex(neighbors[plotIndex]);
			if (canPlace(location.x, location.y, featIdx, "OPEN_WATERS")
				&& shallowWaterAdjacencyCheck(location.x, location.y, "Feature Atoll Spawn Chance")
				&& TerrainBuilder.getRandomNumber(100, "Feature Atoll") < growthChancePercent) {
				addFeature(location.x, location.y, featIdx, 30, "Feature Atoll");
				skipPlotIndices.push(neighbors[plotIndex]);
			}
		}
	});
}

function addLakeFeatures(iWidth, iHeight) {
	forEachTile(iWidth, iHeight, (iX, iY) => {
		const featIdx = isOpenWater(iX, iY) ? firstPlaceable(iX, iY, "IN_LAKE") : -1;
		if (featIdx >= 0) {
			addFeature(iX, iY, featIdx, 100, "Feature Lotus");
		}
	});
}

export function zgAddFeatures(iWidth, iHeight) {
	console.log("Features");
	addPositionalFeatures(iWidth, iHeight);
	scatterFeatures(iWidth, iHeight);
	addIce(iWidth, iHeight);
	addReefs(iWidth, iHeight);
	addOpenWaterFeatures(iWidth, iHeight);
	addLakeFeatures(iWidth, iHeight);
}
