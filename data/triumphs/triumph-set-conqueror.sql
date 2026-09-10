-- Give the Custom Triumph Set this age's Conqueror triumphs.
INSERT OR IGNORE INTO Legacy_LegacySets (LegacySetType, LegacyType)
SELECT 'ZG_LEGACY_SET_CUSTOM', LegacyType
FROM Legacy_LegacySets
WHERE LegacySetType = 'LEGACY_SET_CONQUEROR';
