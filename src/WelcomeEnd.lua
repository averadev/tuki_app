---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local DBManager = require('src.DBManager')
local RestManager = require( "src.RestManager" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

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
    composer.removeScene( "src.Home" )
    composer.gotoScene("src.Home", { time = 400, effect = "slideLeft" } )
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
    local bgWelcome = display.newImage("img/deco/bgWelcome.png")
    bgWelcome:translate( midW, midH)
    screen:insert( bgWelcome )
    
    local logoBig = display.newImage("img/icon/logoBig.png")
    logoBig:translate( midW, midH - 180 )
    screen:insert( logoBig )
    
    local txt1 = display.newText({
        text = "¡LISTO!",
        x = midW, y = midH - 50,
        font = fLatoBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cGrayXH) )
    screen:insert( txt1 )
    
    local txt2 = display.newText({
        text = "Ahora puedes comenzar",
        x = midW, y = midH-15,
        font = fLatoBold,   
        fontSize = 23, align = "center"
    })
    txt2:setFillColor( unpack(cGrayXH) )
    screen:insert( txt2 )
    
    local txt3 = display.newText({
        text = "a ganar recompensas por tus visitas",
        x = midW, y = midH+15,
        font = fLatoBold,   
        fontSize = 23, align = "center"
    })
    txt3:setFillColor( unpack(cGrayXH) )
    screen:insert( txt3 )
    
    
    local btnInterBg1 = display.newRoundedRect( midW, midH + 120, 350, 70, 10 )
    btnInterBg1:setFillColor( unpack(cPurpleL) )
    btnInterBg1:addEventListener( 'tap', goToHome )
    screen:insert(btnInterBg1)
    local btnInterBg2 = display.newRoundedRect( midW, midH + 120, 344, 64, 10 )
    btnInterBg2:setFillColor( unpack(cPurple) )
    screen:insert(btnInterBg2)
    local icoWArrow = display.newImage("img/icon/icoWArrow.png")
    icoWArrow:translate( midW + 60, midH + 118 )
    screen:insert( icoWArrow )
    local txtInter2 = display.newText({
        text = "ENTRAR",
        x = midW - 50, y = midH + 120,
        font = fLatoBold, width = 150,
        fontSize = 20, align = "right"
    })
    txtInter2:setFillColor( unpack(cWhite) )
    screen:insert( txtInter2 )
    
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    -- Deshabilitar welcome
    DBManager.disableWelcome()
    -- Obtener imagen QR
    RestManager.getQR()
end

-- Remove Listener
function scene:destroy( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene