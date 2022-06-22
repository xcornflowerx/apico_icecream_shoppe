-- cornflower's ice cream shoppe mod
-- cornflower hex code #6495ed, rgb = (100,149,237)

MOD_NAME = "icecream_shoppe"

function register()
	return {
		name = MOD_NAME,
		hooks = {"ready"},
		modules = {"cornflower"}
	}
end

function ready()
end


function init()
	api_set_devmode(true)
	define_cornflower()
	return "Success"
end
