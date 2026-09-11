-- Slow: cities need a little more food to grow.
UPDATE AgeGrowthBalances
SET Scalar = ROUND(Scalar * 1.05),
    Exponent = ROUND(Exponent * 1.15);
