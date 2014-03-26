--[[
This is a simple Lua script in Minecraft's ComputerCraft.

The basic purpose is to clear out the volume specified in the arguments.  The
bot assumes to start at the top, left corner of the volume and will clear
out layers forward, to the right and down until it hits the end conditions.

It will empty its contents beside and above the start location if an optional
switch is specifed.
]]
--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

-- Global depth value
-- TODO:  Make global table..
gDepth = 0


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
    crush.checkFuel()
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

    turtle.digDown()
    turtle.down()
    gDepth = gDepth +1

    -- Go down one extra if > 2 so we can do three at a time.
    if height > 2 then
      turtle.digDown()
      turtle.down()
      gDepth = gDepth +1
    end
    
    if height > 1 then
      turtle.digDown()
    end
    
  end
  return height, right
end


function unload()
  -- Go up to the top, turn left and unload into that chest
  -- We go up one extra because the chest would have been above.
  local diff = gDepth + 1

  crush.checkFuel()
  for i = 1,diff do
    turtle.up()
  end
  turtle.turnLeft()

  for i = 3,16 do
    turtle.select(i)
    turtle.drop()
  end

  crush.checkFuel()
  turtle.turnRight()
  for i = 1,diff do
    turtle.down()
  end

end


function returnHome(length, width, atStartCorner)
  -- We assume we are facing away

  -- Move back
  if not atStartCorner then
    turtle.turnLeft()
    for i = 1,width do
      turtle.forward()
    end
    turtle.turnLeft()
    for i = 1,length do
      turtle.forward()
    end
  end

  -- Up
  for i = 1,gDepth do 
    crush.checkFuel()
    turtle.up()
  end

  -- One of the use cases is to actually dig a quarry, not just
  -- a room
  -- In this case, move up one more and forward if we can
  if not turtle.detectUp() then
    turtle.up()
  end
  if not turtle.detect() then
    crush.checkFuel()
    turtle.forward()
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

-- ============================================================================

function mainLoop(length, width, height, shouldUnload)
  print("Starting quarry. l: "..length.." w: "..width.." d: "..height)

  crush.checkFuel()

  -- Track left vs. right turns and where we are relative to start
  local turnRight = true
  local atStartCorner = true

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
 

  -- Scrape away three layers at a time if they want that much
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

    atStartCorner = not atStartCorner

    if atStartCorner and shouldUnload then
      unload()
    end
  end

  returnHome(length, width, atStartCorner)

end

-- ============================================================================

function showHelp()
  print("quarry [-l #] [-w #] [-d #] [-c] [-h]")
  print("  -l #: away, includes start")
  print("  -w #: to right, includes start")
  print("  -d #: down, includes start")
  print("  -c  : unload into chest up & left")
  print("  -h  : this help screen")
end

-- ============================================================================
-- TODO: Place torches on bottom layer
-- TODO: Can it place pumpkins on its head????
-- TODO: Should we quarry up?

-- Main
local argTable = { l=3, w=3, d=2, c=false, h=false }
crush.overlayArgs(":l:w:d:ch", argTable, ...)

if argTable.h then
  showHelp()
else
  mainLoop(argTable.l, argTable.w, argTable.d, argTable.c)
end

print("Done")




