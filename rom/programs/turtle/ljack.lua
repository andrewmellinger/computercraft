--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- TODO:  Move to crush
function chopAllUp()
  height = 0
  crush.checkFuel()

  -- Chop up
  while (chop()) do
    crush.checkFuel()
    turtle.up()
    height = height + 1
  end

  return height
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function chopTree(size, count, spacing)
  print("Chopping tree of size: "..size)
  if size == 2 then
    -- Get into first part of trunk
    ccts("*f")
  end

  height = chopAllUp()

  -- On the way down we can chop wood or leaves
  if size == 2 then 
    -- Size two tree, do the other side..
    ccts("*fr*fr")
  elseif count > 1 then
    -- For size one trees with > 1, do another tree
    for i = 1,spacing+1 do
      turtle.dig()
      turtle.forward()
    end

    -- This time chopping down and extra one
    count = count - 1
  else
    -- Just do leaves
    crush.ccts("*f*f")
  end

  -- Trying going up again in case the new part goes higher
  height = height + chopAllUp()

  -- Now, take out a bunch of stuff on the way down
  crush.tunnelDown(height)

  -- Vizzini says: Back to the beginning!
  if size == 2 then
    crush.ccts("*f*fr*fr")
  else
    crush.ccts("bb")
  end

  -- We always chop down at least one
  count = count - 1

  return count
end

function showHelp()
  print("Usage: ljack [-n #] [-w 1|2] [-s #] [-h]")
  print("Place before and on left side of trunk")
  print("  -n #  : Number of trees.      (1)")
  print("  -w 1|2: Width of tree. 1 or 2 (1)")
  print("  -s #  : SPACE between trees.  (3)")
  print("  -h    : This help screen.")
  print("Inventory:")
  print("  slot 1: coal")
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function mainLoop(count, spacing, size)
  while count > 0 do

    -- Move forward on all but first
    if count > 1 then
      for n = 1,spacing + 1 do
        turtle.dig()
        turtle.forward()
      end
    end
    
    count = chopTree(size, count, spacing)
  end
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Main
local argTable = { n=1, w=1, s=0, h=false }
crush.overlayArgs(":n:w:s:h", argTable, ...)

if argTable.h then
  showHelp()
else
  mainLoop(argTable.n, argTable.s, argTable.w)
end

print("Done")




