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
local RestManager = require('src.RestManager')
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local tools, scrViewA

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

----------------------------    ---------
-- Consulta Comercio
-- @param event objeto evento
------------------------------------
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Partner" )
    composer.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = {idCommerce = t.idx} })
    return true
end

-------------------------------------
-- Muestra primer detalle del usuario
-- @param usuario objeto
------------------------------------
function showAccount(usuario)
    -- Background
    local lastY = 0
    local bgFB = display.newRect(midW, lastY, intW, 270 )
    bgFB.anchorY = 0
    bgFB:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "bottom"
    } )
    scrViewA:insert(bgFB)
    
    if usuario.fbid == nil or usuario.fbid == '' or usuario.fbid == 0 or usuario.fbid == '0' then     
        local fbFrame = display.newImage("img/deco/circleLogo100.png")
        fbFrame:translate(100, 90)
        scrViewA:insert( fbFrame )
        local fbPhoto = display.newImage("img/deco/fbPhoto.png")
        fbPhoto:translate(100, 90)
        scrViewA:insert( fbPhoto )
    else
        local fbFrame = display.newImage("img/deco/circleLogo120.png")
        fbFrame:translate(100, 90)
        scrViewA:insert( fbFrame )
        url = "http://graph.facebook.com/"..usuario.fbid.."/picture?large&width=150&height=150"
        retriveImage(usuario.fbid.."fbmax", url, scrViewA, 100, 90, 120, 120, true)
    end
    

    local txtNombre = display.newText({
        text = usuario.name, 
        x = 350, y = lastY + 70, width = 300, 
        font = fontBold,   
        fontSize = 22, align = "left"
    })
    txtNombre:setFillColor( unpack(cWhite) )
    scrViewA:insert( txtNombre )
    local txtUbicacion = display.newText({
        text = usuario.ciudad, 
        x = 350, y = lastY + 98, width = 300, 
        font = fontLight,   
        fontSize = 20, align = "left"
    })
    txtUbicacion:setFillColor( unpack(cWhite) )
    scrViewA:insert( txtUbicacion )
    
    local txtDescTime = display.newText({
        text = "Eres TUKER desde: "..usuario.signin, 
        x = 350, y = lastY + 125, width = 300, 
        font = fontRegular,   
        fontSize = 14, align = "left"
    })
    txtDescTime:setFillColor( unpack(cWhite) )
    scrViewA:insert( txtDescTime )
    
    -- Desc Tuks
    lastY = lastY + 200
    local availableR = 0
    for z = 1, #usuario.joined, 1 do 
        availableR = availableR + tonumber(usuario.joined[z].avaliable)
    end
    
    local lnDot480 = display.newImage("img/deco/lnDot480.png")
    lnDot480:translate(midW, lastY - 25)
    scrViewA:insert( lnDot480 )
    local lnDot480 = display.newImage("img/deco/dotV.png")
    lnDot480:translate(midW, lastY + 25)
    scrViewA:insert( lnDot480 )
    
    local lblTopL = display.newText({
        text = tostring(#usuario.joined), 
        x = 120, y = lastY, width = 160, 
        font = fontBold,   
        fontSize = 30, align = "center"
    })
    lblTopL:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopL )
    local lblTopL0 = display.newText({
        text = "COMERCIOS A LOS QUE ESTAS AFILIADO", 
        x = 120, y = lastY + 40, width = 200, 
        font = fontSemiRegular,   
        fontSize = 15, align = "center"
    })
    lblTopL0:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopL0 )
    
    local lblTopR = display.newText({
        text = tostring(availableR), 
        x = 360, y = lastY, width = 70, 
        font = fontBold,   
        fontSize = 30, align = "center"
    })
    lblTopR:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopR )
    local lblTopR0 = display.newText({
        text = "RECOMPENSAS DISPONIBLES", 
        x = 360, y = lastY + 40, width = 200, 
        font = fontSemiRegular,   
        fontSize = 15, align = "center"
    })
    lblTopR0:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopR0 )
    
end

-------------------------------------
-- Muestra listado de comercios
-- @param items listado de comercios
------------------------------------
function showAccountCom(items)
    -- Print Commerce
    local lastY = 280
    for z = 1, #items, 1 do 
        if tonumber(items[z].points) > 0 then
            
            local container = display.newContainer( 460, 154 )
            container.anchorY = 0
            container:translate( midW, lastY )
            scrViewA:insert( container )
            
            local bgCom2 = display.newRect(0, 0, intW - 24, 140 )
            bgCom2:setFillColor( 1 )
            bgCom2.idx = items[z].id
            bgCom2:addEventListener( 'tap', tapCommerce)
            container:insert(bgCom2)
            
            local fbFrame = display.newImage("img/deco/circleLogo120.png")
            fbFrame:translate( -153, 0 )
            container:insert( fbFrame )
            local mask = graphics.newMask( "img/deco/maskLogo120.png" )
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:setMask( mask )
            img:translate( -153, 0 )
            img.width = 120
            img.height = 120
            container:insert( img )

            local bgDesc1 = display.newRect(-75, -10, 290, 20 )
            bgDesc1.anchorX = 0
            bgDesc1:setFillColor( unpack(cGrayXXL) )
            container:insert(bgDesc1)
            local bgDesc2 = display.newRect(-75, 40, 290, 20 )
            bgDesc2.anchorX = 0
            bgDesc2:setFillColor( unpack(cGrayXXL) )
            container:insert(bgDesc2)

            -- Descripciones
            local lblDescT = display.newText({
                text = "TUKS", 
                x = 170, y = -30, width = 70, 
                font = fontSemiBold,   
                fontSize = 10, align = "right"
            })
            lblDescT:setFillColor( unpack(cBlueH) )
            container:insert( lblDescT )
            local lblDesc1 = display.newText({
                text = "Recompensas Disponibles", 
                x = 30, y = -10, width = 200, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc1:setFillColor( unpack(cBlueH) )
            container:insert( lblDesc1 )
            local lblDesc2 = display.newText({
                text = "Visitas Realizadas", 
                x = 30, y = 15, width = 200, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc2:setFillColor( unpack(cBlueH) )
            container:insert( lblDesc2 )
            local lblDesc3 = display.newText({
                text = "Ultima Visita", 
                x = 30, y = 40, width = 200, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc3:setFillColor( unpack(cBlueH) )
            container:insert( lblDesc3 )

            --- Valores
            local lblCommerce = display.newText({
                text = items[z].name, 
                x = 40, y = -35, width = 220, 
                font = fontSemiBold,   
                fontSize = 22, align = "left"
            })
            lblCommerce:setFillColor( unpack(cBlueH) )
            container:insert( lblCommerce )
            local lblTuks = display.newText({
                text = items[z].points, 
                x = 140, y = -35, width = 70, 
                font = fontBold,   
                fontSize = 26, align = "right"
            })
            lblTuks:setFillColor( unpack(cBlueH) )
            container:insert( lblTuks )
            local xSpc = 115
            if tonumber(items[z].rewards) > 9 then
                xSpc = 107
            end
            local lblValue0 = display.newText({
                text = items[z].avaliable, 
                x = xSpc, y = -10, width = 150, 
                font = fontBold,   
                fontSize = 14, align = "right"
            })
            lblValue0:setFillColor( unpack(cBlueH) )
            container:insert( lblValue0 )
            local lblValue1 = display.newText({
                text = "/"..items[z].rewards, 
                x = 130, y = -10, width = 150, 
                font = fontRegular,   
                fontSize = 14, align = "right"
            })
            lblValue1:setFillColor( unpack(cBlueH) )
            container:insert( lblValue1 )
            local lblValue2 = display.newText({
                text = items[z].visits, 
                x = 130, y = 15, width = 150, 
                font = fontBold,   
                fontSize = 14, align = "right"
            })
            lblValue2:setFillColor( unpack(cBlueH) )
            container:insert( lblValue2 )
            if items[z].lastVisit then 
                local lblValue3 = display.newText({
                    text = items[z].lastVisit, 
                    x = 130, y = 40, width = 150, 
                    font = fontBold,   
                    fontSize = 14, align = "right"
                })
                lblValue3:setFillColor( unpack(cBlueH) )
                container:insert( lblValue3 )
            end
            
            local lnDot = display.newImage("img/deco/lnDot.png")
            lnDot:translate( 0, 76 )
            container:insert( lnDot )
            
            lastY = lastY + 154
        end
    end
    
    local isFirst = true
    for z = 1, #items, 1 do 
        if tonumber(items[z].points) == 0 then
            
            if isFirst then
                lastY = lastY + 10
                local bgCom1 = display.newRect(midW, lastY, 440, 34 )
                bgCom1.anchorY = 0
                bgCom1:setFillColor( unpack(cBTur) )
                scrViewA:insert(bgCom1)
                local bgCom2 = display.newRect(midW, lastY+2, 436, 30 )
                bgCom2.anchorY = 0
                bgCom2:setFillColor( unpack(cWhite) )
                scrViewA:insert(bgCom2)
                local lblZero1 = display.newText({
                    text = "Afiliado pero ", 
                    x = 80, y = lastY + 15, width = 100, 
                    font = fontRegular,   
                    fontSize = 14, align = "left"
                })
                lblZero1:setFillColor( unpack(cBlueH) )
                scrViewA:insert( lblZero1 )
                local lblZero2 = display.newText({
                    text = "SIN TUKS", 
                    x = 168, y = lastY + 15, width = 100, 
                    font = fontBold,   
                    fontSize = 14, align = "left"
                })
                lblZero2:setFillColor( unpack(cBlueH) )
                scrViewA:insert( lblZero2 )
                lastY = lastY + 40
                
                isFirst = false
            end
            
            local container = display.newContainer( 460, 100 )
            container.anchorY = 0
            container:translate( midW, lastY )
            scrViewA:insert( container )
            
            local bgCom2 = display.newRect(0, 0, intW - 24, 70 )
            bgCom2:setFillColor( 1 )
            bgCom2.idx = items[z].id
            bgCom2:addEventListener( 'tap', tapCommerce)
            container:insert(bgCom2)
            
            local fbFrame = display.newImage("img/deco/circleLogo80.png")
            fbFrame:translate(-170, 0)
            container:insert( fbFrame )
            local mask = graphics.newMask( "img/deco/maskLogo80.png" )
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:translate( -170, 0 )
            img:setMask( mask )
            img.width = 80
            img.height = 80
            container:insert( img )
            
            local lnDot = display.newImage("img/deco/lnDot.png")
            lnDot:translate( 0, 49 )
            container:insert( lnDot )
            
            --- Valores
            local lblCommerce = display.newText({
                text = items[z].name, 
                x = 40, y = -10, width = 310, 
                font = fontSemiBold,   
                fontSize = 22, align = "left"
            })
            lblCommerce:setFillColor( unpack(cBlueH) )
            container:insert( lblCommerce )
            local lblDesc = display.newText({
                text = items[z].description, 
                x = 40, y = 12, width = 310, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc:setFillColor( unpack(cBlueH) )
            container:insert( lblDesc )
            
            lastY = lastY + 100
        end
    end
    
    lastY = lastY + 20
    local spc = display.newRect(0, lastY, 4, 4 )
    spc:setFillColor( 1 )
    scrViewA:insert(spc)
    
    -- Stop Loading
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
    
    scrViewA = widget.newScrollView
	{
		top = h + 60,
		left = 0,
		width = display.contentWidth,
		height = intH - (h + 120),
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewA)
    scrViewA:toBack()
    
    -- Get Data
    tools:setLoading(true, scrViewA)
    RestManager.getAccount()
    
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
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene