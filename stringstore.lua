stringstore = { stores = {} }

function stringstore.convert_to_string(val)
	local val_type = type(val)
	if val_type == "function" then
		error("Serializing functions is not supported")
	end

	return tostring(val)
end

function stringstore.convert_from_string(target_type, key, storeinfo)
	if target_type == "nil" then return nil end
	if target_type == "string" then return storeinfo.get(key) end
	if target_type == "number" then return tonumber(storeinfo.get(key)) end
	if target_type == "table" then
		return stringstore.create_store(storeinfo, storeinfo.get_sub_prefix(key))
	end
	if target_type == "boolean" then return storeinfo.get(key) == "true" end
	error("Unsupported target type: " .. target_type)
end

function stringstore.create_store(storeinfo, base_key)
	if not storeinfo.set_type then error("Missing storeinfo 'set_type' field") end
	if not storeinfo.set then error("Missing storeinfo 'set' field") end	
	if not storeinfo.get_type then error("Missing storeinfo 'get_type' field") end
	if not storeinfo.get then error("Missing storeinfo 'get' field") end

	return setmetatable({},
	{
		__newindex = function(self, key, val)
			storeinfo.restrict(tostring(key))
			key = storeinfo.get_typed_key(key, type(key))
			if base_key then
				key = base_key .. key
			end
			local val_type = type(val)
			storeinfo.set_type(key, val_type)
			if (val_type == "table") then
				for k, v in pairs(val) do
					stringstore.convert_from_string("table", key, storeinfo)[k] = v
				end
			else
				storeinfo.set(key, tostring(val))
			end

		end,

		__index = function(self, key)
			storeinfo.restrict(tostring(key))
			key = storeinfo.get_typed_key(key, type(key))
			if base_key then
				key = base_key .. key
			end
			local val_type = storeinfo.get_type(key)
			if (val_type == nil) then return nil end
			return stringstore.convert_from_string(val_type, key, storeinfo)
		end
	})
end

return stringstore
