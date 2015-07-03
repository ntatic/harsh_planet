-- namespace
Util = Util or {}

-- Give this man cookie https://github.com/bmddota
function Util:SetupGameRules(game_mode)
	-- rules
	GameRules:SetHeroRespawnEnabled(GS_ENABLE_HERO_RESPAWN)
	GameRules:SetSameHeroSelectionEnabled(GS_ALLOW_SAME_HERO_SELECTION)
	GameRules:SetHeroSelectionTime(GS_HERO_SELECTION_TIME)
	GameRules:SetPreGameTime(GS_PRE_GAME_TIME)
	GameRules:SetPostGameTime(GS_POST_GAME_TIME)
	GameRules:SetTreeRegrowTime(GS_TREE_REGROW_TIME)
	GameRules:SetFirstBloodActive(GS_ENABLE_FIRST_BLOOD)
	GameRules:SetHideKillMessageHeaders(GS_HIDE_KILL_BANNERS)
	GameRules:SetUseCustomHeroXPValues(GS_USE_CUSTOM_XP_VALUES)
	GameRules:SetGoldPerTick(GS_GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GS_GOLD_TICK_TIME)
	if GS_CUSTOM_TEAM_PLAYER_COUNT then
		for team, number in pairs(GS_CUSTOM_TEAM_PLAYER_COUNT) do
	  		GameRules:SetCustomGameTeamMaxPlayers(team, number)
		end
	end
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(GS_RECOMMENDED_BUILDS_DISABLED)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(GS_DISABLE_FOG_OF_WAR_ENTIRELY)
	GameRules:GetGameModeEntity():SetAnnouncerDisabled(GS_DISABLE_ANNOUNCER)
	GameRules:GetGameModeEntity():SetFixedRespawnTime(GS_FIXED_RESPAWN_TIME) 
	GameRules:GetGameModeEntity():SetBuybackEnabled(GS_BUYBACK_ENABLED)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(GS_LOSE_GOLD_ON_DEATH)
	GameRules:GetGameModeEntity():SetMaximumAttackSpeed(GS_MAXIMUM_ATTACK_SPEED)
	GameRules:GetGameModeEntity():SetMinimumAttackSpeed(GS_MINIMUM_ATTACK_SPEED)
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled(GS_DISABLE_STASH_PURCHASING)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(GS_USE_CUSTOM_HERO_LEVELS)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(GS_MAX_LEVEL)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(GS_XP_PER_LEVEL_TABLE)
	-- events
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(game_mode, 'OnGameRulesStateChange'), game_mode)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(game_mode, 'OnEntityKilled'), game_mode)
	ListenToGameEvent('dota_player_killed', Dynamic_Wrap(game_mode, 'OnPlayerKilled'), game_mode)
	ListenToGameEvent('player_spawn', Dynamic_Wrap(game_mode, 'OnPlayerSpawn'), game_mode)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(game_mode, 'OnPlayerPickHero'), game_mode)
end

-- explode string
function Util:ExplodeAsString(delimeter, input_string)
	if delimeter == '' then return false end
	local p = 0
	local result = {}
	local add_index = 1
	for st, sp in function() return string.find(input_string, delimeter, p, true) end do
		result[add_index] = string.sub(input_string, p, st - 1)
		add_index = add_index + 1
		p = sp + 1
	end
	result[add_index] = string.sub(input_string, p)
	return result
end

-- explode string and tries to return table filled with numbers
function Util:ExplodeAsInt(delimeter, input_string)
	local str_arr = Util:ExplodeAsString(delimeter, input_string)
	if str_arr == false then return false end
	local result = {}
	for i = 1,  table.getn(str_arr) do
		local val = tonumber(str_arr[i])
		if val == nil then return false end
		result[i] = val
	end
	return result
end

function Util:print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end