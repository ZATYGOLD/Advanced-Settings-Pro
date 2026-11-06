-- Natural Wonders: Redwood Forest disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_REDWOOD_FOREST';
