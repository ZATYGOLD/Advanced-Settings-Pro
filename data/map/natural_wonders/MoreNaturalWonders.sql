-- data/map/natural_wonders/MoreNaturalWonders.sql
-- Author: Zatygold

UPDATE Maps
SET NumNaturalWonders = MAX(1, CAST(CEIL(COALESCE(NumNaturalWonders, 0) * 1.5) AS INTEGER));
