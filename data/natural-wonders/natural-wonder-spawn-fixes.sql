--=============================================================================================================
-- Natural Wonder Spawn Fixes
--=============================================================================================================
-- Gullfoss, Iguazu Falls, and Valley of Flowers get relaxed placement requirements so that
-- they can successfully spawn more often. As of now, they nearly always fail because of their strict requirements.
---------------------------------------------------------------------------------------------------------------
-- TypeTags: Valley of Flowers can spawn near coast
---------------------------------------------------------------------------------------------------------------
DELETE FROM TypeTags
WHERE		Type = 'FEATURE_VALLEY_OF_FLOWERS'
and			Tag = 'NOTNEARCOAST';
---------------------------------------------------------------------------------------------------------------
-- Feature_ValidBiomes: Expand biomes for Valley of Flowers, Iguazu Falls, and Gullfoss
---------------------------------------------------------------------------------------------------------------
INSERT OR IGNORE INTO Feature_ValidBiomes
		(FeatureType,					BiomeType,			ReplaceRange,	ReplaceWithBiomeType)
VALUES	('FEATURE_VALLEY_OF_FLOWERS',	'BIOME_GRASSLAND',	NULL,			NULL),
		('FEATURE_VALLEY_OF_FLOWERS',	'BIOME_TUNDRA',		NULL,			NULL),
		('FEATURE_IGUAZU_FALLS',		'BIOME_GRASSLAND',	NULL,			NULL),
		('FEATURE_IGUAZU_FALLS',		'BIOME_PLAINS',		NULL,			NULL),
		('FEATURE_GULLFOSS',			'BIOME_PLAINS',		1,				'BIOME_TUNDRA');
---------------------------------------------------------------------------------------------------------------
-- TerrainBiomeFeature_YieldChanges: Add yields for the new biomes enabled above, mirroring the normal yields.
---------------------------------------------------------------------------------------------------------------
-- Valley of Flowers
INSERT OR IGNORE INTO TerrainBiomeFeature_YieldChanges
		(FeatureType,					BiomeType,			TerrainType,	YieldType,	ScaleByGameAge,	YieldChange)
SELECT	'FEATURE_VALLEY_OF_FLOWERS',	'BIOME_GRASSLAND',	TerrainType,	YieldType,	ScaleByGameAge,	YieldChange
FROM	TerrainBiomeFeature_YieldChanges
WHERE	FeatureType = 'FEATURE_VALLEY_OF_FLOWERS';

INSERT OR IGNORE INTO TerrainBiomeFeature_YieldChanges
		(FeatureType,					BiomeType,		TerrainType,	YieldType,	ScaleByGameAge,	YieldChange)
SELECT	'FEATURE_VALLEY_OF_FLOWERS',	'BIOME_TUNDRA',	TerrainType,	YieldType,	ScaleByGameAge,	YieldChange
FROM	TerrainBiomeFeature_YieldChanges
WHERE	FeatureType = 'FEATURE_VALLEY_OF_FLOWERS';

-- Iguazu Falls
INSERT OR IGNORE INTO TerrainBiomeFeature_YieldChanges
		(FeatureType,					BiomeType,			TerrainType,	YieldType,	ScaleByGameAge,	YieldChange)
SELECT	'FEATURE_IGUAZU_FALLS',			'BIOME_GRASSLAND',	TerrainType,	YieldType,	ScaleByGameAge,	YieldChange
FROM	TerrainBiomeFeature_YieldChanges
WHERE	FeatureType = 'FEATURE_IGUAZU_FALLS';

INSERT OR IGNORE INTO TerrainBiomeFeature_YieldChanges
		(FeatureType,					BiomeType,		TerrainType,	YieldType,	ScaleByGameAge,	YieldChange)
SELECT	'FEATURE_IGUAZU_FALLS',			'BIOME_PLAINS',	TerrainType,	YieldType,	ScaleByGameAge,	YieldChange
FROM	TerrainBiomeFeature_YieldChanges
WHERE	FeatureType = 'FEATURE_IGUAZU_FALLS';

-- Gullfoss
-- Not needed because it turns its biome into Tundra.
