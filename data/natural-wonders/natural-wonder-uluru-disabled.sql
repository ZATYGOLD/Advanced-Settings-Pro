-- Natural Wonders: Uluru disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_ULURU';
