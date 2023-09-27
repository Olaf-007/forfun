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

----------------------
-- Variables
----------------------


local compatibility = true


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


-- Default Game loaded
if minetest.get_modpath("default") then
  BLOCK_DIRT = "default:dirt"
  BLOCK_STICK = "default:stick"
  ITEM_CHRYSTAL = "default:mese_crystal"
  ITEM_LAPIZ = "default:mese_crystal_fragment"
  ITEM_STICK = "default:stick"
  ITEM_GOLD_INGOT = "default:gold_ingot"
  ITEM_COAL = "default:coal_lump"

  
-- Mineclone Mod loaded
elseif minetest.get_modpath("mcl_core") then
  BLOCK_DIRT = "mcl_core:dirt"
  BLOCK_STICK = "mcl_core:stick"
  ITEM_CHRYSTAL = "mcl_core:emerald"
  ITEM_LAPIZ = "mcl_core:lapis"
  ITEM_STICK = "mcl_core:stick"
  ITEM_GOLD_INGOT = "mcl_core:gold_ingot"
  ITEM_COAL = "mcl_core:coal_lump"

else 
  compatibility = false
  
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
        
        -- Überprüfe alle anliegenden Richtungen
        for _, dic in ipairs({
          {vector.new({x=0,y=1,z=0})},
          {vector.new({x=0,y=-1,z=0})},
          {vector.new(1,0,0)},
          {vector.new(-1,0,0)},
          {vector.new(0,0,1)},
          {vector.new(0,0,-1)},
        }) do
          if minetest.get_node(add(particle_pos,dic[1])).name == "air" then
            minetest.set_node(add(particle_pos,dic[1]), {name = "forfun:lightair_14"})
          end
        end
          
        --[[
          -- If there's a collision
          -- Do where the collision end
          for _, dic in ipairs({
            --{vector.new({x=0,y=1,z=0}),"default:dirt_with_snow"},
            --{vector.new({x=0,y=-1,z=0}),"default:cactus"},
            --{vector.new(1,0,0),"default:brick"},
            --{vector.new(-1,0,0),"default:aspen_wood"},
            --{vector.new(0,0,1),"default:desert_sandstone_brick"},
            --{vector.new(0,0,-1),"default:ice"},
          }) do
            minetest.remove_node(add(particle_pos,dic[1]))
            minetest.set_node(add(particle_pos,dic[1]), {name = dic[2]})
          end
          minetest.remove_node(particle_pos)
          minetest.set_node(particle_pos, {name = "default:diamondblock"})
          
          
          -- If free below, fall
          if minetest.get_node(add(particle_pos,vector.new(0,-1,0))).name == "air" then
            minetest.spawn_falling_node(particle_pos)
          end
          -- Add light
          if minetest.get_node(add(particle_pos,vector.new(0,1,0))).name == "air" then
            minetest.add_entity(add(particle_pos,vector.new(0,1,0)), "forfun:flowlight")
            --minetest.set_node(add(particle_pos,vector.new(0,1,0)), {name = "forfun:lightair_14"})
          end 
          --]]
            
        table.remove(active_casts, _) -- Remove this cast from active casts
      elseif cast.time_elapsed >= cast.max_distance then
          -- If the maximum distance is reached without a collision
          table.remove(active_casts, _) -- Remove this cast from active casts
      else
          -- If there's no collision, and we haven't reached max distance yet
          minetest.add_particle({
              pos = particle_pos,
              expirationtime = 0.1,
              size = 2,
              texture = "forfun_particle.png",
              glow = 14,
          })
          minetest.set_node(particle_pos, {name = "forfun:lightair"})
          
          cast.time_elapsed = cast.time_elapsed + cast.step_distance
      end
  end
end)


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


-- Define the custom tool item
minetest.register_tool("forfun:wand", {
  description = "Wand \n(Spark light)",
  inventory_image = "forfun_wand2.png", -- Regular texture
  wield_image = "forfun_wand2.png", -- Custom wield image
  stack_max = 1,
  light_source = 5,
  
  on_use = function(itemstack, user, pointed_thing)
    
    local player_inventory = user:get_inventory()

  -- Check if the player has the specific item in their inventory
  if player_inventory:contains_item("main", "forfun:coaldust") then
    -- Remove one of the specific item from the player's inventory
    player_inventory:remove_item("main", "forfun:coaldust")
    
    
    -- Play Sound
    -- Emit a sound when the wand is used
    minetest.sound_play("forfun_magic_spell", {
      pos = user:get_pos(), -- Sound will play at the user's position
      gain = 1.0, -- Volume
      max_hear_distance = 10, -- Maximum distance where the sound can be heard
    })
      
    
    
    -- Retrieve the current usage count from the item's metadata
    local meta = itemstack:get_meta()
    local usage_count = meta:get_string("usage_count")

    -- If usage_count is nil or empty, initialize it to 0
    if not usage_count or usage_count == "" then
        usage_count = 0
    else
        usage_count = tonumber(usage_count)
    end
        
    -- Check if the item has been used less than 20 times
    if usage_count < 200 then
      -- Increment the usage count
      usage_count = usage_count + 1
      itemstack:get_meta():set_string("usage_count", tostring(usage_count))
      
      -- Add wear to the item
      itemstack:add_wear(327)
      

    -- If the usage count has reached 5, print a message to the user and remove the wand
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


-- Register Wand depending on the dependencies






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


if compatibility then
--------------------- RegisterStart



-- Register Magic Stick recipe

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



-- Register Wand recipe

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
  
  

-- Coaldust TWO
minetest.register_craft({
  type = "shapeless",
  output = "forfun:coaldust 9",
  recipe = { ITEM_COAL, ITEM_COAL }
})
-- Coaldust ONE (for Mineclone)
minetest.register_craft({
  type = "shapeless",
  output = "forfun:coaldust 16",
  recipe = { ITEM_COAL, ITEM_COAL }
})
  
  
  
  
--------------------- RegisterEnd
end






