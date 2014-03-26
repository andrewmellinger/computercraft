--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

-- CONSTANTS
local TORCH_NUM = 2
local LADDER_NUM = 3
local BACKING_BLOCK_NUM = 4

-- GLOBALS (sigh)
gDShaft = { torchSpacing=7 }

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function checkTorch(counter)
  -- If -1, don't place torches
  if gDShaft.torchSpacing == -1 then
    return 0
  end

  counter = counter - 1
  if counter == 0 then
    turtle.turnRight()
    turtle.select(TORCH_NUM)
    turtle.placeDown()
    turtle.turnLeft()
    counter = gDShaft.torchSpacing
  end
  return counter
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Move down until we find the bottom
-- Place backing blocks if needed
function findBottom()
  local depth = 0;
  while not turtle.detectDown() do
    crush.checkFuel()
    turtle.down()
    turtle.select(BACKING_BLOCK_NUM)
    turtle.place()
    depth = depth + 1
  end

  return depth
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Dig down to the specified depth
-- Place backing blocks if needed
function goDown(depth)
  while depth > 0 do
    crush.checkFuel()
    turtle.digDown()
    turtle.down()
    turtle.select(BACKING_BLOCK_NUM)
    turtle.place()
    depth = depth - 1
  end
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Dig up and place ladder the whole way
function ladderUp(depth)
  crush.checkFuel()
  local torchIt = gDShaft.torchSpacing
  
  -- Go up the whole way
  while (depth > 0) do
    crush.checkFuel()

    -- Place the ladder in front
    turtle.select(LADDER_NUM)
    turtle.place()

    -- Keep going up
    crush.digAllUp()
    turtle.up()
  
    -- Place torches periodically
    torchIt = checkTorch(torchIt)
    depth = depth - 1
  end

end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function mainLoop(depth)
  print("Starting dropshaft depth: "..depth)

  if depth == -1 then
    depth = findBottom()
  else
    goDown(depth)
  end

  -- Now we want to move back, and dig another column and place ladder
  turtle.turnRight()
  turtle.turnRight()
  crush.digAll()
  turtle.forward()
  turtle.turnRight()
  turtle.turnRight()

  -- Place ladder the whole way up
  ladderUp(depth)
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function showHelp()
  print("Usage: dshaft [-d #] [-t #]")
  print("  -d #: Depth, -1 go until bottom, def -1")
  print("  -t #: Torch spacing, -1 disable, def 7")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: ladder")
  print("  slot 4: block for ladder backing")
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Main
local argTable = { d=-1, t=7, h=false }
crush.overlayArgs(":d:t:h", argTable, ...)

if argTable.h then
  showHelp()
else
  -- Set globals
  gDShaft.torchSpacing = argTable.t

  mainLoop(argTable.d)
end

print("Done")


