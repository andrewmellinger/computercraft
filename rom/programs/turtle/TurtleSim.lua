-- This file contains turtle calls so I can run 
-- turtle programs on a linux ssystem
--  No blocks above below min/max.

local turtleSim = {
  fuel = 0;
  block = true;
  blockDown = true;
  blockUp = true;
  selectNum = 1;
  x = 0;
  y = 0;
  z = 0;
}

-- TODO:  Look at setfenv
--[[

http://www.lua.org/pil/15.4.html

local P = {}
complex = P
setfenv(1, P)

function add(c1, c2)
  -- foo.
end

This supposedly creates it in complex



]]

-- Crush Loader
-- Simply puts all the functions INTO a thing that looks like what
-- it would look like in CC.
function turtleSim.loadCrush()
  package.path = package.path..";../../apis/turtle/?.lua"
  require "crush"

  crush = {}
  crush.checkFuel = checkFuel
  crush.digAll = digAll
  crush.digAllUp = digAllUp
  crush.digColumn = digColumn
  crush.digRow = digRow
  crush.ccts = ccts
  crush.fnOverRow = fnOverRow
  crush.turn = turn

  return crush
end


MAX_X =  100;
MIN_X = -100;
MAX_Y =  10;
MIN_Y = -100;
MAX_Z =  100;
MIN_Z = -100;

-- Generate a "random world."

-- UGH!  We need to keep track of facing...
function turtleSim.makeWorld()
  local arr = {}
  for x = MIN_X, MAX_X do
    local xArr = {}
    arr[x] = xArr
    for y = MIN_Y, MAX_Y do
      local yArr = {}
      xArr[y] = yArr
      for z = MIN_Z, MAX_Z do
        -- Here is where we put in the actual value

        if y < 0 then
          --yArr[z] = 1 -- 1 is a block ID 1
          yArr[z] = "dirt" -- 1 is a block ID 1
        else
          yArr[z] = "air" -- 0 is air
        end
        
      end
    end
  end
  return arr
end

turtleSim.world = turtleSim.makeWorld()

--


function turtleSim.forward()
  io.write("f")
  turtleSim.block = true
  turtleSim.blockDown = true
  turtleSim.blockUp = true
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.back()
  io.write("b")
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.turnLeft()
  io.write("l")
  turtleSim.block = true
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.turnRight()
  io.write("r")
  turtleSim.block = true
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.up()
  io.write("u")
  turtleSim.y = turtleSim.y + 1
  turtleSim.block = inRange(turtleSim.y, MIN_Y, MAX_Y)
  turtleSim.blockUp = inRange(turtleSim.y + 1, MIN_Y, MAX_Y)
  turtleSim.blockDown = inRange(turtleSim.y - 1, MIN_Y, MAX_Y)
  turtleSim.fuel = turtleSim.fuel - 1
end

function turtleSim.down()
  io.write("d")
  turtleSim.y = turtleSim.y - 1
  turtleSim.block = inRange(turtleSim.y, MIN_Y, MAX_Y)
  turtleSim.blockUp = inRange(turtleSim.y + 1, MIN_Y, MAX_Y)
  turtleSim.blockDown = inRange(turtleSim.y - 1, MIN_Y, MAX_Y)
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
  return turtleSim.block
end

function turtleSim.detectDown()
  io.write("!\\")
  return turtleSim.blockDown
end

function turtleSim.detectUp()
  io.write("!/")
  return turtleSim.blockUp
end


function turtleSim.dig()
  io.write("x")
  turtleSim.block = false
end

function turtleSim.digDown()
  turtleSim.blockDown = false
  io.write("_")
end

function turtleSim.digUp()
  turtleSim.blockUp = false
  io.write("^")
end


function turtleSim.place()
  print("placing idx: "..turtleSim.selectNum)
end

function turtleSim.placeDown()
  print("placeDown idx: "..turtleSim.selectNum)
end

function turtleSim.placeUp()
  print("placeUp idx: "..turtleSim.selectNum)
end



function turtleSim.compare()
  print("compare")
  if turtleSim.selectNum == 6 then
    return true
  end
  return false
end

function turtleSim.compareDown()
  print("compareDown")
  if turtleSim.selectNum == 7 then
    return true
  end
  return false
end

function turtleSim.compareUp()
  print("compareUp")
  if turtleSim.selectNum == 5 then
    return true
  end
  return false
end


-- Utilities

function turtleSim.getItemCount(slot)
  return 2
end


-- Utilities

function inRange(val, min, max)
  return val >= min and val <= max
end


-- Return the Object so they can access it.

return turtleSim
