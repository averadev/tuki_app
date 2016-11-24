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
        rowPartner[z]:addEventListener( 'tap', tapCommerce )
        rowPartner[z] = nil
    end
    
    if txtFil == '' then
        tools:setEmpty(rowPartner, scrViewP, "No tienes comercios afiliados con tu selección")
    else
        tools:setLoading(true, scrViewP, true)
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
        tools:setEmpty(rowPartner, scrViewP, "No tienes comercios afiliados con tu selección")
    else
        -- Recorre registros y arma lista
        lastYP = 45
        for z = 1, #items, 1 do 
            rowPartner[z] = display.newContainer( 480, 164 )
            rowPartner[z]:translate( midW, lastYP + (164*z) )
            scrViewP:insert( rowPartner[z] )

            -- Fondo
            local bg2 = display.newRect( 0, 0, 452, 120 )
            bg2:setFillColor( unpack(cWhite) )
            bg2.partner = items[z]
            bg2:addEventListener( 'tap', tapCommerce)
            rowPartner[z]:insert( bg2 )

            -- Imagen Comercio
            local fbFrame = display.newImage("img/deco/circleLogo80.png")
            fbFrame:translate( -153, -20 )
            rowPartner[z]:insert( fbFrame )
            local mask = graphics.newMask( "img/deco/maskLogo80.png" )
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:setMask( mask )
            img:translate( -153, -20 )
            img.width = 80
            img.height = 80
            rowPartner[z]:insert( img )

            -- Textos
            local name = display.newText({
                text = items[z].name,     
                x = 0, y = 45, width = 390, 
                font = fontBold,   
                fontSize = 22, align = "left"
            })
            name:setFillColor( unpack(cBlueH) )
            rowPartner[z]:insert( name )
            local concept = display.newText({
                text = items[z].description, 
                x = 0, y = 65, width = 390, 
                font = fontRegular,   
                fontSize = 16, align = "left"
            })
            concept:setFillColor( unpack(cBlueH) )
            rowPartner[z]:insert( concept )

            -- Tuks
            print(intH)
            local bgTuks1 = display.newRect( 70, -43, 270, 45 )
            bgTuks1:setFillColor( unpack(cBTur) )
            rowPartner[z]:insert( bgTuks1 )
            local bgTuks2 = display.newRect( 70, 5, 270, 45 )
            bgTuks2:setFillColor( unpack(cBBlu) )
            rowPartner[z]:insert( bgTuks2 )
            local lblDesc1 = display.newText({
                text = "TUKS", 
                x = 60, y = -50,
                font = fontRegular, width = 200,
                fontSize = 18, align = "left"
            })
            lblDesc1:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblDesc1 )
            local lblDesc2 = display.newText({
                text = "Recompensas", 
                x = 60, y = -2,
                font = fontRegular, width = 200,
                fontSize = 18, align = "left"
            })
            lblDesc2:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblDesc2 )
            
            local lblVal1 = display.newText({
                text = items[z].points, 
                x = 100, y = -45,
                font = fontBold, width = 200,   
                fontSize = 40, align = "right"
            })
            lblVal1:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblVal1 )
            local lblVal2 = display.newText({
                text = items[z].posible..'/'..items[z].rewards, 
                x = 100, y = 5,
                font = fontSemiBold, width = 200, 
                fontSize = 30, align = "right"
            })
            lblVal2:setFillColor( unpack(cWhite) )
            rowPartner[z]:insert( lblVal2 )
            
        local lnDot = display.newImage("img/deco/lnDot.png")
        lnDot:translate( 0, 80 )
        rowPartner[z]:insert( lnDot )

        end
        -- Set new scroll position
        scrViewP:setScrollHeight(lastYP + (164 * #items) + 70)
    end
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
    
    tools:getFilters(scrViewP)
    tools:setLoading(true, scrViewP)
    RestManager.getJoined('1')
    
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