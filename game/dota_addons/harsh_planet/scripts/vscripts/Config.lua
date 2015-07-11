GM_START_LIVES 				= 50 		-- Lives at game start
GM_LIGHTS_RADIUS 			= 900 		-- Default radius of static lights
GM_ROUND_COUNTDOWN			= 10		-- Round countdown in seconds
GM_ROUND_COUNTDOWN_SOUND	= 5			-- How much last seconds of cooldown tick sound should be played
GM_DEFAULT_UNIT_SPAWN_DELAY = 0.35		-- How much to wait to spawn next unit

CFG_PRE_GAME_TIME			= 0			-- Seconds before game starts (before 00:00)
CFG_FOG_OF_WAR_DISABLED  	= true 		-- Disable fog of war

-- particles
FX_PORTAL 					= 'particles/radiant_fx2/good_ancient001_ambient.vpcf'
FX_ENEMY_SPAWN 				= 'particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf'
FX_ENEMY_REACHED_PORTAL 	= 'particles/econ/events/ti4/teleport_end_streak_ti4.vpcf'
-- particles to precache
PC_FX = {
	FX_PORTAL,
	FX_ENEMY_SPAWN,
	FX_ENEMY_REACHED_PORTAL
}

-- ambient particles
FX_AMBIENT = {}
FX_AMBIENT['enemy_spectre'] = 'particles/units/heroes/hero_spectre/spectre_ambient.vpcf'

-- sounds
SND_CLOCK_TICK 				= 'General.CastFail_AbilityInCooldown'
SND_ROUND_START_NORMAL 		= 'greevil_eventstart_Stinger'
SND_ROUND_START_BOSS 		= 'diretide_eventstart_Stinger'
SND_ROUND_END		 		= 'greevil_eventend_Stinger'
SND_ENEMY_REACHED_PORTAL 	= 'Hero_Furion.Teleport_Disappear'
-- precache sounds
PC_SND = {
	'soundevents/game_sounds_greevils.vsndevts',
	'soundevents/game_sounds_heroes/game_sounds_furion.vsndevts',
	'soundevents/game_sounds_heroes/game_sounds_furion.vsndevts'
}
