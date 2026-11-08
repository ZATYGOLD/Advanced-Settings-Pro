-- Natural Wonders: Torres del Paine disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_TORRES_DEL_PAINE';
