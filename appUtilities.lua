--global app settings

-- load Temporary Data
local composer = require ( "composer" )
local td = require ( "tempData" )

local T = {}

--alignment variables
T.goBack = function (event)
  print ("touch detected")
	 if event.phase == "began" then
		        display.getCurrentStage():setFocus( self )
		        event.target.isFocus = true
			elseif event.target.isFocus then
				if ( event.phase == "moved" ) then
			        local dX = event.x - event.xStart
              print ("dX = ", dx)
              -- Check if user is already at the home screen.
              if ( td.currentScreen ~= "home" ) then
                if ( dX > 200 ) then -- User swiped right
                    composer.gotoScene( td.previousScreen )
                end
              else
                print("already home")
                -- At Home screen. No further screens to go back to.
              end

			    elseif event.phase == "ended" or event.phase == "cancelled" then
		            display.getCurrentStage():setFocus( nil )
		            event.target.isFocus = false
			    end

		    end
		    return true
end

T.invisibleLayer = function ()
      T.swipe = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
      T.swipe.x = display.contentCenterX
      T.swipe.y = display.contentCenterY
      T.swipe.isHitTestable = true
      T.swipe:setFillColor( 1 )
      T.swipe.alpha = 0

      return T.swipe
end





return T
