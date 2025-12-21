-- data/unit_movement/settler/settler_fast.sql
-- Author: Zatygold

UPDATE Units
SET BaseMoves = 4
WHERE UnitType = 'UNIT_SETTLER'
   OR UnitType IN (
     SELECT CivUniqueUnitType
     FROM UnitReplaces
     WHERE ReplacesUnitType = 'UNIT_SETTLER'
   );
