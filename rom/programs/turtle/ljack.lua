--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

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


function chopTree(size)
  print("Chopping tree of size: "..size)
  if size == 2 then
    -- Get into first part of trunk
    ccts("*f")
  end

  height = chopAllUp()
  
  -- On the way down we can do other side of big tree,
  -- take out leaves
  if size == 2 then 
    ccts("*fl*fl")
    height = height + chopAllUp()
  else
    crush.ccts("*f*f")
  end

  -- Now, take out a bunch of stuff on the way down
  crush.tunnelDown(height)

  -- Vincini says, back to the beginning!
  if size == 2 then
    crush.ccts("*f*fl*fl")
  else
    crush.ccts("bb")
  end
end

function showHelp()
  print("This script has the turtle cut down trees.")
  print("Place the turtle before the trunk.  For a 2x2 tree")
  print("place the turtle before and on the right side of")
  print("the trunk.\n")
  print("Usage: ljack [-n #] [-w 1|2] [-s #] [-h]")
  print("  -n #    = Number of trees.      Default = 1")
  print("  -w 1|2  = Width of tree. 1 or 2 Default = 1")
  print("  -s #    = SPACE between trees.  Default = 3")
  print("  -h      = This help screen.")
  print("Inventory:")
  print("  slot 1: coal")
end

function mainLoop(count, spacing, size)
  for i = 1,count do

    -- Move forward on all but first
    if i > 1 then
      for n = 1,spacing + 1 do
        turtle.dig()
        turtle.forward()
      end
    end
    
    chopTree(size)
  end
end


-- ========================================

-- Main
local argTable = { n=1, w=1, s=0, h=false }
crush.overlayArgs(":n:w:s:h", argTable, ...)

if argTable.h then
  showHelp()
else
  mainLoop(argTable.n, argTable.s, argTable.w)
end

print("Done")




