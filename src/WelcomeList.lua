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
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local DBManager = require('src.DBManager')
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local h = display.topStatusBarContentHeight 
local minNum = 0
local rowPartner = {}
local tools, scrViewWL, txtW2, txtW3, txtNumber, btnNearBg1, btnNearBg2

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function goToEnd(event)
    if minNum > 2 then
        local t = event.target
        audio.play(fxTap)
        composer.removeScene( "src.WelcomeEnd" )
        composer.gotoScene("src.WelcomeEnd", { time = 400, effect = "slideLeft" } )
    end
end

function wAfiliate(event)
    local idx = event.target.idx
    audio.play(fxTap)
    -- Validate Active
    if rowPartner[idx].bgActive.alpha == 0 then
        minNum = minNum + 1
        rowPartner[idx].bgActive.alpha = 1
        rowPartner[idx].icoActive.alpha = 1
    else
        minNum = minNum - 1
        rowPartner[idx].bgActive.alpha = 0
        rowPartner[idx].icoActive.alpha = 0
    end
    
    -- Actualizar Numero
    if minNum == 0 then txtNumber.text = "3"
    elseif minNum == 1 then txtNumber.text = "2"
    elseif minNum == 2 then 
        txtNumber.text = "1"
        txtW2.text = "Para comenzar afiliate a minimo"
        txtW3.text = "  de nuestros comercios inscritos."
        btnNearBg1:setFillColor( unpack(cGrayM) )
        btnNearBg2:setFillColor( unpack(cGrayM) )
    else 
        txtNumber.text = "" 
        txtW2.text = "Mientras mas afiliaciones tengas"
        txtW3.text = "mas recompensas podrás obtener."
        btnNearBg1:setFillColor( unpack(cTurquesa) )
        btnNearBg2:setFillColor( unpack(cBlue) )
    end
    
    return true
end

local locationHandler = function( event )

	-- Check for error (user may have turned off Location Services)
	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
		print( "Location error: " .. tostring( event.errorMessage ) )
	else
		local gps = { latitude = event.latitude, longitude = event.longitude }
		Runtime:removeEventListener( "location", locationHandler )
		
	end
end

function setListWelcome(items)
    -- Valida registros vacios
    if #items == 0 then
        tools:setEmpty(rowPartner, scrViewWL)
    end
    -- Recorre registros y arma lista
    local lastYP = -40
    for z = 1, #items, 1 do 
        rowPartner[z] = display.newContainer( 480, 95 )
        rowPartner[z]:translate( midW, lastYP + (95*z) )
        scrViewWL:insert( rowPartner[z] )
        
        -- Fondo
        local bg1 = display.newRect( 0, 0, 460, 80 )
        bg1:setFillColor( unpack(cGrayXL) )
        rowPartner[z]:insert( bg1 )
        local bg2 = display.newRect( 0, 0, 456, 76 )
        bg2:setFillColor( unpack(cWhite) )
        bg2.partner = items[z]
        rowPartner[z]:insert( bg2 )
        
        -- Imagen Comercio
        local bgImg0 = display.newRect( -188, 0, 85, 85 )
        bgImg0:setFillColor( unpack(cGrayH) )
        rowPartner[z]:insert( bgImg0 )
        local bgImg = display.newRect( -188, 0, 80, 80 )
        bgImg:setFillColor( tonumber(items[z].colorA1)/255, tonumber(items[z].colorA2)/255, tonumber(items[z].colorA3)/255 )
        rowPartner[z]:insert( bgImg )
        local img = display.newImage( items[z].image, system.TemporaryDirectory )
        img:translate( -188, 0 )
        img.width = 70
        img.height = 70
        rowPartner[z]:insert( img )
        
        -- Boton Afiliar
        local bgBtn1 = display.newRect( 190, 0, 80, 80 )
        bgBtn1:setFillColor( unpack(cGrayXL) )
        bgBtn1.idx = z
        bgBtn1:addEventListener( 'tap', wAfiliate )
        rowPartner[z]:insert( bgBtn1 )
        local icoWPlus = display.newImage("img/icon/icoWPlus.png")
        icoWPlus:translate( 190, 0 )
        rowPartner[z]:insert( icoWPlus )
        
        -- Boton Afiliar
        rowPartner[z].bgActive = display.newRect( 190, 0, 80, 80 )
        rowPartner[z].bgActive:setFillColor( unpack(cPurple) )
        rowPartner[z].bgActive.alpha = 0
        rowPartner[z]:insert( rowPartner[z].bgActive )
        rowPartner[z].icoActive = display.newImage("img/icon/icoWCheck.png")
        rowPartner[z].icoActive:translate( 190, 0 )
        rowPartner[z].icoActive.alpha = 0
        rowPartner[z]:insert( rowPartner[z].icoActive )
        
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
    
    -- Quitar Loading
    tools:setLoading(false)
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
    tools = Tools:new()
    
    local bgWelcome = display.newImage("img/deco/bgWelcome.png")
    bgWelcome:translate( midW, 480)
    screen:insert( bgWelcome )
    
    local txt1 = display.newText({
        text = "¡AFILIATE!",
        x = midW, y = h + 25,
        font = fLatoBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cGrayXH) )
    screen:insert( txt1 )
    
    txtW2 = display.newText({
        text = "Para comenzar afiliate a minimo",
        x = midW, y = h + 60,
        font = fLatoItalic,   
        fontSize = 20, align = "center"
    })
    txtW2:setFillColor( unpack(cGrayXH) )
    screen:insert( txtW2 )
    
    txtNumber = display.newText({
        text = "3",
        x = midW - 148, y = h + 84,
        font = fLatoBold,   
        fontSize = 25, align = "center"
    })
    txtNumber:setFillColor( unpack(cGrayXH) )
    screen:insert( txtNumber )
    
    txtW3 = display.newText({
        text = "  de nuestros comercios inscritos.",
        x = midW, y = h + 85,
        font = fLatoItalic,   
        fontSize = 20, align = "center"
    })
    txtW3:setFillColor( unpack(cGrayXH) )
    screen:insert( txtW3 )
    
    scrViewWL = widget.newScrollView
	{
		top = h + 110,
		left = 0,
		width = display.contentWidth,
		height = intH - (h + 200),
		horizontalScrollDisabled = true
	}
	screen:insert(scrViewWL)
    
    -- Botons
    btnNearBg1 = display.newRoundedRect( midW, intH - 45, 350, 70, 10 )
    btnNearBg1:setFillColor( unpack(cGrayM) )
    btnNearBg1:addEventListener( 'tap', goToEnd )
    screen:insert(btnNearBg1)
    btnNearBg2 = display.newRoundedRect( midW, intH - 45, 344, 64, 10 )
    btnNearBg2:setFillColor( unpack(cGrayM) )
    screen:insert(btnNearBg2)
    local icoWArrow = display.newImage("img/icon/icoWArrow.png")
    icoWArrow:translate( midW + 60, intH - 45 )
    screen:insert( icoWArrow )
    local txtNear2 = display.newText({
        text = "CONTINUAR",
        x = midW + 35, y = intH - 45,
        font = fLatoBold, width = 250,  
        fontSize = 20, align = "left"
    })
    txtNear2:setFillColor( unpack(cWhite) )
    screen:insert( txtNear2 )
    
    tools:setLoading(true, scrViewWL)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    -- Get by Location
    if event.params.isLocation then
        --Runtime:addEventListener( "location", locationHandler )
        RestManager.getCommercesByGPS(21.163405, -86.815875)
    else
        RestManager.getCommercesWCat(event.params.filter)
    end
end

-- Remove Listener
function scene:destroy( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene