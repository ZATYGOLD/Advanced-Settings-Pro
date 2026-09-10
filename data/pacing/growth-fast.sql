-- Fast: cities need less food to grow.
UPDATE AgeGrowthBalances
SET Scalar = ROUND(Scalar * 0.9),
    Exponent = ROUND(Exponent * 0.75);
