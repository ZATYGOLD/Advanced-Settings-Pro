-- Independent Spacing: sets the minimum spacing for independent powers to 2.
UPDATE GlobalParameters
SET Value = 2
WHERE Name = 'INDEPENDENT_SPACING';
