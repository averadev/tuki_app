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

-- Grupos y Contenedores
local screen, scrCities, tools
local scene = composer.newScene()

-- Variables
local iconCheck, txtSearch
local rowCity = {}



---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function onTxtFocus(event)
    if ( "submitted" == event.phase ) then
        -- Hide Keyboard
        native.setKeyboardFocus(nil)
        getCities()
    end
end

function getCities()
    print(txtSearch.text)
    if not(txtSearch.text) or txtSearch.text == '' then
        RestManager.getCities('-')
    else 
        RestManager.getCities(txtSearch.text)
    end 
end 

function setCity(event)
    audio.play(fxTap)
    local t = event.target
    RestManager.setCity(t.idCity)
    -- Agregar al row
    if iconCheck then
        iconCheck:removeSelf()
        iconCheck = nil
    end
    iconCheck = display.newImage("img/icon/iconCheck.png")
    iconCheck:translate( -180, 0)
    t:insert( iconCheck )
    -- Clear Home Memory
    composer.removeScene( "src.Home" )
end 

function showCities(items)
    
    tools:setLoading(false)
    if iconCheck then
        iconCheck:removeSelf()
        iconCheck = nil
    end
    for z = 1, #rowCity, 1 do 
        rowCity[z]:removeSelf()
        rowCity[z]:removeEventListener( 'tap', setCity )
        rowCity[z] = nil
    end
    
    for z = 1, #items, 1 do 
        rowCity[z] = display.newContainer( intW, 65 )
        rowCity[z]:translate( midW, (z*65) - 20 )
        rowCity[z].idCity = items[z].id
        rowCity[z]:addEventListener( 'tap', setCity )
        scrCities:insert( rowCity[z] )
        
        if items[z].user then
            iconCheck = display.newImage("img/icon/iconCheck.png")
            iconCheck:translate( -180, 0)
            rowCity[z]:insert( iconCheck )
        end
        
        local lblInfo = display.newText({
            text = items[z].name,     
            x = 0, y = 0,  
            width = 300, font = fLato,   
            fontSize = 20, align = "left"
        })
        lblInfo:setFillColor( unpack(cBlueH) )
        rowCity[z]:insert( lblInfo )
        
        local lineRow = display.newRect( 0, 32, intW, 1 )
        lineRow:setFillColor( unpack(cGrayL) )
        lineRow.alpha = .3
        rowCity[z]:insert(lineRow)
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
    local hWorkSite = intH - (h + 120)
    
    local bgSearch = display.newRect( midW, initY + 40, intW, 80 )
    bgSearch:setFillColor( unpack(cGrayL) )
    screen:insert(bgSearch)
    
    local bgTxtS = display.newRoundedRect( midW, initY + 40, 350, 45, 20 )
    bgTxtS:setFillColor( unpack(cWhite) )
    screen:insert(bgTxtS)
    
    txtSearch = native.newTextField( midW - 10, initY + 40, 280, 35 )
    txtSearch.size = 20
    txtSearch.hasBackground = false
    txtSearch.placeholder = "Busca tu ciudad"
    txtSearch:addEventListener( "userInput", onTxtFocus )
    
    local iconSearch = display.newImage("img/icon/iconSearch.png")
    iconSearch:translate( midW + 150, initY + 40)
    iconSearch:addEventListener( 'tap', getCities )
    screen:insert( iconSearch )
    
    scrCities = widget.newScrollView
	{
		top = initY + 80,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite - 105,
		horizontalScrollDisabled = true,
		--backgroundColor = { unpack(cGrayXL) }
	}
	screen:insert(scrCities)
    tools:toFront()
    tools:setLoading(true, screen)
    getCities()
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
    if txtSearch then
        native.setKeyboardFocus(nil)
        txtSearch:removeSelf()
        txtSearch = nil
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene