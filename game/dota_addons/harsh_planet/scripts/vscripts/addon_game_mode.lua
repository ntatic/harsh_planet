require('libs/timers')
require('vars')
require('gamemode')
require('util')
require('ai')
require('hud')

-- precache assets
function Precache(context)
    -- particles
    PrecacheResource('particle', FX_ENEMY_REACHED_PORTAL, context)
    for _, file in pairs(FX_AMBIENT) do
        PrecacheResource('particle', file, context)
    end
    -- units
    PrecacheUnitByNameSync('enemy_kobold', context)
    PrecacheUnitByNameSync('enemy_wolf', context)
    PrecacheUnitByNameSync('enemy_obsidian_golem', context)
    PrecacheUnitByNameSync('enemy_obsidian_guard', context)
    PrecacheUnitByNameSync('enemy_spectre', context)
    PrecacheUnitByNameSync('enemy_boss_snowlord', context)
    -- sounds
    PrecacheResource('soundfile', 'soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts', context)
end

-- Create the game mode when we activate
function Activate()
    GameRules.GameMode = GameMode()
    GameRules.GameMode:InitGameMode()
end
