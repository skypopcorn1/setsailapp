-- Import composer library and newScene
local composer = require ( "composer" )
local scene = composer.newScene()

-- Import additional libraries
local composer = require ( "composer" )
local s = require ( "appSettings" )
local td = require ( "tempData")
local util = require ( "appUtilities" )
local widget = require( "widget" )

-- Pre-declare variables
local latitude
local longitude
local accuracy
local time
local speed
local direction
local map
local attempts = 0

-- Location function to find user's current location
local locationHandler = function( event )

	local currentLocation = map:getUserLocation()

	if ( currentLocation.errorCode or ( currentLocation.latitude == 0 and currentLocation.longitude == 0 ) ) then

			attempts = attempts + 1

			if ( attempts > 10 ) then
			    native.showAlert( "No GPS Signal", "Can't sync with GPS.", { "Okay" } )
			else
			    timer.performWithDelay( 1000, locationHandler )
			end
	 else
				latitude.text =  currentLocation.latitude
				longitude.text = currentLocation.longitude

				-- Map marker listener function
				local function markerListener(event)
				    print( "type: ", event.type )  -- event type
				    print( "markerId: ", event.markerId )  -- ID of the marker that was touched
				    print( "lat: ", event.latitude )  -- latitude of the marker
				    print( "long: ", event.longitude )  -- longitude of the marker
				end

				local options =
						{
								title = "Sea Vixen",
								subtitle = "Currently first in division",
								listener = markerListener,
								-- This will look in the resources directory for the image file
								imageFile =  "img/setsail_marker.png",
								-- Alternatively, this looks in the specified directory for the image file
								-- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
						}

			  map:setCenter( currentLocation.latitude, currentLocation.longitude )
			  map:addMarker( currentLocation.latitude, currentLocation.longitude )
	 end

	-- Check for error (user may have turned off Location Services)
	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
		print( "Location error: " .. tostring( event.errorMessage ) )
	else


		latitude.text = string.format( "%.4f", event.latitude )
		longitude.text = string.format( "%.4f", event.longitude )

		local accuracyText = string.format( '%.3f', event.accuracy )
		accuracy.text = accuracyText

		local speedText = string.format( '%.3f', event.speed )
		speed.text = speedText

		local directionText = string.format( '%.3f', event.direction )
		direction.text = directionText

	end
end


-- "scene:create()"
function scene:create( event )

  local group = self.view

	local currentLatitude = 0
	local currentLongitude = 0

	local back = util.invisibleLayer()
  back:addEventListener("touch", util.goBack)
  group:insert(back)

	local bg = display.newRect(0,0,0,0)
	bg.x, bg.y = display.viewableContentWidth/2, display.viewableContentHeight/2
	bg.width, bg.height = display.viewableContentWidth, display.viewableContentHeight
	bg:setFillColor(1)

	group:insert( bg )

end

-- "scene:show()"
function scene:show( event )

	--composer.removeHidden( true )

   local group = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
			latTitle = display.newText( "Latitude:", 0, 0, s.defaultFont, 26 )
			latTitle.anchorX = 0
			latTitle.x, latTitle.y = s.bufferL, 64
			latTitle:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			latitude = display.newText( "--", 0, 0, s.defaultFont, 26 )
			latitude.anchorX = 0
			latitude.x, latitude.y = s.centerX, latTitle.y
			latitude:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			lonTitle = display.newText( "Longitude:", 0, 0, s.defaultFont, 26 )
			lonTitle.anchorX = 0
			lonTitle.x, lonTitle.y = s.bufferL, latitude.y + s.bufferL
			lonTitle:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			longitude = display.newText( "--", 0, 0, s.defaultFont, 26 )
			longitude.anchorX = 0
			longitude.x, longitude.y = s.centerX, lonTitle.y
			longitude:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			accuTitle = display.newText( "Accuracy:", 0, 0, s.defaultFont, 26 )
			accuTitle.anchorX = 0
			accuTitle.x, accuTitle.y = s.bufferL, longitude.y + s.bufferL
			accuTitle:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			accuracy = display.newText( "--", 0, 0, s.defaultFont, 26 )
			accuracy.anchorX = 0
			accuracy.x, accuracy.y = s.centerX, accuTitle.y
			accuracy:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			spdTitle = display.newText( "Speed:", 0, 0, s.defaultFont, 26 )
			spdTitle.anchorX = 0
			spdTitle.x, spdTitle.y = s.bufferL, accuracy.y + s.bufferL
			spdTitle:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			speed = display.newText( "--", 0, 0, s.defaultFont, 26 )
			speed.anchorX = 0
			speed.x, speed.y = s.centerX, spdTitle.y
			speed:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			directionTitle = display.newText( "Direction:", 0, 0, s.defaultFont, 26 )
			directionTitle.anchorX = 0
			directionTitle.x, directionTitle.y = s.bufferL, speed.y + s.bufferL
			directionTitle:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			direction = display.newText( "--", 0, 0, s.defaultFont, 26 )
			direction.anchorX = 0
			direction.x, direction.y = s.centerX, directionTitle.y
			direction:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			timeTitle = display.newText( "Time:", 0, 0, s.defaultFont, 26 )
			timeTitle.anchorX = 0
			timeTitle.x, timeTitle.y = s.bufferL, direction.y + s.bufferL
			timeTitle:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			time = display.newText( os.date("%A %l:%M%p"), 0, 0, s.defaultFont, 26 )
			time.anchorX = 0
			time.x, time.y = s.centerX, timeTitle.y
			time:setFillColor( s.grey3[1], s.grey3[2], s.grey3[3] )

			-- Create a native map view
			local mapHeight = s.fullHeight - ( time.y + time.height + s.bufferM*2 )
			map = native.newMapView( 0, 0, s.fullWidth - s.bufferXL, mapHeight )
			map.x = display.contentCenterX
			map.y = time.y + time.height + s.bufferM
			map.anchorY = 0.0

			-- Display map as vector drawings of streets (other options are "satellite" and "hybrid")
			map.mapType = "satellite"

			-- Initialize map to a real location
			map:setCenter( -33.857804, 151.210790 )

			group:insert( latTitle )
			group:insert( latitude )
			group:insert( lonTitle )
			group:insert( longitude )
			group:insert( accuracy )
			group:insert( accuTitle )
			group:insert( speed )
			group:insert( spdTitle )
			group:insert( direction )
			group:insert( directionTitle )
			group:insert( time )
			group:insert( timeTitle )
			group:insert( map )

			--
			-- Check if this platform supports location events
			--
			if not system.hasEventSource( "location" ) then
				msg = display.newText( "Location events not supported on this platform", 0, 230, s.defaultFont, 13 )
				msg.x = display.contentWidth/2		-- center title
				msg:setFillColor( 1,1,1 )
			end

			-- Activate location listener
			Runtime:addEventListener( "location", locationHandler )

			td.previousScreen = td.currentScreen
			td.currentScreen = "gps"

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
			latTitle:removeSelf()
	 	 	latTitle = nil

			latitude:removeSelf()
			latitude = nil

			lonTitle:removeSelf()
			lonTitle = nil

			longitude:removeSelf()
			longitude = nil

			accuracy:removeSelf()
			accuracy = nil

			accuTitle:removeSelf()
			accuTitle = nil

			speed:removeSelf()
			speed = nil

			spdTitle:removeSelf()
			spdTitle = nil

			direction:removeSelf()
			direction = nil

			directionTitle:removeSelf()
			directionTitle = nil

			time:removeSelf()
			time = nil

			map:removeSelf()
			map = nil
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

	local group = self.view
   -- Called prior to the removal of scene's view ("group").
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
