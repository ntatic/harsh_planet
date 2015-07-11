if CHarshPlanet == nil then
    _G.CHarshPlanet = class({
        constructor = function(self)
            self.RoundsKV = LoadKeyValues('scripts/kv/rounds.kv')
            self.CurrentRound = nil
            self.RoundIndex = nil
            self.Lives = 50
            self.FX = {}
            self:_InitParticleSystem()
            self:_InitCustomLights()
            self:_InitGameRules()
            self:_InitEvents()
            Timers:CreateTimer(function()
                HUD:UpdateGameInfo()
                return 0.25
            end)
        end
    })
end

-- game have reached 00:00 time
function CHarshPlanet:GameStarts()
    self.RoundIndex = 1
    local sKey = tostring(self.RoundIndex)
    if not self.RoundsKV[sKey] then
        print('WARNING: There aren\'t any rounds defined.')
        self:EndGame(DOTA_TEAM_GOODGUYS)
    end
    self.CurrentRound = CRound(self.RoundIndex, self.RoundsKV[sKey], function() self:OnRoundEnds() end)
    self.CurrentRound:Start(GM_ROUND_COUNTDOWN)
end

-- called by CRound class when round is over
function CHarshPlanet:OnRoundEnds()
    local nextRoundIndex = self.RoundIndex + 1
    local sKey = tostring(nextRoundIndex)
    if not self.RoundsKV[sKey] then
        self:EndGame(DOTA_TEAM_GOODGUYS)
    else
        self.CurrentRound:Cleanup()
        self.RoundIndex = nextRoundIndex
        self.CurrentRound = CRound(self.RoundIndex, self.RoundsKV[sKey], function() self:OnRoundEnds() end)
        self.CurrentRound:Start(GM_ROUND_COUNTDOWN)
    end
end

function CHarshPlanet:LifeLost(livesWorth)
    self.Lives = self.Lives - livesWorth
    if self.Lives < 1 then
        self:EndGame(DOTA_TEAM_NEUTRALS)
    end
end

function CHarshPlanet:EndGame(winner)
    if winner == DOTA_TEAM_GOODGUYS then
        HUD:Notify('You WON!')
    else
        HUD:Notify('You LOST!')
    end
    GameRules:SetGameWinner(winner)
end

-- event "game_rules_state_change"
function CHarshPlanet:OnGameRulesStateChange()
    local state = GameRules:State_Get()
    if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
        -- nothing to do
    elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
        -- nothing to do
    elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:GameStarts()
    end
end

-- add particles to map
function CHarshPlanet:_InitParticleSystem()
    self.FX.portal = {dummy = nil, fx = nil}
    local portal = Entities:FindByName(nil, 'wp_portal')
    self.FX.portal.dummy = CreateUnitByName('npc_dummy', portal:GetAbsOrigin() - Vector(40, 60, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)
    Timers:CreateTimer(1, function()
        self.FX.portal.fx = ParticleManager:CreateParticle(FX_PORTAL, PATTACH_ABSORIGIN_FOLLOW, self.FX.portal.dummy)
    end)
end

-- add fow to custom light locations
function CHarshPlanet:_InitCustomLights()
    local lights = Entities:FindAllByName('fow*')
    for _, light in pairs(lights) do
        local radius = light:GetIntAttr('light_radius')
        if radius == 0 then radius = GM_LIGHTS_RADIUS end
        AddFOWViewer(DOTA_TEAM_GOODGUYS, light:GetAbsOrigin(), radius, 60 * 60 * 24, false)
    end
end

-- used by constructor to setup game mode rules
function CHarshPlanet:_InitGameRules()
    -- times
    GameRules:SetCustomGameSetupTimeout(0)
    GameRules:SetHeroSelectionTime(30)
    GameRules:SetPreGameTime(CFG_PRE_GAME_TIME)
    GameRules:SetPostGameTime(60)
    GameRules:SetTreeRegrowTime(60)
    -- misc
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(CFG_FOG_OF_WAR_DISABLED)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetHideKillMessageHeaders(true)
    GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    GameRules:GetGameModeEntity():SetFixedRespawnTime(30) 
    -- gold per time tick
    GameRules:SetGoldPerTick(0)
    GameRules:SetGoldTickTime(0)
    -- shop things
    GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
    GameRules:GetGameModeEntity():SetStashPurchasingDisabled(true)
    -- hero levels
    local maxLvl = 25
    local xpTable = {}
    GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(maxLvl)
    GameRules:SetUseCustomHeroXPValues(true)
    for i = 1, maxLvl do
        xpTable[i] = (i - 1) * 100
    end
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(xpTable)
    -- setup teams
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
    for i = 0, DOTA_MAX_PLAYERS - 1 do
        PlayerResource:SetCustomTeamAssignment(i, DOTA_TEAM_GOODGUYS)
    end
end

-- used by constructor to bind used game events
function CHarshPlanet:_InitEvents()
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)
end
