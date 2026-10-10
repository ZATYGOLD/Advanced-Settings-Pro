-- -25%: triumph project costs x0.75 (every costed project except the repeatable city projects and nuclear weapons).
UPDATE Projects
SET Cost = ROUND(Cost * 0.75)
WHERE Cost IS NOT NULL
AND ProjectType NOT IN ('PROJECT_CITY_SCIENCE_PROJECT', 'PROJECT_CITY_CULTURE_PROJECT', 'PROJECT_PRODUCE_WMD');
