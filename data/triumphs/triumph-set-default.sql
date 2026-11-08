-- Triumph Set: Default. Fills the Custom Triumph Set with this age's Default triumphs.
INSERT OR IGNORE INTO Legacy_LegacySets (LegacySetType, LegacyType)
SELECT 'ZG_LEGACY_SET_CUSTOM', LegacyType
FROM Legacy_LegacySets
WHERE LegacySetType = 'LEGACY_SET_DEFAULT';
