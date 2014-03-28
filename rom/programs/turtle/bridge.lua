--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")


function mainLoop(length)
  print("Starting bridge length: "..length)

  -- Length can be positive (max) or negative which
  -- is go until wall our out of blocks.
  while length ~= 0 do
    crush.checkFuel()

    -- If we run into something, we are done.
    if turtle.detect() then
      break
    end

    -- Look for more items if we have them
    if turtle.getItemCount(2) == 1 then
      crush.gatherItems(2, 3, 16)
    end

    -- Do the real work
    turtle.forward()
    if not turtle.detectDown() then
      turtle.select(2)
      turtle.placeDown()
    end
    length = length - 1

    -- If we are out of supplies (we tried gathering above) 
    -- then we are done.
    if turtle.getItemCount(2) == 0 then
      break
    end

  end
end


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function showHelp()
  print("bridge <-l #>")
  print(" -l #: Len, -1 go until wall/")
  print("          out of blocks, def -1")
  print(" s1: coal")
  print(" s2+: blocks for bridging")
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Main
local argTable = { l=-1, h=false }
crush.overlayArgs(":l:h", argTable, ...)

if argTable.h then
  showHelp()
else
  mainLoop(argTable.l)
end

print("Done")


