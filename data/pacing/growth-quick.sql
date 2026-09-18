-- quick: every term of the growth threshold scales together, so a city needs
-- exactly 0.75x the Food per citizen that Standard asks for.
UPDATE AgeGrowthBalances
SET Flat = ROUND(Flat * 0.75),
    Scalar = ROUND(Scalar * 0.75),
    Exponent = ROUND(Exponent * 0.75);
