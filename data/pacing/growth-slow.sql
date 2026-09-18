-- slow: every term of the growth threshold scales together, so a city needs
-- exactly 1.25x the Food per citizen that Standard asks for.
UPDATE AgeGrowthBalances
SET Flat = ROUND(Flat * 1.25),
    Scalar = ROUND(Scalar * 1.25),
    Exponent = ROUND(Exponent * 1.25);
