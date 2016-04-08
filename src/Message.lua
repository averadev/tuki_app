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
    
    -- Fondo
    local bg1 = display.newRect(midW, 25, intW - 36, 310 )
    bg1:setFillColor( 236/255 )
    bg1.anchorY = 0
    scrViewMe:insert( bg1 )
    local bg2 = display.newRect(midW, 27, intW - 40, 306 )
    bg2:setFillColor( 1 )
    bg2.anchorY = 0
    scrViewMe:insert( bg2 )
    
    local lblFecha = display.newText({
        text = item.fecha,     
        x = 350, y = 50, width = 200, 
        font = fLatoRegular,
        fontSize = 16, align = "right"
    })
    lblFecha:setFillColor( .3 )
    scrViewMe:insert( lblFecha )
    
    local lblDe1 = display.newText({
        text = "De: ",     
        x = 90, y = 95, width = 100, 
        font = fLatoBold,
        fontSize = 18, align = "left"
    })
    lblDe1:setFillColor( .3 )
    scrViewMe:insert( lblDe1 )
    
    local lblDe2 = display.newText({
        text = item.from,     
        x = 270, y = 95, width = 300, 
        font = fLatoRegular,
        fontSize = 18, align = "left"
    })
    lblDe2:setFillColor( .3 )
    scrViewMe:insert( lblDe2 )
    
    local lblAsunto1 = display.newText({
        text = "Asunto: ",     
        x = 90, y = 130, width = 100, 
        font = fLatoBold,
        fontSize = 18, align = "left"
    })
    lblAsunto1:setFillColor( .3 )
    scrViewMe:insert( lblAsunto1 )
    
    local lblAsunto2 = display.newText({
        text = item.name,     
        x = 270, y = 130, width = 300, 
        font = fLatoRegular,
        fontSize = 18, align = "left"
    })
    lblAsunto2:setFillColor( .3 )
    scrViewMe:insert( lblAsunto2 )
    
    -- Imagen
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( midW, 160 )
    imgPBig.anchorY = 0
    scrViewMe:insert( imgPBig )
    -- Resize on Reward
    local txtDesc = item.description
    if item.user then
        imgPBig.width = 400
        imgPBig.height = 400
        txtDesc = "Hola, "..item.from.." te compartio la siguiente recompensa: \n\n'"..item.description.."'."
    end
    
    local lastY = 180 + imgPBig.height
    local lblDesc = display.newText({
        text = txtDesc,
        x = midW, y = lastY, width = 400, 
        font = fLatoRegular,
        fontSize = 18, align = "left"
    })
    lblDesc:setFillColor( .3 )
    scrViewMe:insert( lblDesc )
    
    lblDesc.y = lastY + (lblDesc.height/2)
    
    lastY = lastY + lblDesc.height + 10
    
    -- Ir a Reward
    if item.user then
        lastY = lastY + 40
        local bgCommerce = display.newRoundedRect( midW, lastY, 250, 60, 10 )
        bgCommerce:setFillColor( .21 )
        bgCommerce.idReward = item.id
        bgCommerce:addEventListener( 'tap', tapReward)
        scrViewMe:insert(bgCommerce)
        local txtCommerce = display.newText({
            text = "VER DETALLE", 
            x = midW, y = lastY,
            font = fLatoBold,
            fontSize = 18, align = "center"
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
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
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
    RestManager.getMessage(idMessage)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
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