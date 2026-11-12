--*******************************************************
--************* CLIMATE CONTROL *************************
--*******************************************************
-- Scrum Lord's Climate Controls replaces the base biome, feature and snow passes,
-- and the mod's map passes hand off to them while it is enabled. Every statement
-- here waits on its settings existing, so without it this file does nothing.
--
-- Single player gets copies of its settings in their own Map tab section,
-- between Map Settings (1010-1050) and Terrain Settings (1060); its rows as
-- shipped stay for multiplayer and hotseat. Map Temperature and Map Zones, which
-- its settings replace, are hidden.
INSERT OR IGNORE INTO ParameterGroups (GroupId, Name)
SELECT 'ZG_ClimateControlOptions', 'LOC_GROUPID_ZG_CLIMATECONTROLOPTIONS'
WHERE EXISTS (SELECT 1 FROM Parameters WHERE ParameterID LIKE 'ScrumLordClimate%');

INSERT INTO Parameters (Key1, Key2, ParameterID, Name, Description, Domain, Hash, Array, DefaultValue, ConfigurationGroup, ConfigurationKey, DomainConfigurationKey, PossibleValuesConfigurationKey, ValueConfigurationKey, ValueNameConfigurationKey, ValueHashConfigurationKey, ValueDomainConfigurationKey, NameArrayConfigurationKey, GroupID, GroupIDMultiplayerOverride, Hidden, ReadOnly, SupportsSinglePlayer, SupportsLANMultiplayer, SupportsInternetMultiplayer, SupportsHotseatMultiplayer, IsUGC, ChangeableAfterGameStart, ChangeableAfterAgeTransition, UxHint, SortIndex)
SELECT Key1, Key2, ParameterID, Name, Description, Domain, Hash, Array, DefaultValue, ConfigurationGroup, ConfigurationKey, DomainConfigurationKey, PossibleValuesConfigurationKey, ValueConfigurationKey, ValueNameConfigurationKey, ValueHashConfigurationKey, ValueDomainConfigurationKey, NameArrayConfigurationKey, 'ZG_ClimateControlOptions', NULL, Hidden, ReadOnly, 1, 0, 0, 0, IsUGC, ChangeableAfterGameStart, ChangeableAfterAgeTransition, UxHint, SortIndex - 5
FROM Parameters
WHERE ParameterID LIKE 'ScrumLordClimate%' AND Key1 IS NULL AND COALESCE(SupportsSinglePlayer, 1) = 1;

UPDATE Parameters SET SupportsSinglePlayer = 0
WHERE ParameterID LIKE 'ScrumLordClimate%' AND Key1 IS NULL
AND (SupportsLANMultiplayer = 1 OR SupportsInternetMultiplayer = 1 OR SupportsHotseatMultiplayer = 1);

UPDATE Parameters SET Hidden = 1
WHERE ParameterID IN ('ZG_MapTemperature', 'ZG_MapZones') AND EXISTS (SELECT 1 FROM Parameters WHERE ParameterID LIKE 'ScrumLordClimate%');
