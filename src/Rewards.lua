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
        RestManager.setRewardFav(t.idReward, 0)
    else
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
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
        tools:setEmpty(rowCom, scrViewR, "No tenemos recompensas con tu selección")
    else
        tools:setLoading(true, scrViewR, true)
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
    local bg2 = display.newRect(265, 0, 380, 76)
    bg2:setFillColor( unpack(cWhite) )
    bg2.idReward = reward.id
    bg2:addEventListener( 'tap', tapReward)
    parent:insert( bg2 )

    local bgFav = display.newRect(440, 0, 60, 64 )
    bgFav:setFillColor( unpack(cWhite) )
    parent:insert( bgFav )
    bgFav.idReward = reward.id 
    bgFav:addEventListener( 'tap', tapFavRew)

    bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
    bgFav.iconHeart1:translate( 440, 0 )
    parent:insert( bgFav.iconHeart1 )

    bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
    bgFav.iconHeart2:translate( 440, 0 )
    parent:insert( bgFav.iconHeart2 )

    -- Fav actions
    if reward.id == reward.fav  then
        bgFav.id = reward.id 
        bgFav.iconHeart1.alpha = 0
    else
        bgFav.iconHeart2.alpha = 0
    end
    
    local bgPoints = display.newImage("img/deco/bgPoints80.png")
    bgPoints:translate( 60, 0 )
    parent:insert( bgPoints )
    
    -- Textos y descripciones
    if reward.points == 0 or reward.points == "0" then
        local points = display.newText({
            text = "GRATIS", 
            x = 60, y = 0,
            font = fontSemiBold,   
            fontSize = 18, align = "center"
        })
        points:rotate( -45 )
        points:setFillColor( 1 )
        parent:insert( points )
    else
        local points = display.newText({
            text = reward.points, 
            x = 60, y = -12,
            font = fontBold,   
            fontSize = 32, align = "center"
        })
        points:setFillColor( 1 )
        parent:insert( points )
        local points2 = display.newText({
            text = "TUKS", 
            x = 60, y = 15,
            font = fontSemiBold,   
            fontSize = 16, align = "center"
        })
        points2:setFillColor( 1 )
        parent:insert( points2 )
    end

    local name = display.newText({
        text = reward.name, 
        x = 255, y = 0, width = 280,
        font = fontRegular,   
        fontSize = 19, align = "left"
    })
    name:setFillColor( unpack(cBlueH) )
    parent:insert( name )

    -- Set value Progress Bar
    if cpoints then
        -- Progress Bar
        local progressBar = display.newRect( -45, 0, 300, 5 )
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
            else
                porcentaje  = userPoints/points
            end

            local progressBar2 = display.newRect( -45, 0, 300*porcentaje, 5 )
            progressBar2:setFillColor( {
                    type = 'gradient',
                    color1 = { unpack(cBTur) }, 
                    color2 = { unpack(cBBlu) },
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
    lastYP = 155
    tools:setLoading(false)
    
    if #commerces == 0 then
        tools:setEmpty(rowCom, scrViewR, "No tenemos recompensas con tu selección")
    else
        for z = 1, #commerces, 1 do 

            rowCom[z] = display.newGroup()
            rowCom[z].y = lastYP
            scrViewR:insert( rowCom[z] )

            local bgC1 = display.newRect(midW, 0, intW - 20, 40 )
            bgC1:setFillColor( unpack(cBTur) )
            rowCom[z]:insert( bgC1 )
            local bgC2 = display.newRect(midW, 0, intW - 24, 36 )
            bgC2:setFillColor( unpack(cWhite) )
            rowCom[z]:insert( bgC2 )

            local titleC = display.newText({
                text = commerces[z].name, 
                x = midW, y = 0, width = 420,
                font = fontSemiBold,   
                fontSize = 18, align = "left"
            })
            titleC:setFillColor( unpack(cBlueH) )
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
                more.y = (4 * 80) - 30
                rowCom[z]:insert( more )

                local bg1 = display.newRoundedRect(midW, 0, 130, 30, 10 )
                bg1.idxCom = z
                bg1.pointsCom = commerces[z].points
                bg1.rewards = rewards
                bg1:addEventListener( 'tap', loadMore)
                bg1:setFillColor( {
                    type = 'gradient',
                    color1 = { unpack(cBBlu) }, 
                    color2 = { unpack(cBTur) },
                    direction = "right"
                } )
                more:insert( bg1 )

                local c1 = display.newRoundedRect(midW - 25, 0, 10, 10, 5 )
                c1:setFillColor( unpack(cWhite) )
                more:insert( c1 )
                local c2 = display.newRoundedRect(midW, 0, 10, 10, 5 )
                c2:setFillColor( unpack(cWhite) )
                more:insert( c2 )
                local c3 = display.newRoundedRect(midW + 25, 0, 10, 10, 5 )
                c3:setFillColor( unpack(cWhite) )
                more:insert( c3 )

                lastYP = lastYP + 40

            end

            lastYP = lastYP + 55 + (limitRow * 85)
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
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 60 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 120)
    
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
        tools:showBubble(false)
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