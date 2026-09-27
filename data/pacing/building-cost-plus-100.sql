-- +100%: building costs x2 (every building, unique buildings included;
-- wonders keep their own costs, and districts in this game have none).
UPDATE Constructibles
SET Cost = ROUND(Cost * 2)
WHERE ConstructibleClass = 'BUILDING'
AND Cost > 0;
