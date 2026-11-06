-- Independent Spacing: sets the minimum spacing for independent powers to 5.
UPDATE GlobalParameters
SET Value = 5
WHERE Name = 'INDEPENDENT_SPACING';
