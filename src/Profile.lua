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
require("src.datePickerWheel")

-- Grupos y Contenedores
local screen, grpCumple, grpMale, grpFemale, dateBirthday
local scene = composer.newScene()

-- Variables
local txt1, txt2, lblCumple

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

------------------------------------
-- Cierra componente cumpleaños
-- @param event objeto evento
------------------------------------
function closeCumple(event)
    hideTxt(false)
    if grpCumple then
        grpCumple:removeSelf()
        grpCumple = nil;
    end
end

------------------------------------
-- Selecciona cumpleaños
-- @param event objeto evento
------------------------------------
function selCumple(event)
    local values = dateBirthday:getValues()
    lblCumple.text = values[2].value .. "  de " .. values[1].value  .. ", " .. values[3].value
    lblCumple.year = values[3].value
    lblCumple.day = values[2].value
    for z = 1, #meses, 1 do 
        if meses[z] == values[1].value then
            lblCumple.month = z
        end
    end
    closeCumple()
end

------------------------------------
-- Oculta textbox
-- @param event objeto evento
------------------------------------
function hideTxt(isHide)
    if isHide then
        txt1.x = 600
        txt2.x = 600
    else
        txt1.x = midW + 60
        txt2.x = midW + 60
    end
end

------------------------------------
-- Selecciona genero
-- @param event objeto evento
------------------------------------
function tapGenere(event)
    local typeG = event.target.genere
    if typeG == 'male' and not (grpMale.alpha == 1) then
        grpMale.alpha = 1
        grpFemale.alpha = .01
    elseif typeG == 'female' and not (grpFemale.alpha == 1) then
        grpMale.alpha = .01
        grpFemale.alpha = 1
    end
end

------------------------------------
-- Muestra componente cumpleaños
-- @param event objeto evento
------------------------------------
function tapCumple(event)
    if grpCumple then
        grpCumple:removeSelf()
        grpCumple = nil;
    end
    grpCumple = display.newGroup()
    screen:insert(grpCumple)
    
    hideTxt(true)
    
    function setDes(event)
        return true
    end
    local bg = display.newRect(midW, midH, intW, intH )
    bg.alpha = .5
    bg:setFillColor( 0 )
    bg:addEventListener( 'tap', setDes )
    grpCumple:insert(bg)
    
    local bg1 = display.newRoundedRect(midW, midH, 370, 340, 5 )
    bg1:setFillColor( unpack(cTurquesa) )
    grpCumple:insert(bg1)
    
    local bg2 = display.newRoundedRect(midW, midH, 364, 334, 5 )
    bg2:setFillColor( unpack(cWhite) )
    grpCumple:insert(bg2)
    
    local iconClose = display.newImage("img/icon/iconClose.png")
    iconClose:translate(midW + 155, midH - 145)
    iconClose:addEventListener( 'tap', closeCumple )
    grpCumple:insert( iconClose )
    
    local btnAccept = display.newRoundedRect(midW + 5, midH + 130, 150, 45, 5 )
    btnAccept:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBTur) }, 
        color2 = { unpack(cBBlu) },
        direction = "bottom"
    } )
    btnAccept:addEventListener( 'tap', selCumple )
    grpCumple:insert(btnAccept)
    local lblAccept = display.newText({
        text = 'Seleccionar', 
        x = midW + 5, y = midH + 130,
        font = fontSemiBold, fontSize = 20
    })
    lblAccept:setFillColor( unpack(cWhite) )
    grpCumple:insert( lblAccept )
    
    local year = 2016
    local month = 1
    local day = 1
    if lblCumple.month then
        year = lblCumple.year
        month = lblCumple.month
        day = lblCumple.day
    end
    
    dateBirthday = widget.newDatePickerWheel(year, month, day)
    dateBirthday.anchorChildren = true
    dateBirthday.x = midW
    dateBirthday.y = midH - 15
    grpCumple:insert(dateBirthday)
    
    return true
end

-------------------------------------
-- Muestra primer detalle del usuario
-- @param usuario objeto
------------------------------------
function showProfile(usuario)
    -- Background
    local lastY = 0
    local bgFB = display.newRect(midW, lastY, intW, 170 )
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
    
    -- Campos editables
    lastY = 230
    
    local lbl1 = display.newText({
        text = "Email:", 
        x = 140, y = lastY, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl1:setFillColor( unpack(cBlueH) )
    scrViewA:insert( lbl1 )
    local bg1A = display.newRoundedRect(midW + 60, lastY, 250, 50, 5 )
    bg1A:setFillColor( unpack(cTurquesa) )
    scrViewA:insert(bg1A)
    local bg1B = display.newRoundedRect(midW + 60, lastY, 246, 46, 5 )
    bg1B:setFillColor( unpack(cWhite) )
    scrViewA:insert(bg1B)
    txt1 = native.newTextField( midW + 60, lastY, 220, 40 )
    txt1.size = 18
    txt1.inputType = "email"
    txt1.hasBackground = false
    txt1.placeholder = "Correo electronico"
	scrViewA:insert(txt1)
    
    local lbl2 = display.newText({
        text = "Telefono:", 
        x = 140, y = lastY + 70, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl2:setFillColor( unpack(cBlueH) )
    scrViewA:insert( lbl2 )
    local bg2A = display.newRoundedRect(midW + 60, lastY + 70, 250, 50, 5 )
    bg2A:setFillColor( unpack(cTurquesa) )
    scrViewA:insert(bg2A)
    local bg2B = display.newRoundedRect(midW + 60, lastY + 70, 246, 46, 5 )
    bg2B:setFillColor( unpack(cWhite) )
    scrViewA:insert(bg2B)
    txt2 = native.newTextField( midW + 60, lastY + 70, 220, 40 )
    txt2.size = 18
    txt2.inputType = "email"
    txt2.hasBackground = false
    txt2.placeholder = "Telefono"
	scrViewA:insert(txt2)
    
    local lbl3 = display.newText({
        text = "Sexo:", 
        x = 140, y = lastY + 140, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl3:setFillColor( unpack(cBlueH) )
    scrViewA:insert( lbl3 )
    local bg3A = display.newRoundedRect(midW + 10, lastY + 140, 150, 50, 5 )
    bg3A:setFillColor( unpack(cTurquesa) )
    scrViewA:insert(bg3A)
    local bg3B = display.newRoundedRect(midW + 10, lastY + 140, 146, 46, 5 )
    bg3B:setFillColor( unpack(cWhite) )
    scrViewA:insert(bg3B)
    local icon3A = display.newImage("img/icon/iconMale.png")
    icon3A:translate(midW - 28, lastY + 140)
    scrViewA:insert( icon3A )
    local icon3B = display.newImage("img/icon/iconFemale.png")
    icon3B:translate(midW + 48, lastY + 140)
    scrViewA:insert( icon3B )
    grpMale = display.newGroup()
    scrViewA:insert(grpMale)
    local bg3D = display.newRoundedRect(midW - 26, lastY + 140, 74, 46, 5 )
    bg3D:setFillColor( unpack(cBlueH) )
    bg3D.genere = 'male'
    bg3D:addEventListener( 'tap', tapGenere )
    grpMale:insert(bg3D)
    local icon3C = display.newImage("img/icon/iconMaleA.png")
    icon3C:translate(midW - 28, lastY + 140)
    grpMale:insert( icon3C )
    grpFemale = display.newGroup()
    scrViewA:insert(grpFemale)
    local bg3E = display.newRoundedRect(midW + 46, lastY + 140, 74, 46, 5 )
    bg3E:setFillColor( unpack(cBlueH) )
    bg3E.genere = 'female'
    bg3E:addEventListener( 'tap', tapGenere )
    grpFemale:insert(bg3E)
    local icon3D = display.newImage("img/icon/iconFemaleA.png")
    icon3D:translate(midW + 48, lastY + 140)
    grpFemale:insert( icon3D )
    local bg3C = display.newRoundedRect(midW + 10, lastY + 140, 3, 50, 5 )
    bg3C:setFillColor( unpack(cTurquesa) )
    scrViewA:insert(bg3C)
    grpMale.alpha = .01
    grpFemale.alpha = .01
    
    local lbl4 = display.newText({
        text = "Cumpleaños:", 
        x = 140, y = lastY + 210, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl4:setFillColor( unpack(cBlueH) )
    scrViewA:insert( lbl4 )
    local bg4A = display.newRoundedRect(midW + 60, lastY + 210, 250, 50, 5 )
    bg4A:setFillColor( unpack(cTurquesa) )
    scrViewA:insert(bg4A)
    local bg4B = display.newRoundedRect(midW + 60, lastY + 210, 246, 46, 5 )
    bg4B:setFillColor( unpack(cWhite) )
    scrViewA:insert(bg4B)
    bg4B:addEventListener( 'tap', tapCumple )
    local iconSelect4 = display.newImage("img/icon/iconSelect.png")
    iconSelect4:translate(midW + 163, lastY + 210)
    scrViewA:insert( iconSelect4 )
    lblCumple = display.newText({
        text = "", 
        x = 300, y = lastY + 210, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lblCumple.year = nil
    lblCumple.month = nil
    lblCumple.day = nil
    lblCumple:setFillColor( unpack(cBlueH) )
    scrViewA:insert( lblCumple )
    
    if usuario.email then
        txt1.text = usuario.email
    end
    if usuario.phone then
        txt2.text = usuario.phone
    end
    if usuario.gender then
        if usuario.gender == 'male' then
            grpMale.alpha = 1
        elseif usuario.gender == 'female' then
            grpFemale.alpha = 1
        end
    end
    if usuario.birthDate then
        if usuario.birday then
            lblCumple.day = tonumber(usuario.birday)
        end
        if usuario.birmonth then
            lblCumple.month = tonumber(usuario.birmonth)
        end
        if usuario.biryear then
            lblCumple.year = tonumber(usuario.biryear)
        end
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
    RestManager.getProfile()
    
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
    if txt1 then
        txt1:removeSelf()
        txt1 = nil;
    end
    if txt2 then
        txt2:removeSelf()
        txt2 = nil;
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene