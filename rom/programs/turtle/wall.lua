gInventoryNum = 2

function checkFuel()
  if turtle.getFuelLevel() < 5 then
    turtle.select(1)
    turtle.refuel(1)
  end
end


function showHelp()
  print("Usage: wall <length> <height>")
  print("  slot 1: coal")
  print("  slot X: blocks for wall")
end


function findMaterials()
  for i = gInventoryNum, 16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      gInventoryNum = i
      return
    end
  end
end

function layer(length)

  while (length > 0) do
    checkFuel()
    if not turtle.detectDown() then
      findMaterials()
      turtle.placeDown()
    end
    if turtle.detect() then
      return length
    end

    length = length - 1
    if length > 0 then
      turtle.forward()
    end
  end

  return 0
end


function mainLoop(length, height)
  print("Starting wall length: "..length.." height: "..height)
  
  out = true
  local remain = 0
  while (height > 0) do
    -- Go out
    tmpLength = length
    if not out then
      tmpLength = tmpLength - remain
    end

    -- For coming back, we just come back to where we were    
    local remain = layer(length)
    out = not out
    
    height = height - 1
    turtle.left()
    turtle.left()
  end      
end

-- Main

local tArgs = {...}
if #tArgs < 2 then
  showHelp()
else
  local length = tonumber( tArgs[1] )
  local height = tonumber( tArgs[2] )
  mainLoop(length, height)
end
print("Done")


