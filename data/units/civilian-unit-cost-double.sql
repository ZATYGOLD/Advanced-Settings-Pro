UPDATE Unit_Costs
SET Cost = CAST(ROUND(Cost * 2.0) AS INTEGER)
WHERE YieldType = 'YIELD_PRODUCTION'
AND UnitType IN (
    SELECT UnitType
    FROM Units
    WHERE CoreClass = 'CORE_CLASS_CIVILIAN'
);
