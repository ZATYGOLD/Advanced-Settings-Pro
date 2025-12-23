-- data/independents/exploration/IndependentsUnitsMore.sql
-- Author: Zatygold

UPDATE TribeTagSets
SET 
    InitialUnitAmount = 4,
    MaxUnitAmount = 4
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';