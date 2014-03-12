local turtle = require "TurtleSim"
--[[

TODO: Add switches:  Exclusive modes
-torch - go high and place torches - torches in 2
-bridge - go low and place bridge - blocks in 2

]]


function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(1)
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


function checkTorch(counter)
  counter = counter - 1
  if counter == 0 then
    turtle.select(2)
    turtle.placeDown()
    counter = 6
  end
  return counter
end


function showHelp()
  print("Usage: ftunnel <length>")
  print("  slot 1: coal")
  print("  slot 2: torches or blocks")
end


function mainLoop(length)
  print("Starting tunnel length: "..length)
  torchit = 6
  turtle.up()
  while (length > 0) do
    checkFuel()
    digColumn()
    torchit = checkTorch(torchit)
    length = length - 1
  end
  turtle.down()
end

-- Main

local tArgs = {...}
if #tArgs < 1 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  mainLoop(length)
end
print("Done")




