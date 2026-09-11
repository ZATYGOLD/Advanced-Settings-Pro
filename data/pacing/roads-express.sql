-- Express: roads cost 25% less movement, railroads 50% less.
UPDATE Routes
SET MovementCost = MovementCost * 0.75
WHERE RouteType = 'ROUTE_ROAD';

UPDATE Routes
SET MovementCost = MovementCost * 0.5
WHERE RouteType IN ('ROUTE_RAILROAD', 'ROUTE_STAATSEISENBAHN');
