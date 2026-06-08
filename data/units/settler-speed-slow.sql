-- Currently only works for land based movement.
UPDATE Units
SET BaseMoves = 2
WHERE UnitType = 'UNIT_SETTLER'
    OR UnitType IN (
        SELECT CivUniqueUnitType
        FROM UnitReplaces
        WHERE ReplacesUnitType = 'UNIT_SETTLER'
    );
