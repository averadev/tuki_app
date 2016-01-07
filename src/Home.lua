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
local storyboard = require( "storyboard" )
local RestManager = require( "src.RestManager" )
local Globals = require( "src.Globals" )
local fxFav = audio.loadSound( "fx/fav.wav")
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, workSite
local scene = storyboard.newScene()


-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight
local bgM, tools, grpElemns
local currentCard = 1
local isDown = true
local isCard, direction, detailBox
local txtPoints, txtTuks, txtPoints2, txtName, txtCommerce, iconRewardBig, btnDetail
local yItem, itemSize, midSize, itemCoverSize, cTuks1, cTuks2
local cards, idxA, favH, favOn, favOff


-- Arrays
local cardL = {}
local cardR = {}
local rewardsH
local footer


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
        favOff.alpha = 1
        favOn.alpha = 0
        rewardsH[idxA].fav = nil
        RestManager.setRewardFav(rewardsH[idxA].id, 0)
    else
        favOff.alpha = 0
        favOn.alpha = 1
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
        storyboard.removeScene( "src.Reward" )
        storyboard.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = rewardsH[idxA].id } } )
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
    storyboard.removeScene( "src.Partner" )
    storyboard.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = { idCommerce = t.idCommerce } } )
    return true
end

-------------------------------------
-- Muestra el detalle del reward
-- @param event evento
------------------------------------
function tapDetail(event)
    local t = event.target
    local item = rewardsH[idxA]
    workSite:toBack()
    
    if workSite.y == 0 then
        if detailBox then
            detailBox:removeSelf()
            detailBox = nil
        end
        detailBox = display.newContainer( itemSize, 350 )
        detailBox.anchorY = 1
        detailBox:translate( 240, yItem + itemSize + 100 )
        screen:insert( detailBox )
        detailBox:toBack()

        local bg1 = display.newRoundedRect(0, 0, itemSize, 350, 10 )
        bg1:setFillColor( .91 )
        detailBox:insert( bg1 )

        local bg2 = display.newRoundedRect(0, 0, itemSize - 4, 350 - 4, 10 )
        bg2:setFillColor( 1 )
        detailBox:insert( bg2 )

        local commerce = display.newText({
            text = item.commerce,     
            x = 0, y = -130,
            font = fLatoRegular,   
            fontSize = 22, align = "center"
        })
        commerce:setFillColor( .3 )
        detailBox:insert(commerce)

        local commerceDesc = display.newText({
            text = item.commerceDesc,
            x = 0, y = -100,
            font = fLatoRegular,   
            fontSize = 20, align = "center"
        })
        commerceDesc:setFillColor( .68 )
        detailBox:insert(commerceDesc)

        local bg3 = display.newRect(0, -30, itemSize - 4, 80 )
        bg3:setFillColor( .91 )
        detailBox:insert( bg3 )

        local name = display.newText({
            text = item.name,     
            x = 0, y = -30, width = itemSize - 40,
            font = fLatoRegular,   
            fontSize = 28, align = "center"
        })
        name:setFillColor( .3 )
        detailBox:insert(name)

        local description = display.newText({
            text = item.description,
            x = 0, y = 50, width = itemSize - 40,
            font = fLatoRegular,   
            fontSize = 18, align = "center"
        })
        description:setFillColor( .3 )
        detailBox:insert(description)

        favH.y = favH.bottomY

        local yPosc = 120
        -- Barra Puntos
        local btnPointsBg = display.newRoundedRect( 0, yPosc, 400, 60, 10 )
        btnPointsBg:setFillColor( .91 )
        detailBox:insert(btnPointsBg)
        local bgPoints2A = display.newRect( -67, yPosc, 134, 60)
        bgPoints2A.anchorX = 0
        bgPoints2A:setFillColor( .75 )
        detailBox:insert(bgPoints2A)
        -- Lineas
        local line1 = display.newLine(-67, yPosc-30, -67, yPosc+30)
        line1:setStrokeColor( .58, .2 )
        line1.strokeWidth = 2
        detailBox:insert(line1)
        local line2 = display.newLine(66, yPosc-30, 66, yPosc+30)
        line2:setStrokeColor( .58, .2 )
        line2.strokeWidth = 2
        detailBox:insert(line2)
        -- Mis Puntos
        local txtPoints1A = display.newText({
            text = item.userPoints, 
            x = -130, y = yPosc-7,
            font = fLatoBold,
            fontSize = 24, align = "center"
        })
        txtPoints1A:setFillColor( 0 )
        detailBox:insert( txtPoints1A )
        local txtPoints1B = display.newText({
            text = "TUS TUKS", 
            x = -130, y = yPosc+15,
            font = fLatoRegular,
            fontSize = 12, align = "center"
        })
        txtPoints1B:setFillColor( .3 )
        detailBox:insert( txtPoints1B )
        -- Puntos
        local txtPoints2A = display.newText({
            text = item.points, 
            x = 0, y = yPosc-7, 
            font = fLatoBold,
            fontSize = 26, align = "center"
        })
        txtPoints2A:setFillColor( 0 )
        detailBox:insert( txtPoints2A )
        local txtPoints2B = display.newText({
            text = "VALOR", 
            x = 0, y = yPosc+15, 
            font = fLatoRegular,
            fontSize = 12, align = "center"
        })
        txtPoints2B:setFillColor( .3 )
        detailBox:insert( txtPoints2B )
        -- Action
        local iconRewardCheck1 = display.newImage("img/icon/iconRewardCheck1.png")
        iconRewardCheck1:translate( 130, yPosc - 5 )
        detailBox:insert( iconRewardCheck1 )
        local iconRewardCheck2 = display.newImage("img/icon/iconRewardCheck2.png")
        iconRewardCheck2:translate( 130, yPosc )
        detailBox:insert( iconRewardCheck2 )
        local txtPoints3 = display.newText({
            text = "", 
            x = 130, y = yPosc+20, 
            font = fLatoRegular,
            fontSize = 10, align = "center"
        })
        txtPoints3:setFillColor( .3 )
        detailBox:insert( txtPoints3 )
        local points = tonumber(item.points)
        local userPoints = tonumber(item.userPoints)
        -- Usuario con puntos
        if userPoints > points  then
            iconRewardCheck1.alpha = 0
        else
            txtPoints3.text = "FALTAN " .. (points-userPoints) .. " TUKS"
            iconRewardCheck2.alpha = 0
        end
    end
    
    if workSite.y < 0 then
        isDown = true
        detailBox:toBack()
        transition.to( workSite, { y = 0, time = 200, onComplete=function() 
            if detailBox then
                favH.y = favH.topY
                detailBox:removeSelf()
                detailBox = nil
            end
        end })
    else
        isDown = false
        transition.to( workSite, { y = -370, time = 200 })
    end
    return true
end

-------------------------------------
-- Comprobamos imagen QR
------------------------------------
function verifyQR()
    
end

-------------------------------------
-- Actualiza los puntos del toolbar
-- @param data info del WS
------------------------------------
function getPointsBar(data)
    tools:setPointsBar(data)
end

-------------------------------------
-- Genera primer lote de tarjetas
-- @param obj info del WS
------------------------------------
function getFirstCards(obj)
    tools:setLoading(false)
    rewardsH = obj.items
    for i = 1, #rewardsH, 1 do
        buildCard(rewardsH[i])
    end
    
    idxA = 1
    cardL[idxA].alpha = 1
    cardR[idxA].alpha = 1
    setRewardDetail(idxA)
    screen:addEventListener( "touch", touchScreen )
end

-------------------------------------
-- Actualiza la informacion de la recompensa
-- @param item registro que incluye la info del reward
------------------------------------
function showHElments(vAlpha)
    txtPoints.alpha = vAlpha
    txtTuks.alpha = vAlpha
    txtName.alpha = vAlpha
    txtCommerce.alpha = vAlpha
    cTuks1.alpha = vAlpha
    cTuks2.alpha = vAlpha
    if favOn.active then
        favOn.alpha = vAlpha
    elseif favOff.active then
        favOff.alpha = vAlpha
    end
end

-------------------------------------
-- Actualiza la informacion de la recompensa
-- @param item registro que incluye la info del reward
------------------------------------
function setRewardDetail(idx)
    txtPoints.text = rewardsH[idx].points
    txtName.text = rewardsH[idx].name
    txtCommerce.text = rewardsH[idx].commerce
    -- Fav actions
    if rewardsH[idx].id == rewardsH[idx].fav  then
        favOff.alpha = 0 
        favOff.active = false
        favOn.alpha = 1
        favOn.active = true
    else
        favOff.alpha = 1
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
    local imgS = graphics.newImageSheet( item.image, system.TemporaryDirectory, { width = 150, height = 300, numFrames = 2 })
    
    cardL[idx] = display.newRect( midW, yItem, midSize, itemSize )
    cardL[idx].alpha = 0
    cardL[idx].anchorY = 0
    cardL[idx].anchorX = 1
    cardL[idx].fill = { type = "image", sheet = imgS, frame = 1 }
    cards:insert(cardL[idx])
    
    cardR[idx] = display.newRect( midW, yItem, midSize, itemSize )
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
    if event.phase == "began" and workSite.y == 0 then
        if event.yStart > 140 and event.yStart < 820 then
            isCard = true
            direction = 0
            --showHElments(0)
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
        elseif direction == 1 and x <= 0 and xM >= -itemSize then
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
            elseif xM < itemSize then
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
        if direction == 1 and xM >= -itemSize then
            cardR[idxA].alpha = 1
            cardL[idxA+1].alpha = 0
            transition.to( cardR[idxA], { width = midSize, time = 200, onComplete=function()
                cardR[idxA+1].alpha = 0
            end})
        elseif direction == 1 and xM < -itemSize then
            cardR[idxA].alpha = 0
            cardL[idxA+1].alpha = 1
            setRewardDetail(idxA+1)
            transition.to( cardL[idxA+1], { width = midSize, time = 200, onComplete=function()
                cardL[idxA].alpha = 0
                cardR[idxA].alpha = 0
                idxA = idxA + 1
            end})
        end
        -- To Left
        if direction == -1 and xM <= itemSize then
            cardL[idxA].alpha = 1
            cardR[idxA-1].alpha = 0
            transition.to( cardL[idxA], { width = midSize, time = 200, onComplete=function()
                cardR[idxA-1].alpha = 0
            end})
        elseif direction == -1 and xM > itemSize then
            cardL[idxA].alpha = 0
            cardR[idxA-1].alpha = 1
            setRewardDetail(idxA-1)
            transition.to( cardR[idxA-1], { width = midSize, time = 200, onComplete=function()
                cardL[idxA].alpha = 0
                cardR[idxA].alpha = 0
                idxA = idxA - 1
            end})
        end
        
        showHElments(1)
        isCard = false
        direction = 0
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:createScene( event )
	screen = self.view
    
    -- Background
    bgM = display.newRect(midW, midH, intW, intH )
    bgM.alpha = .01
    screen:insert(bgM)
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    -- Tamaños y posicones
    local isPointsBar = false
    local xLCircle = 115
    local rLCircle = 80
    local fsPoints = 65
    local fyPoints = 55
    local fsTuks = 25
    local fsReward = 22
    local fsCommerce = 16
    local sBgFoot = 100
    local sBgDetail = 30
    local spBgDetail = 80
    allH = intH - h
    itemSize = 420
    midSize = itemSize / 2
    yItem = 0
    
    if allH > 820 then
        isPointsBar = true
        tools:buildPointsBar()
        yItem = (h+170) + (allH - 820)/2
    elseif allH > 730 then
        yItem = (h+115) + (allH - 770)/2
    elseif allH > 685 then
        itemSize = 370
        midSize = itemSize / 2
        yItem = (h+115) + (allH - 735)/2
        xLCircle = 130
        rLCircle = 70
        fsPoints = 55
        fyPoints = 50
        fsReward = 20
        fsCommerce = 14
        fsTuks = 22
    else
        itemSize = 330
        midSize = itemSize / 2
        yItem = (h+115) + (allH - 660)/2
        xLCircle = 150
        rLCircle = 55
        fsPoints = 45
        fyPoints = 45
        fsReward = 18
        fsCommerce = 12
        fsTuks = 20
        sBgFoot = 70
        sBgDetail = 23
        spBgDetail = 58
    end
    
    -- Contenedor area de trabajo
    workSite = display.newGroup()
    screen:insert(workSite)
    
    local bgGray = display.newRect(midW, yItem + (itemSize / 2), itemSize + 4, itemSize + 4 )
    bgGray:setFillColor( unpack(cGrayM) )
    bgGray:addEventListener( 'tap', tapReward) 
    workSite:insert( bgGray )
    
    cards = display.newGroup()
    workSite:insert(cards)
    
    -- Favs
    local rmid = (midW + (itemSize/2)) - 60
    favH = display.newGroup()
    favH:translate( rmid + 25, yItem + 35 )
    favH.bottomY = yItem + itemSize - 220
    favH.topY = yItem + 35
    screen:insert(favH)
    local bgFav = display.newRect( 0, 0, 60, 60 )
    bgFav.alpha = .01
    bgFav:addEventListener( 'tap', tapFavHome) 
    favH:insert( bgFav )
    favOn = display.newImage("img/icon/iconRewardBig2.png")
    favH:insert( favOn )
    favOff = display.newImage("img/icon/iconRewardBig1.png")
    favH:insert( favOff )
        
    cTuks1 = display.newCircle( xLCircle, (yItem + itemSize) - (rLCircle/2), rLCircle )
    cTuks1:setFillColor( unpack(cWhite) )
    workSite:insert( cTuks1 )

    cTuks2 = display.newCircle( xLCircle, (yItem + itemSize) - (rLCircle/2), rLCircle - 5 )
    cTuks2:setFillColor( unpack(cTurquesa) )
    workSite:insert( cTuks2 )
    
    local bgLine = display.newRect(midW, (yItem + itemSize) + 4, itemSize +4, 2 )
    bgLine.anchorY = 0
    bgLine:setFillColor( unpack(cWhite) )
    workSite:insert( bgLine )
    
    local bgInfo = display.newRect(midW, (yItem + itemSize) + 6, itemSize +4, sBgFoot )
    bgInfo.anchorY = 0
    bgInfo:setFillColor( unpack(cBlueH) )
    workSite:insert( bgInfo )
    
    -- Grupo de elementos
    grpElemns = display.newGroup()
    workSite:insert(grpElemns)
    
    txtPoints = display.newText({
        text = '',     
        y = (yItem + itemSize) - fyPoints,
        x = xLCircle, width = 150,
        font = fLatoBold,   
        fontSize = fsPoints, align = "center"
    })
    txtPoints:setFillColor( unpack(cWhite) )
    grpElemns:insert(txtPoints)
    
    txtTuks = display.newText({
        text = 'TUKS', 
        y = (yItem + itemSize) - 13,
        x = xLCircle, width = 150,
        font = fLatoBold,   
        fontSize = fsTuks, align = "center"
    })
    txtTuks:setFillColor( unpack(cBlueH) )
    grpElemns:insert(txtTuks)
    
    txtName = display.newText({
        text = '',   
        y = yItem + (itemSize) + 30,
        x = midW, width = itemSize -30,
        font = fLatoBold,   
        fontSize = fsReward, align = "left"
    })
    txtName:setFillColor( 1 )
    grpElemns:insert(txtName)
    
    txtCommerce = display.newText({
        text = '', 
        y = yItem + (itemSize) + 60,
        x = midW, width = itemSize -30,
        font = "Lato",   
        fontSize = fsCommerce, align = "left"
    })
    txtCommerce:setFillColor( .9 )
    grpElemns:insert(txtCommerce)
    
    -- Buton
    local bgBtn = display.newRoundedRect( rmid, yItem + (itemSize) + spBgDetail, 100, sBgDetail, 5 )
    bgBtn:setFillColor( unpack(cGrayXXH) )
    bgBtn:addEventListener( 'tap', tapDetail) 
    grpElemns:insert(bgBtn)
    
    -- Circles
    local circle1 = display.newRoundedRect( rmid-25, yItem + (itemSize) + spBgDetail, 10, 10, 5 )
    circle1:setFillColor( .9 )
    grpElemns:insert(circle1)
    local circle2 = display.newRoundedRect( rmid, yItem + (itemSize) + spBgDetail, 10, 10, 5 )
    circle2:setFillColor( .9 )
    grpElemns:insert(circle2)
    local circle3 = display.newRoundedRect( rmid+25, yItem + (itemSize) + spBgDetail, 10, 10, 5 )
    circle3:setFillColor( .9 )
    grpElemns:insert(circle3)
    
    -- Verificar QR
    verifyQR()
    
    -- Crea la primera tanda
    tools:setLoading(true, screen)
    if isPointsBar then
        RestManager.getPointsBar()
    end
    RestManager.getHomeRewards()
end	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scenes[#Globals.scenes + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene