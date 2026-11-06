-- Natural Wonders: Mount Kilimanjaro disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_KILIMANJARO';
