local turtle = require "TurtleSim"

--[[

-- Not Implemented
-- TODO:  Forward should dig (repeatedly) if something there.
-- @ precedes a number (for quantity) followed by the operation.  e.g. @60f - move forward 60 spaces.
-- () - Group construct - Should work with #.  So @60(fx) - Digs a tunnel 60 long
-- Nested grous  @3(@4(^1))
-- def foo ‘<content>’ - Defines a subroutine
-- $foo = executes subroutine foo
-- Add subroutines
-- # is for comments

]]

function ccLoadFile(path)
  local fh = fs.open(path, 'r')
  local content = fh.readAll()
  fh.close()
  return content
end

function loadFile(path)
  local fh = io.open(path, "r")
  local content = fh:read("*all")
  fh:close()
  return content
end

-- The vocabulary primitives
function selectAndPlace(invId)
  turtle.select(invId)
  turtle.placeDown()
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function refuel()
  if turtle.getFuelLevel() < 6 then
    turtle.select(16)
    turtle.refuel(1)
  end
end

function showHelp()
  print ("run_ccts <commands_file>")
  os.exit()
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function goForward(idx)
  --if turtle.detect() then
  --  turtle.dig()
  --end
  turtle.forward()
  return idx
end

function digAll(idx)
  while turtle.detect() do
    turtle.dig()
  end
  return idx;
end

function digAllUp(idx)
  while turtle.detectUp() do
    turtle.digUp()
  end
  return idx;
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function repeatIt(idx)
  -- Format:  @[0-9]*\[cmds\]
  
  -- Look for square bracked
  local bracket = idx + 1
  while fileContent:sub(bracket, bracket) ~= '[' do
    bracket = bracket + 1
  end
  
  -- Numeric/count portion
  local count = tonumber(fileContent:sub(idx + 1, bracket - 1))

  while count > 0 do
    newIdx = bracket + 1
    local cmd = fileContent:sub(newIdx, newIdx)
    while cmd ~= ']' do
      newIdx = dispatch(cmd, newIdx)
      newIdx = newIdx + 1
      cmd = fileContent:sub(newIdx, newIdx)
    end
    count = count - 1
  end

  -- This should be ending bracket
  local tmp = fileContent:sub(newIdx, newIdx)
  if tmp ~= ']' then
    print("RepeatIt is not returning on ']', instead: "..tmp)
  end

  return newIdx
end


function placeFront(idx)
  idx = idx + 1
  local c = tonumber(fileContent:sub(idx, idx))
  turtle.select(c)
  turtle.place()
  return idx
end


function placeUp(idx)
  idx = idx + 1
  local c = tonumber(fileContent:sub(idx, idx))
  turtle.select(c)
  turtle.placeUp()
  return idx
end


function ignoreComments(idx)
  while fileContent:sub(idx, idx) ~= "\n" do
    idx = idx + 1
  end
  return idx
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- TOOD:  Since we have IDX, do we really need sym?
function dispatch(sym, idx)
  func = funcs[sym]
  if func == nil then
    print("Failed to find function for: '" ..sym.."'")
  else
    idx = func(idx);
  end
  return idx
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
  --fileContent = ccLoadFile(fileName)
  fileContent = loadFile(fileName)

  -- Construct jumptable
  funcs = {}
  funcs['f'] = function(idx) goForward() return idx end
  funcs['b'] = function(idx) turtle.back() return idx end
  funcs['l'] = function(idx) turtle.turnLeft() return idx end
  funcs['r'] = function(idx) turtle.turnRight() return idx end
  funcs['u'] = function(idx) turtle.up() return idx end
  funcs['d'] = function(idx) turtle.down() return idx end

  funcs['*'] = function(idx) digAll() return idx end
  funcs['/'] = function(idx) digAllUp() return idx end
  funcs['\\'] = function(idx) turtle.digDown() return idx end

  funcs['1'] = function(idx) selectAndPlace(1) return idx end
  funcs['2'] = function(idx) selectAndPlace(2) return idx end
  funcs['3'] = function(idx) selectAndPlace(3) return idx end
  funcs['4'] = function(idx) selectAndPlace(4) return idx end
  funcs['5'] = function(idx) selectAndPlace(5) return idx end
  funcs['6'] = function(idx) selectAndPlace(6) return idx end
  funcs['7'] = function(idx) selectAndPlace(7) return idx end
  funcs['8'] = function(idx) selectAndPlace(8) return idx end
  funcs['9'] = function(idx) selectAndPlace(9) return idx end
  funcs['0'] = function(idx) selectAndPlace(10) return idx end

  funcs['\n'] = function(idx) return idx end
  funcs['.']  = function(idx) return idx end
  funcs['']   = function(idx) return idx end
  funcs['\r'] = function(idx) return idx end
  funcs[' '] = function(idx) return idx end

  funcs['@'] = repeatIt
  funcs['~'] = placeFront
  funcs['^'] = placeUp
  funcs['#'] = ignoreComments

  -- Execute the file one command at a time
  local idx = 0
  while idx <= #fileContent do
    refuel()
    local c = fileContent:sub(idx,idx)
    idx = dispatch(c, idx)
    idx = idx + 1;
  end

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













