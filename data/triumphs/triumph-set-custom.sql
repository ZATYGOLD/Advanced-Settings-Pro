-- The Custom Triumph Set the engine reads while the age-specific sets are in use.
-- Its members are filled in by the triumph-set-<set>.sql file chosen for this age.
INSERT OR IGNORE INTO LegacySets (LegacySetType, Name, Description)
VALUES ('ZG_LEGACY_SET_CUSTOM', 'LOC_ZG_CUSTOM_NAME', 'LOC_ZG_TRIUMPH_SET_DESCRIPTION_CUSTOM');
