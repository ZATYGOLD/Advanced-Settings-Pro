-- Independent Spacing: sets the minimum spacing for independent powers to 7.
UPDATE GlobalParameters
SET Value = 7
WHERE Name = 'INDEPENDENT_SPACING';
