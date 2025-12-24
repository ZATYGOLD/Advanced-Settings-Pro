	-- data/independents/IndependentHostilityNeutral.sql
    -- Author: Zatygold

UPDATE Affinities
SET HostilityChance = 0, NeutralityChance = 100
WHERE Affinity = 'AFFINITY_FRIENDLY';

UPDATE Affinities
SET HostilityChance = 0, NeutralityChance = 100
WHERE Affinity = 'AFFINITY_NEUTRAL';

UPDATE Affinities
SET HostilityChance = 0, NeutralityChance = 100
WHERE Affinity = 'AFFINITY_HOSTILE';
