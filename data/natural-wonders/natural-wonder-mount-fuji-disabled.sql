-- Natural Wonders: Mount Fuji disabled. No map places it.
DELETE FROM Feature_NaturalWonders
WHERE FeatureType = 'FEATURE_MOUNT_FUJI';
