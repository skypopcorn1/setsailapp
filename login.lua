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

-- Forward reference to variables
local loginGroup
local logoScale = s.s1
local mainGroup
local signUpGroup

-- "scene:create()"
function scene:create( event )

  local group = self.view

  local grd = {
      type = "gradient",
      color1 = { 1,1,1,1},
      color2 = { unpack(s.grey1),1},
      direction = 135
  }

  local back = util.invisibleLayer()
  back:addEventListener("touch", util.goBack)
  group:insert(back)

	local bg = display.newRect(0,0,0,0)
	bg.x, bg.y = s.centerX, s.centerY
	bg.width, bg.height = s.fullWidth, s.fullHeight
	bg:setFillColor(grd)
	group:insert( bg )

end

-- "scene:show()"
function scene:show( event )

	--composer.removeHidden( true )

   local group = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).

      -- Add a container to house everything pre-login.
      mainGroup = display.newGroup()
        mainGroup.isVisible = true
      loginGroup = display.newGroup()
        loginGroup.isVisible = false
      signUpGroup = display.newGroup()
        signUpGroup.isVisible = false

      local function updateView (event)
        print ("updateView")

        if ( mainGroup.isVisible and event.target.id == "login" ) then
          mainGroup.isVisible = false
          loginGroup.isVisible = true
        elseif ( mainGroup.isVisible and event.target.id == "firstTime" ) then
          mainGroup.isVisible = false
          signUpGroup.isVisible = true
        elseif loginGroup.isVisible then
          loginGroup.isVisible = false
          mainGroup.isVisible = true
        elseif signUpGroup.isVisible then
          signUpGroup.isVisible = false
          mainGroup.isVisible = true
        end

        return true
      end

      local logo = display.newImage( "img/set_sail_logo_main.png")
    	logo:translate(s.centerX, s.centerY/4)
    	logo:scale(logoScale,logoScale)
    	mainGroup:insert( logo )

    	local title = display.newText(mainGroup, "Welcome to Set Sail!", 0,0, s.defaultFontThin, s.h1 )
    	title.x, title.y = s.centerX, logo.y + logo.height*logoScale + s.bufferL
    	title:setFillColor ( { s.grey3[1], s.grey3[2], s.grey3[3],1} )

      local subTitle = display.newText(mainGroup, "Let's get sailing.", 0,0, s.defaultFontThin, s.h3 )
      subTitle.x, subTitle.y = s.centerX, title.y + title.height + s.bufferM
      subTitle:setFillColor ( { s.grey3[1], s.grey3[2], s.grey3[3],1} )

      local btn1 = display.newRoundedRect(mainGroup,0,0,0,0,12)
    	btn1.x, btn1.y = s.centerX, subTitle.y + subTitle.height + s.bufferXXL
    	btn1.width, btn1.height = s.buttonMW, s.buttonMH
    	btn1.cornerRadius = btn1.height * 0.25
      btn1.strokeWidth = 2
      btn1.stroke = { type="gradient", color1={ 0.5, 0.5 , 0.5 }, color2={ 0.9, 0.9, 0.9 } }
    	btn1:setFillColor(1,1,1,.5)
      btn1.isHitTestable = true
      btn1.id = "firstTime"

    	local btn1txt = display.newText(mainGroup, "First Time?", 0,0, s.defaultFont,s.h4 )
    	btn1txt.x, btn1txt.y = s.centerX, btn1.y
    	btn1txt:setFillColor(unpack(s.grey2))

    	btn1:addEventListener( "touch", updateView )

      local btn2 = display.newRoundedRect(mainGroup,0,0,0,0,12)
    	btn2.x, btn2.y = s.centerX, btn1.y + btn1.height + s.bufferXL
    	btn2.width, btn2.height = s.buttonMW, s.buttonMH
    	btn2.cornerRadius = btn2.height * 0.25
      btn2.strokeWidth = 2
      btn2.stroke = { type="gradient", color1={ 0.5, 0.5 , 0.5 }, color2={ 0.9, 0.9, 0.9 }}
    	btn2:setFillColor(1,1,1,.5)
      btn2.isHitTestable = true
      btn2.id = "login"

    	local btn2txt = display.newText(mainGroup, "Login", 0,0, s.defaultFont,s.h4 )
    	btn2txt.x, btn2txt.y = s.centerX, btn2.y
    	btn2txt:setFillColor(unpack(s.grey2))

    	btn2:addEventListener( "touch", updateView )

      --
      -- Forward declare the native.textFields
      --
      local inputEmail
      local inputPassword
      local inputConfirmPassword

      --
      -- Handle login and registration inputs
      --
      local function textListener( event )
        print ("textListener called")
        if ( event.phase == "began" ) then
            -- User begins editing "defaultField"

        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- Output resulting text from "defaultField"
            print( event.target.id )
            print( event.target.text )

            if ( event.target.id == "email" ) then
              native.setKeyboardFocus( inputPassword )
            elseif ( event.target.id == "inputPassword" ) then
              native.setKeyboardFocus( inputConfirmPassword )
            elseif ( event.target.id == "inputConfirmPassword" ) then
              native.setKeyboardFocus( nil )
            end

        elseif ( event.phase == "editing" ) then
            print( event.newCharacters )
            print( event.oldText )
            print( event.startPosition )
            print( event.text )
        end
      end

      --
      -- Register view
      --
      local labelEmail = display.newText(signUpGroup, "Email:", 0,0, s.defaultFont,s.h4 )
      labelEmail.x, labelEmail.y = s.bufferM, s.q1Y
      labelEmail.anchorX = 0
      labelEmail:setFillColor(unpack(s.grey2))

      inputEmail = native.newTextField(10,10,10,10)
      inputEmail.x = labelEmail.x
      inputEmail.y =  labelEmail.y + labelEmail.height + s.bufferM
      inputEmail.size = s.p1
      inputEmail.width = s.fullWidth - ( s.bufferM * 2 )
      inputEmail.height = inputEmail.size + s.bufferS
      inputEmail.anchorX = 0
      inputEmail.inputType = "email"
      inputEmail.id = "email"
      signUpGroup:insert(inputEmail)

      inputEmail:addEventListener("userInput", textListener)

      local labelPassword = display.newText(signUpGroup, "Password:", 0,0, s.defaultFont,s.h4 )
      labelPassword.x, labelPassword.y = s.bufferM, inputEmail.y + inputEmail.height + s.bufferM
      labelPassword.anchorX = 0
      labelPassword:setFillColor(unpack(s.grey2))

      local inputPassword = native.newTextField(10,10,10,10)
      inputPassword.x = labelPassword.x
      inputPassword.y =  labelPassword.y + labelPassword.height + s.bufferM
      inputPassword.size = s.p1
      inputPassword.width = s.fullWidth - ( s.bufferM * 2 )
      inputPassword.height = inputPassword.size + s.bufferS
      inputPassword.anchorX = 0
      inputPassword.isSecure = true
      inputPassword.id = "inputPassword"
      signUpGroup:insert(inputPassword)

      inputPassword:addEventListener("userInput", textListener)

      local labelConfirmPassword = display.newText(signUpGroup, "Confirm password:", 0,0, s.defaultFont,s.h4 )
      labelConfirmPassword.x = s.bufferM
      labelConfirmPassword.y = inputPassword.y + inputPassword.height + s.bufferM
      labelConfirmPassword.anchorX = 0
      labelConfirmPassword:setFillColor(unpack(s.grey2))

      local inputConfirmPassword = native.newTextField(10,10,10,10)
      inputConfirmPassword.x = labelConfirmPassword.x
      inputConfirmPassword.y =  labelConfirmPassword.y + labelConfirmPassword.height + s.bufferM
      inputConfirmPassword.size = s.p1
      inputConfirmPassword.width = s.fullWidth - ( s.bufferM * 2 )
      inputConfirmPassword.height = inputConfirmPassword.size + s.bufferS
      inputConfirmPassword.anchorX = 0
      inputConfirmPassword.isSecure = true
      inputConfirmPassword.id = "inputConfirmPassword"
      signUpGroup:insert(inputConfirmPassword)

      inputConfirmPassword:addEventListener("userInput", textListener)

      local registerBtn = display.newRoundedRect(signUpGroup,0,0,0,0,12)
    	registerBtn.width, registerBtn.height = s.buttonMW, s.buttonMH
      registerBtn.x = s.fullWidth - (registerBtn.width + s.bufferM)
      registerBtn.y = inputConfirmPassword.y + inputConfirmPassword.height + s.bufferL
      registerBtn.anchorX = 0
    	registerBtn.cornerRadius = registerBtn.height * 0.25
      registerBtn.strokeWidth = 2
      registerBtn.stroke = { type="gradient", color1={ 0.5, 0.5 , 0.5 }, color2={ 0.9, 0.9, 0.9 } }
    	registerBtn:setFillColor(1,1,1,.5)
      registerBtn.isHitTestable = true
      registerBtn.id = "register"

    	local registerBtnTxt = display.newText(signUpGroup, "Login", 0,0, s.defaultFont,s.h4 )
    	registerBtnTxt.x = registerBtn.x + ( registerBtn.width / 2 )
      registerBtnTxt.y = registerBtn.y
    	registerBtnTxt:setFillColor(unpack(s.grey2))

      local function tempHandleRegister (event)
        print("tempHandleRegister")
        composer.removeScene("login")
        composer.gotoScene("home")
        return true
      end
    	registerBtn:addEventListener( "touch", tempHandleRegister )

      --
      -- Register view
      --
      local labelEmail2 = display.newText(loginGroup, "Email:", 0,0, s.defaultFont,s.h4 )
      labelEmail2.x, labelEmail2.y = s.bufferM, s.q1Y
      labelEmail2.anchorX = 0
      labelEmail2:setFillColor(unpack(s.grey2))

      userEmail = native.newTextField(10,10,10,10)
      userEmail.x = labelEmail2.x
      userEmail.y =  labelEmail2.y + labelEmail2.height + s.bufferM
      userEmail.size = s.p1
      userEmail.width = s.fullWidth - ( s.bufferM * 2 )
      userEmail.height = userEmail.size + s.bufferS
      userEmail.anchorX = 0
      userEmail.inputType = "email"
      userEmail.id = "email"
      loginGroup:insert(userEmail)

      userEmail:addEventListener("userInput", textListener)

      local labelPassword2 = display.newText(loginGroup, "Password:", 0,0, s.defaultFont,s.h4 )
      labelPassword2.x, labelPassword2.y = s.bufferM, userEmail.y + userEmail.height + s.bufferM
      labelPassword2.anchorX = 0
      labelPassword2:setFillColor(unpack(s.grey2))

      local inputPassword2 = native.newTextField(10,10,10,10)
      inputPassword2.x = labelPassword2.x
      inputPassword2.y =  labelPassword2.y + labelPassword2.height + s.bufferM
      inputPassword2.size = s.p1
      inputPassword2.width = s.fullWidth - ( s.bufferM * 2 )
      inputPassword2.height = inputPassword2.size + s.bufferS
      inputPassword2.anchorX = 0
      inputPassword2.isSecure = true
      inputPassword2.id = "inputPassword"
      loginGroup:insert(inputPassword2)

      inputPassword2:addEventListener("userInput", textListener)

      local loginBtn = display.newRoundedRect(loginGroup,0,0,0,0,12)
      loginBtn.width, loginBtn.height = s.buttonMW, s.buttonMH
      loginBtn.x = s.fullWidth - (loginBtn.width + s.bufferM)
      loginBtn.y = inputPassword2.y + inputPassword2.height + s.bufferL
      loginBtn.anchorX = 0
      loginBtn.cornerRadius = loginBtn.height * 0.25
      loginBtn.strokeWidth = 2
      loginBtn.stroke = { type="gradient", color1={ 0.5, 0.5 , 0.5 }, color2={ 0.9, 0.9, 0.9 } }
      loginBtn:setFillColor(1,1,1,.5)
      loginBtn.isHitTestable = true
      loginBtn.id = "register"

      local loginBtnTxt = display.newText(loginGroup, "Login", 0,0, s.defaultFont,s.h4 )
      loginBtnTxt.x, loginBtnTxt.y = loginBtn.x + ( loginBtn.width / 2 ), loginBtn.y
      loginBtnTxt:setFillColor(unpack(s.grey2))

      local function tempHandleLogin (event)
        print("tempHandleLogin")
        composer.removeScene("login")
        composer.gotoScene("home")
        return true
      end
      loginBtn:addEventListener( "touch", tempHandleLogin )

      td.currentScreen = "home"
    	td.previousScreen = "home"

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
  print ("destroy")
  if mainGroup then
    print ("remove maingroup")
    mainGroup:removeSelf()
    mainGroup = nil
  end

  if loginGroup then
    loginGroup:removeSelf()
    loginGroup = nil
  end

  if signUpGroup then
    signUpGroup:removeSelf()
    signUpGroup = nil
  end

  if labelEmail then
    labelEmail:removeSelf()
    labelEmail = nil
  end

  if inputEmail then
    inputEmail:removeSelf()
    inputEmail = nil
  end

  if labelPassword then
    labelPassword:removeSelf()
    labelPassword = nil
  end

  if inputPassword then
    inputPassword:removeSelf()
    inputPassword = nil
  end

  if labelConfirmPassword then
    labelConfirmPassword:removeSelf()
    labelConfirmPassword = nil
  end

  if inputConfirmPassword then
    inputConfirmPassword:removeSelf()
    inputConfirmPassword = nil
  end

  if labelEmail2 then
    labelEmail2:removeSelf()
    labelEmail2 = nil
  end

  if userEmail then
    userEmail:removeSelf()
    userEmail = nil
  end

  if labelPassword2 then
    labelPassword2:removeSelf()
    labelPassword2 = nil
  end

  if labelPassword2 then
    labelPassword2:removeSelf()
    labelPassword2 = nil
  end

  if inputPassword2 then
    inputPassword2:removeSelf()
    inputPassword2 = nil
  end

  if loginBtn then
    loginBtn:removeSelf()
    loginBtn = nil
  end

  if loginBtnTxt then
    loginBtnTxt:removeSelf()
    loginBtnTxt = nil
  end
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
