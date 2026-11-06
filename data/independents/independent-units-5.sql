-- Independent Aggression: independent powers start with 5 defender units
-- and keep at most 5.
UPDATE TribeTagSets
SET InitialUnitAmount = 5,
    MaxUnitAmount = 5
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';
