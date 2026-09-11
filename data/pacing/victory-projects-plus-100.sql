-- +100%: triumph project costs x2 (every costed project except the repeatable city projects).
UPDATE Projects
SET Cost = ROUND(Cost * 2)
WHERE Cost IS NOT NULL
AND ProjectType NOT IN ('PROJECT_CITY_SCIENCE_PROJECT', 'PROJECT_CITY_CULTURE_PROJECT');
