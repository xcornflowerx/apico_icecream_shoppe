ICECREAM_SHOPPE_STOCK = {"icecream_shoppe_icecream_maker", "seed131", "icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"}

--[[
    Not to be confused with the script where we define a new flower object :)
    This is meant to define the npc named cornflower.
--]]
function define_cornflower()
    npc_def = {
        id = 131,
        name = "Cornflower",
        pronouns = "She/Her",
        tooltip = "Hey there!",
        shop = true,
        walking = true,
        stock = {"seed131", "icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"},
        specials = {"icecream_shoppe_icecream_maker", "icecream_shoppe_icecream_maker", "icecream_shoppe_icecream_maker"},
        dialogue = {
            "Wanna learn how to make some ice cream yourself?",
            "Excellent!  I am happy to guide you through the process!",
            "To start, you will need an ice cream maker, at least 3 snowballs, and your choice of topping.",
            "Don't worry if you don't own an ice cream maker yet - I always carry some in my shop! "
            .. "Unforunately, you'll need to gather snowballs yourself.  Good thing they won't melt in your pockets!",
            "Right now our ice cream maker knows how to process 11 types of toppings to make 11 different flavours.  "
            .. "You may refer to the manual on the back of the machine to see which toppings can be used.",
            "This isn't your ordinary ice cream maker either.  So much love is put into building "
            .. "each machine that sometimes they will surprise you with a secret flavour!",
            "There are 3 secret ice cream flavours that you can discover - cool, right?  "
            .. "Plus, once you discover a secret flavour, we will even start stocking the secret ingredient for it "
            .. "so that you can make it whenever you like!",
            "Now let's get to making some ice cream! :D",
            " . . . ",
            " . . . . ",
            " . . . . . ",
            "Why are you still here? Go make some ice cream! :D",
            " . . . . . ",
            " . . . . ",
            " . . . ",
            " . . ",
            " . ",
            "Okay now you are just being silly.",
            " . . . ",
            "I'm gonna go now - I hope you have a wonderful day! Happy ice cream making!"
        },
        greeting = "Beeautiful day for ice cream, isn't it?"
    }
    api_define_npc(npc_def,
    "sprites/npc/npc_standing.png",
    "sprites/npc/npc_standing_h.png",
    "sprites/npc/npc_walking.png",
    "sprites/npc/npc_walking_h.png",
    "sprites/npc/npc_head.png",
    "sprites/npc/npc_bust.png",
    "sprites/npc/npc_item.png",
    "sprites/npc/npc_dialogue_menu.png",
    "sprites/npc/npc_shop_menu.png"
    )

end

--[[
    Finds and returns the ice cream shoppe npc. If they have not been spawned already
    then create a new instance near the player.
--]]
function get_cornflower()
    -- check inventory first in case npcornflower is hiding in there
    -- and clear slot if found
    player = api_get_player_instance()
    all_slots = api_get_slots(player)
    for i=1,#all_slots do
        if all_slots[i]["item"] == "npc131" then
            api_log("get_cornflower", "looking in pockets for cornflower")
            api_slot_clear(all_slots[i]["id"])
        end
    end

    -- let there be corn(flower) if she's not been spawned already
    npcornflower = api_get_menu_objects(nil, "npc131")
    if #npcornflower == 0 then
        player_pos = api_get_player_position()
        api_create_obj("npc131", player_pos["x"] + 16, player_pos["y"] - 32)
    elseif #npcornflower > 1 then
        -- remove duplicates but get rid of the oldest instances first
        for i=1, (#npcornflower - 1) do
            api_destroy_inst(npcornflower[i]["id"])
        end
    end
    return api_get_menu_objects(nil, "npc131")
end

--[[
    Updates the items in stock at the shop with the provided topping.
--]]
function update_icecream_shoppe_stock(topping)
    table.insert(ICECREAM_SHOPPE_STOCK, topping)
    local npcornflower = get_cornflower()
    local shop_id = api_gp(npcornflower[1]["menu_id"], "shop")

    if shop_id ~= nil then
        assign_items_to_shop_slots(shop_id)
    end
end

--[[
    Called during init() to set up the npc shoppe with the known secret flavours
    on game load.
]]
function override_icecream_shoppe_stock(npcornflower, KNOWN_SECRET_FLAVOURS_TABLE)
    if npcornflower == nil then
        npcornflower = get_cornflower()
    end

    local shop_id = api_gp(npcornflower[1]["menu_id"], "shop")
    -- if we have more than 10 items to sell in the future then
    -- we'll change how the items for sale are assigned to the shop
    -- slots but we can cross that briddge if and when we get to it
    for i=1,#KNOWN_SECRET_FLAVOURS_TABLE do
        table.insert(ICECREAM_SHOPPE_STOCK, KNOWN_SECRET_FLAVOURS_TABLE[i])
    end

    if shop_id ~= nil then
        assign_items_to_shop_slots(shop_id)
    end
end

--[[
    Helper function for assigning the shop
--]]
function assign_items_to_shop_slots(shop_id)
    shop_slots = api_get_slots(shop_id)
    -- cleanup
    for i=1,#shop_slots do
        api_slot_clear(shop_slots[i]["id"])
    end
    -- set up new special item randomly from stock
    special_item = ICECREAM_SHOPPE_STOCK[math.random(1,#ICECREAM_SHOPPE_STOCK)]
    api_slot_set(shop_slots[1]["id"], special_item, 0)
    -- go ahead and add remaining shop items to the shop slots
    stock_ind = 1
    for i=2,#shop_slots do
        -- avoid out of bounds exception
        if stock_ind > #ICECREAM_SHOPPE_STOCK then
            break
        end
        -- if not special item then set to current shop slot
        -- otherwise use the next item in the ICECREAM_SHOPPE_STOCK
        -- if possible and assign to current slot id
        if ICECREAM_SHOPPE_STOCK[stock_ind] ~= special_item then
            api_slot_set(shop_slots[i]["id"], ICECREAM_SHOPPE_STOCK[stock_ind],0)
        else
            stock_ind = stock_ind + 1
            if stock_ind <= #ICECREAM_SHOPPE_STOCK then
                api_slot_set(shop_slots[i]["id"], ICECREAM_SHOPPE_STOCK[stock_ind],0)
            end
        end
        stock_ind = stock_ind + 1
    end
end
