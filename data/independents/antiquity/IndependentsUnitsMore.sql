-- data/independents/antiquity/IndependentsUnitsMore.sql
-- Author: Zatygold

UPDATE TribeTagSets
SET 
    InitialUnitAmount = 2,
    MaxUnitAmount = 2
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';