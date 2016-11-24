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
local rowReward = {}
local txtBg, txtFiltro, fpRows = {}, {}, {}




---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-- Tap toggle event
function tapFavFavs(event)
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
    for z = 1, #rowReward, 1 do 
        rowReward[z]:removeSelf()
        rowReward[z] = nil
    end
    
    if txtFil == '' then
        tools:setEmpty(rowReward, scrViewR, "No tienes recompensas favoritas con tu selección")
    else
        lastYP = 80
        tools:setLoading(true, scrViewR, true)
        RestManager.getRewardFavs(txtFil)
    end
end

-- Tap toggle event
function tapToggle(event)
    local t = event.target
    if not (t.active) then
        t.active = true
        t:setFillColor( 46/255, 190/255, 239/255 )
        t.txt:setFillColor( 1)
        if t.isMe then
            btnToggle2.active = false
            btnToggle2:setFillColor( 236/255 )
            btnToggle2.txt:setFillColor( .5 )
        else
            btnToggle1.active = false
            btnToggle1:setFillColor( 236/255 )
            btnToggle1.txt:setFillColor( .5 )
        end
    end
end

-- Tap reward event
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Reward" )
    composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
end

-- Creamos lista de comercios
function setListReward(rewards)
    lastYP = 70
    tools:setLoading(false)
    
    if #rewards == 0 then
        tools:setEmpty(rowReward, scrViewR, "No tienes recompensas favoritas con tu selección")
    else
        for z = 1, #rewards, 1 do 
            
            rowReward[z] = display.newContainer( 462, 105 )
            rowReward[z]:translate( midW, lastYP + (105*z) )
            scrViewR:insert( rowReward[z] )

            local bg2 = display.newRect(10, 0, 380, 76 )
            bg2:setFillColor( unpack(cWhite) )
            rowReward[z]:insert( bg2 )
            bg2.idReward = rewards[z].id
            bg2:addEventListener( 'tap', tapReward)

            local bgFav = display.newRect(205, 0, 40, 74 )
            bgFav:setFillColor( unpack(cWhite) )
            rowReward[z]:insert( bgFav )
            bgFav.idReward = rewards[z].id
            bgFav:addEventListener( 'tap', tapFavFavs)

            bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
            bgFav.iconHeart1:translate( 205, 0 )
            rowReward[z]:insert( bgFav.iconHeart1 )

            bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
            bgFav.iconHeart2:translate( 205, 0 )
            rowReward[z]:insert( bgFav.iconHeart2 )

            -- Fav actions
            if rewards[z].id == rewards[z].fav  then
                bgFav.id = rewards[z].id 
                bgFav.iconHeart1.alpha = 0
            else
                bgFav.iconHeart2.alpha = 0
            end
            
            local bgPoints = display.newImage("img/deco/bgPoints80.png")
            bgPoints:translate( -180, 0 )
            rowReward[z]:insert( bgPoints )

            -- Textos y descripciones
            if rewards[z].points == 0 or rewards[z].points == "0" then
                local points = display.newText({
                    text = "GRATIS", 
                    x = -180, y = 0,
                    font = fontSemiBold,   
                    fontSize = 18, align = "center"
                })
                points:rotate( -45 )
                points:setFillColor( 1 )
                rowReward[z]:insert( points )
            else
                local points = display.newText({
                    text = rewards[z].points, 
                    x = -180, y = -12,
                    font = fontBold,   
                    fontSize = 32, align = "center"
                })
                points:setFillColor( 1 )
                rowReward[z]:insert( points )
                local points2 = display.newText({
                    text = "TUKS", 
                    x = -180, y = 15,
                    font = fontSemiBold,   
                    fontSize = 16, align = "center"
                })
                points2:setFillColor( 1 )
                rowReward[z]:insert( points2 )
            end

            local name = display.newText({
                text = rewards[z].name, 
                x = 20, y = 0, width = 280,
                font = fontRegular,   
                fontSize = 19, align = "left"
            })
            name:setFillColor( unpack(cBlueH) )
            rowReward[z]:insert( name )
            
            if z < #rewards then
                local lnDot480 = display.newImage("img/deco/dot400Gray.png")
                lnDot480.width = 480
                lnDot480:translate( 0, 51 )
                rowReward[z]:insert( lnDot480 )
            end
            
            -- Set value Progress Bar
            local usrPoints
            if rewards[z].userPoints then
                usrPoints = tonumber(rewards[z].userPoints)
            end
            if usrPoints then
                -- Progress Bar
                local progressBar = display.newRect( -50, 0, 300, 7 )
                progressBar:setFillColor( {
                    type = 'gradient',
                    color1 = { .6, .5 }, 
                    color2 = { 1, .5 },
                    direction = "bottom"
                } ) 
                progressBar:translate( 70, 30 )
                rowReward[z]:insert(progressBar)

                local points = tonumber(rewards[z].points)
                -- Usuario con puntos
                if usrPoints > 0 or points == 0  then
                    local porcentaje, color1, color2

                    -- Todos los puntos                
                    if points <= usrPoints  then
                        porcentaje = 1
                    else
                        porcentaje  = usrPoints/points
                    end

                    local progressBar2 = display.newRect( -50, 0, 300*porcentaje, 7 )
                    progressBar2:setFillColor( {
                        type = 'gradient',
                        color1 = { unpack(cBTur) }, 
                        color2 = { unpack(cBBlu) },
                        direction = "top"
                    } ) 
                    progressBar2.anchorX = 0
                    progressBar2:translate( -80, 30 )
                    rowReward[z]:insert(progressBar2)
                end
            end
            

        end
        -- Set new scroll position
        scrViewR:setScrollHeight(lastYP + (106 * #rewards) + 65)
    end
    
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 60 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 110)
    
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
    
    tools:getFilters(scrViewR)
    tools:setLoading(true, scrViewR)
    RestManager.getRewardFavs('1')
    
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
    tools:delFilters()
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene