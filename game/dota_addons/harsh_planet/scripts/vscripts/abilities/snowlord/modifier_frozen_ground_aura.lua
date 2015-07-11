modifier_frozen_ground_aura = class({})

function modifier_frozen_ground_aura:IsHidden()
	return true
end

function modifier_frozen_ground_aura:IsAura()
	return true
end

function modifier_frozen_ground_aura:GetModifierAura()
	return "modifier_frozen_ground_aura_effect"
end

function modifier_frozen_ground_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_frozen_ground_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL
end

function modifier_frozen_ground_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_frozen_ground_aura:GetAuraRadius()
	return self.args.radius
end

function modifier_frozen_ground_aura:OnCreated(kv)
	self.args = {}
	self.args.radius = self:GetAbility():GetSpecialValueFor('radius')
end

function modifier_frozen_ground_aura:OnRefresh( kv )
	self.args.radius = self:GetAbility():GetSpecialValueFor('radius')
end