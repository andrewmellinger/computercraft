--turtle = require "TurtleSim"
--local crush = turtle.loadCrush()
os.loadAPI("crush")

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function showHelp()
  print ("ccts <commands_file>")
  os.exit()
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Main Area

function mainLoop(fileName)
  if fileName == "-h" then
    showHelp()
    return
  end

  -- Load the file
  print("Loading "..fileName)
  fileContent = crush.loadFile(fileName)

  crush.ccts(fileContent)
end

-- Main
local tArgs = {...}
if #tArgs < 1 then
  showHelp()
else
  local fileName = tArgs[1]
  mainLoop(fileName)
end

print("Done")













