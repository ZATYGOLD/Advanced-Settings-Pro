-- Affordable: civics costs x1.5.
UPDATE ProgressionTreeNodes
SET Cost = ROUND(Cost * 1.5),
    RepeatableCostProgressionParam1 = CASE
        WHEN RepeatableCostProgressionParam1 > 0 THEN ROUND(RepeatableCostProgressionParam1 * 1.5)
        ELSE RepeatableCostProgressionParam1
    END
WHERE ProgressionTree LIKE 'TREE_CIVICS%'
AND Cost > 1;
