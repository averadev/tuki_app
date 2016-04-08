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
    bg:setFillColor( unpack(cBlueH) )
    screen:insert(bg)
    
    tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
    local allH = intH - h
    local sizeQR = 350
    print("allH: "..allH)
    if allH < 685 then
        sizeQR = 200
    elseif allH < 750 then
        sizeQR = 250
    end
    
    local xTopCode = initY+(hWorkSite/2) - (sizeQR/2)
    local xBottomCode = xTopCode + sizeQR
    
    local lbl2 = display.newText({
        text = "Muestra este codigó en tu próxima visita",
        x = midW, y = xTopCode - 45, width = 400, 
        font = fLatoBold,   
        fontSize = 20, align = "center"
    })
    lbl2:setFillColor( unpack(cWhite) )
    screen:insert( lbl2 )
    
    local lbl3 = display.newText({
        text = "Canjealo con la Tablet-Tuki y obtén tu recompensa",
        x = midW, y = xBottomCode + 30, width = 400, 
        font = fLatoRegular,   
        fontSize = 18, align = "center"
    })
    lbl3:setFillColor( unpack(cWhite) )
    screen:insert( lbl3 )
    
    local bgCode = display.newRect( midW, initY+(hWorkSite/2), sizeQR, sizeQR )
    bgCode:setFillColor( unpack(cTurquesa) )
    screen:insert(bgCode)
    
    RestManager.retriveQR(dbConfig.id.."-"..event.params.idReward, screen, midW, initY+(hWorkSite/2), sizeQR - 20, sizeQR - 20)
    
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
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