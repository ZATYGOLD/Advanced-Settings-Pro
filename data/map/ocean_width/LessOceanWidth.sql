-- data/map/ocean_width/LessOceanWidth.sql
-- Author: Zatygold

-- Tiny, Small, Standard: 3
-- Large, Huge: 6
UPDATE Maps
SET OceanWidth =
  CASE
    WHEN OceanWidth IS NULL THEN NULL
    WHEN OceanWidth <= 0 THEN OceanWidth
    ELSE MAX(3, CAST(OceanWidth * 0.75 AS INTEGER))
  END;