-- TODO:  Make general torching routine

gTorchInterval = 6

function checkFuel()
  if turtle.getFuelLevel() < 15 then
    turtle.select(1)
    turtle.refuel(1)
  end
end

function showHelp()
  print("Usage: torch_up")
  print("  slot 1: coal")
  print("  slot 2: torches")
end

function mainLoop()
  print("Starting torch placement.")
  height = 0
  torch = gTorchInterval
  while (not turtle.detectUp()) do
    checkFuel()
    turtle.up()
    height = height + 1
      torch = torch - 1
      if torch == 0 then
        turtle.select(2)
        turtle.place()
        torch = gTorchInterval
      end
  end

  while (height > 0) do
    turtle.down()
    height = height - 1
  end

end

-- Main
local tArgs = {...}
if #tArgs > 0 then
  showHelp()
else
  mainLoop()
end
print("Done")





