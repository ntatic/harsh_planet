necromonger_sacrifice = class({})

function necromonger_sacrifice:PrecacheArgs(update)
    if not self.Args or update then
        self.Args = {}
        self.Args.Radius = self:GetSpecialValueFor('radius')
        self.Args.HealAmount = self:GetSpecialValueFor('heal_amount')
        self.Args.ProjectileSpeed = self:GetSpecialValueFor('projectile_speed')
        self.Args.FX = {}
        self.Args.FX.Projectile = 'particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf'
        self.Args.SND = {}
        self.Args.SND.OnCast = 'Hero_Necrolyte.DeathPulse'
    end
end

function necromonger_sacrifice:OnUpgrade()
    self:PrecacheArgs(true)
end

function necromonger_sacrifice:OnSpellStart()
    self:PrecacheArgs(false)
    local caster = self:GetCaster()
    -- find units
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.Args.Radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
    for _, t in pairs(targets) do
        -- reduce target healt
        local hp = t:GetHealth() - self.Args.HealAmount
        if hp < 1 then hp = 1 end
        t:SetHealth(hp)
        -- create projectile
        local pInfo = {Target = caster, Source = t, Ability = self, EffectName = self.Args.FX.Projectile, iMoveSpeed = self.Args.ProjectileSpeed, bProvidesVision = false}
        ProjectileManager:CreateTrackingProjectile(pInfo)
    end
    -- play sound
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), self.Args.SND.OnCast, caster)
end

function necromonger_sacrifice:OnProjectileHit(hTarget, vLocation)
    self:PrecacheArgs(false)
    if hTarget ~= nil then
        hTarget:Heal(self:GetSpecialValueFor('heal_amount'), hTarget)
    end
end
