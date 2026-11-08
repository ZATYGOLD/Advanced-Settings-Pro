-- Independent Aggression: 3 units. Independent powers start with 3 defender units
-- and keep at most 3.
UPDATE TribeTagSets
SET InitialUnitAmount = 3,
    MaxUnitAmount = 3
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';
