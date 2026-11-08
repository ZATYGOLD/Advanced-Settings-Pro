-- Treasure Convoy Speed: Modifiers. Movement modifier shared by the Treasure Convoy Speed options.
-- Attached through ABILITY_TREASURE_FLEET so every fleet receives it on spawn.
INSERT OR IGNORE INTO Types (Type, Kind)
    VALUES ('ZG_TREASURE_FLEET_MOD_MOVEMENT_TYPE', 'KIND_MODIFIER');

INSERT OR IGNORE INTO DynamicModifiers (ModifierType, CollectionType, EffectType)
    VALUES ('ZG_TREASURE_FLEET_MOD_MOVEMENT_TYPE', 'COLLECTION_OWNER', 'EFFECT_UNIT_ADJUST_MOVEMENT');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
    VALUES ('ZG_TREASURE_FLEET_MOD_MOVEMENT', 'ZG_TREASURE_FLEET_MOD_MOVEMENT_TYPE');

INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
    VALUES ('ABILITY_TREASURE_FLEET', 'ZG_TREASURE_FLEET_MOD_MOVEMENT');
