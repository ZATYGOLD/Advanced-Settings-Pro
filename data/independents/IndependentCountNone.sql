-- data/independents/IndependentCountNone.sql
-- Author: Zatygold

UPDATE GlobalParameters
SET Value = 0
WHERE Name = 'INDEPENDENT_NUM_PER_MAJOR';
