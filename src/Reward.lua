---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
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
local screen, scrViewRe, tools
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

-- Tap commerce event
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Partner" )
    composer.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = { idCommerce = t.idCommerce } } )
    return true
end

-- Crea contenido del Reward
function setReward(item)
    tools:setLoading(false)
    local yPosc = 0
    
    local name = display.newText({
        text = item.commerce,     
        x = midW, y = 25, width = 400, 
        font = native.systemFontBold,   
        fontSize = 22, align = "center"
    })
    name:setFillColor( .3 )
    scrViewRe:insert( name )

    local concept = display.newText({
        text = item.commerceDesc, 
        x = midW, y = 50, width = 400, 
        font = native.systemFont,   
        fontSize = 20, align = "center"
    })
    concept:setFillColor( .68 )
    scrViewRe:insert( concept )
    
    yPosc = 110
    -- Comercio
    local bgCommerce = display.newRoundedRect( 138, yPosc, 196, 60, 10 )
    bgCommerce:setFillColor( .21 )
    bgCommerce.idCommerce = item.idCommerce
    bgCommerce:addEventListener( 'tap', tapCommerce)
    scrViewRe:insert(bgCommerce)
    local txtCommerce = display.newText({
        text = "IR A COMERCIO", 
        x = 138, y = yPosc,
        font = native.systemFontBold,
        fontSize = 18, align = "center"
    })
    txtCommerce:setFillColor( 1 )
    scrViewRe:insert( txtCommerce )
    -- Compartir
    local bgShare = display.newRoundedRect( 342, yPosc, 196, 60, 10 )
    bgShare:setFillColor( .21 )
    scrViewRe:insert(bgShare)
    local leftShare = display.newRoundedRect( 245, yPosc, 60, 60, 10 )
    leftShare.anchorX = 0
    leftShare:setFillColor( .29 )
    scrViewRe:insert(leftShare)
    local fixShare = display.newRect( 285, yPosc, 20, 60 )
    fixShare.anchorX = 0
    fixShare:setFillColor( .29 )
    scrViewRe:insert(fixShare)
    local iconShare = display.newImage("img/icon/iconShare.png")
    iconShare:translate( 275, yPosc )
    scrViewRe:insert( iconShare )
    local txtShare = display.newText({
        text = "COMPARTIR", 
        x = 370, y = yPosc,
        font = native.systemFontBold,
        fontSize = 18, align = "center"
    })
    txtShare:setFillColor( 1 )
    scrViewRe:insert( txtShare )
    
    yPosc = yPosc + 70
    -- Barra Puntos
    local btnPointsBg = display.newRoundedRect( midW, yPosc, 400, 60, 10 )
    btnPointsBg:setFillColor( .91 )
    scrViewRe:insert(btnPointsBg)
    local bgPoints2A = display.newRect( 173, yPosc, 134, 60)
    bgPoints2A.anchorX = 0
    bgPoints2A:setFillColor( .75 )
    scrViewRe:insert(bgPoints2A)
    -- Lineas
    local line1 = display.newLine(173, yPosc-30, 173, 210)
    line1:setStrokeColor( .58, .2 )
    line1.strokeWidth = 2
    scrViewRe:insert(line1)
    local line2 = display.newLine(306, yPosc-30, 306, 210)
    line2:setStrokeColor( .58, .2 )
    line2.strokeWidth = 2
    scrViewRe:insert(line2)
    -- Mis Puntos
    local txtPoints1A = display.newText({
        text = item.userPoints, 
        x = 106, y = yPosc-7, width = 133, 
        font = native.systemFontBold,
        fontSize = 24, align = "center"
    })
    txtPoints1A:setFillColor( 0 )
    scrViewRe:insert( txtPoints1A )
    local txtPoints1B = display.newText({
        text = "MIS PUNTOS", 
        x = 106, y = yPosc+15, width = 133, 
        font = native.systemFont,
        fontSize = 12, align = "center"
    })
    txtPoints1B:setFillColor( .3 )
    scrViewRe:insert( txtPoints1B )
    -- Puntos
    local txtPoints2A = display.newText({
        text = item.points, 
        x = 239, y = yPosc-7, width = 133, 
        font = native.systemFontBold,
        fontSize = 26, align = "center"
    })
    txtPoints2A:setFillColor( 0 )
    scrViewRe:insert( txtPoints2A )
    local txtPoints2B = display.newText({
        text = "VALOR", 
        x = 239, y = yPosc+15, width = 133, 
        font = native.systemFont,
        fontSize = 12, align = "center"
    })
    txtPoints2B:setFillColor( .3 )
    scrViewRe:insert( txtPoints2B )
    -- Action
    local iconRewardCheck1 = display.newImage("img/icon/iconRewardCheck1.png")
    iconRewardCheck1:translate( 373, yPosc - 5 )
    scrViewRe:insert( iconRewardCheck1 )
    local iconRewardCheck2 = display.newImage("img/icon/iconRewardCheck2.png")
    iconRewardCheck2:translate( 373, yPosc )
    scrViewRe:insert( iconRewardCheck2 )
    local txtPoints3 = display.newText({
        text = "", 
        x = 373, y = yPosc+20, width = 133, 
        font = native.systemFont,
        fontSize = 10, align = "center"
    })
    txtPoints3:setFillColor( .3 )
    scrViewRe:insert( txtPoints3 )
    
    yPosc = yPosc + 240
    -- Imagen
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( midW, yPosc )
    imgPBig.width = 400
    imgPBig.height = 400
    scrViewRe:insert( imgPBig )
    
    local iconRewardBig = display.newContainer( 100, 100 )
    iconRewardBig.idReward = item.id
    iconRewardBig:translate( 390, yPosc - 150  )
    scrViewRe:insert( iconRewardBig )
    
    iconRewardBig.img1 = display.newImage("img/icon/iconRewardBig1.png")
    iconRewardBig:insert( iconRewardBig.img1 )
    iconRewardBig.img2 = display.newImage("img/icon/iconRewardBig2.png")
    iconRewardBig:insert( iconRewardBig.img2 )
    if item.id == item.fav  then
        iconRewardBig.img1.alpha = 0
        iconRewardBig.isFav = true
    else
        iconRewardBig.img2.alpha = 0
        iconRewardBig.isFav = false
    end
    
    yPosc = yPosc + 240
    -- Usar Ahora
    local bgUsar = display.newRoundedRect( 138, yPosc, 196, 60, 10 )
    bgUsar:setFillColor( .85 )
    scrViewRe:insert(bgUsar)
    local txtUsar = display.newText({
        text = "USAR AHORA", 
        x = 138, y = yPosc,
        font = native.systemFontBold,
        fontSize = 18, align = "center"
    })
    txtUsar:setFillColor( 1 )
    scrViewRe:insert( txtUsar )
    -- Comprar
    local bgComprar = display.newRoundedRect( 342, yPosc, 196, 60, 10 )
    bgComprar:setFillColor( .85 )
    scrViewRe:insert(bgComprar)
    local leftComprar = display.newRoundedRect( 245, yPosc, 60, 60, 10 )
    leftComprar.anchorX = 0
    leftComprar:setFillColor( .7 )
    scrViewRe:insert(leftComprar)
    local fixComprar = display.newRect( 285, yPosc, 20, 60 )
    fixComprar.anchorX = 0
    fixComprar:setFillColor( .7 )
    scrViewRe:insert(fixComprar)
    local iconBuy = display.newImage("img/icon/iconBuy.png")
    iconBuy:translate( 275, yPosc )
    scrViewRe:insert( iconBuy )
    local txtComprar = display.newText({
        text = "COMPRAR", 
        x = 370, y = yPosc,
        font = native.systemFontBold,
        fontSize = 18, align = "center"
    })
    txtComprar:setFillColor( 1 )
    scrViewRe:insert( txtComprar )
    
    if item.userPoints then
        local points = tonumber(item.points)
        local userPoints = tonumber(item.userPoints)
        -- Usuario con puntos
        if userPoints > points  then
            bgUsar:setFillColor( .15, .72, .91 )
            bgComprar:setFillColor( .15, .72, .91 )
            leftComprar:setFillColor( .2, .77, .96 )
            fixComprar:setFillColor( .2, .77, .96 )
            
            iconRewardCheck1.alpha = 0
        else
            txtPoints3.text = "FALTAN " .. (points-userPoints) .. " PUNTOS"
            iconRewardCheck2.alpha = 0
        end
    end
    
    yPosc = yPosc + 100
    -- Info Adicional
    local bgInfoSw = display.newRoundedRect( midW, yPosc, 400, 120, 10 )
    bgInfoSw:setFillColor( .95 )
    scrViewRe:insert(bgInfoSw)
    local bgInfo = display.newRoundedRect( midW, yPosc, 396, 116, 10 )
    bgInfo:setFillColor( 1 )
    scrViewRe:insert(bgInfo)
    local txtInfo1 = display.newText({
        text = item.name, 
        x = midW, y = yPosc - 25, width = 380, 
        font = native.systemFontBold,
        fontSize = 28, align = "center"
    })
    txtInfo1:setFillColor( .3 )
    scrViewRe:insert( txtInfo1 )
    local txtInfo2 = display.newText({
        text = item.description, 
        x = midW, y = yPosc + 25, width = 380, 
        font = native.systemFont,
        fontSize = 18, align = "center"
    })
    txtInfo2:setFillColor( .3 )
    scrViewRe:insert( txtInfo2 )
    
    yPosc = yPosc + 90
    -- Vigencia
    local PLTime = display.newImage("img/icon/PLTime.png")
    PLTime:translate( 60, yPosc )
    scrViewRe:insert( PLTime )
    local txtVigencia1 = display.newText({
        text = "Vigencia:", 
        x = 160, y = yPosc, width = 150, 
        font = native.systemFont,
        fontSize = 18, align = "left"
    })
    txtVigencia1:setFillColor( .3 )
    scrViewRe:insert( txtVigencia1 )
    local txtVigencia2 = display.newText({
        text = item.vigencia, 
        x = 315, y = yPosc, width = 300, 
        font = native.systemFontBold,
        fontSize = 18, align = "left"
    })
    txtVigencia2:setFillColor( .3 )
    scrViewRe:insert( txtVigencia2 )
    
    yPosc = yPosc + 40
    -- Terminos y Condiciones
    local txtTerminos1 = display.newText({
        text = "Terminos y Condiciones:", 
        x = 240, y = yPosc, width = 400, 
        font = native.systemFont,
        fontSize = 18, align = "left"
    })
    txtTerminos1:setFillColor( .3 )
    scrViewRe:insert( txtTerminos1 )
    local txtTerminos2 = display.newText({
        text = item.terms, 
        x = 240, y = yPosc + 15, width = 400, 
        font = native.systemFont,
        fontSize = 14, align = "left"
    })
    txtTerminos2.anchorY = 0
    txtTerminos2:setFillColor( .3 )
    scrViewRe:insert( txtTerminos2 )
    
    yPosc = txtTerminos2.y + txtTerminos2.height + 30
    scrViewRe:setScrollHeight(yPosc)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    local idReward = event.params.idReward
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
    scrViewRe = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewRe)
    scrViewRe:toBack()
    
    tools:setLoading(true, scrViewRe)
    RestManager.getReward(idReward)
    
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