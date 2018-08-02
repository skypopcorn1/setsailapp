-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
---------------------------------------------------------------------------------------
-- Import composer library and newScene
local composer = require ( "composer" )
local scene = composer.newScene()

-- Import additional libraries
local api = require ( "api" )
local json = require ( "json" )
local s = require ( "appSettings" )
local td = require ( "tempData" )
local util = require ( "appUtilities" )
local widget = require( "widget" )

-- Forward reference for variables
local bg
local itemSelected
local title
local subTitle
local tableView
local tableViewColors

-- Handle row rendering
local function onRowRender( event )
  local phase = event.phase
  local row = event.row
  local index = row.index
  local params = row.params

  local contentCentre = row.contentHeight/2

  if ( params ) then
    row.yachtClub = display.newText( params.name, 0, 0, questionTextWidth, 0, native.systemFontBold, s.h3 )
    row.yachtClub.size = s.h2
    row.yachtClub.x = s.bufferM
    row.yachtClub.anchorX = 0
    row.yachtClub.y = s.bufferM
    row.yachtClub:setFillColor( unpack(s.grey3) )
    row:insert ( row.yachtClub )

    row.yachtClubPhone = display.newText( params.phone, 0, 0, questionTextWidth, 0, native.systemFontBold, s.p )
    row.yachtClubPhone.size = s.h4
    row.yachtClubPhone.x = s.bufferM
    row.yachtClubPhone.anchorX = 0
    row.yachtClubPhone.y = row.yachtClub.y + row.yachtClub.height + s.bufferS
    row.yachtClubPhone:setFillColor( unpack(s.grey3) )
    row:insert ( row.yachtClubPhone )

    row.yachtClubAddress = display.newText( params.address, 0, 0, questionTextWidth, 0, native.systemFontBold, s.p )
    row.yachtClubAddress.size = s.p
    row.yachtClubAddress.x = s.bufferM
    row.yachtClubAddress.anchorX = 0
    row.yachtClubAddress.y = row.yachtClubPhone.y + row.yachtClubPhone.height + s.bufferS
    row.yachtClubAddress:setFillColor( unpack(s.grey3) )
    row:insert ( row.yachtClubAddress )

    --row.rowHeight = row.yachtClubPhone.y + row.yachtClubPhone.height + s.bufferM
  end

end

-- Handle row updates
local function onRowUpdate( event )
  local phase = event.phase
  local row = event.row
  --print( row.index, ": is now onscreen" )
end

-- Handle touches on the row
local function onRowTouch( event )
  local phase = event.phase
  local row = event.target
  if ( "release" == phase ) then
    itemSelected.text = row.params.name
    transition.to( tableView, { x=((display.contentWidth/2)*-1), time=600, transition=easing.outQuint } )
    transition.to( itemSelected, { x=display.contentCenterX, time=600, transition=easing.outQuint } )
    transition.to( backButton, { x=display.contentCenterX, time=750, transition=easing.outQuint } )
  end
end


-- Call to API to retrieve YachtClubs
local function getYachtClubs ( event )
  if ( not event.error ) then
		myData = json.decode(event.response)
		 ---------------DATA FOR BUILDING THE POST FEED------------------------------
		for i=1, #myData do
              print (myData[i].name)
              print (myData[i].address)
              print (myData[i].phone)
              print (myData[i].website)
      local isCategory = false
  		local rowHeight = 160
  		local rowColor = {
  			default = tableViewColors.rowColor.default,
  			over = tableViewColors.rowColor.over,
  		}
  		-- Insert the row into the tableView
  		tableView:insertRow
  		{
  			isCategory = isCategory,
  			rowHeight = rowHeight,
  			rowColor = rowColor,
  			lineColor = tableViewColors.lineColor,
  			params = {
                    name = myData[i].name,
                    address = myData[i].address,
                    phone = myData[i].phone,
                    website = myData[i].website,
                    defaultLabelColor=tableViewColors.defaultLabelColor,
                    catLabelColor=tableViewColors.catLabelColor
                  }
  		}
    end
  end
end


-- "scene:create()"
function scene:create( event )

  local group = self.view

	bg = display.newRect(0,0,0,0)
	bg.x, bg.y = s.centerX, s.centerY
	bg.width, bg.height = s.fullWidth, s.fullHeight
	bg:setFillColor(1)
	group:insert( bg )

	title = display.newText( "Set Sail", 0,0, s.defaultFontThin, s.h1 )
	title.x, title.y = s.centerX, s.centerY/8
	title:setFillColor ( { s.grey3[1], s.grey3[2], s.grey3[3],1} )
	group:insert( title )

  subTitle = display.newText( "Find your club.", 0,0, s.defaultFontThin, s.h2 )
  subTitle.x, subTitle.y = s.centerX, title.y + title.height + s.bufferM
  subTitle:setFillColor ( { s.grey3[1], s.grey3[2], s.grey3[3],1} )
  group:insert( subTitle )

end

-- "scene:show()"
function scene:show( event )

	--composer.removeHidden( true )

   local group = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      local back = util.invisibleLayer()
      back:addEventListener("touch", util.goBack)
      group:insert(back)

      -- Add the scroll view of YachtClubs
      tableViewColors = {
          rowColor = {
                        default = { 250/255 },
                        over = { 240/255 }
                      },
          lineColor = { 215/255 },
          catColor = {
                        default = { 220/255, 220/255, 220/255, 0.9 },
                        over = { 220/255, 220/255, 220/255, 0.9 }
                      },
          defaultLabelColor = { 0, 0, 0, 0.6 },
          catLabelColor = { 0 },
      }

    	-- Text to show which item we selected
    	itemSelected = display.newText( "--", 0, 0, native.systemFont, 16 )
    	itemSelected:setFillColor( unpack(tableViewColors.catLabelColor) )
    	itemSelected.x = display.contentWidth+itemSelected.contentWidth
    	itemSelected.y = display.contentCenterY
    	group:insert( itemSelected )

    	-- Function to return to the tableView
    	local function goBack( event )
    		transition.to( tableView, { x=display.contentWidth*0.5, time=600, transition=easing.outQuint } )
    		transition.to( itemSelected, { x=display.contentWidth+itemSelected.contentWidth, time=600, transition=easing.outQuint } )
    		transition.to( event.target, { x=display.contentWidth+event.target.contentWidth, time=480, transition=easing.outQuint } )
    	end

    	-- Back button
    	local backButton = widget.newButton {
    		width = 128,
    		height = 32,
    		label = "back",
    		onRelease = goBack
    	}
    	backButton.x = display.contentWidth+backButton.contentWidth
    	backButton.y = itemSelected.y+itemSelected.contentHeight+16
    	group:insert( backButton )

    	-- Listen for tableView events
    	local function tableViewListener( event )
    		local phase = event.phase
    		--print( "Event.phase is:", event.phase )
    	end

    	-- Create a tableView
    	tableView = widget.newTableView
    	{
    		top = subTitle.y + subTitle.height + s.bufferM,
    		left = s.bufferM,
    		width = display.contentWidth - s.bufferXL,
    		height = display.contentHeight - s.q1Y,
    		hideBackground = true,
    		listener = tableViewListener,
    		onRowRender = onRowRender,
    		onRowUpdate = onRowUpdate,
    		onRowTouch = onRowTouch,
    	}
    	group:insert( tableView )

      local data = {}
      data.requestType = "GET"
      data.view = "YachtClubs"

      api:run(data, getYachtClubs)

      td.previousScreen = td.currentScreen
      td.currentScreen = "clubs"
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
