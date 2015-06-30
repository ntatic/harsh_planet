function OnEnemyReachedPortal(trigger)
	local unit = trigger.activator
	if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		--EmitGlobalSound(SND_ENEMY_REACHED_PORTAL)
		local teleportFx = ParticleManager:CreateParticle(FX_ENEMY_REACHED_PORTAL, PATTACH_ABSORIGIN, unit)
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(teleportFx, false)
	    	ParticleManager:ReleaseParticleIndex(teleportFx)
		end)
		FindClearSpaceForUnit(unit, GameRules.waypoints['Special']['EnemyKillPit']['Position'], false)
		unit:ForceKill(false)
	end
end