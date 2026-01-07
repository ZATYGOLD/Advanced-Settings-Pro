-- data/map/ocean_width/MoreOceanWidth.sql
-- Author: Zatygold

-- Tiny, Small, Standard: 5
-- Large, Huge: 10
UPDATE Maps
SET OceanWidth =
  CASE
    WHEN OceanWidth <= 0 THEN OceanWidth
    ELSE MAX(3, CAST(ROUND(OceanWidth * 1.25) AS INTEGER))
  END;
