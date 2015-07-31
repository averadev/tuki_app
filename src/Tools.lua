
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local Sprites = require('src.Sprites')
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local scrMenu, bgShadow, headLogo, bottomCheck, grpLoading
    local h = display.topStatusBarContentHeight
    local fxTap = audio.loadSound( "fx/click.wav")
    self.y = h
    
    -- Creamos la el toolbar
    function self:buildHeader()
        
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

        local btnMenu = display.newRect( 0, 0, 80, 80 )
        btnMenu.anchorX = 0
        btnMenu.anchorY = 0
        btnMenu:setFillColor( .29 )
        btnMenu:addEventListener( 'tap', showMenu)
        self:insert(btnMenu)
        
        local headMenu = display.newImage("img/icon/headMenu.png")
        headMenu:translate(40, 40)
        self:insert( headMenu )
        
        local headSearch = display.newImage("img/icon/headSearch.png")
        headSearch:translate(display.contentWidth - 40, 40)
        self:insert( headSearch )
        
        headLogo = display.newImage("img/icon/headLogo.png")
        headLogo:translate(display.contentWidth /2, 70)
        self:insert( headLogo )
        
         -- Get Menu
        scrMenu = Menu:new()
        scrMenu:builScreen()
    end
    
    -- Creamos la el toolbar
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
        
        
        bottomCheck = display.newImage("img/icon/bottomCheck.png")
        bottomCheck:translate(245, intH - 55)
        self:insert( bottomCheck )
        
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
    
    -- Creamos la el toolbar
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
    
    -- Creamos la el toolbar
    function self:setPointsBar(data)
        
        local bg = display.newRect( 52, 120, 105, 80 )
        bg:setFillColor( .7 )
        bg.alpha = .01
        bg.screen = 'Points'
        bg:addEventListener( 'tap', toScreen)
        self:insert(bg)
        
        local txtTitle = display.newText({
            text = data.total,     
            x = 55, y = 115, width = 105,
            font = native.systemFontBold,   
            fontSize = 24, align = "center"
        })
        txtTitle:setFillColor( 0 )
        self:insert(txtTitle)
        local txtSubTitle = display.newText({
            text = "Mis Puntos",     
            x = 55, y = 137, width = 100,
            font = native.systemFont,   
            fontSize = 12, align = "center"
        })
        txtSubTitle:setFillColor( .3 )
        self:insert(txtSubTitle)
        
        for z = 1, #data.items, 1 do 
            local xPosc = z * 105
            
            local bg = display.newRect( 52 + xPosc, 120, 105, 80 )
            bg:setFillColor( .7 )
            bg.alpha = .01
            bg.idCommerce = data.items[z].idCommerce
            bg.screen = 'Partner'
            bg:addEventListener( 'tap', toScreen)
            self:insert(bg)
            
            local txtTitle = display.newText({
                text = data.items[z].points,     
                x = xPosc + 55, y = 115, width = 105,
                font = native.systemFontBold,   
                fontSize = 24, align = "center"
            })
            txtTitle:setFillColor( 0 )
            self:insert(txtTitle)
            local txtSubTitle = display.newText({
                text = data.items[z].name,     
                x = xPosc + 55, y = 137, width = 100,
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
        bg.screen = 'Points'
        bg:addEventListener( 'tap', toScreen)
        self:insert(bg)
        
        local headMore = display.newImage("img/icon/headMore.png")
        headMore:translate(display.contentWidth - 30, 120)
        self:insert( headMore )
        
        headLogo:toFront()
    end
    
    -- Creamos la el toolbar
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
        btnHome:addEventListener( 'tap', backScreen)
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
    
    -- Creamos loading
    function self:setLoading(isLoading, parent)
        if isLoading then
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
            grpLoading = display.newGroup()
            parent:insert(grpLoading)
            
            local bg = display.newRect( (display.contentWidth / 2), (display.contentHeight / 2), 
                display.contentWidth, display.contentHeight )
            bg:setFillColor( .85 )
            bg.alpha = .3
            grpLoading:insert(bg)
            local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
            local loading = display.newSprite(sheet, Sprites.loading.sequences)
            loading.x = display.contentWidth / 2
            loading.y = display.contentHeight / 2 
            grpLoading:insert(loading)
            loading:setSequence("play")
            loading:play()
            local titleLoading = display.newText({
                text = "Loading...",     
                x = (display.contentWidth / 2) + 5, y = (display.contentHeight / 2) + 60, width = intW,
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
    
    -- Cambia pantalla
    function toScreen(event)
        local t = event.target
        audio.play(fxTap)
        t.alpha = 1
        transition.to( t, { alpha = .01, time = 200, transition = easing.outExpo })
        storyboard.gotoScene("src."..t.screen, { time = 400, effect = "slideLeft" } )
    end
    
    -- Regresa pantalla
    function backScreen(event)
        audio.play(fxTap)
        storyboard.gotoScene("src.Home", { time = 400, effect = "slideRight" } )
        return true
    end
    
    -- Cerramos o mostramos shadow
    function showMenu(event)
        if bgShadow.alpha == 0 then
            scrMenu:toFront()
            bgShadow:toFront()
            bgShadow:addEventListener( 'tap', showMenu)
            transition.to( bgShadow, { alpha = .5, time = 400, transition = easing.outExpo })
            transition.to( scrMenu, { x = 0, time = 400, transition = easing.outExpo } )
        else
            bgShadow:removeEventListener( 'tap', showMenu)
            transition.to( bgShadow, { alpha = 0, time = 400, transition = easing.outExpo })
            transition.to( scrMenu, { x = -400, time = 400, transition = easing.outExpo })
        end
        return true;
    end
    
    return self
end







