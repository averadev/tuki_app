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
require("src.datePickerWheel")
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
local ciudades = {}
local bigList = true
local readyNext = false
local tools, grpCumple, grpCiudad, grpMale, grpFemale
local txtProfEmail, txtProfPhone, lblCumple, lblCiudad

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

------------------------------------
-- Cambiar de escena
-- @param event objeto evento
------------------------------------
function isUpdProfile(event)
    locIdCity = lblCiudad.idCity
    composer.removeScene( "src.WelcomeList" )
    composer.gotoScene("src.WelcomeList", { time = 400, effect = "slideLeft" } )
end

------------------------------------
-- Seleccionar por la coidad actual
-- @param event objeto evento
------------------------------------
function changeCity(idCity)
    for z = 1, #ciudades, 1 do 
        if tonumber(ciudades[z].id) == tonumber(idCity) then
            lblCiudad.idCity = ciudades[z].id
            lblCiudad.text = ciudades[z].name
        end
    end
end

------------------------------------
-- Actualizar Perfil
-- @param event objeto evento
------------------------------------
function updateProfile(event)
    local gender = ''
    if grpMale.alpha == 1 then
        gender = 'male'
    elseif grpFemale.alpha == 1 then
        gender = 'female'
    end
    
    local birthDate = ''
    if lblCumple.month then
        birthDate = lblCumple.year .. '-' .. lblCumple.month .. '-' .. lblCumple.day
    end 
    
    local idCity = ''
    if not (lblCiudad.text == '') then
        idCity = lblCiudad.idCity
    end 
    
    hideTxt(true)
    tools:setLoading(true, screen)
    RestManager.updateProfile(txtProfEmail.text, txtProfPhone.text, gender, birthDate, idCity)
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
-- Oculta textbox
-- @param event objeto evento
------------------------------------
function hideTxt(isHide)
    if isHide then
        txtProfEmail.x = 600
        txtProfPhone.x = 600
    else
        txtProfEmail.x = midW + 60
        txtProfPhone.x = midW + 60
    end
end

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
-- Cierra componente cumpleaños
-- @param event objeto evento
------------------------------------
function closeCiudad(event)
    hideTxt(false)
    if grpCiudad then
        grpCiudad:removeSelf()
        grpCiudad = nil;
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
    
    if lblCumple.month then
        print("lblCumple: "..lblCumple.day.."/"..lblCumple.month.."/"..lblCumple.year)
        dateBirthday = widget.newDatePickerWheel(tonumber(lblCumple.year), tonumber(lblCumple.month), tonumber(lblCumple.day))
    else
        dateBirthday = widget.newDatePickerWheel()
    end
    
    
    dateBirthday.anchorChildren = true
    dateBirthday.x = midW
    dateBirthday.y = midH - 15
    grpCumple:insert(dateBirthday)
    
    return true
end

-------------------------------------
-- Get current position
-- @param event objeto evento
------------------------------------
local getGPS = function( event )
    -- Check for error (user may have turned off location services)
    if ( event.errorCode ) then
		Runtime:removeEventListener( "location", getGPS )
    else
		Runtime:removeEventListener( "location", getGPS )
        gpsLat = event.latitude
        gpsLon = event.longitude
        RestManager.getLocationCity(21.147593180615, -86.82323455810)
        
    end
end

------------------------------------
-- Muestra componente cumpleaños
-- @param event objeto evento
------------------------------------
function tapCiudad(event)
    if grpCiudad then
        grpCiudad:removeSelf()
        grpCiudad = nil;
    end
    grpCiudad = display.newGroup()
    screen:insert(grpCiudad)
    
    hideTxt(true)
    
    function setDes(event)
        return true
    end
    local bg = display.newRect(midW, midH, intW, intH )
    bg.alpha = .5
    bg:setFillColor( 0 )
    bg:addEventListener( 'tap', setDes )
    grpCiudad:insert(bg)
    
    local bg1 = display.newRoundedRect(midW, midH, 370, 340, 5 )
    bg1:setFillColor( unpack(cTurquesa) )
    grpCiudad:insert(bg1)
    
    local bg2 = display.newRoundedRect(midW, midH, 364, 334, 5 )
    bg2:setFillColor( unpack(cWhite) )
    grpCiudad:insert(bg2)
    
    local iconClose = display.newImage("img/icon/iconClose.png")
    iconClose:translate(midW + 155, midH - 145)
    iconClose:addEventListener( 'tap', closeCiudad )
    grpCiudad:insert( iconClose )
    
    local scrViewCities = widget.newScrollView{
		width = 300,
		height = 250,
		horizontalScrollDisabled = true
	}
    scrViewCities.x = midW
    scrViewCities.y = midH
	grpCiudad:insert(scrViewCities)
    
    for z = 1, #ciudades, 1 do
        local yPosc = (z * 62) - 30
        
        local bg = display.newRect(150, yPosc, 300, 60 )
        bg.idCity = ciudades[z].id
        bg.name = ciudades[z].name
        bg:addEventListener( 'tap', function(event) 
            lblCiudad.idCity = event.target.idCity
            lblCiudad.text = event.target.name
            closeCiudad()
        end )
        scrViewCities:insert(bg)
        
        local line = display.newRect(150, yPosc+31, 300, 2 )
        line:setFillColor( .8 )
        scrViewCities:insert(line)
        
        local txt = display.newText({
            text = ciudades[z].name,
            x = 170, y = yPosc,
            font = fontRegular,   
            width = 240,
            fontSize = 18, align = "left"
        })
        txt:setFillColor( unpack(cBlueH) )
        scrViewCities:insert( txt )
        
        if ciudades[z].id == lblCiudad.idCity then
            local iconCheck = display.newImage("img/icon/iconCheck.png")
            iconCheck:translate( 28, yPosc)
            scrViewCities:insert( iconCheck )
        end
    end
    
    return true
end

function showProfile(usuario, cities)
    ciudades = cities
    
    if usuario.email then
        txtProfEmail.text = usuario.email
    end
    if usuario.phone then
        txtProfPhone.text = usuario.phone
    end
    if usuario.ciudad then
        lblCiudad.idCity = usuario.idCity
        lblCiudad.text = usuario.ciudad
    end
    if usuario.gender then
        if usuario.gender == 'male' then
            grpMale.alpha = 1
        elseif usuario.gender == 'female' then
            grpFemale.alpha = 1
        end
    end
    if usuario.birthDate then
        if tonumber(usuario.biryear) > 0 then
            if usuario.birday then
                lblCumple.day = tonumber(usuario.birday)
            end
            if usuario.birmonth then
                lblCumple.month = tonumber(usuario.birmonth)
            end
            if usuario.biryear then
                lblCumple.year = tonumber(usuario.biryear)
            end
            lblCumple.text = lblCumple.day .. ' de ' .. meses[tonumber(usuario.birmonth)] .. ', ' .. usuario.biryear
        end
    end
    Runtime:addEventListener( "location", getGPS )
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
        text = "¡CUÉNTANOS DE TI!",
        x = midW, y = h + 45,
        font = fontBold,   
        fontSize = 30, align = "center"
    })
    txt1:setFillColor( unpack(cBlueH) )
    screen:insert( txt1 )
    
    txtW2 = display.newText({
        text = "Ayudanos a conocer un poco mas de ti,",
        x = midW, y = h + 80,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW2:setFillColor( unpack(cBlueH) )
    screen:insert( txtW2 )
    
    txtW3 = display.newText({
        text = "esta información nos ayudara para",
        x = midW, y = h + 105,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW3:setFillColor( unpack(cBlueH) )
    screen:insert( txtW3 )
    screen:insert( txtW2 )
    
    txtW4 = display.newText({
        text = "entregarte recompensas especiales.",
        x = midW, y = h + 130,
        font = fontLight,   
        fontSize = 20, align = "center"
    })
    txtW4:setFillColor( unpack(cBlueH) )
    screen:insert( txtW4 )
    
    -- Campos editables
    lastY = 220
    
    local lbl1 = display.newText({
        text = "Email:", 
        x = 140, y = lastY, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl1:setFillColor( unpack(cBlueH) )
    screen:insert( lbl1 )
    local bg1A = display.newRoundedRect(midW + 60, lastY, 250, 50, 5 )
    bg1A:setFillColor( unpack(cTurquesa) )
    screen:insert(bg1A)
    local bg1B = display.newRoundedRect(midW + 60, lastY, 246, 46, 5 )
    bg1B:setFillColor( unpack(cWhite) )
    screen:insert(bg1B)
    txtProfEmail = native.newTextField( midW + 60, lastY, 220, 40 )
    txtProfEmail.size = 18
    txtProfEmail.inputType = "email"
    txtProfEmail.hasBackground = false
    txtProfEmail.placeholder = "Correo electronico"
	screen:insert(txtProfEmail)
    
    local lbl2 = display.newText({
        text = "Telefono:", 
        x = 140, y = lastY + 70, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl2:setFillColor( unpack(cBlueH) )
    screen:insert( lbl2 )
    local bg2A = display.newRoundedRect(midW + 60, lastY + 70, 250, 50, 5 )
    bg2A:setFillColor( unpack(cTurquesa) )
    screen:insert(bg2A)
    local bg2B = display.newRoundedRect(midW + 60, lastY + 70, 246, 46, 5 )
    bg2B:setFillColor( unpack(cWhite) )
    screen:insert(bg2B)
    txtProfPhone = native.newTextField( midW + 60, lastY + 70, 220, 40 )
    txtProfPhone.size = 18
    txtProfPhone.inputType = "email"
    txtProfPhone.hasBackground = false
    txtProfPhone.placeholder = "Telefono"
	screen:insert(txtProfPhone)
    
    local lbl3 = display.newText({
        text = "Sexo:", 
        x = 140, y = lastY + 140, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl3:setFillColor( unpack(cBlueH) )
    screen:insert( lbl3 )
    local bg3A = display.newRoundedRect(midW + 10, lastY + 140, 150, 50, 5 )
    bg3A:setFillColor( unpack(cTurquesa) )
    screen:insert(bg3A)
    local bg3B = display.newRoundedRect(midW + 10, lastY + 140, 146, 46, 5 )
    bg3B:setFillColor( unpack(cWhite) )
    screen:insert(bg3B)
    local icon3A = display.newImage("img/icon/icoMale.png")
    icon3A:translate(midW - 28, lastY + 140)
    screen:insert( icon3A )
    local icon3B = display.newImage("img/icon/icoFemale.png")
    icon3B:translate(midW + 48, lastY + 140)
    screen:insert( icon3B )
    grpMale = display.newGroup()
    screen:insert(grpMale)
    local bg3D = display.newRoundedRect(midW - 26, lastY + 140, 74, 46, 5 )
    bg3D:setFillColor( unpack(cBlueH) )
    bg3D.genere = 'male'
    bg3D:addEventListener( 'tap', tapGenere )
    grpMale:insert(bg3D)
    local icon3C = display.newImage("img/icon/icoMaleA.png")
    icon3C:translate(midW - 28, lastY + 140)
    grpMale:insert( icon3C )
    grpFemale = display.newGroup()
    screen:insert(grpFemale)
    local bg3E = display.newRoundedRect(midW + 46, lastY + 140, 74, 46, 5 )
    bg3E:setFillColor( unpack(cBlueH) )
    bg3E.genere = 'female'
    bg3E:addEventListener( 'tap', tapGenere )
    grpFemale:insert(bg3E)
    local icon3D = display.newImage("img/icon/icoFemaleA.png")
    icon3D:translate(midW + 48, lastY + 140)
    grpFemale:insert( icon3D )
    local bg3C = display.newRoundedRect(midW + 10, lastY + 140, 3, 50, 5 )
    bg3C:setFillColor( unpack(cTurquesa) )
    screen:insert(bg3C)
    grpMale.alpha = .01
    grpFemale.alpha = .01
    
    local lbl4 = display.newText({
        text = "Cumpleaños:", 
        x = 140, y = lastY + 210, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl4:setFillColor( unpack(cBlueH) )
    screen:insert( lbl4 )
    local bg4A = display.newRoundedRect(midW + 60, lastY + 210, 250, 50, 5 )
    bg4A:setFillColor( unpack(cTurquesa) )
    screen:insert(bg4A)
    local bg4B = display.newRoundedRect(midW + 60, lastY + 210, 246, 46, 5 )
    bg4B:setFillColor( unpack(cWhite) )
    screen:insert(bg4B)
    bg4B:addEventListener( 'tap', tapCumple )
    local iconSelect4 = display.newImage("img/icon/iconSelect.png")
    iconSelect4:translate(midW + 163, lastY + 210)
    screen:insert( iconSelect4 )
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
    screen:insert( lblCumple )
    
    local lbl5 = display.newText({
        text = "Ciudad:", 
        x = 140, y = lastY + 290, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lbl5:setFillColor( unpack(cBlueH) )
    screen:insert( lbl5 )
    local bg5A = display.newRoundedRect(midW + 60, lastY + 290, 250, 50, 5 )
    bg5A:setFillColor( unpack(cTurquesa) )
    screen:insert(bg5A)
    local bg5B = display.newRoundedRect(midW + 60, lastY + 290, 246, 46, 5 )
    bg5B:setFillColor( unpack(cWhite) )
    screen:insert(bg5B)
    bg5B:addEventListener( 'tap', tapCiudad )
    local iconSelect5 = display.newImage("img/icon/iconSelect.png")
    iconSelect5:translate(midW + 163, lastY + 290)
    screen:insert( iconSelect5 )
    lblCiudad = display.newText({
        text = "", 
        x = 300, y = lastY + 290, width = 200, 
        font = fontSemiBold,   
        fontSize = 16, align = "left"
    })
    lblCiudad.year = nil
    lblCiudad.month = nil
    lblCiudad.day = nil
    lblCiudad:setFillColor( unpack(cBlueH) )
    screen:insert( lblCiudad )
    
    local lbl6 = display.newText({
        text = "*Recuerda que despues puedes cambiar de ciudad, y a si acceder a otros comercios TUKI y a sus recompensas.", 
        x = 240, y = lastY + 350, width = 400, 
        font = fontSemiRegular,   
        fontSize = 14, align = "left"
    })
    lbl6:setFillColor( unpack(cBlueH) )
    screen:insert( lbl6 )
    
    -- Botons
    local btnNearBg = display.newRoundedRect( midW,  lastY + 420, 350, 70, 10 )
    btnNearBg:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBBlu) }, 
        color2 = { unpack(cBTur) },
        direction = "right"
    } )
    btnNearBg:addEventListener( 'tap', updateProfile )
    screen:insert(btnNearBg)
    local icoWArrow = display.newImage("img/icon/icoWArrow.png")
    icoWArrow:translate( midW + 60, lastY + 420 )
    screen:insert( icoWArrow )
    local txtNear2 = display.newText({
        text = "CONTINUAR",
        x = midW + 35, y = lastY + 420,
        font = fontBold, width = 250,  
        fontSize = 20, align = "left"
    })
    txtNear2:setFillColor( unpack(cWhite) )
    screen:insert( txtNear2 )
    
    RestManager.getProfile()
end	

-- Hide Listener
function scene:hide( event )
    if txtProfEmail then
        txtProfEmail:removeSelf()
        txtProfEmail = nil;
    end
    if txtProfPhone then
        txtProfPhone:removeSelf()
        txtProfPhone = nil;
    end
end

-- Remove Listener
function scene:destroy( event )
    Runtime:removeEventListener( "location", getGPS )
    if txtProfEmail then
        txtProfEmail:removeSelf()
        txtProfEmail = nil;
    end
    if txtProfPhone then
        txtProfPhone:removeSelf()
        txtProfPhone = nil;
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene