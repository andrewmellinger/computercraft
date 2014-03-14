-- when in CC
-- os.loadAPI("crush")
-- crush.checkFuel()
-- In loadAPI it seems to come in as an object automatically.

REFUEL_LEVEL = 15
REFUEL_SLOT = 1

-- Used to reload fuel if needed
function checkFuel()
  if turtle.getFuelLevel() < REFUEL_LEVEL then
    turtle.select(REFUEL_SLOT)
    turtle.refuel(1)
  end
end

-- Digs forward until we don't detect anything.
-- Good for getting through sand/gravel.
function digAll()
  while turtle.detect() do
    turtle.dig()
  end
end

-- Digs forward until we don't detect anything.
-- Good for getting through sand/gravel.
function digAllUp()
  while turtle.detectUp() do
    turtle.digUp()
  end
end


-- Extract up to a 3 block column ahead.  One up, one forward
-- and one down.
function digColumn(up, down)
  digAll()
  turtle.forward()

  if up then
    digAllUp()
  end

  if down then
    turtle.digDown()
  end
end


-- Digs a full row (potentially up and down) executing fn
-- in each block if not nil.  The fn is good for placing torches.
-- The function is passed a monotonically incrementing counter
function digRow(length, up, down, fn)
  for i = 1,length do
    checkFuel()
    digColumn(up, down)
    if fn ~= nil then
      fn(i)
    end
  end
end


-- Moves the turtle forward and executes the fn in each block BEFORE as it moves.
-- Each way to make a digger or torch placements.
-- The function is passed a monotonically incrementing counter
function fnOverRow(length, fn, counter)
  for i = 1,length do
    checkFuel()
    fn(counter)
    turtle.forward()
    counter = counter + 1
  end
  return counter
end


-- Parameterized function to do turns.
function turn(right)
  if right then
    turtle.turnRight()
  else
    turtle.turnLeft()
  end
end


-- Go out this many, turn right or left, go over (w+1), come back
-- Note, the over is a number of blocks to move over.  If you 
-- want it to come back on the same one it went out, specify -1.
-- Execute the fn BEFORE moving forward.
-- The function is passed a monotonically incrementing counter
function outAndBack(length, width, right, fn)
  local counter = 1

  counter = fnOverRow(length, fn, counter)
  turn(right)
  counter = fnOverRow(width + 1, fn, counter)
  turn(right)
  counter = fnOverRow(length, fn, counter)
end

-- A functions that clears out and back.  
-- This is what pumpkins does
function clearOutAndBack(length, width)
  outAndBack(length, width, true, function (x) turtle.dig() end)
end

-- Functions used to place torches on some interval.  Often passed
-- in to the other movement loops.
function placeDownWithInterval(idx, interval, slot)
  if idx % interval == 0 then
    turtle.select(torchSlot)
    turtle.placeDown()
  end
end


-- ============================================================================
-- ============================================================================
--  ####  #### #####  #### 
-- #     #       #   #     
-- #     #       #    ###  
-- #     #       #       # 
--  ####  ####   #   #### 

-- TODO: Add entire ccts engine here


-- The vocabulary primitives
function selectAndPlace(invId)
  turtle.select(invId)
  turtle.placeDown()
end


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function goForward(idx)
  --if turtle.detect() then
  --  turtle.dig()
  --end
  turtle.forward()
  return idx
end


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function repeatIt(idx)
  -- Format:  @[0-9]*\[cmds\]
  
  -- Look for square bracked
  local bracket = idx + 1
  while ccts_context.cmds:sub(bracket, bracket) ~= '[' do
    bracket = bracket + 1
  end
  
  -- Numeric/count portion
  local count = tonumber(ccts_context.cmds:sub(idx + 1, bracket - 1))

  while count > 0 do
    newIdx = bracket + 1
    local cmd = ccts_context.cmds:sub(newIdx, newIdx)
    while cmd ~= ']' do
      newIdx = dispatch(cmd, newIdx)
      newIdx = newIdx + 1
      cmd = ccts_context.cmds:sub(newIdx, newIdx)
    end
    count = count - 1
  end

  -- This should be ending bracket
  local tmp = ccts_context.cmds:sub(newIdx, newIdx)
  if tmp ~= ']' then
    print("RepeatIt is not returning on ']', instead: "..tmp)
  end

  return newIdx
end


-- Specific to CCTS
local function placeFront(idx)
  idx = idx + 1
  local c = tonumber(ccts_context.cmds:sub(idx, idx))
  turtle.select(c)
  turtle.place()
  return idx
end


-- Specific to CCTS
local function placeUp(idx)
  idx = idx + 1
  local c = tonumber(ccts_context.cmds:sub(idx, idx))
  turtle.select(c)
  turtle.placeUp()
  return idx
end


-- Specific to CCTS
local function ignoreComments(idx)
  while ccts_context.cmds:sub(idx, idx) ~= "\n" do
    idx = idx + 1
  end
  return idx
end


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- Specific to CCTS
-- TOOD:  Since we have IDX, do we really need sym?
local function dispatch(idx)
  local sym = ccts_context.cmds:sub(idx,idx)
  func = ccts_context.funcs[sym]
  if func == nil then
    print("Failed to find function for: '" ..sym.."'")
  else
    idx = func(idx);
  end
  return idx
end


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Main loop context

ccts_context = {}

-- Executes a series of commands embedded in this file.
function ccts(cmds)

  -- Construct jumptable
  local funcs = {}
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

  ccts_context['funcs'] = funcs
  ccts_context['cmds'] = cmds

  -- Execute the file one command at a time
  local idx = 0
  while idx <= #cmds do
    checkFuel()
    idx = dispatch(idx)
    idx = idx + 1;
  end

end


-- ============================================================================
-- ============================================================================

-- getopt_alt.lua

-- getopt, POSIX style command line argument parser
-- param arg contains the command line arguments in a standard table.
-- param options is a string with the letters that expect string values.
-- returns a table where associated keys are true, nil, or a string value.
-- The following example styles are supported
--   -a one  ==> opts["a"]=="one"
--   -bone   ==> opts["b"]=="one"
--   -c      ==> opts["c"]==true
--   --c=one ==> opts["c"]=="one"
--   -cdaone ==> opts["c"]==true opts["d"]==true opts["a"]=="one"
-- note POSIX demands the parser ends at the first non option
--      this behavior isn't implemented.

function getopt( arg, options )
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end


-- getopt does NOT strip switches.  This function does that, sort of...
function stripSwitches(arg)
  local tab = {}
  for k,v in ipairs(arg) do
    if string.sub(v, 1,1) ~= "-" then
      table.insert(tab, v)
    end
  end
  return tab
end



