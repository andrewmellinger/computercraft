-- when in CC
-- os.loadAPI("crush")
-- crush.checkFuel()

REFUEL_LEVEL = 15
REFULE_SLOT = 1

function checkFuel()
  if turtle.getFuelLevel() < REFUEL_LEVEL then
    turtle.select(REFUEL_SLOT)
    turtle.refuel(1)
  end
end

function digAll()
  while turtle.detect() do
    turtle.dig()
  end
end


-- Extract the entire forward column and move
-- into that column
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
-- in each cell if not nil
function digRow(length, up, down, fn)
  for i = 1,length do
    digColumn(up, down)
    if fn ~= nil then
      fn(i)
    end
  end
end


function fnOverRow(length, fn, counter)
  checkFuel()
  for i = 1,length do
    fn(counter)
    turtle.forward()
    counter = counter + 1
  end
  return counter
end

function turn(right)
  if right then
    turtle.turnRight()
  else
    turtle.turnLeft()
  end
end

-- Go out this many, turn right or left, go over (w+1), come back
-- Execute the fn BEFORE moving forward
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

-- Usually used for placing torches
function placeDownWithInterval(idx, interval, slot)
  if idx % interval == 0 then
    turtle.select(torchSlot)
    turtle.placeDown()
  end
end



-- ================================================

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

function stripSwitches(arg)
  local tab = {}
  for k,v in ipairs(arg) do
    if string.sub(v, 1,1) ~= "-" then
      table.insert(tab, v)
    end
  end
  return tab
end



