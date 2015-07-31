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
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require( "src.Globals" )
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen, scrViewR, tools
local scene = storyboard.newScene()

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

-- Tap filter event
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
    storyboard.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
end

-- Tap toggle event
function tapFav(event)
    local t = event.target
    audio.play( fxFav )
    if t.iconHeart2.alpha == 0 then
        t:setFillColor( 46/255, 190/255, 239/255 )
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
    else
        t:setFillColor( 236/255 )
        t.iconHeart1.alpha = 1
        t.iconHeart2.alpha = 0
    end
    return true
end

-- Creamos filtros del comercio
function filterReward()
    
    local scrViewF = widget.newScrollView
	{
		top = 0,
		left = 10,
		width = display.contentWidth - 20,
		height = 120,
		verticalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	scrViewR:insert(scrViewF)
    
    for z = 1, #Globals.filtros, 1 do 
        local xPosc = (z * 94) - 55
        
        local bg = display.newContainer( 90, 90 )
        bg:translate( xPosc, 60 )
        scrViewF:insert( bg )
        bg:addEventListener( 'tap', tapFilter)
        
        bg.bgFP1 = display.newRect(0, 0, 100, 100 )
        bg.bgFP1:setFillColor( 236/255 )
        bg:insert( bg.bgFP1 )
        
        bg.bgFP2 = display.newRect(0, 0, 90, 90 )
        bg.bgFP2:setFillColor( 46/255, 190/255, 239/255 )
        bg.bgFP2.alpha = 0
        bg:insert( bg.bgFP2 )
        
        bg.iconOn = display.newImage("img/icon/"..Globals.filtros[z][2].."On.png")
        bg.iconOn:translate(0, -10)
        bg.iconOn.alpha = 0
        bg:insert( bg.iconOn )
        
        bg.iconOff = display.newImage("img/icon/"..Globals.filtros[z][2].."Off.png")
        bg.iconOff:translate(0, -10)
        bg:insert( bg.iconOff )
        
        bg.txt = display.newText({
            text = Globals.filtros[z][1], 
            x = xPosc, y = 90,
            font = native.systemFontBold,   
            fontSize = 13, align = "center"
        })
        bg.txt:setFillColor( .5 )
        scrViewF:insert( bg.txt )
        
        -- Activate All
        if z == 1 then
            tapFilter({target = bg})
        end
    end
    -- Set new scroll position
    scrViewF:setScrollWidth((100 * #Globals.filtros) - 10)
    
    -- Toggle Button
    local bgToggle1 = display.newRect(midW, 160, intW - 20, 62 )
    bgToggle1:setFillColor( 236/255 )
    scrViewR:insert( bgToggle1 )
    local bgToggle2 = display.newRect(midW, 160, intW - 24, 58 )
    bgToggle2:setFillColor( 1 )
    scrViewR:insert( bgToggle2 )
    
    btnToggle1 = display.newRect(125, 160, 220, 50 )
    btnToggle1:setFillColor( 236/255 )
    btnToggle1.isMe = true
    btnToggle1.active = true
    scrViewR:insert( btnToggle1 )
    btnToggle1:addEventListener( 'tap', tapToggle)
    btnToggle2 = display.newRect(355, 160, 220, 50 )
    btnToggle2:setFillColor( 236/255 )
    btnToggle2.isMe = false
    btnToggle1.active = false
    scrViewR:insert( btnToggle2 )
    btnToggle2:addEventListener( 'tap', tapToggle)
    
    btnToggle1.txt = display.newText({
        text = "MIS RECOMPENSAS", 
        x = 130, y = 160,
        font = native.systemFontBold,   
        fontSize = 13, align = "center"
    })
    btnToggle1.txt:setFillColor( .5 )
    scrViewR:insert( btnToggle1.txt )
    
    btnToggle2.txt = display.newText({
        text = "EXPLORAR", 
        x = 360, y = 160,
        font = native.systemFontBold,   
        fontSize = 13, align = "center"
    })
    btnToggle2.txt:setFillColor( .5 )
    scrViewR:insert( btnToggle2.txt )
    
    tapToggle({target = btnToggle1})
end 

-- Creamos lista de comercios
function setListReward(rewards)
    lastYP = 160
    tools:setLoading(false)
    
    for z = 1, #rewards, 1 do 
        rowReward[z] = display.newContainer( 462, 95 )
        rowReward[z]:translate( midW, lastYP + (95*z) )
        scrViewR:insert( rowReward[z] )
        
        local bg1 = display.newRect(0, 0, intW - 20, 80 )
        bg1:setFillColor( 236/255 )
        rowReward[z]:insert( bg1 )
        local bg2 = display.newRect(0, 0, intW - 24, 76 )
        bg2:setFillColor( 1 )
        rowReward[z]:insert( bg2 )
        bg2.idReward = rewards[z].id
        bg2:addEventListener( 'tap', tapReward)
        
        local bgFav = display.newRect(-196, 0, 60, 74 )
        bgFav:setFillColor( 236/255 )
        rowReward[z]:insert( bgFav )
        bgFav:addEventListener( 'tap', tapFav)
        local bgPoints = display.newRect(-126, 0, 80, 74 )
        bgPoints:setFillColor( .21 )
        rowReward[z]:insert( bgPoints )
        
        bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
        bgFav.iconHeart1:translate( -196, 0 )
        rowReward[z]:insert( bgFav.iconHeart1 )
        
        bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
        bgFav.iconHeart2:translate( -196, 0 )
        rowReward[z]:insert( bgFav.iconHeart2 )
        
        -- Fav actions
        if rewards[z].id == rewards[z].fav  then
            bgFav.id = rewards[z].id 
            bgFav:setFillColor( 46/255, 190/255, 239/255 )
            bgFav.iconHeart1.alpha = 0
        else
            bgFav.iconHeart2.alpha = 0
        end
        
        -- Textos y descripciones
        if rewards[z].points == 0 or rewards[z].points == "0" then
            local points = display.newText({
                text = "GRATIS", 
                x = -127, y = 0,
                font = native.systemFontBold,   
                fontSize = 20, align = "center"
            })
            points:rotate( -45 )
            points:setFillColor( 1 )
            rowReward[z]:insert( points )
        else
            local points = display.newText({
                text = rewards[z].points, 
                x = -126, y = -7,
                font = native.systemFontBold,   
                fontSize = 26, align = "center"
            })
            points:setFillColor( 1 )
            rowReward[z]:insert( points )
            local points2 = display.newText({
                text = "PUNTOS", 
                x = -126, y = 18,
                font = native.systemFontBold,   
                fontSize = 14, align = "center"
            })
            points2:setFillColor( 1 )
            rowReward[z]:insert( points2 )
        end
        
        local commerce = display.newText({
            text = rewards[z].commerce,     
            x = 70, y = -15, width = 300, 
            font = native.systemFontBold,   
            fontSize = 17, align = "left"
        })
        commerce:setFillColor( .6 )
        rowReward[z]:insert( commerce )
        
        local name = display.newText({
            text = rewards[z].name, 
            x = 70, y = 10, width = 300,
            font = native.systemFont,   
            fontSize = 19, align = "left"
        })
        name:setFillColor( .3 )
        rowReward[z]:insert( name )
        
        if name.height > 25 then
            name.height = 25
            name.text = string.sub(name.text, 0, 30).."..."
            if name.height > 25 then
                name.text = string.sub(name.text, 0, 27).."..."
                if name.height > 25 then
                    name.text = string.sub(name.text, 0, 24).."..."
                end
            end
        end
        
        -- Set value Progress Bar
        if rewards[z].userPoints then
            -- Progress Bar
            local progressBar = display.newRect( 0, 0, 300, 5 )
            progressBar:setFillColor( {
                type = 'gradient',
                color1 = { .6, .5 }, 
                color2 = { 1, .5 },
                direction = "bottom"
            } ) 
            progressBar:translate( 70, 30 )
            rowReward[z]:insert(progressBar)
            
            local points = tonumber(rewards[z].points)
            local userPoints = tonumber(rewards[z].userPoints)
            
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
                progressBar2:translate( -80, 30 )
                rowReward[z]:insert(progressBar2)
            end
        end
        
        
        
    end
    -- Set new scroll position
    scrViewR:setScrollHeight(lastYP + (95 * #rewards) + 65)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
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
    filterReward()
    RestManager.getRewards()
    
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