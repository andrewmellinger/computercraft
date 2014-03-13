-- os.loadAPI("crush")
-- os.loadAPI("/rom/programs/turtle/crush")
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


function checkTorch(counter, torchInterval)
  if torchInterval == 0 then
    return 0
  end

  counter = counter - 1
  if counter == 0 then
    turtle.select(2)
    turtle.placeDown()
    counter = torchInterval
  end
  return counter
end


function showHelp()
  print("Usage: ftunnel <length> <torch_interval=8>")
  print("Goes up, digs ahead and down, places torches on interval.")
  print("If torchInterval == 0, then no torches are placed")
  print("  slot 1: coal")
  print("  slot 2: torches")
end


function mainLoop(length, torchInterval)
  print("Starting tunnel length: "..length)
  local torchCounter = torchInterval

  -- Go high so we can make torch placement easy
  turtle.up()

  while (length > 0) do
    checkFuel()
    digColumn()
    torchCounter = checkTorch(torchCounter, torchInterval)
    length = length - 1
  end

  -- Clear in case we placed a torch
  turtle.digDown()
  turtle.down()
end

-- Main

local tArgs = {...}
if #tArgs < 1 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  local torchInterval = 8
  if #tArgs > 1
    torchInterval = tonumber( tArgs[2] )
  end
  mainLoop(length, torchInterval)
end
print("Done")




