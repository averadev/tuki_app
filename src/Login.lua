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
local widget = require( "widget" )
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
local bottomLogin, loadLogin, grpTerminos


---------------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------------


function toLoginFB(isWelcome)
    local scrLogin = "src.Home"
    if isWelcome then
        if locIdCity == 0 or locIdCity == '0' then
            scrLogin = "src."
        else
            RestManager.setCity(locIdCity)
            scrLogin = "src.WelcomeHome"
        end
    else
        DBManager.updateAfiliated(1)
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

function closeTerminos(event)
    if grpTerminos then
        grpTerminos:removeSelf()
        grpTerminos = nil;
    end
end

function toTerminos()
    if grpTerminos then
        grpTerminos:removeSelf()
        grpTerminos = nil;
    end
    grpTerminos = display.newGroup()
    screen:insert(grpTerminos)
    
    function setDes(event)
        return true
    end
    local bg = display.newRect(midW, midH, intW, intH )
    bg.alpha = .5
    bg:setFillColor( 0 )
    bg:addEventListener( 'tap', setDes )
    grpTerminos:insert(bg)
    
    local bg1 = display.newRoundedRect(midW, midH, 410, 440, 5 )
    bg1:setFillColor( unpack(cTurquesa) )
    grpTerminos:insert(bg1)
    
    local bg2 = display.newRoundedRect(midW, midH, 404, 434, 5 )
    bg2:setFillColor( unpack(cWhite) )
    grpTerminos:insert(bg2)
    
    local iconClose = display.newImage("img/icon/iconClose.png")
    iconClose:translate(midW + 180, midH - 195)
    iconClose:addEventListener( 'tap', closeTerminos )
    grpTerminos:insert( iconClose )
    
    local scrViewTerminos = widget.newScrollView{
		width = 400,
		height = 390,
		horizontalScrollDisabled = true
	}
    scrViewTerminos.x = midW
    scrViewTerminos.y = midH + 10
	grpTerminos:insert(scrViewTerminos)
    
    local lblTerm = display.newText( {
        text = "Tuki Términos y Condiciones",
        x = 200, y = 5,
        font = fontBold, width = 370,
        fontSize = 20, align = "left"
    })
    lblTerm.anchorY = 0
    lblTerm:setFillColor( unpack(cPurpleL) )
    scrViewTerminos:insert(lblTerm)
    
    local yPosc = 40
    for z = 1, #tukiTerminos, 1 do 
        
         local lblTermX = display.newText( {
            text = tukiTerminos[z],
            x = 200, y = yPosc,
            font = fontRegular, width = 370,
            fontSize = 13, align = "left"
        })
        lblTermX.anchorY = 0
        lblTermX:setFillColor( unpack(cPurpleL) )
        scrViewTerminos:insert(lblTermX)
        
        yPosc = yPosc + lblTermX.height + 15
        
    end
    yPosc = yPosc + 10
    
    local lblTerm = display.newText( {
        text = "Tuki Aviso de Privacidad",
        x = 200, y = yPosc,
        font = fontBold, width = 370,
        fontSize = 20, align = "left"
    })
    lblTerm.anchorY = 0
    lblTerm:setFillColor( unpack(cPurpleL) )
    scrViewTerminos:insert(lblTerm)
    
    yPosc = yPosc + 30
    for z = 1, #tukiPrivacidad, 1 do 
        
         local lblTermX = display.newText( {
            text = tukiPrivacidad[z],
            x = 200, y = yPosc,
            font = fontRegular, width = 370,
            fontSize = 13, align = "left"
        })
        lblTermX.anchorY = 0
        lblTermX:setFillColor( unpack(cPurpleL) )
        scrViewTerminos:insert(lblTermX)
        
        yPosc = yPosc + lblTermX.height + 15
        
    end
    
    scrViewTerminos:setScrollHeight(yPosc)
    
    return true
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

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
 

function facebookListener( event )
    
    if ( "session" == event.type ) then
		local params = { fields  = "id,name,first_name,last_name,age_range,gender,locale,timezone,email"}
        
        facebook.request( "me", "GET", params )
	   -- recibe los datos pedidos y verifica el loqueo
    elseif ( "request" == event.type ) then
        local response = event.response
		if ( not event.isError ) then
	        response = json.decode( event.response )
			--Init data
            fbName = ''
            fbFirstName = ''
            fbLastName = ''
            fbAgeMin = ''
            fbAgeMax = ''
            fbGender = ''
            fbLocale = ''
            fbTimezone = ''
            fbEmail = ''
            -- Validate data
            if not (response.name == nil) then fbName = response.name end
            if not (response.first_name == nil) then fbFirstName = response.first_name end
            if not (response.last_name == nil) then fbLastName = response.last_name end
            if response.age_range then 
                if response.age_range.min then fbAgeMin = response.age_range.min end
            end
            if response.age_range then 
                if response.age_range.max then fbAgeMax = response.age_range.max end
            end
            if not (response.gender == nil) then fbGender = response.gender end
            if not (response.locale == nil) then fbLocale = response.locale end
            if not (response.timezone == nil) then fbTimezone = response.timezone end
            if not (response.email == nil) then fbEmail = response.email end
            -- Inserta en bd
            insertLoading(true)
            RestManager.createUserFB(response.id, fbName, fbFirstName, fbLastName, 
                fbAgeMin, fbAgeMax, fbGender, fbLocale, fbTimezone, fbEmail)
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
            font = fontBold,
            fontSize = 55, align = "center"
        })
        lbl1:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl1)
        
        local lbl2 = display.newText( {
            text = "¡Los Programas de Lealtad de tus",
            x = midW, y = midH + posY[i][2],
            font = fontRegular,  width = 400,
            fontSize = 34, align = "center"
        })
        lbl2:setFillColor( unpack(cBlueH) )
        parent:insert(lbl2)
        
        local lbl3 = display.newText( {
            text = "COMERCIOS FAVORITOS!",
            x = midW, y = midH + posY[i][3],
            font = fontBold,  
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
            font = fontBold,  
            fontSize = 60, align = "center"
        })
        lbl1:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl1)
        
        local lbl2 = display.newText( {
            text = "A tus COMERCIOS FAVORITOS",
            x = midW, y = intH - posY[i][2],
            font = fontBold, 
            fontSize = 28, align = "center"
        })
        lbl2:setFillColor( unpack(cPurpleL) )
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
            font = fontBold,  
            fontSize = 50, align = "center"
        })
        lbl1:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl1)

        local lbl2 = display.newText( {
            text = "Comercios Afiliados",
            x = 350, y = intH - posY[i][4],
            font = fontBold, 
            fontSize = 26, align = "center"
        })
        lbl2:setFillColor( unpack(cTurquesa) )
        parent:insert(lbl2)

        local lbl3 = display.newText( {
            text = "REALIZA",
            x = 350, y = intH - posY[i][5],
            font = fontBold,  
            fontSize = 30, align = "center"
        })
        lbl3:setFillColor( unpack(cPurpleL) )
        parent:insert(lbl3)

        local lbl4 = display.newText( {
            text = "CHECK IN",
            x = 350, y = intH - posY[i][6],
            font = fontBold, 
            fontSize = 50, align = "center"
        })
        lbl4:setFillColor( unpack(cWhite) )
        parent:insert(lbl4)

        local lbl5 = display.newText( {
            text = "SUMA",
            x = 350, y = intH - posY[i][7],
            font = fontBold, 
            fontSize = 65, align = "center"
        })
        lbl5:setFillColor( unpack(cWhite) )
        parent:insert(lbl5)

        local lbl6 = display.newText( {
            text = "PUNTOS",
            x = 350, y = intH - posY[i][8],
            font = fontBold, 
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
        
        
        local img2 = display.newImage("img/deco/splash6.png")
        img2:translate(midW, midH - 110)
        parent:insert( img2 )

        local bg2 = display.newRect( midW, midH + posY[i][2], intW, 100 )
        bg2:setFillColor( unpack(cTurquesa) )
        parent:insert(bg2)

        local lbl1 = display.newText( {
            text = "CANJEA",
            x = midW-80, y = midH - 275,
            font = fontSemiBold,  
            fontSize = 35, align = "center"
        })
        lbl1:setFillColor( unpack(cTurquesa) )
        parent:insert(lbl1)

        local lbl2 = display.newText( {
            text = "PUNTOS",
            x = midW+80, y = midH - 275,
            font = fontBold, 
            fontSize = 40, align = "center"
        })
        lbl2:setFillColor( unpack(cTurquesa) )
        parent:insert(lbl2)

        local lbl3 = display.newText( {
            text = "¡Por",
            x = 425, y = midH + 30,
            font = fontBold, width = 250,
            fontSize = 24, align = "left"
        })
        lbl3:setFillColor( unpack(cWhite) )
        parent:insert(lbl3)

        local lbl4 = display.newText( {
            text = "Recompensas!",
            x = 425, y = midH + 55,
            font = fontBold, width = 250,
            fontSize = 24, align = "left"
        })
        lbl4:setFillColor( unpack(cWhite) )
        parent:insert(lbl4)
        
        local img1 = display.newImage("img/deco/splash5.png")
        img1.anchorX = 0
        img1:translate(0, midH + posY[i][7])
        parent:insert( img1 )
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
    
    -- Posiciones de los elementos segun ratio
    local postFix = ""
    if intH > 840 then
        posY = {{-300, 30, 95, -140}, { 710, 670, 100}, { 550, 450, 660, 620, 570, 535, 470, 425, 270, 55}, { -160, 40, -180, -140, 15, 45, 50, -158}}
    elseif intH > 750 then
        posY = {{-250, 30, 95, -120}, { 710, 670, 100}, { 550, 450, 660, 620, 570, 535, 470, 425, 270, 55}, { -160, 40, -180, -140, 15, 45, 50, -160}}    
    else
        postFix = ".s"
        posY = {{-230, 0, 65, -120}, { 585, 545, 100}, { 450, 350, 560, 520, 470, 435, 370, 325, 225, 55}, { -160, 40, -180, -140, 15, 45, 50, -160}}
    end
    
    -- Circles position
    for i = 1, 4 do
        grpSplash[i] = display.newGroup()
        grpSplash[i].x = (intW * (i-1))
        screen:insert(grpSplash[i])
        
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
    bg:setFillColor( {
        type = 'gradient',
        color1 = { unpack(cBTur) }, 
        color2 = { unpack(cBBlu) },
        direction = "top"
    } )
    bottomLogin:insert(bg)
    
    -- Btn FB
    local btnFB = display.newImage("img/deco/btnFacebook.png")
    btnFB:addEventListener( "tap", loginFB )
    btnFB:translate(midW, intH - 90)
    bottomLogin:insert( btnFB )
    
    -- Terminos
    local bgBtnTerminos = display.newRect( 150, intH - 30, 200, 50 )
	bgBtnTerminos:setFillColor( .5 )
    bgBtnTerminos.alpha = .01
    bgBtnTerminos:addEventListener( "tap", toTerminos )
	bottomLogin:insert(bgBtnTerminos)
    
    local lblTerminos = display.newText( {
        text = "TERMINOS Y CONDICIONES AVISO DE PRIVACIDAD",
        x = 150, y = intH - 33, 
        font = fontBold, width = 190,
        fontSize = 14, align = "right"
    })
    lblTerminos:setFillColor( unpack(cWhite) )
    bottomLogin:insert(lblTerminos)
    
    -- User / Email
    local bgBtnUserName = display.newRect( 355, intH - 30, 150, 50 )
	bgBtnUserName:setFillColor( .5 )
    bgBtnUserName.alpha = .01
    bgBtnUserName:addEventListener( "tap", toLoginUserName )
	bottomLogin:insert(bgBtnUserName)
    
    local lblUserName = display.newText( {
        text = "INGRESA CON USERNAME Ó EMAIL",
        x = 370, y = intH - 33, 
        font = fontBold, width = 170,
        fontSize = 14, align = "left"
    })
    lblUserName:setFillColor( unpack(cWhite) )
    bottomLogin:insert(lblUserName)
    
    local lineSep = display.newRect( midW + 25, intH - 33, 2, 30 )
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

