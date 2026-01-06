-- data/settlements/exploration/SettlementLimitMore.sql
-- Author: Zatygold

UPDATE ModifierArguments
SET Value = 12
WHERE ModifierId = 'TRAIT_INITIAL_SETTLEMENT_CAP' AND Name = 'Amount';