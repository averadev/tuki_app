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

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------


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
    
    local name = display.newText({
        text = "La Parrilla De Jose",     
        x = midW, y = 25, width = 400, 
        font = native.systemFontBold,   
        fontSize = 24, align = "center"
    })
    name:setFillColor( .3 )
    scrViewP:insert( name )

    local concept = display.newText({
        text = "Restaurante Argentino", 
        x = midW, y = 50, width = 400, 
        font = native.systemFont,   
        fontSize = 20, align = "center"
    })
    concept:setFillColor( .68 )
    scrViewP:insert( concept )
    
    -- Boton Action
    local btnActionSw = display.newRoundedRect( midW, 110 + 6, 400, 60, 10 )
    btnActionSw:setFillColor( .95 )
    scrViewP:insert(btnActionSw)
    local btnActionBg = display.newRoundedRect( midW, 110, 400, 60, 10 )
    btnActionBg:setFillColor( .15, .72, .91 )
    scrViewP:insert(btnActionBg)
    local btnActionTxt = display.newText({
        text = "COMPRAR", 
        x = midW, y = 110, width = 400, 
        font = native.systemFontBold,
        fontSize = 28, align = "center"
    })
    btnActionTxt:setFillColor( 1 )
    scrViewP:insert( btnActionTxt )
    
    -- Barra Puntos
    local btnPointsSw = display.newRoundedRect( midW, 190 + 6, 400, 60, 10 )
    btnPointsSw:setFillColor( .95 )
    scrViewP:insert(btnPointsSw)
    local btnPointsBg = display.newRoundedRect( midW, 190, 400, 60, 10 )
    btnPointsBg:setFillColor( .91 )
    scrViewP:insert(btnPointsBg)
    -- Lineas
    local line1 = display.newLine(173, 160, 173, 220)
    line1:setStrokeColor( .58, .3 )
    line1.strokeWidth = 1
    scrViewP:insert(line1)
    local line2 = display.newLine(306, 160, 306, 220)
    line2:setStrokeColor( .58, .3 )
    line2.strokeWidth = 1
    scrViewP:insert(line2)
    -- Strikes
    local txtPoints1A = display.newText({
        text = "1024", 
        x = 106, y = 183, width = 133, 
        font = native.systemFontBold,
        fontSize = 24, align = "center"
    })
    txtPoints1A:setFillColor( 0 )
    scrViewP:insert( txtPoints1A )
    local txtPoints1B = display.newText({
        text = "STRIKES", 
        x = 106, y = 205, width = 133, 
        font = native.systemFont,
        fontSize = 12, align = "center"
    })
    txtPoints1B:setFillColor( .3 )
    scrViewP:insert( txtPoints1B )
    -- Puntos
    local txtPoints2A = display.newText({
        text = "400", 
        x = 239, y = 183, width = 133, 
        font = native.systemFontBold,
        fontSize = 24, align = "center"
    })
    txtPoints2A:setFillColor( 0 )
    scrViewP:insert( txtPoints2A )
    local txtPoints2B = display.newText({
        text = "PUNTOS", 
        x = 239, y = 205, width = 133, 
        font = native.systemFont,
        fontSize = 12, align = "center"
    })
    txtPoints2B:setFillColor( .3 )
    scrViewP:insert( txtPoints2B )
    -- Action
    local PLcheck = display.newImage("img/icon/PLcheck.png")
    PLcheck:translate( 373, 190 )
    scrViewP:insert( PLcheck )
    
    -- Imagen
    local imgPBig = display.newImage("img/deco/imgPBig01.png")
    imgPBig:translate( midW, 440 )
    scrViewP:insert( imgPBig )
    
    -- Info Adicional
    local bgInfoSw = display.newRoundedRect( midW, 720, 400, 120, 10 )
    bgInfoSw:setFillColor( .95 )
    scrViewP:insert(bgInfoSw)
    local bgInfo = display.newRoundedRect( midW, 720, 396, 116, 10 )
    bgInfo:setFillColor( 1 )
    scrViewP:insert(bgInfo)
    local txtInfo1 = display.newText({
        text = "BEBIDAS GRATIS", 
        x = midW, y = 700, width = 380, 
        font = native.systemFontBold,
        fontSize = 28, align = "center"
    })
    txtInfo1:setFillColor( .3 )
    scrViewP:insert( txtInfo1 )
    local txtInfo2 = display.newText({
        text = "TODAS LAS BEBIDAS GRATIS EN TU CONSUMO", 
        x = midW, y = 740, width = 380, 
        font = native.systemFont,
        fontSize = 18, align = "center"
    })
    txtInfo2:setFillColor( .3 )
    scrViewP:insert( txtInfo2 )
        
    -- Vigencia
    local PLTime = display.newImage("img/icon/PLTime.png")
    PLTime:translate( 60, 810 )
    scrViewP:insert( PLTime )
    local txtVigencia1 = display.newText({
        text = "Vigencia:", 
        x = 160, y = 810, width = 150, 
        font = native.systemFont,
        fontSize = 18, align = "left"
    })
    txtVigencia1:setFillColor( .3 )
    scrViewP:insert( txtVigencia1 )
    local txtVigencia2 = display.newText({
        text = "Julio 2015", 
        x = 315, y = 810, width = 300, 
        font = native.systemFontBold,
        fontSize = 18, align = "left"
    })
    txtVigencia2:setFillColor( .3 )
    scrViewP:insert( txtVigencia2 )
    
    -- Boton Action 2
    local btnAction2Sw = display.newRoundedRect( midW, 865 + 6, 400, 60, 10 )
    btnAction2Sw:setFillColor( .95 )
    scrViewP:insert(btnAction2Sw)
    local btnAction2Bg = display.newRoundedRect( midW, 865, 400, 60, 10 )
    btnAction2Bg:setFillColor( .15, .72, .91 )
    scrViewP:insert(btnAction2Bg)
    local btnAction2Txt = display.newText({
        text = "COMPRAR", 
        x = midW, y = 865, width = 400, 
        font = native.systemFontBold,
        fontSize = 28, align = "center"
    })
    btnAction2Txt:setFillColor( 1 )
    scrViewP:insert( btnAction2Txt )
    
    -- Terminos y Condiciones
    local txtTerminos1 = display.newText({
        text = "Terminos y Condiciones:", 
        x = 240, y = 935, width = 400, 
        font = native.systemFont,
        fontSize = 18, align = "left"
    })
    txtTerminos1:setFillColor( .3 )
    scrViewP:insert( txtTerminos1 )
    local txtTerminos2 = display.newText({
        text = "Lorem ipsum ad his scripta blandit partiendo, eum fastidii accumsan euripidis in, eum liber hendrerit an. Qui ut wisi vocibus suscipiantur, quo dicit ridens inciderint id. Quo mundi lobortis reformidans eu, legimus senserit definiebas an eos. Eu sit tincidunt incorrupte definitionem, vis mutat affert percipit cu, eirmod consectetuer signiferumque eu per.", 
        x = 240, y = 950, width = 400, 
        font = native.systemFontBold,
        fontSize = 16, align = "left"
    })
    txtTerminos2.anchorY = 0
    txtTerminos2:setFillColor( .3 )
    scrViewP:insert( txtTerminos2 )
    
    
    scrViewP:setScrollHeight(1100)
    
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