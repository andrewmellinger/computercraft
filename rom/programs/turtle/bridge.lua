function checkFuel()
  if turtle.getFuelLevel() < 3 then
    turtle.select(1)
    turtle.refuel(1)
  end
end


function showHelp()
  print("Usage: bridge <length>")
  print("  slot 1: coal")
  print("  slot 2: blocks for bridging")
end


function mainLoop(length)
  print("Starting bridge length: "..length)
  torchit = 6
  while (length > 0) do
    checkFuel()
    turtle.forward()
    if not turtle.detectDown() then
      turtle.select(2)
      turtle.placeDown()
    end
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


