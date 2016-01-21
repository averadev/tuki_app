
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local Sprites = require('src.Sprites')
local Globals = require( "src.Globals" )
local widget = require( "widget" )
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local bgShadow, headLogo, grpLoading, filters, scrViewF
    local h = display.topStatusBarContentHeight
    local fxTap = audio.loadSound( "fx/click.wav")
    self.y = h
    
    
    -------------------------------------
    -- Creamos el top bar
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
    function self:buildHeader(isWelcome)
        
        bgShadow = display.newRect( 0, 0, display.contentWidth, display.contentHeight - h )
        bgShadow.alpha = 0
        bgShadow.anchorX = 0
        bgShadow.anchorY = 0
        bgShadow:setFillColor( 0 )
        self:insert(bgShadow)
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 80 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .21 )
        self:insert(toolbar)
        
        headLogo = display.newGroup()
        self:insert( headLogo )
        
        local circle1 = display.newCircle( midW, 55, 35 )
        circle1:setFillColor( unpack(cWhite) )
        headLogo:insert( circle1 )
        
        local circle2 = display.newCircle( midW, 55, 32 )
        circle2:setFillColor( unpack(cPurpleL) )
        headLogo:insert( circle2 )
        
        local iconLogo = display.newImage("img/icon/iconLogo.png")
        iconLogo:translate( midW, 55 )
        headLogo:insert( iconLogo )
        
        if not isWelcome then

            local btnMenu = display.newRect( 0, 0, 80, 80 )
            btnMenu.anchorX = 0
            btnMenu.anchorY = 0
            btnMenu:setFillColor( unpack(cGrayXH) )
            btnMenu:addEventListener( 'tap', showMenu)
            self:insert(btnMenu)

            local headMenu = display.newImage("img/icon/headMenu.png")
            headMenu:translate(40, 40)
            self:insert( headMenu )

            local headSearch = display.newImage("img/icon/headSearch.png")
            headSearch:translate(display.contentWidth - 40, 40)
            self:insert( headSearch )
            
             -- Get Menu
            if Globals.menu == nil then
                Globals.menu = Menu:new()
                Globals.menu:builScreen()
            end
        end
    end
    
    -------------------------------------
    -- Creamos el bottom bar
    ------------------------------------ 
    function self:buildBottomBar()
        local intH = display.contentHeight - h
        
        local toolbar = display.newRect( 0, intH - 80, display.contentWidth, 80 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( 0 )
        self:insert(toolbar)
        
        local section1 = display.newRect( 0, intH - 80, 96, 80 )
        section1.anchorX = 0
        section1.anchorY = 0
        section1:setFillColor( .24 )
        section1.screen = 'Wallet'
        section1:addEventListener( 'tap', toScreen)
        self:insert(section1)
        local section2 = display.newRect( 96, intH - 80, 96, 80 )
        section2.anchorX = 0
        section2.anchorY = 0
        section2:setFillColor( .21 )
        section2.screen = 'Messages'
        section2:addEventListener( 'tap', toScreen)
        self:insert(section2)
        local section3 = display.newRect( 192, intH - 80, 96, 80 )
        section3.anchorX = 0
        section3.anchorY = 0
        section3:setFillColor( .21 )
        self:insert(section3)
        local section4 = display.newRect( 288, intH - 80, 96, 80 )
        section4.anchorX = 0
        section4.anchorY = 0
        section4:setFillColor( .21 )
        section4.screen = 'Map'
        section4:addEventListener( 'tap', toScreen)
        self:insert(section4)
        local section5 = display.newRect( display.contentWidth - 96, intH - 80, 96, 80 )
        section5.anchorX = 0
        section5.anchorY = 0
        section5:setFillColor( .24 )
        section5.screen = 'Favs'
        section5:addEventListener( 'tap', toScreen)
        self:insert(section5)
        
        local circle1 = display.newCircle( 245, intH - 65, 50 )
        circle1:setFillColor( unpack(cWhite) )
        self:insert( circle1 )
        local circle2 = display.newCircle( 245, intH - 65, 46 )
        circle2:setFillColor( unpack(cTurquesa) )
        circle2.screen = 'CheckIn'
        circle2:addEventListener( 'tap', toScreen)
        self:insert( circle2 )
        local iconLogo = display.newImage("img/icon/iconCheckIn.png")
        iconLogo:translate(245, intH - 60 )
        self:insert( iconLogo )
        
        local bottomWallet = display.newImage("img/icon/bottomWallet.png")
        bottomWallet:translate(43, intH - 40)
        self:insert( bottomWallet )
        local bottomMail = display.newImage("img/icon/bottomMail.png")
        bottomMail:translate(150, intH - 40)
        self:insert( bottomMail )
        local bottomMap = display.newImage("img/icon/bottomMap.png")
        bottomMap:translate(333, intH - 40)
        self:insert( bottomMap )
        local bottomFav = display.newImage("img/icon/bottomFav.png")
        bottomFav:translate(435, intH - 40)
        self:insert( bottomFav )
    end
    
    -------------------------------------
    -- Creamos la barra de puntos
    ------------------------------------ 
    function self:buildPointsBar()
        
        local toolbar = display.newRect( 0, 80, display.contentWidth, 80 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .85 )
        self:insert(toolbar)
        
        local line1 = display.newLine(0, 160, display.contentWidth, 160)
        line1:setStrokeColor( .58, .3 )
        line1.strokeWidth = 1
        self:insert(line1)
        
        headLogo:toFront()
    end
    
    -------------------------------------
    -- Asignamos valores a la barra de puntos
    -- @param data valores
    ------------------------------------ 
    function self:setPointsBar(data)
        
        local bg = display.newRect( 52, 120, 105, 80 )
        bg:setFillColor( .7 )
        bg.alpha = .01
        bg.screen = 'Points'
        bg:addEventListener( 'tap', toScreen)
        self:insert(bg)
        
        Globals.menu:updateTuks(data.total)
        local txtTitle = display.newText({
            text = data.total,     
            x = 55, y = 115,
            font = native.systemFontBold,   
            fontSize = 24, align = "center"
        })
        txtTitle:setFillColor( 0 )
        self:insert(txtTitle)
        local txtSubTitle = display.newText({
            text = "Mis Puntos",     
            x = 55, y = 137,
            font = native.systemFont,   
            fontSize = 12, align = "center"
        })
        txtSubTitle:setFillColor( .3 )
        self:insert(txtSubTitle)
        
        for z = 1, #data.items, 1 do 
            local xPosc = z * 105
            
            local bgCommerce = display.newRect( 52 + xPosc, 120, 105, 80 )
            bgCommerce:setFillColor( .7 )
            bgCommerce.alpha = .01
            bgCommerce.idCommerce = data.items[z].idCommerce
            bgCommerce.screen = 'Partner'
            bgCommerce:addEventListener( 'tap', tapCommerce)
            self:insert(bgCommerce)
            
            local txtTitle = display.newText({
                text = data.items[z].points,     
                x = xPosc + 55, y = 115,
                font = native.systemFontBold,   
                fontSize = 24, align = "center"
            })
            txtTitle:setFillColor( 0 )
            self:insert(txtTitle)
            local txtSubTitle = display.newText({
                text = data.items[z].name,     
                x = xPosc + 55, y = 137,
                font = native.systemFont,   
                fontSize = 12, align = "center"
            })
            txtSubTitle:setFillColor( .3 )
            self:insert(txtSubTitle)
            
            local line = display.newLine(xPosc, 80, xPosc, 160)
            line:setStrokeColor( .58, .1 )
            line.strokeWidth = 2
            self:insert(line)
        end
        
        local line = display.newLine(420, 80, 420, 160)
        line:setStrokeColor( .58, .1 )
        line.strokeWidth = 2
        self:insert(line)
        
        local bg = display.newRect( 450, 120, 60, 80 )
        bg:setFillColor( .7 )
        bg.alpha = .01
        bg.screen = 'Joined'
        bg:addEventListener( 'tap', toScreen)
        self:insert(bg)
        
        local headMore = display.newImage("img/icon/headMore.png")
        headMore:translate(display.contentWidth - 30, 120)
        self:insert( headMore )
        
        headLogo:toFront()
    end
    
    -------------------------------------
    -- Creamos la barra de navegacion
    -- @param scrView objeto contenedor
    ------------------------------------ 
    function self:buildNavBar(scrView)
        
        local grpNavBar = display.newGroup()
        self:insert(grpNavBar)
        
        local toolbar = display.newRect( 0, 80, 480, 60, 10 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .7 )
        grpNavBar:insert(toolbar)
        
        local btnBack = display.newRect( 120, 110, 240, 60 )
        btnBack:setFillColor( .91 )
        btnBack:addEventListener( 'tap', backScreen)
        grpNavBar:insert(btnBack)
        local navBack = display.newImage("img/icon/navBack.png")
        navBack:translate( 60, 110 )
        grpNavBar:insert( navBack )
        local txtBack = display.newText({
            text = "REGRESAR",     
            x = 180, y = 110, width = 150,
            font = native.systemFont,   
            fontSize = 14, align = "left"
        })
        txtBack:setFillColor( .68 )
        grpNavBar:insert(txtBack)
        
        local btnHome = display.newRect( 360, 110, 240, 60 )
        btnHome:setFillColor( .91 )
        btnHome:addEventListener( 'tap', toHome)
        grpNavBar:insert(btnHome)
        local navHome = display.newImage("img/icon/navHome.png")
        navHome:translate( 435, 105 )
        grpNavBar:insert( navHome )
        local txtBack = display.newText({
            text = "VOLVER AL INICIO",     
            x = 330, y = 110, width = 150,
            font = native.systemFont,   
            fontSize = 14, align = "right"
        })
        txtBack:setFillColor( .68 )
        grpNavBar:insert(txtBack)
        
        local line = display.newLine(240, 80, 240, 140)
        line:setStrokeColor( .78, .3 )
        line.strokeWidth = 2
        grpNavBar:insert(line)
        
        grpNavBar:toBack()
    end
    
    -------------------------------------
    -- Muestra loading sprite
    -- @param arrayObj lista
    -- @param parent objeto contenedor
    ------------------------------------
    function self:setEmpty(arrayObj, parent)
        arrayObj[1] = display.newGroup()
        parent:insert(arrayObj[1])

        local empty = display.newImage("img/icon/empty.png")
        empty:translate( midW, (parent.height / 2) - 40 )
        arrayObj[1]:insert( empty )
        local titleLoading = display.newText({
            text = "Intente con otra consulta", 
            x = midW, y = (parent.height / 2) + 40, width = intW,
            font = native.systemFontBold,   
            fontSize = 18, align = "center"
        })
        titleLoading:setFillColor( .3, .3, .3 )
        arrayObj[1]:insert(titleLoading)
    end
    
    -------------------------------------
    -- Muestra loading sprite
    -- @param isLoading activar/desactivar
    -- @param parent objeto contenedor
    ------------------------------------
    function self:setLoading(isLoading, parent)
        if isLoading then
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
            grpLoading = display.newGroup()
            parent:insert(grpLoading)
            
            function setDes(event)
                return true
            end
            local bg = display.newRect( (display.contentWidth / 2), (parent.height / 2), 
                display.contentWidth, parent.height )
            bg:setFillColor( .85 )
            bg:addEventListener( 'tap', setDes)
            bg.alpha = .3
            grpLoading:insert(bg)
            local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
            local loading = display.newSprite(sheet, Sprites.loading.sequences)
            loading.x = display.contentWidth / 2
            loading.y = parent.height / 2 
            grpLoading:insert(loading)
            loading:setSequence("play")
            loading:play()
            local titleLoading = display.newText({
                text = "Loading...",     
                x = (display.contentWidth / 2) + 5, y = (parent.height / 2) + 60, width = intW,
                font = native.systemFontBold,   
                fontSize = 18, align = "center"
            })
            titleLoading:setFillColor( .3, .3, .3 )
            grpLoading:insert(titleLoading)
        else
            grpLoading:removeSelf()
            grpLoading = nil 
        end
    end
    
    -------------------------------------
    -- Muestra carrusel de filtro
    -- @param parent objeto contenedor
    ------------------------------------
    function self:delFilters()
        if scrViewF then
            scrViewF:removeSelf()
            scrViewF = nil;
        end
    end
    function self:getFilters(parent)
    
        filters = {}
        scrViewF = widget.newScrollView
        {
            top = 0,
            left = 10,
            width = display.contentWidth - 20,
            height = 120,
            verticalScrollDisabled = true,
            backgroundColor = { 1 }
        }
        parent:insert(scrViewF)
        
        -------------------------------------
        -- Cambia de color el elemento
        -- @param event evento
        ------------------------------------
        function tapFilter(event)
            local t = event.target
            
            if t.idx == 1 then
                -- Activar boton TODOS
                if t.active then
                    return
                end
                t.active = true
                t.bgFP1:setFillColor( unpack(cTurquesa) )
                t.bgFP2:setFillColor( unpack(cBlueH) )
                t.iconOn.alpha = 1
                t.iconOff.alpha = 0
                t.txt:setFillColor( 1 )
                for z = 2, #filters, 1 do 
                    if filters[z].active then
                        filters[z].active = false
                        filters[z].bgFP1:setFillColor( unpack(cGrayL) )
                        filters[z].bgFP2:setFillColor( unpack(cWhite) )
                        filters[z].iconOn.alpha = 0
                        filters[z].iconOff.alpha = 1
                        filters[z].txt:setFillColor( .5 )
                    end
                end
            else
                -- Desactivar boton TODOS
                if filters[1].active then
                    filters[1].active = false
                    filters[1].bgFP1:setFillColor( unpack(cGrayL) )
                    filters[1].bgFP2:setFillColor( unpack(cWhite) )
                    filters[1].iconOn.alpha = 0
                    filters[1].iconOff.alpha = 1
                    filters[1].txt:setFillColor( .5 )
                end
                -- Activar botones secundarios
                if t.active then
                    t.active = false
                    t.bgFP1:setFillColor( unpack(cGrayL) )
                    t.bgFP2:setFillColor( unpack(cWhite) )
                    t.iconOn.alpha = 0
                    t.iconOff.alpha = 1
                    t.txt:setFillColor( .5 )
                else
                    t.active = true
                    t.bgFP1:setFillColor( unpack(cTurquesa) )
                    t.bgFP2:setFillColor( unpack(cBlueH) )
                    t.iconOn.alpha = 1
                    t.iconOff.alpha = 0
                    t.txt:setFillColor( 1 )
                end
            end
            
            -- Send filter
            txtFil = ''
            for z = 1, #filters, 1 do 
                if filters[z].active then
                    if txtFil ~= '' then
                        txtFil = txtFil..'-'
                    end
                    txtFil = txtFil..z
                end
            end
            doFilter(txtFil)
        end

        for z = 1, #Globals.filtros, 1 do 
            local xPosc = (z * 94) - 50

            filters[z] = display.newContainer( 90, 90 )
            filters[z].idx = z
            filters[z].active = false
            filters[z]:translate( xPosc, 60 )
            scrViewF:insert( filters[z] )
            filters[z]:addEventListener( 'tap', tapFilter)

            filters[z].bgFP1 = display.newRect(0, 0, 90, 90 )
            filters[z].bgFP1:setFillColor( unpack(cGrayL) )
            filters[z]:insert( filters[z].bgFP1 )

            filters[z].bgFP2 = display.newRect(0, 0, 80, 80 )
            filters[z].bgFP2:setFillColor( unpack(cWhite) )
            filters[z]:insert( filters[z].bgFP2 )

            filters[z].iconOn = display.newImage("img/icon/"..Globals.filtros[z][2].."2.png")
            filters[z].iconOn:translate(0, -10)
            filters[z].iconOn.alpha = 0
            filters[z]:insert( filters[z].iconOn )

            filters[z].iconOff = display.newImage("img/icon/"..Globals.filtros[z][2].."1.png")
            filters[z].iconOff:translate(0, -10)
            filters[z]:insert( filters[z].iconOff )

            filters[z].txt = display.newText({
                text = Globals.filtros[z][1], 
                x = xPosc, y = 90, width = 85,
                font = native.systemFontBold,   
                fontSize = 10, align = "center"
            })
            filters[z].txt:setFillColor( .5 )
            scrViewF:insert( filters[z].txt )

            -- Activate All
            if z == 1 then
                filters[z].active = true
                filters[z].bgFP1:setFillColor( unpack(cTurquesa) )
                filters[z].bgFP2:setFillColor( unpack(cBlueH) )
                filters[z].iconOn.alpha = 1
                filters[z].iconOff.alpha = 0
                filters[z].txt:setFillColor( 1 )
            end
        end
        -- Set new scroll position
        scrViewF:setScrollWidth((94 * #Globals.filtros) - 10)
    end 
    
    -- Muestra el menu
    function showMenu(event)
        Globals.menu:toFront()
        Globals.menu:getMenu()
        return true
    end 
    
    -- Cambia pantalla
    function toScreen(event)
        local t = event.target
        if not ("src."..t.screen == storyboard.getCurrentSceneName()) then
            audio.play(fxTap)
            t.alpha = 1
            transition.to( t, { alpha = .01, time = 200, transition = easing.outExpo })
            storyboard.removeScene( "src."..t.screen )
            storyboard.gotoScene("src."..t.screen, { time = 400, effect = "slideLeft" } )
        end
        return true
    end
    
    -- Regresa pantalla
    function backScreen(event)
        print("backScreen")
        audio.play(fxTap)
        local last = Globals.scenes[#Globals.scenes - 1]
        table.remove( Globals.scenes )
        table.remove( Globals.scenes )
        storyboard.gotoScene(last, { time = 400, effect = "slideRight" } )
        return true
    end
    
    -- Regresa al Home
    function toHome(event)
        audio.play(fxTap)
        Globals.scenes = {}
        storyboard.gotoScene("src.Home", { time = 400, effect = "slideRight" } )
        return true
    end
    
    return self
end







