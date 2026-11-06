--*******************************************************
--************* MAP SCRIPT REDIRECTS ********************
--*******************************************************
-- Points every standard map at this mod's copy of its script (zg-<name>.js),
-- which applies the mod's map settings. Start positions, the Sea Level
-- dependencies, and the per-map Sea Level rows (Key1 'Map', Key2 the file;
-- only the Voronoi maps carry them) follow the new path.

UPDATE Maps
SET File = REPLACE(File, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-')
WHERE File IN (
	'{base-standard}maps/archipelago.js',
	'{base-standard}maps/archipelago-voronoi.js',
	'{base-standard}maps/continents.js',
	'{base-standard}maps/continents-plus.js',
	'{base-standard}maps/continents-voronoi.js',
	'{base-standard}maps/fractal.js',
	'{base-standard}maps/fractal-voronoi.js',
	'{base-standard}maps/pangaea-plus.js',
	'{base-standard}maps/pangaea-voronoi.js',
	'{base-standard}maps/shattered-seas-voronoi.js',
	'{base-standard}maps/shuffle.js',
	'{base-standard}maps/shuffle-voronoi.js',
	'{base-standard}maps/terra-incognita.js',
	'{base-standard}maps/terra-incognita-voronoi.js'
);

UPDATE SupportedValuesByMap
SET Map = REPLACE(Map, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-')
WHERE Map IN (
	'{base-standard}maps/archipelago.js',
	'{base-standard}maps/archipelago-voronoi.js',
	'{base-standard}maps/continents.js',
	'{base-standard}maps/continents-plus.js',
	'{base-standard}maps/continents-voronoi.js',
	'{base-standard}maps/fractal.js',
	'{base-standard}maps/fractal-voronoi.js',
	'{base-standard}maps/pangaea-plus.js',
	'{base-standard}maps/pangaea-voronoi.js',
	'{base-standard}maps/shattered-seas-voronoi.js',
	'{base-standard}maps/shuffle.js',
	'{base-standard}maps/shuffle-voronoi.js',
	'{base-standard}maps/terra-incognita.js',
	'{base-standard}maps/terra-incognita-voronoi.js'
);

UPDATE ParameterDependencies
SET ConfigurationValue = REPLACE(ConfigurationValue, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-')
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue IN (
	'{base-standard}maps/archipelago.js',
	'{base-standard}maps/archipelago-voronoi.js',
	'{base-standard}maps/continents.js',
	'{base-standard}maps/continents-plus.js',
	'{base-standard}maps/continents-voronoi.js',
	'{base-standard}maps/fractal.js',
	'{base-standard}maps/fractal-voronoi.js',
	'{base-standard}maps/pangaea-plus.js',
	'{base-standard}maps/pangaea-voronoi.js',
	'{base-standard}maps/shattered-seas-voronoi.js',
	'{base-standard}maps/shuffle.js',
	'{base-standard}maps/shuffle-voronoi.js',
	'{base-standard}maps/terra-incognita.js',
	'{base-standard}maps/terra-incognita-voronoi.js'
);

UPDATE Parameters
SET Key2 = REPLACE(Key2, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-')
WHERE Key1 = 'Map' AND Key2 IN (
	'{base-standard}maps/archipelago.js',
	'{base-standard}maps/archipelago-voronoi.js',
	'{base-standard}maps/continents.js',
	'{base-standard}maps/continents-plus.js',
	'{base-standard}maps/continents-voronoi.js',
	'{base-standard}maps/fractal.js',
	'{base-standard}maps/fractal-voronoi.js',
	'{base-standard}maps/pangaea-plus.js',
	'{base-standard}maps/pangaea-voronoi.js',
	'{base-standard}maps/shattered-seas-voronoi.js',
	'{base-standard}maps/shuffle.js',
	'{base-standard}maps/shuffle-voronoi.js',
	'{base-standard}maps/terra-incognita.js',
	'{base-standard}maps/terra-incognita-voronoi.js'
);
