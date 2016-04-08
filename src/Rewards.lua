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
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen, scrViewR, tools
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local lastX = 0
local txtPName, txtPConcept, lastYP
local btnToggle1, btnToggle2

-- Arrays
local rowCom, rowRew = {}, {}
local txtBg, txtFiltro, fpRows = {}, {}, {}




---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Filtro de recompensas
-- @param event objeto evento
-------------------------------------
function tapFilter(event)
    local t = event.target
    if t.bgFP2.alpha == 0 then
        t.bgFP2.alpha = 1
        t.iconOn.alpha = 1
        t.iconOff.alpha = 0
        t.txt:setFillColor( 1 )
    else
        t.bgFP2.alpha = 0
        t.iconOn.alpha = 0
        t.iconOff.alpha = 1
        t.txt:setFillColor( .5 )
    end
end

-------------------------------------
-- Consulta pantalla Reward
-- @param event objeto evento
-------------------------------------
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Reward" )
    composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
end

-------------------------------------
-- Tap Reward Favorito
-- @param event objeto evento
-------------------------------------
function tapFavRew(event)
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
-- Filtrar registros
-- @param txtFil array filters
------------------------------------
function doFilter(txtFil)
    -- Clean Info
    for y = 1, #rowRew, 1 do 
        rowRew[y]:removeSelf()
        rowRew[y] = nil
    end
    for z = 1, #rowCom, 1 do 
        rowCom[z]:removeSelf()
        rowCom[z] = nil
    end
    
    if txtFil == '' then
        tools:setEmpty(rowCom, scrViewR, "No tenemos recompensas para el filtro seleccionado")
    else
        tools:setLoading(true, scrViewR)
        RestManager.getRewards(txtFil)
    end
end

-------------------------------------
-- Genera mas renglones de rewards por comercio
-- @param event objeto evento
-------------------------------------
function loadMore(event)
    local t = event.target
    t.alpha = 0
    
    -- Crear elementos
    for y = 4, #t.rewards, 1 do 
        local idx = #rowRew + 1
        rowRew[idx] = display.newGroup()
        rowRew[idx].y = (y * 80) - 15
        rowCom[t.idxCom]:insert( rowRew[idx] )
        getRowRew(rowRew[idx], t.rewards[y], t.pointsCom)
    end
    
    -- Moover grupos inferiores
    for y = (t.idxCom+1), #rowCom, 1 do 
        transition.to( rowCom[y], { y = rowCom[y].y + (80 * (#t.rewards-3)) - 30, time = 500 })
    end
    
    timer.performWithDelay( 800, function() 
        local newPos = rowCom[#rowCom].y + rowCom[#rowCom].height + 20
        scrViewR:setScrollHeight( newPos )
    end )
end

-------------------------------------
-- Genera un renglon de reward
-- @param parent objeto contenedor
-- @param reward datos del reward
-- @param cpoints puntos del comercio
------------------------------------
function getRowRew(parent, reward, cpoints)
    local bg1 = display.newRect(midW, 0, intW - 20, 70 )
    bg1:setFillColor( 236/255 )
    parent:insert( bg1 )
    local bg2 = display.newRect(midW, 0, intW - 24, 66 )
    bg2:setFillColor( 1 )
    parent:insert( bg2 )
    bg2.idReward = reward.id
    bg2:addEventListener( 'tap', tapReward)

    local bgFav = display.newRect(42, 0, 60, 64 )
    bgFav:setFillColor( 236/255 )
    parent:insert( bgFav )
    bgFav.idReward = reward.id 
    bgFav:addEventListener( 'tap', tapFavRew)
    local bgPoints = display.newRect(110, 0, 80, 64 )
    bgPoints:setFillColor( .21 )
    parent:insert( bgPoints ) 

    bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
    bgFav.iconHeart1:translate( 42, 0 )
    parent:insert( bgFav.iconHeart1 )

    bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
    bgFav.iconHeart2:translate( 42, 0 )
    parent:insert( bgFav.iconHeart2 )

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
            x = 110, y = 0,
            font = fLatoBold,   
            fontSize = 20, align = "center"
        })
        points:rotate( -45 )
        points:setFillColor( 1 )
        parent:insert( points )
    else
        local points = display.newText({
            text = reward.points, 
            x = 110, y = -7,
            font = fLatoBold,   
            fontSize = 26, align = "center"
        })
        points:setFillColor( 1 )
        parent:insert( points )
        local points2 = display.newText({
            text = "TUKS", 
            x = 110, y = 18,
            font = fLatoBold,   
            fontSize = 16, align = "center"
        })
        points2:setFillColor( 1 )
        parent:insert( points2 )
    end

    local name = display.newText({
        text = reward.name, 
        x = 310, y = 0, width = 280,
        font = fLatoRegular,   
        fontSize = 19, align = "left"
    })
    name:setFillColor( .3 )
    parent:insert( name )

    -- Set value Progress Bar
    if cpoints then
        -- Progress Bar
        local progressBar = display.newRect( 0, 0, 300, 5 )
        progressBar:setFillColor( {
            type = 'gradient',
            color1 = { .6, .5 }, 
            color2 = { 1, .5 },
            direction = "bottom"
        } ) 
        progressBar:translate( 310, 30 )
        parent:insert(progressBar)

        local points = tonumber(reward.points)
        local userPoints = tonumber(cpoints)

        -- Usuario con puntos
        if userPoints > 0 or points == 0  then
            local porcentaje, color1, color2

            -- Todos los puntos                
            if points <= userPoints  then
                porcentaje = 1
                color1 = { 157/255, 210/255, 25/255, 1 }
                color2 = { 140/255, 242/255, 14/255, .3 }
            else
                porcentaje  = userPoints/points
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
            progressBar2:translate( 160, 30 )
            parent:insert(progressBar2)
        end
    end
end

-------------------------------------
-- Creamos lista de comercios
-- @param commerces lista de comercios
------------------------------------
function setListReward(commerces)
    lastYP = 140
    tools:setLoading(false)
    
    if #commerces == 0 then
        tools:setEmpty(rowCom, scrViewR, "No tenemos recompensas para el filtro seleccionado")
    else
        for z = 1, #commerces, 1 do 

            rowCom[z] = display.newGroup()
            rowCom[z].y = lastYP
            scrViewR:insert( rowCom[z] )

            local bgC1 = display.newRect(midW, 0, intW - 20, 40 )
            bgC1:setFillColor( unpack(cTurquesa) )
            rowCom[z]:insert( bgC1 )
            local bgC2 = display.newRect(midW, 0, intW - 24, 36 )
            bgC2:setFillColor( unpack(cBlueH) )
            rowCom[z]:insert( bgC2 )

            local titleC = display.newText({
                text = commerces[z].name, 
                x = midW, y = 0, width = 420,
                font = fLatoBold,   
                fontSize = 18, align = "left"
            })
            titleC:setFillColor( 1 )
            rowCom[z]:insert( titleC )

            local rewards = commerces[z].rewards
            local limitRow = 3
            if #rewards < limitRow then limitRow = #rewards end
            for y = 1, limitRow, 1 do 
                local idx = #rowRew + 1
                rowRew[idx] = display.newGroup()
                rowRew[idx].y = (y * 80) - 15
                rowCom[z]:insert( rowRew[idx] )
                getRowRew(rowRew[idx], rewards[y], commerces[z].points)
            end

            if #rewards > 3 then 
                local more = display.newGroup()
                more.y = (4 * 80) - 35
                rowCom[z]:insert( more )

                local bg1 = display.newRoundedRect(midW, 0, 180, 30, 10 )
                bg1.idxCom = z
                bg1.pointsCom = commerces[z].points
                bg1.rewards = rewards
                bg1:addEventListener( 'tap', loadMore)
                bg1:setFillColor( unpack(cGrayL) )
                more:insert( bg1 )

                local c1 = display.newRoundedRect(midW - 25, 0, 15, 15, 7 )
                c1:setFillColor( unpack(cWhite) )
                more:insert( c1 )
                local c2 = display.newRoundedRect(midW, 0, 15, 15, 7 )
                c2:setFillColor( unpack(cWhite) )
                more:insert( c2 )
                local c3 = display.newRoundedRect(midW + 25, 0, 15, 15, 7 )
                c3:setFillColor( unpack(cWhite) )
                more:insert( c3 )

                lastYP = lastYP + 40

            end

            lastYP = lastYP + 55 + (limitRow * 80)
        end
    end
    -- Set new scroll position
    local newPos = rowCom[#rowCom].y + rowCom[#rowCom].height + 20
    scrViewR:setScrollHeight( newPos )
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
-------------------------------------
-- Called immediately before scene has moved onscreen:
-- @param event objeto evento
------------------------------------
function scene:create( event )
	screen = self.view
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
    scrViewR = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewR)
    scrViewR:toBack()
    
    tools:setLoading(true, scrViewR)
    tools:getFilters(scrViewR)
    RestManager.getRewards('1')
    
end	

-------------------------------------
-- Called immediately after scene has moved onscreen:
-- @param event objeto evento
------------------------------------ 
function scene:show( event )
    if event.phase == "will" then 
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
    end
end

-------------------------------------
-- Salir escena
-- @param event objeto evento
------------------------------------ 
function scene:destroy( event )
    tools:delFilters()
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene