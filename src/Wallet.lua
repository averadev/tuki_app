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
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    local isReden = false
    if t.status == "1" then
        t.status = "2"
        myWallet = myWallet -1
        
        if t.border then
            t.border:removeSelf()
            t.border = nil
        end
        RestManager.setReadGift(t.idReward)
    elseif t.status == "3" then
        isReden = true
    end
    
    composer.removeScene( "src.Reward" )
    composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward, giftReden = isReden } } )
end

-- Agregamos lista de comercios
function setWalletLogos(rewards)
    for z = 1, #rewards, 1 do 
        if rowReward[z] then
            local circleLogo = display.newImage("img/deco/circleLogo.png")
            circleLogo:translate(-130, -50 )
            rowReward[z]:insert( circleLogo )
            
            local mask = graphics.newMask( "img/deco/maskLogo.png" )
            local img = display.newImage( rewards[z].image, system.TemporaryDirectory )
            img:setMask( mask )
            img:translate( -130, -50 )
            img.width = 150
            img.height = 150
            rowReward[z]:insert( img )
        end
    end
end 

-- Creamos lista de comercios
function setListWallet(rewards)
    lastYP = 100
    local isAvailable = true
    tools:setLoading(false)
    
    if #rewards == 0 then
        tools:setEmpty(rowReward, scrViewR, "No cuentas con regalos recibidos")
    else
        
        local iconGift = display.newImage("img/icon/iconGift.png")
        iconGift:translate( 40, 40 )
        scrViewR:insert( iconGift )
        
        local lblInfo1 = display.newText({
            text = "¡FELICIDADES TUKER!",     
            x = 280, y = 30, width = 400, 
            font = fontSemiBold,   
            fontSize = 15, align = "left"
        })
        lblInfo1:setFillColor( unpack(cBBlu) )
        scrViewR:insert( lblInfo1 )
        
        local lblInfo2 = display.newText({
            text = "TUS COMERCIOS FAVORITOS TE REGALAN:",     
            x = 280, y = 50, width = 400, 
            font = fontSemiBold,   
            fontSize = 15, align = "left"
        })
        lblInfo2:setFillColor( unpack(cBBlu) )
        scrViewR:insert( lblInfo2 )
        
        lastYP = -90
        for z = 1, #rewards, 1 do 

            -- Contenedor del Reward
            rowReward[z] = display.newContainer( 480, 330 )
            rowReward[z]:translate( midW, lastYP + (330*z) )
            scrViewR:insert( rowReward[z] )
        
            local lnDot = display.newImage("img/deco/lnDot.png")
            lnDot:translate( 0, -160 )
            rowReward[z]:insert( lnDot )
            
            local dotSquare = display.newImage("img/deco/dotSquare.png")
            dotSquare:translate( 0, -50 )
            rowReward[z]:insert( dotSquare )
            
            local bgImg = display.newRect( 90, -50, 266, 200 )
            bgImg:setFillColor( unpack(cBTur) )
            rowReward[z]:insert( bgImg )
            
            local bgImg = display.newRect( 0, 100, 440, 80 )
            bgImg.idReward = rewards[z].id
            bgImg.status = rewards[z].status
            bgImg:addEventListener( 'tap', tapReward)
            rowReward[z]:insert( bgImg )
            
            local img = display.newImage( rewards[z].image, system.TemporaryDirectory )
            img:translate( 90, -50 )
            img.width = 262
            img.height = 196
            img.idReward = rewards[z].id
            img.status = rewards[z].status
            img:addEventListener( 'tap', tapReward)
            rowReward[z]:insert( img )
            
            local lblCommerce = display.newText({
                text = rewards[z].commerce,     
                x = 0, y = 73, width = 400, 
                font = fontSemiBold,   
                fontSize = 20, align = "left"
            })
            lblCommerce:setFillColor( unpack(cBBlu) )
            rowReward[z]:insert( lblCommerce )
            
            local lblGift1 = display.newText({
                text = "TE REGALA: ",     
                x = 0, y = 100, width = 400, 
                font = fontRegular,   
                fontSize = 12, align = "left"
            })
            lblGift1:setFillColor( unpack(cBBlu) )
            rowReward[z]:insert( lblGift1 )
            
            local lblGift1 = display.newText({
                text = rewards[z].name..' '..rewards[z].name,     
                x = 20, y = 100, width = 300, 
                font = fontSemiBold, height = 23,   
                fontSize = 18, align = "left"
            })
            lblGift1:setFillColor( unpack(cBBlu) )
            rowReward[z]:insert( lblGift1 )
            
            local lblGift2 = display.newText({
                text = "Valido al  "..rewards[z].vigency,     
                x = 0, y = 120, width = 400, 
                font = fontRegular,   
                fontSize = 12, align = "left"
            })
            lblGift2:setFillColor( unpack(cBBlu) )
            rowReward[z]:insert( lblGift2 )
            
            local iconArrowR = display.newImage("img/icon/iconArrowR.png")
            iconArrowR:translate( 200, 105 )
            rowReward[z]:insert( iconArrowR )
            
            local lnDot1 = display.newImage("img/deco/lnDot.png")
            lnDot1:translate( 0, 140 )
            rowReward[z]:insert( lnDot1 )
            
            local bgFoot = display.newRect( 0, 155, 480, 10 )
            bgFoot:setFillColor( {
                type = 'gradient',
                color1 = { unpack(cBBlu) }, 
                color2 = { unpack(cBTur) },
                direction = "right"
            } ) 
            rowReward[z]:insert( bgFoot )
            
        end
        -- Set new scroll position
        scrViewR:setScrollHeight((330 * #rewards) + 90)
        for z = 1, #rewards, 1 do 
            rewards[z].image = rewards[z].logo
        end
        loadImage({idx = 0, name = "WalletLogos", path = "assets/img/api/commerce/", items = rewards})
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
    RestManager.getWallet()
    
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