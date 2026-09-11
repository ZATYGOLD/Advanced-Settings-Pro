-- +45%: civic costs x1.45.
UPDATE ProgressionTreeNodes
SET Cost = ROUND(Cost * 1.45),
    RepeatableCostProgressionParam1 = CASE
        WHEN RepeatableCostProgressionParam1 > 0 THEN ROUND(RepeatableCostProgressionParam1 * 1.45)
        ELSE RepeatableCostProgressionParam1
    END
WHERE ProgressionTree LIKE 'TREE_CIVICS%'
AND Cost > 1;
