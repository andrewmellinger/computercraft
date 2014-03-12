--local turtle = require "TurtleSim"

function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(1)
    turtle.refuel(1)
  end
end

function digAll()
  while turtle.detect() do
    turtle.dig()
  end
end

function digAllUp()
  while turtle.detectUp() do
    turtle.digUp()
  end
end

function moveUp(count)
  for i=1,count do
    digAllUp()
    turtle.up()
  end
end

function moveDown(count)
  for i=1,count do
    turtle.digDown()
    turtle.down()
  end
end

function placeStairs()
  turtle.turnRight()
  turtle.turnRight()
  turtle.select(3)
  turtle.place()
  turtle.turnLeft()
  turtle.turnLeft()
end

function checkTorch(counter)
  if counter == -1 then
    return counter
  end

  counter = counter - 1
  if counter == 0 then
    turtle.select(2)
    turtle.placeUp()
    counter = gTorchSpacing
  end
  return counter
end

function ensureDown()
  if not turtle.detectDown() then
    turtle.select(4)
    turtle.placeDown()
  end
end

-- Workhorse.  Mines the columns (3) for the stairs descent
-- Basically, mines up, mines forward then clears two columns on 
-- the way down.
function digColumn(doHigh, doStairs, doDown, torchCounter )
  --print("Making column. High: "..tostring(doHigh).." stairs: "..tostring(doStairs).." down: "..tostring(doDown).." torchCounter: "..tostring(torchCounter))
    
  height = 1
  if doHigh then
    height = 2
  end

  checkFuel()
  
  moveUp(height)
  digAllUp()
  digAll()
  turtle.forward()
  digAllUp()

  -- We can place up, as this is the only place we'll probably never dig again
  -- Otherwise, we often end up mining the torch
  torchCounter = checkTorch(torchCounter)

  -- Clear out below and forward
  for i =1,height do
    digAll()
    moveDown(1)
  end

  -- Stairs check
  if doStairs then
    placeStairs()
  end

  -- Descend
  if doDown then
    moveDown(1)
  end

  -- Need floor ot place stairs on or to walk on
  ensureDown()

  return torchCounter
end

function makeStairs(height)
  torchCounter = gTorchSpacing
  for i = 0,height do
    torchCounter = digColumn( i == 0, i > 0, i < height, torchCounter)
  end
end

function makeLanding(length)
  torchCounter = gTorchSpacing
  for i = 1, length - 1 do
    torchCounter = digColumn( true, false, false, torchCounter)
  end
end

function mainLoop(depth, layerHeight, landing)
  print ("Digging stairs down: "..depth.." layer height: "..layerHeight.." landing: "..landing)
  while (depth > 0) do
    -- Make the descent portion
    tmpHeight = layerHeight
    if depth < layerHeight then
      tmpHeight = depth
    end

    makeStairs(layerHeight)
    depth = depth - tmpHeight

    if landing > 1 then
      makeLanding(landing)
    end

  end
end

function showHelp()
  print("Usage: stairsdown <depth> <layerHeight=depth> <landing=0>")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: stairs")
  print("  slot 4: blocks for bridging under stairs")
end


-- GLOBALS
gTorchSpacing = 6

-- Main
local tArgs = {...}

if #tArgs < 1 then
  showHelp()
else
  local depth = tonumber( tArgs[1] )
  local layerHeight = depth
  local landing = 0
  if #tArgs > 2 then
    layerHeight = tonumber( tArgs[2] )
    landing = tonumber( tArgs[3] )
  end

  -- Always do a torch at every level
  if gTorchSpacing > layerHeight then
    gTorchSpacing = layerHeight
  end

  mainLoop(depth, layerHeight, landing)
end
print("Done")



