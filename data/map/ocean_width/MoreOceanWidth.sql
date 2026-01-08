-- data/map/ocean_width/MoreOceanWidth.sql
-- Author: Zatygold

-- Tiny, Small, Standard: 5
-- Large, Huge: 10
UPDATE Maps
SET OceanWidth = OceanWidth * 1.25;
