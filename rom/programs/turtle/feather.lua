local turtle = require "TurtleSim"

-- loadAPI()

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


function digRow(length)
  torchit = 6
  while (length > 0) do
    checkFuel()
    digColumn()
    torchit = checkTorch(torchit)
    length = length - 1
  end
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
  print("Digs tunnel len <1>, turns right, digs len <2>, right & digs back")
  print("Usage: ftunnel <length> <spacing=4>")
  print("  slot 1: coal")
  print("  slot 2: torches")
end


function mainLoop(length, spacing)
  print("Starting tunnel: "..length.." x "..spacing)
  turtle.up()

  print("\nDigging out")
  digRow(length)

  print("\nDigging over")
  turtle.turnRight()
  digRow(spacing + 1)

  print("\nDigging back")
  digRow(length)

  turtle.down()
end


---- Main

local tArgs = {...}
if #tArgs < 1 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  local spacing = 4
  if #tArgs > 1 then
    spacing = tonumber( tArgs[2] )
  end
  mainLoop(length, spacing)
end
print("Done")


