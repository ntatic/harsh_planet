if GameMode == nil then
    _G.GameMode = class({})
end

-- initialize game
function GameMode:InitGameMode()
  -- setup rules
  GameRules:SetHeroRespawnEnabled(GS_ENABLE_HERO_RESPAWN)
  GameRules:SetSameHeroSelectionEnabled(GS_ALLOW_SAME_HERO_SELECTION)
  GameRules:SetHeroSelectionTime(GS_HERO_SELECTION_TIME)
  GameRules:SetPreGameTime(GS_PRE_GAME_TIME)
  GameRules:SetPostGameTime(GS_POST_GAME_TIME)
  GameRules:SetTreeRegrowTime(GS_TREE_REGROW_TIME)
  GameRules:SetFirstBloodActive(GS_ENABLE_FIRST_BLOOD)
  GameRules:SetHideKillMessageHeaders(GS_HIDE_KILL_BANNERS)
   GameRules:SetUseCustomHeroXPValues(GS_USE_CUSTOM_XP_VALUES)
  if GS_CUSTOM_TEAM_PLAYER_COUNT then
    for team, number in pairs(GS_CUSTOM_TEAM_PLAYER_COUNT) do
      GameRules:SetCustomGameTeamMaxPlayers(team, number)
    end
  end
  GameMode.mode = nil
  -- setup events
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
  -- load waypoints
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
  elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return nil
  end
  return 1
end

function GameMode:OnConnectFull(keys)
  if GameMode.mode == nil then
    GameMode.mode = GameRules:GetGameModeEntity()
    GameMode.mode:SetRecommendedItemsDisabled(GS_RECOMMENDED_BUILDS_DISABLED)
    GameMode.mode:SetFogOfWarDisabled(GS_DISABLE_FOG_OF_WAR_ENTIRELY)
    GameMode.mode:SetAnnouncerDisabled(GS_DISABLE_ANNOUNCER)
    GameMode.mode:SetFixedRespawnTime(GS_FIXED_RESPAWN_TIME) 
    GameMode.mode:SetBuybackEnabled(GS_BUYBACK_ENABLED)
    GameMode.mode:SetLoseGoldOnDeath(GS_LOSE_GOLD_ON_DEATH)
    GameMode.mode:SetMaximumAttackSpeed(GS_MAXIMUM_ATTACK_SPEED)
    GameMode.mode:SetMinimumAttackSpeed(GS_MINIMUM_ATTACK_SPEED)
    GameMode.mode:SetStashPurchasingDisabled(GS_DISABLE_STASH_PURCHASING)
    GameMode.mode:SetUseCustomHeroLevels(GS_USE_CUSTOM_HERO_LEVELS)
    GameMode.mode:SetCustomHeroMaxLevel(GS_MAX_LEVEL)
    GameMode.mode:SetCustomXPRequiredToReachNextLevel(GS_XP_PER_LEVEL_TABLE)
  end
end

-- game reached 00:00 time
function GameMode:OnGameInProgress()
  GameMode:EndRound();
end

-- called everytime time unit is killed
function GameMode:OnEntityKilled(keys)
  local killedUnit = EntIndexToHScript(keys.entindex_killed)
  if killedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then GameRules.rounds['EnemyAlive'] = GameRules.rounds['EnemyAlive'] - 1 end
  if GameRules.rounds['EnemyAlive'] == 0 and GameRules.rounds['SpawnInProgress'] == false then GameMode:EndRound() end
end

function GameMode:StartNextRound()
  GameRules.rounds['CurrentRound'] = GameRules.rounds['CurrentRound'] + 1
  local p_round = 'Round' .. GameRules.rounds['CurrentRound'] .. '_'
  if GameRules.rounds[p_round .. 'Type'] == ROUND_TYPE_NORMAL then
    GameMode:SpawnNormalRound(p_round)
  end
end

function GameMode:EndRound()
  if GameRules.rounds['CurrentRound'] == GameRules.rounds['RoundCount'] then
    HUD:Notify('You won!')
    EmitGlobalSound(SND_ROUND_START_NORMAL)
  else
    if GameRules.rounds['CurrentRound'] == 0 then
      HUD:Notify('Prepare yourself for battle!')
    else  
      HUD:Notify('You successfully stopped enemy!')
      Timers:CreateTimer(5, function()
        HUD:Notify('Prepare yourself for battle!')
      end)
    end
    local countdown = ROUND_BREAK_DURATION - 1
    Timers:CreateTimer(1, function()
      if countdown > 0 then
        HUD:Notify('Round ' .. (GameRules.rounds['CurrentRound'] + 1) .. ' starting in ' .. countdown)
        EmitGlobalSound(SND_CLOCK_TICK)
        countdown = countdown - 1
        return 1.0
      else
        GameMode:StartNextRound()
      end
    end)    
  end
end

function GameMode:SpawnNormalRound(p_round)
  HUD:Notify('Round ' .. GameRules.rounds['CurrentRound'] .. ': ' .. GameRules.rounds[p_round .. 'Title'])
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

function GameMode:SpawnBossRound(p_round)
end