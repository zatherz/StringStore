stringstore.noita = stringstore.noita or {}

stringstore.noita.globals = {
	set_type = function(key, val)
		GlobalsSetValue(key .. ".type", val)
	end,

	set = function(key, val)
		GlobalsSetValue(key, val)
	end,

	get_type = function(key, val)
		return GlobalsGetValue(key .. ".type")
	end,

	get = function(key)
		return GlobalsGetValue(key)
	end,

	get_sub_prefix = function(key)
		return key .. ".idx."
	end,

	get_typed_key = function(key, type)
		return key .. ":" .. type
	end,

	restrict = function(key)
		if key:find("\\.") or key:find(":") then
			error("Cannot use the dot ('.') character or the colon character (':') in the Globals stringstore")
		end
	end
}