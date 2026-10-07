-- Raze Time: Shorter. Twice the age's districts razed per turn (2 / 4 / 6).
-- Antiquity ships no row of its own; the game's rate there is 1.
INSERT OR REPLACE INTO GlobalParameters (Name, Value)
    SELECT 'CITY_RAZE_DISTRICTS_PER_TURN',
        COALESCE((SELECT Value FROM GlobalParameters WHERE Name = 'CITY_RAZE_DISTRICTS_PER_TURN'), 1) * 2;
