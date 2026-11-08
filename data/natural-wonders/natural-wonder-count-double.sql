-- Natural Wonders: 100% more.
UPDATE Maps
SET NumNaturalWonders = NumNaturalWonders * 2
WHERE NumNaturalWonders IS NOT NULL;
