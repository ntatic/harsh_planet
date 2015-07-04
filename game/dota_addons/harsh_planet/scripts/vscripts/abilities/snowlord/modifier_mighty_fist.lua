modifier_mighty_fist = class({})

function modifier_mighty_fist:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_mighty_fist:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
			local target = params.target
			local fx = ParticleManager:CreateParticle('particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_base_elixir.vpcf', PATTACH_ABSORIGIN, target)
		end
	end
end