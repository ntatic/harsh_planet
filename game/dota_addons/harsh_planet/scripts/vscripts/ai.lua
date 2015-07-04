-- namespace
AI = AI or {}

-- unit AI states
AI.STATE_IDLE = 0
AI.STATE_MOVE = 1
AI.STATE_ATTACK = 2

-- Writes params to unit that are used with AI
function AI:SetParams(unit, params)
	if unit.ai == nil then unit.ai = {} end
	for key, value in pairs(params) do
		unit.ai[key] = value
	end
end

-- Set unit think method that pass unit to tinker function
function AI:SetContextThinkSmart(unit, func_name)
	local func = AI[func_name]
	unit:SetContextThink(DoUniqueString('ai'), function() return func(AI, unit) end, 0.25)
end

-- calculates 2d distance between two locations
function AI:Distance(vector1, vector2)
	xd = vector2.x - vector1.x
	yd = vector2.y - vector1.y
	return math.sqrt(xd * xd + yd * yd)
end

-- todo
function AI:Basic(unit)
	-- if unit is idle set state to AI_STATE_IDLE
	if unit:IsIdle() then unit.ai.state = AI.STATE_IDLE end
	-- try to find valid target to atack
	if unit.ai.state ~= AI.STATE_ATTACK then
		local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS, unit:GetAbsOrigin(), nil, unit:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if table.getn(targets) > 0 then
			-- find closest unit range that can be attacked
			for i = 1, table.getn(targets) do
				if targets[i]:IsAlive() and not targets[i]:IsAttackImmune() then
					-- found unit to atack
					unit.ai.state = AI.STATE_ATTACK
					-- first stop any current actions
					unit:Stop()
					-- issue attack
					ExecuteOrderFromTable({UnitIndex = unit:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET, TargetIndex = targets[i]:GetEntityIndex(), Queue = true})
					-- exit tinker
					return 0.25
				end
			end
		end
	end
	-- if unit is idle move it to portal
	if unit.ai.state == AI.STATE_IDLE then
		unit.ai.state = AI.STATE_MOVE
		-- setup few common vars used
		local unit_position = unit:GetAbsOrigin()
		local ally_portal_position = GameRules.waypoints['Special']['AllyPortal']['Position']
		local distance_to_portal = AI:Distance(unit_position, ally_portal_position)
		local path1_bonus_score = 0
		local path2_bonus_score = 0
		if unit.ai['PreferedPath'] == 1 then path2_bonus_score = 500 else path1_bonus_score = 500 end
		-- set ally portal as current best waypoint
		local best = {Portal = true, Score = distance_to_portal, Path = 0, Order = 0}
		-- check to see if nearest path 1 waypoint is better
		local e_waypoint1 = Entities:FindByNameNearest('p_enemy1_path*', unit_position, 0)
		local waypoint1 = {Portal = false, Score = AI:Distance(unit_position, e_waypoint1:GetAbsOrigin()) + path1_bonus_score, Path = 1, Order = tonumber(string.sub(e_waypoint1:GetName(), -1, -1))}
		if waypoint1['Score'] < best['Score'] then
			best = waypoint1
		end
		-- check to see if nearest path 2 waypoint is better
		local e_waypoint2 = Entities:FindByNameNearest('p_enemy2_path*', unit_position, 0)
		local waypoint2 = {Portal = false, Score = AI:Distance(unit_position, e_waypoint2:GetAbsOrigin()) + path2_bonus_score, Path = 2, Order = tonumber(string.sub(e_waypoint2:GetName(), -1, -1))}
		if waypoint2['Score'] < best['Score'] then
			best = waypoint2
		end
		-- stop any unit actions
		unit:Stop()
		-- five move orders
		if not best['Portal'] then
			-- join trough waypoints
			for i = best['Order'], 8 do
				ExecuteOrderFromTable({UnitIndex = unit:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION, Position = GameRules.waypoints['Path' .. best['Path']][i]['Position'], Queue = true})
			end
		end
		-- finaly move to portal
		ExecuteOrderFromTable({UnitIndex = unit:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION, Position = ally_portal_position, Queue = true})
		-- exit tinker
		return 0.25
	end
	return 0.25
end

function AI:BossSnowMaster(unit)
	-- if unit is idle set state to AI_STATE_IDLE
	if unit:IsIdle() then unit.ai.state = AI.STATE_IDLE end
	-- just get to portal with shorttest path
 end