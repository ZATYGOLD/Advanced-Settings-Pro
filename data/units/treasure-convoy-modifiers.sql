-- Movement modifier shared by the Treasure Convoy Speed options.
-- Attached through ABILITY_TREASURE_FLEET so every fleet receives it on spawn.
INSERT INTO Types (Type, Kind)
    VALUES ('ZG_TREASURE_FLEET_MOD_MOVEMENT_TYPE', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType)
    VALUES ('ZG_TREASURE_FLEET_MOD_MOVEMENT_TYPE', 'COLLECTION_OWNER', 'EFFECT_UNIT_ADJUST_MOVEMENT');

INSERT INTO Modifiers (ModifierId, ModifierType)
    VALUES ('ZG_TREASURE_FLEET_MOD_MOVEMENT', 'ZG_TREASURE_FLEET_MOD_MOVEMENT_TYPE');

INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
    VALUES ('ABILITY_TREASURE_FLEET', 'ZG_TREASURE_FLEET_MOD_MOVEMENT');
