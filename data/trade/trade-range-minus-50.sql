-- Trade Range -50%: land and sea range. Applied only in the age that
-- chose it; the other ages' parameter sets are not read while it is in play.
UPDATE TradeSystemParameterSets
SET LandRouteRange = ROUND(LandRouteRange * 0.5),
    SeaRouteRange = ROUND(SeaRouteRange * 0.5);
