-- data/settlements/SettlementDistanceLess.sql
-- Author: Zatygold

UPDATE GlobalParameters
SET Value = 2
WHERE Name = 'CITY_MIN_RANGE';
