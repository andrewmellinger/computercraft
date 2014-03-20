--local turtle = require "TurtleSim"

function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(1)
    turtle.refuel(1)
  end
end


function digColumn()
  turtle.dig()
  turtle.forward()
end


function digRow(length)
  while (length > 0) do
    checkFuel()
    digColumn()
    length = length - 1
  end
end


function showHelp()
  print("Clears pumpkins len <1>, turns right, digs len <2>, right & digs back")
  print("Usage: pumpkins <length> <spacing=4>")
  print("  slot 1: coal")
end


function mainLoop(length, spacing)
  print("Clearing pumpkins: "..length.." x "..spacing)

  print("\nDigging out")
  digRow(length+1)

  print("\nDigging over")
  turtle.turnRight()
  digRow(spacing + 1)

  print("\nDigging back")
  turtle.turnRight()
  digRow(length+1)
end

---- Main
-- TODO:  Switch to using crush out and back.
local tArgs = {...}
if #tArgs < 2 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  local spacing = tonumber( tArgs[2] )
  mainLoop(length, spacing)
end
print("Done")




