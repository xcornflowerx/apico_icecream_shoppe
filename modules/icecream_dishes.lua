-- variables for mapping toppings to flavour names, prices, etc.
icecream_topping_prices = {
	flower131 = 0,
	morningdew = 1.5,
	honeydew = 1,
	spice1 = 2,
	spice2 = 2,
	spice3 = 2,
	spice4 = 2.5,
	spice5 = 2.5,
	icecream_shoppe_cookiedough = 3.5,
	icecream_shoppe_saltedcaramel = 3.5,
	icecream_shoppe_mintchocchip = 3.5
}

icecream_toppings = {
	"flower131",
	"morningdew",
	"honeydew",
	"spice1",
	"spice2",
	"spice3",
	"spice4",
	"spice5",
	"icecream_shoppe_cookiedough",
	"icecream_shoppe_saltedcaramel",
	"icecream_shoppe_mintchocchip"
}

icecream_flavours = {
	"icecream_shoppe_icecream_flavour01",
	"icecream_shoppe_icecream_flavour02",
	"icecream_shoppe_icecream_flavour03",
	"icecream_shoppe_icecream_flavour04",
	"icecream_shoppe_icecream_flavour05",
	"icecream_shoppe_icecream_flavour06",
	"icecream_shoppe_icecream_flavour07",
	"icecream_shoppe_icecream_flavour08",
	"icecream_shoppe_icecream_flavour09",
	"icecream_shoppe_icecream_flavour10",
	"icecream_shoppe_icecream_flavour11"
}

icecream_toppings_flavours_map = {
	flower131 = "icecream_shoppe_icecream_flavour01",
	morningdew = "icecream_shoppe_icecream_flavour02",
	honeydew = "icecream_shoppe_icecream_flavour03",
	spice1 = "icecream_shoppe_icecream_flavour04",
	spice2 = "icecream_shoppe_icecream_flavour05",
	spice3 = "icecream_shoppe_icecream_flavour06",
	spice4 = "icecream_shoppe_icecream_flavour07",
	spice5 = "icecream_shoppe_icecream_flavour08",
	icecream_shoppe_cookiedough = "icecream_shoppe_icecream_flavour09",
	icecream_shoppe_saltedcaramel = "icecream_shoppe_icecream_flavour10",
	icecream_shoppe_mintchocchip = "icecream_shoppe_icecream_flavour11"
}

secret_icecream_flavours = {"icecream_shoppe_cookiedough", "icecream_shoppe_saltedcaramel", "icecream_shoppe_mintchocchip"}

--[[
	Calls on the icecream maker dishes and ice cream flavour define functions.
--]]
function define_iceream_dishes()
	define_icecream_flavour_dishes()
	define_icecream_dishes()
	define_secret_toppings()
end

--[[
	Returns the ice cream flavour for the output based on the input topping.
	Sometimes returns a surprise :)
--]]
function get_icecream_flavour_by_topping(topping)
	local is_secret_topping = is_secret_icecream_topping(topping)

	-- if we hit a lucky number then we set the topping to the secret flavour the lucky num
	-- matches to only if the corresponding secret flavour isn't already known
	local lucky_num = math.random(0,100)
	if is_secret_topping == false then
		if lucky_num == 69
			and is_known_secret_flavour("icecream_shoppe_cookiedough") == false then
			topping = "icecream_shoppe_cookiedough"
			is_secret_topping = true
		elseif lucky_num == 7
			and is_known_secret_flavour("icecream_shoppe_saltedcaramel") == false then
			topping = "icecream_shoppe_saltedcaramel"
			is_secret_topping = true
		elseif lucky_num == 33
			and is_known_secret_flavour("icecream_shoppe_mintchocchip") == false then
			topping = "icecream_shoppe_mintchocchip"
			is_secret_topping = true
		end
	end

	-- if new secret topping discovered then update our player's data and
	-- update the ice cream shoppe stock
	if is_secret_topping == true
		and is_known_secret_flavour(topping) ~= true then
			update_known_secret_flavors(topping)
			update_icecream_shoppe_stock(topping)
	end
	return icecream_toppings_flavours_map[topping]
end

--[[
	Returns whether we already have a secret ingredient.
]]
function is_secret_icecream_topping(topping)
	for i=1,#secret_icecream_flavours do
		if topping == secret_icecream_flavours[i] then
			return true
		end
	end
	return false
end

--[[
	Checks if the secret flavour is already known to the player.
--]]
function is_known_secret_flavour(topping)
	if #KNOWN_SECRET_FLAVOURS_TABLE > 0 then
		for i=1,#KNOWN_SECRET_FLAVOURS_TABLE do
			if KNOWN_SECRET_FLAVOURS_TABLE[i] == topping then
				return true
			end
		end
	end
	return false
end

--[[
	Updates the player's data.json with the new secret topping discovered.
--]]
function update_known_secret_flavors(topping)
	table.insert(KNOWN_SECRET_FLAVOURS_TABLE, topping)
	api_set_data({known_secret_flavours = KNOWN_SECRET_FLAVOURS_TABLE})
	api_play_sound("confetti")
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
	Note: thanks spitefulfox for the spice cream category name!
--]]
function define_icecream_flavour_dishes()
	icecream_shop_buy = 0

	-- flavour01: topping = flower131
	api_define_object({
		id = "icecream_flavour01",
		name = "Cornflower Moments",
		category = "Ice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("flower131"),
		tooltip = "Tastes like all of your favorite flavors singing in perfect "
			.. "harmony with hints of ... - wait, is that glitter??",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour01.png")

	-- flavour02: topping = morningdew
	api_define_object({
		id = "icecream_flavour02",
		name = "Top o'the Morning(dew)!",
		category = "Ice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("morningdew"),
		tooltip = "The taste is reminiscent of a fresh early Spring morning.",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour02.png")

	-- flavour03: topping = honeydew
	api_define_object({
		id = "icecream_flavour03",
		name = "Sweet as Honey(dew)",
		category = "Ice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("honeydew"),
		tooltip = "Honeydew or honeydon't. There is no honeytry.",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour03.png")

	-- flavour04: topping = apise (spice1)
	api_define_object({
		id = "icecream_flavour04",
		name = "Apise o'Cake",
		category = "Spice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("spice1"),
		tooltip = "Apise-infused ice cream with cake bits and sprinkles.",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour04.png")

	-- flavour05: topping = calidus (spice2)
	api_define_object({
		id = "icecream_flavour05",
		name = "Coco-Calidus",
		category = "Spice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("spice2"),
		tooltip = "Made with a lovely bunch of coconuts (do-do-doo)...",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour05.png")

	-- flavour06: topping = roburrum (spice3)
	api_define_object({
		id = "icecream_flavour06",
		name = "Roburrum & Raisin",
		category = "Spice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("spice3"),
		tooltip = "Roburrum-spiced ice cream with raisins - nature's candy!",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour06.png")

	-- flavour07: topping = temperus (spice4)
	api_define_object({
		id = "icecream_flavour07",
		name = "Temperus Tantrum",
		category = "Spice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("spice4"),
		tooltip = "An ice cream bursting with flavors reminiscent of your childhood.",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour07.png")

	-- flavour08: topping = combustus (spice5)
	api_define_object({
		id = "icecream_flavour08",
		name = "Combust(us) A Move!",
		category = "Spice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("spice5"),
		tooltip = "An ice cream with a kick! A favorite among adventurous foodies.",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour08.png")

	-- flavour09: topping = cookiedough
	api_define_object({
		id = "icecream_flavour09",
		name = "Cookie Doughn't Ping Me, Please!",
		category = "Premium Ice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("icecream_shoppe_cookiedough"),
		tooltip = "A classic flavor and a favorite of one of the devs!",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour09.png")

	-- flavour10: topping = salted caramel
	api_define_object({
		id = "icecream_flavour10",
		name = "Salted Honey Caramel",
		category = "Premium Ice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("icecream_shoppe_saltedcaramel"),
		tooltip = "A favorite of one of the devs! The sweet and salty"
			.. "honey caramel are perfectly balanced to create this beelightful flavour!",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour10.png")

	-- flavour11: topping = mint chocolate chip
	api_define_object({
		id = "icecream_flavour11",
		name = "Musical Mint Chocolate Chip",
		category = "Premium Ice Cream",
		shop_buy = icecream_shop_buy,
		shop_sell = get_icecream_shop_sell_price("icecream_shoppe_mintchocchip"),
		tooltip = "A favorite of Port APICO's most famous composer! The flavor is musical,"
	 		.. "harmonic, and makes your taste buds (and yourself) dance!",
		tools = {"hammer1"}
	}, "sprites/icecream/flavour11.png")
end

--[[
	Defines the ice cream dishes that the ice cream is served in.
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

--[[
	Defines the toppings for the secret ice cream flavours.
--]]
function define_secret_toppings()
	-- topping09: cookie dough
	api_define_item({
		id = "cookiedough",
		name = "Cookiedough",
		category = "Ice Cream Topping",
		tooltip = "One of the secret toppings for ice cream",
		shop_buy = 1,
		shop_sell = 1
	}, "sprites/icecream/topping09.png")

	-- topping10: salted caramel
	api_define_item({
		id = "saltedcaramel",
		name = "Salted Honey Caramel",
		category = "Ice Cream Topping",
		tooltip = "One of the secret toppings for ice cream",
		shop_buy = 1,
		shop_sell = 1
	}, "sprites/icecream/topping10.png")

	-- topping11: mint chocolate chip
	api_define_item({
		id = "mintchocchip",
		name = "Mint Chocolate",
		category = "Ice Cream Topping",
		tooltip = "One of the secret toppings for ice cream",
		shop_buy = 1,
		shop_sell = 1
	}, "sprites/icecream/topping11.png")
end

-- might use these for later when more ingredients are added.
-- compiled_bee_produce = {
-- 	beepollen = 1,
-- 	sticky_pearl = 1,
-- 	comb_fragment = 1,
-- 	waxy_pearl = 1.5,
-- 	hivedust = 1.5,
-- 	shrouded_dye = 1.5,
-- 	sticky_shard = 1.5,
-- 	clay_dust = 1.5,
-- 	glowing_dye = 2,
-- 	stone = 0,
-- 	royal_jelly = 2,
-- 	wax_canister = 2,
-- 	wax_shard = 2,
-- 	glossy_pearl = 2,
-- 	sparkling_dye = 2,
-- 	icy_shard = 2,
-- 	charred_pearl = 2,
-- 	honeycore_shjard = 5,
-- 	random_seeds = 3
-- 	glorious_pearl = 2.5,
-- 	honeycomb_frame = 2.5,
-- 	unstable_dust = 2.5,
-- 	icy_dye = 2,
-- 	queens_pearl = 2.5,
-- 	disc_fragment = 2.5,
-- 	lightning_shard = 2.5,
-- 	hallowed_dye = 2,
-- 	blessed_pearl = 5,
-- 	random_jelly = 7
-- }
