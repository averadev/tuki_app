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
local txtPoints, txtPoints2, txtName, txtCommerce, iconRewardBig, btnDetail
local initY, hWorkSite, yItem, itemSize, itemCoverSize  


-- Arrays
local items
local cards = {}
local footer


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Tap toggle event
function tapFav(event)
    local t = event.target
    audio.play( fxFav )
    if items[currentCard].id == items[currentCard].fav  then
        t.img1.alpha = 1
        t.img2.alpha = 0
        items[currentCard].fav = nil
        RestManager.setRewardFav(t.idReward, 0)
    else
        t.img1.alpha = 0
        t.img2.alpha = 1
        items[currentCard].fav = items[currentCard].id
        RestManager.setRewardFav(t.idReward, 1)
    end
    return true
end

-- Tap toggle event
function tapReward(event)
    if isDown then
        local t = event.target
        audio.play( fxTap )
        storyboard.removeScene( "src.Reward" )
        storyboard.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = items[currentCard].id } } )
    end
    return true
end

-- Tap commerce event
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( "src.Partner" )
    storyboard.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = { idCommerce = t.idCommerce } } )
    return true
end

-- Tap show detail
function tapDetail(event)
    local t = event.target
    local item = items[currentCard]
    workSite:toBack()
    
    if workSite.y == 0 then
        if detailBox then
            detailBox:removeSelf()
            detailBox = nil
        end
        detailBox = display.newContainer( itemSize, 350 )
        detailBox.anchorY = 1
        detailBox:translate( 240, yItem + itemSize + 60 )
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
            x = 0, y = -140,
            font = native.systemFont,   
            fontSize = 22, align = "center"
        })
        commerce:setFillColor( .3 )
        detailBox:insert(commerce)

        local commerceDesc = display.newText({
            text = item.commerceDesc,
            x = 0, y = -110,
            font = native.systemFont,   
            fontSize = 20, align = "center"
        })
        commerceDesc:setFillColor( .68 )
        detailBox:insert(commerceDesc)

        local bg3 = display.newRect(0, -40, itemSize - 4, 80 )
        bg3:setFillColor( .91 )
        detailBox:insert( bg3 )

        local name = display.newText({
            text = item.name,     
            x = 0, y = -40, width = itemSize - 40,
            font = native.systemFont,   
            fontSize = 28, align = "center"
        })
        name:setFillColor( .3 )
        detailBox:insert(name)

        local description = display.newText({
            text = item.description,
            x = 0, y = 30, width = itemSize - 40,
            font = native.systemFont,   
            fontSize = 18, align = "center"
        })
        description:setFillColor( .3 )
        detailBox:insert(description)

        iconRewardBig.y = iconRewardBig.bottomY

        local yPosc = 100
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
            x = -130, y = yPosc-7, width = 133, 
            font = native.systemFontBold,
            fontSize = 24, align = "center"
        })
        txtPoints1A:setFillColor( 0 )
        detailBox:insert( txtPoints1A )
        local txtPoints1B = display.newText({
            text = "MIS PUNTOS", 
            x = -130, y = yPosc+15, width = 133, 
            font = native.systemFont,
            fontSize = 12, align = "center"
        })
        txtPoints1B:setFillColor( .3 )
        detailBox:insert( txtPoints1B )
        -- Puntos
        local txtPoints2A = display.newText({
            text = item.points, 
            x = 0, y = yPosc-7, width = 133, 
            font = native.systemFontBold,
            fontSize = 26, align = "center"
        })
        txtPoints2A:setFillColor( 0 )
        detailBox:insert( txtPoints2A )
        local txtPoints2B = display.newText({
            text = "VALOR", 
            x = 0, y = yPosc+15, width = 133, 
            font = native.systemFont,
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
            x = 130, y = yPosc+20, width = 133, 
            font = native.systemFont,
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
            txtPoints3.text = "FALTAN " .. (points-userPoints) .. " PUNTOS"
            iconRewardCheck2.alpha = 0
        end
    end
    
    if workSite.y < 0 then
        isDown = true
        detailBox:toBack()
        transition.to( workSite, { y = 0, time = 200, onComplete=function() 
            if detailBox then
                iconRewardBig.y = iconRewardBig.topY
                detailBox:removeSelf()
                detailBox = nil
            end
        end })
    else
        isDown = false
        transition.to( workSite, { y = -350, time = 200 })
    end
    return true
end

-- Crea primeras tarjetas
function getFirstCards(obj)
    tools:setLoading(false)
    items = obj.items
    
    currentCard = 1
    buildCard(items[1])
    buildCard(items[2])
    
    local btnBg = display.newRect(midW, yItem + (itemSize / 2), itemSize, itemSize )
    btnBg:setFillColor( 0 )
    btnBg.alpha = .01
    btnBg:addEventListener( 'tap', tapReward) 
    workSite:insert( btnBg )
    
    footer = display.newImage("img/deco/footerReward.png")
    footer.anchorY = 0
    footer:translate(midW, yItem + (itemSize/2) )
    workSite:insert( footer )
    
    -- Grupo de elementos
    grpElemns = display.newGroup()
    workSite:insert(grpElemns)
    
    iconRewardBig = display.newContainer( 100, 100 )
    iconRewardBig.idReward = items[1].id
    iconRewardBig.bottomY = 750
    iconRewardBig.topY = yItem + (itemSize/8) 
    iconRewardBig:addEventListener( 'tap', tapFav) 
    iconRewardBig:translate( 400, yItem + (itemSize/8)  )
    grpElemns:insert( iconRewardBig )
    
    iconRewardBig.img1 = display.newImage("img/icon/iconRewardBig1.png")
    iconRewardBig:insert( iconRewardBig.img1 )
    iconRewardBig.img2 = display.newImage("img/icon/iconRewardBig2.png")
    iconRewardBig:insert( iconRewardBig.img2 )
    if items[1].id == items[1].fav  then
        iconRewardBig.img1.alpha = 0
    else
        iconRewardBig.img2.alpha = 0
    end
    
    btnDetail = display.newRect(380, yItem + itemSize + 30, 120, 40 )
    btnDetail.alpha = .01
    btnDetail:addEventListener( 'tap', tapDetail) 
    grpElemns:insert(btnDetail)
    
    txtPoints = display.newText({
        text = items[1].points,     
        y = yItem + (itemSize * .80),
        x = 110, width = 105,
        font = native.systemFontBold,   
        fontSize = 50, align = "center"
    })
    txtPoints:setFillColor( 1 )
    grpElemns:insert(txtPoints)
    txtPoints2 = display.newText({
        text = "PUNTOS",     
        y = yItem + (itemSize * .80) + 43,
        x = 110, width = 140,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    txtPoints2:setFillColor( 1 )
    grpElemns:insert(txtPoints2)
    
    txtName = display.newText({
        text = items[1].name,     
        y = yItem + (itemSize) + 20,
        x = 215, width = 350,
        font = native.systemFontBold,   
        fontSize = 20, align = "left"
    })
    txtName:setFillColor( 1 )
    grpElemns:insert(txtName)
    
    txtCommerce = display.newText({
        text = items[1].commerce,     
        y = yItem + (itemSize) + 40,
        x = 215, width = 350,
        font = native.systemFontBold,   
        fontSize = 16, align = "left"
    })
    txtCommerce:setFillColor( .9 )
    grpElemns:insert(txtCommerce)
    
    cards[1].top.alpha = 1
    cards[1].bottom.alpha = 1
    bgM:addEventListener( "touch", touchScreen )
    
end

-- Arma tarjeta
function nextCard()
    currentCard = currentCard + 1
    if #cards < #items then
        buildCard(items[#cards + 1])
    end
end

-- Activa tarjeta
function activateCard(noC)
    grpElemns.alpha = 0 
    
    cards[noC].top:toBack()
    cards[noC].top.alpha = 1
    cards[noC].top.height = itemSize
    cards[noC].bottom:toBack()
    cards[noC].bottom.alpha = 1
    cards[noC].bottom.height = itemSize
end

-- Desactiva tarjeta
function deactivateCard(noC)
    grpElemns.alpha = 1
    grpElemns:toFront();
    
    cards[noC].top.alpha = 0
    cards[noC].bottom.alpha = 0
end

-- Mueve tabs de las hojas
function anotherCard()
    grpElemns.alpha = 1
    grpElemns:toFront();
    txtPoints.text = items[currentCard].points
    txtName.text = items[currentCard].name
    txtCommerce.text = items[currentCard].commerce
    iconRewardBig.idReward = items[currentCard].id
    if items[currentCard].id == items[currentCard].fav  then
        iconRewardBig.img1.alpha = 0
        iconRewardBig.img2.alpha = 1
    else
        iconRewardBig.img1.alpha = 1
        iconRewardBig.img2.alpha = 0
    end
end


-- Arma tarjeta
function buildCard(item)
    local idx = #cards + 1
    
    -- Container
    cards[idx] = {}
    -- Imagen Top
    local maskTop = graphics.newMask( "img/deco/maskTop.jpg" )
    cards[idx].top = display.newImage(item.image, system.TemporaryDirectory)
    cards[idx].top:translate(midW, yItem + (itemSize / 2))
    cards[idx].top.alpha = 0
    cards[idx].top:setMask( maskTop )
    cards[idx].top.width = itemSize
    cards[idx].top.height = itemSize
    workSite:insert( cards[idx].top )
    
    -- Imagen Bottom
    local maskBottom = graphics.newMask( "img/deco/maskBottom.jpg" )
    cards[idx].bottom = display.newImage(item.image, system.TemporaryDirectory)
    cards[idx].bottom:translate(midW, yItem + (itemSize / 2))
    cards[idx].bottom.alpha = 0
    cards[idx].bottom:setMask( maskBottom )
    cards[idx].bottom.width = itemSize
    cards[idx].bottom.height = itemSize
    workSite:insert( cards[idx].bottom )
end

-- Listener Touch Screen
function touchScreen(event)
    local nextC = currentCard + 1
    local prevC = currentCard - 1
    if event.phase == "began" and isDown then
        if event.yStart > yItem  and event.yStart < (yItem + itemSize + 55) then
            isCard = true
            direction = 0
        else
            isCard = false
        end
    elseif event.phase == "moved" and (isCard) and isDown then
        local y = (event.y - event.yStart)
        if direction == 0 then
            if y < -10 and currentCard < #items then
                direction = 1
                activateCard(nextC)
                cards[nextC].top.height = 0
            elseif y > 10 and currentCard > 1 then
                direction = -1
                activateCard(prevC)
                cards[prevC].bottom.height = 0
            end
        elseif direction == 1 then
            if y < 0 then
                if ((-y * 4) < itemSize) then
                    cards[nextC].top.alpha = 0
                    cards[currentCard].bottom.alpha = 1
                    footer.alpha = 1
                    
                    cards[currentCard].bottom.height = itemSize + (y * 4)
                    footer.height = (itemSize / 2) + (y * 2)
                elseif cards[nextC].top.height < itemSize then
                    cards[nextC].top.alpha = 1
                    cards[currentCard].bottom.alpha = 0
                    footer.alpha = 0
                    cards[nextC].top:toFront()
                    
                    if itemSize + ((-y * 4) - (itemSize*2)) > itemSize then
                        cards[nextC].top.height = itemSize
                    else
                        cards[nextC].top.height = itemSize + ((-y * 4) - (itemSize*2))
                    end
                end
            end
        elseif direction == -1 then
            if y > 0 then
                if ((y * 4) < itemSize) then
                    cards[prevC].bottom.alpha = 0
                    cards[currentCard].top.alpha = 1
                    cards[currentCard].top.height = itemSize - (y * 4)
                elseif cards[prevC].bottom.height < itemSize then
                    cards[prevC].bottom:toFront()
                    cards[prevC].bottom.alpha = 1
                    cards[currentCard].top.alpha = 0
                    if itemSize + ((y * 4) - (itemSize*2)) > itemSize then
                        cards[prevC].bottom.height = itemSize
                    else
                        cards[prevC].bottom.height = itemSize + ((y * 4) - (itemSize*2))
                    end
                end
            end
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        
        -- Movimiento
        if direction == 1 and (isCard) then
            if  cards[currentCard].bottom.alpha == 1 then
                transition.to( footer, { height = itemCoverSize, time = 200 })
                transition.to( cards[currentCard].bottom, { height = itemSize, time = 200, onComplete=function() 
                    deactivateCard(nextC)
                end })
            elseif cards[currentCard].bottom.alpha == 0 then
                footer.height = itemCoverSize
                transition.to( footer, { alpha = 1, time = 200 })
                transition.to( cards[nextC].top, { height = itemSize, time = 200, onComplete=function() 
                    deactivateCard(currentCard)
                    nextCard()
                    anotherCard()
                end })
            end
        elseif direction == -1 and (isCard) then
            if  cards[currentCard].top.alpha == 1 then
                transition.to( cards[currentCard].top, { height = itemSize, time = 200, onComplete=function() 
                    deactivateCard(prevC)
                end })
            elseif cards[currentCard].top.alpha == 0 then
                footer.alpha = 0
                footer:toFront()
                transition.to( footer, { alpha = 1, time = 200 })
                transition.to( cards[prevC].bottom, { height = itemSize, time = 200, onComplete=function() 
                    deactivateCard(currentCard)
                    currentCard = currentCard - 1
                    anotherCard()
                end })
            end
        end
        isCard = false
        direction = 0
    end
end

function getPointsBar(data)
    tools:setPointsBar(data)
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
    tools:buildPointsBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    -- Tamaños y posicones
    initY = h + 160 -- inicio en Y del worksite
    hWorkSite = intH - (h + 240) -- altura del worksite
    -- Tamaño de las recompensas
    itemSize = 320 -- Pantalla chica
    if hWorkSite > 440 and hWorkSite < 500 then 
        itemSize = 360 -- Pantalla mediana
    elseif hWorkSite > 500 then 
        itemSize = 420 -- Pantalla alta
    end
    itemCoverSize = (itemSize / 2) + 60
    
    -- Y del Item
    yItem = initY + ((hWorkSite/2) - (itemSize/2)) - 35 -- centro del worksite
    
    -- Contenedor area de trabajo
    workSite = display.newGroup()
    screen:insert(workSite)
    -- Crea la primera tanda
    tools:setLoading(true, screen)
    RestManager.getPointsBar()
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