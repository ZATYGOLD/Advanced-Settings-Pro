-- -25%: building costs x0.75 (every building, unique buildings included;
-- wonders keep their own costs, and districts in this game have none).
UPDATE Constructibles
SET Cost = ROUND(Cost * 0.75)
WHERE ConstructibleClass = 'BUILDING'
AND Cost > 0;
