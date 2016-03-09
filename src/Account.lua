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

-------------------------------------
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
    local bgFB = display.newRect(midW, lastY, intW, 200 )
    bgFB.anchorY = 0
    bgFB:setFillColor( .38 )
    scrViewA:insert(bgFB)

    
    
    if usuario.fbid == 0 then
            local bgFB = display.newCircle( 95, lastY + 100, 78 )
            bgFB:setFillColor( unpack(cTurquesa) )
            scrViewA:insert(bgFB)
            local fbPhoto = display.newImage("img/deco/fbPhoto.png")
            fbPhoto:translate(95, lastY + 100)
            scrViewA:insert( fbPhoto )
        else
            url = "http://graph.facebook.com/"..usuario.fbid.."/picture?large&width=150&height=150"
            local isReady = retriveImage(usuario.fbid.."fbmax", url, scrViewA, 95, lastY + 100, 150, 150)
            local fbFrame = display.newImage("img/deco/fbFrame.png")
            fbFrame:translate(95, lastY + 100)
            scrViewA:insert( fbFrame )
        end

    local txtNombre = display.newText({
        text = usuario.name, 
        x = 350, y = lastY + 70, width = 300, 
        font = fLatoBold,   
        fontSize = 20, align = "left"
    })
    txtNombre:setFillColor( unpack(cWhite) )
    scrViewA:insert( txtNombre )
    local txtUbicacion = display.newText({
        text = usuario.ciudad, 
        x = 350, y = lastY + 98, width = 300, 
        font = fLatoItalic,   
        fontSize = 18, align = "left"
    })
    txtUbicacion:setFillColor( unpack(cWhite) )
    scrViewA:insert( txtUbicacion )
    
    local lineTop = display.newLine(190, lastY + 120, 450, lastY + 120)
    lineTop:setStrokeColor( unpack(cGrayM) )
    lineTop.strokeWidth = 3
    scrViewA:insert(lineTop)
    
    local txtDescTime = display.newText({
        text = "Eres TUKER desde:", 
        x = 350, y = lastY + 140, width = 300, 
        font = fLatoRegular,   
        fontSize = 16, align = "left"
    })
    txtDescTime:setFillColor( unpack(cTurquesa) )
    scrViewA:insert( txtDescTime )
    local txtTime = display.newText({
        text = usuario.signin, 
        x = 400, y = lastY + 140, width = 120, 
        font = fLatoBold,   
        fontSize = 16, align = "left"
    })
    txtTime:setFillColor( unpack(cWhite) )
    scrViewA:insert( txtTime )
    
    -- Desc Tuks
    lastY = lastY + 200
    local availableR = 0
    for z = 1, #usuario.joined, 1 do 
        availableR = availableR + tonumber(usuario.joined[z].avaliable)
    end
    local bgTopL = display.newRect(0, lastY, midW, 45 )
    bgTopL.anchorX = 0
    bgTopL.anchorY = 0
    bgTopL:setFillColor( unpack(cPurpleL) )
    scrViewA:insert(bgTopL)
    local lblTopL0 = display.newText({
        text = "Afiliado a", 
        x = 30, y = lastY + 20, width = 120, 
        font = fLatoRegular,   
        fontSize = 16, align = "right"
    })
    lblTopL0:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopL0 )
    local lblTopL = display.newText({
        text = (#usuario.joined).." Comercios", 
        x = 177, y = lastY + 20, width = 160, 
        font = fLatoBold,   
        fontSize = 20, align = "left"
    })
    lblTopL:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopL )
    local bgTopR = display.newRect(midW, lastY, midW, 45 )
    bgTopR.anchorX = 0
    bgTopR.anchorY = 0
    bgTopR:setFillColor( unpack(cTurquesa) )
    scrViewA:insert(bgTopR)
    local lblTopR = display.newText({
        text = availableR, 
        x = 245, y = lastY + 20, width = 70, 
        font = fLatoBold,   
        fontSize = 22, align = "right"
    })
    lblTopR:setFillColor( unpack(cWhite) )
    scrViewA:insert( lblTopR )
    local lblTopR0 = display.newText({
        text = "Recompensas Disponibles", 
        x = 385, y = lastY + 20, width = 200, 
        font = fLatoRegular,   
        fontSize = 16, align = "left"
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
    local lastY = 260
    for z = 1, #items, 1 do 
        if tonumber(items[z].points) > 0 then
            
            local container = display.newContainer( 460, 144 )
            container.anchorY = 0
            container:translate( midW, lastY )
            scrViewA:insert( container )
            
            local bgCom1 = display.newRect(0, 0, intW - 20, 144 )
            bgCom1:setFillColor( unpack(cGrayXL) )
            container:insert(bgCom1)
            local bgCom2 = display.newRect(0, 0, intW - 24, 140 )
            bgCom2:setFillColor( 1 )
            bgCom2.idx = items[z].id
            bgCom2:addEventListener( 'tap', tapCommerce)
            container:insert(bgCom2)

            local bgImg1 = display.newRect(-158, 0, 144, 144 )
            bgImg1:setFillColor( unpack(cGrayL) )
            container:insert(bgImg1)
            local bgImg2 = display.newRect(-158, 0, 140, 140 )
            bgImg2:setFillColor( 1 )
            container:insert(bgImg2)
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:translate( -158, 0 )
            img.width = 140
            img.height = 140
            container:insert( img )

            local bgTuks1 = display.newRect(193, -45, 70, 50 )
            bgTuks1:setFillColor( unpack(cTurquesa) )
            container:insert(bgTuks1)
            local bgTuks2 = display.newRect(193, -45, 66, 46 )
            bgTuks2:setFillColor( unpack(cBlueH) )
            container:insert(bgTuks2)

            local bgDesc1 = display.newRect(-86, -20, 314, 30 )
            bgDesc1.anchorX = 0
            bgDesc1.anchorY = 0
            bgDesc1:setFillColor( unpack(cGrayXXL) )
            container:insert(bgDesc1)
            local bgDesc2 = display.newRect(-86, 40, 314, 30 )
            bgDesc2.anchorX = 0
            bgDesc2.anchorY = 0
            bgDesc2:setFillColor( unpack(cGrayXXL) )
            container:insert(bgDesc2)

            -- Descripciones
            local lblDescT = display.newText({
                text = "TUKS", 
                x = 193, y = -32, width = 70, 
                font = fLatoRegular,   
                fontSize = 14, align = "center"
            })
            lblDescT:setFillColor( 1 )
            container:insert( lblDescT )
            local lblDesc1 = display.newText({
                text = "Recompensas Disponibles", 
                x = 60, y = -5, width = 200, 
                font = fLatoRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc1:setFillColor( unpack(cGrayH) )
            container:insert( lblDesc1 )
            local lblDesc2 = display.newText({
                text = "Visitas Realizadas", 
                x = 60, y = 25, width = 200, 
                font = fLatoRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc2:setFillColor( unpack(cGrayH) )
            container:insert( lblDesc2 )
            local lblDesc3 = display.newText({
                text = "Ultima Visita", 
                x = 60, y = 55, width = 200, 
                font = fLatoRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc3:setFillColor( unpack(cGrayH) )
            container:insert( lblDesc3 )
            local Account01 = display.newImage("img/icon/Account01.png")
            Account01:translate(-64, 24)
            container:insert( Account01 )
            local Account02 = display.newImage("img/icon/Account02.png")
            Account02:translate(-64, -6)
            container:insert( Account02 )
            local Account03 = display.newImage("img/icon/Account03.png")
            Account03:translate(-64, 54)
            container:insert( Account03 )

            --- Valores
            local lblCommerce = display.newText({
                text = items[z].name, 
                x = 40, y = -45, width = 220, 
                font = fLatoBold,   
                fontSize = 22, align = "left"
            })
            lblCommerce:setFillColor( unpack(cGrayH) )
            container:insert( lblCommerce )
            local lblTuks = display.newText({
                text = items[z].points, 
                x = 193, y = -52, width = 70, 
                font = fLatoBold,   
                fontSize = 26, align = "center"
            })
            lblTuks:setFillColor( 1 )
            container:insert( lblTuks )
            local xSpc = 125
            if tonumber(items[z].rewards) > 9 then
                xSpc = 117
            end
            local lblValue0 = display.newText({
                text = items[z].avaliable, 
                x = xSpc, y = -5, width = 150, 
                font = fLatoBold,   
                fontSize = 14, align = "right"
            })
            lblValue0:setFillColor( unpack(cPurpleL) )
            container:insert( lblValue0 )
            local lblValue1 = display.newText({
                text = "/"..items[z].rewards, 
                x = 140, y = -5, width = 150, 
                font = fLatoRegular,   
                fontSize = 14, align = "right"
            })
            lblValue1:setFillColor( unpack(cGrayH) )
            container:insert( lblValue1 )
            local lblValue2 = display.newText({
                text = items[z].visits, 
                x = 140, y = 25, width = 150, 
                font = fLatoBold,   
                fontSize = 14, align = "right"
            })
            lblValue2:setFillColor( unpack(cPurpleL) )
            container:insert( lblValue2 )
            if items[z].lastVisit then 
                local lblValue3 = display.newText({
                    text = items[z].lastVisit, 
                    x = 140, y = 55, width = 150, 
                    font = fLatoBold,   
                    fontSize = 14, align = "right"
                })
                lblValue3:setFillColor( unpack(cPurpleL) )
                container:insert( lblValue3 )
            end
            lastY = lastY + 154
        end
    end
    
    local isFirst = true
    for z = 1, #items, 1 do 
        if tonumber(items[z].points) == 0 then
            
            if isFirst then
                lastY = lastY + 10
                local bgCom1 = display.newRect(midW, lastY, intW, 30 )
                bgCom1.anchorY = 0
                bgCom1:setFillColor( unpack(cGrayM) )
                scrViewA:insert(bgCom1)
                local lblZero1 = display.newText({
                    text = "Afiliado pero ", 
                    x = 80, y = lastY + 15, width = 100, 
                    font = fLatoRegular,   
                    fontSize = 14, align = "left"
                })
                lblZero1:setFillColor( 1 )
                scrViewA:insert( lblZero1 )
                local lblZero2 = display.newText({
                    text = "SIN TUKS", 
                    x = 162, y = lastY + 15, width = 100, 
                    font = fLatoBold,   
                    fontSize = 14, align = "left"
                })
                lblZero2:setFillColor( 1 )
                scrViewA:insert( lblZero2 )
                lastY = lastY + 40
                
                isFirst = false
            end
            
            local container = display.newContainer( 460, 74 )
            container.anchorY = 0
            container:translate( midW, lastY )
            scrViewA:insert( container )
            
            local bgCom1 = display.newRect(0, 0, intW - 20, 74 )
            bgCom1:setFillColor( unpack(cGrayXL) )
            container:insert(bgCom1)
            local bgCom2 = display.newRect(0, 0, intW - 24, 70 )
            bgCom2:setFillColor( 1 )
            bgCom2.idx = items[z].id
            bgCom2:addEventListener( 'tap', tapCommerce)
            container:insert(bgCom2)
            
            local bgImg1 = display.newRect(-191, 0, 74, 74 )
            bgImg1:setFillColor( unpack(cGrayL) )
            container:insert(bgImg1)
            local bgImg2 = display.newRect(-191, 0, 70, 70 )
            bgImg2:setFillColor( 1 )
            container:insert(bgImg2)
            local img = display.newImage( items[z].image, system.TemporaryDirectory )
            img:translate( -191, 0 )
            img.width = 70
            img.height = 70
            container:insert( img )
            
            --- Valores
            local lblCommerce = display.newText({
                text = items[z].name, 
                x = 40, y = -10, width = 350, 
                font = fLatoBold,   
                fontSize = 22, align = "left"
            })
            lblCommerce:setFillColor( unpack(cGrayH) )
            container:insert( lblCommerce )
            local lblDesc = display.newText({
                text = items[z].description, 
                x = 40, y = 12, width = 350, 
                font = fLatoRegular,   
                fontSize = 14, align = "left"
            })
            lblDesc:setFillColor( unpack(cGrayH) )
            container:insert( lblDesc )
            
            lastY = lastY + 84
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
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    scrViewA = widget.newScrollView
	{
		top = h + 140,
		left = 0,
		width = display.contentWidth,
		height = intH - (h + 220),
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