function OnEnemyReachedPortal(trigger)
	local unit = trigger.activator
	-- is unit in DOTA_TEAM_NEUTRAL
	if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		-- find killpit location
		local killpit = Entities:FindByName(nil, 'p_enemy_killpit'):GetAbsOrigin()
		-- emit sound
		EmitGlobalSound(SND_ENEMY_REACHED_PORTAL)
		-- show effect
		local teleportFx = ParticleManager:CreateParticle(FX_ENEMY_REACHED_PORTAL, PATTACH_ABSORIGIN, unit)
		Timers:CreateTimer(3.0, function()
			ParticleManager:DestroyParticle(teleportFx, false)
	    	ParticleManager:ReleaseParticleIndex(teleportFx)
		end)
		-- teleport unit
		FindClearSpaceForUnit(unit, killpit, false)
		-- kill unit
		unit:ForceKill(false)
		-- notify game mode
		local livesWorth = 1
		if unit.Round then livesWorth = unit.Round.LivesWorth end
		GameRules.GameMode:LifeLost(livesWorth)
	end
end