-- This file contains turtle calls so I can run 
-- turtle programs on a linux ssystem
--  No blocks above below min/max.

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- #   #  ###  ####  #     ####  
-- #   # #   # #   # #     #   # 
-- #   # #   # ####  #     #   # 
-- # # # #   # #   # #     #   # 
--  # #   ###  #   # ##### ####  


MAX_X =  100;
MIN_X = -100;
MAX_Y =  100;
MIN_Y = -100;
MAX_Z =  100;
MIN_Z = -100;


-- Basic block ID's to use for inventory code...

NO_BLOCK          = 0;
STONE_BLOCK       = 1;
DIRT_BLOCK        = 3;
COBBLESTONE_BLOCK = 4
GRAVEL_BLOCK      = 13
LOG_BLOCK         = 17
LEAVES_BLOCK      = 18
TORCH             = 50

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


local function makeWorldKey(x, y, z)
  return string.format("%d,%d,%d", x, y, z)
end

local function setVoxel(volume, x, y, z, id)
  key = makeWorldKey(x, y, z)
  volume[key] = id
end

local function getVoxel(volume, x, y, z, default)
  key = makeWorldKey(x, y, z)
  val = volume[key]
  if val == nil then
    return default
  end
  return val
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Our local representation of the world

local FACING = { "NORTH", "EAST", "SOUTH", "WEST", NORTH = 1, EAST = 2, SOUTH = 3, WEST = 4 }


local function getBlock(world, x, y, z)
  -- < 0 is   STONE_BLOCK
  -- 1-10 is  LOG_BLOCK
  -- > 10 is  NO_BLOCK

  local default = 0
  if y < 0 then
    default = STONE_BLOCK
  elseif y < 11 then
    default = WOOD_BLOCK
  end

  return getVoxel(world, x, y, z, default)
end

local function clearCurrentBlock(world)
  local x, y, z = world.getLocation()
  setVoxel(world.vol, x, y, z, 0)
end

local function left(world)
  local facing = world.facing
  facing = facing - 1
  if facing < 1 then
    facing = 4
  end
  world.facing = facing
end


local function right(world)
  local facing = world.facing
  facing = facing + 1
  if facing > 4 then
    facing = 1
  end
  world.facing = facing
end


local function forBack(world, qty)
  local facing = world.facing
  local x = world.x
  local z = world.z
  if facing == 1 then
    z = z - qty
  elseif facing == 2 then
    x = x + qty
  elseif facing == 3 then
    z = z + qty
  else
    x = x - qty
  end

  world.x = x
  world.z = z
end

local function upDown(world, qty)
  world.y = world.y + qty
end


local function getLocationFront(world)
  local facing = world.facing
  local x, y, z = world.getLocation()
  if facing == 1 then
    z = z - qty
  elseif facing == 2 then
    x = x + qty
  elseif facing == 3 then
    z = z + qty
  else
    x = x - qty
  end
  return x, y, z
end


local function dumpWorld(world)
  for k,v in pairs(world.vol) do
    print(k.." - "..tostring(v))
  end
  print("facing: "..world.facing)
  print("x,y,z: "..world.x..","..world.y..","..world.z)
end

-- Constructs the gWorld object

-- TODO:  Add hit detection
-- TODO:  Add code for generating trees and other shapes
-- TODO:  Add code for initializing location, layers, etc.

function initWorld()
  local world      = { vol = {}, facing = 1, x = 0, y = 0, z = 0 }
  world.getBlock   = function (x,y,z) return getBlock(world.vol, x, y, z) end
  world.setBlock   = function (x,y,z, id) return setVoxel(world.vol, x, y, z, id) end
  world.dump       = function() dumpWorld(world) end
  world.getLocation = function() return world.x, world.y, world.z end
  world.setBlock(0, 0, 0, 0)

  return world
end


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- Construct TurtleSim object to pass back
local turtleSim = {
  fuel = 0;
  selectNum = 1;

  world = initWorld()
}


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- Loads the file
function tsLoadFile(path)
  local fh = io.open(path, "r")
  local content = fh:read("*all")
  fh:close()
  return content
end

-- Crush Loader
-- Simply puts all the functions INTO a thing that looks like what
-- it would look like in CC.
-- Totally a hack.
function turtleSim.loadCrush()
  package.path = package.path..";../../apis/turtle/?.lua"
  require "crush"

  -- This doesn't obfuscate/remove any
  -- Need to see if there is a better way to do this on the other side.
  crush = {}
  crush.overlayArgs = overlayArgs

  crush.checkFuel = checkFuel
  crush.digAll = digAll
  crush.digAllUp = digAllUp
  crush.digColumn = digColumn
  crush.digRow = digRow
  crush.ccts = ccts
  crush.fnOverRow = fnOverRow
  crush.turn = turn
  crush.tunnelDown = tunnelDown
  crush.gatherItems = gatherItems

  -- NOTE:  This is NOT the actual one from crush, but one for the Simulator
  crush.loadFile = tsLoadFile

  return crush
end



-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function turtleSim.forward()
  io.write("f")
  forBack(turtleSim.world, 1)
  clearCurrentBlock(turtleSim.world)
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.back()
  io.write("b")
  forBack(turtleSim.world, -1)
  clearCurrentBlock(turtleSim.world)
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.turnLeft()
  io.write("l")
  left(turtleSim.world)
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.turnRight()
  io.write("r")
  right(turtleSim.world)
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.up()
  io.write("u")
  upDown(turtleSim.world(), 1)
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.down()
  io.write("d")
  upDown(turtleSim.world(), -1)
  turtleSim.fuel = turtleSim.fuel - 1
end



function turtleSim.getFuelLevel()
  -- Do not print...
  return turtleSim.fuel
end

function turtleSim.refuel()
  print(">>> Refueling!!!!!")
  turtleSim.fuel = 80
end

function turtleSim.select(idx)
  print("\nSelecting: "..idx)
  turtleSim.selectNum = idx
end

function turtleSim.detect()
  io.write("!f")
  local x, y, z = turtleSim.world.getLocationFront(world)
  return getBlockAt(turtleSim.world, x, y, z) ~= 0
end

function turtleSim.detectDown()
  io.write("!\\")
  local x = turtleSim.world.x
  local y = turtleSim.world.y + 1
  local z = turtleSim.world.z
  return turtleSim.getBlockAt(world, x, y, z) ~= 0
end

function turtleSim.detectUp()
  io.write("!/")
  local x = turtleSim.world.x
  local y = turtleSim.world.y - 1
  local z = turtleSim.world.z
  return getBlockAt(turtleSim.world, x, y, z) ~= 0
end


function turtleSim.dig()
  io.write("x")
  local x,y,z = getLocationFront(turtleSim.world)
  turtle.world.setBlock(x,y,z,0)
end

function turtleSim.digDown()
  local x,y,z = turtleSim.world.getLocation()
  y = y - 1
  turtle.world.setBlock(x,y,z,0)
  io.write("_")
end

function turtleSim.digUp()
  local x,y,z = turtleSim.world.getLocation()
  y = y + 1
  turtle.world.setBlock(x,y,z,0)
  io.write("^")
end


function turtleSim.place()
  -- TODO: Simulate inventory
  local x,y,z = getLocationFront(turtleSim.world)
  turtle.world.setBlock(x,y,z,1)
  print("placing idx: "..turtleSim.selectNum)
end

function turtleSim.placeDown()
  -- TODO: Simulate inventory
  local x,y,z = turtleSim.world.getLocation()
  y = y - 1
  turtle.world.setBlock(x,y,z,1)
  print("placeDown idx: "..turtleSim.selectNum)
end

function turtleSim.placeUp()
  -- TODO: Simulate inventory
  local x,y,z = turtleSim.world.getLocation()
  y = y + 1
  turtle.world.setBlock(x,y,z,1)
  print("placeUp idx: "..turtleSim.selectNum)
end



function turtleSim.compare()
  -- TODO
  return false;
end

function turtleSim.compareDown()
  -- TODO
  return false;
end

function turtleSim.compareUp()
  -- TODO
  return false;
end


-- Utilities

function turtleSim.getItemCount(slot)
  -- TODO: Simulate inventory
  return 2
end


-- Utilities

function inRange(val, min, max)
  return val >= min and val <= max
end


-- Return the Object so they can access it.




return turtleSim
