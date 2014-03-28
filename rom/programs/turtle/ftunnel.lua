-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- ComputerCraft script for digging "fast tunnels" (ftunnel.)
-- This is faster than the built in tunnel because it only does one wide
-- and two high. Will place torches if it has some and is configured with a
-- spacing > 0, and will place blocks for bridging.
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

function digColumn()
  crush.digAll()
  turtle.forward()
  crush.digAllUp()
  turtle.select(3)
  turtle.placeDown()
end


-- TODO:  Move to crush once tested
function checkTorch(counter, torchInterval, torchSlot, blockSlot, doBehind)
  if torchInterval <= 0 then
    return 0
  end

  if counter > 0 then
    return counter - 1
  end

  -- Torch is slot 2
  turtle.select(torchSlot)

  -- First, try right side
  turtle.turnRight()
  if turtle.placeUp() then
    turtle.turnLeft()
    return torchInterval
  end
  
  -- If they gave us a block to place, try it
  if blockSlot > 0 then
    turtle.up()
    turtle.select(blockSlot)
    turtle.place()
    turtle.down()
    turtle.select(torchSlot)
    local placedIt = turtle.placeUp()
    turtle.turnLeft()

    if placedIt then
      return torchInterval
    end
  end

  -- Try left side
  turtle.turnLeft()
  if not turtle.placeUp() then
    if doBehind then
      -- Fallback to behind
      turtle.turnLeft()
      turtle.place()
      turtle.turnRight()
    end
  end      
  turtle.turnRight()

  return torchInterval
end


function showHelp()
  print("ftunnel [-l #] [-t #]")
  print("Digs two high tunnel with torches and bridging")
  print("  -l #: length, def 16")
  print("  -t #: torch spacing, 0 skip, def 11")
  print("  s1: coal")
  print("  s2: torches")
  print("  s3: blocks for bridging")
end


function mainLoop(length, torchSpacing)
  print("Length: "..length.." spacing: "..torchSpacing)
  if torchSpacing == 0 then
    print ("  Skipping torch placement.")
  end
  local torchCounter = torchSpacing

  while (length > 0) do
    crush.checkFuel()
    digColumn()
    torchCounter = checkTorch(torchCounter, torchSpacing, 2, 3, false)
    length = length - 1
  end

end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Main

local argTable = { l=16, t=11, h=false }
crush.overlayArgs(":l:t:h", argTable, ...)

if argTable.h then
  showHelp()
else
  mainLoop(argTable.l, argTable.t)
end

print("Done")




