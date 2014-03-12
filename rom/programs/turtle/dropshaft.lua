function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(1)
    turtle.refuel(1)
  end
end

function digLayer()
  if turtle.detectDown() then
    turtle.digDown()
  end
  turtle.down()
  if turtle.detect() then
    turtle.dig()
  end
  turtle.forward()
  if not turtle.detect() then
    turtle.select(4)
    turtle.place()
  end
  turtle.back()
  turtle.select(3)
  turtle.place()
end

function checkTorch(counter)
  counter = counter - 1
  if counter == 0 then
    turtle.turnRight()
    turtle.select(2)
    turtle.placeUp()
    turtle.turnLeft()
    counter = 6
  end
  return counter
end

function showHelp()
  print("Usage: ftunnel <length>")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: ladder")
  print("  slot 4: block for ladder backing")
end

function mainLoop(length)
  print("Starting dropshaft depth: "..length)
  torchit = 6
  while (length > 0) do
    checkFuel()
    digLayer()
    torchit = checkTorch(torchit)
    length = length - 1
  end
end

-- Main
local tArgs = {...}
if #tArgs < 1
  showHelp()
else
  local length = tonumber( tArgs[1] )
  mainLoop(length)
end
print("Done")


