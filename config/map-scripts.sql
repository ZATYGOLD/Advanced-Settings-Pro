--*******************************************************
--************* MAP SCRIPT COPIES ***********************
--*******************************************************
-- Single player plays this mod's copy of each standard map (zg-<name>.js),
-- which applies the mod's map settings; multiplayer and hotseat keep the base
-- scripts. Each copy joins the map list as a row of its own, carrying the base
-- map's start positions, Sea Level dependencies and per-map Sea Level rows
-- (Key1 'Map', Key2 the file; only the Voronoi maps have them), and each mode
-- filters the other's scripts out of the list.

INSERT OR IGNORE INTO Maps (Domain, File, Name, Description, Image, StaticMap, WorldBuilderOnly, SortIndex)
SELECT Domain, REPLACE(File, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-'), Name, Description, Image, StaticMap, WorldBuilderOnly, SortIndex
FROM Maps
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

INSERT INTO SupportedValuesByMap (Map, PlayerID, Domain, Value)
SELECT REPLACE(Map, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-'), PlayerID, Domain, Value
FROM SupportedValuesByMap
WHERE Map IN (SELECT REPLACE(File, '{AdvancedSettingsPro}maps/zg-', '{base-standard}maps/') FROM Maps WHERE File LIKE '{AdvancedSettingsPro}maps/zg-%');

INSERT INTO ParameterDependencies (ParameterID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
SELECT ParameterID, ConfigurationGroup, ConfigurationKey, Operator, REPLACE(ConfigurationValue, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-')
FROM ParameterDependencies
WHERE ConfigurationKey = 'MapScript'
AND ConfigurationValue IN (SELECT REPLACE(File, '{AdvancedSettingsPro}maps/zg-', '{base-standard}maps/') FROM Maps WHERE File LIKE '{AdvancedSettingsPro}maps/zg-%');

INSERT INTO Parameters (Key1, Key2, ParameterID, Name, Description, Domain, Hash, Array, DefaultValue, ConfigurationGroup, ConfigurationKey, DomainConfigurationKey, PossibleValuesConfigurationKey, ValueConfigurationKey, ValueNameConfigurationKey, ValueHashConfigurationKey, ValueDomainConfigurationKey, NameArrayConfigurationKey, GroupID, GroupIDMultiplayerOverride, Hidden, ReadOnly, SupportsSinglePlayer, SupportsLANMultiplayer, SupportsInternetMultiplayer, SupportsHotseatMultiplayer, IsUGC, ChangeableAfterGameStart, ChangeableAfterAgeTransition, UxHint, SortIndex)
SELECT Key1, REPLACE(Key2, '{base-standard}maps/', '{AdvancedSettingsPro}maps/zg-'), ParameterID, Name, Description, Domain, Hash, Array, DefaultValue, ConfigurationGroup, ConfigurationKey, DomainConfigurationKey, PossibleValuesConfigurationKey, ValueConfigurationKey, ValueNameConfigurationKey, ValueHashConfigurationKey, ValueDomainConfigurationKey, NameArrayConfigurationKey, GroupID, NULL, Hidden, ReadOnly, 1, 0, 0, 0, IsUGC, ChangeableAfterGameStart, ChangeableAfterAgeTransition, UxHint, SortIndex
FROM Parameters
WHERE Key1 = 'Map'
AND Key2 IN (SELECT REPLACE(File, '{AdvancedSettingsPro}maps/zg-', '{base-standard}maps/') FROM Maps WHERE File LIKE '{AdvancedSettingsPro}maps/zg-%');

-- On the copies, Sea Level joins the mod's Terrain Settings group.
UPDATE Parameters SET GroupId = 'TerrainOptions', SortIndex = 153 WHERE ParameterID = 'MapSeaLevel' AND Key2 LIKE '{AdvancedSettingsPro}maps/zg-%';

INSERT OR IGNORE INTO Queries (QueryID, Type, SQL)
    VALUES
        ('ZGSinglePlayerMaps', 'DomainValueFilters', 'SELECT Domain, REPLACE(File, ''{AdvancedSettingsPro}maps/zg-'', ''{base-standard}maps/'') AS Value, ''Difference'' AS Filter FROM Maps WHERE File LIKE ''{AdvancedSettingsPro}maps/zg-%'''),
        ('ZGMultiplayerMaps', 'DomainValueFilters', 'SELECT Domain, File AS Value, ''Difference'' AS Filter FROM Maps WHERE File LIKE ''{AdvancedSettingsPro}maps/zg-%''');

INSERT OR IGNORE INTO QueryCriteria (QueryID, ConfigurationGroup, ConfigurationKey, Operator, ConfigurationValue)
    VALUES
        ('ZGSinglePlayerMaps', 'Game', 'ZGSinglePlayerSetup', 'Equals', 1),
        ('ZGMultiplayerMaps', 'Game', 'ZGSinglePlayerSetup', 'NotEquals', 1);
