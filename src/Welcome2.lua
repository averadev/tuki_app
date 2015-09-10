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
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local h = display.topStatusBarContentHeight 
local bgNext
local btns = {}


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function goToEnd(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( "src.Welcome3" )
    storyboard.gotoScene("src.Welcome3", { time = 400, effect = "slideLeft" } )
end

function tapWelcomeFilter(event)
    local t = event.target
    audio.play(fxTap)
    if t.isActive then
        t.isActive = false
        t.bgFP1.alpha = 1
        t.bgFP2.alpha = 0
        t.iconOn.alpha = 0
        t.iconOff.alpha = 1
    else
        t.isActive = true
        t.bgFP1.alpha = 0
        t.bgFP2.alpha = 1
        t.iconOn.alpha = 1
        t.iconOff.alpha = 0
    end
    -- Verify next button
    local isReady = false
    for z = 1, #btns, 1 do
        if btns[z].isActive then
            isReady = true
        end
    end
    if isReady then
        if not (bgNext.isActive) then
            bgNext.isActive = true
            bgNext:setFillColor( 46/255, 190/255, 239/255 )
            bgNext.txt:setFillColor( 1 )
            bgNext:addEventListener( 'tap', goToEnd )
        end
    else
        if bgNext.isActive then
            bgNext.isActive = false
            bgNext:setFillColor( .91 )
            bgNext.txt:setFillColor( .3 )
            bgNext:removeEventListener( 'tap', goToEnd )
        end
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    
    local ajustH = 0
    if intH < 700 then
        ajustH = 45
    elseif intH < 750 then
        ajustH = 25
    end
    
	local tools = Tools:new()
    tools:buildHeader(true)
    screen:insert(tools)
    
    local scrViewW2 = widget.newScrollView
	{
		top = h + 80,
		left = 0,
		width = display.contentWidth,
		height = display.contentHeight - h - 80,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewW2)
    scrViewW2:toBack()
    
    -- Botons
    local bgTitle = display.newRoundedRect( midW, 70, 400, 60, 10 )
    bgTitle:setFillColor( .91 )
    scrViewW2:insert(bgTitle)
    local lblTitle = display.newText({
        text = "¡LO QUE ME GUSTA!",
        x = midW, y = 70,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    lblTitle:setFillColor( .3 )
    scrViewW2:insert( lblTitle )
    
    local isLeft = true
    local xPosc = 0
    local yPosc = 10
    for z = 1, #Globals.filtros, 1 do 
        
        if isLeft then
            xPosc = 135
            isLeft = false
            yPosc = yPosc + 210
        else
            xPosc = 345
            isLeft = true
        end

        local idx = #btns + 1
        btns[idx] = display.newContainer( 190, 190 )
        btns[idx]:translate( xPosc, yPosc )
        btns[idx].isActive = false
        scrViewW2:insert( btns[idx] )
        btns[idx]:addEventListener( 'tap', tapWelcomeFilter)

        btns[idx].bgFP1 = display.newRect(0, 0, 190, 190 )
        btns[idx].bgFP1:setFillColor( 236/255 )
        btns[idx]:insert( btns[idx].bgFP1 )

        btns[idx].bgFP2 = display.newRect(0, 0, 190, 190 )
        btns[idx].bgFP2:setFillColor( 46/255, 190/255, 239/255 )
        btns[idx].bgFP2.alpha = 0
        btns[idx]:insert( btns[idx].bgFP2 )

        btns[idx].iconOn = display.newImage("img/icon/"..Globals.filtros[z][2].."2.png")
        btns[idx].iconOn:translate(0, -10)
        btns[idx].iconOn.height = 100
        btns[idx].iconOn.width = 100
        btns[idx].iconOn.alpha = 0
        btns[idx]:insert( btns[idx].iconOn )

        btns[idx].iconOff = display.newImage("img/icon/"..Globals.filtros[z][2].."1.png")
        btns[idx].iconOff:translate(0, -10)
        btns[idx].iconOff.height = 100
        btns[idx].iconOff.width = 100
        btns[idx]:insert( btns[idx].iconOff )

        btns[idx].txt = display.newText({
            text = Globals.filtros[z][1], 
            x = xPosc, y = yPosc + 60,
            font = native.systemFontBold,   
            fontSize = 16, align = "center"
        })
        btns[idx].txt:setFillColor( .5 )
        scrViewW2:insert( btns[idx].txt )

    end
    
    -- Continuar
    yPosc = yPosc + 150
    bgNext = display.newRoundedRect( midW, yPosc, 400, 60, 10 )
    bgNext.isActive = false
    bgNext:setFillColor( .91 )
    scrViewW2:insert(bgNext)
    bgNext.txt = display.newText({
        text = "CONTINUAR",
        x = midW, y = yPosc,
        font = native.systemFont,   
        fontSize = 22, align = "center"
    })
    bgNext.txt:setFillColor( .3 )
    scrViewW2:insert( bgNext.txt )
    
    -- Set new scroll position
    scrViewW2:setScrollHeight(yPosc + 60)
    
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