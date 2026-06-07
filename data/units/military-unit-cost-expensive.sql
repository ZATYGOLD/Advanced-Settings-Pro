UPDATE Unit_Costs
SET Cost = CAST(ROUND(Cost * 1.5) AS INTEGER)
WHERE YieldType = 'YIELD_PRODUCTION'
AND UnitType IN (
    SELECT UnitType
    FROM Units
    WHERE CoreClass = 'CORE_CLASS_MILITARY'
);
