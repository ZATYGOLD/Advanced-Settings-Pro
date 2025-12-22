-- config/SetupGameOptions
-- Author: Zatygold

-- Single Player Single Age Option
UPDATE Parameters
SET SupportsSinglePlayer = 1
WHERE ParameterID = 'SingleAgeGame';