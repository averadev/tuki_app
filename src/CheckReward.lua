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
    dbConfig = DBManager.getSettings()
    
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
    tools:buildBottomBar()
    screen:insert(tools)
    
    -- Positions
    local sLn = 0
    local allH = intH - h
    local xTopCode = midH - 80
    local xBottomCode = midH + 130
    if allH > 685 and allH < 750 then
        xTopCode = xTopCode - 20
        xBottomCode = xBottomCode + 25
    elseif allH >= 750 then
        sLn = 10
        xTopCode = xTopCode - 40
        xBottomCode = xBottomCode + 40
    end
    
    local lbl1 = display.newText({
        text = "Muestra este codigó en tu próxima visita",
        x = midW, y = xTopCode - 70, width = 400, 
        font = fontBold,   
        fontSize = 32, align = "center"
    })
    lbl1:setFillColor( unpack(cWhite) )
    screen:insert( lbl1 )
    
    local lbl3 = display.newText({
        text = "Canjealo en la Tablet-Tuki y obtén tu recompensa.",
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
        local lnRT = display.newLine( midW+(50+sLn), midH-(100+sLn), midW+(130+sLn), midH-(100+sLn), midW+(130+sLn), midH-(20+sLn) )
        lnRT.strokeWidth = 3
        screen:insert( lnRT )
        local lnRB = display.newLine( midW+(50+sLn), midH+(160+sLn), midW+(130+sLn), midH+(160+sLn), midW+(130+sLn), midH+(80+sLn) )
        lnRB.strokeWidth = 3
        screen:insert( lnRB )
        local lnLB = display.newLine( midW-(130+sLn), midH+(80+sLn), midW-(130+sLn), midH+(160+sLn), midW-(50+sLn), midH+(160+sLn) )
        lnLB.strokeWidth = 3
        screen:insert( lnLB )
        local lnLT = display.newLine( midW-(130+sLn), midH-(20+sLn), midW-(130+sLn), midH-(100+sLn), midW-(50+sLn), midH-(100+sLn) )
        lnLT.strokeWidth = 3
        screen:insert( lnLT )
    end
    
    RestManager.retriveQR(dbConfig.id.."-"..event.params.idReward, screen, midW, midH + 30, 270, 270)
    
    
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
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene