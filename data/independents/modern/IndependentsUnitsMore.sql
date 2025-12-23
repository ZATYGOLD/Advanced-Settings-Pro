-- data/independents/modern/IndependentsUnitsMore.sql
-- Author: Zatygold

UPDATE TribeTagSets
SET 
    InitialUnitAmount = 5,
    MaxUnitAmount = 5
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';