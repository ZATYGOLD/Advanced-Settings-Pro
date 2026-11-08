-- Triumph Set: Explorer. Fills the Custom Triumph Set with this age's Explorer triumphs.
INSERT OR IGNORE INTO Legacy_LegacySets (LegacySetType, LegacyType)
SELECT 'ZG_LEGACY_SET_CUSTOM', LegacyType
FROM Legacy_LegacySets
WHERE LegacySetType = 'LEGACY_SET_EXPLORER';
