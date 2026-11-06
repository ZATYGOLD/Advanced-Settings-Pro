-- Settler Speed: Fast. Settlers and their unique replacements get 5 base
-- movement; embarked movement is set by the settler-embark files.
UPDATE Units
SET BaseMoves = 5
WHERE UnitType = 'UNIT_SETTLER'
    OR UnitType IN (
        SELECT CivUniqueUnitType
        FROM UnitReplaces
        WHERE ReplacesUnitType = 'UNIT_SETTLER'
    );
