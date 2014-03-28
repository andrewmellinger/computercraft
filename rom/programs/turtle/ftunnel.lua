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


function checkTorch(counter, torchInterval)
  if torchInterval <= 0 then
    return 0
  end

  counter = counter - 1
  if counter == 0 then
    turtle.turnRight()
    turtle.turnRight()
    turtle.select(2)
    turtle.place()
    turtle.turnRight()
    turtle.turnRight()
    counter = torchInterval
  end
  return counter
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
    torchCounter = checkTorch(torchCounter, torchSpacing)
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




