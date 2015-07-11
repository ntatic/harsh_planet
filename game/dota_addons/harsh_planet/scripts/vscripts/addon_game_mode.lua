require('libs/timers')
require('libs/physics')
require('Util')
require('Config')
require('AI')
require('HUD')
require('CRound')
require('CHarshPlanet')

-- precache assets
function Precache(context)
    -- precache units
    local units = LoadKeyValues('scripts/npc/npc_units_custom.txt')
    for key, _ in pairs(units) do
        if key ~= 'Version' then PrecacheUnitByNameSync(key, context) end
    end
    -- precache particles
    for _, fx in pairs(PC_FX) do
        PrecacheResource('particle', fx, context)
    end
    for _, fx in pairs(FX_AMBIENT) do
        PrecacheResource('particle', fx, context)
    end
    -- precache sounds
    for _, snd in pairs(PC_SND) do
        PrecacheResource('soundfile', snd, context)
    end
end

-- start game mode
function Activate()
    GameRules.GameMode = CHarshPlanet()
end
