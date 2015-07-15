obsidian_golem_immolation_effect = class({})

function obsidian_golem_immolation_effect:OnCreated(kv)
    if IsServer() then
        self.Args = {}
        self.Args.Radius = self:GetAbility():GetSpecialValueFor('radius')
        self.Args.DPS = self:GetAbility():GetSpecialValueFor('dps')
        self.FX = ParticleManager:CreateParticle('particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.FX, 1, self:GetCaster():GetAbsOrigin())
        self:DamageTick()
        self:StartIntervalThink(1)
    end
end

function obsidian_golem_immolation_effect:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
        ParticleManager:DestroyParticle(self.FX, false)
    end
end

function obsidian_golem_immolation_effect:OnRefresh(kv)
    self.Args = {}
    self.Args.Radius = self:GetAbility():GetSpecialValueFor('radius')
    self.Args.DPS = self:GetAbility():GetSpecialValueFor('dps')
end

function obsidian_golem_immolation_effect:DeclareFunctions()
    local funcs = {}
    return funcs
end

function obsidian_golem_immolation_effect:GetStatusEffectName()
    return 'particles/status_fx/status_effect_burn.vpcf'
end

function obsidian_golem_immolation_effect:OnIntervalThink()
    if IsServer() then
        self:DamageTick()
        ParticleManager:SetParticleControl(self.FX, 1, self:GetCaster():GetAbsOrigin())
    end
end

function obsidian_golem_immolation_effect:DamageTick()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.Args.DPS,
        damage_type = self:GetAbility():GetAbilityDamageType()
    })
end
