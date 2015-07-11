-- constructor
if CRound == nil then
    _G.CRound = class({
    	constructor = function(self, index, rules, cbOnRoundEnd) 
    		self.Index = index
    		self.Rules = rules
    		self.TotalEnemies = 0
    		for _, uInfo in pairs(self.Rules.Units) do self.TotalEnemies = self.TotalEnemies + tonumber(uInfo.Count) * tonumber(self.Rules.SpawnLocations) end
    		self.KilledEnemies = 0
    		self.OnRoundEndCallback = cbOnRoundEnd
    		self.Countdown = 99
    		self.ListenerNpcDied = ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)
    	end
	})
end

-- start round
function CRound:Start(countdown)
	self.Countdown = countdown
	Timers:CreateTimer(function()
		HUD:UpdateRoundInfo(self)
		if self.Countdown == 0 then
			if self.Rules.Type == 'ROUND_TYPE_NORMAL' then
				EmitGlobalSound(SND_ROUND_START_NORMAL)
			else
				EmitGlobalSound(SND_ROUND_START_BOSS)
			end
			self:SpawnRound()
		else
			if self.Countdown < GM_ROUND_COUNTDOWN_SOUND then
				EmitGlobalSound(SND_CLOCK_TICK)
			end
			self.Countdown = self.Countdown - 1
			return 1.0
		end
	end)
end

-- spawn whole wave
function CRound:SpawnRound()
	-- get all spawner entities
	local spawners = Entities:FindAllByName('wp_spawner*')
	-- randomize spawners
	local n = table.getn(spawners)
	while n >= 2 do
		local k = math.random(n)
		spawners[n], spawners[k] = spawners[k], spawners[n]
		n = n - 1
	end
	-- spawn units
	local delay = 0
	for _, uInfo in pairs(self.Rules.Units) do
		for i = 1, tonumber(uInfo.Count) do
			Timers:CreateTimer(delay, function()
				for i = 1, tonumber(self.Rules.SpawnLocations) do
					self:SpawnEnemy(uInfo, spawners[i]:GetAbsOrigin())
				end
			end)
			local bonusDelay = GM_DEFAULT_UNIT_SPAWN_DELAY
			if uInfo.NextUnitDelay then bonusDelay = tonumber(uInfo.NextUnitDelay) end
			delay = delay + bonusDelay
		end
	end
end

-- spawn enemy at desired location
function CRound:SpawnEnemy(uInfo, location)
	-- create unit
	local unit = CreateUnitByName(uInfo.Name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	-- attack round info
	unit.Round = {}
	unit.Round.Index = self.Index
	if uInfo.LivesWorth then unit.Round.LivesWorth = uInfo.LivesWorth else unit.Round.LivesWorth = 1 end
	-- face unit in right direction
	local wp = Entities:FindByNameNearest('wp_path*_seg1', location, 0)
	local vForward = wp:GetAbsOrigin() - location
	unit:SetForwardVector(vForward)
	-- attach ai
	AI:Init(unit)
	-- play spawn animation
	unit.Round.SpawnFX = ParticleManager:CreateParticle(FX_ENEMY_SPAWN, PATTACH_ABSORIGIN, unit)
	Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(unit.Round.SpawnFX, false)
        ParticleManager:ReleaseParticleIndex(unit.Round.SpawnFX)
	end)
end

-- handle round logic when spawned unit is killed (by reaching portal or just plain killing)
function CRound:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript(keys.entindex_killed)
    if killedUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and killedUnit.Round and killedUnit.Round.Index == self.Index then
    	self.KilledEnemies = self.KilledEnemies + 1
    	HUD:UpdateRoundInfo(self)
	    if self.KilledEnemies == self.TotalEnemies then
	    	EmitGlobalSound('SND_ROUND_END')
	    	self.OnRoundEndCallback()
	    end
    end
end

-- return round info useful for hud
function CRound:GetInfo()
	local t = {}
	t.Index = self.Index
	t.Title = '#Round' .. self.Index .. '_Title'
	t.Type = self.Rules.Type
	t.Progress = self.KilledEnemies / self.TotalEnemies
	t.Countdown = self.Countdown
	return t
end

-- cleanup resources
function CRound:Cleanup()
	StopListeningToGameEvent(self.ListenerNpcDied)
end
