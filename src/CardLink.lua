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
local qrscanner = require('plugin.qrscanner')
local fxLink = audio.loadSound( "fx/join.wav")
local fxError = audio.loadSound( "fx/error.wav")

-- Grupos y Contenedores
local screen, grpCLMess
local scene = composer.newScene()


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-------------------------------------
-- Abre a camara
-- @param event objeto del evento
------------------------------------
function getQRScan(event)
    local function listQR(message)  
        tools:setLoading(true, screen)
        RestManager.cardLink(message)
    end
    -- Ejecuta el plugin
    qrscanner.show(listQR, {strings = { title = 'TUKI' }})  
end

-------------------------------------
-- Muestra un mensaje 
-- @param message 
------------------------------------
function showMess(isLink, message)
    tools:setLoading(false)
    if grpCLMess then
        grpCLMess:removeSelf()
        grpCLMess = nil
    end
    grpCLMess = display.newGroup()
    screen:insert(grpCLMess)

    function setDes(event)
        return true
    end
    local bg = display.newRect( midW, midH, intW, intH )
    bg:setFillColor( 0 )
    bg:addEventListener( 'tap', setDes)
    bg.alpha = .7
    grpCLMess:insert(bg)
    
    local bgContent = display.newRoundedRect( midW, midH + 30, 400, 150, 10 )
    bgContent:setFillColor( unpack(cGrayXXH) )
    grpCLMess:insert(bgContent)
    local titleLoading = display.newText({
        text = message,     
        x = midW, y = midH + 30, width = 380,
        font = fLatoBold,   
        fontSize = 25, align = "center"
    })
    titleLoading:setFillColor( .9 )
    grpCLMess:insert(titleLoading)
    
    if isLink then
        disabledLink()
        audio.play(fxLink)
        transition.to( grpCLMess, { alpha = 0, time = 500, delay = 5000 , onComplete=function()
            toHome()
        end})
    else
        audio.play(fxError)
        transition.to( grpCLMess, { alpha = 0, time = 500, delay = 4000 })
    end
    
end


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
        text = "¡Liga una tarjeta TUKI a tu cuenta y LLEVALA SIEMPRE CONTIGO!", 
        x = midW, y = midH - 100, width = 440, 
        font = fLatoBold, fontSize = 26, align = "center"
    })
    lblTitle:setFillColor( unpack(cBlueH) )
    screen:insert( lblTitle )
    
    local txtDesc1 = "Liga una tarjeta a tu cuenta y automaticamente llevarás todos tus puntos contigo."
    local txtDesc2 = "¡Sin necesidad de traer la tarjeta contigo!"
         
    local lblDesc1 = display.newText({
        text = txtDesc1, 
        x = midW, y = midH - 20, width = 400, 
        font = fLatoRegular, fontSize = 18
    })
    lblDesc1:setFillColor( unpack(cBlueH) )
    screen:insert( lblDesc1 )
    local lblDesc2 = display.newText({
        text = txtDesc2, 
        x = midW, y = midH + 20, width = 400, 
        font = fLatoBold, fontSize = 18
    })
    lblDesc2:setFillColor( unpack(cBlueH) )
    screen:insert( lblDesc2 )
    
    local bgRedem = display.newRoundedRect( midW, midH + 100, 400, 60, 10 )
    bgRedem:setFillColor( unpack(cPurpleL) )
    bgRedem:addEventListener( 'tap', getQRScan)
    screen:insert(bgRedem)
    local bgRedemR1 = display.newRoundedRect( 400, midH + 100, 80, 60, 10 )
    bgRedemR1:setFillColor( unpack(cPurple) )
    screen:insert(bgRedemR1)
    local bgRedemR2 = display.newRect( 380, midH + 100, 40, 60 )
    bgRedemR2:setFillColor( unpack(cPurple) )
    screen:insert(bgRedemR2)
    local lblRedem = display.newText({
        text = "LIGAR TARJETA", 
        x = midW, y = midH + 100,
        font = fLatoBold,
        fontSize = 26, align = "center"
    })
    lblRedem:setFillColor( unpack(cWhite) )
    screen:insert( lblRedem )
    local iconQR = display.newImage("img/icon/iconQR.png")
    iconQR:translate( 400, midH + 100 )
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