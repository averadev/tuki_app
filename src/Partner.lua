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
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local scrViewPa, tools
local yPosc = 0
local idxPartner, usrPoints

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Consultar comercio
-- @param event objeto evento
------------------------------------
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Reward" )
    composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
    return true
end

-------------------------------------
-- Consultar comercio
-- @param event objeto evento
------------------------------------
function readyJoined(idCommerce)
    tools:animate()
    timer.performWithDelay( 250, function() audio.play(fxJoined) end )
    timer.performWithDelay( 3000, function() 
        table.remove( Globals.scenes )
        composer.removeScene( "src.Partner" )
        composer.gotoScene("src.Partner", { params = { idCommerce = idxPartner } } )
    end )
    return true
end

-------------------------------------
-- Fav a la recompensa
-- @param event objeto evento
------------------------------------
function tapComRewFav(event)
    local t = event.target
    audio.play( fxFav )
    if t.iconHeart1.alpha == 0  then
        t.iconHeart1.alpha = 1
        t.iconHeart2.alpha = 0
        t:setFillColor( 236/255 )
        RestManager.setRewardFav(t.idReward, 0)
    else
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
        t:setFillColor( 46/255, 190/255, 239/255 )
        RestManager.setRewardFav(t.idReward, 1)
    end
    return true
end

-------------------------------------
-- Abrimos URL
-- @param event objeto evento
------------------------------------
function openUrl(event)
    local t = event.target
    audio.play(fxTap)
    system.openURL( t.url )
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
    RestManager.setCommerceJoin(idxPartner)
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
-- Mostramos informacion del comercio
-- @param item comercio
-- @param rewards recompensas
------------------------------------
function setCommerce(item, rewards)
    tools:setLoading(false)
    
    yPosc = 20
    idxPartner = item.id
    if item.points then
        usrPoints = tonumber(item.points)
    end
    local color = {tonumber(item.colorA1)/255, tonumber(item.colorA2)/255, tonumber(item.colorA3)/255}
    local bgTop = display.newRoundedRect(midW, yPosc, 440, 80, 10 )
    bgTop.anchorY = 0
    bgTop:setFillColor( color[1], color[2], color[3] )
    scrViewPa:insert( bgTop )
    local banner = display.newImage( item.banner, system.TemporaryDirectory )
    banner.anchorY = 0
    banner.height = 280
    banner.width = 440
    banner:translate( midW, yPosc + 73 )
    scrViewPa:insert( banner )
    local bottomRounded = display.newImage("img/deco/bottomRounded.png")
    bottomRounded:translate(midW, yPosc + 335)
    scrViewPa:insert( bottomRounded )
    local bgTCover1 = display.newRoundedRect(70, yPosc - 6, 110, 110, 10 )
    bgTCover1.anchorY = 0
    bgTCover1:setFillColor( color[1], color[2], color[3] )
    scrViewPa:insert( bgTCover1 )
    local bgTCover2 = display.newRoundedRect(70, yPosc - 2, 102, 102, 10 )
    bgTCover2.anchorY = 0
    bgTCover2:setFillColor( 1 )
    scrViewPa:insert( bgTCover2 )
    local img = display.newImage( item.image, system.TemporaryDirectory )
    img.anchorY = 0
    img.height = 95
    img.width = 95
    img:translate( 70, yPosc + 2 )
    scrViewPa:insert( img )
    
    local txtCommerce = display.newText({
        text = item.name,
        y = yPosc + 27,
        x = midW + 60, width = 340,
        font = fLatoBold,   
        fontSize = 30, align = "left"
    })
    txtCommerce:setFillColor( unpack(cWhite) )
    scrViewPa:insert(txtCommerce)
    local txtCommerceDesc = display.newText({
        text = item.description,
        y = yPosc + 55,
        x = midW + 63, width = 340,
        font = fLatoItalic,   
        fontSize = 18, align = "left"
    })
    txtCommerceDesc:setFillColor( unpack(cWhite) )
    scrViewPa:insert(txtCommerceDesc)
    
    -- Detalle afiliado
    yPosc = yPosc + 365
    if item.points then
        local container = display.newContainer( 440, 94 )
        container.anchorY = 0
        container:translate( midW, yPosc )
        scrViewPa:insert( container )
        
        local bgCom1 = display.newRect(0, 0, intW - 40, 94 )
        bgCom1:setFillColor( unpack(cGrayXL) )
        container:insert(bgCom1)
        local bgCom2 = display.newRect(0, 0, intW - 44, 90 )
        bgCom2:setFillColor( 1 )
        container:insert(bgCom2)

        local bgTuks1 = display.newRect(-158, 0, 120, 90 )
        bgTuks1:setFillColor( unpack(cTurquesa) )
        container:insert(bgTuks1)
        local bgTuks2 = display.newRect(-158, 0, 116, 86 )
        bgTuks2:setFillColor( unpack(cBlueH) )
        container:insert(bgTuks2)

        local bgDesc1 = display.newRect(-86, -30, 313, 30 )
        bgDesc1.anchorX = 0
        bgDesc1:setFillColor( unpack(cGrayXXL) )
        container:insert(bgDesc1)
        local bgDesc2 = display.newRect(-86, 30, 313, 30 )
        bgDesc2.anchorX = 0
        bgDesc2:setFillColor( unpack(cGrayXXL) )
        container:insert(bgDesc2)

        -- Descripciones
        local lblDescT = display.newText({
            text = "TUKS", 
            x = -158, y = 23, width = 70, 
            font = fLatoBold,   
            fontSize = 23, align = "center"
        })
        lblDescT:setFillColor( 1 )
        container:insert( lblDescT )
        local lblDesc1 = display.newText({
            text = "Recompensas Disponibles", 
            x = 60, y = -30, width = 200, 
            font = fLatoRegular,   
            fontSize = 14, align = "left"
        })
        lblDesc1:setFillColor( unpack(cGrayH) )
        container:insert( lblDesc1 )
        local lblDesc2 = display.newText({
            text = "Visitas Realizadas", 
            x = 60, y = 0, width = 200, 
            font = fLatoRegular,   
            fontSize = 14, align = "left"
        })
        lblDesc2:setFillColor( unpack(cGrayH) )
        container:insert( lblDesc2 )
        local lblDesc3 = display.newText({
            text = "Ultima Visita", 
            x = 60, y = 30, width = 200, 
            font = fLatoRegular,   
            fontSize = 14, align = "left"
        })
        lblDesc3:setFillColor( unpack(cGrayH) )
        container:insert( lblDesc3 )
        local Account01 = display.newImage("img/icon/Account01.png")
        Account01:translate(-64, -30)
        container:insert( Account01 )
        local Account02 = display.newImage("img/icon/Account02.png")
        Account02:translate(-64, 0)
        container:insert( Account02 )
        local Account03 = display.newImage("img/icon/Account03.png")
        Account03:translate(-64, 30)
        container:insert( Account03 )

        --- Valores
        local lblTuks = display.newText({
            text = item.points, 
            x = -158, y = -12, width = 70, 
            font = fLatoBold,   
            fontSize = 40, align = "center"
        })
        lblTuks:setFillColor( 1 )
        container:insert( lblTuks )
        local xSpc = 125
        if tonumber(item.rewards) > 9 then
            xSpc = 117
        end
        local lblValue0 = display.newText({
            text = item.avaliable, 
            x = xSpc, y = -30, width = 150, 
            font = fLatoBold,   
            fontSize = 14, align = "right"
        })
        lblValue0:setFillColor( unpack(cPurpleL) )
        container:insert( lblValue0 )
        local lblValue1 = display.newText({
            text = "/"..item.rewards, 
            x = 140, y = -30, width = 150, 
            font = fLatoRegular,   
            fontSize = 14, align = "right"
        })
        lblValue1:setFillColor( unpack(cGrayH) )
        container:insert( lblValue1 )
        local lblValue2 = display.newText({
            text = item.visits, 
            x = 140, y = 0, width = 150, 
            font = fLatoBold,   
            fontSize = 14, align = "right"
        })
        lblValue2:setFillColor( unpack(cPurpleL) )
        container:insert( lblValue2 )
        if item.lastVisit then 
            local lblValue3 = display.newText({
                text = item.lastVisit, 
                x = 140, y = 30, width = 150, 
                font = fLatoBold,   
                fontSize = 14, align = "right"
            })
            lblValue3:setFillColor( unpack(cPurpleL) )
            container:insert( lblValue3 )
        end
        yPosc = yPosc + 105
    end
    
    
    -- Description
    yPosc = yPosc
    local txtCommerceDetail = display.newText({
        text = item.detail,
        y = yPosc + 10,
        x = midW, width = 420,
        font = fLatoItalic,   
        fontSize = 18, align = "left"
    })
    txtCommerceDetail.anchorY = 0
    txtCommerceDetail:setFillColor( unpack(cGrayXH) )
    scrViewPa:insert(txtCommerceDetail)
    
    -- Contact Information
    yPosc = yPosc + txtCommerceDetail.height + 50
    local icoCom1 = display.newImage("img/icon/icoCom1.png")
    icoCom1:translate(midW - 200, yPosc)
    scrViewPa:insert( icoCom1 )
    local txtContact1 = display.newText({
        text = item.address,
        y = yPosc,
        x = midW + 25, width = 400,
        font = fLatoBold,   
        fontSize = 18, align = "left"
    })
    txtContact1:setFillColor( unpack(cGrayXH) )
    scrViewPa:insert(txtContact1)
    if txtContact1.height > 35 then
        yPosc = yPosc + 13
    end
    if item.phone then
        yPosc = yPosc + 35
        local icoCom2 = display.newImage("img/icon/icoCom2.png")
        icoCom2:translate(midW - 200, yPosc)
        scrViewPa:insert( icoCom2 )
        local txtContact2 = display.newText({
            text = item.phone,
            y = yPosc,
            x = midW + 25, width = 400,
            font = fLatoBold,   
            fontSize = 18, align = "left"
        })
        txtContact2.url = "tel:"..item.phone
        txtContact2:addEventListener( 'tap', openUrl)
        txtContact2:setFillColor( unpack(cGrayXH) )
        scrViewPa:insert(txtContact2)
    end
    if item.web then
        yPosc = yPosc + 35
        local icoCom3 = display.newImage("img/icon/icoCom3.png")
        icoCom3:translate(midW - 200, yPosc + 3)
        scrViewPa:insert( icoCom3 )
        local txtContact3 = display.newText({
            text = item.web,
            y = yPosc,
            x = midW + 25, width = 400,
            font = fLatoBold,   
            fontSize = 18, align = "left"
        })
        txtContact3.url = item.web
        txtContact3:addEventListener( 'tap', openUrl)
        txtContact3:setFillColor( unpack(cGrayXH) )
        scrViewPa:insert(txtContact3)
    end
    
    -- Afiliarse
    if not(item.points) then
        yPosc = yPosc + 60
        local bgRedem = display.newRoundedRect( midW, yPosc, 440, 60, 10 )
        bgRedem:setFillColor( unpack(cPurpleL) )
        bgRedem:addEventListener( 'tap', setCommerceJoin)
        scrViewPa:insert(bgRedem)
        local bgRedemL1 = display.newRoundedRect( midW + 180, yPosc, 80, 60, 10 )
        bgRedemL1:setFillColor( unpack(cPurple) )
        scrViewPa:insert(bgRedemL1)
        local bgRedemL2 = display.newRect( midW + 170, yPosc, 60, 60 )
        bgRedemL2:setFillColor( unpack(cPurple) )
        scrViewPa:insert(bgRedemL2)
        local iconAfil = display.newImage("img/icon/iconAfil.png")
        iconAfil:translate(midW + 180, yPosc)
        scrViewPa:insert( iconAfil )
        local lblRedem = display.newText({
            text = "¡AFILIATE AHORA!", 
            x = midW - 25, y = yPosc,
            font = fLatoBold,
            fontSize = 26, align = "center"
        })
        lblRedem:setFillColor( unpack(cWhite) )
        scrViewPa:insert( lblRedem )
    end
    
    yPosc = yPosc + 50
    local bgTitle1 = display.newRect( midW, yPosc, intW, 30 )
    bgTitle1:setFillColor( unpack(cBlueH) )
    scrViewPa:insert( bgTitle1 )

    local lblTitle1 = display.newText({
        text = "RECOMPENSAS DISPONIBLES",     
        x = midW, y = yPosc, width = 460,
        font = native.systemFont,
        fontSize = 15, align = "left"
    })
    lblTitle1:setFillColor( 1 )
    scrViewPa:insert(lblTitle1)
    
    yPosc = yPosc + 75
    for z = 1, #rewards, 1 do 
        newReward(rewards[z], yPosc, item.points)
        yPosc = yPosc + 95
    end
    
    -- Set new scroll position
    scrViewPa:setScrollHeight( yPosc )
end

-- Creamos lista de comercios
function newReward(reward, lastYP, cpoints)
    
    container = display.newContainer( 462, 95 )
    container:translate( midW, lastYP )
    scrViewPa:insert( container )

    local bg1 = display.newRect(0, 0, intW - 20, 80 )
    bg1:setFillColor( 236/255 )
    container:insert( bg1 )
    local bg2 = display.newRect(0, 0, intW - 24, 76 )
    bg2:setFillColor( 1 )
    container:insert( bg2 )
    bg2.idReward = reward.id
    bg2:addEventListener( 'tap', tapReward)

    local bgFav = display.newRect(-196, 0, 60, 74 )
    bgFav:setFillColor( 236/255 )
    container:insert( bgFav )
    bgFav.idReward = reward.id
    bgFav:addEventListener( 'tap', tapComRewFav)
    local bgPoints = display.newRect(-126, 0, 80, 74 )
    bgPoints:setFillColor( unpack(cBlueH) )
    container:insert( bgPoints )

    bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
    bgFav.iconHeart1:translate( -196, 0 )
    container:insert( bgFav.iconHeart1 )

    bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
    bgFav.iconHeart2:translate( -196, 0 )
    container:insert( bgFav.iconHeart2 )

    -- Fav actions
    if reward.id == reward.fav  then
        bgFav.id = reward.id 
        bgFav:setFillColor( 46/255, 190/255, 239/255 )
        bgFav.iconHeart1.alpha = 0
    else
        bgFav.iconHeart2.alpha = 0
    end

    -- Textos y descripciones
    if reward.points == 0 or reward.points == "0" then
        local points = display.newText({
            text = "GRATIS", 
            x = -127, y = 0,
            font = native.systemFontBold,   
            fontSize = 20, align = "center"
        })
        points:rotate( -45 )
        points:setFillColor( 1 )
        container:insert( points )
    else
        local points = display.newText({
            text = reward.points, 
            x = -126, y = -7,
            font = native.systemFontBold,   
            fontSize = 26, align = "center"
        })
        points:setFillColor( 1 )
        container:insert( points )
        local points2 = display.newText({
            text = "PUNTOS", 
            x = -126, y = 18,
            font = native.systemFontBold,   
            fontSize = 14, align = "center"
        })
        points2:setFillColor( 1 )
        container:insert( points2 )
    end

    local name = display.newText({
        text = reward.name, 
        x = 70, y = 0, width = 280,
        font = native.systemFont,   
        fontSize = 19, align = "left"
    })
    name:setFillColor( .3 )
    container:insert( name )

    -- Set value Progress Bar
    if usrPoints then
        -- Progress Bar
        local progressBar = display.newRect( 0, 0, 300, 5 )
        progressBar:setFillColor( {
            type = 'gradient',
            color1 = { .6, .5 }, 
            color2 = { 1, .5 },
            direction = "bottom"
        } ) 
        progressBar:translate( 70, 30 )
        container:insert(progressBar)

        local points = tonumber(reward.points)
        -- Usuario con puntos
        if usrPoints > 0 or points == 0  then
            local porcentaje, color1, color2

            -- Todos los puntos                
            if points <= usrPoints  then
                porcentaje = 1
                color1 = { 157/255, 210/255, 25/255, 1 }
                color2 = { 140/255, 242/255, 14/255, .3 }
            else
                porcentaje  = usrPoints/points
                -- Colores
                if porcentaje <= .33 then
                    color1 = { 210/255, 70/255, 27/255, 1 }
                    color2 = { 242/255, 34/255, 12/255, .3 }
                elseif porcentaje <= .66 then
                    color1 = { 242/255, 112/255, 12/255, 1 }
                    color2 = { 210/255, 141/255, 27/255, .3 }
                elseif porcentaje > .66 then
                    color1 = { 250/255, 214/255, 67/255, 1 }
                    color2 = { 202/255, 127/255, 13/255, .3 }
                end
            end

            local progressBar2 = display.newRect( 0, 0, 300*porcentaje, 5 )
            progressBar2:setFillColor( {
                type = 'gradient',
                color1 = color1, 
                color2 = color2,
                direction = "top"
            } ) 
            progressBar2.anchorX = 0
            progressBar2:translate( -80, 30 )
            container:insert(progressBar2)
        end
    end
    
end

function setCommercePhotos(photos)
    -- yPosc
    if #photos > 0 then
        if #photos == 1 then
            yPosc = yPosc - 15
            local bgTitle1 = display.newRect( midW, yPosc, intW, 30 )
            bgTitle1:setFillColor( unpack(cBlueH) )
            scrViewPa:insert( bgTitle1 )

            local lblTitle1 = display.newText({
                text = "GALERIA",     
                x = midW, y = yPosc, width = 460,
                font = native.systemFont,
                fontSize = 15, align = "left"
            })
            lblTitle1:setFillColor( 1 )
            scrViewPa:insert(lblTitle1)
            yPosc = yPosc + 30
            
            local img = display.newImage( photos[1].image, system.TemporaryDirectory )
            img.anchorY = 0
            img.height = 345
            img.width = 460
            img:translate( midW, yPosc )
            scrViewPa:insert( img )
            
            -- Set new scroll position
            scrViewPa:setScrollHeight( yPosc + 365 )
        else
            yPosc = yPosc - 15
            local bgTitle1 = display.newRect( midW, yPosc, intW, 30 )
            bgTitle1:setFillColor( unpack(cBlueH) )
            scrViewPa:insert( bgTitle1 )

            local lblTitle1 = display.newText({
                text = "GALERIA",     
                x = midW, y = yPosc, width = 460,
                font = native.systemFont,
                fontSize = 15, align = "left"
            })
            lblTitle1:setFillColor( 1 )
            scrViewPa:insert(lblTitle1)
            yPosc = yPosc + 30
            scrViewPhotos = widget.newScrollView
            {
                top = yPosc,
                left = 0,
                width = display.contentWidth,
                height = 260,
                verticalScrollDisabled = true,
                backgroundColor = { .91 }
            }
            scrViewPa:insert(scrViewPhotos)

            for z = 1, #photos, 1 do 
                local img = display.newImage( photos[z].image, system.TemporaryDirectory )
                img.anchorX = 1
                img.anchorY = 0
                img:translate( (z * 330), 10 )
                scrViewPhotos:insert( img )
            end
            
            -- Set new scroll position
            scrViewPhotos:setScrollWidth( (#photos * 330) + 10 )
            scrViewPa:setScrollHeight( yPosc + 280 )
        end
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    local idCommerce = event.params.idCommerce
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
    scrViewPa = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewPa)
    scrViewPa:toBack()
    
    tools:setLoading(true, scrViewPa)
    RestManager.getCommerce(idCommerce)
    
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
    if scrViewPhotos then
        scrViewPhotos:removeSelf()
        scrViewPhotos = nil;
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene