local turtle = require "TurtleSim"
package.path = package.path..";../../apis/turtle/?.lua"
local crush = require "crush"

-- loadAPI()

-- Global configs
gTorchSpacing = 11
gTurnRight = false

FUEL_SLOT=1
TORCH_SLOT=2
CHEST_SLOT=3

function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(FUEL_SLOT)
    turtle.refuel(1)
  end
end


function digColumn()
  while turtle.detect() do
    turtle.dig()
  end
  turtle.forward()
  turtle.digDown()
end


function digRow(length)
  torchIt = gTorchSpacing
  if torchIt >= length then
    torchIt = math.floor(length / 2)
  end
  while (length > 0) do
    checkFuel()
    digColumn()
    torchIt = checkTorch(torchIt)
    length = length - 1
  end
end


-- Moves torches to slot 2 until we get 64
function gatherTorches()
  for i = 4,16 do
    turtle.select(i)
    if turtle.compareTo(TORCH_SLOT) then
      turtle.transferTo(TORCH_SLOT)
      if turtle.getItemCount(TORCH_SLOT) == 64 then
        break
      end
    end
  end
end

-- Place a torch down if we have them.
function placeTorchDown()
  if turtle.getItemCount(TORCH_SLOT) == 1 then
    gatherTorches()
  end
  if turtle.getItemCount(TORCH_SLOT) > 1 then
    turtle.select(TORCH_SLOT)
    turtle.placeDown()
    --print("Torching!")
  end
end

-- Checks to see if we need to place a torch down
function checkTorch(counter)
  if gTorchSpacing == 0 then
    return 0
  end

  counter = counter - 1
  if counter == 0 then
    placeTorchDown()
    counter = gTorchSpacing
  end
  return counter
end

-- Dumps all the contents into a chest
function emptyContents(chestSlot, torchSlot, startIdx, endIdx)
  -- Backup one and put a chest down on the floor
  turtle.back()
  turtle.turnRight()
  while turtle.detect() do
    turtle.dig()
  end
  turtle.digDown()
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
  turtle.up()
  turtle.turnLeft()
  turtle.forward()
end

-- This doens't dig down
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
  print("Digs a tunnel out, goes spacing to left or right, tunnels back.")
  print("Usage: ftunnel [-l #] [-w #] [-t #] [-n #] [-r]")
  print("  -l #  = Length of tunnel, default 60")
  print("  -w #  = Spacing between tunnels, default 4")
  print("  -t #  = Spacing between torches, default 11")
  print("  -n #  = Number of out-back pairs, default 1")
  print("  -r    = Work to the right, default is to work to the left.")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: chests")
  print("  slot n: might be torches")
end


function mainLoop(length, spacing, iterations)
  print("Starting tunnel: "..length.." x "..spacing)
  checkFuel()
  turtle.up()

  local currIter = 0
  while (currIter < iterations) do
    print ("Starting iteration: "..currIter.." of "..iterations)

    print("\nDigging out")
    digRow(length)

    print("\nDigging over")
    turn(gTurnRight)
    digRow(spacing + 1)
    turn(gTurnRight)

    print("\nDigging back")
    digRow(length)

    currIter = currIter + 1
    if currIter % 2 == 0 or currIter == iterations then
      emptyContents(CHEST_SLOT, TORCH_SLOT, 4, 16)
    end

    if currIter < iterations then
      print("Moving over")
      moveOver(spacing)
    end
  end 

  turtle.digDown()
  turtle.down()
end


---- Main

local argTable = { l=60, w=4, t=11, n=1, r=false }
-- crush.overlayArgs(":l:w:t:n:r", argTable, ...)
overlayArgs(":l:w:t:n:r", argTable, ...)

gTorchSpacing=argTable.t
gTurnRight=argTable.r

mainLoop(argTable.l, argTable.w, argTable.n)

print("Done")


