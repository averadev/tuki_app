
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
require('src.Menu')

Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local scrMenu, bgShadow, headLogo, bottomCheck
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
        toolbar:setFillColor( .21 )
        self:insert(toolbar)
        
        local section1 = display.newRect( 0, intH - 80, 96, 80 )
        section1.anchorX = 0
        section1.anchorY = 0
        section1:setFillColor( .24 )
        self:insert(section1)
        
        local section2 = display.newRect( display.contentWidth - 96, intH - 80, 96, 80 )
        section2.anchorX = 0
        section2.anchorY = 0
        section2:setFillColor( .24 )
        self:insert(section2)
        
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
        
        local data = {{"400", "MIS PUNTOS"}, {"98", "EL CAFE"}, {"110", "PARRILLADA"}}
        for z = 1, #data, 1 do 
            local xPosc = z * 120
            
            local txtTitle = display.newText({
                text = data[z][1],     
                x = xPosc - 60, y = 110, width = 120,
                font = native.systemFontBold,   
                fontSize = 24, align = "center"
            })
            txtTitle:setFillColor( 0 )
            self:insert(txtTitle)
            local txtSubTitle = display.newText({
                text = data[z][2],     
                x = xPosc - 60, y = 135, width = 120,
                font = native.systemFont,   
                fontSize = 12, align = "center"
            })
            txtSubTitle:setFillColor( .3 )
            self:insert(txtSubTitle)
            
            local line = display.newLine(xPosc, 80, xPosc, 160)
            line:setStrokeColor( .58, .3 )
            line.strokeWidth = 1
            self:insert(line)
        end
        
        local headMore = display.newImage("img/icon/headMore.png")
        headMore:translate(display.contentWidth - 60, 120)
        self:insert( headMore )
        
        headLogo:toFront()
    end
    
    -- Creamos la el toolbar
    function self:buildNavBar()
        
        local toolbar = display.newRoundedRect( 40, 110, 400, 70, 10 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .91 )
        self:insert(toolbar)
        
        local line = display.newLine(240, 110, 240, 180)
        line:setStrokeColor( .78, .3 )
        line.strokeWidth = 2
        self:insert(line)
        
        
        local btnBack = display.newRect( 140, 145, 160, 60 )
        btnBack:setFillColor( .91 )
        btnBack:addEventListener( 'tap', backScreen)
        self:insert(btnBack)
        local navBack = display.newImage("img/icon/navBack.png")
        navBack:translate( 90, 145 )
        self:insert( navBack )
        local txtBack = display.newText({
            text = "REGRESAR",     
            x = 200, y = 145, width = 150,
            font = native.systemFont,   
            fontSize = 14, align = "left"
        })
        txtBack:setFillColor( .68 )
        self:insert(txtBack)
        
        local btnHome = display.newRect( 340, 145, 160, 60 )
        btnHome:setFillColor( .91 )
        btnHome:addEventListener( 'tap', backScreen)
        self:insert(btnHome)
        local navHome = display.newImage("img/icon/navHome.png")
        navHome:translate( 410, 142 )
        self:insert( navHome )
        local txtBack = display.newText({
            text = "VOLVER AL INICIO",     
            x = 310, y = 145, width = 150,
            font = native.systemFont,   
            fontSize = 14, align = "right"
        })
        txtBack:setFillColor( .68 )
        self:insert(txtBack)
        
    end
    
    -- Cambia pantalla
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







