-- Apply the Catastrophic disaster frequencies to every intensity tier so they hold
-- whatever the hidden base setting is. Plagues are excluded because they are crisis-driven.
UPDATE RandomEventFrequencies
SET OccurrencesPerAge = (
    SELECT src.OccurrencesPerAge
    FROM RandomEventFrequencies src
    WHERE src.RandomEventType = RandomEventFrequencies.RandomEventType
    AND src.RealismSettingType = 'REALISM_SETTING_HEAVY'
)
WHERE RandomEventType NOT LIKE 'RANDOM_EVENT_PLAGUE%'
AND EXISTS (
    SELECT 1
    FROM RandomEventFrequencies src
    WHERE src.RandomEventType = RandomEventFrequencies.RandomEventType
    AND src.RealismSettingType = 'REALISM_SETTING_HEAVY'
);

UPDATE RealismSettings
SET PercentVolcanoesActive = (
    SELECT src.PercentVolcanoesActive
    FROM RealismSettings src
    WHERE src.RealismSettingType = 'REALISM_SETTING_HEAVY'
);
