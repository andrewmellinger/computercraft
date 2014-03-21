inventoryNum = 2

function checkFuel()
  if turtle.getFuelLevel() < 8 then
	turtle.select(1)
	turtle.refuel(1)
  end
end

function showHelp()
  print("Usage: floor <length> <height>")
  print("  slot 1: coal")
  print("  slot 2+: blocks for flor")
end

function findMaterials()
  for i = inventoryNum, 16 do
	if turtle.getItemCount(i) > 0 then
  	turtle.select(i)
  	inventoryNum = i
  	return
	end
  end
end

function mainLoop(length, width)
  print("Starting floor length: "..length.." height: "..width)
  checkFuel()
  turtle.up()
  turnRight = true
  while (width > 0) do
		tmpLength = length
		while (tmpLength > 0) do
		  checkFuel()
			if not turtle.detectDown() then
				findMaterials()
				turtle.placeDown()
			end
			tmpLength = tmpLength - 1
			if tmpLength > 0 then
				turtle.forward()
			end
		end
		width = width - 1
		if turnRight then
			turtle.turnRight()
			turtle.forward()
			turtle.turnRight()
	  else
			turtle.turnLeft()
			turtle.forward()
			turtle.turnLeft()
	  end
	  turnRight = not turnRight
  end
end

-- Main

local tArgs = {...}
if #tArgs < 2 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  local width = tonumber( tArgs[2] )
  mainLoop(length, width)
end
print("Done")


