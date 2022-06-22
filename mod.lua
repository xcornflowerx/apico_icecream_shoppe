-- cornflower's ice cream shoppe mod
-- cornflower hex code #6495ed, rgb = (100,149,237)

MOD_NAME = "icecream_shoppe"

function register()
	return {
		name = MOD_NAME,
		hooks = {"ready"},
		modules = {"cornflower", "icecream_dishes", "icecream_maker"}
	}
end

function ready()
	-- this is where we would set things up if we had anything to set up :)
end

function init()
	define_cornflower()
	define_iceream_dishes()
	define_icecream_maker()
	return "Success"
end

