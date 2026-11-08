-- Natural Wonders: Bermuda Triangle disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_BERMUDA_TRIANGLE';
