-- data/independents/IndependentHostilityCalm.sql
-- Author: Zatygold
-- 30% Hostile and 70% Non-Hostile

UPDATE Affinities
SET HostilityChance = 0, NeutralityChance = 0
WHERE Affinity = 'AFFINITY_FRIENDLY';

UPDATE Affinities
SET HostilityChance = 0, NeutralityChance = 100
WHERE Affinity = 'AFFINITY_NEUTRAL';

UPDATE Affinities
SET HostilityChance = 90, NeutralityChance = 100
WHERE Affinity = 'AFFINITY_HOSTILE';
