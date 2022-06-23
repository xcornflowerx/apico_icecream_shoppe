MOD_NAME = "icecream_shoppe"
KNOWN_SECRET_FLAVOURS_TABLE = {}

function register()
	return {
		name = MOD_NAME,
		hooks = {},
		modules = {"cornflower", "cornflower_flower", "icecream_dishes", "icecream_maker"}
	}
end

function init()
	-- load user data (used for determining if the secret ice cream flavours have been discovered yet)
	api_get_data()

	-- other define calls for the ice cream shoppe
	define_cornflower() -- the npc, not the flower
	define_cornflower_flower() -- :)
	define_iceream_dishes()
	define_icecream_maker()

	return "Success"
end

function data(ev, data)
	if ev == "LOAD" and data ~= nil then
		KNOWN_SECRET_FLAVOURS_TABLE = data["known_secret_flavours"]
		override_icecream_shoppe_stock(get_cornflower(), KNOWN_SECRET_FLAVOURS_TABLE)
	elseif ev == "SAVE" then
		if data == nil then
			api_log("data", "failed to update our data.json")
		end
	end
end
