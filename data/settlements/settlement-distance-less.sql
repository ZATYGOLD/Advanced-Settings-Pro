-- Settlement Distance: Less. Sets the minimum distance between
-- settlements (CITY_MIN_RANGE) to 2.
UPDATE GlobalParameters
SET Value = 2
WHERE Name = 'CITY_MIN_RANGE';
