---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
local widget = require( "widget" )
local Globals = require( "src.Globals" )
local storyboard = require( "storyboard" )
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")

-- Grupos y Contenedores
local screen
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local scrViewPa, tools
local yPosc = 0

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Open url
function openURL(event)
    if event.target.url then
        system.openURL( event.target.url )
    end
end

-- Tap reward event
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( "src.Reward" )
    storyboard.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
end

-- Tap toggle event
function tapFavCom(event)
    local t = event.target
    audio.play( fxFav )
    if t.iconHeart1.alpha == 0  then
        t.iconHeart1.alpha = 1
        t.iconHeart2.alpha = 0
        t:setFillColor( 236/255 )
        RestManager.setCommerceFav(t.idCommerce, 0)
    else
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
        t:setFillColor( 46/255, 190/255, 239/255 )
        RestManager.setCommerceFav(t.idCommerce, 1)
    end
    return true
end

-- Tap toggle event
function tapFavComRew(event)
    local t = event.target
    audio.play( fxFav )
    if t.iconHeart1.alpha == 0  then
        t.iconHeart1.alpha = 1
        t.iconHeart2.alpha = 0
        t:setFillColor( 236/255 )
        RestManager.setRewardFav(t.idReward, 0)
    else
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
        t:setFillColor( 46/255, 190/255, 239/255 )
        RestManager.setRewardFav(t.idReward, 1)
    end
    return true
end


function setCommerce(item, rewards)
    tools:setLoading(false)
    
    local bg1 = display.newRect(midW, 80, 460, 140, 10 )
    bg1:setFillColor( .91 )
    scrViewPa:insert( bg1 )
    
    local bg2 = display.newRect(midW, 80, 456, 136, 10 )
    bg2:setFillColor( 1 )
    scrViewPa:insert( bg2 )
    
    local bgImg = display.newRect(80, 80, 140, 140, 10 )
    bgImg:setFillColor( tonumber(item.colorA1)/255, tonumber(item.colorA2)/255, tonumber(item.colorA3)/255 )
    scrViewPa:insert( bgImg )
    
    local img = display.newImage( item.image, system.TemporaryDirectory )
    img.height = 130
    img.width = 130
    img:translate( 80, 80 )
    scrViewPa:insert( img )
    
    -- Textos informativos
    local txtPName = display.newText({
        text = item.name,     
        x = 310, y = 35, width = 300,
        font = native.systemFontBold,   
        fontSize = 22, align = "left"
    })
    txtPName:setFillColor( .3 )
    scrViewPa:insert(txtPName)

    local  txtPAddress = display.newText({
        text = item.address,     
        x = 310, y = 70, width = 300,
        font = native.systemFont,   
        fontSize = 14, align = "left"
    })
    txtPAddress:setFillColor( .68 )
    scrViewPa:insert(txtPAddress)
    
    local bgBtn = display.newRect(310, 120, 310, 50, 40 )
    bgBtn:setFillColor( 0 )
    scrViewPa:insert( bgBtn )

    local txtBtn = display.newText({
        text = "AFILIATE",     
        x = 310, y = 120, width = 300,
        font = native.systemFontBold,
        fontSize = 22, align = "center"
    })
    txtBtn:setFillColor( 1 )
    scrViewPa:insert(txtBtn)
    
    local bg3 = display.newRect( 125, 190, 230, 60, 10 )
    bg3:setFillColor( .91 )
    scrViewPa:insert( bg3 )
    
    local bgFav = display.newRect( 356, 190, 228, 60, 10 )
    bgFav:setFillColor( .91 )
    bgFav.idCommerce = item.id
    bgFav:addEventListener( 'tap', tapFavCom)
    scrViewPa:insert( bgFav )
    
    local iconMap = display.newImage("img/icon/iconMap.png")
    iconMap:translate( 125, 190 )
    scrViewPa:insert( iconMap )
    
    bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
    bgFav.iconHeart1:translate( 356, 190 )
    scrViewPa:insert( bgFav.iconHeart1 )

    bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
    bgFav.iconHeart2:translate( 356, 190 )
    scrViewPa:insert( bgFav.iconHeart2 )

    -- Fav actions
    if item.id == item.fav  then
        bgFav:setFillColor( 46/255, 190/255, 239/255 )
        bgFav.iconHeart1.alpha = 0
    else
        bgFav.iconHeart2.alpha = 0
    end
    
    yPosc = 255
    
    local bgTitle1 = display.newRect( midW, yPosc, intW, 30 )
    bgTitle1:setFillColor( .91 )
    scrViewPa:insert( bgTitle1 )

    local lblTitle1 = display.newText({
        text = "RECOMPENSAS DISPONIBLES",     
        x = midW, y = yPosc, width = 460,
        font = native.systemFont,
        fontSize = 14, align = "left"
    })
    lblTitle1:setFillColor( .3 )
    scrViewPa:insert(lblTitle1)
    
    yPosc = yPosc + 75
    for z = 1, #rewards, 1 do 
        newReward(rewards[z], yPosc)
        yPosc = yPosc + 95
    end
    
    -- Social Buttons
    yPosc = yPosc - 10
    
    local bg5 = display.newRect( 125, yPosc, 230, 60, 10 )
    bg5:setFillColor( .91 )
    bg5.url = item.facebook
    bg5:addEventListener( 'tap', openURL)
    scrViewPa:insert( bg5 )
    
    local bg6 = display.newRect( 356, yPosc, 228, 60, 10 )
    bg6:setFillColor( .91 )
    bg6.url = item.twitter
    bg6:addEventListener( 'tap', openURL)
    scrViewPa:insert( bg6 )
    
    local iconFB = display.newImage("img/icon/iconFB.png")
    iconFB:translate( 125, yPosc )
    scrViewPa:insert( iconFB )
    
    local iconTW = display.newImage("img/icon/iconTW.png")
    iconTW:translate( 356, yPosc )
    scrViewPa:insert( iconTW )
    
    if item.facebook then
        bg5:setFillColor( 59/255, 89/255, 152/255 )
    end
    if item.twitter then
        bg6:setFillColor( 0, 172/255, 237/255 )
    end
    
    yPosc = yPosc + 50
    -- Set new scroll position
    scrViewPa:setScrollHeight( yPosc )
end

-- Creamos lista de comercios
function newReward(reward, lastYP)
    
    local rewardRow = display.newContainer( 462, 95 )
    rewardRow:translate( midW, lastYP )
    scrViewPa:insert( rewardRow )

    local bg1 = display.newRect(0, 0, intW - 20, 80 )
    bg1:setFillColor( 236/255 )
    rewardRow:insert( bg1 )
    local bg2 = display.newRect(0, 0, intW - 24, 76 )
    bg2:setFillColor( 1 )
    rewardRow:insert( bg2 )
    bg2.idReward = reward.id
    bg2:addEventListener( 'tap', tapReward)

    local bgFav = display.newRect(-196, 0, 60, 74 )
    bgFav:setFillColor( 236/255 )
    rewardRow:insert( bgFav )
    bgFav.idReward = reward.id
    bgFav:addEventListener( 'tap', tapFavComRew)
    local bgPoints = display.newRect(-126, 0, 80, 74 )
    bgPoints:setFillColor( .21 )
    rewardRow:insert( bgPoints )

    bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
    bgFav.iconHeart1:translate( -196, 0 )
    rewardRow:insert( bgFav.iconHeart1 )

    bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
    bgFav.iconHeart2:translate( -196, 0 )
    rewardRow:insert( bgFav.iconHeart2 )

    -- Fav actions
    if reward.id == reward.fav  then
        bgFav.id = reward.id 
        bgFav:setFillColor( 46/255, 190/255, 239/255 )
        bgFav.iconHeart1.alpha = 0 
    else
        bgFav.iconHeart2.alpha = 0 
    end

    -- Textos y descripciones
    if reward.points == 0 or reward.points == "0" then
        local points = display.newText({
            text = "GRATIS", 
            x = -127, y = 0,
            font = native.systemFontBold,   
            fontSize = 20, align = "center"
        })
        points:rotate( -45 )
        points:setFillColor( 1 )
        rewardRow:insert( points )
    else
        local points = display.newText({
            text = reward.points, 
            x = -126, y = -7,
            font = native.systemFontBold,   
            fontSize = 26, align = "center"
        })
        points:setFillColor( 1 )
        rewardRow:insert( points )
        local points2 = display.newText({
            text = "PUNTOS", 
            x = -126, y = 18,
            font = native.systemFontBold,   
            fontSize = 14, align = "center"
        })
        points2:setFillColor( 1 )
        rewardRow:insert( points2 )
    end

    local commerce = display.newText({
        text = reward.commerce,     
        x = 70, y = -15, width = 300, 
        font = native.systemFontBold,   
        fontSize = 17, align = "left"
    })
    commerce:setFillColor( .6 )
    rewardRow:insert( commerce )

    local name = display.newText({
        text = reward.name, 
        x = 70, y = 10, width = 300,
        font = native.systemFont,   
        fontSize = 19, align = "left"
    })
    name:setFillColor( .3 )
    rewardRow:insert( name )

    if name.height > 25 then
        name.height = 25
        name.text = string.sub(name.text, 0, 30).."..."
        if name.height > 25 then
            name.text = string.sub(name.text, 0, 27).."..."
            if name.height > 25 then
                name.text = string.sub(name.text, 0, 24).."..."
            end
        end
    end

    -- Set value Progress Bar
    if reward.userPoints then
        -- Progress Bar
        local progressBar = display.newRect( 0, 0, 300, 5 )
        progressBar:setFillColor( {
            type = 'gradient',
            color1 = { .6, .5 }, 
            color2 = { 1, .5 },
            direction = "bottom"
        } ) 
        progressBar:translate( 70, 30 )
        rewardRow:insert(progressBar)

        local points = tonumber(reward.points)
        local userPoints = tonumber(reward.userPoints)

        -- Usuario con puntos
        if userPoints > 0 or points == 0  then
            local porcentaje, color1, color2

            -- Todos los puntos                
            if points <= userPoints  then
                porcentaje = 1
                color1 = { 157/255, 210/255, 25/255, 1 }
                color2 = { 140/255, 242/255, 14/255, .3 }
            else
                porcentaje  = userPoints/points
                -- Colores
                if porcentaje <= .33 then
                    color1 = { 210/255, 70/255, 27/255, 1 }
                    color2 = { 242/255, 34/255, 12/255, .3 }
                elseif porcentaje <= .66 then
                    color1 = { 242/255, 112/255, 12/255, 1 }
                    color2 = { 210/255, 141/255, 27/255, .3 }
                elseif porcentaje > .66 then
                    color1 = { 250/255, 214/255, 67/255, 1 }
                    color2 = { 202/255, 127/255, 13/255, .3 }
                end
            end

            local progressBar2 = display.newRect( 0, 0, 300*porcentaje, 5 )
            progressBar2:setFillColor( {
                type = 'gradient',
                color1 = color1, 
                color2 = color2,
                direction = "top"
            } ) 
            progressBar2.anchorX = 0
            progressBar2:translate( -80, 30 )
            rewardRow:insert(progressBar2)
        end
    end 
end

function setCommercePhotos(photos)
    -- yPosc
    if #photos > 0 then
        if #photos == 1 then
            local img = display.newImage( photos[1].image, system.TemporaryDirectory )
            img.anchorY = 0
            img.height = 345
            img.width = 460
            img:translate( midW, yPosc )
            scrViewPa:insert( img )
            
            -- Set new scroll position
            scrViewPa:setScrollHeight( yPosc + 365 )
        else
            local scrViewPhotos = widget.newScrollView
            {
                top = yPosc,
                left = 0,
                width = display.contentWidth,
                height = 260,
                verticalScrollDisabled = true,
                backgroundColor = { .91 }
            }
            scrViewPa:insert(scrViewPhotos)

            for z = 1, #photos, 1 do 
                local img = display.newImage( photos[z].image, system.TemporaryDirectory )
                img.anchorX = 1
                img.anchorY = 0
                img:translate( (z * 330), 10 )
                scrViewPhotos:insert( img )
            end
            
            -- Set new scroll position
            scrViewPhotos:setScrollWidth( (#photos * 330) + 10 )
            scrViewPa:setScrollHeight( yPosc + 280 )
        end
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    local idCommerce = event.params.idCommerce
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
    scrViewPa = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewPa)
    scrViewPa:toBack()
    
    tools:setLoading(true, scrViewPa)
    RestManager.getCommerce(idCommerce)
    
end	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scenes[#Globals.scenes + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene