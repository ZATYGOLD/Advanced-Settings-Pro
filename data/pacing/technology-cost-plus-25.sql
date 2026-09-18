-- +25%: technology costs x1.25.
UPDATE ProgressionTreeNodes
SET Cost = ROUND(Cost * 1.25),
    RepeatableCostProgressionParam1 = CASE
        WHEN RepeatableCostProgressionParam1 > 0 THEN ROUND(RepeatableCostProgressionParam1 * 1.25)
        ELSE RepeatableCostProgressionParam1
    END
WHERE ProgressionTree LIKE 'TREE_TECHS%'
AND Cost > 1;
