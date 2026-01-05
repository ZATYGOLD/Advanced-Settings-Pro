-- data/settlement_limit/antiquity/SettlementLimitMore.sql
-- Author: Zatygold

UPDATE ModifierArguments
SET Value = 5
WHERE ModifierId = 'TRAIT_INITIAL_SETTLEMENT_CAP' AND Name = 'Amount';