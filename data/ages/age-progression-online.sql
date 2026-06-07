UPDATE AgeProgressions
SET MaxPoints_Abbreviated = CAST(ROUND(MaxPoints_Abbreviated * 0.75) AS INTEGER),
    MaxPoints_Standard = CAST(ROUND(MaxPoints_Standard * 0.75) AS INTEGER),
    MaxPoints_Long = CAST(ROUND(MaxPoints_Long * 0.75) AS INTEGER);
