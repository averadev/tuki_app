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
local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local h = display.topStatusBarContentHeight 
local btnCatBg1
local btns = {}


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function goToEnd(event)
    if btnCatBg1.alpha == 0 then
        -- Send filter
        local txtFil = ''
        for z = 1, #btns, 1 do 
            if btns[z].isActive then
                if txtFil ~= '' then
                    txtFil = txtFil..'-'
                end
                txtFil = txtFil..z
            end
        end
        -- Change Scene
        local t = event.target
        audio.play(fxTap)
        composer.removeScene( "src.WelcomeList" )
        composer.gotoScene("src.WelcomeList", { time = 400, effect = "slideLeft", params = { filter = txtFil} } )
    end
end

function tapWelcomeFilter(event)
    local t = event.target
    if t.idx == 1 then
        if not (t.isActive) then
            audio.play(fxTap)
            t.isActive = true
            t.bgFP1.alpha = 0
            t.bgFP2.alpha = 1
            t.iconOn.alpha = 1
            t.iconOff.alpha = 0
        end
        for z = 2, #btns, 1 do
        if btns[z].isActive then
            btns[z].isActive = false
            btns[z].bgFP1.alpha = 1
            btns[z].bgFP2.alpha = 0
            btns[z].iconOn.alpha = 0
            btns[z].iconOff.alpha = 1
        end
    end
    else
        if btns[1].isActive then
            btns[1].isActive = false
            btns[1].bgFP1.alpha = 1
            btns[1].bgFP2.alpha = 0
            btns[1].iconOn.alpha = 0
            btns[1].iconOff.alpha = 1
        end
            
        audio.play(fxTap)
        if t.isActive then
            t.isActive = false
            t.bgFP1.alpha = 1
            t.bgFP2.alpha = 0
            t.iconOn.alpha = 0
            t.iconOff.alpha = 1
        else
            t.isActive = true
            t.bgFP1.alpha = 0
            t.bgFP2.alpha = 1
            t.iconOn.alpha = 1
            t.iconOff.alpha = 0
        end
    end
    
    -- Verify next button
    local isReady = false
    for z = 1, #btns, 1 do
        if btns[z].isActive then
            isReady = true
        end
    end
    if isReady then
        if btnCatBg1.alpha == 1 then
            btnCatBg1.alpha = 0
        end
    else
        if btnCatBg1.alpha == 0 then
            btnCatBg1.alpha = 1
        end
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    
    local txt1 = display.newText({
        text = "¡SELECCIONA!",
        x = midW, y = h + 25,
        font = fontBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cBlueH) )
    screen:insert( txt1 )
    
    txtW2 = display.newText({
        text = "Selecciona tus intereses",
        x = midW, y = h + 60,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW2:setFillColor( unpack(cBlueH) )
    screen:insert( txtW2 )
    
    txtW3 = display.newText({
        text = " y encuentra tus comercios favoritos.",
        x = midW, y = h + 85,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW3:setFillColor( unpack(cBlueH) )
    screen:insert( txtW3 )
    
    
    scrViewW2 = widget.newScrollView
	{
		top = h + 110,
		left = 0,
		width = display.contentWidth,
		height = intH - (h + 200),
		horizontalScrollDisabled = true
	}
	screen:insert(scrViewW2)
    
    local isLeft = true
    local xPosc = 0
    local yPosc = -100
    for z = 1, #Globals.filtros, 1 do 
        
        if isLeft then
            xPosc = 135
            isLeft = false
            yPosc = yPosc + 200
        else
            xPosc = 345
            isLeft = true
        end

        local idx = #btns + 1
        btns[idx] = display.newContainer( 190, 190 )
        btns[idx]:translate( xPosc, yPosc )
        btns[idx].idx = idx
        btns[idx].isActive = false
        scrViewW2:insert( btns[idx] )
        btns[idx]:addEventListener( 'tap', tapWelcomeFilter)

        btns[idx].bgFP1 = display.newRect(0, 0, 190, 190 )
        btns[idx].bgFP1:setFillColor( .96 )
        btns[idx]:insert( btns[idx].bgFP1 )

        btns[idx].bgFP2 = display.newRect(0, 0, 190, 190 )
        btns[idx].bgFP2:setFillColor( .90 )
        btns[idx].bgFP2.alpha = 0
        btns[idx]:insert( btns[idx].bgFP2 )

        btns[idx].iconOn = display.newImage("img/icon/"..Globals.filtros[z][2].."2.png")
        btns[idx].iconOn:translate(0, -10)
        btns[idx].iconOn.height = 100
        btns[idx].iconOn.width = 100
        btns[idx].iconOn.alpha = 0
        btns[idx]:insert( btns[idx].iconOn )

        btns[idx].iconOff = display.newImage("img/icon/"..Globals.filtros[z][2].."1.png")
        btns[idx].iconOff:translate(0, -10)
        btns[idx].iconOff.height = 100
        btns[idx].iconOff.width = 100
        btns[idx]:insert( btns[idx].iconOff )

        btns[idx].txt = display.newText({
            text = Globals.filtros[z][1], 
            x = xPosc, y = yPosc + 60,
            font = fontSemiBold,   
            fontSize = 16, align = "center"
        })
        btns[idx].txt:setFillColor( unpack(cBlueH) )
        scrViewW2:insert( btns[idx].txt )

    end
    
    -- Botons
    local btnCatBg = display.newRoundedRect( midW, intH - 45, 350, 70, 10 )
    btnCatBg:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "right"
    } )
    btnCatBg:addEventListener( 'tap', goToEnd )
    screen:insert(btnCatBg)
    btnCatBg1 = display.newRoundedRect( midW, intH - 45, 350, 70, 10 )
    btnCatBg1:setFillColor( unpack(cGrayM) )
    screen:insert(btnCatBg1)
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
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
    
end

-- Remove Listener
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene