-- data/independents/exploration/IndependentsUnitsLess.sql
-- Author: Zatygold

UPDATE TribeTagSets
SET 
    InitialUnitAmount = 2,
    MaxUnitAmount = 2
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';