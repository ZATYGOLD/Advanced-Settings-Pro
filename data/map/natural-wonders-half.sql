UPDATE Maps
SET NumNaturalWonders =
  CASE
    WHEN NumNaturalWonders IS NULL THEN 1
    WHEN NumNaturalWonders <= 1 THEN 1
    ELSE CAST((NumNaturalWonders / 2.0) AS INTEGER)
  END;

