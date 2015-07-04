common_crit_aura = class({})

LinkLuaModifier("modifier_crit_aura", "abilities/common/modifier_crit_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crit_aura_effect", "abilities/common/modifier_crit_aura_effect.lua", LUA_MODIFIER_MOTION_NONE)

function common_crit_aura:GetIntrinsicModifierName()
	return 'modifier_crit_aura'
end