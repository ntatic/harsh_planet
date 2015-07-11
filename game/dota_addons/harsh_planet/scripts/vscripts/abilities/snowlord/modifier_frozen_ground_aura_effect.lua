modifier_frozen_ground_aura_effect = class({})

function modifier_frozen_ground_aura_effect:OnCreated(kv)
	if IsServer() then
		print('Starting')
		self.args = {}
		self.args.unit = self:GetParent()
		if not IsPhysicsUnit(self.args.unit) then
			Physics:Unit(self.args.unit)
		end
		self.args.unit:Slide(true)
	end
end

function modifier_frozen_ground_aura_effect:OnDestroy(kv)
	if IsServer() then
		self.args.unit:Slide(false)
	end
end

