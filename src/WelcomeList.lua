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
local bigList = true
local readyNext = false
local tools, scrViewWL, txtW2, txtW3, txtNumber, btnNearBg1

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function goToEnd(event)
    if readyNext then
        -- Play Audio
        local t = event.target
        audio.play(fxTap)
        -- Afiliar a Comercios
        local idx = ""
        for z = 1, #rowPartner, 1 do 
            if rowPartner[z].bgActive.alpha == 1 then
                if idx == "" then
                    idx = rowPartner[z].bgActive.idCommerce
                else
                    idx = idx.."-"..rowPartner[z].bgActive.idCommerce
                end
            end
        end
        RestManager.multipleJoin(idx)
        -- Change Screen
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
    
    if bigList then
        -- Actualizar Numero
        if minNum == 0 then txtNumber.text = "3"
        elseif minNum == 1 then txtNumber.text = "2"
        elseif minNum == 2 then 
            txtNumber.text = "1"
            txtW2.text = "Para comenzar afiliate a minimo"
            txtW3.text = "  de nuestros comercios inscritos."
            btnNearBg1.alpha = 1
            readyNext = false
        else 
            txtNumber.text = "" 
            txtW2.text = "Mientras mas afiliaciones tengas"
            txtW3.text = "mas recompensas podrás obtener."
            btnNearBg1.alpha = 0
            readyNext = true
        end
    else
        -- Activar boton next
        if rowPartner[idx].bgActive.alpha == 1 then
            btnNearBg1.alpha = 0
            readyNext = true
        else
            btnNearBg1.alpha = 1
            readyNext = false
        end
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
        tools:setEmpty(rowPartner, scrViewWL, "No existen comercios con tu selección")
    end
    
    if #items == 0 then
    else
        if #items <= 3 then
            bigList = false
            txtNumber.text = ""
            txtW2.text = "Para comenzar afiliate a alguno"
            txtW3.text = "de nuestros comercios inscritos."
        end
        
        -- Recorre registros y arma lista
        local lastYP = -50
        for z = 1, #items, 1 do 
            rowPartner[z] = display.newContainer( 480, 105 )
            rowPartner[z]:translate( midW, lastYP + (105*z) )
            scrViewWL:insert( rowPartner[z] )

            -- Boton Afiliar
            local bgBtn1 = display.newRect( 0, 0, 440, 80 )
            bgBtn1:setFillColor( unpack(cWhite) )
            bgBtn1.idx = z
            bgBtn1:addEventListener( 'tap', wAfiliate )
            rowPartner[z]:insert( bgBtn1 )

            -- Imagen Comercio
            local fbFrame = display.newImage("img/deco/circleLogo80.png")
            fbFrame:translate( -170, 0)
            rowPartner[z]:insert( fbFrame )
            local mask = graphics.newMask( "img/deco/maskLogo80.png" )
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:setMask( mask )
            img:translate( -170, 0 )
            img.width = 80
            img.height = 80
            rowPartner[z]:insert( img )

            -- Boton Afiliar
            local icoWPlus = display.newImage("img/icon/icoWPlus.png")
            icoWPlus:translate( 180, 0 )
            rowPartner[z]:insert( icoWPlus )
            rowPartner[z].bgActive = display.newRect( 180, 0, 80, 80 )
            rowPartner[z].bgActive:setFillColor( unpack(cWhite) )
            rowPartner[z].bgActive.idCommerce = items[z].id
            rowPartner[z].bgActive.alpha = 0
            rowPartner[z]:insert( rowPartner[z].bgActive )
            rowPartner[z].icoActive = display.newImage("img/icon/icoWCheck.png")
            rowPartner[z].icoActive:translate( 180, 0 )
            rowPartner[z].icoActive.alpha = 0
            rowPartner[z]:insert( rowPartner[z].icoActive )

            -- Textos
            local name = display.newText({
                text = items[z].name,     
                x = poscLabels, y = 0, width = 230, 
                font = fontBold,   
                fontSize = 22, align = "left"
            })
            name.anchorY = 1
            name:setFillColor( unpack(cBlueH) )
            rowPartner[z]:insert( name )
            local concept = display.newText({
                text = items[z].description, 
                x = poscLabels, y = 3, width = 230, 
                font = fontRegular,   
                fontSize = 16, align = "left"
            })
            concept.anchorY = 0
            concept:setFillColor( unpack(cBlueH) )
            rowPartner[z]:insert( concept )
            
            local lnDot = display.newImage("img/deco/lnDot.png")
            lnDot:translate( 0, 51 )
            rowPartner[z]:insert( lnDot )

        end
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
        font = fontBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cBlueH) )
    screen:insert( txt1 )
    
    txtW2 = display.newText({
        text = "Para comenzar afiliate a minimo",
        x = midW, y = h + 60,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW2:setFillColor( unpack(cBlueH) )
    screen:insert( txtW2 )
    
    txtNumber = display.newText({
        text = "3",
        x = midW - 155, y = h + 81,
        font = fontBold,   
        fontSize = 25, align = "center"
    })
    txtNumber:setFillColor( unpack(cBlueH) )
    screen:insert( txtNumber )
    
    txtW3 = display.newText({
        text = "  de nuestros comercios inscritos.",
        x = midW, y = h + 85,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW3:setFillColor( unpack(cBlueH) )
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
    local btnNearBg = display.newRoundedRect( midW, intH - 45, 350, 70, 10 )
    btnNearBg:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "right"
    } )
    btnNearBg:addEventListener( 'tap', goToEnd )
    screen:insert(btnNearBg)
    btnNearBg1 = display.newRoundedRect( midW, intH - 45, 350, 70, 10 )
    btnNearBg1:setFillColor( unpack(cGrayM) )
    screen:insert(btnNearBg1)
    local icoWArrow = display.newImage("img/icon/icoWArrow.png")
    icoWArrow:translate( midW + 60, intH - 45 )
    screen:insert( icoWArrow )
    local txtNear2 = display.newText({
        text = "CONTINUAR",
        x = midW + 35, y = intH - 45,
        font = fontBold, width = 250,  
        fontSize = 20, align = "left"
    })
    txtNear2:setFillColor( unpack(cWhite) )
    screen:insert( txtNear2 )
    
    tools:setLoading(true, scrViewWL)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then 
        -- Get by Location
        if event.params.isLocation then
            --Runtime:addEventListener( "location", locationHandler )
            RestManager.getCommercesByGPS(21.163405, -86.815875)
        else
            RestManager.getCommercesWCat(event.params.filter)
        end
    end
end

-- Remove Listener
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene