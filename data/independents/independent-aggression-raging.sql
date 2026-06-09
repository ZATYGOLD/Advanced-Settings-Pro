-- Raging: independent powers raid far more boldly and build up forces faster.
UPDATE BarbarianTribes
SET RaidingBoldness = RaidingBoldness * 2,
    CityAttackBoldness = CityAttackBoldness * 2,
    TurnsToWarriorSpawn = MAX(1, TurnsToWarriorSpawn / 2);
