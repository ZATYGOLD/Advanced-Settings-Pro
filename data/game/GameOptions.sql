-- data/game/GameOptions.sql
-- Author: Zatygold

UPDATE Parameters
SET SupportsSinglePlayer = 1
WHERE ParameterID = 'SingleAgeGame';