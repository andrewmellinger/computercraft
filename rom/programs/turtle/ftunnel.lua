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

  -- If the counter hasn't reach zero, just count down
  if counter > 0 then
    return counter - 1
  end

  -- Go back because it might one put on the wall we are about to dig
  -- and so will get destroyed
  -- TODO:  Move into digColumn before forward to optimize movement
  turtle.back()

  -- Torch is slot 2
  turtle.select(torchSlot)

  -- First, try placing "up" 
  -- The way CC works, it will choose a side.
  if turtle.placeUp() then
    turtle.forward()
    return torchInterval
  end
  
  -- If they gave us a block to place, try it
  if blockSlot > 0 then
    turtle.up()
    turtle.turnRight()
    turtle.select(blockSlot)
    turtle.place()
    turtle.down()
    turtle.select(torchSlot)
    local placedIt = turtle.placeUp()
    turtle.turnLeft()

    if placedIt then
      turtle.forward()
      return torchInterval
    end
  end

  turtle.forward()

  -- At this point try behind
  if doBehind then
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.place()
    turtle.turnRight()
    turtle.turnRight()
  end

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




