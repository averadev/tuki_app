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
local partnerFav = {{"imgPartner1.jpg", "El Encanto", "Brochetas" }, 
                    {"imgPartner2.jpg", "Dulce Tentación", "Cafe y Postres"}, 
                    {"imgPartner3.jpg", "Maria Bonita", "Comida Mexicana"}, 
                    {"imgPartner4.jpg", "Arte Taurino", "Tapas y Carnes Frias"}, 
                    {"imgPartner5.jpg", "La Plaza", "Cafeteria"}, 
                    {"imgPartner6.jpg", "Linda Argentina", "Cortes Argentinos"}, 
                    {"imgPartner7.jpg", "Happy Rainbow", "Pasteleria"}}
local filtroP = {"HOTELES", "PARQUES", "ANTROS", "VIAJES", "RESTAURANTES", "HOTELES", "PARQUES", "ANTROS", "ENTRETENIMIENTO", "BARES", "RESTAURANTES",}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Crea el coverflow de comercios destacados
function getCoverFirstFlow()
    -- Get first covers
    lastX = -40
    for z = 1, 3, 1 do 
        createCover(partnerFav[z])
    end
    
    covers[1].x = 110
    covers[3].x = 370
    
    covers[2].alpha = 1
    covers[2]:toFront()
    covers[2].y = 130
    covers[2].bg.width = 236
    covers[2].bg.height = 236
    covers[2].img.width = 220
    covers[2].img.height = 220
    
    txtPName = display.newText({
        text = covers[2].name,     
        x = midW, y = 270, width = 440,
        font = native.systemFontBold,   
        fontSize = 26, align = "center"
    })
    txtPName:setFillColor( .3 )
    scrViewP:insert(txtPName)

    txtPConcept = display.newText({
        text = covers[2].concept,     
        x = midW, y = 300, width = 440,
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
    lastX = lastX + 140
    
    covers[idx] = display.newContainer( 226, 226 )
    covers[idx].alpha = .5
    covers[idx]:translate( midW, 100 )
    covers[idx].name = partner[2]
    covers[idx].concept = partner[3]
    scrViewP:insert( covers[idx] )
    
    covers[idx].bg = display.newRect(0, 0, 186, 186 )
    covers[idx].bg:setFillColor( .58 )
    covers[idx]:insert( covers[idx].bg )
    
    covers[idx].img = display.newImage("img/deco/"..partner[1])
    covers[idx].img:translate( 0, 0 )
    covers[idx].img.width = 180
    covers[idx].img.height = 180
    covers[idx]:insert( covers[idx].img )
end

-- Evento opcion filtro
function tapFilterPartner(event)
    local t = event.target
    if t.set then
        t.set = false
        t:setFillColor( .91 )
        txtFiltro[t.idx]:setFillColor( .68 )
    else
        t.set = true
        t:setFillColor( .15, .72, .91 )
        txtFiltro[t.idx]:setFillColor( 1 )
    end
    return true
end

-- Creamos filtros del comercio
function filterPartner()
    local lastY = 350
    local fieldBlueSearch = display.newImage("img/deco/fieldBlueSearch.png")
    fieldBlueSearch:translate(midW, lastY)
    scrViewP:insert( fieldBlueSearch )
    
    local fpx = 20
    local fpy = 410
    for z = 1, #filtroP, 1 do 
        txtBg[z] = display.newRoundedRect( fpx, fpy, 100, 45, 10 )
        txtBg[z].anchorX = 0
        txtBg[z].idx = z
        txtBg[z].set = false
        txtBg[z]:setFillColor( .91 )
        txtBg[z]:addEventListener( 'tap', tapFilterPartner)
        scrViewP:insert( txtBg[z] )
        
        txtFiltro[z] = display.newText({
            text = filtroP[z],     
            x = fpx + 10, y = fpy,
            font = native.systemFont,   
            fontSize = 14, align = "left"
        })
        txtFiltro[z].anchorX = 0
        txtFiltro[z]:setFillColor( .68 )
        scrViewP:insert( txtFiltro[z] )
        -- Resize background
        txtBg[z].width = txtFiltro[z].width + 20
        
        -- Set new X
        if txtBg[z].x + txtBg[z].width > 460 then
            fpx = 20
            fpy = fpy + 55
            txtBg[z].x = fpx
            txtBg[z].y = fpy
            txtFiltro[z].x = fpx + 10
            txtFiltro[z].y = fpy
            fpRows[#fpRows + 1] = z - 1
        end
        fpx = txtBg[z].x + txtBg[z].width + 15
    end
    lastYP = fpy
    fpRows[#fpRows + 1] = #filtroP
    
    -- Reorder
    for z = 1, #fpRows, 1 do 
        local lastBG = 1
        if z > 1 then 
           lastBG = fpRows[z - 1] + 1
        end
        
        if lastBG < fpRows[z] then
            local xtraX = 460 - (txtBg[fpRows[z]].x + txtBg[fpRows[z]].width)
            local xtraByP = xtraX / (fpRows[z] - lastBG)
            
            local noY = 1
            for y = lastBG + 1, fpRows[z], 1 do 
                txtBg[y].x = txtBg[y].x + (xtraByP * noY)
                txtFiltro[y].x = txtFiltro[y].x + (xtraByP * noY)
                noY = noY + 1
            end
        end
    end
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
        
        
        local img = display.newImage("img/deco/"..currentP[z][1])
        img:translate( -160, 0 )
        img.width = 100
        img.height = 100
        rowPartner[z]:insert( img )
        local mask = graphics.newMask( "img/deco/mask100.jpg" )
        img:setMask( mask )
        
        local PLinfo = display.newImage("img/icon/PLinfo.png")
        PLinfo:translate( 190, 0 )
        PLinfo.alpha = .7
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
            local line = display.newLine(- 200, 119, 200, 119)
            line:setStrokeColor( .58, .3 )
            line.strokeWidth = 2
            rowPartner[z]:insert(line)
        end
    end
end

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
    
    local initY = h + 190 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 270)
    
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