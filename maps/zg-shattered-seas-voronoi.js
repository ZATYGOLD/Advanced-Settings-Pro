// Copy of {base-standard}maps/shattered-seas-voronoi.js with a tier-aware river model;
// imports are repointed at the base module so everything else stays stock.
import { zgModelRivers } from './zg-map-rivers.js';
import { zgMountainsDisabled } from './zg-map-mountains.js';
import { zgGenerateLakes } from './zg-map-lakes.js';
import { assignAdvancedStartRegions } from 'fs://game/base-standard/maps/assign-advanced-start-region.js';
import { PlayerRegion, assignStartPositionsFromTiles } from 'fs://game/base-standard/maps/assign-starting-plots.js';
import { generateDiscoveries } from 'fs://game/base-standard/maps/discovery-generator.js';
import { generateLakes, addHills, buildRainfallMap } from 'fs://game/base-standard/maps/elevation-terrain-generator.js';
import { designateBiomes, addFeatures } from 'fs://game/base-standard/maps/feature-biome-generator.js';
import { dumpContinents, dumpTerrain, dumpElevation, dumpRainfall, dumpBiomes, dumpFeatures, dumpResources } from 'fs://game/base-standard/maps/map-debug-helpers.js';
import { g_FlatTerrain, g_CoastTerrain, g_OceanTerrain, g_HillTerrain, g_MountainTerrain, g_VolcanoFeature, g_NavigableRiverTerrain, g_PolarWaterRows } from 'fs://game/base-standard/maps/map-globals.js';
import { addNaturalWonders } from 'fs://game/base-standard/maps/natural-wonder-generator.js';
import { generateResources } from 'fs://game/base-standard/maps/resource-generator.js';
import { generateSnow, dumpPermanentSnow } from 'fs://game/base-standard/maps/snow-generator.js';
import { TerrainType } from 'fs://game/base-standard/scripts/voronoi-types.js';
import { VoronoiShatteredSeas } from 'fs://game/base-standard/scripts/voronoi_maps/shattered-seas.js';

console.log("Generating using script shattered-seas-voronoi.ts");
function requestMapData(initParams) {
  console.log(initParams.width);
  console.log(initParams.height);
  console.log(initParams.topLatitude);
  console.log(initParams.bottomLatitude);
  console.log(initParams.wrapX);
  console.log(initParams.wrapY);
  console.log(initParams.mapSize);
  engine.call("SetMapInitData", initParams);
}
async function generateMap() {
  console.log("Generating a map!");
  console.log(`Age - ${GameInfo.Ages.lookup(Game.age).AgeType}`);
  const iWidth = GameplayMap.getGridWidth();
  const iHeight = GameplayMap.getGridHeight();
  const uiMapSize = GameplayMap.getMapSize();
  const mapInfo = GameInfo.Maps.lookup(uiMapSize);
  if (mapInfo == null) return;
  const iNumNaturalWonders = mapInfo.NumNaturalWonders;
  const iTilesPerLake = mapInfo.LakeGenerationFrequency;
  const iTotalPlayers = Players.getAliveMajorIds().length;
  const startTime = Date.now();
  const voronoiMap = new VoronoiShatteredSeas();
  voronoiMap.setPrimaryMapSetting(["totalPlayers"], iTotalPlayers);
  const seaLevelType = Configuration.getMapValue("SeaLevel");
  console.log(`Sea Level - ${seaLevelType}`);
  switch (seaLevelType) {
    case "SEA_LEVEL_LOW":
      voronoiMap.setSelectedVariantKey("Sea Level", "Low");
      break;
    case "SEA_LEVEL_HIGH":
      voronoiMap.setSelectedVariantKey("Sea Level", "High");
      break;
  }
  voronoiMap.init({ x: iWidth, y: iHeight });
  voronoiMap.simulate();
  const tiles = voronoiMap.getHexTiles().getTiles();
  for (let y = 0; y < tiles.length; ++y) {
    for (let x = 0; x < tiles[y].length; ++x) {
      const tile = tiles[y][x];
      if (tile.playerLandmassId === 0) {
        TerrainBuilder.addPlotTag(x, y, PlotTags.PLOT_TAG_ISLAND);
      } else {
        TerrainBuilder.setLandmassRegionId(x, y, 1);
      }
      const type = (() => {
        switch (tile.terrainType) {
          case TerrainType.Flat:
            return g_FlatTerrain;
          case TerrainType.Mountainous:
            return zgMountainsDisabled() ? g_HillTerrain : g_MountainTerrain;
          case TerrainType.Volcano:
            return zgMountainsDisabled() ? g_HillTerrain : g_MountainTerrain;
          case TerrainType.Rough:
            return g_HillTerrain;
          case TerrainType.Ocean:
            return g_OceanTerrain;
          case TerrainType.Coast:
            return g_CoastTerrain;
          default:
            return g_FlatTerrain;
        }
      })();
      TerrainBuilder.setTerrainType(x, y, type);
      if (tile.terrainType === TerrainType.Volcano && !zgMountainsDisabled()) {
        TerrainBuilder.setFeatureType(x, y, {
          Feature: g_VolcanoFeature,
          Direction: -1,
          Elevation: 0
        });
      }
    }
  }
  const endTime = Date.now();
  console.log(`Initial Voronoi map generation took ${endTime - startTime} ms`);
  TerrainBuilder.validateAndFixTerrain();
  AreaBuilder.recalculateAreas();
  TerrainBuilder.stampContinents();
  zgGenerateLakes(iWidth, iHeight, iTilesPerLake);
  AreaBuilder.recalculateAreas();
  TerrainBuilder.buildElevation();
  addHills(iWidth, iHeight);
  buildRainfallMap(iWidth, iHeight);
  zgModelRivers(5, 15);
  TerrainBuilder.validateAndFixTerrain();
  TerrainBuilder.defineNamedRivers();
  designateBiomes(iWidth, iHeight);
  addNaturalWonders(iWidth, iHeight, iNumNaturalWonders);
  TerrainBuilder.addFloodplains(4, 10);
  addFeatures(iWidth, iHeight);
  TerrainBuilder.validateAndFixTerrain();
  AreaBuilder.recalculateAreas();
  TerrainBuilder.storeWaterData();
  generateSnow(iWidth, iHeight);
  dumpContinents(iWidth, iHeight);
  dumpTerrain(iWidth, iHeight);
  dumpElevation(iWidth, iHeight);
  dumpRainfall(iWidth, iHeight);
  dumpBiomes(iWidth, iHeight);
  dumpFeatures(iWidth, iHeight);
  dumpPermanentSnow(iWidth, iHeight);
  generateResources(iWidth, iHeight, 5);
  let startPositions = [];
  const fertilityGetter = (tile) => StartPositioner.getPlotFertilityForCoord(tile.coord.x, tile.coord.y);
  voronoiMap.createMajorPlayerAreas(fertilityGetter);
  const playerRegions = Array.from({ length: iTotalPlayers }, () => new PlayerRegion());
  playerRegions.forEach((region, index) => {
    region.regionId = index;
  });
  console.log(`Creating player regions.. initializing indices: ${playerRegions.map((pr) => pr.regionId)}`);
  for (const row of tiles) {
    for (const tile of row) {
      if (tile.majorPlayerRegionId >= 0 && tile.landmassId > 0) {
        const regionId = tile.majorPlayerRegionId;
        const playerRegion = playerRegions[regionId];
        playerRegion.tiles.push({ x: tile.coord.x, y: tile.coord.y });
      }
    }
  }
  playerRegions.forEach((region) => {
    console.log(`  Region ${region.regionId} in landmass ${region.landmassId} with ${region.tiles.length} tiles.`);
  });
  startPositions = assignStartPositionsFromTiles(playerRegions);
  generateDiscoveries(iWidth, iHeight, startPositions, g_PolarWaterRows);
  dumpResources(iWidth, iHeight);
  FertilityBuilder.recalculate();
  assignAdvancedStartRegions();
  const PlayerList = Players.getAlive();
  for (const player of PlayerList) {
    if (player.isValid && player.isMajor && player.isAI) {
      const playerAI = player.AI;
      playerAI?.scaleAiPreference("PseudoYieldBiases", "PSEUDOYIELD_STANDING_NAVY_UNIT", 200);
    }
  }
}
engine.on("RequestMapInitData", requestMapData);
engine.on("GenerateMap", generateMap);
