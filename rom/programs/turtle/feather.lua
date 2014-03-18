local turtle = require "TurtleSim"
package.path = package.path..";../../apis/turtle/?.lua"
local crush = require "crush"

-- loadAPI()

TORCH_INTERVAL = 10

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
  torchit = TORCH_INTERVAL
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
    print("Torching!")
    counter = TORCH_INTERVAL
  end
  return counter
end


function emptyContents(chestIdx, startIdx, endIdx)
  turtle.forward()
  while turtle.detect() do
    turtle.dig()
  end
  turtle.digDown()
  turtle.down()
  turtle.dig()
  turtle.select(chestIdx)
  if turtle.place() then
    for i = startIdx, endIdx do
      turtle.select(i)
      turtle.drop()
    end
  end
  turtle.up()
  turtle.back()
end


function showHelp()
  print("Digs tunnel len <1>, turns right, digs len <2>, right & digs back")
  print("Usage: ftunnel <length> <spacing=4> <iterations=1>")
  print("  If iterations is > 1, then it will go out and back that many times.")
  print("  When it comes back every other iteration, it will deposit the materials")
  print("    in one of the chests.")
  print("  slot 1: coal")
  print("  slot 2: torches")
  print("  slot 3: chests")
end


function mainLoop(length, spacing, iterations)
  
  print("Starting tunnel: "..length.." x "..spacing)
  turtle.up()

  local currIter = 0
  while (currIter < iterations) do
    print ("Starting iteration: "..currIter)

    print("\nDigging out")
    digRow(length)

    print("\nDigging over")
    turtle.turnRight()
    digRow(spacing + 1)

    print("\nDigging back")
    digRow(length)

    currIter = currIter + 1
    if currIter % 2 == 0 or currIter == iterations then
      -- Place chest and empty contents
      emptyContents(3,4,16)
    end

    if currIter < iterations then
      -- Move over so we can do it again.
      turtle.turnRight()
      for i = 1,spacing do
        turtle.forward()
      end
      turtle.turnRight()
    end
  end 

  turtle.digDown()
  turtle.down()
end


---- Main

-- TODO:  Add left switch




local tArgs = {...}
if #tArgs < 1 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  local spacing = 4
  local iterations = 1
  if #tArgs > 1 then
    spacing = tonumber( tArgs[2] )
  end
  if #tArgs > 2 then
    iterations = tonumber( tArgs[3] )
  end
  mainLoop(length, spacing, iterations)
end
print("Done")


