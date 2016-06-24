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

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local myMap, tools, latitude, longitude
local isIcons = true

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
local locationHandler = function( event )
	-- Check for error (user may have turned off Location Services)
    Runtime:removeEventListener( "location", locationHandler )
    if isIcons then
        if event.errorCode then
        else
            if myMap then
                latitude, longitude = event.latitude, event.longitude
                myMap:setRegion( latitude, longitude, 0.02, 0.02 )
                isIcons = false
                local function listener( event )
                    tools:toFront()
                    RestManager.getCommercesByGPSLite(latitude, longitude)
                end
                timer.performWithDelay( 1500, listener, 1 )
            end
        end
    end
end

-------------------------------------
-- Genera los iconos para mostrarlos en el mapa
-- @param items listado de comercios
------------------------------------
function setIconMap(items)
    if myMap then
        for y = 1, #items, 1 do 
            local options = { 
                title = items[y].name,
                subtitle = items[y].description.."\n"..items[y].address, 
                imageFile = "img/icon/"..Globals.filtros[tonumber(items[y].idCategory)][2]..".png"
                --imageFile = { filename=items[y].image, baseDir=system.TemporaryDirectory }
            }
            myMap:addMarker( tonumber(items[y].lat), tonumber(items[y].long), options )
        end
    end
end

-------------------------------------
-- Mueve el mapa a una determinada direccion
-- @param position nueva posicion del mapa
------------------------------------
function moveMap(position)
    if myMap then
        transition.to( myMap, { x = position, time = 400, transition = easing.outExpo })
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local bg = display.newRect( 0, h + 140, display.contentWidth, intH - h - 220 )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	screen:insert(bg)
    
    tools:toFront()
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        isIcons = true
        tools:showBubble(false)
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
        print("Mapa")
        myMap = native.newMapView( 0, h + 140, display.contentWidth, intH - h - 220 )
        if myMap then
            myMap.anchorX = 0
            myMap.anchorY = 0
            tools:toFront()
            Runtime:addEventListener( "location", locationHandler )
        else
            print("Not Map")
        end
        
    end
end

-- Remove Listener
function scene:hide( event )
	if myMap then
        Runtime:removeEventListener( "location", locationHandler )
        myMap:removeSelf()
        myMap = nil
    end
end

-- Remove Listener
function scene:destroy( event )
	if myMap then
        Runtime:removeEventListener( "location", locationHandler )
        myMap:removeSelf()
        myMap = nil
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene