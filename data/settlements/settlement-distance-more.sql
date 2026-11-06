-- Settlement Distance: More. Sets the minimum distance between
-- settlements (CITY_MIN_RANGE) to 4.
UPDATE GlobalParameters
SET Value = 4
WHERE Name = 'CITY_MIN_RANGE';
