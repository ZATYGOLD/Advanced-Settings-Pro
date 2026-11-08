-- Trade Range: -50%. Land and sea range. Applied only in the age that
-- chose it; the other ages' parameter sets are not read while it is in play.
UPDATE TradeSystemParameterSets
SET LandRouteRange = CAST(ROUND(LandRouteRange * 0.5) AS INTEGER),
    SeaRouteRange = CAST(ROUND(SeaRouteRange * 0.5) AS INTEGER);
