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
local screen, scrViewP
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local lastX = 0
local txtPName, txtPConcept, lastYP

-- Arrays
local covers, currentP, rowPartner = {}, {}, {}
local txtBg, txtFiltro, fpRows = {}, {}, {}
local partnerFav = {{"imgPartner1.png", "Las Brochetas Grill", "Brochetas y Tragos", {.2, .5, .7}, 1}, 
                    {"imgPartner2.png", "Dulce Tentación", "Cafe y Postres", {.2, .7, .2}, 0}, 
                    {"imgPartner3.png", "Maria Bonita", "Comida Mexicana", {.5, .2, .7}, 1}, 
                    {"imgPartner4.png", "Arte Taurino", "Tapas y Carnes Frias", {.7, .2, .2}, 0}, 
                    {"imgPartner5.png", "La Plaza", "Cafeteria", {.7, .2, .7}, 0}, 
                    {"imgPartner6.png", "Linda Argentina", "Cortes Argentinos", {.5, .5, .2}, 1}, 
                    {"imgPartner7.png", "La Perla", "Pasteleria", {.7, .7, .2}, 1}}


local filtroP = {{"TODO", "iconFilter"}, {"HOGAR", "iconFilter"}, {"COMPRAS", "iconFilter"}, {"MODA", "iconFilter"}, 
                 {"CAFE", "iconFilter"}, {"NIÑOS", "iconFilter"}, {"ANTROS", "iconFilter"}, {"COMIDA", "iconFilter"}}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Crea el coverflow de comercios destacados
function getCoverFirstFlow()
    -- Get first covers
    for z = 1, 3, 1 do 
        createCover(partnerFav[z])
    end
    
    covers[1].x = 120
    covers[3].x = 360
    
    covers[2].alpha = 1
    covers[2]:toFront()
    covers[2].y = 220
    covers[2].bg.width = 240
    covers[2].bg.height = 150
    covers[2].img.width = 220
    covers[2].img.height = 90
    
    txtPName = display.newText({
        text = covers[2].name,     
        x = midW, y = 315, width = 440,
        font = native.systemFontBold,   
        fontSize = 26, align = "center"
    })
    txtPName:setFillColor( .3 )
    scrViewP:insert(txtPName)

    txtPConcept = display.newText({
        text = covers[2].concept,     
        x = midW, y = 340, width = 440,
        font = native.systemFont,   
        fontSize = 20, align = "center"
    })
    txtPConcept:setFillColor( .68 )
    scrViewP:insert(txtPConcept)
    
end

-- Creamos un cover
function createCover()
    local idx = #covers + 1
    local partner = partnerFav[idx]
    
    covers[idx] = display.newContainer( 240, 150 )
    covers[idx].alpha = .5
    covers[idx]:translate( midW, 200 )
    covers[idx].name = partner[2]
    covers[idx].concept = partner[3]
    scrViewP:insert( covers[idx] )
    
    covers[idx].bg = display.newRoundedRect(0, 0, 200, 125, 10 )
    covers[idx].bg:setFillColor( partner[4][1], partner[4][2], partner[4][3] )
    covers[idx]:insert( covers[idx].bg )
    
    covers[idx].img = display.newImage("img/deco/"..partner[1])
    covers[idx].img.height = 80
    covers[idx].img.width = 200
    covers[idx].img:translate( 0, 0 )
    
    covers[idx]:insert( covers[idx].img )
    
end

-- Creamos filtros del comercio
function tapFilter(event)
    local t = event.target
    if t.bgFP1.alpha == 0 then
        t.bgFP1.alpha = 1
        t.bgFP2.alpha = 1
        t.iconOn.alpha = 1
        t.iconOff.alpha = 0
        t.txt:setFillColor( 1 )
    else
        t.bgFP1.alpha = 0
        t.bgFP2.alpha = 0
        t.iconOn.alpha = 0
        t.iconOff.alpha = 1
        t.txt:setFillColor( .68 )
    end
end

-- Creamos filtros del comercio
function filterPartner()
    
    local bgFP = display.newRect(midW, 435, intW, 150 )
    bgFP:setFillColor( 246/255, 252/255, 1 )
    scrViewP:insert( bgFP )
    
    for z = 1, #filtroP, 1 do 
        local xPosc = (z * 130) - 65
        
        local bg = display.newContainer( 150, 150 )
        bg:translate( xPosc, 435 )
        scrViewP:insert( bg )
        bg:addEventListener( 'tap', tapFilter)
        
        bg.bgFP1 = display.newRoundedRect(0, 0, 130, 130, 10 )
        bg.bgFP1:setFillColor( 236/255 )
        bg.bgFP1.alpha = 0
        bg:insert( bg.bgFP1 )
        
        bg.bgFP2 = display.newRoundedRect(0, 0, 120, 120, 10 )
        bg.bgFP2:setFillColor( 46/255, 190/255, 239/255 )
        bg.bgFP2.alpha = 0
        bg:insert( bg.bgFP2 )
        
        bg.iconOn = display.newImage("img/icon/"..filtroP[z][2].."On.png")
        bg.iconOn:translate(0, -10)
        bg.iconOn.alpha = 0
        bg:insert( bg.iconOn )
        
        bg.iconOff = display.newImage("img/icon/"..filtroP[z][2].."Off.png")
        bg.iconOff:translate(0, -10)
        bg:insert( bg.iconOff )
        
        bg.txt = display.newText({
            text = filtroP[z][1], 
            x = -5, y = 35, width = 120, 
            font = native.systemFontBold,   
            fontSize = 16, align = "center"
        })
        bg.txt:setFillColor( .68 )
        bg:insert( bg.txt )
        
        -- Activate All
        if z == 1 then
            tapFilter({target = bg})
        end
        -- 202
        --#filtroP
    end
    
    local fieldBlueSearch = display.newImage("img/deco/fieldBlueSearch.png")
    fieldBlueSearch:translate(midW, 540)
    scrViewP:insert( fieldBlueSearch )
    
    lastYP = 520
end 

-- Creamos lista de comercios
function setListPartner()
    for z = 1, #currentP, 1 do 
        rowPartner[z] = display.newContainer( 480, 120 )
        rowPartner[z]:translate( midW, lastYP + (120*z) )
        scrViewP:insert( rowPartner[z] )
        
        local bg = display.newRect( 0, 0, 480, 118 )
        bg.alpha = 0
        bg:setFillColor( 1 )
        rowPartner[z]:insert( bg )
        
        local bgImg = display.newRoundedRect(-160, 0, 128, 80, 7 )
        bgImg:setFillColor( currentP[z][4][1], currentP[z][4][2], currentP[z][4][3] )
        rowPartner[z]:insert( bgImg )
        
        local img = display.newImage("img/deco/"..currentP[z][1])
        img:translate( -160, 0 )
        img.width = 122
        img.height = 50
        rowPartner[z]:insert( img )
        
        local isAfil = "partnersAfili.png"
        if currentP[z][5] == 1 then
            isAfil = "partnersNext.png"
        end
        local PLinfo = display.newImage("img/icon/"..isAfil)
        PLinfo:translate( 190, 0 )
        rowPartner[z]:insert( PLinfo )
        
        local name = display.newText({
            text = currentP[z][2],     
            x = 70, y = -15, width = 300, 
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        name:setFillColor( .3 )
        rowPartner[z]:insert( name )
        
        local concept = display.newText({
            text = currentP[z][3], 
            x = 70, y = 15, width = 300, 
            font = native.systemFont,   
            fontSize = 20, align = "left"
        })
        concept:setFillColor( .68 )
        rowPartner[z]:insert( concept )
        
        if z < #currentP then
            local line = display.newRect( 0, 59, 400, 2 )
            line:setFillColor( .58, .3 )
            rowPartner[z]:insert( line )
        end
    end
    -- Set new scroll position
    scrViewP:setScrollHeight(lastYP + (120 * #currentP) + 65)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    
	local tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 80 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 160)
    
    scrViewP = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewP)
    scrViewP:toBack()
    tools:buildNavBar(scrViewP)
    
    getCoverFirstFlow()
    filterPartner()
    currentP = partnerFav
    setListPartner()
    
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