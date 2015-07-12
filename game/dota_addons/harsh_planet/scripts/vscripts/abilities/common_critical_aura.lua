common_critical_aura = class({})

LinkLuaModifier("common_critical_aura", "modifiers/common_critical_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("common_critical_aura_effect", "modifiers/common_critical_aura_effect.lua", LUA_MODIFIER_MOTION_NONE)

function common_critical_aura:GetIntrinsicModifierName()
    return 'common_critical_aura'
end