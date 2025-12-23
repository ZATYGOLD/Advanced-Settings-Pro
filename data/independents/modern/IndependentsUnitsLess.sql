-- data/independents/modern/IndependentsUnitsLess.sql
-- Author: Zatygold

UPDATE TribeTagSets
SET 
    InitialUnitAmount = 3,
    MaxUnitAmount = 3
WHERE TribeTagName = 'DEFAULT_DEFENDER_TAGS';