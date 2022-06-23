-- might use these for later when more ingredients are added.
-- compiled_bee_produce = {
-- 	beepollen = 1,
-- 	sticky_pearl = 1,
-- 	honeydew = 1,
-- 	comb_fragment = 1,
-- 	waxy_pearl = 1.5,
-- 	hivedust = 1.5,
-- 	morningdew = 1.5,
-- 	shrouded_dye = 1.5,
-- 	apise = 2,
-- 	sticky_shard = 1.5,
-- 	clay_dust = 1.5,
-- 	glowing_dye = 2,
-- 	stone = 0,
-- 	royal_jelly = 2,
-- 	wax_canister = 2,
-- 	wax_shard = 2,
-- 	glossy_pearl = 2,
-- 	calidus = 2,
-- 	sparkling_dye = 2,
-- 	icy_shard = 2,
-- 	charred_pearl = 2,
-- 	roburrum = 2,
-- 	honeycore_shjard = 5,
-- 	temperus = 2.5,
-- 	random_seeds = 3
-- 	glorious_pearl = 2.5,
-- 	honeycomb_frame = 2.5,
-- 	unstable_dust = 2.5,
-- 	icy_dye = 2,
-- 	combustus = 2.5,
-- 	queens_pearl = 2.5,
-- 	disc_fragment = 2.5,
-- 	lightning_shard = 2.5,
-- 	hallowed_dye = 2,
-- 	blessed_pearl = 5,
-- 	random_jelly = 7
-- }

-- variables for mapping toppings to flavour names, prices, etc.
icecream_topping_prices = {
	flower131 = 0,
	morningdew = 1.5
}
icecream_toppings = {"flower131",
	"morningdew"}
icecream_flavours = {"icecream_shoppe_icecream_flavour01",
	"icecream_shoppe_icecream_flavour02"}
icecream_toppings_flavours_map = {
	flower131 = "icecream_shoppe_icecream_flavour01",
	morningdew = "icecream_shoppe_icecream_flavour02"
}

--[[
	Calls on the icecream maker dishes and ice cream flavour define functions.
--]]
function define_iceream_dishes()
	define_icecream_flavour_dishes()
	define_icecream_dishes()
end

--[[
	Calculates the price of an ice cream with a given topping.
--]]
function get_icecream_shop_sell_price(topping)
	icecream_base_price = 3
	return icecream_base_price + icecream_topping_prices[topping]
end

--[[
	Defines the ice cream flavours.
	TODO: consider loading this from json file
--]]
function define_icecream_flavour_dishes()
	icecream_shop_buy = 0

	-- flavour01: topping = flower131
	api_define_object({
		id = "icecream_flavour01",
		name = "Cornflower Ice Cream",
		category = "Treat",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("flower131"),
		tooltip = "Homemade ice cream flavoured with Cornflowers",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour01.png")

	-- flavour02: topping = morningdew
	api_define_object({
		id = "icecream_flavour02",
		name = "Morningdew Ice Cream",
		category = "Treat",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("morningdew"),
		tooltip = "Homemade ice cream flavoured with morningdew",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour02.png")
end

--[[
	Defines the ice cream dishes that the ice cream is served in.
	TODO: add more dish designs?
--]]
function define_icecream_dishes()
	api_define_item({
		id = "icecream_dish01",
		name = "Ice Cream Serving Dish",
		category = "Tableware",
		tooltip = "A dish used for serving ice cream",
		shop_buy = 1,
		shop_sell = 1
	}, "sprites/icecream/dish01.png")
end
