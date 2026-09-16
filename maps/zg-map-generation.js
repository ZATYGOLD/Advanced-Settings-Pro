// Copy of {base-standard}scripts/common-generation.js generateMapFeatures with the
// mod's tier-aware river model and biome pass substituted in; every other phase
// stays stock and is imported from the base module.
//
// The base game consolidated the Voronoi maps' terrain generation into this one
// helper. The Voronoi map copies call zgGenerateMapFeatures instead of the base
// generateMapFeatures so the Rivers and Biome settings still apply, while the
// phase order, profiling and GenerationContext behaviour match the base exactly.
import { addHills, buildRainfallMap } from 'fs://game/base-standard/maps/elevation-terrain-generator.js';
import { addFeatures } from 'fs://game/base-standard/maps/feature-biome-generator.js';
import { dumpContinents, dumpTerrain, dumpElevation, dumpRainfall, dumpBiomes, dumpFeatures, dumpResources } from 'fs://game/base-standard/maps/map-debug-helpers.js';
import { addNaturalWonders } from 'fs://game/base-standard/maps/natural-wonder-generator.js';
import { generateResources } from 'fs://game/base-standard/maps/resource-generator.js';
import { generateSnow, dumpPermanentSnow } from 'fs://game/base-standard/maps/snow-generator.js';
import { GenerationContext, GenerationPhases } from 'fs://game/base-standard/scripts/common-generation.js';
import { profileScope, profileFunction } from 'fs://game/base-standard/scripts/profiling.js';
import { zgModelRivers } from './zg-map-rivers.js';
import { zgDesignateBiomes } from './zg-map-biomes.js';
import { zgAdjustHexMountains } from './zg-map-mountains.js';

export async function zgGenerateMapFeatures(hexMap, context = new GenerationContext()) {
  const generateMapFeaturesScope = new profileScope("Generate Features");
  const iWidth = GameplayMap.getGridWidth();
  const iHeight = GameplayMap.getGridHeight();
  const uiMapSize = GameplayMap.getMapSize();
  const mapInfo = GameInfo.Maps.lookup(uiMapSize);
  if (mapInfo == null) return;
  const iNumNaturalWonders = mapInfo.NumNaturalWonders;
  if (context.phases & GenerationPhases.Lakes) {
    profileFunction("generateLakes", () => hexMap.GenerateLakes());
  }
  if (context.phases & GenerationPhases.WriteToTerrainBuilder) {
    // ZG-ASP: apply the Mountains setting to the simulated tiles before they
    // are written out, since these maps never call addMountains.
    profileFunction("zgAdjustHexMountains", () => zgAdjustHexMountains(hexMap));
    hexMap.writeToTerrainBuilder();
  }
  profileFunction("TerrainBuilder.validateAndFixTerrain", () => TerrainBuilder.validateAndFixTerrain());
  profileFunction("AreaBuilder.recalculateAreas", () => AreaBuilder.recalculateAreas());
  if (context.phases & GenerationPhases.Continents) {
    profileFunction("TerrainBuilder.stampContinents", () => TerrainBuilder.stampContinents());
  }
  profileFunction("AreaBuilder.recalculateAreas", () => AreaBuilder.recalculateAreas());
  if (context.phases & GenerationPhases.Elevation) {
    profileFunction("TerrainBuilder.buildElevation", () => TerrainBuilder.buildElevation());
  }
  if (context.phases & GenerationPhases.Hills) {
    profileFunction("addHills", () => addHills(iWidth, iHeight));
  }
  if (context.phases & GenerationPhases.Rainfall) {
    profileFunction("buildRainfallMap", () => buildRainfallMap(iWidth, iHeight));
  }
  if (context.phases & GenerationPhases.Rivers) {
    // ZG-ASP: tier-aware river model in place of TerrainBuilder.modelRivers.
    profileFunction("zgModelRivers", () => zgModelRivers(5, 15));
  } else {
    profileFunction(
      "TerrainBuilder.finalizeRivers",
      () => TerrainBuilder.finalizeRivers(
        context.bRunAestheticRiverValidation,
        context.largeRiverPercent,
        context.minNavRiverLength,
        context.minUpstreamMinorRivers
      )
    );
  }
  if (context.phases & GenerationPhases.Biomes) {
    // ZG-ASP: biome pass that applies the mod's biome setting.
    profileFunction("zgDesignateBiomes", () => zgDesignateBiomes(iWidth, iHeight));
  }
  if (context.phases & GenerationPhases.NaturalWonders) {
    profileFunction("addNaturalWonders", () => addNaturalWonders(iWidth, iHeight, iNumNaturalWonders));
  }
  if (context.phases & GenerationPhases.FloodPlains) {
    profileFunction("TerrainBuilder.addFloodplains", () => TerrainBuilder.addFloodplains(4, 10));
  }
  if (context.phases & GenerationPhases.Features) {
    profileFunction("addFeatures", () => addFeatures(iWidth, iHeight));
  }
  profileFunction("TerrainBuilder.validateAndFixTerrain", () => TerrainBuilder.validateAndFixTerrain());
  profileFunction("AreaBuilder.recalculateAreas", () => AreaBuilder.recalculateAreas());
  profileFunction("TerrainBuilder.storeWaterData", () => TerrainBuilder.storeWaterData());
  if (context.phases & GenerationPhases.Snow) {
    profileFunction("generateSnow", () => generateSnow(iWidth, iHeight));
  }
  if (context.phases & GenerationPhases.Resources) {
    profileFunction("generateResources", () => generateResources(iWidth, iHeight));
  }
  dumpContinents(iWidth, iHeight);
  dumpTerrain(iWidth, iHeight);
  dumpElevation(iWidth, iHeight);
  dumpRainfall(iWidth, iHeight);
  dumpBiomes(iWidth, iHeight);
  dumpFeatures(iWidth, iHeight);
  dumpPermanentSnow(iWidth, iHeight);
  dumpResources(iWidth, iHeight);
  generateMapFeaturesScope.end();
}
