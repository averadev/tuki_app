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
        hidenMenu()
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
        transition.to( self, { x = 480, time = 400, transition = easing.outExpo })
        transition.to( bgGray, { alpha = 0, time = 400, transition = easing.outExpo })
        if composer.getSceneName( "current" ) == "src.Map" then
            moveMap(0)
        end
        return true;
    end
    
    -- Cerramos o mostramos shadow
    function hidenMenu()
        self.x = 480
        bgGray.alpha = 0
        return true;
    end
    
    -- Obtenemos el Menu
    function self:getMenu()
        if composer.getSceneName( "current" ) == "src.Map" then
            moveMap(400)
        end
        transition.to( self, { x = 80, time = 400, onComplete=function() 
            bgGray.alpha = .5
        end })
    end
    
    -- Deshabilitamos CardLink
    function disabledLink()
        txtLCard.text = 'Tarjeta Vinculada'
        bgMenuUser1:removeEventListener( 'tap', changeScreen)
    end
    
    -- Creamos la pantalla del menu
    function self:builScreen()
        Menu =  menu
        self.anchorY = 0
        self.y = h
        self.x = 480
        local minScr = 220 -- Pantalla pequeña
        
        local dbConfig = DBManager.getSettings()
        
        bgGray = display.newRect( -40, midH, intW, intH )
        bgGray.alpha = 0
        bgGray:setFillColor( 0 )
        bgGray:addEventListener( 'tap', hideMenu)
        self:insert(bgGray)
        
        -- Background
        local background = display.newRect(200, midH, 400, intH )
        background:setFillColor( unpack(cWhite) )
        background:addEventListener( 'tap', blockTap)
        self:insert(background)
        
        -- Background
        local bgFB = display.newRect(200, 0, 400, 280 )
        bgFB.anchorY = 0
        bgFB:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBBlu) }, 
            color2 = { unpack(cBTur) },
            direction = "bottom"
        } )
        self:insert(bgFB)
        
        -- Avatar
        if dbConfig.fbid == nil or dbConfig.fbid == '' or dbConfig.fbid == 0 or dbConfig.fbid == '0' then     
            local fbFrame = display.newImage("img/deco/circleLogo100.png")
            fbFrame:translate(100, 80)
            self:insert( fbFrame )
            local fbPhoto = display.newImage("img/deco/fbPhoto.png")
            fbPhoto:translate(100, 80)
            self:insert( fbPhoto )
        else
            local fbFrame = display.newImage("img/deco/circleLogo100.png")
            fbFrame:translate(100, 80)
            self:insert( fbFrame )
            url = "http://graph.facebook.com/"..dbConfig.fbid.."/picture?large&width=150&height=150"
            retriveImage(dbConfig.fbid.."fbmax", url, self, 100, 80, 100, 100, true)
        end
        
        local txtNombre = display.newText({
            text = dbConfig.name, 
            x = 275, y = 80, width = 220, 
            font = fontBold, fontSize = 20
        })
        txtNombre.anchorY = 1
        txtNombre:setFillColor( unpack(cWhite) )
        self:insert( txtNombre )
        local txtUbicacion = display.newText({
            text = dbConfig.city, 
            x = 275, y = 80, width = 220, 
            font = fontLight, fontSize = 17
        })
        txtUbicacion.anchorY = 0
        txtUbicacion:setFillColor( unpack(cWhite) )
        self:insert( txtUbicacion )
        
        -- Menu
        local dot400 = display.newImage("img/deco/dot400.png")
        dot400:translate(200, 160)
        self:insert( dot400 )
        local dot118 = display.newImage("img/deco/dot118.png")
        dot118:translate(200, 220)
        self:insert( dot118 )
        
        local bgMenuUser1 = display.newRect( 100, 210, 120, 80 )
        bgMenuUser1.alpha = .01
        bgMenuUser1.screen = "CardLink"
        bgMenuUser1:addEventListener( 'tap', changeScreen)
        self:insert(bgMenuUser1)
        local menuUser = display.newImage("img/icon/menuCard.png")
        menuUser:translate(100, 200)
        self:insert( menuUser )
        txtLCard = display.newText({
            text = "VINCULAR TARJETA", 
            x = 100, y = 240, width = 120,
             font = fontBold, fontSize = 14, align = "center"
        })
        txtLCard:setFillColor( unpack(cWhite) )
        self:insert( txtLCard )
        
        local bgMenuUser2 = display.newRect( 300, 210, 120, 80 )
        bgMenuUser2.alpha = .01
        bgMenuUser2.screen = "Account"
        bgMenuUser2:addEventListener( 'tap', changeScreen)
        self:insert(bgMenuUser2)
        local menuUser2 = display.newImage("img/icon/iconEstadodeCuenta.png")
        menuUser2:translate(300, 200)
        self:insert( menuUser2 )
        txtLCard2 = display.newText({
            text = "ESTADO DE CUENTA", 
            x = 300, y = 240, width = 120,
             font = fontBold, fontSize = 14, align = "center"
        })
        txtLCard2:setFillColor( unpack(cWhite) )
        self:insert( txtLCard2 )
        -- bgMenuUser2.screen = "Cities"
        
        scrMMain = widget.newScrollView
        {
            top = 280,
            left = 0,
            width = 400,
            height = intH - (280+h),
            horizontalScrollDisabled = true,
            isBounceEnabled = false,
            hideBackground = true
        }
        self:insert(scrMMain)
        
        -- Menu vertical
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
            font = fontSemiBold, fontSize = 18, align = "left"
        })
        txtTitle1:setFillColor( unpack(cBlueH) )
        scrMMain:insert(txtTitle1)
        
        local dotM2 = display.newImage("img/deco/dot400Gray.png")
        dotM2:translate(200, 80)
        scrMMain:insert( dotM2 )
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
            font = fontSemiBold, fontSize = 18, align = "left"
        })
        txtTitle2:setFillColor( unpack(cBlueH) )
        scrMMain:insert(txtTitle2)
        
        local dotM3 = display.newImage("img/deco/dot400Gray.png")
        dotM3:translate(200, 160)
        scrMMain:insert( dotM3 )
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
            font = fontSemiBold, fontSize = 18, align = "left"
        })
        txtTitle3:setFillColor( unpack(cBlueH) )
        scrMMain:insert(txtTitle3)
        
        scrMMain:setScrollHeight(250)
        
        local dotM4 = display.newImage("img/deco/dot400Gray.png")
        dotM4:translate(200, 240)
        scrMMain:insert( dotM4 )
        local bgMenu4 = display.newRect( 200, 280, 400, 60 )
        bgMenu4.alpha = .01
        bgMenu4.screen = "Cities"
        bgMenu4:setFillColor( .7 )
        bgMenu4:addEventListener( 'tap', changeScreen)
        scrMMain:insert(bgMenu4)
        local menu4 = display.newImage("img/icon/menuCambiarCiudad.png")
        menu4:translate(66, 280)
        scrMMain:insert( menu4 )
        local txtTitle4 = display.newText({
            text = "Cambiar de Ciudad", 
            x = 260, y = 280, width = 300,
            font = fontSemiBold, fontSize = 18, align = "left"
        })
        txtTitle4:setFillColor( unpack(cBlueH) )
        scrMMain:insert(txtTitle4)
        
        scrMMain:setScrollHeight(250)
        
        local dotM5 = display.newImage("img/deco/dot400Gray.png")
        dotM5:translate(200, 320)
        scrMMain:insert( dotM5 )
        local bgMenu5 = display.newRect( 200, 360, 400, 60 )
        bgMenu5.alpha = .01
        bgMenu5.screen = "Login"
        bgMenu5:setFillColor( .7 )
        bgMenu5:addEventListener( 'tap', closeSession)
        scrMMain:insert(bgMenu5)
        local menu5 = display.newImage("img/icon/menuCerrarSesion.png")
        menu5:translate(66, 360)
        scrMMain:insert( menu5 )
        local txtTitle5 = display.newText({
            text = "Cerrar Sesión", 
            x = 260, y = 360, width = 300,
            font = fontSemiBold, fontSize = 18, align = "left"
        })
        txtTitle5:setFillColor( unpack(cBlueH) )
        scrMMain:insert(txtTitle5)
        
        scrMMain:setScrollHeight(250)
        
        -- Border Right
        local borderRight = display.newRect( 2, midH, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .4, .4, .4, .2 },
            direction = "right"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        self:insert(borderRight)
    end

    return self
end