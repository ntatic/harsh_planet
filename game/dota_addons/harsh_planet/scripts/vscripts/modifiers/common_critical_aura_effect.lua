common_critical_aura_effect = class({})

function common_critical_aura_effect:OnCreated(kv)
	self.args = {}
	self.args.chance = self:GetAbility():GetSpecialValueFor('chance')
	self.args.multiplier = self:GetAbility():GetSpecialValueFor('multiplier')
end

function common_critical_aura_effect:OnRefresh(kv)
	self.args.chance = self:GetAbility():GetSpecialValueFor('chance')
	self.args.multiplier = self:GetAbility():GetSpecialValueFor('multiplier')
end

function common_critical_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return funcs
end

function common_critical_aura_effect:GetModifierPreAttack_CriticalStrike(params)
	if IsServer() and RandomInt(1, 100) <= self.args.chance then
		return self.args.multiplier
	else
		return false
	end
end