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
        favOff.alpha = .7
        favOn.alpha = 0
        rewardsH[idxA].fav = nil
        RestManager.setRewardFav(rewardsH[idxA].id, 0)
    else
        favOff.alpha = 0
        favOn.alpha = .7
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
        for z = 1, #comRews, 1 do 
            -- Deactivate
            if coverHComer[z].active then
                coverHComer[z].active = false
                coverHComer[z].bgFP1:setFillColor( unpack(cGrayL) )
                coverHComer[z].bgFP2:setFillColor( unpack(cWhite) )  
            end
        end
        -- Activate
        tools:setLoading(true, screen)
        coverHComer[idx].active = true
        coverHComer[idx].bgFP1:setFillColor( unpack(cTurquesa) )
        if curLogo then
            curLogo:removeSelf()
            curLogo = nil;
        end
        curLogo = display.newImage( comRews[idx].image, system.TemporaryDirectory )
        curLogo:translate( midW-midSize+40, h + 239 )
        curLogo.height = 75
        curLogo.width = 75
        workSite:insert(curLogo)
        color = {tonumber(comRews[idx].colorA1)/255, tonumber(comRews[idx].colorA2)/255, tonumber(comRews[idx].colorA3)/255}
        colorL = { 1-color[1], 1-color[2], 1-color[3] }
        bgTCover1:setFillColor( color[1], color[2], color[3] )
        bgTop:setFillColor( color[1], color[2], color[3] )
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
        local xPosc = (z * 94) - 50

        coverHComer[z] = display.newContainer( 90, 90 )
        coverHComer[z].idx = z
        coverHComer[z].active = false
        coverHComer[z]:translate( xPosc, 50 )
        scrViewCM:insert( coverHComer[z] )
        coverHComer[z]:addEventListener( 'tap', getHPartner)

        coverHComer[z].bgFP1 = display.newRect(0, 0, 90, 90 )
        coverHComer[z].bgFP1:setFillColor( unpack(cGrayL) )
        coverHComer[z]:insert( coverHComer[z].bgFP1 )

        coverHComer[z].bgFP2 = display.newRect(0, 0, 80, 80 )
        coverHComer[z].bgFP2:setFillColor( unpack(cWhite) )
        coverHComer[z]:insert( coverHComer[z].bgFP2 )

        coverHComer[z].img = display.newImage( comRews[z].image, system.TemporaryDirectory )
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
        scrViewCM:setScrollWidth((94 * #comRews) - 5)
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
    --[[
    if favOn.active then
        favOn.alpha = vAlpha
    elseif favOff.active then
        favOff.alpha = vAlpha
    end
    ]]
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
    
    cardL[idx] = display.newRect( midW, h + 280, wCmp/2, hCmp )
    cardL[idx].alpha = 0
    cardL[idx].anchorY = 0
    cardL[idx].anchorX = 1
    cardL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    cards:insert(cardL[idx])
    
    cardR[idx] = display.newRect( midW, h + 280, wCmp/2, hCmp )
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
        top = h + 90,
        left = 18,
        width = intW - 36,
        height = 100,
        verticalScrollDisabled = true,
		backgroundColor = { 1 }
    }
    screen:insert(scrViewCM)
    
    -- Tamaños y posicones
    initY  = h + 200 
    allH = intH - h
    wCmp, hCmp = 440, 330
    wCTitle, rLRest, hHPoints, yHPoints, hHTuks, xxLCircle = 0, 0, 0, 0, 0, 0
    -- Footer
    isFooter = true
    if allH <= 750 then
        isFooter = false
    end
    -- Resize Cmp
    print(allH)
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
    
    local bgGrayT = display.newRoundedRect(midW, initY - 3, wCmp + 4, 100, 10 )
    bgGrayT.anchorY = 0
    bgGrayT:setFillColor( unpack(cGrayM) )
    bgGrayT:addEventListener( 'tap', tapCommerce) 
    workSite:insert( bgGrayT )
    bgTop = display.newRoundedRect(midW, initY, wCmp, 100, 10 )
    bgTop.anchorY = 0
    bgTop:setFillColor( unpack(cTurquesa) )
    workSite:insert( bgTop )
    local bgGray = display.newRect(midW, initY + 80,  wCmp + 4, hCmp )
    bgGray.anchorY = 0
    bgGray:setFillColor( unpack(cGrayM) )
    bgGray:addEventListener( 'tap', tapReward) 
    workSite:insert( bgGray )
    cards = display.newGroup()
    workSite:insert(cards)
    bgTCover1 = display.newRoundedRect(midW-midSize+40, initY - 6, 90, 90, 10 )
    bgTCover1.anchorY = 0
    bgTCover1:setFillColor( unpack(cTurquesa) )
    workSite:insert( bgTCover1 )
    local bgTCover2 = display.newRoundedRect(midW-midSize+40, initY - 2, 82, 82, 10 )
    bgTCover2.anchorY = 0
    bgTCover2:setFillColor( unpack(cWhite) )
    workSite:insert( bgTCover2 )
    txtCommerce = display.newText({
        text = '',
        y = initY + 30,
        x = midW + 50, width = 350 - wCTitle,
        font = fLatoBold,   
        fontSize = 35, align = "left"
    })
    txtCommerce:setFillColor( unpack(cWhite) )
    workSite:insert(txtCommerce)
    txtCommerceDesc = display.newText({
        text = '',
        y = initY + 60,
        x = midW + 53, width = 350 - wCTitle,
        font = fLatoItalic,   
        fontSize = 18, align = "left"
    })
    txtCommerceDesc:setFillColor( unpack(cWhite) )
    workSite:insert(txtCommerceDesc)
    
    
    -- Favs
    favH = display.newGroup()
    favH:translate( midW + (hCmp/2), initY + 120 )
    workSite:insert(favH)
    local bgFav = display.newRect( 0, 0, 60, 60 )
    bgFav.alpha = .01
    bgFav:addEventListener( 'tap', tapFavHome) 
    favH:insert( bgFav )
    favOn = display.newImage("img/icon/iconRewardBig2.png")
    favOn.alpha = .4
    favH:insert( favOn )
    favOff = display.newImage("img/icon/iconRewardBig1.png")
    favH:insert( favOff )
    
    -- Circle points
    local initY = initY + hCmp + 83
    local xLCircle = 115 +xxLCircle
    local rLCircle = 80
    
    if not(isFooter) then
        local bgBottom = display.newRect(midW, initY - 10, wCmp + 4, 60 )
        bgBottom.anchorY = 1
        bgBottom:setFillColor( 0 )
        bgBottom.alpha = .5
        workSite:insert( bgBottom )
    end
    local cTuks1 = display.newCircle( xLCircle, initY - 45, rLCircle - rLRest )
    cTuks1:setFillColor( unpack(cWhite) )
    workSite:insert( cTuks1 )
    local cTuks2 = display.newCircle( xLCircle, initY - 45, rLCircle - rLRest - 4 )
    cTuks2:setFillColor( unpack(cTurquesa) )
    workSite:insert( cTuks2 )
    local bgLine = display.newRect(midW, initY - 3, initY + 4, 3 )
    bgLine.anchorY = 0
    bgLine:setFillColor( unpack(cWhite) )
    workSite:insert( bgLine )
    txtPoints = display.newText({
        text = '',     
        y = initY - 70 + yHPoints,
        x = xLCircle, width = 150,
        font = fLatoBold,   
        fontSize = 70 - hHPoints, align = "center"
    })
    txtPoints:setFillColor( unpack(cWhite) )
    workSite:insert(txtPoints)
    txtTuks = display.newText({
        text = 'TUKS', 
        y = initY - 25,
        x = xLCircle, width = 150,
        font = fLatoBold,   
        fontSize = 30 - hHTuks, align = "center"
    })
    txtTuks.alpha = .7
    txtTuks:setFillColor( unpack(cBlueH) )
    workSite:insert(txtTuks)
    
    -- Bottom
    if isFooter then
        local bgBottom = display.newRoundedRect(midW, initY, wCmp + 4, 80, 10 )
        bgBottom.anchorY = 0
        bgBottom:setFillColor( unpack(cBlueH) )
        workSite:insert( bgBottom )
        local bgBottomT = display.newRect(midW, initY, wCmp + 4, 20 )
        bgBottomT.anchorY = 0
        bgBottomT:setFillColor( unpack(cBlueH) )
        workSite:insert( bgBottomT )
        txtName = display.newText({
            text = '',   
            y = initY + 40,
            x = midW, width = wCmp -30,
            font = fLatoBold,   
            fontSize = 25, align = "left"
        })
        txtName:setFillColor( unpack(cWhite) )
        workSite:insert(txtName)
    else
        bgLine.height = 30
        
        txtName = display.newText({
            text = '',   
            y = initY - 40,
            x = midW + 60 - xxLCircle, width = wCmp - 150,
            font = fLatoBold,   
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
    RestManager.getHomeRewards()
    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
    end
end

-- Remove Listener
function scene:destroy( event )
    if scrViewCM then
        --scrViewCM:removeSelf()
        --scrViewCM = nil;
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene