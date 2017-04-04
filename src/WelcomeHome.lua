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
function goToProfile(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.WelcomeProfile" )
    composer.gotoScene("src.WelcomeProfile", { time = 400, effect = "slideLeft", params = { isLocation = true } } )
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
        text = "¡ BIENVENIDO !",
        x = midW, y = midH - 50,
        font = fontBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cBlueH) )
    screen:insert( txt1 )
    
    local txt2 = display.newText({
        text = "Recibe Regalos exclusivos",
        x = midW, y = midH-15,
        font = fontSemiBold,   
        fontSize = 25, align = "center"
    })
    txt2:setFillColor( unpack(cBlueH) )
    screen:insert( txt2 )
    
    local txt3 = display.newText({
        text = "de tus comercios favoritos.",
        x = midW, y = midH+15,
        font = fontSemiBold,   
        fontSize = 25, align = "center"
    })
    txt3:setFillColor( unpack(cBlueH) )
    screen:insert( txt3 )
    
    -- Botons
    local btnNearBg1 = display.newRoundedRect( midW, midH + 120, 350, 70, 10 )
    btnNearBg1:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "right"
    } )
    btnNearBg1:addEventListener( 'tap', goToProfile )
    screen:insert(btnNearBg1)
    local icoWArrow = display.newImage("img/icon/icoWArrow.png")
    icoWArrow:translate( midW + 60, midH + 120 )
    screen:insert( icoWArrow )
    local txtNear2 = display.newText({
        text = "CONTINUAR",
        x = midW + 35, y = midH + 120,
        font = fontBold, width = 250,  
        fontSize = 20, align = "left"
    })
    txtNear2:setFillColor( unpack(cWhite) )
    screen:insert( txtNear2 )
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