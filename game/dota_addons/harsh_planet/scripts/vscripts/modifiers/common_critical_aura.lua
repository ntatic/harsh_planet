common_critical_aura = class({})

function common_critical_aura:IsHidden()
    return true
end

function common_critical_aura:IsAura()
    return true
end

function common_critical_aura:GetModifierAura()
    return "critical_aura_effect"
end

function common_critical_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function common_critical_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL
end

function common_critical_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function common_critical_aura:GetAuraRadius()
    return self.args.radius
end

function common_critical_aura:OnCreated(kv)
    self.args = {}
    self.args.radius = self:GetAbility():GetSpecialValueFor('radius')
end

function common_critical_aura:OnRefresh( kv )
    self.args.radius = self:GetAbility():GetSpecialValueFor('radius')
end