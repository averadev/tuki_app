---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------


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
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local DBManager = require('src.DBManager')
local RestManager = require( "src.RestManager" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local tools

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
    local bg = display.newRect( midW, h, intW, intH )
    bg.anchorY = 0
    bg:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "right"
    } ) 
    screen:insert(bg)
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    -- Positions
    local sLn = 0
    local allH = intH - h
    local xTopCode = midH - 60
    local xBottomCode = midH + 140
    if allH > 685 and allH < 750 then
        xTopCode = xTopCode - 20
        xBottomCode = xBottomCode + 25
    elseif allH >= 750 then
        sLn = 10
        xTopCode = xTopCode - 50
        xBottomCode = xBottomCode + 50
    end
    
    local lbl1 = display.newText({
        text = "¡  A   T U K E A R  !",
        x = midW, y = xTopCode - 80, width = 400, 
        font = fontBold,   
        fontSize = 45, align = "center"
    })
    lbl1:setFillColor( unpack(cWhite) )
    screen:insert( lbl1 )
    
    -- Buil format key
    dbConfig = DBManager.getSettings()
    local lblClave = string.sub( dbConfig.id, 0 , 3 ).." "..
                    string.sub( dbConfig.id, 4, 7 ).." "..
                    string.sub( dbConfig.id, 8, 10 ).." "..
                    string.sub( dbConfig.id, 11, 13 )
    
    local lbl2 = display.newText({
        text = 'CD: '..lblClave,
        x = midW, y = xTopCode - 40, width = 400, 
        font = fontSemiBold,   
        fontSize = 20, align = "center"
    })
    lbl2:setFillColor( unpack(cWhite) )
    screen:insert( lbl2 )
    
    local lbl3 = display.newText({
        text = "Haz Check-In en comercios afiliados.",
        x = midW, y = xBottomCode + 50, width = 400, 
        font = fontRegular,   
        fontSize = 18, align = "center"
    })
    lbl3:setFillColor( unpack(cWhite) )
    screen:insert( lbl3 )
    
    local grpQR = display.newGroup()
    screen:insert( grpQR )
    -- Lines
    if allH > 685 then
        local lnRT = display.newLine( midW+(50+sLn), midH-(80+sLn), midW+(130+sLn), midH-(80+sLn), midW+(130+sLn), midH-sLn )
        lnRT.strokeWidth = 3
        screen:insert( lnRT )
        local lnRB = display.newLine( midW+(50+sLn), midH+(180+sLn), midW+(130+sLn), midH+(180+sLn), midW+(130+sLn), midH+(100+sLn) )
        lnRB.strokeWidth = 3
        screen:insert( lnRB )
        local lnLB = display.newLine( midW-(130+sLn), midH+(100+sLn), midW-(130+sLn), midH+(180+sLn), midW-(50+sLn), midH+(180+sLn) )
        lnLB.strokeWidth = 3
        screen:insert( lnLB )
        local lnLT = display.newLine( midW-(130+sLn), midH+sLn, midW-(130+sLn), midH-(80+sLn), midW-(50+sLn), midH-(80+sLn) )
        lnLT.strokeWidth = 3
        screen:insert( lnLT )
    end
    
    RestManager.retriveQR(dbConfig.id, grpQR, midW, midH + 50, 270, 270)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        tools:showBubble(false)
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
    end
end

-- Remove Listener
function scene:hide( event )
end

-- Remove Listener
function scene:destroy( event )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

