-- +35%: civic costs x1.35.
UPDATE ProgressionTreeNodes
SET Cost = ROUND(Cost * 1.35),
    RepeatableCostProgressionParam1 = CASE
        WHEN RepeatableCostProgressionParam1 > 0 THEN ROUND(RepeatableCostProgressionParam1 * 1.35)
        ELSE RepeatableCostProgressionParam1
    END
WHERE ProgressionTree LIKE 'TREE_CIVICS%'
AND Cost > 1;
