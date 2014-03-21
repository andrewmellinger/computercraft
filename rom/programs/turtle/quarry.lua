--local turtle = require "TurtleSim"

-- Global depth value
gDepth = 0


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

-- Digs the block ahead an maybe one above and one below
function digIt(height)
  digAll()
  turtle.forward()
  if height > 1 then
    turtle.digDown()
  end
  if height > 2 then
    digAllUp()
  end
end


function digRow(length, height)
  while (length > 0) do
    checkFuel()
    digIt(height)
    length = length - 1
    
  end
end


-- Moves to next row
function nextRow(height, right)
  if right then
    turtle.turnRight()
    digIt(height)
    turtle.forward()
    turtle.turnRight()
  else
    turtle.turnLeft()
    digIt(height)
    turtle.forward()
    turtle.turnLeft()
  end
  return not right
end


-- Digs the slab
function digSlab(length, width, height, right)
  while (width > 0) do
    digRow(length - 1, height)

    width = width - 1
    if width > 0 then
      right = nextRow(height, right)
    end
  end
 
  return right
end


function changeHeight(height, right)
  height = height - 3
  if height > 0 then
    turtle.turnRight()
    turtle.turnRight()
    --right = not right  -- Since we turned around, re-orient

    turtle.digDown()
    turtle.down()
    gDepth = gDepth +1

    -- Go down one extra if > 2 so we can do three at a time.
    if height > 2 then
      turtle.digDown()
      turtle.down()
      gDepth = gDepth +1
    end
    
    turtle.digDown()
    
  end
  return height, right
end


function unload()
  -- Go up to the top, turn left and unload into that chest
  -- We go up one extra because the chest would have been above.
  local diff = gDepth + 1

  checkFuel()
  for i = 1,diff do
    turtle.up()
  end
  turtle.turnLeft()

  for i = 3,16 do
    turtle.select(i)
    turtle.drop()
  end

  checkFuel()
  turtle.turnRight()
  for i = 1,diff do
    turtle.down()
  end

end


function checkTorch(counter)
  counter = counter - 1
  if counter == 0 then
    turtle.select(2)
    turtle.placeDown()
    counter = 6
  end
  return counter
end


function showHelp()
  print("Usage: clear <length> <width> <height> <torch>")
  print("")
  print("Clears and area of the specified volume, up")
  print("The turtle is IN the starting corner block")
  print("If there is a chest above and to left of start")
  print("The turtle will place output there periodically.")
  print("  <length> Number of blocks away from front")
  print("  <width>  (1) Number of rows to right of unit, including starting.")
  print("  <height> (1) Number of layers down, including starting layer")
  print("  <torch>  (0) Set to have it place torches every X blocks")
  print("  slot 1: coal")
  print("  slot 2: torches")
end


function mainLoop(length, width, height, torches)
  print("Starting clearing operation. L: "..length.." W: "..width.." H: "..height)

  checkFuel()
  local startingHeight = height;

  -- Move down to the starting position if larger area
  if height > 2 then
    turtle.digDown()
    turtle.down()
    gDepth = gDepth +1
  end

  -- Clear out below
  if height > 1 then
    turtle.digDown()
  end
 
  -- Track left vs. right turns
  local turnRight = true

  -- Scrape away three layers at a time if they want that much
  outAndBack = false
  while (height > 0) do
    turnRight = digSlab(length, width, height, turnRight)

    if height > 1 then
      turtle.down()
      gDepth = gDepth + 1
      -- We should now be right above the next lay,
      -- so changeHeight should work
    end

    -- Go down if we need to change layers
    height, turnRight = changeHeight(height, turnRight)

    if outAndBack then
      unload()
    end

    outAndBack = not outAndBack
  end
end

-- TODO: Place torches on bottom layer
-- TODO: Can it place pumpkins on its head????

-- Main

local tArgs = {...}
if #tArgs < 1 then
  showHelp()
else
  local width = 1
  local height = 1
  local torches = 0
  local length = tonumber( tArgs[1] )
  if #tArgs > 1 then
    width = tonumber( tArgs[2] )
  end
  if #tArgs > 2 then
    height = tonumber( tArgs[3] )
  end
  if #tArgs > 3 then
    torches = tonumber( tArgs[4] )
  end
  mainLoop(length, width, height, torches)
end
print("Done")




