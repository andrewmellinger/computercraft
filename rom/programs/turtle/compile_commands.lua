-- This file creates a 'command stream' from a schematic
-- file.  The command stream then can be modified/edited 
-- to add custom bits like torches, etc.  The command
-- file is then executed by puppet.

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

function showHelp()
  print ("3dprinter <schemtic_file>")
  os.exit()
end

-- Between rows ALWAYS alternate rfr, vs lfl  !
-- But, between foors I do a urr instead then continue

-- '-' cause change to lr2 and clockwise
-- '+' moves up and change to l2r but NOT clockwise and add "newRow"

function walkPlan(plan)

  -- To Prime, find floor and go to first row
  -- Afterwards we should be looking at the first row
  idx = seekToFirstRow(plan)
  print("u")

  -- The tow state variables
  l2r = true          -- Are we printING r2l, or l2r and need to reverse string
  clockwise = true    -- Should we rotate CW, or CCW?  We alternate every row except when floor changes
  newFloor = true     -- Did the floor change?

  local inComment = false
  while idx <= #plan do
    local c=plan:sub(idx, idx)
    -- Print row based on which way we are going
    if inComment and c == "\n" then
      inComment = false
    elseif inComment then
      -- Nothing to do 
    elseif c == "#" then
      inComment = true
    elseif c == "-" then
      newFloor, clockwise = doNewRow(newFloor, clockwise)
      endIdx = getRowEnd(plan, idx + 1)
      if (l2r) then
        printRow(plan, idx+1, endIdx)
      else 
        printRow(plan, endIdx, idx+1)
      end
      l2r = not l2r
      idx = endIdx - 1  -- -1 because we increment later
    elseif c == "+" then
      print("urr")
      newFloor = true
    elseif c == "\n" then
      -- No-op
    else
      print("# Couldn't parse '"..c.."' "..idx.."/"..#plan)
    end
    idx = idx + 1
  end
end

function doNewRow(newFloor, clockwise)
  if newFloor then
    return false, clockwise
  end
  
  if clockwise then
    print("rfr")
  else
    print("lfl")
  end

  return false, (not clockwise)
end

function seekToFirstRow(plan) 
  idx = 1
  while idx <= #plan do
    local c = plan:sub(idx,idx)
    if c == "+" then
      return idx+1 
    end
    idx = idx + 1
  end
  print("# Couldn't find floor marker!!!")
  return #plan
end

function getRowEnd(plan, idx)
  -- Find the row string
  local startPos = idx
  local endPos = startPos
  while idx <= #plan do
    local c = plan:sub(idx,idx)
    if c == "+" or c == "-" then
      endPos = idx - 1
      return idx - 1
    end    
    idx = idx +1 
  end
  -- If we got to the end then we are done
  return idx - 1 
end

function printRow(plan, startIdx, endIdx )
  inc = 1
  if endIdx < startIdx then
    inc = -1
  end

  for i=startIdx,endIdx,inc do
    local c = plan:sub(i,i)
    if c ~= "\n" then
      if c ~= "." then
        io.write(c)
      end
      io.write("f")
    end
  end
  print("")
end


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- TODO:  Can we just walk it backwards, so I don't need to do 
-- reversal?
function reverseString(str)
  local outStr = ''
  for i=#str,1,-1 do
    outStr = outStr..str:sub(i,i)
  end
  return outStr
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Main Area

-- Parse args
tArgs = {...}
if #tArgs < 1 then
  showHelp()
end

local fileName = tArgs[1]

if fileName == "-h" then
  showHelp()
end

-- Load the file
print("Loading "..fileName)
fileContent = loadFile(fileName)

-- Parse the content into a plan
walkPlan(fileContent)

print("Done");


