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
local Globals = require( "src.Globals" )
local composer = require( "composer" )
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen, scrViewP
local scene = composer.newScene()

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
    composer.removeScene( "src.Partner" )
    composer.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = {idCommerce = t.partner.id} })
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
        rowPartner[z]:addEventListener( 'tap', tapCommerce)
        rowPartner[z] = nil
    end
    
    if txtFil == '' then
        tools:setEmpty(rowPartner, scrViewP, "No tenemos comercios cercanos con tu selección")
    else
        lastYP = 80
        tools:setLoading(true, scrViewP)
        RestManager.getCommerces(txtFil)
    end
end

-------------------------------------
-- Crea la lista de comercios
-- @param items lista de items de BD
------------------------------------
function setListCommerce(items)
    -- Valida registros vacios
    if #items == 0 then
        tools:setEmpty(rowPartner, scrViewP, "No tenemos comercios cercanos con tu selección")
    end
    
    -- Recorre registros y arma lista
    lastYP = 50
    for z = 1, #items, 1 do 
        rowPartner[z] = display.newContainer( 480, 154 )
        rowPartner[z]:translate( midW, lastYP + (154*z) )
        scrViewP:insert( rowPartner[z] )
        
        -- Fondo
        local bg2 = display.newRect( 0, 0, 452, 120 )
        bg2:setFillColor( unpack(cWhite) )
        bg2.partner = items[z]
        bg2:addEventListener( 'tap', tapCommerce)
        rowPartner[z]:insert( bg2 )
        
        -- Imagen Comercio
        local fbFrame = display.newImage("img/deco/circleLogo120.png")
        fbFrame:translate( -153, 0 )
        rowPartner[z]:insert( fbFrame )
        local mask = graphics.newMask( "img/deco/maskLogo120.png" )
        local img = display.newImage( items[z].image, system.TemporaryDirectory )
        img:setMask( mask )
        img:translate( -153, 0 )
        img.width = 120
        img.height = 120
        rowPartner[z]:insert( img )
        
        -- Comercio Afiliado
        local txtAfil = 'AFILIADO'
        local imageAfil = 'menuAfiliado.png'
        
        if not(items[z].afil) then
            txtAfil = 'AFILIATE'
            imageAfil = 'menuNotAfiliado.png'
        end
        
        local iconMedal = display.newImage("img/icon/"..imageAfil)
        iconMedal.alpha = .7
        iconMedal:translate( 180, -15 )
        rowPartner[z]:insert( iconMedal )

        local lblAfil = display.newText({
            text = txtAfil,     
            x = 180, y = 15, width = 100, 
            font = fontSemiBold,   
            fontSize = 12, align = "center"
        })
        lblAfil.alpha = .8
        lblAfil:setFillColor( unpack(cBlueH) )
        rowPartner[z]:insert( lblAfil )
        
        if not(items[z].afil) then
            lblAfil.alpha = .5
            iconMedal.alpha = .5
        end
        
        -- Textos
        local name = display.newText({
            text = items[z].name,     
            x = 55, y = 0, width = 250, 
            font = fontBold,   
            fontSize = 22, align = "left"
        })
        name.anchorY = 1
        name:setFillColor( unpack(cBlueH) )
        rowPartner[z]:insert( name )
        local concept = display.newText({
            text = items[z].description, 
            x = 55, y = 5, width = 250, 
            font = fontRegular,   
            fontSize = 16, align = "left"
        })
        concept.anchorY = 0
        concept:setFillColor( unpack(cBlueH) )
        rowPartner[z]:insert( concept )
            
        local lnDot = display.newImage("img/deco/lnDot.png")
        lnDot:translate( 0, 76 )
        rowPartner[z]:insert( lnDot )
        
    end
    -- Set new scroll position
    scrViewP:setScrollHeight(lastYP + (154 * #items) + 90)
    tools:setLoading(false)
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
    
    lastYP = 240
    tools:getFilters(scrViewP)
    tools:setLoading(true, scrViewP)
    RestManager.getCommerces('1')
    
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
    tools:delFilters()
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene