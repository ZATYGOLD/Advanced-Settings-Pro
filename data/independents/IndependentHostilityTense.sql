-- data/independents/IndependentHostilityTense.sql
-- Author: Zatygold
-- 70% Hostile and 30% Non-Hostile

UPDATE Affinities
SET HostilityChance = 10, NeutralityChance = 0
WHERE Affinity = 'AFFINITY_FRIENDLY';

UPDATE Affinities
SET HostilityChance = 100, NeutralityChance = 0
WHERE Affinity = 'AFFINITY_NEUTRAL';

UPDATE Affinities
SET HostilityChance = 100, NeutralityChance = 0
WHERE Affinity = 'AFFINITY_HOSTILE';