--[[
    Defines a new flower for us ;)
--]]
function define_cornflower_flower()
    -- create flower_definition table
    cornflower_def = {
      id = "131",
      species = "Cornflower",
      title = "Cornflower",
      latin = "Centaurea Cyanus",
      hint = "An intensely blue flower that grows in temperate areas.",
      desc = "In the past, Cornflowers grew as a weed in cornfields, hence its name. "
          .. "Its robustness and ability to survive drought has established the Cornflower "
          .. "as a symbol of hope and optimism for the future in many cultures.",
      aquatic = false,
      variants = 2,
      deep = false,
      smoker = {},
      recipes = {}
    }

    -- define flower
    api_define_flower(cornflower_def,
      "sprites/cornflower/cornflower_item.png", "sprites/cornflower/cornflower_variants.png",
      "sprites/cornflower/cornflower_seed_item.png", "sprites/cornflower/cornflower_hd.png",
      {r=100, g=149, b=237}
    )
end
