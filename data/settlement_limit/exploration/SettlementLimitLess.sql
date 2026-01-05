-- data/settlement_limit/exploration/SettlementLimitLess.sql
-- Author: Zatygold

UPDATE ModifierArguments
SET Value = 4
WHERE ModifierId = 'TRAIT_INITIAL_SETTLEMENT_CAP' AND Name = 'Amount';