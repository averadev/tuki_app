Menu = {}
function Menu:new()
    -- Variables
    local self = display.newGroup()
    local widget = require( "widget" )
    local h = display.topStatusBarContentHeight
    local intW, intH  = display.contentWidth, display.contentHeight
    local midW, midH  = intW / 2, intH / 2
    local fxTap = audio.loadSound( "fx/click.wav")
    local Menu
    
    -- Bloquea cierre de menu
    function blockTap()
        return true;
    end
    
    -- Cambia pantalla
    function changeScreen(event)
        local t = event.target
        t.alpha = 1
        audio.play(fxTap)
        timer.performWithDelay(200, function() 
            t.alpha = .01
            if t.screen ~= "" then
                local storyboard = require( "storyboard" )
                storyboard.gotoScene("src."..t.screen, { time = 400, effect = "slideLeft" } )
            end
        end)
        timer.performWithDelay(400, function() 
            
        end)
        showMenu()
        return true
    end
    
    -- Creamos la pantalla del menu
    function self:builScreen()
        Menu =  menu
        self.anchorY = 0
        self.y = h
        self.x = -400
        
        local minScr = 220 -- Pantalla pequeña
        if intH > 790 and intH < 840 then
            minScr = 260 -- Pantalla mediana
        elseif intH > 840 then
            minScr = 300 -- Pantalla alta
        end
        
        -- Background
        local background = display.newRect(200, midH, 400, intH )
        background:setFillColor( .22, .22, .22 )
        background:addEventListener( 'tap', blockTap)
        self:insert(background)
        
        -- Background
        local bgFB = display.newRect(200, minScr/2, 400, minScr )
        bgFB:setFillColor( .38, .38, .38 )
        self:insert(bgFB)
        
        local fbPhoto = display.newImage("img/deco/fbPhoto.png")
        fbPhoto:translate(200, minScr/2)
        self:insert( fbPhoto )
        
        local grpOptions = display.newGroup()
        grpOptions.y = minScr --340
        self:insert(grpOptions)
        
        -- Mis puntos
        local bgFB = display.newRect(200, 40, 400, 80 )
        bgFB:setFillColor( {
            type = 'gradient',
            color1 = { 249/255, 168/255, 6/255 }, 
            color2 = { 243/255, 137/255, 9/255 },
            direction = "bottom"
        } ) 
        grpOptions:insert(bgFB)
        local txtTitle = display.newText( "MIS PUNTOS", 200, 40, 300, 0, native.systemFontBold, 22)
        txtTitle:setFillColor( 1 )
        grpOptions:insert(txtTitle)
        local menuPoints = display.newImage("img/icon/menuPoints.png")
        menuPoints:translate(332, 40)
        grpOptions:insert( menuPoints )
        
        -- Lineas
        local line1 = display.newLine(0, 160, 400, 160)
        line1:setStrokeColor( 1, .5 )
        line1.strokeWidth = 1
        grpOptions:insert(line1)
        local line2 = display.newLine(133, 80, 133, 160)
        line2:setStrokeColor( 1, .5 )
        line2.strokeWidth = 1
        grpOptions:insert(line2)
        local line3 = display.newLine(267, 80, 267, 160)
        line3:setStrokeColor( 1, .5 )
        line3.strokeWidth = 1
        grpOptions:insert(line3)
        
        -- Iconos
        local bgMenuUser1 = display.newRect( 0, 120, 133, 80 )
        bgMenuUser1.alpha = .01
        bgMenuUser1.anchorX = 0
        bgMenuUser1.screen = ""
        bgMenuUser1:setFillColor( .7 )
        bgMenuUser1:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenuUser1)
        local menuUser = display.newImage("img/icon/menuUser.png")
        menuUser:translate(66, 120)
        grpOptions:insert( menuUser )
        local bgMenuUser2 = display.newRect( 134, 120, 133, 80 )
        bgMenuUser2.alpha = .01
        bgMenuUser2.anchorX = 0
        bgMenuUser2.screen = ""
        bgMenuUser2:setFillColor( .7 )
        bgMenuUser2:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenuUser2)
        local menuReload = display.newImage("img/icon/menuReload.png")
        menuReload:translate(199, 120)
        grpOptions:insert( menuReload )
        local bgMenuUser3 = display.newRect( 267, 120, 133, 80 )
        bgMenuUser3.alpha = .01
        bgMenuUser3.anchorX = 0
        bgMenuUser3.screen = ""
        bgMenuUser3:setFillColor( .7 )
        bgMenuUser3:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenuUser3)
        local menuClose = display.newImage("img/icon/menuClose.png")
        menuClose:translate(332, 120)
        grpOptions:insert( menuClose )
        
        -- Menu vertical
        local bgMenu1 = display.newRect( 200, 220, 400, 60 )
        bgMenu1.alpha = .01
        bgMenu1.screen = ""
        bgMenu1:setFillColor( .7 )
        bgMenu1:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenu1)
        local menuComercios = display.newImage("img/icon/menuProgramas.png")
        menuComercios:translate(66, 220)
        grpOptions:insert( menuComercios )
        local txtTitle1 = display.newText( "Recompensas Disponibles", 240, 220, 250, 0, native.systemFontBold, 20)
        txtTitle1:setFillColor( 1 )
        grpOptions:insert(txtTitle1)
        
        local bgMenu2 = display.newRect( 200, 290, 400, 60 )
        bgMenu2.alpha = .01
        bgMenu2.screen = "Partners"
        bgMenu2:setFillColor( .7 )
        bgMenu2:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenu2)
        local menuComercios = display.newImage("img/icon/menuComercios.png")
        menuComercios:translate(66, 290)
        grpOptions:insert( menuComercios )
        local txtTitle2 = display.newText( "Comercios afiliados", 240, 290, 250, 0, native.systemFontBold, 20)
        txtTitle2:setFillColor( 1 )
        grpOptions:insert(txtTitle2)
        
        local bgMenu3 = display.newRect( 200, 360, 400, 60 )
        bgMenu3.alpha = .01
        bgMenu3.screen = ""
        bgMenu3:setFillColor( .7 )
        bgMenu3:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenu3)
        local menuComercios = display.newImage("img/icon/menuProgramas.png")
        menuComercios:translate(66, 360)
        grpOptions:insert( menuComercios )
        local txtTitle3 = display.newText( "Programas de lealtad", 240, 360, 250, 0, native.systemFontBold, 20)
        txtTitle3:setFillColor( 1 )
        grpOptions:insert(txtTitle3)
        
        local bgMenu4 = display.newRect( 200, 430, 400, 60 )
        bgMenu4.alpha = .01
        bgMenu4.screen = ""
        bgMenu4:setFillColor( .7 )
        bgMenu4:addEventListener( 'tap', changeScreen)
        grpOptions:insert(bgMenu4)
        local menuComercios = display.newImage("img/icon/menuFavs.png")
        menuComercios:translate(66, 430)
        grpOptions:insert( menuComercios )
        local txtTitle4 = display.newText( "Mis favoritos", 240, 430, 250, 0, native.systemFontBold, 20)
        txtTitle4:setFillColor( 1 )
        grpOptions:insert(txtTitle4)
        
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