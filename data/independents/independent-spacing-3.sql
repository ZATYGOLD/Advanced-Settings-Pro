-- Independent Spacing: sets the minimum spacing for independent powers to 3.
UPDATE GlobalParameters
SET Value = 3
WHERE Name = 'INDEPENDENT_SPACING';
