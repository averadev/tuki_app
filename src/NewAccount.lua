---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------
local composer = require( "composer" )
local Globals = require('src.Globals')
local Sprites = require('src.Sprites')
local DBManager = require('src.DBManager')
local RestManager = require('src.RestManager')
local facebook = require("plugin.facebook.v4")
local json = require("json")
local scene = composer.newScene()

-- Variables
local circles = {}
local grpSplash = {}
local direction = 0
local idxScr = 1
local bottomLogin, loadLogin
local imgLogo, groupSign, groupCreate
local txtSignEmail, txtSignPass, txtCreateEmail, txtCreatePass, txtCreateRePass


---------------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------------


function toLoginUser(isWelcome)
    local scrLogin = "src.Home"
    if isWelcome then
        scrLogin = "src.WelcomeHome"
    end
    Globals.isReadOnly = true
    reloadConfig()
    composer.removeScene( scrLogin )
    composer.gotoScene( scrLogin, { time = 400, effect = "crossFade" })
end

function onTxtFocus(event)
    if ( "began" == event.phase ) then
        -- Interfaz Sign In
        if groupSign.x == 0 and groupSign.y == 0 then
            transition.to( imgLogo, { y = 65 + h, width = 200, height = 74, time = 400, transition = easing.outExpo } )
            transition.to( groupSign, { y = (-midH + 200) + h, time = 400, transition = easing.outExpo } )
        -- Interfaz Create
        elseif groupCreate.x == 0 and groupCreate.y == 0 then
            transition.to( imgLogo, { y = 65 + h, width = 200, height = 74, time = 400, transition = easing.outExpo } )
            transition.to( groupCreate, { y = (-midH + 230) + h, time = 400, transition = easing.outExpo } )
        end
    elseif ( "submitted" == event.phase ) then
        backTxtPositions()
        if event.target.method == "create" then
            doCreate()
        else
            doSignIn()
        end
    end
end

function getReturnSplash(event)
    backTxtPositions()
    composer.removeScene( "src.Login" )
    composer.gotoScene( "src.Login", { time = 400, effect = "crossFade" })
end 

function backTxtPositions()
    -- Hide Keyboard
    native.setKeyboardFocus(nil)
    -- Interfaz Sign In
    if groupSign.x == 0 and groupSign.y < 0 then
        transition.to( imgLogo, { y = midH / 2, width = 400, height = 147, time = 400, transition = easing.outExpo } )
        transition.to( groupSign, { y = 0, time = 400, transition = easing.outExpo } )
    -- Interfaz Create
    elseif groupCreate.x == 0 and groupCreate.y < 0 then
        transition.to( imgLogo, { y = midH / 2, width = 400, height = 147, time = 400, transition = easing.outExpo } )
        transition.to( groupCreate, { y = 0, time = 400, transition = easing.outExpo } )
    end
end

function showCreate()
    backTxtPositions()
    transition.to( groupSign, { x = -480, time = 400, transition = easing.outExpo } )
    transition.to( groupCreate, { x = 0, time = 400, transition = easing.outExpo } )
end

function hideCreate()
    backTxtPositions()
    transition.to( groupSign, { x = 0, time = 400, transition = easing.outExpo } )
    transition.to( groupCreate, { x = 480, time = 400, transition = easing.outExpo } )
end

function doCreate()
    if txtCreateEmail.text == '' or txtCreatePass.text == '' or txtCreateRePass.text == '' then
        native.showAlert( "TUKI", 'El email y password son necesarios.', { "OK"})
    elseif not (txtCreatePass.text == txtCreateRePass.text) then
        native.showAlert( "TUKI", 'Los paswords no coinciden.', { "OK"})
    else
        backTxtPositions()
        RestManager.createUser(txtCreateEmail.text, txtCreatePass.text)
    end
end

function doSignIn()
    if txtSignEmail.text == '' or txtSignPass.text == '' then
        native.showAlert( "TUKI", 'El email y password son necesarios.', { "OK"})
    else
        backTxtPositions()
        RestManager.validateUser(txtSignEmail.text, txtSignPass.text)
    end 
end


---------------------------------------------------------------------------------
-- OVERRIDING SCENES METHODS
--------------------------------------------------------------- ------------------
-- Called when the scene's view does not exist:
function scene:create( event )
    -- Agregamos el home
	screen = self.view
    
    local bg = display.newRect( midW, h, intW, intH )
    bg.anchorY = 0
    bg:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBTur) }, 
        color2 = { unpack(cBBlu) },
        direction = "top"
    } ) 
    screen:insert(bg)
        
    imgLogo = display.newImage("img/deco/logoWhite.png", true) 
	imgLogo.x = midW
	imgLogo.y = midH / 2
	screen:insert(imgLogo)
    
    -- Groups
    groupSign = display.newGroup()
	screen:insert(groupSign)
    groupCreate = display.newGroup()
	screen:insert(groupCreate)

    -- Bg TextFields
    local bg1 = display.newRoundedRect( midW, midH - 40, 350, 55, 5 )
	bg1:setFillColor( unpack(cTurquesa) )
	groupSign:insert(bg1)
    local bg2 = display.newRoundedRect( midW, midH - 40, 344, 51, 5 )
	bg2:setFillColor( unpack(cWhite) )
	groupSign:insert(bg2)
    local bg3 = display.newRoundedRect( midW, midH + 40, 350, 55, 5 )
	bg3:setFillColor( unpack(cTurquesa) )
	groupSign:insert(bg3)
    local bg4 = display.newRoundedRect( midW, midH + 40, 350, 51, 5 )
	bg4:setFillColor( unpack(cWhite) )
	groupSign:insert(bg4)
    local bg5 = display.newRoundedRect( midW, midH + 120, 350, 55, 5 )
	bg5:setFillColor( unpack(cTurquesa) )
    bg5:addEventListener( "tap", doSignIn )
	groupSign:insert(bg5)
    local bg6 = display.newRoundedRect( midW, midH + 200, 350, 55, 5 )
	bg6:setFillColor( unpack(cBPur) )
    bg6:addEventListener( "tap", showCreate )
	groupSign:insert(bg6)
    local btnDoReturn = display.newRect( midW - 90, midH + 270, 160, 40 )
    btnDoReturn.alpha = .01
    btnDoReturn:addEventListener( "tap", getReturnSplash )
	groupSign:insert(btnDoReturn)
    
    -- TextFields Sign In
    txtSignEmail = native.newTextField( midW + 25, midH - 40, 300, 45 )
    txtSignEmail.size = 24
    txtSignEmail.method = "signin"
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
    txtSignEmail.placeholder = "Email"
    txtSignEmail:addEventListener( "userInput", onTxtFocus )
	groupSign:insert(txtSignEmail)
    txtSignPass = native.newTextField( midW + 25, midH + 40, 300, 45 )
    txtSignPass.size = 24
    txtSignPass.method = "signin"
    txtSignPass.isSecure = true
    txtSignPass.hasBackground = false
    txtSignPass.placeholder = "Password"
    txtSignPass:addEventListener( "userInput", onTxtFocus )
	groupSign:insert(txtSignPass)
    
    local txt1 = display.newText( {
        text = "ENTRAR",
        x = midW, y = midH + 120,
        font = fontSemiBold,  fontSize = 24, align = "center"
    })
    groupSign:insert(txt1)
    local txt2 = display.newText( {
        text = "CREAR CUENTA",
        x = midW, y = midH + 200,
        font = fontSemiBold,  fontSize = 24, align = "center"
    })
    groupSign:insert(txt2)
    local txt3 = display.newText( {
        text = "Regresar",
        x = midW - 90, y = midH + 270,
        font = fontSemiBold, fontSize = 20, align = "left"
    })
    groupSign:insert(txt3)
    
    -- Icons
    local icon1 = display.newImage("img/icon/icoEmail.png", true) 
    icon1:translate(midW - 145, midH - 40)
    groupSign:insert(icon1)
    local icon2 = display.newImage("img/icon/iconCandado.png", true) 
    icon2:translate(midW - 145, midH + 40)
    groupSign:insert(icon2)
    local icon3 = display.newImage("img/icon/iconPrev.png", true) 
    icon3:translate(midW - 155, midH + 270)
    groupSign:insert(icon3)
        
    -- Bg TextFields
    local bg7 = display.newRoundedRect( midW, midH - 40, 350, 55, 5 )
	bg7:setFillColor( unpack(cTurquesa) )
	groupCreate:insert(bg7)
    local bg8 = display.newRoundedRect( midW, midH - 40, 344, 51, 5 )
	bg8:setFillColor( unpack(cWhite) )
	groupCreate:insert(bg8)
    local bg9 = display.newRoundedRect( midW, midH + 40, 350, 55, 5 )
	bg9:setFillColor( unpack(cTurquesa) )
	groupCreate:insert(bg9)
    local bg10 = display.newRoundedRect( midW, midH + 40, 350, 51, 5 )
	bg10:setFillColor( unpack(cWhite) )
	groupCreate:insert(bg10)
    local bg11 = display.newRoundedRect( midW, midH + 120, 350, 55, 5 )
	bg11:setFillColor( unpack(cTurquesa) )
	groupCreate:insert(bg11)
    local bg12 = display.newRoundedRect( midW, midH + 120, 350, 51, 5 )
	bg12:setFillColor( unpack(cWhite) )
	groupCreate:insert(bg12)
    local bg13 = display.newRoundedRect( midW, midH + 200, 350, 55, 5 )
	bg13:setFillColor( unpack(cBPur) )
    bg13:addEventListener( "tap", doCreate )
	groupCreate:insert(bg13)
    local btnDoReturn2 = display.newRect( midW - 90, midH + 270, 160, 40 )
    btnDoReturn2.alpha = .01
    btnDoReturn2:addEventListener( "tap", hideCreate )
	groupCreate:insert(btnDoReturn2)
    
    
    -- TextFields Create
    txtCreateEmail = native.newTextField( midW + 25, midH - 40, 300, 45 )
    txtCreateEmail.size = 20
    txtCreateEmail.method = "create"
    txtCreateEmail.inputType = "email"
    txtCreateEmail.hasBackground = false
    txtCreateEmail.placeholder = "Email"
	groupCreate:insert(txtCreateEmail)
    txtCreateEmail:addEventListener( "userInput", onTxtFocus )
    txtCreatePass = native.newTextField( midW + 25, midH + 40, 300, 45 )
    txtCreatePass.size = 20
    txtCreatePass.method = "create"
    txtCreatePass.isSecure = true
    txtCreatePass.hasBackground = false
    txtCreatePass.placeholder = "Password"
	groupCreate:insert(txtCreatePass)
    txtCreatePass:addEventListener( "userInput", onTxtFocus )
    txtCreateRePass = native.newTextField( midW + 25, midH + 120, 300, 45 )
    txtCreateRePass.size = 20
    txtCreateRePass.method = "create"
    txtCreateRePass.isSecure = true
    txtCreateRePass.hasBackground = false
    txtCreateRePass.placeholder = "Repetir Password"
	groupCreate:insert(txtCreateRePass)
    txtCreateRePass:addEventListener( "userInput", onTxtFocus )
    
    -- Text
    local txt2 = display.newText( {
        text = "CREAR CUENTA",
        x = midW, y = midH + 200,
        font = fontSemiBold,  fontSize = 24, align = "center"
    })
    groupCreate:insert(txt2)
    local txt3 = display.newText( {
        text = "Regresar",
        x = midW - 90, y = midH + 270,
        font = fontSemiBold, fontSize = 20, align = "left"
    })
    groupCreate:insert(txt3)
    
    -- Icons
    local icon4 = display.newImage("img/icon/icoEmail.png", true) 
    icon4:translate(midW - 145, midH - 40)
    groupCreate:insert(icon4)
    local icon5 = display.newImage("img/icon/iconCandado.png", true) 
    icon5:translate(midW - 145, midH + 40)
    groupCreate:insert(icon5)
    local icon6 = display.newImage("img/icon/iconCandado.png", true) 
    icon6:translate(midW - 145, midH + 120)
    groupCreate:insert(icon6)
    local icon7 = display.newImage("img/icon/iconPrev.png", true) 
    icon7:translate(midW - 155, midH + 270)
    groupCreate:insert(icon7)
    
    groupCreate.x = 480
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Remove Listener
function scene:hide( event )
    if txtSignEmail then
        txtSignEmail:removeSelf()
        txtSignEmail = nil
    end
    if txtSignPass then
        txtSignPass:removeSelf()
        txtSignPass = nil
    end
    if txtCreateEmail then
        txtCreateEmail:removeSelf()
        txtCreateEmail = nil
    end
    if txtCreatePass then
        txtCreatePass:removeSelf()
        txtCreatePass = nil
    end
    if txtCreateRePass then
        txtCreateRePass:removeSelf()
        txtCreateRePass = nil
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )

    
return scene

