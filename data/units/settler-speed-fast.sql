-- Settler Speed: Fast. Settlers and their unique replacements get 5 base
-- movement, and an embarked movement modifier (settler-speed-modifiers.sql).
UPDATE Units
SET BaseMoves = 5
WHERE UnitType = 'UNIT_SETTLER'
    OR UnitType IN (
        SELECT CivUniqueUnitType
        FROM UnitReplaces
        WHERE ReplacesUnitType = 'UNIT_SETTLER'
    );

-- Embarked movement: 2 base + 2.
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
    VALUES ('ZG_SETTLER_MOD_EMBARK_MOVEMENT', 'Amount', '2');
