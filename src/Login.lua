---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
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
local bgL = {}
local direction = 0
local idxScr = 1
local bottomLogin, loadLogin


---------------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------------


function toLoginFB()
    Globals.isReadOnly = true
    composer.removeScene( "src.WelcomeHome" )
    composer.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function toLoginUserName(event)
    Globals.isReadOnly = false
    composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function toLoginFree()
    Globals.isReadOnly = true
    composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function insertLoading(isLoading)
    if isLoading then
        bottomLogin.alpha = 0
        loadLogin.alpha = 1
        loadLogin:play()
    else
        bottomLogin.alpha = 1
        loadLogin.alpha = 0
        loadLogin:setSequence("play")
    end
end

function facebookListener( event )
    
    if ( "session" == event.type ) then
		local params = { fields = "id,name,email" }
        facebook.request( "me", "GET", params )
	--resibe los datos pedidos y verifica el loqueo
    elseif ( "request" == event.type ) then
        local response = event.response
		if ( not event.isError ) then
	        response = json.decode( event.response )
			--si devuelve los datos verifica el correo
            email = '-'
            if not (response.email == nil) then
                email = response.email
            end
            --si devuelve los datos verifica el nombre
            name = '-'
            if not (response.name == nil) then
                name = response.name
            end
            -- Inserta en bd
            insertLoading(true)
            RestManager.createUserFB(response.id, name, email)
        else
			-- printTable( event.response, "Post Failed Response", 3 )
		end
    end
end

function loginFB(event)
    facebook.login( facebookListener, {"public_profile", "email"} )
end

function newScr(idx)
    idxScr = idx
    direction = 0
    circles[idx]:setFillColor( 75/255, 176/255, 217/255 )
    if idx > 1 then
        circles[idx-1]:toFront()
        circles[idx-1]:setFillColor( 182/255, 207/255, 229/255 )
    end
    if idx < 4 then
        circles[idx+1]:toFront()
        circles[idx+1]:setFillColor( 182/255, 207/255, 229/255 )
    end
end

-- Listener Touch Screen
function touchScreen(event)
    if event.phase == "began" then
        direction = 0
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart)
        if direction == 0 then
            if x < -10 and idxScr < 4 then
                direction = 1
            elseif x > 10 and idxScr > 1 then
                direction = -1
            end
        elseif direction == 1 then
            -- Mover pantalla
            if x < 0 and x > -240 then
                bgL[idxScr].x = x
                bgL[idxScr + 1].x = x + intW
            end
        elseif direction == -1 then
            if x > 0 and x < 240 then
                if idxScr == 2 then
                    bgL[idxScr].x = x
                    bgL[idxScr - 1].x = (-intW) + x
                    print(intW + x)
                end
            end
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        
        local x = (event.x - event.xStart)
        -- Next Screen
        if direction == 1 then
            if x > -200 then 
                -- Cancel
                transition.to( bgL[idxScr], { x = 0, time = 200 })
                transition.to( bgL[idxScr+1], { x = intW, time = 200 })
            else 
                -- Do
                transition.to( bgL[idxScr], { x = -intW, time = 200 })
                transition.to( bgL[idxScr+1], { x = 0, time = 200 })
                newScr(idxScr+1)
            end
        end
        -- Previous Screen 
        if direction == -1 then
            if x < 200 then 
                -- Cancel
                transition.to( bgL[idxScr], { x = 0, time = 200 })
                transition.to( bgL[idxScr-1], { x = -intW, time = 200 })
            else 
                -- Do
                transition.to( bgL[idxScr], { x = intW, time = 200 })
                transition.to( bgL[idxScr-1], { x = 0, time = 200 })
                newScr(idxScr-1)
            end
        end
    end
end


---------------------------------------------------------------------------------
-- OVERRIDING SCENES METHODS
--------------------------------------------------------------- ------------------
-- Called when the scene's view does not exist:
function scene:create( event )

    -- Agregamos el home
	screen = self.view
    local curBG = cTurquesa
    
    local bg = display.newRect( midW, h, intW, intH - h )
    bg.anchorY = 0
    bg:setFillColor( unpack(cBlueH) )
    screen:insert(bg)

    -- Circles position
    for i = 1, 4 do
        if curBG == cTurquesa then curBG = cTurquesaL else curBG = cTurquesa end
        bgL[i] = display.newRect( (intW * (i-1)), h, intW, intH - h - 150 )
        bgL[i].anchorX = 0
        bgL[i].anchorY = 0
        bgL[i]:setFillColor( unpack(curBG) )
        screen:insert(bgL[i])
        
        circles[i] = display.newRoundedRect( 165 + (i * 25), intH - 170, 15, 15, 8 )
        circles[i]:setFillColor( 182/255, 207/255, 229/255 )
        screen:insert(circles[i])
    end
    circles[1]:setFillColor( 75/255, 176/255, 217/255 )
    
    bottomLogin = display.newGroup()
    screen:insert(bottomLogin)
    
    -- Btn FB
    local bgBtn = display.newRect( midW, intH - 100, 354, 59 )
	bgBtn:setFillColor( unpack(cWhite) )
	bottomLogin:insert(bgBtn)
    
    local btn = display.newRect( midW, intH - 100, 350, 55 )
	btn:setFillColor( 39/255, 69/255, 132/255 )
    btn:addEventListener( "tap", loginFB )
	bottomLogin:insert(btn)
    
    local btn = display.newRect( midW+35, intH - 100, 280, 55 )
	btn:setFillColor( 59/255, 89/255, 152/255 )
    btn:addEventListener( "tap", loginFB )
	bottomLogin:insert(btn)
    
    local iconFB = display.newImage("img/icon/iconFB.png")
    iconFB:translate(midW - 140, intH - 100)
    bottomLogin:insert( iconFB )
    
    local lblBtn = display.newText( {
        text = "Ingresar con FACEBOOK",
        x = midW + 35, y = intH - 100,
        font = fLatoBold,  
        fontSize = 20, align = "center"
    })
	lblBtn:setFillColor( unpack(cWhite) )
    bottomLogin:insert(lblBtn)
    
    -- User / Email
    local bgBtnUserName = display.newRect( 140, intH - 30, 160, 50 )
	bgBtnUserName:setFillColor( 1 )
    bgBtnUserName.alpha = .01
    bgBtnUserName:addEventListener( "tap", toLoginUserName )
	bottomLogin:insert(bgBtnUserName)
    
    local lblBottom = display.newText( {
        text = "INGRESA CON USERNAME Ó EMAIL",
        x = 140, y = intH - 30,
        font = fLatoBold,  
        width = 160,
        fontSize = 14, align = "center"
    })
    lblBottom:setFillColor( unpack(cWhite) )
    bottomLogin:insert(lblBottom)
    
    local lineSep = display.newRect( midW, intH - 30, 2, 20 )
	lineSep:setFillColor( .6 )
	bottomLogin:insert(lineSep)
    
    -- Recorrido
    local bgBtnFree = display.newRect( 340, intH - 30, 160, 50 )
	bgBtnFree:setFillColor( 1 )
    bgBtnFree.alpha = .01
    bgBtnFree:addEventListener( "tap", toLoginFree )
	bottomLogin:insert(bgBtnFree)
    
    local lblFree = display.newText( {
        text = "CONOCE MÁS DE LA APLICACIÓN",
        x = 340, y = intH - 30,
        font = fLatoBold,  
        width = 160,
        fontSize = 14, align = "center"
    })
    lblFree:setFillColor( unpack(cWhite) )
    bottomLogin:insert(lblFree)
    
    --
    local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
    loadLogin = display.newSprite(sheet, Sprites.loading.sequences)
    loadLogin.x = midW
    loadLogin.y = intH - 100
    screen:insert(loadLogin)
    loadLogin:setSequence("play")
    loadLogin.alpha = 0
    
    -- Touch Listener
    screen:addEventListener( "touch", touchScreen )
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Remove Listener
function scene:destroy( event )
    screen:removeEventListener( "touch", touchScreen )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

    
return scene

