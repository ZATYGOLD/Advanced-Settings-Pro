-- data/settlement_limit/antiquity/SettlementLimitLess.sql
-- Author: Zatygold

UPDATE ModifierArguments
SET Value = 1
WHERE ModifierId = 'TRAIT_INITIAL_SETTLEMENT_CAP' AND Name = 'Amount';