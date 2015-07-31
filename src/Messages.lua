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