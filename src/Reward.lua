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
local giftReden = false
local isGift = false

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
-- Muestra el bubble de wallet
-- @param wallet number
------------------------------------
function addB(gift)
    myWallet = myWallet + gift
    tools:showBubble(true)
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
    local serviceName = "facebook"
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
                "http://mytuki.com/rewards/"..idxReward,
            }
        })
    else
        if isSimulator then
        else
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
    if item.status == "-1" then
        isGift = true
    end
    
    local bgTop = display.newRoundedRect(midW, yPosc, 440, 80, 10 )
    bgTop.idCommerce = item.idCommerce
    bgTop:addEventListener( 'tap', tapCommerce)
    bgTop:setFillColor( unpack(cWhite) )
    scrViewRe:insert( bgTop )
    
    local txtInfo1 = display.newText({
        text = item.name, 
        x = midW + 40, y = yPosc-10, width = 320, 
        font = fontSemiBold,
        fontSize = 21, align = "left"
    })
    txtInfo1.anchorY = 1
    txtInfo1:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtInfo1 )
    local name = display.newText({
        text = item.commerce,     
        x = midW + 40, y = yPosc, width = 320, 
        font = fontRegular,
        fontSize = 18, align = "left"
    })
    name:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( name )
    
    
    local txtInfo2 = display.newText({
        text = item.description, 
        x = midW + 40, y = yPosc + 10, width = 320, 
        font = fontRegular,
        fontSize = 14, align = "left"
    })
    txtInfo2.anchorY = 0
    txtInfo2:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtInfo2 )
    
    if txtInfo1.height > 40 then
        txtInfo1.y = yPosc-5
        name.y = yPosc+5
        txtInfo2.y = yPosc+15
    end 
    
    -- Imagen
    yPosc = yPosc + 225
    local bgImage = display.newRoundedRect(midW, yPosc, 440, 330, 5 )
    bgImage:setFillColor( unpack(cBTur) )
    scrViewRe:insert( bgImage )
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( midW, yPosc )
    imgPBig.width = 436
    imgPBig.height = 326
    scrViewRe:insert( imgPBig )
    
    -- Comercio Afiliado
    if item.idCommerce == item.isCommerce then
        -- Fondos Puntos
        yPosc = yPosc + 220
        local bgMyTuks = display.newRoundedRect( midW - 10, yPosc, 210, 90, 5 )
        bgMyTuks.anchorX = 1
        bgMyTuks:setFillColor( unpack(cBTur) )
        scrViewRe:insert(bgMyTuks)
        local bgMyTuksR = display.newRoundedRect( midW - 12, yPosc, 206, 86, 5 )
        bgMyTuksR.anchorX = 1
        bgMyTuksR:setFillColor( unpack(cWhite) )
        scrViewRe:insert(bgMyTuksR)
        local bgTuks = display.newRoundedRect( midW + 10, yPosc, 210, 90, 5 )
        bgTuks.anchorX = 0
        bgTuks:setFillColor( unpack(cBTur) )
        scrViewRe:insert(bgTuks)
        local bgTuksL = display.newRoundedRect( midW + 12, yPosc, 206, 86, 5 )
        bgTuksL.anchorX = 0
        bgTuksL:setFillColor( unpack(cWhite) )
        scrViewRe:insert(bgTuksL)
        -- Mis Puntos
        local txtPoints1A = display.newText({
            text = item.userPoints, 
            x = 120, y = yPosc+10,
            font = fontSemiBold,
            fontSize = 40, align = "center"
        })
        txtPoints1A:setFillColor( unpack(cBPur) )
        scrViewRe:insert( txtPoints1A )
        local txtPoints1B = display.newText({
            text = "TUS TUKS", 
            x = 120, y = yPosc-17,
            font = fontRegular,
            fontSize = 25, align = "center"
        })
        txtPoints1B:setFillColor( unpack(cBPur) )
        scrViewRe:insert( txtPoints1B )
        -- Puntos
        if item.points == "0" then
            local txtPoints2A = display.newText({
                text = "GRATIS", 
                x = 360, y = yPosc,
                font = fontBold,
                fontSize = 32, align = "center"
            })
            txtPoints2A:setFillColor( unpack(cBPur) )
            scrViewRe:insert( txtPoints2A )
        else
            local txtPoints2A = display.newText({
                text = item.points, 
                x = 360, y = yPosc+10,
                font = fontSemiBold,
                fontSize = 40, align = "center"
            })
            txtPoints2A:setFillColor( unpack(cBPur) )
            scrViewRe:insert( txtPoints2A )
            local txtPoints2B = display.newText({
                text = "VALE POR", 
                x = 360, y = yPosc-17,
                font = fontRegular,
                fontSize = 25, align = "center"
            })
            txtPoints2B:setFillColor( unpack(cBPur) )
            scrViewRe:insert( txtPoints2B )
        end
        -- Comprar
        if not(giftReden) then
            yPosc = yPosc + 95
            local bgRedem2 = display.newRoundedRect( midW, yPosc, 440, 70, 5 )
            bgRedem2:setFillColor( {
                type = 'gradient',
                color1 = { unpack(cBBlu) }, 
                color2 = { unpack(cBTur) },
                direction = "right"
            } ) 
            scrViewRe:insert(bgRedem2)
            local bgRedem = display.newRoundedRect( midW, yPosc, 436, 66, 5 )
            bgRedem:setFillColor( unpack(cWhite) )
            scrViewRe:insert(bgRedem)
            local lblRedem = display.newText({
                text = "NO CUENTAS CON SUFICIENTES TUKS", 
                x = midW, y = yPosc,
                font = fontBold,
                fontSize = 20, align = "center"
            })
            lblRedem:setFillColor( unpack(cBTur) )
            scrViewRe:insert( lblRedem )

            -- Validate points
            if tonumber(item.userPoints) >= tonumber(item.points) then
                local lblRedem2 = display.newText({
                    text = "C O M P R A R", 
                    x = midW, y = yPosc,
                    font = fontSemiold,
                    fontSize = 25, align = "center"
                })
                lblRedem2:setFillColor( unpack(cWhite) )
                scrViewRe:insert( lblRedem2 )
                bgRedem.alpha = 0
                lblRedem.alpha = 0
                bgRedem2:addEventListener( 'tap', goToCheckReward)
            end
        end
    -- Comercio NO Afiliado
    else
        -- Fondos Puntos
        yPosc = yPosc + 220
        local bgMyTuks = display.newRoundedRect( midW - 10, yPosc, 210, 90, 5 )
        bgMyTuks.anchorX = 1
        bgMyTuks:setFillColor( unpack(cBTur) )
        scrViewRe:insert(bgMyTuks)
        local bgMyTuksR = display.newRoundedRect( midW - 12, yPosc, 206, 86, 5 )
        bgMyTuksR.anchorX = 1
        bgMyTuksR:setFillColor( unpack(cWhite) )
        scrViewRe:insert(bgMyTuksR)
        local bgTuks = display.newRoundedRect( midW + 10, yPosc, 210, 90, 5 )
        bgTuks.anchorX = 0
        bgTuks:setFillColor( unpack(cBTur) )
        scrViewRe:insert(bgTuks)
        local bgTuksL = display.newRoundedRect( midW + 12, yPosc, 206, 86, 5 )
        bgTuksL.anchorX = 0
        bgTuksL:setFillColor( unpack(cWhite) )
        scrViewRe:insert(bgTuksL)
        
        local txtPoints1A = display.newText({
            text = "AÚN NO ESTAS AFILIADO A ESTE COMERCIO", 
            x = 120, y = yPosc,
            font = fontSemiBold, width = 200,
            fontSize = 20, align = "center"
        })
        txtPoints1A:setFillColor( unpack(cBPur) )
        scrViewRe:insert( txtPoints1A )
        local txtPoints2A = display.newText({
            text = item.points, 
            x = 360, y = yPosc+10,
            font = fontSemiBold,
            fontSize = 40, align = "center"
        })
        txtPoints2A:setFillColor( unpack(cBPur) )
        scrViewRe:insert( txtPoints2A )
        local txtPoints2B = display.newText({
            text = "VALE POR", 
            x = 360, y = yPosc-17,
            font = fontRegular,
            fontSize = 25, align = "center"
        })
        txtPoints2B:setFillColor( unpack(cBPur) )
        scrViewRe:insert( txtPoints2B )

        -- Comprar
        yPosc = yPosc + 95
        local bgRedem3 = display.newRoundedRect( midW, yPosc, 440, 70, 5 )
        bgRedem3:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBBlu) }, 
            color2 = { unpack(cBTur) },
            direction = "right"
        } ) 
        bgRedem3.idCommerce = item.idCommerce
        bgRedem3:addEventListener( 'tap', setCommerceJoin)
        scrViewRe:insert(bgRedem3)
        local lblRedem2 = display.newText({
            text = "¡AFILIATE AHORA!", 
            x = midW, y = yPosc,
            font = fontSemiold,
            fontSize = 25, align = "center"
        })
        lblRedem2:setFillColor( unpack(cWhite) )
        scrViewRe:insert( lblRedem2 )
    end
    
    -- Comercio
    yPosc = yPosc + 90
    local bgCommerce = display.newRect( midW - 120, yPosc, 200, 60 )
    bgCommerce.idCommerce = item.idCommerce
    bgCommerce:addEventListener( 'tap', tapCommerce)
    scrViewRe:insert(bgCommerce)
    local txtCommerce = display.newText({
        text = "CONOCER COMERCIO", 
        x = midW - 75, y = yPosc,
        font = fontSemiBold, width = 120,
        fontSize = 14
    })
    txtCommerce:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtCommerce )
    local icoBtnCommerce = display.newImage( "img/icon/icoBtnCommerce.png" )
    icoBtnCommerce:translate( 60, yPosc )
    scrViewRe:insert( icoBtnCommerce )
   
    -- Compartir
    local bgShare = display.newRect( midW + 120, yPosc, 200, 60 )
    bgShare.item = item
    bgShare:addEventListener( 'tap', doShare)
    scrViewRe:insert(bgShare)
    local txtShare = display.newText({
        text = "COMPARTIR CON MIS AMIGOS", 
        x = midW + 155, y = yPosc,
        font = fontSemiBold, width = 120,
        fontSize = 14
    })
    txtShare:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtShare )
    local icoBtnShare = display.newImage( "img/icon/icoBtnShare.png" )
    icoBtnShare:translate( 290, yPosc )
    scrViewRe:insert( icoBtnShare )
    
    -- Vigencia
    yPosc = yPosc + 70
    local txtVigencia = display.newText({
        text = "Valido al "..item.vigencia, 
        x = 240, y = yPosc, width = 400, 
        font = fontBold,
        fontSize = 18, align = "left"
    })
    txtVigencia:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtVigencia )
    
    -- Terminos y Condiciones
    yPosc = yPosc + 35
    local txtTerminos1 = display.newText({
        text = "Terminos y Condiciones:", 
        x = 240, y = yPosc, width = 400, 
        font = fontRegular,
        fontSize = 18, align = "left"
    })
    txtTerminos1:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtTerminos1 )
    local txtTerminos2 = display.newText({
        text = item.terms, 
        x = 240, y = yPosc + 15, width = 400, 
        font = fontRegular,
        fontSize = 14, align = "left"
    })
    txtTerminos2.anchorY = 0
    txtTerminos2:setFillColor( unpack(cBlueH) )
    scrViewRe:insert( txtTerminos2 )
    
    yPosc = txtTerminos2.y + txtTerminos2.height + 40
    print("setScrollHeight"..yPosc)
    scrViewRe:setScrollHeight(yPosc)
    
    -- Load logo Comercio
    local commerce = {{image = item.comImage}}
    loadImage({idx = 0, name = "RewardLogo", path = "assets/img/api/commerce/", items = commerce})
end
    
function setRewardLogo(item)
    local circleLogo = display.newImage("img/deco/circleLogo80.png")
    circleLogo:translate( 65, 60 )
    scrViewRe:insert( circleLogo )
    
    local mask = graphics.newMask( "img/deco/maskLogo80.png" )
    local imgPBig = display.newImage(item.image, system.TemporaryDirectory)
    imgPBig:translate( 65, 60 )
    imgPBig.height = 80
    imgPBig.width = 80
    imgPBig:setMask( mask )
    scrViewRe:insert( imgPBig )
end

function isRedem()
    local grpIsRedem = display.newGroup()
    grpIsRedem.alpha = 0
    scrViewRe:insert( grpIsRedem )
    
    function setDesR(event)
        return true
    end
    local bgRedem1 = display.newRoundedRect( midW, 590, 440, 60, 10 )
    bgRedem1:setFillColor( unpack(cGrayM) )
    bgRedem1:addEventListener( 'tap', setDesR)
    grpIsRedem:insert(bgRedem1)
    
    local lblRedem = display.newText({
        text = "ESTE ARTICULO YA FUE CANJEADO", 
        x = midW, y = 590,
        font = fontBold,
        fontSize = 24, align = "center"
    })
    lblRedem:setFillColor( unpack(cWhite) )
    grpIsRedem:insert( lblRedem )
    
    transition.to( grpIsRedem, { alpha = 1, time = 1000 })
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    local idReward = event.params.idReward
    giftReden = false
    if event.params.giftReden then
        giftReden = true
    end
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 60 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 120)
    
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
        tools:showBubble(false)
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
        -- Verificar regalos
        --isGift = false
        if isGift and not(giftReden) then
            RestManager.isGiftRedem(idxReward)
        end
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