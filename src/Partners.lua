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
        tools:setEmpty(rowPartner, scrViewP)
    else
        lastYP = 80
        tools:setLoading(true, scrViewP)
        RestManager.getCommerces(txtFil)
    end
end

-------------------------------------
-- Listener de navegacion de Coverflow
-- @param event objeto evento
------------------------------------
local function tapMoveCover( event )
    local t = event.target
    
    coverLeft.alpha = 0
    coverRight.alpha = 0
    txtPName.alpha = 0
    txtPConcept.alpha = 0
    covers[idxCover]:removeEventListener( 'tap', tapCommerce)
    
    local idxL = idxCover - 1
    if idxCover == 1 then idxL = sCover end
    local idxR = idxCover + 1
    if idxCover == sCover then idxR = 1 end
    
    if t.action == 'left' then
        local idxN = idxCover + 2
        if (idxCover+1) == sCover then idxN = 1 end 
        if idxCover == sCover then idxN = 2 end
        
        -- Center
        transition.to( covers[idxCover], { x = midW - 155,  time = 200 })
        transition.to( covers[idxCover].bg, { width = 150, height = 90,  time = 200 })
        transition.to( covers[idxCover].img, { width = 70, height = 70,  time = 200 })
        -- Left
        transition.to( covers[idxL], { x = midW,  time = 200 })
        -- Right
        transition.to( covers[idxR], { x = midW,  time = 200 })
        transition.to( covers[idxR].bg, { width = 200, height = 120,  time = 200 })
        transition.to( covers[idxR].img, { width = 110, height = 110,  time = 200 })
        covers[idxR]:toFront()
        -- New
        transition.to( covers[idxN], { x = midW + 155,  time = 200 })
        
        -- Add to index
        if idxCover == sCover then
            idxCover = 1
        else
            idxCover = idxCover + 1
        end 
    else
        local idxN = idxCover - 2
        if (idxCover-1) == 1 then idxN = sCover end 
        if idxCover == 1 then idxN = sCover-1 end
        
        -- Center
        transition.to( covers[idxCover], { x = midW + 155,  time = 200 })
        transition.to( covers[idxCover].bg, { width = 150, height = 90,  time = 200 })
        transition.to( covers[idxCover].img, { width = 70, height = 70,  time = 200 })
        -- Left
        transition.to( covers[idxL], { x = midW,  time = 200 })
        transition.to( covers[idxL].bg, { width = 200, height = 120,  time = 200 })
        transition.to( covers[idxL].img, { width = 110, height = 110,  time = 200 })
        covers[idxL]:toFront()
        -- Right
        transition.to( covers[idxR], { x = midW,  time = 200 })
        -- New
        transition.to( covers[idxN], { x = midW - 155,  time = 200 })
        
        -- Add to index
        if idxCover == 1 then
            idxCover = sCover
        else
            idxCover = idxCover - 1
        end 
    end
    
    -- Return Nav
    local tm = timer.performWithDelay( 200, function() 
        coverLeft:toFront()
        coverRight:toFront()
        coverLeft.alpha = 1
        coverRight.alpha = 1
        txtPName.alpha = 1
        txtPConcept.alpha = 1
        txtPName.text = covers[idxR].partner.name
        txtPConcept.text = covers[idxR].partner.description
        covers[idxCover]:addEventListener( 'tap', tapCommerce)
    end)
    
    return true
end

-------------------------------------
-- Crea el coverflow de comercios destacados
-- @param obj lista de comercios
------------------------------------
function getCoverFirstFlow(obj)
    
    -- Build covers
    sCover = #obj.items
    for z = 1, sCover, 1 do 
        createCover(obj.items[z])
    end
    
    idxCover = 1
    covers[idxCover]:toFront()
    covers[2].x = midW + 155
    covers[sCover].x = midW - 155
    
    covers[idxCover].bg.width = 200
    covers[idxCover].bg.height = 120
    covers[idxCover].img.width = 110
    covers[idxCover].img.height = 110
    covers[idxCover]:addEventListener( 'tap', tapCommerce)
    
    coverLeft = display.newImage( "img/icon/coverLeft.png" )
    coverLeft:translate( 75, 180 )
    coverLeft.action = 'left'
    coverLeft:addEventListener( 'tap', tapMoveCover)
    scrViewP:insert(coverLeft)
    
    coverRight = display.newImage( "img/icon/coverRight.png" )
    coverRight:translate( intW - 75, 180 )
    coverRight.action = 'right'
    coverRight:addEventListener( 'tap', tapMoveCover)
    scrViewP:insert(coverRight)
    
    -- Textos informativos
    txtPName = display.newText({
        text = covers[idxCover].partner.name,     
        x = midW, y = 255, width = 440,
        font = fLatoBold,   
        fontSize = 24, align = "center"
    })
    txtPName:setFillColor( unpack(cGrayXH) )
    scrViewP:insert(txtPName)

    txtPConcept = display.newText({
        text = covers[idxCover].partner.description,     
        x = midW, y = 275, width = 440,
        font = fLatoBold,   
        fontSize = 14, align = "center"
    })
    txtPConcept:setFillColor( unpack(cGrayH) )
    scrViewP:insert(txtPConcept)
    
end

-------------------------------------
-- Crea una tarjeta del Coverflow
-- @param partner objeto comercio
------------------------------------
function createCover(partner)
    local idx = #covers + 1
    
    covers[idx] = display.newContainer( 200, 120 )
    covers[idx].active = false
    covers[idx]:translate( midW, 180 )
    covers[idx].partner = partner
    scrViewP:insert( covers[idx] )
    
    covers[idx].bg = display.newRoundedRect(0, 0, 150, 90, 10 )
    covers[idx].bg:setFillColor( tonumber(partner.colorA1)/255, tonumber(partner.colorA2)/255, tonumber(partner.colorA3)/255 )
    covers[idx]:insert( covers[idx].bg )
    
    covers[idx].img = display.newImage( partner.image, system.TemporaryDirectory )
    covers[idx].img.height = 70
    covers[idx].img.width = 70
    covers[idx].img:translate( 0, 0 )
    covers[idx]:insert( covers[idx].img )
    
end

-------------------------------------
-- Crea la lista de comercios
-- @param items lista de items de BD
------------------------------------
function setListCommerce(items)
    -- Valida registros vacios
    if #items == 0 then
        tools:setEmpty(rowPartner, scrViewP)
    end
    -- Recorre registros y arma lista
    for z = 1, #items, 1 do 
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
        bgImg0:setFillColor( tonumber(items[z].colorA1)/255, tonumber(items[z].colorA2)/255, tonumber(items[z].colorA3)/255 )
        rowPartner[z]:insert( bgImg0 )
        local bgImg = display.newRect( -188, 0, 75, 75 )
        bgImg:setFillColor( 1 )
        rowPartner[z]:insert( bgImg )
        local img = display.newImage( items[z].image, system.TemporaryDirectory )
        img:translate( -188, 0 )
        img.width = 70
        img.height = 70
        rowPartner[z]:insert( img )
        
        -- Comercio Afiliado
        local poscLabels = 10
        if items[z].afil then
            poscLabels = 55
            local bgAfil0 = display.newRect( -121, 0, 50, 80 )
            bgAfil0:setFillColor( unpack(cGrayXL) )
            rowPartner[z]:insert( bgAfil0 )
            local bgAfil = display.newRect( -123, 0, 46, 72 )
            bgAfil:setFillColor( unpack(cPurple) )
            rowPartner[z]:insert( bgAfil )
            local iconMedal = display.newImage("img/icon/iconMedal.png")
            iconMedal.alpha = .7
            iconMedal:translate( -123, 0 )
            rowPartner[z]:insert( iconMedal )
        end
        
        -- Textos
        local name = display.newText({
            text = items[z].name,     
            x = poscLabels, y = -15, width = 270, 
            font = fLatoBold,   
            fontSize = 22, align = "left"
        })
        name:setFillColor( unpack(cGrayXH) )
        rowPartner[z]:insert( name )
        local concept = display.newText({
            text = items[z].description, 
            x = poscLabels, y = 10, width = 270, 
            font = fLatoRegular,   
            fontSize = 16, align = "left"
        })
        concept:setFillColor( unpack(cGrayH) )
        rowPartner[z]:insert( concept )
        
    end
    -- Set new scroll position
    scrViewP:setScrollHeight(lastYP + (95 * #items) + 70)
    tools:setLoading(false)
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
    
    lastYP = 240
    tools:getFilters(scrViewP)
    tools:setLoading(true, scrViewP)
    RestManager.getCommerceFlow()
    RestManager.getCommerces('1')
    
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
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