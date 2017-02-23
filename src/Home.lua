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
local composer = require( "composer" )
local RestManager = require( "src.RestManager" )
local Globals = require( "src.Globals" )
local widget = require( "widget" )
local fxFav = audio.loadSound( "fx/fav.wav")
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, workSite
local scene = composer.newScene()


-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight
local bgM, tools, grpElemns
local currentCard = 1
local isDown = true
local isCard, doFlow, direction, detailBox
local txtPoints, txtTuks, txtPoints2, txtName, txtCommerce, iconRewardBig, btnDetail
local yItem, itemSize, itemCoverSize, cTuks1, cTuks2, scrViewCM
local cards, idxA, favH, favOn, favOff
local wCmp, hCmp, midSize, currentPH
local initHY

-- Arrays
local cardL = {}
local cardR = {}
local comRews = {}
local coverHComer = {}
local rewardsH
local footer, curLogo, bgTCover1, bgTop


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-------------------------------------
-- Tap en fav, realiza fav del reward
-- @param event objeto evento
------------------------------------
function tapFavHome(event)
    local t = event.target
    audio.play( fxFav )
    if rewardsH[idxA].id == rewardsH[idxA].fav  then
        favOff.alpha = .8
        favOn.alpha = 0
        rewardsH[idxA].fav = nil
        RestManager.setRewardFav(rewardsH[idxA].id, 0)
    else
        favOff.alpha = 0
        favOn.alpha = .8
        rewardsH[idxA].fav = rewardsH[idxA].id
        RestManager.setRewardFav(rewardsH[idxA].id, 1)
    end
    return true
end

-------------------------------------
-- Tap en Reward, cambio de pantalla
-- @param event objeto evento
------------------------------------
function tapReward(event)
    if isDown then
        local t = event.target
        audio.play( fxTap )
        composer.removeScene( "src.Reward" )
        composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = rewardsH[idxA].id } } )
    end
    return true
end

-------------------------------------
-- Tap en puntos, cambio de pantalla a Comercio
-- @param event objeto evento
------------------------------------
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    print("Partner")
    composer.removeScene( "src.Partner" )
    composer.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = { idCommerce = comRews[currentPH].id } } )
    return true
end

-------------------------------------
-- Selecciona el comercio
-- @param event objeto evento
------------------------------------
function getHPartner(event)
    if not(event.target.active) then
        idx = event.target.idx
        currentPH = idx
        
        local circleLogo = display.newImage("img/deco/circleLogo80.png")
        circleLogo:translate( midW-midSize+40, h + 255 )
        workSite:insert( circleLogo )
        
        local mask = graphics.newMask( "img/deco/maskLogo80.png" )
        curLogo = display.newImage( comRews[idx].image, system.TemporaryDirectory )
        curLogo:setMask( mask )
        curLogo:translate( midW-midSize+40, h + 255 )
        curLogo.height = 80
        curLogo.width = 80
        workSite:insert(curLogo)
        txtCommerce.text = comRews[idx].name
        txtCommerceDesc.text = comRews[idx].description
        loadImage({idx = 0, name = "HomeRewards", path = "assets/img/api/rewards/", items = comRews[idx].rewards})
    end
end

-------------------------------------
-- Muestra logos de comercios
-- @param obj info del WS
------------------------------------
function getCarCom(items)
    comRews = items
    
    for z = 1, #comRews, 1 do 
        local xPosc = (z * 100) - 40

        coverHComer[z] = display.newContainer( 95, 95 )
        coverHComer[z].idx = z
        coverHComer[z].active = false
        coverHComer[z]:translate( xPosc, 60 )
        scrViewCM:insert( coverHComer[z] )
        coverHComer[z]:addEventListener( 'tap', getHPartner)
        
        local txt = display.newText({
            text = comRews[z].name, 
            x = xPosc, y = 115, width = 98,
            font = fontSemiBold,   
            fontSize = 12, align = "center"
        })
        txt:setFillColor( .4 )
        scrViewCM:insert( txt )
        
        local circleLogo = display.newImage("img/deco/circleLogo80.png")
        circleLogo:translate( 0, 0 )
        coverHComer[z]:insert( circleLogo )
        
        local mask = graphics.newMask( "img/deco/maskLogo80.png" )
        coverHComer[z].img = display.newImage( comRews[z].image, system.TemporaryDirectory )
        coverHComer[z].img:setMask( mask )
        coverHComer[z].img:translate(0, 0)
        coverHComer[z].img.height = 80
        coverHComer[z].img.width = 80
        coverHComer[z]:insert( coverHComer[z].img )
    end
    -- Call first partner
    getHPartner({target = coverHComer[1]})
    
    if #comRews < 4 then
        scrViewCM:setIsLocked( true )
    else
        -- Set new scroll position
        scrViewCM:setScrollWidth((100 * #comRews) + 20)
    end
    
    if not(oneSignalId == 0) then
        RestManager.updateOneSignalId(oneSignalId)
    end
end

-------------------------------------
-- Genera tarjetas de rewards
-- @param obj info del WS
------------------------------------
function buildCardsR(items)
    -- Clear past
    for i = 1, #cardL, 1 do
        if cardL[i] then
            cardL[i]:removeSelf()
            cardL[i] = nil;
        end
        if cardR[i] then
            cardR[i]:removeSelf()
            cardR[i] = nil;
        end
    end
    
    rewardsH = items
    for i = 1, #rewardsH, 1 do
        buildCard(rewardsH[i])
    end
    
    idxA = 1
    cardL[idxA].alpha = 1
    cardR[idxA].alpha = 1
    setRewardDetail(idxA)
    tools:setLoading(false)
    screen:addEventListener( "touch", touchScreen )
    doFlow = true
end

-------------------------------------
-- Actualiza la informacion de la recompensa
-- @param item registro que incluye la info del reward
------------------------------------
function showHElments(vAlpha)
    txtPoints.alpha = vAlpha
    txtTuks.alpha = vAlpha
    txtName.alpha = vAlpha
end

-------------------------------------
-- Muestra el bubble de wallet
-- @param wallet number
------------------------------------
function showB(wallet, message)
    myWallet = wallet
    myMessages = message
    tools:showBubble(true)
end

-------------------------------------
-- Actualiza la informacion de la recompensa
-- @param item registro que incluye la info del reward
------------------------------------
function setRewardDetail(idx)
    txtPoints.text = rewardsH[idx].points
    txtName.text = rewardsH[idx].name
    -- Fav actions
    if rewardsH[idx].id == rewardsH[idx].fav  then
        favOff.alpha = 0 
        favOff.active = false
        favOn.alpha = .7
        favOn.active = true
    else
        favOff.alpha = .7
        favOff.active = true
        favOn.alpha = 0 
        favOn.active = false
    end
end

-------------------------------------
-- Muestra imagenes y mascaras
-- @param item registro que incluye el nombre de la imagen
------------------------------------
function buildCard(item)
    local idx = #cardL + 1
    local imgS = graphics.newImageSheet( item.image, system.TemporaryDirectory, { width = 220, height = 330, numFrames = 2 })
    
    cardL[idx] = display.newRect( midW, h + 310, wCmp/2, hCmp )
    cardL[idx].alpha = 0
    cardL[idx].anchorY = 0
    cardL[idx].anchorX = 1
    cardL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    cards:insert(cardL[idx])
    
    cardR[idx] = display.newRect( midW, h + 310, wCmp/2, hCmp )
    cardR[idx].alpha = 0
    cardR[idx].anchorY = 0
    cardR[idx].anchorX = 0
    cardR[idx].fill = { type = "image", sheet = imgS, frame = 2 }
    cards:insert(cardR[idx])
    
end

-------------------------------------
-- Listener para el flip del reward
-- @param event objeto evento
------------------------------------
function touchScreen(event)
    if event.phase == "began" and doFlow and workSite.y == 0 then
        if event.yStart > 140 and event.yStart < 820 then
            doFlow = false
            isCard = true
            direction = 0
        end
    elseif event.phase == "moved" and (isCard) then
        local x = (event.x - event.xStart)
        local xM = (x * 1.5)
        local vAlpha = (xM/200)
        if direction == 0 then
            if x < -10 and idxA < #rewardsH then
                direction = 1
                cardR[idxA+1]:toBack()
                cardR[idxA+1].alpha = 1
                cardR[idxA+1].width = midSize
            elseif x > 10 and idxA > 1 then
                direction = -1
                cardL[idxA-1]:toBack()
                cardL[idxA-1].alpha = 1
                cardL[idxA-1].width = midSize
            end
        elseif direction == 1 and x <= 0 and xM >= -wCmp then
            vAlpha = 1+vAlpha
            if (vAlpha<=1) then
                showHElments(vAlpha)
            end
            if xM > -midSize then
                if cardR[idxA].alpha == 0 then
                    cardL[idxA+1].alpha = 0
                    cardR[idxA].alpha = 1
                    cardR[idxA].width = 0
                end
                -- Move current to left
                cardR[idxA].width = midSize + xM
            else
                if cardL[idxA+1].alpha == 0 then
                    cardR[idxA].alpha = 0
                    cardL[idxA+1]:toFront()
                    cardL[idxA+1].alpha = 1
                    cardL[idxA+1].width = 0
                end
                -- Move new to left
                cardL[idxA+1].width = (xM*-1)-midSize
            end
        elseif direction == -1 and x >= 0 then
            vAlpha = 1-vAlpha
            if (vAlpha>0) then
                showHElments(vAlpha)
            end
            if xM < midSize then
                if cardL[idxA].alpha == 0 then
                    cardR[idxA-1].alpha = 0
                    cardL[idxA].alpha = 1
                    cardL[idxA].width = 0
                end
                -- Move current to left
                cardL[idxA].width = midSize - xM
            elseif xM < wCmp then
                if cardR[idxA-1].alpha == 0 then
                    cardL[idxA].alpha = 0
                    cardR[idxA-1]:toFront()
                    cardR[idxA-1].alpha = 1
                    cardR[idxA-1].width = 0
                end
                -- Move new to left
                cardR[idxA-1].width = xM - midSize
            end
            
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local xM = ((event.x - event.xStart) * 3)
        -- To Rigth
        if direction == 1 and xM >= -wCmp then
            cardR[idxA].alpha = 1
            cardL[idxA+1].alpha = 0
            transition.to( cardR[idxA], { width = midSize, time = 200, onComplete=function()
                cardR[idxA+1].alpha = 0
                doFlow = true
            end})
        elseif direction == 1 and xM < -wCmp then
            cardR[idxA].alpha = 0
            cardL[idxA+1].alpha = 1
            setRewardDetail(idxA+1)
            transition.to( cardL[idxA+1], { width = midSize, time = 200, onComplete=function()
                cardL[idxA].alpha = 0
                cardR[idxA].alpha = 0
                idxA = idxA + 1
                doFlow = true
            end})
        else
            -- To Left
            if direction == -1 and xM <= wCmp then
                cardL[idxA].alpha = 1
                cardR[idxA-1].alpha = 0
                transition.to( cardL[idxA], { width = midSize, time = 200, onComplete=function()
                    cardR[idxA-1].alpha = 0
                    doFlow = true
                end})
            elseif direction == -1 and xM > wCmp then
                cardL[idxA].alpha = 0
                cardR[idxA-1].alpha = 1
                setRewardDetail(idxA-1)
                transition.to( cardR[idxA-1], { width = midSize, time = 200, onComplete=function()
                    cardL[idxA].alpha = 0
                    cardR[idxA].alpha = 0
                    idxA = idxA - 1
                    doFlow = true
                end})
            else
                doFlow = true
            end
        end
        
        showHElments(1)
        isCard = false
        direction = 0
    end
end

-------------------------------------
-- Get current position
-- @param event objeto evento
------------------------------------
local getGPS = function( event )

    -- Check for error (user may have turned off location services)
    if ( event.errorCode ) then
        print( "Location error: " .. tostring( event.errorMessage ) )
    else
        print("latitude "..event.latitude)
        print("longitude "..event.longitude)
        --RestManager.getHomeRewardsGPS()
		Runtime:removeEventListener( "location", getGPS )
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    
    -- Background
    bgM = display.newRect(midW, midH, intW, intH )
    bgM.alpha = .01
    screen:insert(bgM)
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    scrViewCM = widget.newScrollView {
        top = h + 60,
        left = 0,
        width = intW,
        height = 130,
        verticalScrollDisabled = true,
		backgroundColor = { unpack(cGrayXXL) }
    }
    screen:insert(scrViewCM)
    
    -- Tamaños y posicones
    initHY  = h + 220 
    allH = intH - h
    wCmp, hCmp = 440, 330
    wCTitle, rLRest, hHPoints, yHPoints, hHTuks, xxLCircle = 0, 0, 0, 0, 0, 0
    -- Footer
    isFooter = true
    if allH <= 750 then
        isFooter = false
    end
    -- Resize Cmp
    if allH <= 685 then
        wCTitle, rLRest, hHPoints, yHPoints, hHTuks, xxLCircle = 100, 30, 15, 10, 8, 20
        wCmp, hCmp, hHPoints = 320, 240, 20
    elseif allH <= 780 then
        wCTitle, rLRest, hHPoints, yHPoints, hHTuks = 45, 20, 15, 10, 8
        wCmp, hCmp, hHPoints = 380, 285, 20
    end
    midSize = wCmp/2
    
    -- Contenedor area de trabajo
    workSite = display.newGroup()
    screen:insert(workSite)
    
    local bgGrayT = display.newRect(midW - 15, initHY + 35, 400, 80 )
    bgGrayT:setFillColor( unpack(cWhite) )
    bgGrayT:addEventListener( 'tap', tapCommerce) 
    workSite:insert( bgGrayT )
    
    local bgGray = display.newRect(midW, initHY + 90,  wCmp + 4, hCmp + 70 )
    bgGray.anchorY = 0
    bgGray:setFillColor( unpack(cWhite) )
    bgGray:addEventListener( 'tap', tapReward) 
    workSite:insert( bgGray )
    cards = display.newGroup()
    workSite:insert(cards)
    
    txtCommerce = display.newText({
        text = '',
        y = initHY + 25,
        x = midW + 50, width = 350 - wCTitle,
        font = fontSemiBold,   
        fontSize = 35, align = "left"
    })
    txtCommerce:setFillColor( unpack(cBlueH) )
    workSite:insert(txtCommerce)
    txtCommerceDesc = display.newText({
        text = '',
        y = initHY + 55,
        x = midW + 53, width = 350 - wCTitle,
        font = fontLight,   
        fontSize = 18, align = "left"
    })
    txtCommerceDesc:setFillColor( unpack(cBlueH) )
    workSite:insert(txtCommerceDesc)
    
    -- Favs
    favH = display.newGroup()
    favH:translate( midW + (hCmp/2), initHY + 120 )
    workSite:insert(favH)
    local bgFav = display.newRect( 0, 0, 60, 60 )
    bgFav.alpha = .01
    bgFav:addEventListener( 'tap', tapFavHome) 
    favH:insert( bgFav )
    favOn = display.newImage("img/icon/iconRewardHeart2.png")
    favOn:scale( 1.4, 1.5 )
    favOn.alpha = .8
    favH:insert( favOn )
    favOff = display.newImage("img/icon/iconRewardHeart3.png")
    favOff:scale( 1.4, 1.5 )
    favH:insert( favOff )
    
    -- Circle points
    local initHY = initHY + hCmp + 83
    local xLCircle = 115 +xxLCircle
    local rLCircle = 80
    
    if not(isFooter) then
        local bgBottom = display.newRect(midW, initHY - 10, wCmp + 4, 60 )
        bgBottom.anchorY = 1
        bgBottom:setFillColor( 0 )
        bgBottom.alpha = .8
        workSite:insert( bgBottom )
    end
    
    local bgPoints = display.newImage("img/deco/bgPoints.png")
    bgPoints:translate(xLCircle, initHY - 80 + yHPoints)
    workSite:insert( bgPoints )
    if allH <= 750 then
        bgPoints:scale(.85, .8)
    end
    
    local bgLine = display.newRect(midW, initHY - 3, initHY + 4, 3 )
    bgLine.anchorY = 0
    bgLine:setFillColor( unpack(cWhite) )
    workSite:insert( bgLine )
    txtPoints = display.newText({
        text = '',     
        y = initHY - 100 + yHPoints,
        x = xLCircle, width = 150,
        font = fontBold,   
        fontSize = 70 - hHPoints, align = "center"
    })
    txtPoints:setFillColor( unpack(cWhite) )
    workSite:insert(txtPoints)
    txtTuks = display.newText({
        text = 'TUKS', 
        y = initHY - 50,
        x = xLCircle, width = 150,
        font = fontSemiBold,   
        fontSize = 30 - hHTuks, align = "center"
    })
    txtTuks:setFillColor( unpack(cWhite) )
    workSite:insert(txtTuks)
    
    -- Bottom
    if isFooter then
        local bgBottom1 = display.newRect(midW, initHY, wCmp + 4, 80 )
        bgBottom1.anchorY = 0
        bgBottom1:setFillColor( unpack(cBTur) )
        workSite:insert( bgBottom1 )
        local bgBottom2 = display.newRect(midW, initHY + 4, wCmp - 4, 72 )
        bgBottom2.anchorY = 0
        bgBottom2:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBBlu) }, 
            color2 = { unpack(cBTur) },
            direction = "right"
        } )
        workSite:insert( bgBottom2 )
        txtName = display.newText({
            text = '',   
            y = initHY + 40,
            x = midW, width = wCmp -30,
            font = fontBold,   
            fontSize = 25, align = "left"
        })
        txtName:setFillColor( unpack(cWhite) )
        workSite:insert(txtName)
    else
        bgLine.height = 30
        
        txtName = display.newText({
            text = '',   
            y = initHY - 40,
            x = midW + 60 - xxLCircle, width = wCmp - 150,
            font = fontBold,   
            fontSize = 18, align = "left"
        })
        txtName:setFillColor( unpack(cWhite) )
        workSite:insert(txtName)
    end
    -- Obtener imagen QR
    RestManager.getQR()
    
    -- Crea la primera tanda
    tools:toFront()
    tools:setLoading(true, screen)
    
    Runtime:addEventListener( "location", getGPS )
    RestManager.getHomeRewards()
    
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
    Runtime:removeEventListener( "location", getGPS )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene