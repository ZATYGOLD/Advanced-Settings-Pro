-- fast: every term of the growth threshold scales together, so a city needs
-- exactly 0.5x the Food per citizen that Standard asks for.
UPDATE AgeGrowthBalances
SET Flat = ROUND(Flat * 0.5),
    Scalar = ROUND(Scalar * 0.5),
    Exponent = ROUND(Exponent * 0.5);
