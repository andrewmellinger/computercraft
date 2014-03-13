local turtle = require "TurtleSim"

local Sides = {
  ["Up"] = "up";
  ["Down"] = "down";
  ["Front"] = "front";
  ["Left"] = "left";
  ["Right"] = "right";
}

function checkFuel()
  if turtle.getFuelLevel() < 20 then
    turtle.select(1)
    turtle.refuel(1)
  end
end


function digColumn()

  -- Get upper block
  turtle.up()
  while turtle.detect() do
    turtle.dig()
  end

  -- Get lower block
  turtle.forward()
  if turtle.detectDown() then
    turtle.digDown()
  end

  -- Check top and upper sides
  digIfWanted(Sides.Up)

  turtle.turnLeft()
  digIfWanted(Sides.Front)

  turtle.turnRight()
  turtle.turnRight()

  digIfWanted(Sides.Front)

  -- Check lower sides and bottom
  turtle.down()
  digIfWanted(Sides.Front)

  turtle.turnLeft()
  turtle.turnLeft()

  digIfWanted(Sides.Front)

  turtle.turnRight()
  digIfWanted(Sides.Down)
 
  -- Make sure we have something to walk on
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
  print("Usage: minetunnel <length>")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: blocks for bridging")
end


function compareCheckDig()
  if turtle.compare() then
    turtle.dig()
    return
  end
end


function digIfWanted(side)
  -- Check the specified side for Mats in the second row, 5,6,7,8
  -- So like iron ore block, charcoal ore block, redstone ore block, diamond ore block
  -- NOTE:  Need BLOCKS of things for this to work right
  
  for idx = 5, 8 do
    turtle.select(idx)

    if side == Sides.Front then
      if turtle.compare() then
        turtle.dig()
        break
      end
    elseif side == Sides.Up then
      if turtle.compareUp() then
        turtle.digUp()
        break
      end
    elseif side == Sides.Down then
      if turtle.compareDown() then
        turtle.digDown()
        break
      end
    else
      print("!! Don't recognize side: "..side)
      break;
    end

  end
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
if #tArgs < 1 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  mainLoop(length)
end
print("Done")


