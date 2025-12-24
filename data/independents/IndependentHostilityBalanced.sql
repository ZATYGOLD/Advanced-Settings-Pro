	-- data/independents/IndependentHostilityBalanced.sql
    -- Author: Zatygold

UPDATE Affinities
SET 
    HostilityChance = 0,
    NeutralityChance = 0
WHERE Affinity = 'AFFINITY_FRIENDLY',
SET 
    HostilityChance = 0,
    NeutralityChance = 100
WHERE Affinity = 'AFFINITY_NEUTRAL',
SET 
    HostilityChance = 100,
    NeutralityChance = 0
WHERE Affinity = 'AFFINITY_HOSTILE';
