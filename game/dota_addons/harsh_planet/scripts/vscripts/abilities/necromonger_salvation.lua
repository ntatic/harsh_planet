necromonger_salvation = class({})

function necromonger_salvation:PrecacheArgs(update)
    if not self.Args or update then
        self.Args = {}
        self.Args.HealAmount = self:GetSpecialValueFor('heal_amount')
        self.Args.FX = {}
        self.Args.FX.Line = 'particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance.vpcf'
        self.Args.FX.Target = 'particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance_explosion.vpcf'
        self.Args.SND = {}
        self.Args.SND.OnCastCaster = 'Hero_Abaddon.DeathCoil.Cast'
        self.Args.SND.OnCastTarget = 'Hero_Abaddon.DeathCoil.Target'
    end
end

function necromonger_salvation:OnUpgrade()
    self:PrecacheArgs(true)
end

function necromonger_salvation:CastFilterResultTarget(target)
    if self:GetCaster() == target then
        return UF_FAIL_CUSTOM
    end
    return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
end

function necromonger_salvation:OnSpellStart()
    self:PrecacheArgs(false)
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    -- heal
    target:Heal(self.Args.HealAmount, caster)
    -- play fx
    local fxLine = ParticleManager:CreateParticle(self.Args.FX.Line, PATTACH_ABSORIGIN_FOLLOW, target)
    local fxTarget = ParticleManager:CreateParticle(self.Args.FX.Target, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(fxLine, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(fxTarget, 1, target:GetAbsOrigin())
    Timers:CreateTimer(5.0, function()
        ParticleManager:DestroyParticle(fxLine, false)
        ParticleManager:DestroyParticle(fxTarget, false)
    end)
    -- play sound
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), self.Args.SND.OnCastCaster, caster)
    EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), self.Args.SND.OnCastTarget, caster)
end

