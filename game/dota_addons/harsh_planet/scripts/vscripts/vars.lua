-- game settings
GS_ENABLE_HERO_RESPAWN = true
GS_ALLOW_SAME_HERO_SELECTION = false
GS_HERO_SELECTION_TIME = 30.0
GS_PRE_GAME_TIME = 5.0
GS_POST_GAME_TIME = 60.0
GS_TREE_REGROW_TIME = 60.0
GS_ENABLE_FIRST_BLOOD = false
GS_HIDE_KILL_BANNERS = true

GS_RECOMMENDED_BUILDS_DISABLED = true
GS_DISABLE_FOG_OF_WAR_ENTIRELY = true
GS_DISABLE_ANNOUNCER = true
GS_FIXED_RESPAWN_TIME = -1
GS_BUYBACK_ENABLED = false
GS_MAX_LEVEL = 25
GS_LOSE_GOLD_ON_DEATH = true
GS_MAXIMUM_ATTACK_SPEED = 600
GS_MINIMUM_ATTACK_SPEED = 20
GS_DISABLE_STASH_PURCHASING = true
GS_USE_CUSTOM_HERO_LEVELS = true

GS_CUSTOM_TEAM_PLAYER_COUNT = {}
GS_CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 4
GS_CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 0

GS_USE_CUSTOM_XP_VALUES = true
GS_XP_PER_LEVEL_TABLE = {}
for i = 1, GS_MAX_LEVEL do
  GS_XP_PER_LEVEL_TABLE[i] = (i -1 ) * 100
end

-- game logic
ROUND_BREAK_DURATION = 4
ROUND_TYPE_NORMAL = 0
ROUND_TYPE_BOSS = 1
LIGHTS_RADIUS = 900

-- particles
FX_ENEMY_REACHED_PORTAL = 'particles/econ/events/ti4/teleport_end_streak_ti4.vpcf'

-- sounds
SND_CLOCK_TICK = 'sounds/ui/deny_cooldown.vsnd'
SND_ROUND_START_NORMAL = 'sounds/music/stingers/greevil_stingers/greevil_camp_respawn.vsnd'
SND_ENEMY_REACHED_PORTAL = 'Hero_KeeperOfTheLight.Recall.Cast'
