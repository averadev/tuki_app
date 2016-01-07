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
local Globals = require( "src.Globals" )
local storyboard = require( "storyboard" )
local DBManager = require('src.DBManager')
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen, scrViewP
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local txtPName, txtPConcept, lastYP
local sCover, coverLeft, coverRight, idxCover, dbConfig

-- Arrays
local covers, currentP, rowPartner = {}, {}, {}
local txtBg, txtFiltro, fpRows = {}, {}, {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------



---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
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
    
    local lbl1 = display.newText({
        text = "¡Hola!, tu codigó es:",
        x = midW, y = xTopCode - 70, width = 400, 
        font = fLatoRegular,   
        fontSize = 22, align = "center"
    })
    lbl1:setFillColor( unpack(cWhite) )
    screen:insert( lbl1 )
    
    -- Buil format key
    local lblClave = string.sub( dbConfig.id, 0 , 3 ).." "..
                    string.sub( dbConfig.id, 4, 7 ).." "..
                    string.sub( dbConfig.id, 8, 10 ).." "..
                    string.sub( dbConfig.id, 11, 13 )
    
    local lbl2 = display.newText({
        text = lblClave,
        x = midW, y = xTopCode - 40, width = 400, 
        font = fLatoBold,   
        fontSize = 20, align = "center"
    })
    lbl2:setFillColor( unpack(cWhite) )
    screen:insert( lbl2 )
    
    local lbl3 = display.newText({
        text = "Haz CheckIn en comercios afiliados TUKI",
        x = midW, y = xBottomCode + 30, width = 400, 
        font = fLatoRegular,   
        fontSize = 18, align = "center"
    })
    lbl3:setFillColor( unpack(cWhite) )
    screen:insert( lbl3 )
    
    local bgCode = display.newRect( midW, initY+(hWorkSite/2), sizeQR, sizeQR )
    bgCode:setFillColor( unpack(cTurquesa) )
    screen:insert(bgCode)
    
    local path = system.pathForFile( dbConfig.id..".png", system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        
        local qr = display.newImage( dbConfig.id..".png", system.TemporaryDirectory )
        qr:translate( midW, initY+(hWorkSite/2) )
        qr.width = sizeQR - 20
        qr.height = sizeQR - 20
        screen:insert(qr)
    end
    
    
end	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scenes[#Globals.scenes + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene