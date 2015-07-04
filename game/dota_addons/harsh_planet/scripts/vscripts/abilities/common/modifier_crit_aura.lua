modifier_crit_aura = class({})

function modifier_crit_aura:IsHidden()
	return true
end

function modifier_crit_aura:IsAura()
	return true
end

function modifier_crit_aura:GetModifierAura()
	return "modifier_crit_aura_effect"
end

function modifier_crit_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_crit_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL
end

function modifier_crit_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_crit_aura:GetAuraRadius()
	return self.args.radius
end

function modifier_crit_aura:OnCreated(kv)
	self.args = {}
	self.args.radius = self:GetAbility():GetSpecialValueFor('radius')
end

function modifier_crit_aura:OnRefresh( kv )
	self.args.radius = self:GetAbility():GetSpecialValueFor('radius')
end