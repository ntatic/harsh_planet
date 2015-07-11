-- namespace
HUD = HUD or {}

-- displays notification
function HUD:Notify(text, duration)
    duration = duration or 3
    CustomGameEventManager:Send_ServerToAllClients('ce_hud_notification', {Text = text, Duration = duration});
end

function HUD:UpdateGameInfo()
    local json = {}
    local gm = GameRules.GameMode
    json.Lives = gm.Lives
    json.Players = {}
    for i = 0, DOTA_MAX_PLAYERS - 1 do
        if PlayerResource:IsValidPlayer(i) then
            local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
            if hero ~= nil then
                json.Players[i] = {HeroName = hero:GetUnitName(), Alive = hero:IsAlive()}
            else
                json.Players[i] = {HeroName = 'npc_dota_hero_none', Alive = true}
            end
        end
    end
    CustomGameEventManager:Send_ServerToAllClients('ce_hud_update_gameinfo', json)
end

function HUD:UpdateRoundInfo(round)
    local json = {}
    if round ~= nil then
        json.Round = round:GetInfo()
    else
        json.Round = false
    end
    CustomGameEventManager:Send_ServerToAllClients('ce_hud_update_roundinfo', json)
end
