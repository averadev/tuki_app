---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local fxTap = audio.loadSound( "fx/click.wav")

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
function goToWCat(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.WelcomeCat" )
    composer.gotoScene("src.WelcomeCat", { time = 400, effect = "slideLeft" } )
end

function goToList(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.WelcomeList" )
    composer.gotoScene("src.WelcomeList", { time = 400, effect = "slideLeft", params = { isLocation = true } } )
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
        text = "¡BIENVENIDO!",
        x = midW, y = midH - 50,
        font = fLatoBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cGrayXH) )
    screen:insert( txt1 )
    
    local txt2 = display.newText({
        text = "Comienza buscando",
        x = midW, y = midH-15,
        font = fLatoBold,   
        fontSize = 25, align = "center"
    })
    txt2:setFillColor( unpack(cGrayXH) )
    screen:insert( txt2 )
    
    local txt3 = display.newText({
        text = "los comercios afiliados",
        x = midW, y = midH+15,
        font = fLatoBold,   
        fontSize = 25, align = "center"
    })
    txt3:setFillColor( unpack(cGrayXH) )
    screen:insert( txt3 )
    
    -- Botons
    local btnNearBg1 = display.newRoundedRect( midW, midH + 120, 350, 70, 10 )
    btnNearBg1:setFillColor( unpack(cTurquesa) )
    btnNearBg1:addEventListener( 'tap', goToList )
    screen:insert(btnNearBg1)
    local btnNearBg2 = display.newRoundedRect( midW, midH + 120, 344, 64, 10 )
    btnNearBg2:setFillColor( unpack(cBlue) )
    screen:insert(btnNearBg2)
    local icoWLocation = display.newImage("img/icon/icoWLocation.png")
    icoWLocation:translate( midW - 120, midH + 120 )
    screen:insert( icoWLocation )
    local txtNear2 = display.newText({
        text = "LO MAS CERCA DE MI",
        x = midW + 35, y = midH + 120,
        font = fLatoBold, width = 250,  
        fontSize = 20, align = "left"
    })
    txtNear2:setFillColor( unpack(cWhite) )
    screen:insert( txtNear2 )
    
    local btnInterBg1 = display.newRoundedRect( midW, midH + 210, 350, 70, 10 )
    btnInterBg1:setFillColor( unpack(cPurpleL) )
    btnInterBg1:addEventListener( 'tap', goToWCat )
    screen:insert(btnInterBg1)
    local btnInterBg2 = display.newRoundedRect( midW, midH + 210, 344, 64, 10 )
    btnInterBg2:setFillColor( unpack(cPurple) )
    screen:insert(btnInterBg2)
    local icoWCategories = display.newImage("img/icon/icoWCategories.png")
    icoWCategories:translate( midW - 120, midH + 210 )
    screen:insert( icoWCategories )
    local txtInter2 = display.newText({
        text = "POR MIS INTERESES",
        x = midW + 35, y = midH + 210,
        font = fLatoBold, width = 250,
        fontSize = 20, align = "left"
    })
    txtInter2:setFillColor( unpack(cWhite) )
    screen:insert( txtInter2 )
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    
end

-- Remove Listener
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene