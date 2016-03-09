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
local fxJoined = audio.loadSound( "fx/join.wav")

-- Grupos y Contenedores
local screen, scrViewRe, tools
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local idxReward

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Consultar comercio
-- @param event objeto evento
------------------------------------
function readyJoined(idCommerce)
    tools:animate()
    timer.performWithDelay( 250, function() audio.play(fxJoined) end )
    timer.performWithDelay( 3000, function() 
        table.remove( Globals.scenes )
        composer.removeScene( "src.Reward" )
        composer.gotoScene("src.Reward", { params = { idReward = idxReward } } )
    end )
    return true
end

-------------------------------------
-- Afiliacion del Comercio
-- @param event objeto evento
------------------------------------
function setCommerceJoin(event)
    local t = event.target
    t:removeEventListener( 'tap', setCommerceJoin)
    t.alpha = .9
    RestManager.setCommerceJoin(t.idCommerce)
    return true
end

-------------------------------------
-- Consultar comercio
-- @param event objeto evento
------------------------------------
function goToCheckReward(event)
    composer.removeScene( "src.CheckReward" )
    composer.gotoScene("src.CheckReward", { params = { idReward = idxReward } } )
    return true
end

-------------------------------------
-- Tap commerce event
-- @param event objeto evento
------------------------------------
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Partner" )
    composer.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = { idCommerce = t.idCommerce } } )
    return true
end

-------------------------------------
-- Executed upon touching and releasing the button created below
-- @param event objeto evento
------------------------------------
local function doShare( event )
    local serviceName = "share"
    local isAvailable = native.canShowPopup( "social", serviceName )
 
    -- If it is possible to show the popup
    if isAvailable then
        local listener = {}
        function listener:popup( event )
            print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )			
        end
 
        -- Show the popup
        native.showPopup( "social",
        {
            service = serviceName, -- The service key is ignored on Android.
            message = "Tuki es un programa de lealtad multi-comercios, con la cual ganarás recompensas por las visitas a tus comercios favoritos.",
            listener = listener,
            image = 
            {
                { filename = event.target.item.image, baseDir = system.TemporaryDirectory },
            },
            url = 
            { 
                "http://www.facebook.com/tukicard",
            }
        })
    else
        if isSimulator then
            native.showAlert( "Build for device", "This plugin is not supported on the Corona Simulator, please build for an iOS/Android device or the Xcode simulator", { "OK" } )
        else
            -- Popup isn't available.. Show error message
            native.showAlert( "Cannot send " .. serviceName .. " message.", "Please setup your " .. serviceName .. " account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
        end
    end
end

-------------------------------------
-- Crea contenido del Reward
-- @param item objeto reward
------------------------------------
function setReward(item)
    tools:setLoading(false)
    local yPosc = 60
    idxReward = item.id
    
    local color = {tonumber(item.colorA1)/255, tonumber(item.colorA2)/255, tonumber(item.colorA3)/255}
    local bgTop = display.newRoundedRect(midW, yPosc, 440, 80, 10 )
    bgTop:setFillColor( color[1], color[2], color[3] )
    scrViewRe:insert( bgTop )
    local bgTopB = display.newRect(midW, yPosc+30, 440, 20 )
    bgTopB:setFillColor( color[1], color[2], color[3] )
    scrViewRe:insert( bgTopB )
    local bgTCover1 = display.newRoundedRect(65, yPosc, 90, 90, 10 )
    bgTCover1:setFillColor( color[1], color[2], color[3] )
    scrViewRe:insert( bgTCover1 )
    local bgTCover2 = display.newRoundedRect(65, yPosc, 82, 82, 10 )
    bgTCover2:setFillColor( unpack(cWhite) )
    scrViewRe:insert( bgTCover2 )
    
    local txtInfo1 = display.newText({
        text = item.name, 
        x = midW + 40, y = yPosc - 15, width = 320, 
        font = fLatoBold,
        fontSize = 21, align = "left"
    })
    txtInfo1:setFillColor( unpack(cWhite) )
    scrViewRe:insert( txtInfo1 )
    local name = display.newText({
        text = item.commerce,     
        x = midW + 40, y = yPosc + 15, width = 320, 
        font = fLatoRegular,
        fontSize = 18, align = "left"
    })
    name:setFillColor( unpack(cWhite) )
    scrViewRe:insert( name )
    
    yPosc = yPosc + 65
    local txtInfo2 = display.newText({
        text = item.description, 
        x = midW, y = yPosc, width = 440, 
        font = fLatoRegular,
        fontSize = 16, align = "left"
    })
    txtInfo2:setFillColor( unpack(cGrayH) )
    scrViewRe:insert( txtInfo2 )
    
    if txtInfo2.height > 22 then
        local addSpc = txtInfo2.height - 20
        yPosc = yPosc + addSpc
        txtInfo2.y = txtInfo2.y  + (addSpc/2)
    end
    
    -- Imagen
    yPosc = yPosc + 190
    local bgImage = display.newRoundedRect(midW, yPosc, 440, 330, 5 )
    bgImage:setFillColor( unpack(cGrayM) )
    scrViewRe:insert( bgImage )
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( midW, yPosc )
    imgPBig.width = 432
    imgPBig.height = 324
    scrViewRe:insert( imgPBig )
    
    -- Comercio Afiliado
    if item.idCommerce == item.isCommerce then
        -- Fondos Puntos
        yPosc = yPosc + 205
        local bgMyTuks = display.newRoundedRect( midW - 10, yPosc, 210, 60, 10 )
        bgMyTuks.anchorX = 1
        bgMyTuks:setFillColor( unpack(cBlueH) )
        scrViewRe:insert(bgMyTuks)
        local bgMyTuksR = display.newRect( midW - 10, yPosc, 40, 60 )
        bgMyTuksR.anchorX = 1
        bgMyTuksR:setFillColor( unpack(cBlueH) )
        scrViewRe:insert(bgMyTuksR)
        local bgTuks = display.newRoundedRect( midW + 10, yPosc, 210, 60, 10 )
        bgTuks.anchorX = 0
        bgTuks:setFillColor( unpack(cBlueH) )
        scrViewRe:insert(bgTuks)
        local bgTuksL = display.newRect( midW + 10, yPosc, 40, 60 )
        bgTuksL.anchorX = 0
        bgTuksL:setFillColor( unpack(cBlueH) )
        scrViewRe:insert(bgTuksL)
        -- Mis Puntos
        local txtPoints1A = display.newText({
            text = item.userPoints, 
            x = 120, y = yPosc-7,
            font = fLatoBold,
            fontSize = 32, align = "center"
        })
        txtPoints1A:setFillColor( unpack(cWhite) )
        scrViewRe:insert( txtPoints1A )
        local txtPoints1B = display.newText({
            text = "MIS PUNTOS", 
            x = 120, y = yPosc+15,
            font = fLatoRegular,
            fontSize = 12, align = "center"
        })
        txtPoints1B:setFillColor( unpack(cWhite) )
        scrViewRe:insert( txtPoints1B )
        -- Puntos
        local txtPoints2A = display.newText({
            text = item.points, 
            x = 360, y = yPosc-7,
            font = fLatoBold,
            fontSize = 32, align = "center"
        })
        txtPoints2A:setFillColor( unpack(cWhite) )
        scrViewRe:insert( txtPoints2A )
        local txtPoints2B = display.newText({
            text = "TUKS", 
            x = 360, y = yPosc+15,
            font = fLatoRegular,
            fontSize = 12, align = "center"
        })
        txtPoints2B:setFillColor( unpack(cWhite) )
        scrViewRe:insert( txtPoints2B )

        -- Comprar
        yPosc = yPosc + 70
        local bgRedem = display.newRoundedRect( midW, yPosc, 440, 60, 10 )
        bgRedem:setFillColor( unpack(cPurpleL) )
        scrViewRe:insert(bgRedem)
        local bgRedemR1 = display.newRoundedRect( 420, yPosc, 80, 60, 10 )
        bgRedemR1:setFillColor( unpack(cPurple) )
        scrViewRe:insert(bgRedemR1)
        local bgRedemR2 = display.newRect( 400, yPosc, 40, 60 )
        bgRedemR2:setFillColor( unpack(cPurple) )
        scrViewRe:insert(bgRedemR2)
        local lblRedem = display.newText({
            text = "COMPRAR", 
            x = midW, y = yPosc,
            font = fLatoBold,
            fontSize = 26, align = "center"
        })
        lblRedem:setFillColor( unpack(cWhite) )
        scrViewRe:insert( lblRedem )
        local menuPoints = display.newImage( "img/icon/menuPoints.png" )
        menuPoints:translate( 420, yPosc )
        scrViewRe:insert( menuPoints )
        
        -- Validate points
        if tonumber(item.userPoints) >= tonumber(item.points) then
            bgRedem:addEventListener( 'tap', goToCheckReward)
        else
            local bgGray = display.newRoundedRect( midW, yPosc, 440, 60, 10 )
            bgGray.alpha = .5
            bgGray:setFillColor( 1 )
            scrViewRe:insert(bgGray)
        end
        
    -- Comercio NO Afiliado
    else
        -- Fondos Puntos
        yPosc = yPosc + 205
        local bgMyTuks = display.newRoundedRect( midW - 70, yPosc, 150, 60, 10 )
        bgMyTuks.anchorX = 1
        bgMyTuks:setFillColor( unpack(cBlueH) )
        scrViewRe:insert(bgMyTuks)
        local bgMyTuksR = display.newRect( midW - 70, yPosc, 40, 60 )
        bgMyTuksR.anchorX = 1
        bgMyTuksR:setFillColor( unpack(cBlueH) )
        scrViewRe:insert(bgMyTuksR)
        -- Mis Puntos
        local txtPoints1A = display.newText({
            text = item.points, 
            x = 100, y = yPosc-7,
            font = fLatoBold,
            fontSize = 32, align = "center"
        })
        txtPoints1A:setFillColor( unpack(cWhite) )
        scrViewRe:insert( txtPoints1A )
        local txtPoints1B = display.newText({
            text = "TUKS", 
            x = 100, y = yPosc+15,
            font = fLatoRegular,
            fontSize = 12, align = "center"
        })
        txtPoints1B:setFillColor( unpack(cWhite) )
        scrViewRe:insert( txtPoints1B )
        local txtJoinMessage = display.newText({
            text = "AÚN NO ESTAS AFILIADO A ESTE COMERCIO", 
            x = midW + 80, y = yPosc,
            width = 200, font = fLatoBold,
            fontSize = 16, align = "center"
        })
        txtJoinMessage:setFillColor( unpack(cGrayH) )
        scrViewRe:insert( txtJoinMessage )

        -- Comprar
        yPosc = yPosc + 70
        local bgRedem = display.newRoundedRect( midW, yPosc, 440, 60, 10 )
        bgRedem:setFillColor( unpack(cPurpleL) )
        bgRedem.idCommerce = item.idCommerce
        bgRedem:addEventListener( 'tap', setCommerceJoin)
        scrViewRe:insert(bgRedem)
        local lblRedem = display.newText({
            text = "¡AFILIATE AHORA!", 
            x = midW, y = yPosc,
            font = fLatoBold,
            fontSize = 26, align = "center"
        })
        lblRedem:setFillColor( unpack(cWhite) )
        scrViewRe:insert( lblRedem )
    end
    
    -- Comercio
    yPosc = yPosc + 70
    local bgCommerce = display.newRect( midW - 120, yPosc, 200, 60 )
    bgCommerce.idCommerce = item.idCommerce
    bgCommerce:addEventListener( 'tap', tapCommerce)
    scrViewRe:insert(bgCommerce)
    local txtCommerce = display.newText({
        text = "IR A COMERCIO", 
        x = midW - 140, y = yPosc,
        font = fLatoBold,
        fontSize = 16, align = "center"
    })
    txtCommerce:setFillColor( unpack(cGrayXH) )
    scrViewRe:insert( txtCommerce )
    local icoBtnCommerce = display.newImage( "img/icon/icoBtnCommerce.png" )
    icoBtnCommerce:translate( 200, yPosc )
    scrViewRe:insert( icoBtnCommerce )
    -- Lineas
    local line1 = display.newLine(midW, yPosc-30, midW, yPosc+30)
    line1:setStrokeColor( .58, .2 )
    line1.strokeWidth = 2
    scrViewRe:insert(line1)
    -- Compartir
    local bgShare = display.newRect( midW + 120, yPosc, 200, 60 )
    bgShare.item = item
    bgShare:addEventListener( 'tap', doShare)
    scrViewRe:insert(bgShare)
    local txtShare = display.newText({
        text = "COMPARTIR", 
        x = midW + 90, y = yPosc,
        font = fLatoBold,
        fontSize = 16, align = "center"
    })
    txtShare:setFillColor( unpack(cGrayXH) )
    scrViewRe:insert( txtShare )
    local icoBtnShare = display.newImage( "img/icon/icoBtnShare.png" )
    icoBtnShare:translate( 410, yPosc )
    scrViewRe:insert( icoBtnShare )
    
    -- Info Adicional
    yPosc = yPosc + 40
    local bgInfoSw = display.newRoundedRect( midW, yPosc, 440, 100, 10 )
    bgInfoSw.anchorY = 0
    bgInfoSw:setFillColor( .95 )
    scrViewRe:insert(bgInfoSw)
    local bgInfo = display.newRoundedRect( midW, yPosc + 2, 436, 96, 10 )
    bgInfo.anchorY = 0
    bgInfo:setFillColor( 1 )
    scrViewRe:insert(bgInfo)
    
    -- Vigencia
    yPosc = yPosc + 30
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
    
    bgInfoSw.height = bgInfoSw.height + txtTerminos2.height
    bgInfo.height = bgInfo.height + txtTerminos2.height
    
    -- Load logo Comercio
    local commerce = {{image = item.comImage}}
    loadImage({idx = 0, name = "RewardLogo", path = "assets/img/api/commerce/", items = commerce})
end
    
function setRewardLogo(item)
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( 65, 60 )
    imgPBig.width = 75
    imgPBig.height = 75
    scrViewRe:insert( imgPBig )
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