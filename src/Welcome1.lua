---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require( "src.Globals" )
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local h = display.topStatusBarContentHeight 


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function goToScr(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( t.to )
    storyboard.gotoScene(t.to, { time = 400, effect = "slideLeft" } )
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    print(intH)
    local ajustH = 0
    if intH < 700 then
        ajustH = 45
    elseif intH < 750 then
        ajustH = 25
    end
    
	local tools = Tools:new()
    tools:buildHeader(true)
    screen:insert(tools)
    
    -- Middle work place
    local midH = ((display.contentHeight - h - 80  ) / 2) + h + 80
    
    
    local txt1 = display.newText({
        text = "BIENVENIDO A",
        x = midW, y = midH - 270 + ajustH,
        font = native.systemFontBold,   
        fontSize = 40, align = "center"
    })
    txt1:setFillColor( .1 )
    screen:insert( txt1 )
    
    local logoBig = display.newImage("img/icon/logoBig.png")
    logoBig:translate( midW, midH - 160 + ajustH)
    screen:insert( logoBig )
    
    local txt2 = display.newText({
        text = "TODOS LOS COMERCIOS CERCA DE TI \nÓ\nTODO LO QUE TE GUSTA",
        x = midW, y = midH,
        font = native.systemFontBold,   
        fontSize = 20, align = "center"
    })
    txt2:setFillColor( .1 )
    screen:insert( txt2 )
    
    local txt2 = display.newText({
        text = "AFILIATE Y DISFRUTA DE LOS BENEFICIOS",
        x = midW, y = midH + 110 - ajustH,
        font = native.systemFont,   
        fontSize = 18, align = "center"
    })
    txt2:setFillColor( .3 )
    screen:insert( txt2 )
    
    -- Botons
    local btnNearBg1 = display.newRoundedRect( midW, midH + 180 - ajustH, 350, 70, 10 )
    btnNearBg1:setFillColor( 46/255, 190/255, 239/255 )
    btnNearBg1.to = "src.Welcome3"
    btnNearBg1:addEventListener( 'tap', goToScr )
    screen:insert(btnNearBg1)
    local btnNearBg2 = display.newRoundedRect( midW, midH + 180 - ajustH, 344, 66, 10 )
    btnNearBg2:setFillColor( 1 )
    screen:insert(btnNearBg2)
    local txtNear2 = display.newText({
        text = "LO MAS CERCA DE MI",
        x = midW, y = midH + 180 - ajustH,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    txtNear2:setFillColor( 46/255, 190/255, 239/255 )
    screen:insert( txtNear2 )
    
    local btnInterBg1 = display.newRoundedRect( midW, midH + 270 - ajustH, 350, 70, 10 )
    btnInterBg1:setFillColor( .3 )
    btnInterBg1.to = "src.Welcome2"
    btnInterBg1:addEventListener( 'tap', goToScr )
    screen:insert(btnInterBg1)
    local btnInterBg2 = display.newRoundedRect( midW, midH + 270 - ajustH, 344, 66, 10 )
    btnInterBg2:setFillColor( 1 )
    screen:insert(btnInterBg2)
    local txtInter2 = display.newText({
        text = "POR MIS INTERESES",
        x = midW, y = midH + 270 - ajustH,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    txtInter2:setFillColor( .3 )
    screen:insert( txtInter2 )
    
    
    tools:toFront()
    
end	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene