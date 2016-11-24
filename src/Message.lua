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
local Globals = require( "src.Globals" )
local composer = require( "composer" )
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen, scrViewMe, tools
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-- Tap reward event
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Reward" )
    composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
end

-- Crea contenido del Reward
function setMessage(item)
    tools:setLoading(false)
    local yPosc = 0
    
    local lblFecha = display.newText({
        text = item.fecha,     
        x = 350, y = 45, width = 200, 
        font = fontRegular,
        fontSize = 16, align = "right"
    })
    lblFecha:setFillColor( unpack(cBlueH) )
    scrViewMe:insert( lblFecha )
    
    
    local circleLogo = display.newImage("img/deco/circleLogo80.png")
    circleLogo:translate( 65, 90 )
    scrViewMe:insert( circleLogo )
    
    local imgLogo
    local path = system.pathForFile( item.imagecom, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        imgLogo = display.newImage( item.imagecom, system.TemporaryDirectory )
    else
        imgLogo = display.newImage("img/icon/tukiIcon.png")
    end
    
    local mask = graphics.newMask( "img/deco/maskLogo80.png" )
    imgLogo:setMask( mask )
    imgLogo:translate( 65, 90 )
    imgLogo.height = 80
    imgLogo.width = 80
    scrViewMe:insert( imgLogo )
    
    local lblDe1 = display.newText({
        text = "De: ",     
        x = 180, y = 80, width = 100, 
        font = fontSemiBold,
        fontSize = 18, align = "left"
    })
    lblDe1:setFillColor( unpack(cBlueH) )
    scrViewMe:insert( lblDe1 )
    
    local lblDe2 = display.newText({
        text = item.commerce,     
        x = 290, y = 80, width = 250, 
        font = fontRegular,
        fontSize = 20, align = "left"
    })
    lblDe2:setFillColor( unpack(cBlueH) )
    scrViewMe:insert( lblDe2 )
    
    local lblAsunto1 = display.newText({
        text = "Asunto: ",     
        x = 180, y = 95, width = 100, 
        font = fontSemiBold,
        fontSize = 18, align = "left"
    })
    lblAsunto1.anchorY = 0
    lblAsunto1:setFillColor( unpack(cBlueH) )
    scrViewMe:insert( lblAsunto1 )
    
    local lblAsunto2 = display.newText({
        text = item.name,     
        x = 315, y = 95, width = 230, 
        font = fontRegular,
        fontSize = 18, align = "left"
    })
    lblAsunto2.anchorY = 0
    lblAsunto2:setFillColor( unpack(cBlueH) )
    scrViewMe:insert( lblAsunto2 )
    
    -- Imagen
    local bgImage = display.newRoundedRect(midW, 157, 446, 160, 5 )
    bgImage.anchorY = 0
    bgImage:setFillColor( unpack(cBTur) )
    scrViewMe:insert( bgImage )
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( midW, 160 )
    imgPBig.anchorY = 0
    scrViewMe:insert( imgPBig )
    
    bgImage.height = imgPBig.height + 6
    
    local lastY = 180 + imgPBig.height
    local lblDesc = display.newText({
        text = item.description,
        x = midW, y = lastY, width = 430, 
        font = fontRegular,
        fontSize = 18, align = "left"
    })
    lblDesc:setFillColor( unpack(cBlueH) )
    scrViewMe:insert( lblDesc )
    
    lblDesc.y = lastY + (lblDesc.height/2)
    
    lastY = lastY + lblDesc.height + 10
    
    -- Ir a Reward
    if not(item.idReward == '0') then
        lastY = lastY + 40
        
        local bgCommerce = display.newRoundedRect( midW, lastY, 440, 60, 5 )
        bgCommerce:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBBlu) }, 
            color2 = { unpack(cBTur) },
            direction = "right"
        } )
        bgCommerce.idReward = item.idReward
        bgCommerce:addEventListener( 'tap', tapReward)
        scrViewMe:insert(bgCommerce)
        local txtCommerce = display.newText({
            text = "IR A LA RECOMPENSA", 
            x = midW, y = lastY,
            font = fontBold,
            fontSize = 20, align = "center"
        })
        txtCommerce:setFillColor( 1 )
        scrViewMe:insert( txtCommerce )
        lastY = lastY + 20
    end 
    
    bg1.height = lastY
    bg2.height = lastY - 4
    
    -- Set new scroll position
    scrViewMe:setScrollHeight( lastY + 50)
    
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    local idMessage = event.params.idMessage
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 60 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 120)
    
    scrViewMe = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewMe)
    scrViewMe:toBack()
    
    tools:setLoading(true, scrViewMe)
    RestManager.getMessageSeg(idMessage)
    
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