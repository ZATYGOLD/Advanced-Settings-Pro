-- Natural Wonders: Grand Canyon disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_GRAND_CANYON';
