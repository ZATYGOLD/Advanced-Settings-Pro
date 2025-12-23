-- data/independents/antiquity/IndependentsUnitsLess.sql
-- Author: Zatygold

UPDATE TribeTagSets
SET 
    InitialUnitAmount = 0,
    MaxUnitAmount = 0
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';