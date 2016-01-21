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
local sCover, coverLeft, coverRight, idxCover

-- Arrays
local covers, currentP, rowPartner = {}, {}, {}
local txtBg, txtFiltro, fpRows = {}, {}, {}




---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Consulta Comercio
-- @param event objeto evento
------------------------------------
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( "src.Partner" )
    storyboard.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = {idCommerce = t.partner.id} })
    return true
end

-------------------------------------
-- Filtrar registros
-- @param txtFil array filters
------------------------------------
function doFilter(txtFil)
    -- Clean Info
    if txtPName then
        covers[idxCover]:removeEventListener( 'tap', tapCommerce)
        coverLeft:removeSelf()
        coverLeft = nil
        coverRight:removeSelf()
        coverRight = nil
        txtPName:removeSelf()
        txtPName = nil
        txtPConcept:removeSelf()
        txtPConcept = nil
        for z = 1, #covers, 1 do 
            covers[z]:removeSelf()
            covers[z] = nil
        end
    end
    for z = 1, #rowPartner, 1 do 
        rowPartner[z]:removeSelf()
        rowPartner[z]:addEventListener( 'tap', tapCommerce )
        rowPartner[z] = nil
    end
    
    if txtFil == '' then
        tools:setEmpty(rowPartner, scrViewP)
    else
        tools:setLoading(true, scrViewP)
        RestManager.getJoined(txtFil)
    end
end

-------------------------------------
-- Crea la lista de comercios
-- @param items lista de items de BD
------------------------------------
function setListCommerce(items)
    -- Valida registros vacios
    if #items == 0 then
        tools:setEmpty(rowPartner, scrViewP)
    else
        -- Recorre registros y arma lista
        for z = 1, #items, 1 do 
            lastYP = 80
            rowPartner[z] = display.newContainer( 480, 95 )
            rowPartner[z]:translate( midW, lastYP + (95*z) )
            scrViewP:insert( rowPartner[z] )

            -- Fondo
            local bg1 = display.newRect( 0, 0, 460, 80 )
            bg1:setFillColor( unpack(cGrayXL) )
            rowPartner[z]:insert( bg1 )
            local bg2 = display.newRect( 0, 0, 452, 72 )
            bg2:setFillColor( unpack(cWhite) )
            bg2.partner = items[z]
            bg2:addEventListener( 'tap', tapCommerce)
            rowPartner[z]:insert( bg2 )

            -- Imagen Comercio
            local bgImg0 = display.newRect( -188, 0, 85, 85 )
            bgImg0:setFillColor( unpack(cGrayH) )
            rowPartner[z]:insert( bgImg0 )
            local bgImg = display.newRect( -188, 0, 75, 75 )
            bgImg:setFillColor( tonumber(items[z].colorA1)/255, tonumber(items[z].colorA2)/255, tonumber(items[z].colorA3)/255 )
            rowPartner[z]:insert( bgImg )
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:translate( -188, 0 )
            img.width = 70
            img.height = 70
            rowPartner[z]:insert( img )

            -- Textos
            local name = display.newText({
                text = items[z].name,     
                x = poscLabels, y = -15, width = 270, 
                font = fLatoBold,   
                fontSize = 22, align = "left"
            })
            name:setFillColor( unpack(cGrayXH) )
            rowPartner[z]:insert( name )

            -- Tuks
            local bgTuks = display.newRect( -144, 20, 184, 30 )
            bgTuks.anchorX = 0
            bgTuks:setFillColor( unpack(cBlueH) )
            rowPartner[z]:insert( bgTuks )
            local lblTuks1 = display.newText({
                text = items[z].points, 
                x = -80, y = 20, width = 60, 
                font = fLatoBold,   
                fontSize = 18, align = "right"
            })
            lblTuks1:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblTuks1 )
            local lblTuks2 = display.newText({
                text = "TUKS", 
                x = -15, y = 20, width = 60, 
                font = fLatoRegular,   
                fontSize = 12, align = "left"
            })
            lblTuks2:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblTuks2 )

            -- Rewards
            local bgRew = display.newRect( 41, 20, 184, 30 )
            bgRew.anchorX = 0
            bgRew:setFillColor( unpack(cPurple) )
            rowPartner[z]:insert( bgRew )
            local iconMedal = display.newImage("img/icon/iconMedalSmall.png")
            iconMedal.alpha = .7
            iconMedal:translate( 110, 20 )
            rowPartner[z]:insert( iconMedal )
            local lblTuks1 = display.newText({
                text = items[z].posible, 
                x = 110, y = 20, width = 60, 
                font = fLatoRegular,   
                fontSize = 18, align = "right"
            })
            lblTuks1:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblTuks1 )
            local lblTuks2 = display.newText({
                text = " / "..items[z].rewards, 
                x = 170, y = 20, width = 60, 
                font = fLatoRegular,   
                fontSize = 12, align = "left"
            })
            lblTuks2:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblTuks2 )

        end
        -- Set new scroll position
        scrViewP:setScrollHeight(lastYP + (95 * #items) + 70)
    end
    tools:setLoading(false)
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    
    tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
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
    
    tools:getFilters(scrViewP)
    tools:setLoading(true, scrViewP)
    RestManager.getJoined('1')
    
    
end	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scenes[#Globals.scenes + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
    tools:delFilters()
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene