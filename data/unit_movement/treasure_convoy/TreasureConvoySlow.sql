-- data/unit_movement/treasure_convoy/TreasureConvoySlow.sql
-- Author: Zatygold

UPDATE Units
SET BaseMoves = 1
WHERE UnitType = 'UNIT_TREASURE_FLEET';