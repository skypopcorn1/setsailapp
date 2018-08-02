--global app settings
local T = {}

--alignment variables

T.bufferXXL = 100
T.bufferXL = 50
T.bufferL= 40
T.bufferM = 25
T.bufferS = 15
T.bufferXS = 3
T.buttonMW = display.viewableContentWidth/3
T.buttonMH = T.buttonMW / 3
T.centerX = display.viewableContentWidth/2
T.centerY = display.viewableContentHeight/2
T.footerY = display.viewableContentHeight * .9
T.fullWidth = display.contentWidth
T.fullHeight = display.contentHeight
T.halfScreenW = display.contentWidth/2
T.leftAlignment = display.contentCenterX - T.halfScreenW
T.s1 = .25 -- scale 25%
T.s2 = .5  -- scale 50%
T.textFieldWidth = T.fullWidth * .7
T.textFieldHeight = T.textFieldWidth / 5
T.q1X = display.viewableContentWidth/4
T.q1Y = display.viewableContentHeight/4
T.q3X = display.viewableContentWidth * .75
T.q3Y = display.viewableContentHeight * .75

--font variables
T.defaultFont = "fonts/SinkinSans-400Regular"
T.defaultFontThin = "fonts/SinkinSans-100Thin"
T.h1 = 50
T.h2 = 40
T.h3 = 30
T.h4 = 20
T.p = 15

--colour palette variables
T.blue = {0/255, 176/255, 240/255}
T.grey1 = {161/255, 166/255, 164/255}
T.grey2 = {92/255, 95/255, 94/255}
T.grey3 = {61/255, 64/255, 63/255}

return T
