-- Require libraries
local composer = require ( "composer" )
local json = require ( "json" )
local util = require ( "appUtilities" )

-- Forward reference to variables
local firstTime

local function checkLoginStatus ()
  local data = nil
  local path = system.pathForFile( "tokenDirectory.json", system.DocumentsDirectory  )
  local fileHandle = io.open( path, "r" )
  if fileHandle then
      data = json.decode( fileHandle:read( "*a" ) or "" )
      io.close( fileHandle )
  end
  print('data', data )
  if data then
    return false
  else
    return true
  end

end

firstTime = checkLoginStatus()

--
-- Check if the user has previously logged in.
--
if firstTime then
  composer.gotoScene( "login" )
else
  composer.gotoScene( "home" )
end
