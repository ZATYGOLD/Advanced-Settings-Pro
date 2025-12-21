-- data/unit_movement/treasure_convoy/TreasureConvoyFast.sql
-- Author: Zatygold

UPDATE Units
SET BaseMoves = 3
WHERE UnitType = 'UNIT_TREASURE_FLEET';