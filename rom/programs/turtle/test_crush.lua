-- Since these things are all global, we can load the TurtleSim
-- before we laod crush and it works.
turtle = require "TurtleSim"
package.path = package.path..";../../apis/turtle/?.lua"
local crush = require "crush"

--TODO: Make this a function...

-- Now 
--checkFuel()
--ccts("llrl")

--digAll("")
--print("")

--digAllUp("")
--print("")

--[[
digColumn(false, false)
print("")

digColumn(true, false)
print("")

digColumn(false, true)
print("")

digColumn(true, true)
print("")
]]

--digRow(5, true, true, function(x) print("") end)
--print("")

--print(fnOverRow(4, function(x) print("Yo") end, 5))
--print("")

--outAndBack(7,2,true, function(x) print("X"..x) end)
--outAndBack(7,-1,true, function(x) print("X"..x) end)
outAndBack(7,-1,false, function(x) print("X"..x) end)
clearOutAndBack(9,2)

function printTable(table)
  for k, v in pairs(table) do
    print("k:", k, "v:", v)
  end
end

function testArgs(...)
  local argTable = { l=60, w=4, t=10, n=1, r=false }
  printTable(argTable)

  print("---")
  --overlayArgs(":l:w:t:n:r", argTable, ...)
  overlayArgs(":l:w:t:n:r", argTable, "-l", "40")
  printTable(argTable)
end
testArgs(...)

print()
