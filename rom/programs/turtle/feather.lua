-- First two lines are for PC, the last one is for MC.
--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

-- Global configs
gTorchSpacing = 11
gTurnRight = false
gPlaceChests = false

FUEL_SLOT=1
TORCH_SLOT=2
CHEST_SLOT=3
BRIDGE_SLOT=4


function digColumn()
  crush.digAll()
  turtle.forward()
  crush.digAllUp()
  
  -- Bridge if we can
  if turtle.getItemCount(BRIDGE_SLOT) == 1 then
    crush.gatherItems(BRIDGE_SLOT, 5, 16)
  end

  if turtle.getItemCount(BRIDGE_SLOT) >= 1 then
    turtle.select(BRIDGE_SLOT)
    turtle.placeDown()
  end
end


function digRow(length)
  torchIt = gTorchSpacing
  if torchIt >= length then
    torchIt = math.floor(length / 2)
  end
  while (length > 0) do
    crush.checkFuel()
    digColumn()
    torchIt = checkTorch(torchIt)
    length = length - 1
  end
end


-- Place a torch down if we have them.
function placeTorch()
  if turtle.getItemCount(TORCH_SLOT) == 1 then
    crush.gatherItems(TORCH_SLOT, 5, 16)
  end
  if turtle.getItemCount(TORCH_SLOT) > 1 then
    turtle.select(TORCH_SLOT)

    turtle.turnRight()
    turtle.turnRight()
    turtle.place()
    turtle.turnRight()
    turtle.turnRight()
  end
end

-- Checks to see if we need to place a torch down
function checkTorch(counter)
  if gTorchSpacing <= 0 then
    return 0
  end

  counter = counter - 1
  if counter == 0 then
    placeTorch()
    counter = gTorchSpacing
  end
  return counter
end

-- Dumps all the contents into a chest
function emptyContents(chestSlot, torchSlot, startIdx, endIdx)
  if not gPlaceChests then
    return
  end

  -- Gather up torches and blocks before we do this
  crush.gatherItems(TORCH_SLOT, 5, 16)
  crush.gatherItems(BRIDGE_SLOT, 5, 16)

  -- Backup one and put a chest down on the floor
  turtle.back()
  turtle.up()
  turtle.turnRight()
  crush.digAll()
  turtle.down()
  turtle.dig()

  -- Dump the contents
  turtle.select(chestSlot)
  if turtle.place() then
    for i = startIdx, endIdx do
      turtle.select(i)
      -- Drop things that are not torches
      if not turtle.compareTo(torchSlot) then
        turtle.drop()
      end
    end
  end

  -- Put us back where we were
  turtle.turnLeft()
  turtle.forward()
end

-- This doesn't dig down
function moveOver(spacing)

  -- Move over so we can do it again.
  turn(not gTurnRight)
  for i = 1,spacing do
    turtle.dig()
    turtle.forward()
  end
  turn(not gTurnRight)

end

-- Turn the specific direction
function turn(right)
  if right then
    turtle.turnRight()
  else
    turtle.turnLeft()
  end
end


function showHelp()
  print("feather [-l #] [-w #] [-t #] [-n #] [-r] [-c] [-h]")
  print("  -l #  = Length             Def 60")
  print("  -w #  = Tunnel spacing.    Def 4")
  print("  -t #  = Torch spacing.     Def 11")
  print("  -n #  = Nm out-back pairs. Def 1")
  print("  -r    = Right instead of left.")
  print("  -c    = Place chests.      Def no chests.")
  print("  -h    = This help screen.")
  print("  s1 coal, s2 torches, s3 chests, s4 filler")
end


function mainLoop(length, spacing, iterations)
  print("Starting tunnel: "..length.." x "..spacing)
  crush.checkFuel()

  local currIter = 0
  while (currIter < iterations) do
    -- Out
    digRow(length)

    -- Across
    turn(gTurnRight)
    digRow(spacing + 1)
    turn(gTurnRight)

    -- Back
    digRow(length)

    -- Dump stuff
    currIter = currIter + 1
    if currIter % 2 == 0 or currIter == iterations then
      emptyContents(CHEST_SLOT, TORCH_SLOT, 5, 16)
    end

    -- Next out-back
    if currIter < iterations then
      moveOver(spacing + 1)
    end
  end 

end


---- Main

local argTable = { l=60, w=4, t=11, n=1, r=false, h=false, c=false }
crush.overlayArgs(":l:w:t:n:rhc", argTable, ...)

if argTable.h then
  showHelp()
else
  gTorchSpacing=argTable.t
  gTurnRight=argTable.r
  gPlaceChests=argTable.c

  mainLoop(argTable.l, argTable.w, argTable.n)
end

print("Done")


