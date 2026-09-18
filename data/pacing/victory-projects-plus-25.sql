-- +25%: triumph project costs x1.25 (every costed project except the repeatable city projects).
UPDATE Projects
SET Cost = ROUND(Cost * 1.25)
WHERE Cost IS NOT NULL
AND ProjectType NOT IN ('PROJECT_CITY_SCIENCE_PROJECT', 'PROJECT_CITY_CULTURE_PROJECT');
