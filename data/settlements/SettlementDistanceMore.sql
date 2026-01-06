-- data/settlements/SettlementDistanceMore.sql
-- Author: Zatygold

UPDATE GlobalParameters
SET Value = 4
WHERE Name = 'CITY_MIN_RANGE';
