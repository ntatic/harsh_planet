obsidian_golem_immolation_aura = class({})

function obsidian_golem_immolation_aura:OnCreated(kv)
    self.Args = {}
    self.Args.Radius = self:GetAbility():GetSpecialValueFor('radius')
    self.Args.DPS = self:GetAbility():GetSpecialValueFor('dps')
end

function obsidian_golem_immolation_aura:OnRefresh( kv )
    self.Args.Radius = self:GetAbility():GetSpecialValueFor('radius')
    self.Args.DPS = self:GetAbility():GetSpecialValueFor('dps')
end

function obsidian_golem_immolation_aura:IsHidden()
    return true
end

function obsidian_golem_immolation_aura:IsAura()
    return true
end

function obsidian_golem_immolation_aura:GetModifierAura()
    return "obsidian_golem_immolation_effect"
end

function obsidian_golem_immolation_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function obsidian_golem_immolation_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function obsidian_golem_immolation_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function obsidian_golem_immolation_aura:GetAuraRadius()
    return self.Args.Radius
end