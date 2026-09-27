-- +25%: building costs x1.25 (every building, unique buildings included;
-- wonders keep their own costs, and districts in this game have none).
UPDATE Constructibles
SET Cost = ROUND(Cost * 1.25)
WHERE ConstructibleClass = 'BUILDING'
AND Cost > 0;
