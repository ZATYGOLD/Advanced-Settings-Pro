-- Slower: cities need noticeably more food to grow.
UPDATE AgeGrowthBalances
SET Scalar = ROUND(Scalar * 1.1),
    Exponent = ROUND(Exponent * 1.3);
