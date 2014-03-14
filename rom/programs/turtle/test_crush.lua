
-- Since these things are all global, we can load the TurtleSim
-- before we laod crush and it works.
turtle = require "TurtleSim"
package.path = package.path..";../../apis/turtle/?.lua"
local crush = require "crush"

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

print()
