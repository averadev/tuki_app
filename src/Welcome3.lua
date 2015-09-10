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
function goToHome(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( "src.Home" )
    storyboard.gotoScene("src.Home", { time = 400, effect = "slideLeft" } )
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    
	local tools = Tools:new()
    tools:buildHeader(true)
    screen:insert(tools)
    
    -- Middle work place
    local midH = ((display.contentHeight - h - 80  ) / 2) + h + 80
    
    local txt1 = display.newText({
        text = "¡LISTO!",
        x = midW, y = midH - 190,
        font = native.systemFontBold,   
        fontSize = 40, align = "center"
    })
    txt1:setFillColor( 46/255, 190/255, 239/255 )
    screen:insert( txt1 )
    
    local txt2 = display.newText({
        text = "¡RECUERDA AFILIARTE A TODOS LOS\nPROGRAMAS DE LEALTAD!\n\nY\n\nOBTENER BENEFICIOS DIARIAMENTE\nEN TU CONSUMO",
        x = midW, y = midH - 40,
        font = native.systemFontBold,   
        fontSize = 20, align = "center"
    })
    txt2:setFillColor( .1 )
    screen:insert( txt2 )
    
    -- Botons
    local btnNearBg1 = display.newRoundedRect( midW, midH + 120, 350, 70, 10 )
    btnNearBg1:setFillColor( 46/255, 190/255, 239/255 )
    screen:insert(btnNearBg1)
    local btnNearBg2 = display.newRoundedRect( midW, midH + 120, 344, 66, 10 )
    btnNearBg2:setFillColor( 1 )
    screen:insert(btnNearBg2)
    local menuProgramas = display.newImage("img/icon/menuProgramas.png")
    menuProgramas:translate( midW - 70, midH + 118)
    screen:insert( menuProgramas )
    local txtNear2 = display.newText({
        text = "AFILIARME",
        x = midW + 30, y = midH + 120,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    txtNear2:setFillColor( 46/255, 190/255, 239/255 )
    screen:insert( txtNear2 )
    
    
    local btnTxt2 = display.newRect( midW + 130, midH + 200, 150, 40 )
    btnTxt2:setFillColor( 1 )
    btnTxt2:addEventListener( 'tap', goToHome )
    screen:insert(btnTxt2)
    local txt2 = display.newText({
        text = "CONTINUAR >>",
        x = midW + 80, y = midH + 200,
        width = 200, font = native.systemFont,   
        fontSize = 14, align = "right"
    })
    txt2:setFillColor( 46/255, 190/255, 239/255 )
    screen:insert( txt2 )
    
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