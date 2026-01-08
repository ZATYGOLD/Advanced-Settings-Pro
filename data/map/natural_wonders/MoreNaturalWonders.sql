-- data/map/natural_wonders/MoreNaturalWonders.sql
-- Author: Zatygold

UPDATE Maps
SET NumNaturalWonders = CAST((NumNaturalWonders * 1.5) AS INTEGER);
