-- +85%: tech costs x1.85.
UPDATE ProgressionTreeNodes
SET Cost = ROUND(Cost * 1.85),
    RepeatableCostProgressionParam1 = CASE
        WHEN RepeatableCostProgressionParam1 > 0 THEN ROUND(RepeatableCostProgressionParam1 * 1.85)
        ELSE RepeatableCostProgressionParam1
    END
WHERE ProgressionTree LIKE 'TREE_TECHS%'
AND Cost > 1;
