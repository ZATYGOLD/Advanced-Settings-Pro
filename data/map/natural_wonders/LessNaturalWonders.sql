-- data/map/natural_wonders/LessNaturalWonders.sql
-- Author: Zatygold

UPDATE Maps
SET NumNaturalWonders =
  CASE
    WHEN NumNaturalWonders - 2 < 1 THEN 1
    ELSE NumNaturalWonders - 2
  END
WHERE NumNaturalWonders IS NOT NULL
  AND NumNaturalWonders > 0;
