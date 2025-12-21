-- data/independents/IndependentCountMore.sql
-- Author: Zatygold

UPDATE GlobalParameters
SET Value = 4
WHERE Name = 'INDEPENDENT_NUM_PER_MAJOR';
