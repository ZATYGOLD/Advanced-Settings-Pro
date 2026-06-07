UPDATE AgeProgressions
SET MaxPoints_Abbreviated = CAST(ROUND(MaxPoints_Abbreviated * 1.5) AS INTEGER),
    MaxPoints_Standard = CAST(ROUND(MaxPoints_Standard * 1.5) AS INTEGER),
    MaxPoints_Long = CAST(ROUND(MaxPoints_Long * 1.5) AS INTEGER);
