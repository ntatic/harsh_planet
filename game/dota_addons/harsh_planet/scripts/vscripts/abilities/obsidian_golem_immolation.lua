obsidian_golem_immolation = class({})

LinkLuaModifier("obsidian_golem_immolation_aura", "modifiers/obsidian_golem_immolation_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("obsidian_golem_immolation_effect", "modifiers/obsidian_golem_immolation_effect.lua", LUA_MODIFIER_MOTION_NONE)

function obsidian_golem_immolation:GetIntrinsicModifierName()
    return 'obsidian_golem_immolation_aura'
end