-- Natural Wonders: Iguazú Falls disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_IGUAZU_FALLS';
