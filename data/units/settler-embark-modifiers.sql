-- Embarked-movement modifier shared by the Settler Speed options.
-- Attached through a unit ability on the settler class so every settler,
-- including unique replacements, receives it on spawn.
INSERT INTO Types (Type, Kind)
    VALUES
        ('ZG_ABILITY_SETTLER_EMBARK', 'KIND_ABILITY'),
        ('ZG_SETTLER_MOD_EMBARK_MOVEMENT_TYPE', 'KIND_MODIFIER');

INSERT INTO UnitAbilities (UnitAbilityType)
    VALUES ('ZG_ABILITY_SETTLER_EMBARK');

INSERT INTO UnitClass_Abilities (UnitAbilityType, UnitClassType)
    VALUES ('ZG_ABILITY_SETTLER_EMBARK', 'UNIT_CLASS_CREATE_TOWN');

INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType)
    VALUES ('ZG_SETTLER_MOD_EMBARK_MOVEMENT_TYPE', 'COLLECTION_OWNER', 'EFFECT_ADJUST_UNIT_EMBARKED_MOVEMENT');

INSERT INTO Modifiers (ModifierId, ModifierType)
    VALUES ('ZG_SETTLER_MOD_EMBARK_MOVEMENT', 'ZG_SETTLER_MOD_EMBARK_MOVEMENT_TYPE');

INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
    VALUES ('ZG_ABILITY_SETTLER_EMBARK', 'ZG_SETTLER_MOD_EMBARK_MOVEMENT');
