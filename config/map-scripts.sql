--*******************************************************
--************* MAP SCRIPT REDIRECTS ********************
--*******************************************************
-- Points every standard map entry at this mod's copy of the script,
-- which applies the Rivers setting. Names, descriptions, start position
-- support and the Sea Level dependencies follow the new file path.

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-voronoi.js'
WHERE File = '{base-standard}maps/continents-voronoi.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-voronoi.js'
WHERE Map = '{base-standard}maps/continents-voronoi.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-voronoi.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/continents-voronoi.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-voronoi.js'
WHERE File = '{base-standard}maps/pangaea-voronoi.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-voronoi.js'
WHERE Map = '{base-standard}maps/pangaea-voronoi.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-voronoi.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/pangaea-voronoi.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal-voronoi.js'
WHERE File = '{base-standard}maps/fractal-voronoi.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal-voronoi.js'
WHERE Map = '{base-standard}maps/fractal-voronoi.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal-voronoi.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/fractal-voronoi.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-shattered-seas-voronoi.js'
WHERE File = '{base-standard}maps/shattered-seas-voronoi.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-shattered-seas-voronoi.js'
WHERE Map = '{base-standard}maps/shattered-seas-voronoi.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-shattered-seas-voronoi.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/shattered-seas-voronoi.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-plus.js'
WHERE File = '{base-standard}maps/continents-plus.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-plus.js'
WHERE Map = '{base-standard}maps/continents-plus.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-plus.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/continents-plus.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-continents.js'
WHERE File = '{base-standard}maps/continents.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-continents.js'
WHERE Map = '{base-standard}maps/continents.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-continents.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/continents.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-archipelago.js'
WHERE File = '{base-standard}maps/archipelago.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-archipelago.js'
WHERE Map = '{base-standard}maps/archipelago.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-archipelago.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/archipelago.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal.js'
WHERE File = '{base-standard}maps/fractal.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal.js'
WHERE Map = '{base-standard}maps/fractal.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/fractal.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-shuffle.js'
WHERE File = '{base-standard}maps/shuffle.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-shuffle.js'
WHERE Map = '{base-standard}maps/shuffle.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-shuffle.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/shuffle.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-terra-incognita.js'
WHERE File = '{base-standard}maps/terra-incognita.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-terra-incognita.js'
WHERE Map = '{base-standard}maps/terra-incognita.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-terra-incognita.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/terra-incognita.js';

UPDATE Maps
SET File = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-plus.js'
WHERE File = '{base-standard}maps/pangaea-plus.js';

UPDATE SupportedValuesByMap
SET Map = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-plus.js'
WHERE Map = '{base-standard}maps/pangaea-plus.js';

UPDATE ParameterDependencies
SET ConfigurationValue = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-plus.js'
WHERE ConfigurationKey = 'MapScript' AND ConfigurationValue = '{base-standard}maps/pangaea-plus.js';

-- The Sea Level parameter is defined per map through Key1/Key2 scoping, so the
-- map-keyed parameter rows must follow the redirected file paths as well.

UPDATE Parameters
SET Key2 = '{Zatygold''s Advanced Settings Pro}maps/zg-continents-voronoi.js'
WHERE Key1 = 'Map' AND Key2 = '{base-standard}maps/continents-voronoi.js';

UPDATE Parameters
SET Key2 = '{Zatygold''s Advanced Settings Pro}maps/zg-pangaea-voronoi.js'
WHERE Key1 = 'Map' AND Key2 = '{base-standard}maps/pangaea-voronoi.js';

UPDATE Parameters
SET Key2 = '{Zatygold''s Advanced Settings Pro}maps/zg-fractal-voronoi.js'
WHERE Key1 = 'Map' AND Key2 = '{base-standard}maps/fractal-voronoi.js';

UPDATE Parameters
SET Key2 = '{Zatygold''s Advanced Settings Pro}maps/zg-shattered-seas-voronoi.js'
WHERE Key1 = 'Map' AND Key2 = '{base-standard}maps/shattered-seas-voronoi.js';
