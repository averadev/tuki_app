---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local composer = require( "composer" )
local Sprites = require('src.Sprites')
local Globals = require( "src.Globals" )
local widget = require( "widget" )
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local bgShadow, headLogo, grpLoading, grpAnimate, filters, scrViewF
    local h = display.topStatusBarContentHeight, grpBubble
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
        
        local bg = display.newRect( midW, 0, intW, 60 )
        bg.anchorY = 0
        bg:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBBlu) }, 
            color2 = { unpack(cBTur) },
            direction = "right"
        } ) 
        self:insert(bg)
        
        local toolbar = display.newRect( 0, 59, display.contentWidth, 2 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( unpack(cBTur) )
        self:insert(toolbar)
        
        headLogo = display.newGroup()
        self:insert( headLogo )
        
        local iconLogo = display.newImage("img/icon/iconHeader.png")
        iconLogo:translate( midW, 40 )
        iconLogo:addEventListener( 'tap', toHome)
        headLogo:insert( iconLogo )
        
        if not isWelcome then
            if not ("src.Home" == composer.getSceneName( "current" )) then
                local iconReturn = display.newImage("img/icon/iconReturn.png")
                iconReturn:translate(40, 30)
                iconReturn:addEventListener( 'tap', backScreen)
                self:insert( iconReturn )
            end
            
            local headMenu = display.newImage("img/icon/headMenu.png")
            headMenu:translate(intW-40, 30)
            headMenu:addEventListener( 'tap', showMenu)
            self:insert( headMenu )
            
             -- Get Menu
            if Globals.menu == nil then
                Globals.menu = Menu:new()
                Globals.menu:builScreen()
            end
        end
    end
    
    -------------------------------------
    -- Creamos la barra de navegacion
    -- @param scrView objeto contenedor
    ------------------------------------ 
    function self:buildNavBar(scrView)
        
        local grpNavBar = display.newGroup()
        self:insert(grpNavBar)
        
        local btnBack = display.newRect( 120, 85, 240, 50 )
        btnBack:setFillColor( unpack(cBPur) )
        btnBack:addEventListener( 'tap', backScreen)
        grpNavBar:insert(btnBack)
        local txtBack = display.newText({
            text = "REGRESAR",     
            x = 120, y = 85, width = 240,
            font = fontSemiBold,   
            fontSize = 16, align = "center"
        })
        grpNavBar:insert(txtBack)
        
        local btnHome = display.newRect( 360, 85, 240, 50 )
        btnHome:setFillColor( unpack(cBTur) )
        btnHome:addEventListener( 'tap', toHome)
        grpNavBar:insert(btnHome)
        local txtBack = display.newText({
            text = "VOLVER AL INICIO",     
            x = 360, y = 85, width = 240,
            font = fontSemiBold,   
            fontSize = 16, align = "center"
        })
        grpNavBar:insert(txtBack)
        
        grpNavBar:toBack()
    end
    
    -------------------------------------
    -- Creamos el bottom bar
    ------------------------------------ 
    function self:buildBottomBar()
        local intH = display.contentHeight - h
        
        local toolbar = display.newRect( 0, intH - 60, display.contentWidth, 60 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( 0 )
        self:insert(toolbar)
        
        local section1 = display.newRect( 0, intH - 60, 96, 60 )
        section1.anchorX = 0
        section1.anchorY = 0
        section1.screen = 'Wallet'
        section1:addEventListener( 'tap', toScreen)
        self:insert(section1)
        local section2 = display.newRect( 96, intH - 60, 96, 60 )
        section2.anchorX = 0
        section2.anchorY = 0
        section2.screen = 'Messages'
        section2:addEventListener( 'tap', toScreen)
        self:insert(section2)
        local section3 = display.newRect( 192, intH - 60, 96, 60 )
        section3.anchorX = 0
        section3.anchorY = 0
        self:insert(section3)
        local section4 = display.newRect( 288, intH - 60, 96, 60 )
        section4.anchorX = 0
        section4.anchorY = 0
        section4.screen = 'Map'
        section4:addEventListener( 'tap', toScreen)
        self:insert(section4)
        local section5 = display.newRect( display.contentWidth - 96, intH - 60, 96, 60 )
        section5.anchorX = 0
        section5.anchorY = 0
        section5.screen = 'Favs'
        section5:addEventListener( 'tap', toScreen)
        self:insert(section5)
        
        local lnDot = display.newImage("img/deco/lnDot.png")
        lnDot:translate(midW, intH - 58 )
        self:insert( lnDot )
        
        local iconCheckIn = display.newImage("img/icon/iconCheckIn.png")
        iconCheckIn:translate(245, intH - 53 )
        iconCheckIn.screen = 'CheckIn'
        iconCheckIn:addEventListener( 'tap', toScreen)
        self:insert( iconCheckIn )
        -- Reduce Size
        if composer.getSceneName( "current" ) == "src.Map" then
            iconCheckIn.width = 80
            iconCheckIn.height = 80
            iconCheckIn.y = intH - 40
        end
        
        local bottomWallet = display.newImage("img/icon/bottomWallet.png")
        bottomWallet:translate(43, intH - 30)
        self:insert( bottomWallet )
        local bottomMail = display.newImage("img/icon/bottomMail.png")
        bottomMail:translate(150, intH - 30)
        self:insert( bottomMail )
        local bottomMap = display.newImage("img/icon/bottomMap.png")
        bottomMap:translate(333, intH - 30)
        self:insert( bottomMap )
        local bottomFav = display.newImage("img/icon/bottomFav.png")
        bottomFav:translate(435, intH - 30)
        self:insert( bottomFav )
    end
    
    -------------------------------------
    -- Muestra el bubble
    ------------------------------------ 
    function self:showBubble(animate)
        if myWallet > 0 then 
            if grpBubble then
                grpBubble:removeSelf()
                grpBubble = nil
            end 

            grpBubble = display.newGroup()
            self:insert(grpBubble)
            grpBubble.alpha = 0

            local myCircle1 = display.newCircle( 63, intH - 80, 12 )
            myCircle1:setFillColor( 1 )
            grpBubble:insert(myCircle1)

            local myCircle2 = display.newCircle( 63, intH - 80, 10 )
            myCircle2:setFillColor( 1, .3, .3 )
            grpBubble:insert(myCircle2)

            local txt = display.newText({
                text = myWallet,     
                x = 63, y = intH - 81, width = 30,
                font = fontBold, fontSize = 14, align = "center"
            })
            txt:setFillColor( 1 )
            grpBubble:insert(txt)

            if animate then
                transition.to( grpBubble, { alpha = 1, time = 600})
            else
                grpBubble.alpha = 1
            end
        else
            if grpBubble then
                grpBubble:removeSelf()
                grpBubble = nil
            end 
        end
    end
    
    -------------------------------------
    -- Muestra loading sprite
    -- @param arrayObj lista
    -- @param parent objeto contenedor
    ------------------------------------
    function self:setEmpty(arrayObj, parent, info)
        arrayObj[1] = display.newGroup()
        parent:insert(arrayObj[1])

        local empty = display.newImage("img/deco/notRows.png")
        empty:translate( midW, (parent.height / 2) - 40 )
        arrayObj[1]:insert( empty )
        local titleLoading = display.newText({
            text = info, 
            x = midW, y = (parent.height / 2) + 70,
            font = fontRegular, width = 350,
            fontSize = 16, align = "center"
        })
        titleLoading:setFillColor( unpack(cBlueH) )
        arrayObj[1]:insert(titleLoading)
    end
    
    -- Descargar Deal
    function self:animate()
        
        if grpAnimate then
            grpAnimate:removeSelf()
            grpAnimate = nil
        end
        grpAnimate = display.newGroup()
        self:insert(grpAnimate)
        
        function setDes(event)
            return true
        end
        local bgShade = display.newRect( midW, midH, display.contentWidth, display.contentHeight )
        bgShade:addEventListener( 'tap', setDes)
        bgShade:setFillColor( 0, 0, 0, .5 )
        grpAnimate:insert(bgShade)
        
        local bg1 = display.newRect( midW, midH, 300, 350 )
        bg1:setFillColor( unpack(cBPur) )
        grpAnimate:insert(bg1)
        
        local bg2 = display.newRect( midW, midH, 296, 346 )
        bg2:setFillColor( unpack(cWhite) )
        grpAnimate:insert(bg2)
        
        local iconAfilMax = display.newImage("img/icon/iconAfilMax.png")
        iconAfilMax:translate( midW, midH - 55 )
        grpAnimate:insert( iconAfilMax )
        
        local txt1 = display.newText( {
            text = "¡GRACIAS POR",
            x = midW, y = midH + 55,
			align = "center", width = 250,
            font = "Lato-Heavy", fontSize = 28
        })
        txt1:setFillColor( unpack(cBPur) )
        grpAnimate:insert(txt1)
        
        local txt2 = display.newText( {
            text = "AFILIARTE!",
            x = midW, y = midH + 95,
			align = "center", width = 250,
            font = "Lato-Heavy", fontSize = 37
        })
        txt2:setFillColor( unpack(cBPur) )
        grpAnimate:insert(txt2)
        
        return true
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
            bg:setFillColor( 1 )
            bg:addEventListener( 'tap', setDes)
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
                x = (display.contentWidth / 2) + 5, y = (parent.height / 2) + 120, width = intW,
                font = fontSemiBold,   
                fontSize = 18, align = "center"
            })
            titleLoading:setFillColor( .3, .3, .3 )
            grpLoading:insert(titleLoading)
        else
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
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
            left = 0,
            width = display.contentWidth,
            height = 120,
            verticalScrollDisabled = true,
            backgroundColor = { unpack(cGrayXXL) }
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
                t.iconOn.alpha = 1
                t.iconOff.alpha = 0
                for z = 2, #filters, 1 do 
                    if filters[z].active then
                        filters[z].active = false
                        filters[z].iconOn.alpha = 0
                        filters[z].iconOff.alpha = 1
                    end
                end
            else
                -- Desactivar boton TODOS
                if filters[1].active then
                    filters[1].active = false
                    filters[1].iconOn.alpha = 0
                    filters[1].iconOff.alpha = 1
                end
                -- Activar botones secundarios
                if t.active then
                    t.active = false
                    t.iconOn.alpha = 0
                    t.iconOff.alpha = 1
                else
                    t.active = true
                    t.iconOn.alpha = 1
                    t.iconOff.alpha = 0
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
            local xPosc = (z * 93) - 45

            filters[z] = display.newContainer( 93, 110 )
            filters[z].idx = z
            filters[z].active = false
            filters[z]:translate( xPosc, 60 )
            scrViewF:insert( filters[z] )
            filters[z]:addEventListener( 'tap', tapFilter)

            filters[z].iconOn = display.newImage("img/icon/"..Globals.filtros[z][2].."2.png")
            filters[z].iconOn:translate(0, -10)
            filters[z].iconOn.alpha = 0
            filters[z]:insert( filters[z].iconOn )

            filters[z].iconOff = display.newImage("img/icon/"..Globals.filtros[z][2].."1.png")
            filters[z].iconOff:translate(0, -10)
            filters[z]:insert( filters[z].iconOff )

            local txt = display.newText({
                text = Globals.filtros[z][1], 
                x = xPosc, y = 100, width = 85,
                font = fontSemiBold,   
                fontSize = 9, align = "center"
            })
            txt:setFillColor( .2 )
            scrViewF:insert( txt )

            -- Activate All
            if z == 1 then
                filters[z].active = true
                filters[z].iconOn.alpha = 1
                filters[z].iconOff.alpha = 0
            end
        end
        -- Set new scroll position
        scrViewF:setScrollWidth((93 * #Globals.filtros))
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
        if not ("src."..t.screen == composer.getSceneName( "current" )) then
            audio.play(fxTap)
            if  t.screen == "Partners" or t.screen == "Joined" or 
                t.screen == "Favs" or t.screen == "Rewards"then
                composer.removeScene( "src.Partners" )
                composer.removeScene( "src.Joined" )
                composer.removeScene( "src.Favs" )
                composer.removeScene( "src.Rewards" )
            else
                composer.removeScene( "src."..t.screen )
            end
            
            composer.gotoScene("src."..t.screen, { time = 400, effect = "slideLeft" } )
        end
        return true
    end
    
    -- Regresa pantalla
    function backScreen(event)
        audio.play(fxTap)
        local last = Globals.scenes[#Globals.scenes - 1]
        table.remove( Globals.scenes )
        table.remove( Globals.scenes )
        composer.gotoScene(last, { time = 400, effect = "slideRight" } )
        return true
    end
    
    -- Regresa al Home
    function toHome(event)
        audio.play(fxTap)
        Globals.scenes = {}
        composer.gotoScene("src.Home", { time = 400, effect = "slideRight" } )
        return true
    end
    
    return self
end







