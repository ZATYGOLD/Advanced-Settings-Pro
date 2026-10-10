-- Base movement; embarked movement is set by the settler-embark files.
UPDATE Units
SET BaseMoves = 5
WHERE UnitType = 'UNIT_SETTLER'
    OR UnitType IN (
        SELECT CivUniqueUnitType
        FROM UnitReplaces
        WHERE ReplacesUnitType = 'UNIT_SETTLER'
    );
