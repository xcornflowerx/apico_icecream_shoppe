--[[
    Defines the icecream maker menu object.
--]]
function define_icecream_maker()
    api_define_menu_object({
        id = "icecream_maker",
        name = "Ice Cream Maker",
        category = "Crafting",
        tooltip = "Lets you make ice cream",
        shop_buy = 100,
        shop_sell = 100,
        layout = {
            {8, 17, "Input", icecream_toppings},
            {8, 40, "Input", {"snowball"}},
            {71, 35, "Input", {"icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"}},
            {99, 17, "Output"},
            {99, 40, "Output"},
            {99, 63, "Output"},
            {7, 89}, {30, 89}, {53, 89}, {76, 89}, {99, 89},
        },
        buttons = {"Help", "Target", "Close"},
        info = {
            {"1. Toppings Input", "GREEN"},
            {"2. Dish Input", "GREEN"},
            {"3. Ice Cream Output", "RED"},
            {"4. Extra Storage", "WHITE"},
        },
        tools = {"mouse1", "hammer1"},
        placeable = true
    }, "sprites/icecream/machine_item.png", "sprites/icecream/machine_menu.png", {
        define = "icecream_maker_define_callback",
        draw = "icecream_maker_draw_callback",
        tick = "icecream_maker_tick_callback",
        change = "has_valid_inputs"
    })
end

--[[
    Callback function for defining the icecream maker menu object.
--]]
function icecream_maker_define_callback(menu_id)
    -- define properties
    api_dp(menu_id, "loaded", false)
    api_dp(menu_id, "working", false)
    api_dp(menu_id, "p_start_mixer", 0)
    api_dp(menu_id, "p_end_mixer", 35)
    api_dp(menu_id, "p_start_arrow", 0)
    api_dp(menu_id, "p_end_arrow", 29)

    -- mixer progress bar
    api_define_gui(menu_id, "mixer_progress_bar", 29, 21, "icecream_maker_mixer_gui_tooltip",
        "sprites/icecream/machine_gui_mixer.png")
    api_dp(menu_id, "mixer_progress_bar_sprite", api_get_sprite("icecream_shoppe_mixer_progress_bar"))

    -- arrow progress bar
    api_define_gui(menu_id, "arrow_progress_bar", 65, 19, "icecream_maker_arrow_gui_tooltip",
        "sprites/icecream/machine_gui_arrow.png")
    api_dp(menu_id, "arrow_progress_bar_sprite", api_get_sprite("icecream_shoppe_arrow_progress_bar"))

    -- save progress
    fields = {"p_start_mixer", "p_end_mixer", "p_start_arrow", "p_end_arrow"}
    fields = api_sp(menu_id, "_fields", fields)
end

--[[
    Callback function for drawing the icecream maker menu object gui progress bars.
--]]
function icecream_maker_draw_callback(menu_id)
    cam = api_get_cam()
    -- mixer progress bar callback operations
    mixer_gui = api_get_inst(api_gp(menu_id, "mixer_progress_bar"))
    mixer_spr = api_gp(menu_id, "mixer_progress_bar_sprite")

    mixer_gx = mixer_gui["x"] - cam["x"]
    mixer_gy = mixer_gui["y"] - cam["y"]

    -- mixer width = 35
    mixer_progress = (api_gp(menu_id, "p_start_mixer") / api_gp(menu_id, "p_end_mixer") * 35)
    api_draw_sprite_part(mixer_spr, 2, 0, 0, mixer_progress, 41 , mixer_gx, mixer_gy)
    api_draw_sprite(mixer_spr, 1, mixer_gx, mixer_gy)

    if api_get_highlighted("ui") == mixer_gui["id"] then
        api_draw_sprite(mixer_spr, 0, mixer_gx, mixer_gy)
    end

    -- arrow progress bar callback operations
    arrow_gui = api_get_inst(api_gp(menu_id, "arrow_progress_bar"))
    arrow_spr = api_gp(menu_id, "arrow_progress_bar_sprite")

    arrow_gx = arrow_gui["x"] - cam["x"]
    arrow_gy = arrow_gui["y"] - cam["y"]

    -- arrow width = 29
    arrow_progress = (api_gp(menu_id, "p_start_arrow") / api_gp(menu_id, "p_end_arrow") * 29)
    api_draw_sprite_part(arrow_spr, 2, 0, 0, arrow_progress, 41 , arrow_gx, arrow_gy)
    api_draw_sprite(arrow_spr, 1, arrow_gx, arrow_gy)

    if api_get_highlighted("ui") == arrow_gui["id"] then
        api_draw_sprite(arrow_spr, 0, arrow_gx, arrow_gy)
    end
end

--[[
    Callback function for the icecream maker menu object tick hook.
--]]
function icecream_maker_tick_callback(menu_id)
    -- nothing to do if there aren't valid inputs
    if has_valid_inputs(menu_id) ~= true then
        return
    end

    -- update mixer progress
    api_sp(menu_id, "p_start_mixer", api_gp(menu_id, "p_start_mixer") + 0.1)

    -- if mixer progress is complete then update arrow progress
    -- mixer progress is kept until arrow progress is complete then we
    -- reset the progress for both
    if api_gp(menu_id, "p_start_mixer") >= api_gp(menu_id, "p_end_mixer") then
        api_sp(menu_id, "p_start_arrow", api_gp(menu_id, "p_start_arrow") + 0.1)
    end

    -- reset progress for mixer and arrow if arrow progress is complete
    -- proceed with updating input and output slots, etc.
    if api_gp(menu_id, "p_start_arrow") >= api_gp(menu_id, "p_end_arrow") then
        api_sp(menu_id, "p_start_arrow", 0)
        api_sp(menu_id, "p_start_mixer", 0)

        -- get stuff from input slots
        local input_toppings = api_slot_match_range(menu_id, icecream_toppings, {1}, true)
        local input_snowballs = api_slot_match_range(menu_id, {"snowball"}, {2}, true)
        local input_icecream_dishes = api_slot_match_range(menu_id,
            {"icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"}, {3}, true)

        -- check that there is space in the output slots
        -- note that output slots indexes for the ice cream maker menu are 4,5,6
        local current_flavour = get_icecream_flavour_by_topping(input_toppings["item"], input_icecream_dishes["item"])
        local output_slots = api_get_slots(menu_id)
        local target_slot = nil
        for i=4,6 do
            if output_slots[i]["item"] == ""
                or (output_slots[i]["item"] == current_flavour and output_slots[i]["count"] < 99) then
                    target_slot = output_slots[i]
                    break
            end
        end

        -- if we found a target slot to output to then set item to the target slot and/or increment target slot
        -- and decr counts for input slots
        if target_slot ~= nil then
            if target_slot["item"] == "" then
                api_slot_set(target_slot["id"], current_flavour, 1)
            else
                api_slot_incr(target_slot["id"], 1)
            end
               api_slot_decr(input_toppings["id"], 1)
            api_slot_decr(
                api_slot_match_range(menu_id, {"snowball"}, {2}, true)["id"],
                    3)
            api_slot_decr(
                api_slot_match_range(menu_id, {"icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"}, {3}, true)["id"],
                    1)
        else
            -- no target slot identified so set working to false
            api_sp(menu_id, "working", false)
        end
    end
end

--[[
    Returns a boolean based on the validity of the menu object input slots.
    Note: `has_valid_inputs` also serves as the change callback for the icecream maker menu object
--]]
function has_valid_inputs(menu_id)
    -- validate inputs for toppings, snowballs, and ice cream dishes
    local input_toppings = api_slot_match_range(menu_id, icecream_toppings, {1}, true)
    local input_snowballs = api_slot_match_range(menu_id, {"snowball"}, {2}, true)
    local input_icecream_dishes = api_slot_match_range(menu_id,
        {"icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"}, {3}, true)

    -- case where all three inputs are valid
    if (input_snowballs ~= nil and input_snowballs["count"] >= 3)
        and input_toppings ~= nil
        and input_icecream_dishes ~= nil then

            api_sp(menu_id, "loaded", true)
            api_sp(menu_id, "working", true)
            api_sp(menu_id, "error", "")
            return true
    -- case where all three inputs are loaded but not enough snowballs
    elseif (input_snowballs ~= nil and input_snowballs["count"] < 3)
        and input_toppings ~= nil
        and input_icecream_dishes ~= nil then
            -- not enough snowballs but there are at least some in the input slot
            -- and there exists items in the other input slots
            api_sp(menu_id, "loaded", true)
            api_sp(menu_id, "working", false)
            return false
    -- at least one of our input checks failed so format error message and return false
    else
        local error_msg = format_missing_input_error_message(menu_id)
        api_sp(menu_id, "error", error_msg)
        api_sp(menu_id, "loaded", false)
        api_sp(menu_id, "working", false)
        api_sp(menu_id, "p_start_mixer", 0)
        api_sp(menu_id, "p_start_arrow", 0)
        return false
    end
end

--[[
    Identifies the invalid inputs for the given menu and returns a formatted error message.
--]]
function format_missing_input_error_message(menu_id)
    local input_toppings = api_slot_match_range(menu_id, icecream_toppings, {1}, true)
    local input_snowballs = api_slot_match_range(menu_id, {"snowball"}, {2}, true)
    local input_icecream_dishes = api_slot_match_range(menu_id,
        {"icecream_shoppe_icecream_dish01", "icecream_shoppe_icecream_dish01b"}, {3}, true)

    -- identify missing inputs and format error message for menu accordingly
    missing_inputs = {}
    if input_toppings == nil then
        table.insert(missing_inputs, "ice cream toppings")
    end
    if input_snowballs == nil then
        table.insert(missing_inputs, "snowballs")
    elseif input_snowballs["count"] < 3 then
        api_sp(menu_id, "loaded", false)
        table.insert(missing_inputs, "snowballs (need at least 3 to process)")
    end
    if input_icecream_dishes == nil then
        table.insert(missing_inputs, "ice cream dishes")
    end
    missing_inputs_str = table.concat( missing_inputs, ", ")
    return "Missing input item(s): " .. missing_inputs_str
end

function icecream_maker_mixer_gui_tooltip(menu_id)
    progress = math.floor((api_gp(menu_id, "p_start_mixer") / api_gp(menu_id, "p_end_mixer")) * 100)
    if progress <= 100 then
        percent = tostring(progress) .. "%"
        message = "Mixing..."
    else
        message = "Mixing complete!"
        percent = "100%"
    end
    return {
      {message, "FONT_WHITE"},
      {percent, "FONT_BGREY"}
    }
end

function icecream_maker_arrow_gui_tooltip(menu_id)
    progress = math.floor((api_gp(menu_id, "p_start_arrow") / api_gp(menu_id, "p_end_arrow")) * 100)
    if progress == 0 then
        message = "Waiting for mixing to complete..."
        percent = tostring(progress) .. "%"
    elseif progress < 100 then
        message = "Transferring to dish..."
        percent = tostring(progress) .. "%"
    else
        -- will probably not see this message ever display but adding just in case
        -- someone manages to catch the message at the exact frame it's displayed
        message = "Enjoy!"
        percent = "100%"
    end
    return {
      {message, "FONT_WHITE"},
      {percent, "FONT_BGREY"}
    }
end
