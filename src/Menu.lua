---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

Menu = {}
function Menu:new()
    -- Variables
    local self = display.newGroup()
    local widget = require( "widget" )
    local composer = require( "composer" )
    local DBManager = require('src.DBManager')
    local h = display.topStatusBarContentHeight
    local intW, intH  = display.contentWidth, display.contentHeight
    local midW, midH  = intW / 2, intH / 2
    local fxTap = audio.loadSound( "fx/click.wav")
    local Menu, bgGray, bgMenuUser1, txtLCard
    
    -- Bloquea cierre de menu
    function blockTap()
        return true;
    end
    
    -- Cambia pantalla
    function closeSession(event)
        DBManager.updateUser({id='', fbid='', name='', idCard=''})
        changeScreen(event)
        return true
    end
    
    -- Cambia pantalla
    function changeScreen(event)
        hideMenu()
        toScreen(event)
        return true
    end
    
    -- Cambia pantalla
    function getFrameFB(x, y)
        local fbFrame = display.newImage("img/deco/fbFrame.png")
        fbFrame:translate(x, y)
        self:insert( fbFrame )
    end
    
    -- Cerramos o mostramos shadow
    function hideMenu()
        transition.to( self, { x = -400, time = 400, transition = easing.outExpo })
        transition.to( bgGray, { alpha = 0, time = 400, transition = easing.outExpo })
        if composer.getSceneName( "current" ) == "src.Map" then
            moveMap(0)
        end
        return true;
    end
    
    -- Obtenemos el Menu
    function self:getMenu()
        if composer.getSceneName( "current" ) == "src.Map" then
            moveMap(400)
        end
        transition.to( self, { x = 0, time = 400, onComplete=function() 
            bgGray.alpha = .5
        end })
    end
    
    -- Deshabilitamos CardLink
    function disabledLink()
        txtLCard.text = 'Tarjeta Vinculada'
        bgMenuUser1.alpha = .2
        bgMenuUser1:removeEventListener( 'tap', changeScreen)
    end
    
    -- Creamos la pantalla del menu
    function self:builScreen()
        Menu =  menu
        self.anchorY = 0
        self.y = h
        self.x = -400
        local minScr = 220 -- Pantalla pequeña
        
        local dbConfig = DBManager.getSettings()
        
        bgGray = display.newRect( midW, midH, intW, intH )
        bgGray.alpha = 0
        bgGray:setFillColor( 0 )
        bgGray:addEventListener( 'tap', hideMenu)
        self:insert(bgGray)
        
        -- Background
        local background = display.newRect(200, midH, 400, intH )
        background:setFillColor( .22, .22, .22 )
        background:addEventListener( 'tap', blockTap)
        self:insert(background)
        
        -- Background
        local bgFB = display.newRect(200, 0, 400, minScr + 40 )
        bgFB.anchorY = 0
        bgFB:setFillColor( .38, .38, .38 )
        self:insert(bgFB)
        
        -- Avatar
        if dbConfig.fbid == nil or dbConfig.fbid == '' or dbConfig.fbid == 0 or dbConfig.fbid == '0' then
            local bgFB = display.newCircle( 200, minScr/2, 78 )
            bgFB:setFillColor( unpack(cTurquesa) )
            self:insert(bgFB)
            local fbPhoto = display.newImage("img/deco/fbPhoto.png")
            fbPhoto:translate(200, minScr/2)
            self:insert( fbPhoto )
        else
            url = "http://graph.facebook.com/"..dbConfig.fbid.."/picture?large&width=150&height=150"
            local isReady = retriveImage(dbConfig.fbid.."fbmax", url, self, 200, minScr/2, 150, 150, true)
            if isReady then
                local fbFrame = display.newImage("img/deco/fbFrame.png")
                fbFrame:translate(200, minScr/2)
                self:insert( fbFrame )
            end
        end
        
        local txtNombre = display.newText({
            text = dbConfig.name, 
            x = 200, y = minScr-10, width = 300, 
            font = fontBold,   
            fontSize = 20, align = "center"
        })
        txtNombre:setFillColor( unpack(cWhite) )
        self:insert( txtNombre )
        local txtUbicacion = display.newText({
            text = dbConfig.city, 
            x = 200, y = minScr + 10, width = 300, 
            font = fontLight,   
            fontSize = 18, align = "center"
        })
        txtUbicacion:setFillColor( unpack(cWhite) )
        self:insert( txtUbicacion )
                
        local grpOptions = display.newGroup()
        grpOptions.y = minScr + 40
        self:insert(grpOptions)
        
        -- Estado de cuenta
        local bgAccount = display.newRect(200, 40, 400, 80 )
        bgAccount.screen = "Account"
        bgAccount:addEventListener( 'tap', changeScreen)
        bgAccount:setFillColor( {
            type = 'gradient',
            color1 = { 46/255, 190/255, 239/255 }, 
            color2 = { 26/255, 170/255, 219/255 }, 
            direction = "bottom"
        } ) 
        grpOptions:insert(bgAccount)
        local txtTitleTuks = display.newText({
            text = "Estado de Cuenta", 
            x = 260, y = 40, width = 300,
            font = fontBold, fontSize = 24, align = "left"
        })
        txtTitleTuks:setFillColor( unpack(cWhite) )
        grpOptions:insert( txtTitleTuks )
        local menuPoints = display.newImage("img/icon/menuPoints.png")
        menuPoints:translate(66, 40)
        grpOptions:insert( menuPoints )
        
        -- Lineas
        local bgFB = display.newRect(200, 124, 400, 80 )
        bgFB:setFillColor( unpack(cPurple) ) 
        grpOptions:insert(bgFB)
        local line2 = display.newLine(133, 84, 133, 164)
        line2:setStrokeColor( 1, .3 )
        line2.strokeWidth = 2
        grpOptions:insert(line2)
        local line3 = display.newLine(267, 84, 267, 164)
        line3:setStrokeColor( 1, .3 )
        line3.strokeWidth = 2
        grpOptions:insert(line3)
        
        -- Iconos
        bgMenuUser1 = display.newRect( 0, 124, 133, 80 )
        bgMenuUser1.alpha = .2
        bgMenuUser1.anchorX = 0
        bgMenuUser1.screen = "CardLink"
        bgMenuUser1:setFillColor( .7 )
        grpOptions:insert(bgMenuUser1)
        local menuUser = display.newImage("img/icon/menuCard.png")
        menuUser:translate(66, 120)
        grpOptions:insert( menuUser )
        txtLCard = display.newText({
            text = "Tarjeta Vinculada", 
            x = 66, y = 150, width = 120,
             font = fontBold, fontSize = 14, align = "center"
        })
        txtLCard:setFillColor( unpack(cWhite) )
        grpOptions:insert( txtLCard )
        local bgMenuUser2 = display.newRect( 134, 124, 133, 80 )
        bgMenuUser2.alpha = .01
        bgMenuUser2.anchorX = 0
        bgMenuUser2.screen = "Cities"
        bgMenuUser2:setFillColor( .7 )
        bgMenuUser2:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenuUser2)
        local menuReload = display.newImage("img/icon/menuCity.png")
        menuReload:translate(199, 120)
        grpOptions:insert( menuReload )
        local txtCCiudad = display.newText({
            text = "Cambio de Ciudad", 
            x = 200, y = 150, width = 120,
            font = fontBold, fontSize = 14, align = "center"
        })
        txtCCiudad:setFillColor( unpack(cWhite) )
        grpOptions:insert( txtCCiudad )
        local bgMenuUser3 = display.newRect( 267, 124, 133, 80 )
        bgMenuUser3.alpha = .01
        bgMenuUser3.anchorX = 0
        bgMenuUser3.screen = "Login"
        bgMenuUser3:setFillColor( .7 )
        bgMenuUser3:addEventListener( 'tap', closeSession)
        grpOptions:insert(bgMenuUser3)
        local menuClose = display.newImage("img/icon/menuClose.png")
        menuClose:translate(332, 120)
        grpOptions:insert( menuClose )
        local txtCSession = display.newText({
            text = "Cerrar Sesión", 
            x = 333, y = 150, width = 120,
             font = fontBold, fontSize = 14, align = "center"
        })
        txtCSession:setFillColor( unpack(cWhite) )
        grpOptions:insert( txtCSession )
        
        if dbConfig.idCard == nil or dbConfig.idCard == '' then
            txtLCard.text = 'Ligar Tarjeta'
            bgMenuUser1.alpha = .01
            bgMenuUser1:addEventListener( 'tap', changeScreen)
        end
        
        scrMMain = widget.newScrollView
        {
            top = 165,
            left = 0,
            width = 400,
            height = intH - (minScr+235),
            horizontalScrollDisabled = true,
            isBounceEnabled = false,
            hideBackground = true
        }
        grpOptions:insert(scrMMain)
        
        -- Menu vertical
        local line1 = display.newLine(0, 80, 400, 80)
        line1:setStrokeColor( 1, .3 )
        line1.strokeWidth = 2
        scrMMain:insert(line1)
        local bgMenu1 = display.newRect( 200, 40, 400, 60 )
        bgMenu1.alpha = .01
        bgMenu1.screen = "Joined"
        bgMenu1:setFillColor( .7 )
        bgMenu1:addEventListener( 'tap', changeScreen)
        scrMMain:insert(bgMenu1)
        local menuComercios = display.newImage("img/icon/menuComercios.png")
        menuComercios:translate(66, 40)
        scrMMain:insert( menuComercios )
        local txtTitle1 = display.newText({
            text = "Mis programas de lealtad", 
            x = 260, y = 40, width = 300,
            font = fontBold, fontSize = 20, align = "left"
        })
        txtTitle1:setFillColor( 1 )
        scrMMain:insert(txtTitle1)
        
        local line2 = display.newLine(0, 160, 400, 160)
        line2:setStrokeColor( 1, .3 )
        line2.strokeWidth = 2
        scrMMain:insert(line2)
        local bgMenu2 = display.newRect( 200, 120, 400, 60 )
        bgMenu2.alpha = .01
        bgMenu2.screen = "Partners"
        bgMenu2:setFillColor( .7 )
        bgMenu2:addEventListener( 'tap', changeScreen)
        scrMMain:insert(bgMenu2)
        local menuComercios = display.newImage("img/icon/menuAfiliado.png")
        menuComercios:translate(66, 120)
        scrMMain:insert( menuComercios )
        local txtTitle2 = display.newText({
            text = "Comercios Afiliados", 
            x = 260, y = 120, width = 300,
            font = fontBold, fontSize = 20, align = "left"
        })
        txtTitle2:setFillColor( 1 )
        scrMMain:insert(txtTitle2)
        
        local bgMenu3 = display.newRect( 200, 200, 400, 60 )
        bgMenu3.alpha = .01
        bgMenu3.screen = "Rewards"
        bgMenu3:setFillColor( .7 )
        bgMenu3:addEventListener( 'tap', changeScreen)
        scrMMain:insert(bgMenu3)
        local menuComercios = display.newImage("img/icon/menuProgramas.png")
        menuComercios:translate(66, 200)
        scrMMain:insert( menuComercios )
        local txtTitle3 = display.newText({
            text = "Recompensas Disponibles", 
            x = 260, y = 200, width = 300,
            font = fontBold, fontSize = 20, align = "left"
        })
        txtTitle3:setFillColor( 1 )
        scrMMain:insert(txtTitle3)
        
        scrMMain:setScrollHeight(250)
        
        -- Border Right
        local borderRight = display.newRect( 398, midH, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .4, .4, .4, .2 },
            direction = "left"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        self:insert(borderRight)
    end

    return self
end