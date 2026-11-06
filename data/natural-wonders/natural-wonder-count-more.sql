-- Natural Wonders: 50% more.
UPDATE Maps
SET NumNaturalWonders = CAST(NumNaturalWonders * 1.5 AS INTEGER)
WHERE NumNaturalWonders IS NOT NULL;
