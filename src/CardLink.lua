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
    local function listQR(event)  
        tools:setLoading(true, screen)
        RestManager.cardLink(event.message)
    end
    -- Ejecuta el plugin
    qrscanner.show({listener = listQR, text = 'TUKI' })  
end

-------------------------------------
-- Muestra el bubble de wallet
-- @param wallet number
------------------------------------
function addB(gift)
    myWallet = myWallet + gift
    tools:showBubble(true)
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
    
    local bg1 = display.newRect( midW, midH + 30, 404, 154 )
    bg1:setFillColor( unpack(cBPur) )
    grpCLMess:insert(bg1)

    local bg2 = display.newRect( midW, midH + 30, 400, 150 )
    bg2:setFillColor( unpack(cWhite) )
    grpCLMess:insert(bg2)
    
    local titleLoading = display.newText({
        text = message,     
        x = midW, y = midH + 30, width = 380,
        font = fontBold,   
        fontSize = 25, align = "center"
    })
    titleLoading:setFillColor( unpack(cBPur) )
    grpCLMess:insert(titleLoading)
    
    if isLink then
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
    tools:buildBottomBar()
    screen:insert(tools)
    
    local linkCard = display.newImage("img/deco/linkCard.png")
    linkCard:translate( midW, midH - 85 )
    screen:insert( linkCard )
    
    local lblTitle = display.newText({
        text = "¡LIGA TU TARJETA A TU CUENTA Y LLEVA TUS TUKS A TODOS LADOS!", 
        x = midW, y = midH + 85, width = 440, 
        font = fontBold, fontSize = 24, align = "center"
    })
    lblTitle:setFillColor( unpack(cBlueH) )
    screen:insert( lblTitle )
    
    local lblDesc = display.newText({
        text = "¡Sin necesidad de traer la tarjeta contigo!", 
        x = midW, y = midH + 130, width = 400, 
        font = fontBold, fontSize = 18, align = "center"
    })
    lblDesc:setFillColor( unpack(cBlueH) )
    screen:insert( lblDesc )
    
    local bgRedem = display.newRoundedRect( midW, midH + 190, 400, 60, 10 )
    bgRedem:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "right"
    } )
    bgRedem:addEventListener( 'tap', getQRScan)
    screen:insert(bgRedem)
    local lblRedem = display.newText({
        text = "LIGAR TARJETA", 
        x = midW - 30, y = midH + 190,
        font = fontBold,
        fontSize = 26, align = "center"
    })
    lblRedem:setFillColor( unpack(cWhite) )
    screen:insert( lblRedem )
    local iconQR = display.newImage("img/icon/menuCard.png")
    iconQR.height = 30
    iconQR.width = 47
    iconQR:translate( 365, midH + 190 )
    screen:insert( iconQR )
    
    -- Ajust by ratio
    if allH > 685 then
        linkCard.y = midH - 110
        lblTitle.y = midH + 75
        lblDesc.y = midH + 120
    end
    
    tools:toFront()
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        tools:showBubble(false)
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