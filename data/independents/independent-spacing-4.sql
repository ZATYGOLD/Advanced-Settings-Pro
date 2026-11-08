-- Independent Spacing: sets the minimum spacing for independent powers to 4.
UPDATE GlobalParameters
SET Value = 4
WHERE Name = 'INDEPENDENT_SPACING';
