---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
local widget = require( "widget" )
local Globals = require( "src.Globals" )
local composer = require( "composer" )
local RestManager = require( "src.RestManager" )
local fxTap = audio.loadSound( "fx/click.wav")
local fxFav = audio.loadSound( "fx/fav.wav")
local fxJoined = audio.loadSound( "fx/join.wav")

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local scrViewPa, tools
local yPosc = 0
local idxPartner, usrPoints, grpSucursales

-- Arrays

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Consultar comercio
-- @param event objeto evento
------------------------------------
function tapReward(event)
    local t = event.target
    audio.play(fxTap)
    composer.removeScene( "src.Reward" )
    composer.gotoScene("src.Reward", { time = 400, effect = "slideLeft", params = { idReward = t.idReward } } )
    return true
end

-------------------------------------
-- Consultar comercio
-- @param event objeto evento
------------------------------------
function readyJoined(idCommerce)
    tools:animate()
    timer.performWithDelay( 250, function() audio.play(fxJoined) end )
    timer.performWithDelay( 3000, function() 
        table.remove( Globals.scenes )
        composer.removeScene( "src.Partner" )
        composer.gotoScene("src.Partner", { params = { idCommerce = idxPartner } } )
    end )
    return true
end

-------------------------------------
-- Fav a la recompensa
-- @param event objeto evento
------------------------------------
function tapComRewFav(event)
    local t = event.target
    audio.play( fxFav )
    if t.iconHeart1.alpha == 0  then
        t.iconHeart1.alpha = 1
        t.iconHeart2.alpha = 0
        RestManager.setRewardFav(t.idReward, 0)
    else
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
        RestManager.setRewardFav(t.idReward, 1)
    end
    return true
end

-------------------------------------
-- Abrimos URL
-- @param event objeto evento
------------------------------------
function openUrl(event)
    local t = event.target
    audio.play(fxTap)
    system.openURL( t.url )
    return true
end

-------------------------------------
-- Afiliacion del Comercio
-- @param event objeto evento
------------------------------------
function setCommerceJoin(event)
    local t = event.target
    t:removeEventListener( 'tap', setCommerceJoin)
    t.alpha = .7
    RestManager.setCommerceJoin(idxPartner)
    return true
end

-------------------------------------
-- Muestra el bubble de wallet
-- @param wallet number
------------------------------------
function addB(gift)
    myWallet = myWallet + gift
    tools:showBubble(true)
end

function closeSucursales(event)
    grpSucursales.alpha = 0
end

function showSucursales(event)
    grpSucursales.alpha = 1
end

function makeSucursales(items)
    grpSucursales = display.newGroup()
    grpSucursales.alpha = 0
    screen:insert(grpSucursales)
    
    function setDes(event)
        return true
    end
    local bg = display.newRect(midW, midH, intW, intH )
    bg.alpha = .5
    bg:setFillColor( 0 )
    bg:addEventListener( 'tap', setDes )
    grpSucursales:insert(bg)
    
    local bg1 = display.newRoundedRect(midW, midH, 450, 450, 5 )
    bg1:setFillColor( unpack(cTurquesa) )
    grpSucursales:insert(bg1)
    
    local bg2 = display.newRoundedRect(midW, midH, 444, 444, 5 )
    bg2:setFillColor( unpack(cWhite) )
    grpSucursales:insert(bg2)
    
    local lblSuc1 = display.newText({
        text = "TODAS LAS SUCURSALES",     
        x = 220 - 10, y = midH - 205, width = 350,
        font = fontSemiBold,
        fontSize = 20, align = "left"
    })
    lblSuc1.anchorY = 0
    lblSuc1:setFillColor( unpack(cBlueH) )
    grpSucursales:insert(lblSuc1)
    
    local iconClose = display.newImage("img/icon/iconClose.png")
    iconClose:translate(midW + 195, midH - 200)
    iconClose:addEventListener( 'tap', closeSucursales )
    grpSucursales:insert( iconClose )
    
    local scrViewSuc = widget.newScrollView{
		width = 440,
		height = 390,
		horizontalScrollDisabled = true
	}
    scrViewSuc.x = midW
    scrViewSuc.y = midH + 15
	grpSucursales:insert(scrViewSuc)
    
    local sucPosc = -20
    for z = 1, #items, 1 do 
        sucPosc = sucPosc + 110
        local bgTitle1 = display.newRoundedRect( 220, sucPosc - 80, 440, 95, 5 )
        bgTitle1.anchorY = 0
        bgTitle1:setFillColor( unpack(cBTur) )
        scrViewSuc:insert( bgTitle1 )
        local bgTitle2 = display.newRoundedRect( 220, sucPosc - 78, 436, 91, 5 )
        bgTitle2.anchorY = 0
        bgTitle2:setFillColor( unpack(cWhite) )
        scrViewSuc:insert( bgTitle2 )

        local lblSuc1 = display.newText({
            text = items[z].name,     
            x = 220 - 10, y = sucPosc - 70, width = 350,
            font = fontSemiBold,
            fontSize = 15, align = "left"
        })
        lblSuc1.anchorY = 0
        lblSuc1:setFillColor( unpack(cBlueH) )
        scrViewSuc:insert(lblSuc1)

        local lblSuc2 = display.newText({
            text = items[z].address,     
            x = 220 - 60, y = sucPosc - 50, width = 250,
            font = fontRegular,
            fontSize = 14, align = "left"
        })
        lblSuc2.anchorY = 0
        lblSuc2:setFillColor( unpack(cBlueH) )
        scrViewSuc:insert(lblSuc2)
        
        local xtrXpc = 0
        if lblSuc2.height > 25 then
            xtrXpc = 15
        end 

        local lblSuc3 = display.newText({
            text = items[z].city,     
            x = 220 - 60, y = (sucPosc - 30) + xtrXpc, width = 250,
            font = fontRegular,
            fontSize = 14, align = "left"
        })
        lblSuc3.anchorY = 0
        lblSuc3:setFillColor( unpack(cBlueH) )
        scrViewSuc:insert(lblSuc3)

        if items[z].phone == '' or not(items[z].phone) then
            xtrXpc = xtrXpc - 15
        else
            local lblSuc4 = display.newText({
                text = 'Tel: '..items[z].phone,     
                x = 220 - 60, y = (sucPosc - 12) + xtrXpc, width = 250,
                font = fontRegular,
                fontSize = 14, align = "left"
            })
            lblSuc4.anchorY = 0
            lblSuc4:setFillColor( unpack(cBlueH) )
            scrViewSuc:insert(lblSuc4)
        end
        
        bgTitle1.height = bgTitle1.height + xtrXpc
        bgTitle2.height = bgTitle2.height + xtrXpc
        sucPosc = sucPosc + xtrXpc
        
        local midSucPosc = bgTitle1.y + (bgTitle1.height / 2)
        if not (items[z].phone == '' or not(items[z].phone)) then
            local iconComPhone = display.newImage("img/icon/iconComPhone.png")
            iconComPhone:translate( 220 + 110, midSucPosc )
            iconComPhone.url = "tel:"..items[z].phone
            iconComPhone:addEventListener( 'tap', openUrl)
            scrViewSuc:insert( iconComPhone )
        end
        local iconComPosition = display.newImage("img/icon/iconComPosition.png")
        iconComPosition:translate( 220 + 175, midSucPosc )
        scrViewSuc:insert( iconComPosition )
    end
    
    scrViewSuc:setScrollHeight(sucPosc + 20)
    
    return true
end

-------------------------------------
-- Mostramos informacion del comercio
-- @param item comercio
-- @param rewards recompensas
------------------------------------
function setCommerce(item, branchs, rewards)
    tools:setLoading(false)
    
    yPosc = 20
    idxPartner = item.id
    if item.points then
        usrPoints = tonumber(item.points)
    end
    local banner = display.newImage( item.banner, system.TemporaryDirectory )
    banner.anchorY = 0
    banner.height = 280
    banner.width = 440
    banner:translate( midW, yPosc )
    scrViewPa:insert( banner )
    local bottomRounded = display.newImage("img/deco/bottomRounded.png")
    bottomRounded:translate(midW, yPosc + 260)
    scrViewPa:insert( bottomRounded )
    
    local bgBottom = display.newRect(midW, yPosc + 80, 440, 90 )
    bgBottom:setFillColor( 0 )
    bgBottom.alpha = .6
    scrViewPa:insert( bgBottom )
    
    local circleLogo = display.newImage("img/deco/circleLogo.png")
    circleLogo.anchorY = 0
    circleLogo:translate( 107, yPosc + 5 )
    scrViewPa:insert( circleLogo )
    local mask = graphics.newMask( "img/deco/maskLogo.png" )
    local img = display.newImage( item.image, system.TemporaryDirectory )
    img.anchorY = 0
    img.height = 160
    img.width = 160
    img:setMask( mask )
    img:translate( 107, yPosc + 10 )
    scrViewPa:insert( img )
    
    local txtCommerce = display.newText({
        text = item.name,
        y = yPosc + 67,
        x = midW + 90, width = 260,
        font = fontBold,   
        fontSize = 23, align = "left"
    })
    txtCommerce:setFillColor( unpack(cWhite) )
    scrViewPa:insert(txtCommerce)
    local txtCommerceDesc = display.newText({
        text = item.description,
        y = yPosc + 93,
        x = midW + 90, width = 260,
        font = fontLight,   
        fontSize = 18, align = "left"
    })
    txtCommerceDesc:setFillColor( unpack(cWhite) )
    scrViewPa:insert(txtCommerceDesc)
    
    -- Detalle afiliado
    yPosc = yPosc + 290
    if item.points then
        local container = display.newContainer( 440, 114 )
        container.anchorY = 0
        container:translate( midW, yPosc )
        scrViewPa:insert( container )
        
        local bgCom1 = display.newRect(0, -10, intW - 40, 94 )
        bgCom1:setFillColor( unpack(cBTur) )
        container:insert(bgCom1)
        local bgCom2 = display.newRect(0, -10, intW - 44, 90 )
        bgCom2:setFillColor( unpack(cWhite) )
        container:insert(bgCom2)
        local bgCom2 = display.newRect(70, -10, 2, 80 )
        bgCom2:setFillColor( unpack(cGrayXXL) )
        container:insert(bgCom2)

        local bgTuks1 = display.newRoundedRect(-160, 0, 120, 114, 5 )
        bgTuks1:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBTur) }, 
            color2 = { unpack(cBBlu) },
            direction = "top"
        } )
        container:insert(bgTuks1)

        -- Descripciones
        local lblDescT = display.newText({
            text = "TUKS", 
            x = -158, y = 23, width = 70, 
            font = fontSemiBold,   
            fontSize = 23, align = "center"
        })
        lblDescT:setFillColor( 1 )
        container:insert( lblDescT )
        local lblDesc1 = display.newText({
            text = "Recompensas Disponibles", 
            x = -10, y = 10, width = 100, 
            font = fontRegular,   
            fontSize = 14, align = "center"
        })
        lblDesc1:setFillColor( unpack(cBlueH) )
        container:insert( lblDesc1 )
        local lblDesc2 = display.newText({
            text = "Visitas Recientes", 
            x = 145, y = 10, width = 100, 
            font = fontRegular,   
            fontSize = 14, align = "center"
        })
        lblDesc2:setFillColor( unpack(cBlueH) )
        container:insert( lblDesc2 )
        if item.lastVisit then 
            local lblDesc3 = display.newText({
                text = "ULTIMA VISITA:", 
                x = 10, y = 50, width = 200, 
                font = fontSemiBold,   
                fontSize = 14, align = "left"
            })
            lblDesc3:setFillColor( unpack(cBlueH) )
            container:insert( lblDesc3 )
        end 
        --- Valores
        local lblTuks = display.newText({
            text = item.points, 
            x = -158, y = -12, width = 70, 
            font = fontBold,   
            fontSize = 40, align = "center"
        })
        lblTuks:setFillColor( 1 )
        container:insert( lblTuks )
        local lblValue0 = display.newText({
            text = item.avaliable, 
            x = -90, y = -30, width = 150, 
            font = fontBold,   
            fontSize = 40, align = "right"
        })
        lblValue0:setFillColor( unpack(cBlueH) )
        container:insert( lblValue0 )
        local lblValue1 = display.newText({
            text = "/"..item.rewards, 
            x = 65, y = -25, width = 150, 
            font = fontRegular,   
            fontSize = 25, align = "left"
        })
        lblValue1:setFillColor( unpack(cGrayH) )
        container:insert( lblValue1 )
        local lblValue2 = display.newText({
            text = item.visits, 
            x = 140, y = -30, width = 150, 
            font = fontBold,   
            fontSize = 40, align = "center"
        })
        lblValue2:setFillColor( unpack(cBlueH) )
        container:insert( lblValue2 )
        if item.lastVisit then 
            local lblValue3 = display.newText({
                text = item.lastVisit, 
                x = 120, y = 50, width = 200, 
                font = fontRegular,   
                fontSize = 14, align = "left"
            })
            lblValue3:setFillColor( unpack(cBlueH) )
            container:insert( lblValue3 )
        end
        yPosc = yPosc + 125
    end
    
    -- Description
    yPosc = yPosc
    local txtCommerceDetail = display.newText({
        text = item.detail,
        y = yPosc + 10,
        x = midW, width = 420,
        font = fontLight,   
        fontSize = 18, align = "left"
    })
    txtCommerceDetail.anchorY = 0
    txtCommerceDetail:setFillColor( unpack(cBlueH) )
    scrViewPa:insert(txtCommerceDetail)
    yPosc = yPosc + txtCommerceDetail.height
    
    -- Afiliarse
    if not(item.points) then
        yPosc = yPosc + 75
        local bgRedem = display.newRoundedRect( midW, yPosc - 20, 440, 60, 5 )
        bgRedem:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBTur) }, 
            color2 = { unpack(cBBlu) },
            direction = "top"
        } )
        bgRedem:addEventListener( 'tap', setCommerceJoin)
        scrViewPa:insert(bgRedem)
        local lblRedem = display.newText({
            text = "¡ AFILIATE AHORA !", 
            x = midW , y = yPosc - 20,
            font = fontBold,
            fontSize = 26, align = "center"
        })
        lblRedem:setFillColor( unpack(cWhite) )
        scrViewPa:insert( lblRedem )
    end
    
    -- Branch's
    local maxR = #branchs
    if maxR > 4 then
        maxR = 4
    end
    for z = 1, maxR, 1 do 
        yPosc = yPosc + 110
        local bgTitle1 = display.newRoundedRect( midW, yPosc - 80, 440, 95, 5 )
        bgTitle1.anchorY = 0
        bgTitle1:setFillColor( unpack(cBTur) )
        scrViewPa:insert( bgTitle1 )
        local bgTitle2 = display.newRoundedRect( midW, yPosc - 78, 436, 91, 5 )
        bgTitle2.anchorY = 0
        bgTitle2:setFillColor( unpack(cWhite) )
        scrViewPa:insert( bgTitle2 )

        local lblSuc1 = display.newText({
            text = branchs[z].name,     
            x = midW - 10, y = yPosc - 70, width = 350,
            font = fontSemiBold,
            fontSize = 15, align = "left"
        })
        lblSuc1.anchorY = 0
        lblSuc1:setFillColor( unpack(cBlueH) )
        scrViewPa:insert(lblSuc1)

        local lblSuc2 = display.newText({
            text = branchs[z].address,     
            x = midW - 60, y = yPosc - 50, width = 250,
            font = fontRegular,
            fontSize = 14, align = "left"
        })
        lblSuc2.anchorY = 0
        lblSuc2:setFillColor( unpack(cBlueH) )
        scrViewPa:insert(lblSuc2)
        
        local xtrXpc = 0
        if lblSuc2.height > 25 then
            xtrXpc = 15
        end 

        local lblSuc3 = display.newText({
            text = branchs[z].city,     
            x = midW - 60, y = (yPosc - 30) + xtrXpc, width = 250,
            font = fontRegular,
            fontSize = 14, align = "left"
        })
        lblSuc3.anchorY = 0
        lblSuc3:setFillColor( unpack(cBlueH) )
        scrViewPa:insert(lblSuc3)

        if branchs[z].phone == '' or not(branchs[z].phone) then
            xtrXpc = xtrXpc - 15
        else
            local lblSuc4 = display.newText({
                text = 'Tel: '..branchs[z].phone,     
                x = midW - 60, y = (yPosc - 12) + xtrXpc, width = 250,
                font = fontRegular,
                fontSize = 14, align = "left"
            })
            lblSuc4.anchorY = 0
            lblSuc4:setFillColor( unpack(cBlueH) )
            scrViewPa:insert(lblSuc4)
        end
        
        bgTitle1.height = bgTitle1.height + xtrXpc
        bgTitle2.height = bgTitle2.height + xtrXpc
        yPosc = yPosc + xtrXpc
        
        local midSucPosc = bgTitle1.y + (bgTitle1.height / 2)
        if not (branchs[z].phone == '' or not(branchs[z].phone)) then
            local iconComPhone = display.newImage("img/icon/iconComPhone.png")
            iconComPhone:translate( midW + 110, midSucPosc )
            iconComPhone.url = "tel:"..branchs[z].phone
            iconComPhone:addEventListener( 'tap', openUrl)
            scrViewPa:insert( iconComPhone )
        end
        local iconComPosition = display.newImage("img/icon/iconComPosition.png")
        iconComPosition:translate( midW + 175, midSucPosc )
        scrViewPa:insert( iconComPosition )
    end
    -- Additionals branchs
    if #branchs > 4 then
        local bgMore = display.newRoundedRect( midW, yPosc + 50, 200, 45, 5 )
        bgMore:setFillColor( {
            type = 'gradient',
            color1 = { unpack(cBTur) }, 
            color2 = { unpack(cBBlu) },
            direction = "top"
        } )
        bgMore:addEventListener( 'tap', showSucursales)
        scrViewPa:insert( bgMore )
        
        local lblSuc1 = display.newText({
            text = "Ver mas sucursales...",     
            x = midW, y = yPosc + 50, width = 180,
            font = fontSemiBold,
            fontSize = 15, align = "center"
        })
        lblSuc1:setFillColor( unpack(cWhite) )
        scrViewPa:insert(lblSuc1)
        
        makeSucursales(branchs)
        
        yPosc = yPosc + 60
    end
    
    -- Social Buttons
    local posSoc = 0
    local socials = {}
    if not (item.facebook == '' or not(item.facebook)) then
        posSoc = posSoc + 1
        socials[posSoc] = display.newImage("img/icon/socialFB.png")
        socials[posSoc].url = item.facebook
        socials[posSoc]:addEventListener( 'tap', openUrl)
        scrViewPa:insert( socials[posSoc] )
    end
    if not (item.twitter == '' or not(item.twitter)) then
        posSoc = posSoc + 1
        socials[posSoc] = display.newImage("img/icon/socialTwitter.png")
        socials[posSoc].url = item.twitter
        socials[posSoc]:addEventListener( 'tap', openUrl)
        scrViewPa:insert( socials[posSoc] )
    end
    if not (item.web == '' or not(item.web)) then
        posSoc = posSoc + 1
        socials[posSoc] = display.newImage("img/icon/socialWeb.png")
        socials[posSoc].url = item.web
        socials[posSoc]:addEventListener( 'tap', openUrl)
        scrViewPa:insert( socials[posSoc] )
    end
    if not (item.email == '' or not(item.email)) then
        posSoc = posSoc + 1
        socials[posSoc] = display.newImage("img/icon/socialEmail.png")
        socials[posSoc].url = '"mailto:'..item.email
        socials[posSoc]:addEventListener( 'tap', openUrl)
        scrViewPa:insert( socials[posSoc] )
    end
    if #socials > 0 then
        yPosc = yPosc + 60
        if #socials == 1 then
            socials[1]:translate(midW, yPosc)
        elseif #socials == 2 then
            socials[1]:translate(midW-60, yPosc)
            socials[2]:translate(midW+60, yPosc)
        elseif #socials == 3 then
            socials[1]:translate(midW-120, yPosc)
            socials[2]:translate(midW, yPosc)
            socials[3]:translate(midW+120, yPosc)
        elseif #socials == 4 then
            socials[1]:translate(midW-180, yPosc)
            socials[2]:translate(midW+60, yPosc)
            socials[3]:translate(midW-60, yPosc)
            socials[4]:translate(midW+180, yPosc)
        end
    end 
    
    yPosc = yPosc + 70
    local bgTitle1 = display.newRect( midW, yPosc, 440, 50 )
    bgTitle1:setFillColor( unpack(cBTur) )
    scrViewPa:insert( bgTitle1 )
    local bgTitle1 = display.newRect( midW, yPosc, 436, 46 )
    bgTitle1:setFillColor( unpack(cWhite) )
    scrViewPa:insert( bgTitle1 )
    
    local iconGiftMin = display.newImage("img/icon/iconGiftMin.png")
    iconGiftMin:translate( midW - 175, yPosc)
    scrViewPa:insert( iconGiftMin )

    local lblTitle1 = display.newText({
        text = "RECOMPENSAS DISPONIBLES",     
        x = midW - 20, y = yPosc, width = 230,
        font = fontRegular,
        fontSize = 15, align = "left"
    })
    lblTitle1:setFillColor( unpack(cBlueH) )
    scrViewPa:insert(lblTitle1)
    
    yPosc = yPosc + 80
    for z = 1, #rewards, 1 do 
        newReward(rewards[z], yPosc, item.points)
        yPosc = yPosc + 95
    end
    
    -- Set new scroll position
    scrViewPa:setScrollHeight( yPosc )
end

-- Creamos lista de comercios
function newReward(reward, lastYP, cpoints)
    
    container = display.newContainer( 462, 95 )
    container:translate( midW, lastYP )
    scrViewPa:insert( container )

    local bg2 = display.newRect(0, 0, intW - 24, 76 )
    bg2:setFillColor( unpack(cWhite) )
    container:insert( bg2 )
    bg2.idReward = reward.id
    bg2:addEventListener( 'tap', tapReward)

    local bgFav = display.newRect(205, 0, 40, 74 )
    bgFav:setFillColor( unpack(cWhite) )
    container:insert( bgFav )
    bgFav.idReward = reward.id
    bgFav:addEventListener( 'tap', tapComRewFav)

    bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
    bgFav.iconHeart1:translate( 205, 0 )
    container:insert( bgFav.iconHeart1 )

    bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
    bgFav.iconHeart2:translate( 205, 0 )
    container:insert( bgFav.iconHeart2 )

    -- Fav actions
    if reward.id == reward.fav  then
        bgFav.id = reward.id 
        bgFav.iconHeart1.alpha = 0
    else
        bgFav.iconHeart2.alpha = 0
    end
    
    local bgPoints = display.newImage("img/deco/bgPoints80.png")
    bgPoints:translate( -180, 0 )
    container:insert( bgPoints )

    -- Textos y descripciones
    if reward.points == 0 or reward.points == "0" then
        local points = display.newText({
            text = "GRATIS", 
            x = -180, y = 0,
            font = fontSemiBold,   
            fontSize = 18, align = "center"
        })
        points:rotate( -45 )
        points:setFillColor( 1 )
        container:insert( points )
    else
        local points = display.newText({
            text = reward.points, 
            x = -180, y = -12,
            font = fontBold,   
            fontSize = 32, align = "center"
        })
        points:setFillColor( 1 )
        container:insert( points )
        local points2 = display.newText({
            text = "TUKS", 
            x = -180, y = 13,
            font = fontSemiBold,   
            fontSize = 16, align = "center"
        })
        points2:setFillColor( 1 )
        container:insert( points2 )
    end

    local name = display.newText({
        text = reward.name, 
        x = 20, y = 0, width = 280,
        font = fontRegular,   
        fontSize = 19, align = "left"
    })
    name:setFillColor( unpack(cBlueH) )
    container:insert( name )

    -- Set value Progress Bar
    if usrPoints then
        -- Progress Bar
        local progressBar = display.newRect( -50, 0, 300, 7 )
        progressBar:setFillColor( {
            type = 'gradient',
            color1 = { .6, .5 }, 
            color2 = { 1, .5 },
            direction = "bottom"
        } ) 
        progressBar:translate( 70, 30 )
        container:insert(progressBar)

        local points = tonumber(reward.points)
        -- Usuario con puntos
        if usrPoints > 0 or points == 0  then
            local porcentaje, color1, color2

            -- Todos los puntos                
            if points <= usrPoints  then
                porcentaje = 1
            else
                porcentaje  = usrPoints/points
            end

            local progressBar2 = display.newRect( -50, 0, 300*porcentaje, 7 )
            progressBar2:setFillColor( {
                type = 'gradient',
                color1 = { unpack(cBTur) }, 
                color2 = { unpack(cBBlu) },
                direction = "top"
            } ) 
            progressBar2.anchorX = 0
            progressBar2:translate( -80, 30 )
            container:insert(progressBar2)
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
            img:translate( midW, yPosc - 30 )
            scrViewPa:insert( img )
            
            -- Set new scroll position
            scrViewPa:setScrollHeight( yPosc + 335 )
        else
            scrViewPhotos = widget.newScrollView
            {
                top = yPosc - 30,
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
            scrViewPa:setScrollHeight( yPosc + 260 )
        end
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:create( event )
	screen = self.view
    local idCommerce = event.params.idCommerce
    
	tools = Tools:new()
    tools:buildHeader()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 60 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 120)
    
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
function scene:show( event )
    if event.phase == "will" then 
        tools:showBubble(false)
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
    end
end

-- Remove Listener
function scene:destroy( event )
    if scrViewPhotos then
        scrViewPhotos:removeSelf()
        scrViewPhotos = nil;
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene