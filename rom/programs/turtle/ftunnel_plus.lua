function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(1)
    turtle.refuel(1)
  end
end


function digColumn()
  turtle.up()
  while turtle.detect() do
    turtle.dig()
  end
  turtle.forward()
  if turtle.detectDown() then
    turtle.digDown()
  end
  turtle.down()
  if not turtle.detectDown() then
    turtle.select(3)
    turtle.placeDown()
  end
end


function checkTorch(counter)
  counter = counter - 1
  if counter == 0 then
    turtle.turnRight()
    turtle.turnRight()
    turtle.select(2)
    turtle.place()
    turtle.turnLeft()
    turtle.turnLeft()
    counter = 6
  end
  return counter
end


function showHelp()
  print("Usage: ftunnel <length>")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: blocks for bridging")
end


function mainLoop(length)
  print("Starting tunnel length: "..length)
  torchit = 6
  while (length > 0) do
    checkFuel()
    digColumn()
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


