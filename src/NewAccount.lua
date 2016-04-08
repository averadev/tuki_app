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
            transition.to( imgLogo, { y = 80 + h, time = 400, transition = easing.outExpo } )
            transition.to( groupSign, { y = (-midH + 250) + h, time = 400, transition = easing.outExpo } )
        -- Interfaz Create
        elseif groupCreate.x == 0 and groupCreate.y == 0 then
            transition.to( imgLogo, { y = 80 + h, time = 400, transition = easing.outExpo } )
            transition.to( groupCreate, { y = (-midH + 275) + h, time = 400, transition = easing.outExpo } )
        end
    elseif ( "submitted" == event.phase ) then
        -- Hide Keyboard
        native.setKeyboardFocus(nil)
        if event.target.method == "create" then
            doCreate()
        else
            doSignIn()
        end
    end
end

function getReturnSplash(event)
    composer.removeScene( "src.Login" )
    composer.gotoScene( "src.Login", { time = 400, effect = "crossFade" })
end 

function backTxtPositions()
    -- Hide Keyboard
    native.setKeyboardFocus(nil)
    -- Interfaz Sign In
    if groupSign.x == 0 and groupSign.y < 0 then
        transition.to( imgLogo, { y = midH / 2, time = 400, transition = easing.outExpo } )
        transition.to( groupSign, { y = 0, time = 400, transition = easing.outExpo } )
    -- Interfaz Create
    elseif groupCreate.x == 0 and groupCreate.y < 0 then
        transition.to( imgLogo, { y = midH / 2, time = 400, transition = easing.outExpo } )
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
        RestManager.createUser(txtCreateEmail.text, txtCreatePass.text)
    end
end

function doSignIn()
    if txtSignEmail.text == '' or txtSignPass.text == '' then
        native.showAlert( "TUKI", 'El email y password son necesarios.', { "OK"})
    else
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
    
    local bg = display.newRect( midW, h, intW, intH - h )
    bg.anchorY = 0
    bg:setFillColor( .95 )
    screen:insert(bg)
    
    local bgSplash = display.newImage("img/deco/bgSplashTall.png")
    bgSplash.y = h
    bgSplash.x = midW
    bgSplash.anchorY = 0
    screen:insert( bgSplash )
        
    imgLogo = display.newImage("img/deco/splash1.png", true) 
	imgLogo.x = midW
	imgLogo.y = midH / 2
	screen:insert(imgLogo)
    
    -- Groups
    groupSign = display.newGroup()
	screen:insert(groupSign)
    groupCreate = display.newGroup()
	screen:insert(groupCreate)

    -- Bg TextFields
    local bgSignEmail = display.newImage("img/deco/usuario.png", true) 
    bgSignEmail.x = midW
    bgSignEmail.y = midH - 45
    groupSign:insert(bgSignEmail)
    local bgSignPass = display.newImage("img/deco/contrasenia.png", true) 
    bgSignPass.x = midW
    bgSignPass.y = midH + 45
    groupSign:insert(bgSignPass)
    
    -- TextFields Sign In
    txtSignEmail = native.newTextField( midW + 25, midH - 45, 300, 45 )
    txtSignEmail.size = 20
    txtSignEmail.method = "signin"
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
    txtSignEmail.placeholder = "Email"
    txtSignEmail:addEventListener( "userInput", onTxtFocus )
	groupSign:insert(txtSignEmail)
    txtSignPass = native.newTextField( midW + 25, midH + 45, 300, 45 )
    txtSignPass.size = 20
    txtSignPass.method = "signin"
    txtSignPass.isSecure = true
    txtSignPass.hasBackground = false
    txtSignPass.placeholder = "Password"
    txtSignPass:addEventListener( "userInput", onTxtFocus )
	groupSign:insert(txtSignPass)
    
    local bgBtn = display.newRoundedRect( midW, midH + 130, 350, 55, 10 )
	bgBtn:setFillColor( 0 )
	groupSign:insert(bgBtn)
    local btn = display.newRoundedRect( midW, midH + 130, 348, 53, 10 )
	btn:setFillColor( unpack(cPurple) )
    btn:addEventListener( "tap", doSignIn )
	groupSign:insert(btn)
    
    local txtDoSignIn = display.newText( {
        text = "Ingresar",
        x = midW, y = midH + 130,
        font = "Lato",  fontSize = 24, align = "center"
    })
    groupSign:insert(txtDoSignIn)
    
    local btnDoReturn = display.newRoundedRect( midW - 100, midH + 215, 150, 50, 10 )
	btnDoReturn:setFillColor( 0, 51/255, 86/255 )
    btnDoReturn.alpha = .3
    btnDoReturn:addEventListener( "tap", getReturnSplash )
	groupSign:insert(btnDoReturn)
    local txtDoReturn = display.newText( {
        text = "Regresar",
        x = midW - 100, y = midH + 215,
        font = "Lato",  fontSize = 20, align = "left"
    })
    groupSign:insert(txtDoReturn)
    
    local btnDoCreateIt = display.newRoundedRect( midW + 100, midH + 215, 150, 50, 10 )
	btnDoCreateIt:setFillColor( 0, 51/255, 86/255 )
    btnDoCreateIt.alpha = .3
    btnDoCreateIt:addEventListener( "tap", showCreate )
	groupSign:insert(btnDoCreateIt)
    local txtDoCreateIt = display.newText( {
        text = "Crear Cuenta",
        x = midW + 100, y = midH + 215,
        font = "Lato",  fontSize = 20, align = "right"
    })
    groupSign:insert(txtDoCreateIt)
        
    -- Bg TextFields
    local bgCreateEmail = display.newImage("img/deco/usuario.png", true) 
    bgCreateEmail.x = midW
    bgCreateEmail.y = midH - 75
    groupCreate:insert(bgCreateEmail)
    local bgCreatePass = display.newImage("img/deco/contrasenia.png", true) 
    bgCreatePass.x = midW
    bgCreatePass.y = midH + 05
    groupCreate:insert(bgCreatePass)
    local bgCreateRePass = display.newImage("img/deco/contrasenia.png", true) 
    bgCreateRePass.x = midW
    bgCreateRePass.y = midH + 85
    groupCreate:insert(bgCreateRePass)
    
    -- TextFields Create
    txtCreateEmail = native.newTextField( midW + 25, midH - 75, 300, 45 )
    txtCreateEmail.size = 20
    txtCreateEmail.method = "create"
    txtCreateEmail.inputType = "email"
    txtCreateEmail.hasBackground = false
    txtCreateEmail.placeholder = "Email"
	groupCreate:insert(txtCreateEmail)
    txtCreateEmail:addEventListener( "userInput", onTxtFocus )
    txtCreatePass = native.newTextField( midW + 25, midH + 05, 300, 45 )
    txtCreatePass.size = 20
    txtCreatePass.method = "create"
    txtCreatePass.isSecure = true
    txtCreatePass.hasBackground = false
    txtCreatePass.placeholder = "Password"
	groupCreate:insert(txtCreatePass)
    txtCreatePass:addEventListener( "userInput", onTxtFocus )
    txtCreateRePass = native.newTextField( midW + 25, midH + 85, 300, 45 )
    txtCreateRePass.size = 20
    txtCreateRePass.method = "create"
    txtCreateRePass.isSecure = true
    txtCreateRePass.hasBackground = false
    txtCreateRePass.placeholder = "Repetir Password"
	groupCreate:insert(txtCreateRePass)
    txtCreateRePass:addEventListener( "userInput", onTxtFocus )
    
    local bgBtn2 = display.newRoundedRect( midW, midH + 170, 350, 55, 10 )
	bgBtn2:setFillColor( 0 )
	groupCreate:insert(bgBtn2)
    local btn2 = display.newRoundedRect( midW, midH + 170, 348, 53, 10 )
	btn2:setFillColor( unpack(cPurple) )
    btn2:addEventListener( "tap", doCreate )
	groupCreate:insert(btn2)
    
    local txtDoSignIn2 = display.newText( {
        text = "Crear Cuenta",
        x = midW, y = midH + 170,
        font = "Lato",  fontSize = 24, align = "center"
    })
    groupCreate:insert(txtDoSignIn2)
    
    local btnDoReturn2 = display.newRoundedRect(  midW - 100, midH + 250, 150, 50, 10 )
	btnDoReturn2:setFillColor( 0, 51/255, 86/255 )
    btnDoReturn2.alpha = .3
    btnDoReturn2:addEventListener( "tap", hideCreate )
	groupCreate:insert(btnDoReturn2)
    local txtDoReturn2 = display.newText( {
        text = "Regresar",
        x = midW - 100, y = midH + 250,
        font = "Lato",  fontSize = 20, align = "left"
    })
    groupCreate:insert(txtDoReturn2)
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

