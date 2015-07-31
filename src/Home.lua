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

-- Grupos y Contenedores
local screen, workSite
local scene = storyboard.newScene()


-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight
local bgM, tools
local currentCard = 1
local isCard, direction
local initY, hWorkSite, yItem, itemSize, itemCoverSize  

-- Arrays
local items
local cards = {}
local cTop, cBottom, footer


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Crea primeras tarjetas
function getFirstCards(obj)
    tools:setLoading(false)
    items = obj.items
    
    cTop = display.newRect( midW, yItem + 10, itemSize, 10, 2 )
    cTop:setFillColor( .85 )
    screen:insert( cTop )
    cTop:toBack()
    cBottom = display.newRect( midW, yItem + itemSize, itemSize, 10, 2 )
    cBottom:setFillColor( .85 )
    screen:insert( cBottom )
    cBottom:toBack()
    
    currentCard = 1
    buildCard(items[1])
    buildCard(items[2])
    
    footer = display.newImage("img/deco/footerReward.png")
    footer.anchorY = 0
    footer:translate(midW, yItem + (itemSize/2) )
    workSite:insert( footer )
    
    local txtPoints = display.newText({
        text = items[1].points,     
        y = yItem + (itemSize * .80),
        x = 110, width = 105,
        font = native.systemFontBold,   
        fontSize = 50, align = "center"
    })
    txtPoints:setFillColor( 1 )
    workSite:insert(txtPoints)
    local txtPoints2 = display.newText({
        text = "POINTS",     
        y = yItem + (itemSize * .80) + 43,
        x = 110, width = 140,
        font = native.systemFontBold,   
        fontSize = 25, align = "center"
    })
    txtPoints2:setFillColor( 1 )
    workSite:insert(txtPoints2)
    local txtName = display.newText({
        text = items[1].name,     
        y = yItem + (itemSize) + 20,
        x = 215, width = 350,
        font = native.systemFontBold,   
        fontSize = 20, align = "left"
    })
    txtName:setFillColor( 1 )
    workSite:insert(txtName)
    
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
    cards[noC].top:toBack()
    cards[noC].top.alpha = 1
    cards[noC].top.height = itemSize
    cards[noC].bottom:toBack()
    cards[noC].bottom.alpha = 1
    cards[noC].bottom.height = itemSize
end

-- Desactiva tarjeta
function deactivateCard(noC)
    cards[noC].top.alpha = 0
    cards[noC].bottom.alpha = 0
end

-- Mueve tabs de las hojas
function moveTabs()
    if currentCard == 1 then cTop.y = yItem + 10 
    elseif currentCard == 2 then cTop.y = yItem end
    
    if (currentCard + 1) == #items then cBottom.y = yItem + itemSize 
    elseif (currentCard) == #items then cBottom.y = yItem + (itemSize - 10) end
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
    if event.phase == "began" then
        if event.yStart > yItem  and event.yStart < (yItem + itemSize) then
            isCard = true
            direction = 0
        else
            isCard = false
        end
    elseif event.phase == "moved" and (isCard) then
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
                    print(itemSize + ((y * 4) - (itemSize*2)))
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
                    moveTabs()
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
                    moveTabs()
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
    tools:setLoading(true, workSite)
    RestManager.getPointsBar()
    RestManager.getHomeRewards()
end	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene