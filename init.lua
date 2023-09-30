----------------------
-- HELPING FUNCTIONS 
---------------------

function Print(message)
  minetest.chat_send_player("singleplayer", message)
end

function Log(message)
  minetest.log("warning",tostring(message))
end

function add(a,b)
  local vector = {x=0,y=0,z=0}
  vector.x = a.x + b.x
  vector.y = a.y + b.y
  vector.z = a.z + b.z
  return vector
end

function mal(a,b) -- b ist Skalar!
  local vector = {x=0,y=0,z=0}
  vector.x = a.x *b
  vector.y = a.y *b
  vector.z = a.z *b
  return vector
end

function isInTable(tbl, item)
  for key, value in pairs(tbl) do
      if value == item then
          return true
      end
  end
  return false
end

----------------------
-- Variables
----------------------

local GAME = "none"

if minetest.get_modpath("default") then
  GAME = "default"
elseif minetest.get_modpath("mcl_core") then
  GAME = "mineclone"
end

----------------------
-- Blocks
----------------------

local BLOCK_DIRT = ""
local BLOCK_STICK = ""
local ITEM_CHRYSTAL = ""
local ITEM_STICK = ""
local ITEM_LAPIZ = ""
local ITEM_GOLD_INGOT = ""
local ITEM_COAL = ""
local ITEM_BONEBLOCK = ""
local ITEM_BONEMEAL = ""
local FIRES = {}

-- Default Game loaded
if GAME == "default" then
  BLOCK_DIRT = "default:dirt"
  BLOCK_STICK = "default:stick"
  ITEM_CHRYSTAL = "default:mese_crystal"
  ITEM_LAPIZ = "default:mese_crystal_fragment"
  ITEM_STICK = "default:stick"
  ITEM_GOLD_INGOT = "default:gold_ingot"
  ITEM_COAL = "default:coal_lump"
  ITEM_BONEBLOCK = "bones:bones"
  ITEM_BONEMEAL = "bones:bones"
  FIRES = {"fire:basic_flame","fire:permanent_flame"}
  

  
-- Mineclone Mod loaded
elseif GAME == "mineclone" then
  BLOCK_DIRT = "mcl_core:dirt"
  BLOCK_STICK = "mcl_core:stick"
  ITEM_CHRYSTAL = "mcl_core:emerald"
  ITEM_LAPIZ = "mcl_core:lapis"
  ITEM_STICK = "mcl_core:stick"
  ITEM_GOLD_INGOT = "mcl_core:gold_ingot"
  ITEM_COAL = "mcl_core:coal_lump"
  ITEM_BONEBLOCK = "mcl_core:bone_block"
  ITEM_BONEMEAL = "mcl_bone_meal:bone_meal"
  FIRES = {"mcl_fire:fire","mcl_fire:eternal_fire"}

end


----------------------
-- Start Code
----------------------

----------------------
-- Nodes
----------------------

-- Register the "lightair" node

minetest.register_node("forfun:lightair", {
  description = "Illuminated Air",
  drawtype = "airlike",  -- This makes the node invisible like air
  walkable = false,  -- Players and entities can walk through it like air
  pointable = false,  -- Players can't point to it (i.e., can't select it with the mouse)
  diggable = false,  -- Players can't dig it
  buildable_to = true,  -- Other nodes can replace it when built upon
  drop = "",  -- Nothing drops when dug
  sunlight_propagates = true,  -- Sunlight goes through it
  paramtype = "light",  -- This allows the node to be lit
  light_source = 14,  -- How bright the node is; this makes it emit light. Value can be from 0 (dark) to 15 (very bright)
  groups = {not_in_creative_inventory=1},  -- This hides it from the creative inventory
  
  on_timer = function(pos, elapsed)
    minetest.set_node(pos, {name = "air"})
  end,
  on_construct = function(pos)
      local timer = minetest.get_node_timer(pos)
      timer:start(0.1)  -- Replace YOUR_PARTICLE_LIFESPAN with the lifespan of the particle in seconds
  end,
})

local light_levels = 14  -- Starting from 14, which is very bright

for i=1, light_levels do
    minetest.register_node("forfun:lightair_" .. i, {
        description = "Illuminated Air Level " .. i,
        drawtype = "airlike",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
        drop = "",
        sunlight_propagates = true,
        paramtype = "light",
        light_source = i,
        groups = {not_in_creative_inventory=1, lightair=1},
    })
end

----------------------
-- Global Step
----------------------

-- Register global table to hold casting data
local active_casts = {}

minetest.register_globalstep(function(dtime)
  for _, cast in ipairs(active_casts) do
      local particle_pos = {
          x = cast.start.x + cast.direction.x * cast.time_elapsed,
          y = cast.start.y + cast.direction.y * cast.time_elapsed,
          z = cast.start.z + cast.direction.z * cast.time_elapsed
      }
      
      -- Get the node at the particle's position
      local node = minetest.get_node(particle_pos)
      
    
      -- Check if the node is not air (or another condition, as needed)
      if node.name ~= "air" and
        node.name ~= "forfun:lightair_14" and 
        node.name ~= "forfun:lightair_13" and 
        node.name ~= "forfun:lightair_12" and 
        node.name ~= "forfun:lightair_11" and 
        node.name ~= "forfun:lightair_10" and 
        node.name ~= "forfun:lightair_9" and 
        node.name ~= "forfun:lightair_8" and 
        node.name ~= "forfun:lightair_7" and 
        node.name ~= "forfun:lightair_6" and 
        node.name ~= "forfun:lightair_5" and 
        node.name ~= "forfun:lightair_4" and 
        node.name ~= "forfun:lightair_3" and 
        node.name ~= "forfun:lightair_2" and 
        node.name ~= "forfun:lightair_1" and 
        node.name ~= "forfun:lightair" then
        
        local directions = {
          vector.new(0,1,0),
          vector.new(0,-1,0),
          vector.new(1,0,0),
          vector.new(-1,0,0),
          vector.new(0,0,1),
          vector.new(0,0,-1),
        }
          
          
        -- Platziere letztes Licht
        if cast.type == "light" then
          -- Überprüfe alle anliegenden Richtungen
          for _, vec in ipairs(directions) do
            -- Place a lightnode at the end
            if minetest.get_node(add(particle_pos,vec)).name == "air" then
              minetest.set_node(add(particle_pos,vec), {name = "forfun:lightair_14"})
            end
          end
          
        
          -- Entferne sämtliches Feuer
        elseif cast.type == "grow" then
          local all_directions = {}
          local remove_radius = 8
          
          for xc = 0, remove_radius-1, 1 do
            for yc = 0, remove_radius-1, 1 do
              for zc = 0, remove_radius-1, 1 do
                table.insert(all_directions,
                  add(
                    add(particle_pos,vector.new(-math.floor(remove_radius/2),
                                                -math.floor(remove_radius/2),
                                                -math.floor(remove_radius/2))),
                    add(
                      mal(vector.new(1,0,0),xc),
                      add(
                        mal(vector.new(0,1,0),yc),
                        mal(vector.new(0,0,1),zc)
                      )
                    )
                  )
                )
              end
            end
          end
              
          
          local at_least_one_removed = false
          
          for _, vec in ipairs(all_directions) do               
            
            if isInTable(FIRES,minetest.get_node(vec).name) then
              minetest.set_node(vec,{name = "air"})
              at_least_one_removed = true
            end
                
            
          end
          
          if at_least_one_removed then
            minetest.sound_play("fire_extinguish", {
              pos = particle_pos, -- Sound will play at the user's position
              gain = 1.0, -- Volume
              max_hear_distance = 10, -- Maximum distance where the sound can be heard
            })
          end
          
        end
          
            
        table.remove(active_casts, _) -- Remove this cast from active casts
      elseif cast.time_elapsed >= cast.max_distance then
          -- If the maximum distance is reached without a collision
          table.remove(active_casts, _) -- Remove this cast from active casts
      else
        
        -- Cast light
          if cast.type == "light" then
            minetest.set_node(particle_pos, {name = "forfun:lightair"})
            
            -- If there's no collision, and we haven't reached max distance yet
            minetest.add_particle({
              pos = particle_pos,
              expirationtime = 0.1,
              size = 2,
              texture = "forfun_particle.png",
              glow = 14,
            })
            
          elseif cast.type == "grow" then
                      
            -- If there's no collision, and we haven't reached max distance yet
            minetest.add_particle({
              pos = particle_pos,
              expirationtime = 0.2,
              size = 2,
              texture = "forfun_particle_grow.png",
              glow = 8,
            })
          end
            
            
          cast.time_elapsed = cast.time_elapsed + cast.step_distance
      end
  end
end)


----------------------------------------------
----------------------------------------------


----------------------
-- Effects
----------------------

minetest.register_abm({
  nodenames = {"group:lightair"},  -- Targeting all nodes in the 'lightair' group
  interval = 1,  -- Run every 5 seconds
  chance = 1,  -- Always act upon the node if conditions are met

  action = function(pos, node)
    --minetest.set_node(pos, {name = "air"})
      local level = tonumber(string.match(node.name, "forfun:lightair_(%d+)"))

      if level and level > 3 then
          -- Decrease the light level by 1
          minetest.set_node(pos, {name = "forfun:lightair_" .. (level - 4)})
      else
          -- If the light level is 1 or for some reason not recognized, replace with default air
          minetest.set_node(pos, {name = "air"})
      end
      --]]
  end,
})

-- Register forfun:wand
minetest.register_tool("forfun:wand", {
  description = "Wand \n(Spark light)",
  inventory_image = "forfun_wand_turned.png", -- Regular texture
  wield_image = "forfun_wand2.png", -- Custom wield image
  stack_max = 1,
  light_source = 5,
  
  on_use = function(itemstack, user, pointed_thing)
    
    local player_inventory = user:get_inventory()

  -- Check if the player has the specific item in their inventory
  if player_inventory:contains_item("main", "forfun:coaldust") then
    
    player_inventory:remove_item("main", "forfun:coaldust") -- Remove one of the specific item from the player's inventory
    
    -- Play Sound
    -- Emit a sound when the wand is used
    minetest.sound_play("forfun_magic_spell", {
      pos = user:get_pos(), -- Sound will play at the user's position
      gain = 1.0, -- Volume
      max_hear_distance = 10, -- Maximum distance where the sound can be heard
    })
      
    
    if itemstack:get_wear() < 65536 then      -- 65536 for some reason being the maximum amount of usages... 
      -- Add wear to the item
      itemstack:add_wear(656) -- ca. 100 usages
      
    -- Remove Item when used
    else
      itemstack:take_item(1)  -- Removes the wand from the inventory
    end
    
    ------- Magic Spell Start
      
    local player_pos = user:get_pos()
    local player_dir = user:get_look_dir()

    -- Store the casting data for the globalstep callback
    table.insert(active_casts, {
        start = {
            x = player_pos.x,
            y = player_pos.y + 1.4, -- roughly eye level
            z = player_pos.z
        },
        direction = player_dir,
        type = "light",
        step_distance = 0.5,
        time_elapsed = 0,
        max_distance = 30
    })
  else
    Print("You need a coal dust to use this wand")
  
  end
    
    ------- Magic Spell End

    -- Return the modified itemstack
    return itemstack
  end,

  tool_capabilities = {
    max_drop_level = 0,
    groupcaps = {
      hand = {times = {[1] = 0.0}, uses = 0, maxlevel = 1},
    }, 
  },
})


-- Register forfun:bonewand
minetest.register_tool("forfun:bonewand", {
  description = "Bone Wand \n(extinguish fires)",
  inventory_image = "forfun_bonewand_turned.png", -- Regular texture
  wield_image = "forfun_bonewand.png", -- Custom wield image
  stack_max = 1,
  light_source = 5,
  
  on_use = function(itemstack, user, pointed_thing)
    
    local player_inventory = user:get_inventory()

  -- Check if the player has the specific item in their inventory
  if player_inventory:contains_item("main", ITEM_BONEMEAL) then
    
    player_inventory:remove_item("main", ITEM_BONEMEAL) -- Remove one of the specific item from the player's inventory
      
    
    minetest.sound_play("forfun_magic_spell2", {
      pos = user:get_pos(), -- Sound will play at the user's position
      gain = 1.0, -- Volume
      max_hear_distance = 10, -- Maximum distance where the sound can be heard
    })
    
    
    if itemstack:get_wear() < 65536 then      -- 65536 for some reason being the maximum amount of usages... 
      -- Add wear to the item
      itemstack:add_wear(1820) -- ca. 36 usages
      
    -- Remove Item when used
    else
      itemstack:take_item(1)  -- Removes the wand from the inventory
    end
    
    ------- Magic Spell Start
      
    local player_pos = user:get_pos()
    local player_dir = user:get_look_dir()

    -- Store the casting data for the globalstep callback
    table.insert(active_casts, {
        start = {
            x = player_pos.x,
            y = player_pos.y + 1.4, -- roughly eye level
            z = player_pos.z
        },
        direction = player_dir,
        type = "grow",
        step_distance = 0.5,
        time_elapsed = 0,
        max_distance = 30
    })
  else
    Print("You need bone meal to use this wand.")
  
  end
    
    ------- Magic Spell End

    -- Return the modified itemstack
    return itemstack
  end,

  tool_capabilities = {
    max_drop_level = 0,
    groupcaps = {
      hand = {times = {[1] = 0.0}, uses = 0, maxlevel = 1},
    }, 
  },
})

local i_count = 0
local function OnFrame()
  Print("Every frame:"..i_count)
end






-- Register the Magic Stick
minetest.register_craftitem("forfun:magicstick", {
  description = "Magic Stick",
  inventory_image = "forfun_magicstick.png",
  groups = {stick = 1, flammable = 2},
})


-- Register Coaldust
minetest.register_craftitem("forfun:coaldust", {
  description = "Coal Dust",
  inventory_image = "forfun_coaldust.png",
  groups = {flammable = 1},
})




---------------------
-- Register only on compatibility
---------------------


if GAME ~= "none" then
--------------------- RegisterStart


  if true then -- Crafting Recipes: forfun:magicstick

    -- Left
    minetest.register_craft({
      output = "forfun:magicstick",
      recipe = {
        {"", "", ITEM_LAPIZ},
        {"", ITEM_STICK, ""},
        {ITEM_LAPIZ, "", ""},
      }
    })

    -- Right
    minetest.register_craft({
      output = "forfun:magicstick",
      recipe = {
        {ITEM_LAPIZ, "", ""},
          {"",ITEM_STICK, ""},
          {"", "", ITEM_LAPIZ},
      }
    })

  end

  if true then -- Crafting Recipes: forfun:wand

    -- Right
    minetest.register_craft({
      output = "forfun:wand", -- Assuming you have a magic wand defined
      recipe = {
          {"forfun:magicstick", "", ""},
          {"", "forfun:magicstick", ""},
          {"", "", ITEM_GOLD_INGOT},
      }
    })

    -- Left
    minetest.register_craft({
      output = "forfun:wand",
      recipe = {
        {"", "", "forfun:magicstick"},
        {"", "forfun:magicstick", ""},
        {ITEM_GOLD_INGOT, "", ""},
      }
    })

  end
  
  if true then -- Crafting Recipes: forfun:coaldust
    if GAME == "default" then
      minetest.register_craft({
        type = "shapeless",
        output = "forfun:coaldust 12",
        recipe = { ITEM_COAL, ITEM_COAL }
      })

      -- Coaldust ONE (for Mineclone)
    else
      minetest.register_craft({
        type = "shapeless",
        output = "forfun:coaldust 6",
        recipe = { ITEM_COAL }
      })
    end
  end
    
  if true then -- Crafting Recipes: forfun:bonewand 
    -- Right
    minetest.register_craft({
      output = "forfun:bonewand", -- Assuming you have a magic wand defined
      recipe = {
          {"forfun:magicstick", "", ""},
          {"", "forfun:magicstick", ""},
          {"", "", ITEM_BONEBLOCK},
      }
    })

    -- Left
    minetest.register_craft({
      output = "forfun:bonewand",
      recipe = {
        {"", "", "forfun:magicstick"},
        {"", "forfun:magicstick", ""},
        {ITEM_BONEBLOCK, "", ""},
      }
    })
  end
    
  
--------------------- RegisterEnd
end







