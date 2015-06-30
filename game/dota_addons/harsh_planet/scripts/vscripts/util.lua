Util = Util or {}

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