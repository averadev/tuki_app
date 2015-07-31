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

-- Grupos y Contenedores
local screen
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local myMap

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    
	local tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local bg = display.newRect( 0, h + 190, display.contentWidth, intH - 320 )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	screen:insert(bg)
    
    myMap = native.newMapView( 0, h + 190, display.contentWidth, intH - 320 )
    if myMap then
        myMap.anchorX = 0
        myMap.anchorY = 0
    end
    
    
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