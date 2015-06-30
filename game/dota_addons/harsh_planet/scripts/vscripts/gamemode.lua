if GameMode == nil then
    _G.GameMode = class({})
end

-- initialize game
function GameMode:InitGameMode()
    -- setup rules
    Util:SetupGameRules(self)
    -- load waypoints, todo: better entities name
    -- special
    GameRules.waypoints = {}
    GameRules.waypoints['Special'] = {}
    GameRules.waypoints['Special']['AllyPortal'] = {Position = Entities:FindByName(nil, 'p_ally_portal'):GetAbsOrigin()}
    GameRules.waypoints['Special']['EnemyKillPit'] = {Position = Entities:FindByName(nill, 'p_enemy_killpit'):GetAbsOrigin()}
    GameRules.waypoints['Special']['SpawnForPath1'] = {Position = Entities:FindByName(nil, 'p_enemy1_start'):GetAbsOrigin()}
    GameRules.waypoints['Special']['SpawnForPath2'] = {Position = Entities:FindByName(nil, 'p_enemy2_start'):GetAbsOrigin()}
    -- paths
    GameRules.waypoints['Path1'] = {}
    GameRules.waypoints['Path2'] = {}
    for i = 1, 8 do
        local pos1 = Entities:FindByName(nil, "p_enemy1_path" .. i):GetAbsOrigin()
        local pos2 = Entities:FindByName(nil, "p_enemy2_path" .. i):GetAbsOrigin()
        GameRules.waypoints['Path1'][i] = {Position = pos1, DistanceToPortal = AI:Distance(pos1, GameRules.waypoints['Special']['AllyPortal']['Position'])}
        GameRules.waypoints['Path2'][i] = {Position = pos2, DistanceToPortal = AI:Distance(pos2, GameRules.waypoints['Special']['AllyPortal']['Position'])}
    end
    -- setup lights
    for i = 1, 10 do
        local location = Entities:FindByName(nil, 'fow' .. i)
        if location ~= nil then
            local radius = location:GetIntAttr('light_radius')
            if radius == 0 then radius = 900 end
            AddFOWViewer(DOTA_TEAM_GOODGUYS, location:GetAbsOrigin(), radius, 60 * 60 * 60, false)
        end
    end
    -- ensure particle portal teleport play
    AddFOWViewer(DOTA_TEAM_GOODGUYS, GameRules.waypoints['Special']['EnemyKillPit']['Position'], 200, 60 * 60 * 60, false)
    -- Setup round tracker
    GameRules.rounds = {}
    GameRules.rounds['CurrentRound'] = 0
    GameRules.rounds['RoundCount'] = 2
    GameRules.rounds['EnemyAlive'] = 0
    GameRules.rounds['SpawnInProgress'] = false
    -- setup rounds
    -- round 1
    GameRules.rounds['Round1_Title'] = 'Skeletons invasion'
    GameRules.rounds['Round1_Type'] = ROUND_TYPE_NORMAL
    GameRules.rounds['Round1_Unit'] = 'enemy_bat enemy_spectre enemy_fire_golem'
    GameRules.rounds['Round1_CountPerSide'] = '4 8 4'
    GameRules.rounds['Round1_TinkerFunc'] = 'Basic Basic Basic'
    -- round 2
    GameRules.rounds['Round2_Title'] = 'Winter is comming'
    GameRules.rounds['Round2_Type'] = ROUND_TYPE_NORMAL
    GameRules.rounds['Round2_Unit'] = 'enemy_fire_golem'
    GameRules.rounds['Round2_CountPerSide'] = '10'
    GameRules.rounds['Round2_TinkerFunc'] = 'Basic'
end

-- handle game state changes
function GameMode:OnGameRulesStateChange(keys)
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        GameMode:OnGameInProgress()
    end
end

-- game reached 00:00 time
function GameMode:OnGameInProgress()
    GameMode:StartNextRound()
end

-- called everytime time unit is killed
function GameMode:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript(keys.entindex_killed)
    if killedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then GameRules.rounds['EnemyAlive'] = GameRules.rounds['EnemyAlive'] - 1 end
    if GameRules.rounds['EnemyAlive'] == 0 and GameRules.rounds['SpawnInProgress'] == false then GameMode:EndRound() end
end

-- starts next round
function GameMode:StartNextRound()
    GameRules.rounds['CurrentRound'] = GameRules.rounds['CurrentRound'] + 1
    local p_round = 'Round' .. GameRules.rounds['CurrentRound'] .. '_'
    local countdown = ROUND_COUNTDOWN
    Timers:CreateTimer(function()
        if countdown > 0 then
            HUD:Notify('<font color="#FB535B">Round ' .. GameRules.rounds['CurrentRound'] .. ':</font> starting in <font color="#FB535B">' .. countdown .. '</font>...')
            countdown = countdown - 1
            return 1.0
        else
            if GameRules.rounds[p_round .. 'Type'] == ROUND_TYPE_NORMAL then
                GameMode:SpawnNormalRound(p_round)
            elseif GameRules.rounds[p_round .. 'Type'] == ROUND_TYPE_BOSS then
                GameRules:SpawnBossRound(p_round)
            end            
        end
    end)
end

-- round is over
function GameMode:EndRound()
    if GameRules.rounds['CurrentRound'] == GameRules.rounds['RoundCount'] then
        HUD:Notify('<font color="#FB535B">You won!</font>')
    else
        HUD:Notify('<font color="#FB535B">Round completed!</font>')
        HUD:Notify('Prepare yourself for next round.')
        Timers:CreateTimer(ROUND_BREAK_DURATION, function()
            GameMode:StartNextRound()
        end)
    end
end

-- spawn normal round
function GameMode:SpawnNormalRound(p_round)
    HUD:Notify('<font color="#FB535B">Round ' .. GameRules.rounds['CurrentRound'] .. ':</font> <font color="#7293C8">' .. GameRules.rounds[p_round .. 'Title'] .. '</font>')
    GameRules.rounds['SpawnInProgress'] = true
    local unit_names = Util:ExplodeAsString(' ', GameRules.rounds[p_round .. 'Unit'])
    local unit_counts = Util:ExplodeAsInt(' ', GameRules.rounds[p_round .. 'CountPerSide'])
    local unit_tfuncs = Util:ExplodeAsString(' ', GameRules.rounds[p_round .. 'TinkerFunc'])
    local spawn_delay = 0
    for i = 1, table.getn(unit_names) do
        local unit_name = unit_names[i]
        local unit_count = unit_counts[i]
        local unit_tfunc = unit_tfuncs[i]
        for j = 1, unit_count do
            spawn_delay = spawn_delay + 0.8
            Timers:CreateTimer(spawn_delay, function()
                local unit1 = CreateUnitByName(unit_name, GameRules.waypoints['Special']['SpawnForPath1']['Position'], true, nil, nil, DOTA_TEAM_BADGUYS)
                local unit2 = CreateUnitByName(unit_name, GameRules.waypoints['Special']['SpawnForPath2']['Position'], true, nil, nil, DOTA_TEAM_BADGUYS)
                AI:SetParams(unit1, {PreferedPath = 1, State = AI_STATE_IDLE})
                AI:SetParams(unit2, {PreferedPath = 2, State = AI_STATE_IDLE})
                AI:SetContextThinkSmart(unit1, unit_tfunc)
                AI:SetContextThinkSmart(unit2, unit_tfunc)
                GameRules.rounds['EnemyAlive'] = GameRules.rounds['EnemyAlive'] + 2
                if j == unit_count and i == table.getn(unit_names) then GameRules.rounds['SpawnInProgress'] = false end
            end)
        end
    end
end

-- spawn boss round
function GameMode:SpawnBossRound(p_round)
end