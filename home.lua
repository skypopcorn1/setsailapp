-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
---------------------------------------------------------------------------------------
-- Import composer library and newScene
local composer = require ( "composer" )
local scene = composer.newScene()

-- Import additional libraries
local s = require ( "appSettings" )
local td = require ( "tempData" )
local util = require ( "appUtilities" )

-- "scene:create()"
function scene:create( event )

  local group = self.view

  local grd = {
      type = "gradient",
			color1 = { 1,1,1,1},
			color2 = { s.blue[1], s.blue[2], s.blue[3],1},
      direction = "down"
  }

  local back = util.invisibleLayer()
  back:addEventListener("touch", util.goBack)
  group:insert(back)

	local bg = display.newRect(0,0,0,0)
	bg.x, bg.y = s.centerX, s.centerY
	bg.width, bg.height = s.fullWidth, s.fullHeight
	bg:setFillColor(1)
	group:insert( bg )

	local title = display.newText( "Set Sail", 0,0, s.defaultFontThin, s.h1 )
	title.x, title.y = s.centerX, s.centerY/4
	title:setFillColor ( { s.grey3[1], s.grey3[2], s.grey3[3],1} )
	group:insert( title )

	local logo = display.newImage( "img/set_sail_logo_main.png")
	logo:translate(s.centerX, s.q1Y)
	logo:scale(.5,.5)
	group:insert( logo )

	--check my current location
	local btn1 = display.newRoundedRect(0,0,0,0,12)
	btn1.x, btn1.y = s.centerX, s.centerY
	btn1.width, btn1.height = s.halfScreenW, s.bufferXL
	btn1.cornerRadius = btn1.height * 0.5
	btn1:setFillColor(1,0,0)
	group:insert( btn1 )

	local btn1txt = display.newText( "Check my location", 0,0, s.defaultFont,s.p )
	btn1txt.x, btn1txt.y = s.centerX, btn1.y
	btn1txt:setFillColor(1)
	group:insert( btn1txt )

	local function gpsPage () composer.gotoScene( "gps" ) return true end
	btn1:addEventListener( "touch", gpsPage )

	-- local xy = display.newRoundedRect(0,0,0,0,12)
	-- xy.x, xy.y = s.centerX, s.centerY
	-- xy.width, xy.height = s.halfScreenW, s.bufferXL
	-- xy:setFillColor(1,1,0)
	--
	-- group:insert(xy)

	-- Find upcoming races
	local btn2 = display.newRoundedRect(0,0,0,0,12)
	btn2.x, btn2.y = s.centerX, btn1.y + btn1.height + s.bufferM
	btn2.width, btn2.height = s.halfScreenW, s.bufferXL
	btn2.cornerRadius = btn2.height * 0.5
	btn2:setFillColor(s.grey2[1], s.grey2[2], s.grey2[3])
	group:insert( btn2 )

	local btn2txt = display.newText( "Find my Yacht Club", 0,0, s.defaultFont,s.p )
	btn2txt.x, btn2txt.y = s.centerX, btn2.y
	btn2txt:setFillColor(1)
	group:insert( btn2txt )


	local function yachtClubs () composer.gotoScene( "clubs" ) end
	btn2:addEventListener( "touch", yachtClubs )

end

-- "scene:show()"
function scene:show( event )

	--composer.removeHidden( true )

   local group = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).


      td.currentScreen = "home"
    	td.previousScreen = "home"
		--group:insert ( logonButtonText )

		-- local xy = display.newCircle(5,5,5,5)
		-- xy.x = logonButtonText.x
		-- xy.y = logonButtonText.y
		-- xy:setFillColor(1,0,0)
		--
		-- group:insert(xy)

   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local group = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

	local group = self.view
   -- Called prior to the removal of scene's view ("group").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
