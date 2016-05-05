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


---------------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------------


function toLoginFB(isWelcome)
    local scrLogin = "src.Home"
    if isWelcome then
        scrLogin = "src.WelcomeHome"
    end
    Globals.isReadOnly = true
    reloadConfig()
    composer.removeScene( scrLogin )
    composer.gotoScene( scrLogin, { time = 400, effect = "crossFade" })
end

function toLoginUserName(event)
    Globals.isReadOnly = false
    composer.removeScene( "src.NewAccount" )
    composer.gotoScene( "src.NewAccount", { time = 400, effect = "crossFade" })
end

function toLoginFree()
    Globals.isReadOnly = true
    composer.removeScene( "src.Home" )
    composer.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function insertLoading(isLoading)
    if isLoading then
        bottomLogin.alpha = .7
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
	   -- recibe los datos pedidos y verifica el loqueo
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
                grpSplash[idxScr].x = x
                grpSplash[idxScr + 1].x = x + intW
            end
        elseif direction == -1 then
            if x > 0 and x < 240 then
                grpSplash[idxScr].x = x
                grpSplash[idxScr - 1].x = (-intW) + x
            end
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        
        local x = (event.x - event.xStart)
        -- Next Screen
        if direction == 1 then
            if x > -200 then 
                -- Cancel
                transition.to( grpSplash[idxScr], { x = 0, time = 200 })
                transition.to( grpSplash[idxScr+1], { x = intW, time = 200 })
            else 
                -- Do
                transition.to( grpSplash[idxScr], { x = -intW, time = 200 })
                transition.to( grpSplash[idxScr+1], { x = 0, time = 200 })
                newScr(idxScr+1)
            end
        end
        -- Previous Screen 
        if direction == -1 then
            if x < 200 then 
                -- Cancel
                transition.to( grpSplash[idxScr], { x = 0, time = 200 })
                transition.to( grpSplash[idxScr-1], { x = -intW, time = 200 })
            else 
                -- Do
                transition.to( grpSplash[idxScr], { x = intW, time = 200 })
                transition.to( grpSplash[idxScr-1], { x = 0, time = 200 })
                newScr(idxScr-1)
            end
        end
    end
end

function getSplash(i, parent, posY, postFix)
    
    if i == 1 then
        local lbl1 = display.newText( {
            text = "BIENVENIDO A:",
            x = midW, y = midH + posY[i][1],
            font = fLatoBold,
            fontSize = 55, align = "center"
        })
        lbl1:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl1)
        
        local lbl2 = display.newText( {
            text = "¡Los Programas de Lealtad de tus",
            x = midW, y = midH + posY[i][2],
            font = fLatoRegular,  width = 400,
            fontSize = 34, align = "center"
        })
        lbl2:setFillColor( unpack(cBlueH) )
        parent:insert(lbl2)
        
        local lbl3 = display.newText( {
            text = "COMERCIOS FAVORITOS!",
            x = midW, y = midH + posY[i][3],
            font = fLatoBold,  
            fontSize = 35, align = "center"
        })
        lbl3:setFillColor( unpack(cBlueH) )
        parent:insert(lbl3)
        
        local img1 = display.newImage("img/deco/splash1.png")
        img1:translate(midW, midH + posY[i][4])
        parent:insert( img1 )
        
    elseif i == 2 then
        local lbl1 = display.newText( {
            text = "Afíliate",
            x = midW, y = intH - posY[i][1],
            font = fLatoBold,  
            fontSize = 60, align = "center"
        })
        lbl1:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl1)
        
        local lbl2 = display.newText( {
            text = "A tus COMERCIOS FAVORITOS",
            x = midW, y = intH - posY[i][2],
            font = fLatoBold, 
            fontSize = 28, align = "center"
        })
        lbl2:setFillColor( unpack(cBlueH) )
        parent:insert(lbl2)
        
        local img1 = display.newImage("img/deco/splash2"..postFix..".png")
        img1.anchorY = 1
        img1:translate(midW, intH - posY[i][3])
        parent:insert( img1 )
        
    elseif i == 3 then
        local bg1 = display.newRect( intW, intH - posY[i][1], 300, 100 )
        bg1.anchorX = 1
        bg1:setFillColor( unpack(cTurquesa) )
        parent:insert(bg1)

        local bg2 = display.newRect( intW, intH - posY[i][2], 300, 100 )
        bg2.anchorX = 1
        bg2:setFillColor( unpack(cPurpleL) )
        parent:insert(bg2)

        local lbl1 = display.newText( {
            text = "VISITA",
            x = 350, y = intH - posY[i][3],
            font = fLatoBold,  
            fontSize = 50, align = "center"
        })
        lbl1:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl1)

        local lbl2 = display.newText( {
            text = "Comercios Afiliados",
            x = 350, y = intH - posY[i][4],
            font = fLatoBold, 
            fontSize = 26, align = "center"
        })
        lbl2:setFillColor( unpack(cTurquesa) )
        parent:insert(lbl2)

        local lbl3 = display.newText( {
            text = "REALIZA",
            x = 350, y = intH - posY[i][5],
            font = fLatoBold,  
            fontSize = 30, align = "center"
        })
        lbl3:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl3)

        local lbl4 = display.newText( {
            text = "CHECK IN",
            x = 350, y = intH - posY[i][6],
            font = fLatoBold, 
            fontSize = 50, align = "center"
        })
        lbl4:setFillColor( unpack(cWhite) )
        parent:insert(lbl4)

        local lbl5 = display.newText( {
            text = "SUMA",
            x = 350, y = intH - posY[i][7],
            font = fLatoBold, 
            fontSize = 65, align = "center"
        })
        lbl5:setFillColor( unpack(cWhite) )
        parent:insert(lbl5)

        local lbl6 = display.newText( {
            text = "PUNTOS",
            x = 350, y = intH - posY[i][8],
            font = fLatoBold, 
            fontSize = 48, align = "center"
        })
        lbl6:setFillColor( unpack(cWhite) )
        parent:insert(lbl6)
        
        local img1 = display.newImage("img/deco/splash3"..postFix..".png")
        img1.anchorY = 1
        img1:translate(120, intH - posY[i][9])
        parent:insert( img1 )
        
        local x = 85
        if postFix == "" then x = 75 end
        local img2 = display.newImage("img/deco/splash4"..postFix..".png")
        img2.anchorX = 0
        img2.anchorY = 1
        img2:translate(x, intH - posY[i][10])
        parent:insert( img2 )
        
    elseif i == 4 then
        local bg1 = display.newRect( 0, midH + posY[i][1], 300, 100 )
        bg1.anchorX = 0
        bg1:setFillColor( unpack(cPurpleL) )
        parent:insert(bg1)

        local bg2 = display.newRect( midW, midH + posY[i][2], intW, 100 )
        bg2:setFillColor( unpack(cTurquesa) )
        parent:insert(bg2)

        local lbl1 = display.newText( {
            text = "CANJEA",
            x = 120, y = midH + posY[i][3],
            font = fLatoBold,  
            fontSize = 50, align = "center"
        })
        lbl1:setFillColor( unpack(cWhite) )
        parent:insert(lbl1)

        local lbl2 = display.newText( {
            text = "PUNTOS",
            x = 120, y = midH + posY[i][4],
            font = fLatoBold, 
            fontSize = 47, align = "center"
        })
        lbl2:setFillColor( unpack(cWhite) )
        parent:insert(lbl2)

        local lbl3 = display.newText( {
            text = "¡Por",
            x = 370, y = midH + posY[i][5],
            font = fLatoBold, width = 250,
            fontSize = 25, align = "left"
        })
        lbl3:setFillColor( unpack(cWhite) )
        parent:insert(lbl3)

        local lbl4 = display.newText( {
            text = "Recompensas!",
            x = 370, y = midH + posY[i][6],
            font = fLatoBold, width = 250,
            fontSize = 35, align = "left"
        })
        lbl4:setFillColor( unpack(cWhite) )
        parent:insert(lbl4)
        
        local img1 = display.newImage("img/deco/splash5.png")
        img1.anchorX = 0
        img1:translate(0, midH + posY[i][7])
        parent:insert( img1 )
        
        local img2 = display.newImage("img/deco/splash6.png")
        img2:translate(360, midH + posY[i][8])
        parent:insert( img2 )
    end
end


---------------------------------------------------------------------------------
-- OVERRIDING SCENES METHODS
--------------------------------------------------------------- ------------------
-- Called when the scene's view does not exist:
function scene:create( event )

    -- Agregamos el home
	screen = self.view
    local posY
    local curBG = .9
    
    -- Posiciones de los elementos segun ratio
    local postFix = ""
    if intH > 840 then
        posY = {{-300, 30, 95, -140}, { 690, 650, 100}, { 550, 450, 660, 620, 570, 535, 470, 425, 270, 100}, { -160, 40, -180, -140, 15, 45, 50, -158}}
    elseif intH > 750 then
        posY = {{-250, 30, 95, -120}, { 690, 650, 100}, { 550, 450, 660, 620, 570, 535, 470, 425, 270, 100}, { -160, 40, -180, -140, 15, 45, 50, -160}}    
    else
        postFix = ".s"
        posY = {{-230, 0, 65, -120}, { 585, 545, 100}, { 450, 350, 560, 520, 470, 435, 370, 325, 225, 100}, { -160, 40, -180, -140, 15, 45, 50, -160}}
    end
    
    -- Circles position
    for i = 1, 4 do
        grpSplash[i] = display.newGroup()
        grpSplash[i].x = (intW * (i-1))
        screen:insert(grpSplash[i])
        
        if curBG == .9 then curBG = .95 else curBG = .9 end
        bg = display.newRect( midW, h, intW, intH - h - 150 )
        bg.anchorY = 0
        bg:setFillColor( curBG )
        grpSplash[i]:insert(bg)
        
        local bgImg = "bgSplashL.png"
        if i == 2 or i == 4 then
            bgImg = "bgSplashR.png"
        end
        local bgSplash = display.newImage("img/deco/"..bgImg)
        bgSplash.y = h
        bgSplash.anchorX = 0
        bgSplash.anchorY = 0
        grpSplash[i]:insert( bgSplash )
        
        getSplash(i, grpSplash[i], posY, postFix)
        
        circles[i] = display.newRoundedRect( 165 + (i * 25), intH - 170, 15, 15, 8 )
        circles[i]:setFillColor( 182/255, 207/255, 229/255 )
        screen:insert(circles[i])
    end
    circles[1]:setFillColor( 75/255, 176/255, 217/255 )
    
    bottomLogin = display.newGroup()
    screen:insert(bottomLogin)
    
    local bg = display.newRect( midW, intH, intW, 150 )
    bg.anchorY = 1
    bg:setFillColor( unpack(cBlueH) )
    bottomLogin:insert(bg)
    
    -- Btn FB
    local bgBtn = display.newRect( midW, intH - 100, 354, 59 )
	bgBtn:setFillColor( unpack(cWhite) )
	bottomLogin:insert(bgBtn)
    
    local btn = display.newRect( midW, intH - 100, 350, 55 )
	btn:setFillColor( 39/255, 69/255, 132/255 )
    btn:addEventListener( "tap", loginFB )
	bottomLogin:insert(btn)
    
    local btn1 = display.newRect( midW+35, intH - 100, 280, 55 )
	btn1:setFillColor( 59/255, 89/255, 152/255 )
	bottomLogin:insert(btn1)
    
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
    local bgBtnUserName = display.newRect( midW, intH - 30, 260, 50 )
	bgBtnUserName:setFillColor( 1 )
    bgBtnUserName.alpha = .01
    bgBtnUserName:addEventListener( "tap", toLoginUserName )
	bottomLogin:insert(bgBtnUserName)
    
    local lblBottom = display.newText( {
        text = "INGRESA CON USERNAME Ó EMAIL",
        x = midW, y = intH - 35, font = fLatoBold,
        fontSize = 14, align = "center"
    })
    lblBottom:setFillColor( unpack(cWhite) )
    bottomLogin:insert(lblBottom)
    
    local lineSep = display.newRect( midW, intH - 20, 260, 2 )
	lineSep:setFillColor( .6 )
	bottomLogin:insert(lineSep)
    
    --
    local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
    loadLogin = display.newSprite(sheet, Sprites.loading.sequences)
    loadLogin.x = midW
    loadLogin.y = intH - 100
    screen:insert(loadLogin)
    loadLogin:setSequence("play")
    loadLogin.alpha = 0
    
    -- Clear Menu
    if Globals.menu then
        Globals.menu:removeSelf()
        Globals.menu = nil
    end
    
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

