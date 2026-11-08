-- Natural Wonders: Mount Everest disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_MOUNT_EVEREST';
