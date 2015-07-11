-- namespace
AI = AI or {}

-- unit AI states
AI.STATE_IDLE = 0
AI.STATE_MOVE = 1
AI.STATE_ATTACK = 2

-- constant
AI.THINK_INTERVAL = 0.25

-- cached some values to optimize ai
AI.CACHE = false

-- init unit ai
function AI:Init(unit, params)
	if not AI.CACHE then
		AI:_Prepare()
	end
	unit.AI = {State = AI.STATE_IDLE}
	local func = AI['_BasicCreature']
	unit:SetContextThink(DoUniqueString('ai'), function() return func(AI, unit) end, AI.THINK_INTERVAL)
end

-- calculates 2d distance between two locations
function AI:Distance(vector1, vector2)
	xd = vector2.x - vector1.x
	yd = vector2.y - vector1.y
	return math.sqrt(xd * xd + yd * yd)
end

-- cache some common values
function AI:_Prepare()
	AI.CACHE = {Locations = {}, DistanceToPortal = {}, Target = {}}
	AI.CACHE.Locations['wp_portal'] = Entities:FindByName(nil, 'wp_portal'):GetAbsOrigin()
	local waypoints = Entities:FindAllByName('wp*')
	for _, wp in pairs(waypoints) do
		AI.CACHE.Locations[wp:GetName()] = wp:GetAbsOrigin()
		AI.CACHE.DistanceToPortal[wp:GetName()] = AI:Distance(wp:GetAbsOrigin(), AI.CACHE.Locations['wp_portal'])
		local targets = Entities:FindAllByTarget(wp:GetName())
		for _, t in pairs(targets) do
			AI.CACHE.Target[t:GetName()] = wp:GetName()
		end
	end
end

-- aggro logic
function AI:_TryToAggro(unit)
	if unit.AI.State ~= AI.STATE_ATTACK then
		local targets = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, unit:GetAbsOrigin(), nil, unit:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if table.getn(targets) > 0 then
			-- find closest unit range that can be attacked
			for i = 1, table.getn(targets) do
				if targets[i]:IsAlive() and not targets[i]:IsAttackImmune() then
					-- found unit to atack
					unit.AI.State = AI.STATE_ATTACK
					-- first stop any current actions
					unit:Stop()
					-- issue attack
					ExecuteOrderFromTable({UnitIndex = unit:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET, TargetIndex = targets[i]:GetEntityIndex(), Queue = true})
				end
			end
		end
	end
end

-- movement logic
function AI:_MoveToPortal(unit)
	if unit.AI.State == AI.STATE_IDLE then
		-- set current state
		unit.AI.State = AI.STATE_MOVE
		-- find closest waypoint
		local distanceToPortal = AI:Distance(unit:GetAbsOrigin(), AI.CACHE.Locations['wp_portal'])
		local wp = Entities:FindByNameNearest('wp*', unit:GetAbsOrigin(), 0)
		local wpName = wp:GetName()
		-- if waypoint is further than unit move to next in chain
		if AI.CACHE.DistanceToPortal[wp:GetName()] > distanceToPortal and AI.CACHE.Target[wp:GetName()] then
			wpName = AI.CACHE.Target[wp:GetName()]
		end
		-- stop any unit actions
		unit:Stop()
		-- fire move orders
		while true do
			ExecuteOrderFromTable({
				UnitIndex = unit:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION, Position = AI.CACHE.Locations[wpName], Queue = true})
			if AI.CACHE.Target[wpName] then
				wpName = AI.CACHE.Target[wpName]
			else
				break
			end
		end
	end
end

-- unit will move to portal and attack any enemies it encounters
function AI:_BasicCreature(unit)
	-- if unit is idle set state to AI_STATE_IDLE
	if unit:IsIdle() then unit.AI.State = AI.STATE_IDLE end
	-- try to attack anyone close
	AI:_TryToAggro(unit)
	-- otherwise move to portal
	AI:_MoveToPortal(unit)
	-- time until next think interval
	return AI.THINK_INTERVAL
end
