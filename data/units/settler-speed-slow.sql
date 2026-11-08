-- Settler Speed: Slow. Settlers and their unique replacements get 2 base
-- movement, and an embarked movement modifier (settler-speed-modifiers.sql).
UPDATE Units
SET BaseMoves = 2
WHERE UnitType = 'UNIT_SETTLER'
    OR UnitType IN (
        SELECT CivUniqueUnitType
        FROM UnitReplaces
        WHERE ReplacesUnitType = 'UNIT_SETTLER'
    );

-- Embarked movement: 2 base - 1.
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('ZG_SETTLER_MOD_EMBARK_MOVEMENT', 'Amount', '-1');
