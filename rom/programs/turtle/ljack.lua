--local turtle = require "TurtleSim"

function checkFuel()
  if turtle.getFuelLevel() < 10 then
    turtle.select(1)
    turtle.refuel(1)
  end
end

function chop()
  foundSomething = false
  if turtle.detect() then
    turtle.dig()
    foundSomething = true
  end

  if turtle.detectUp() then
    turtle.digUp()
    foundSomething = true
  end
  return foundSomething
end

function chopTree()
  print("Chopping tree.")
  height = 0
  checkFuel()

  -- Chop up
  while (chop()) do
    checkFuel()
    turtle.up()
    height = height + 1
  end
  
  -- Go back down
  while (height > 0) do
    checkFuel()
    turtle.down()
    height = height - 1
  end
end

function showHelp()
  print("Usage: lumberjack <tree_count=1> <space_to_next=0>")
  print("  Note: spacing does NOT include tree size, just 'open' ground")
  print("  slot 1: coal")
end

function mainLoop(count, spacing)
  for i = 1,count do

    -- Move forward on all but first
    if i > 1 then
      for n = 1,spacing+1 do
        turtle.dig()
        turtle.forward()
      end
    end
    
    chopTree()
  end
end


-- TODO:  Add ability to do 2x2 trees

-- Main
local tArgs = {...}
if #tArgs == 1 then
  showHelp()
else
  local count = 1
  local spacing = 0
  if #tArgs > 1 then
    count = tonumber( tArgs[1] )
    spacing = tonumber( tArgs[2] )
  end
  mainLoop(count, spacing, size)
end
print("Done")




