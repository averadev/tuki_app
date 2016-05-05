---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local RestManager = require( "src.RestManager" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()




---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local lblTitle = display.newText({
        text = "Vincular una tarjeta TUKI", 
        x = midW, y = midH - 130, width = 400, 
        font = fLatoBold, fontSize = 33
    })
    lblTitle:setFillColor( unpack(cBlueH) )
    screen:insert( lblTitle )
    
    local txtDesc1 = "Al vincular una tarjeta a tu cuenta Tuki, automáticamente llevarás todos los "..
    "puntos acumulados hasta el momento a tu celular."
    local txtDesc2 = "Así, podrás registrar tus visitas directamente con tu teléfono ¡Sin necesidad de llevar tu tarjeta!"
    local txtDesc3 = "Por tu seguridad, únicamente podrás vincular una tarjeta a tu cuenta Tuki."
         
    local lblDesc1 = display.newText({
        text = txtDesc1, 
        x = midW, y = midH - 65, width = 400, 
        font = fLatoRegular, fontSize = 20
    })
    lblDesc1:setFillColor( unpack(cBlue) )
    screen:insert( lblDesc1 )
    local lblDesc2 = display.newText({
        text = txtDesc2, 
        x = midW, y = midH + 20, width = 400, 
        font = fLatoRegular, fontSize = 20
    })
    lblDesc2:setFillColor( unpack(cBlue) )
    screen:insert( lblDesc2 )
    local lblDesc3 = display.newText({
        text = txtDesc3, 
        x = midW, y = midH + 90, width = 400, 
        font = fLatoRegular, fontSize = 20
    })
    lblDesc3:setFillColor( unpack(cBlue) )
    screen:insert( lblDesc3 )
    
    local bgRedem = display.newRoundedRect( midW, midH + 170, 400, 60, 10 )
    bgRedem:setFillColor( unpack(cPurpleL) )
    screen:insert(bgRedem)
    local bgRedemR1 = display.newRoundedRect( 400, midH + 170, 80, 60, 10 )
    bgRedemR1:setFillColor( unpack(cPurple) )
    screen:insert(bgRedemR1)
    local bgRedemR2 = display.newRect( 380, midH + 170, 40, 60 )
    bgRedemR2:setFillColor( unpack(cPurple) )
    screen:insert(bgRedemR2)
    local lblRedem = display.newText({
        text = "VINCULAR", 
        x = midW, y = midH + 170,
        font = fLatoBold,
        fontSize = 26, align = "center"
    })
    lblRedem:setFillColor( unpack(cWhite) )
    screen:insert( lblRedem )
    local iconQR = display.newImage("img/icon/iconQR.png")
    iconQR:translate( 400, midH + 170 )
    screen:insert( iconQR )
    
    
    tools:toFront()
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
    end
end

-- Remove Listener
function scene:hide( event )
end

-- Remove Listener
function scene:destroy( event )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene