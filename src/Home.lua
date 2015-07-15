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

-- Grupos y Contenedores
local screen, workSite
local scene = storyboard.newScene()


-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight
local whenFlip = 1
local currentCard = 1
local isReady = false
local initY, hWorkSite, yItem, itemSize 
local timerFlip, bgM
local isCard, direction

-- Arrays
local cards = {}
local holders = {}
local items = {{"imgPBig01.png"}, {"imgPBig02.png"}, {"imgPBig03.png"}, {"imgPBig04.png"}, 
               {"imgPBig05.png"}, {"imgPBig06.png"}, {"imgPBig07.png"}, {"imgPBig08.png"},  
               {"imgPBig09.png"}, {"imgPBig10.png"}, {"imgPBig11.png"}, {"imgPBig12.png"}}


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Crea primeras tarjetas
function getFirstCards()
    for z = 1, 4, 1 do 
        buildCard(items[z], z)
    end
    isReady = true
    currentCard = 1
    cards[1].alpha = 1
end

-- Arma tarjeta
function nextCard()
    currentCard = currentCard + 1
    if #cards < #items then
        buildCard(items[#cards + 1], 4)
    else
        local newIdx = currentCard + 3
        if (currentCard+2) == #cards then
            newIdx = 1
        elseif (currentCard+1) == #cards then
            newIdx = 2
        elseif currentCard == #cards then
            newIdx = 3
        elseif currentCard > #cards then
            newIdx = 4
            currentCard = 1
        end
        print("Set: "..newIdx)
        cards[newIdx]:toBack()
        cards[newIdx].alpha = .5
        cards[newIdx].yScale = 1
        cards[newIdx].y = yItem + 20
        cards[newIdx].height = itemSize
    end
    isReady = true
    bgM:addEventListener( "touch", touchScreen )
end

-- Arma tarjeta
function buildCard(item, level)
    if level == 4 then level = 3 end
    local addY = ((level-1) * 10)
    local idx = #cards + 1
    
    -- Imagen
    cards[idx] = display.newImage("img/deco/"..item[1])
    cards[idx].anchorY = 0
    cards[idx]:translate( midW, yItem + addY )
    cards[idx].width = itemSize
    cards[idx].height = itemSize
    cards[idx].alpha = .5
    workSite:insert( cards[idx] )
    cards[idx]:toBack()
end

-- Verifica si realiza movimiento de tarjeta
function isNextCard()
    isReady = false
    local t =  cards[currentCard]
    local idx = currentCard
    local next1 = currentCard + 1
    local next2 = currentCard + 2
    if (currentCard + 1) == #items then
        next2 = 1
    elseif currentCard == #items then
        next1 = 1
        next2 = 2
    end
    if cards[next1].alpha >= 1 then
        -- Subir Imagenes
        transition.to( cards[next1], { y = yItem, time = 300, transition = easing.outExpo })
        transition.to( cards[next2], { y = yItem + 10, time = 300, transition = easing.outExpo })
        -- Voltear tarjeta
        whenFlip = 1
        local count = 0
        timerFlip = timer.performWithDelay(10, function() 
            print(isReady)
            count = count + 1
            if whenFlip == 1 then
                if t.height > 50 then
                    t.height = t.height - 50
                else
                    t.height = 0
                    whenFlip = 2
                    t.path.x2 = 0
                    t.path.x3 = 0
                    t.yScale = -1
                end
            elseif whenFlip == 2 then
                if t.height < 150 then
                    t.height = t.height + 40
                    t.path.x2 = t.path.x2 - 10
                    t.path.x3 = t.path.x3 + 10
                else
                    whenFlip = 3
                end

            elseif whenFlip == 3 then
                if t.height > 0 then
                    t.height = t.height - 40
                    t.path.x2 = t.path.x2 + 10
                    t.path.x3 = t.path.x3 - 10
                else
                    print("----")
                    timer.cancel(timerFlip)
                    nextCard()
                end
            end
        end, 0)

    else
        cards[2].alpha = .5
        t.path.x2 = 0
        t.path.x3 = 0
        timer.performWithDelay(500, function() 
                bgM:addEventListener( "touch", touchScreen ) 
                isReady = true 
        end, 1)
        transition.to( t, { height = itemSize, y = cWorkSite, time = 400, transition = easing.outExpo })
    end
end

-- Listener Touch Screen
function touchScreen(event)
    if event.phase == "began" and (isReady) then
        if event.yStart > yItem  and event.yStart < (yItem + itemSize) then
            isCard = true
            direction = 0
        else
            isCard = false
        end
    elseif event.phase == "moved" and (isCard) then
        local y = (event.y - event.yStart)
        if direction == 0 then
            if y < -10 then
                direction = 1
            elseif y > 10 then
                direction = -1
            end
        elseif direction == 1 then
            if y < 0 then
                -- Perspectiva
                cards[currentCard].height = itemSize + y
                cards[currentCard].path.x2 = y
                cards[currentCard].path.x3 = - y
                -- Alpha
                if (y/300) < .5 then
                    local next1 = currentCard + 1
                    if currentCard == #items then
                        next1 = 1
                    end
                    cards[next1].alpha = .5 - (y/300)
                end
            end 
        end
        
    elseif event.phase == "ended" or event.phase == "cancelled" then
        bgM:removeEventListener( "touch", touchScreen )
        print("----------"..event.phase)
        isCard = false
        direction = 0
        isNextCard()
    end
end

function dragCard(event)
    local t =  event.target
    local next1 = currentCard + 1
    local next2 = currentCard + 2
    if (currentCard + 1) == #items then
        next2 = 1
    elseif currentCard == #items then
        next1 = 1
        next2 = 2
    end
    
    if event.phase == "began" then
        --imageTop.alpha = 1
    elseif event.phase == "moved" then
        
    elseif event.phase == "ended" or event.phase == "cancelled" then
        isNextCard()
    end
    
    return true
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:createScene( event )
	screen = self.view
    
    -- Background
    bgM = display.newRect(200, midH, 400, intH )
    bgM.alpha = .01
    screen:insert(bgM)
    bgM:addEventListener( "touch", touchScreen )
    
	local tools = Tools:new()
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
    -- Y del Item
    yItem = initY + (hWorkSite/2) - (itemSize/2) -- centro del worksite
    
    -- Contenedor area de trabajo
    workSite = display.newGroup()
    screen:insert(workSite)
    -- Crea la primera tanda
    getFirstCards()
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