-- Natural Wonders: Great Barrier Reef disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_BARRIER_REEF';
