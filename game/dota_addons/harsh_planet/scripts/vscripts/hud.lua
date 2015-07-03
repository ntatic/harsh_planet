-- namespace
HUD = HUD or {}

-- displays notification
function HUD:Notify(text, duration)
    duration = duration or 3
    CustomGameEventManager:Send_ServerToAllClients('ce_notification', {Text = text, Duration = duration});
end

-- update game hud
function HUD:HudUpdate()
    local data = {Round = {}, Players = {}, Lives = 0, Countdown = {}}
    -- round data
    local p_round = GameRules.rounds['CurrentRound']
    data['Round']['Level'] = p_round
    data['Round']['Type'] = GameRules.rounds['Round' .. p_round .. '_Type']
    data['Round']['Title'] = GameRules.rounds['Round' .. p_round .. '_Title']
    if GameRules.rounds['TotalEnemies'] > 0 then
    	data['Round']['Progress'] = GameRules.rounds['EnemyKilled'] / GameRules.rounds['TotalEnemies']
    else
    	data['Round']['Progress'] = 0
    end
    -- players data
    local t_players = {}
    for i = 0, DOTA_MAX_PLAYERS - 1 do
        if PlayerResource:IsValidPlayer(i) then
            t_players[i] = {HeroName = 'npc_dota_hero_none', Alive = true}
            local hero = PlayerResource:GetPlayer(i):GetAssignedHero();
            if hero ~= nil then
                t_players[i]['HeroName'] = hero:GetUnitName()
                t_players[i]['Alive'] = hero:IsAlive()
            end
        end
    end
    data['Players'] = t_players
    -- lives
    data['Lives'] = GameRules.Lives
    -- countdown
    data['Countdown'] = {Enabled = GameRules.hud['CountdownEnabled'], Value = GameRules.hud['CountdownValue']}
    -- send event
    CustomGameEventManager:Send_ServerToAllClients('ce_hud_update', data);
end