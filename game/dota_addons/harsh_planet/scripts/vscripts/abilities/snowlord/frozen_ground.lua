snowlord_frozen_ground = class({})


LinkLuaModifier("modifier_frozen_ground_aura", "abilities/snowlord/modifier_frozen_ground_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frozen_ground_aura_effect", "abilities/snowlord/modifier_frozen_ground_aura_effect.lua", LUA_MODIFIER_MOTION_NONE)

function snowlord_frozen_ground:GetIntrinsicModifierName()
	return 'modifier_frozen_ground_aura'
end