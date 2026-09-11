-- +50%: triumph project costs x1.5 (every costed project except the repeatable city projects).
UPDATE Projects
SET Cost = ROUND(Cost * 1.5)
WHERE Cost IS NOT NULL
AND ProjectType NOT IN ('PROJECT_CITY_SCIENCE_PROJECT', 'PROJECT_CITY_CULTURE_PROJECT');
