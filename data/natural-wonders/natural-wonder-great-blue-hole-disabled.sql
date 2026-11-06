-- Natural Wonders: Great Blue Hole disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_GREAT_BLUE_HOLE';
