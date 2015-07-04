-- ability
snowlord_mighty_fist = class({})

LinkLuaModifier("modifier_mighty_fist", "abilities/snowlord/modifier_mighty_fist.lua", LUA_MODIFIER_MOTION_NONE)

function snowlord_mighty_fist:GetIntrinsicModifierName()
	return 'modifier_mighty_fist'
end