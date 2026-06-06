-- Zero every random disaster frequency. Plagues are excluded because they are
-- crisis-driven and intended to be controlled by a separate setting.
UPDATE RandomEventFrequencies
SET OccurrencesPerAge = 0
WHERE RandomEventType NOT LIKE 'RANDOM_EVENT_PLAGUE%';
