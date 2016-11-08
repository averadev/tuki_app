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
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen, scrViewR, tools
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local lastX = 0
local txtPName, txtPConcept, lastYP
local btnToggle1, btnToggle2

-- Arrays
local rowReward = {}
local txtBg, txtFiltro, fpRows = {}, {}, {}




---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-- Tap reward event
function tapMessage(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Message" )
    composer.gotoScene("src.Message", { time = 400, effect = "slideLeft", params = { idMessage = t.idMessage } } )
end

-- Creamos lista de comercios
function setListMessages(rewards)
    lastYP = -65
    local isAvailable = true
    tools:setLoading(false)
    
    if #rewards == 0 then
        tools:setEmpty(rowReward, scrViewR, "No cuentas con mensajes recibidos")
    else
        local function setInfoBar(yPosc, txtInfo)
            local bg1 = display.newRect(midW, yPosc, 462, 30 )
            bg1:setFillColor( unpack(cBlueH) )
            scrViewR:insert( bg1 )

            local lblInfo = display.newText({
                text = txtInfo,     
                x = 180, y = yPosc, width = 300, 
                font = fontBold,   
                fontSize = 17, align = "left"
            })
            lblInfo:setFillColor( unpack(cWhite) )
            scrViewR:insert( lblInfo )
        end

        for z = 1, #rewards, 1 do 

            -- Contenedor del Reward
            rowReward[z] = display.newContainer( intW, 130 )
            rowReward[z]:translate( midW, lastYP + (130*z) )
            scrViewR:insert( rowReward[z] )

            local bg = display.newRect(0, 0, intW, 120 )
            bg:setFillColor( 1 )
            bg.idMessage = rewards[z].id
            bg:addEventListener( 'tap', tapMessage)
            rowReward[z]:insert( bg )
        
            local lnDot1 = display.newImage("img/deco/lnDot.png")
            lnDot1:translate( 0, -60 )
            rowReward[z]:insert( lnDot1 )
        
            local lnDot2 = display.newImage("img/deco/lnDot.png")
            lnDot2:translate( 0, 60 )
            rowReward[z]:insert( lnDot2 )
            
            local circleLogo = display.newImage("img/deco/circleLogo80.png")
            circleLogo:translate( -178, 0 )
            rowReward[z]:insert( circleLogo )
            
            local img
            if rewards[z].image then
                -- Commerce
                img = display.newImage( rewards[z].image, system.TemporaryDirectory )
            else
                -- Unify and Standar
                img = display.newImage("img/icon/tukiIcon.png")
            end
            local mask = graphics.newMask( "img/deco/maskLogo80.png" )
            img:setMask( mask )
            img:translate( -178, 0 )
            img.width = 80
            img.height = 80
            rowReward[z]:insert( img )


            local lblFecha = display.newText({
                text = rewards[z].fecha,     
                x = 35, y = -35, width = 350, 
                font = fontRegular,   
                fontSize = 14, align = "right"
            })
            lblFecha:setFillColor( unpack(cBlueH) )
            rowReward[z]:insert( lblFecha )

            local lblTxt1 = display.newText({
                text = "DE",     
                x = 55, y = -10, width = 350, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblTxt1:setFillColor( unpack(cBlueH) )
            rowReward[z]:insert( lblTxt1 )

            local lblFrom = display.newText({
                text = rewards[z].commerce,     
                x = 80, y = -10, width = 350, 
                font = fontSemiBold,   
                fontSize = 20, align = "left"
            })
            lblFrom:setFillColor( unpack(cBlueH) )
            rowReward[z]:insert( lblFrom )

            local lblTxt2 = display.newText({
                text = "ASUNTO",     
                x = 55, y = 20, width = 350, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblTxt2:setFillColor( unpack(cBlueH) )
            rowReward[z]:insert( lblTxt2 )

            local lblName = display.newText({
                text = rewards[z].name, 
                x = 75, y = 9, width = 260,
                font = fontRegular,   
                fontSize = 17, align = "left"
            })
            lblName.anchorY = 0
            lblName:setFillColor( unpack(cBlueH) )
            rowReward[z]:insert( lblName )

            -- Diseño visto
            if rewards[z].status == "1" then
                local bgSel = display.newRect( midW-4, 0, 8, 120 )
                bgSel:setFillColor( {
                    type = 'gradient',
                    color1 = { unpack(cBBlu) }, 
                    color2 = { unpack(cBTur) },
                    direction = "top"
                } ) 
                rowReward[z]:insert(bgSel)
            end

        end
        -- Set new scroll position
        scrViewR:setScrollHeight((125 * #rewards) + lastYP + 80)
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
    
    local initY = h + 60 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 120)
    
    scrViewR = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewR)
    scrViewR:toBack()
    
    tools:setLoading(true, scrViewR)
    RestManager.getMessagesSeg()
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        tools:showBubble(false)
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
    end
end

-- Remove Listener
function scene:destroy( event )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene