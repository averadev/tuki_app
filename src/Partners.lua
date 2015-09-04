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
local screen, scrViewP
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight 
local lastX = 0
local txtPName, txtPConcept, lastYP

-- Arrays
local covers, currentP, rowPartner = {}, {}, {}
local txtBg, txtFiltro, fpRows = {}, {}, {}




---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Tap filter event
function tapFilter(event)
    local t = event.target
    if t.bgFP2.alpha == 0 then
        t.bgFP2.alpha = 1
        t.iconOn.alpha = 1
        t.iconOff.alpha = 0
        t.txt:setFillColor( 1 )
    else
        t.bgFP2.alpha = 0
        t.iconOn.alpha = 0
        t.iconOff.alpha = 1
        t.txt:setFillColor( .5 )
    end
end

-- Tap toggle event
function tapFavComer(event)
    local t = event.target
    audio.play( fxFav )
    if t.iconHeart2.alpha == 0 then
        t:setFillColor( 46/255, 190/255, 239/255 )
        t.iconHeart1.alpha = 0
        t.iconHeart2.alpha = 1
        RestManager.setCommerceFav(t.idCommerce, 1)
    else
        t:setFillColor( 236/255 )
        t.iconHeart1.alpha = 1
        t.iconHeart2.alpha = 0
        RestManager.setCommerceFav(t.idCommerce, 0)
    end
    return true
end

-- Tap commerce event
function tapCommerce(event)
    local t = event.target
    audio.play(fxTap)
    storyboard.removeScene( "src.Partner" )
    storyboard.gotoScene("src.Partner", { time = 400, effect = "slideLeft", params = { idCommerce = t.idCommerce } } )
    return true
end

-- ScrollView listener
local function scrollListener( event )
    local t = event.target
    local x, y = t:getContentPosition()
    local elem1, elem2, porc1, porc2
    local midPlus = false
    x = x * -1
    
    for z = 1, #covers, 1 do 
        if x>=((z-1)*200) and x< (z*200) then
            elem1 = z
            elem2 = z + 1
            porc1 =  1 -  ((x - ((z-1)*200)) * .0015)
            porc2 =  .7 + ((x - ((z-1)*200)) * .0015)
            if (x - ((z-1)*200)) > 100 then midPlus = true end
        end
    end
    
    covers[elem1].height = 150 * porc1
    covers[elem1].width = 250 * porc1
    covers[elem1].childs[1].height = 150 * porc1
    covers[elem1].childs[1].width = 250 * porc1
    covers[elem1].childs[2].height = 75 * porc1
    covers[elem1].childs[2].width = 250 * porc1
    covers[elem1].childs[4].height = 150 * porc1
    covers[elem1].childs[4].width = 150 * porc1

    covers[elem2].height = 150 * porc2
    covers[elem2].width = 250 * porc2
    covers[elem2].childs[1].height = 150 * porc2
    covers[elem2].childs[1].width = 250 * porc2
    covers[elem2].childs[2].height = 75 * porc2
    covers[elem2].childs[2].width = 250 * porc2
    covers[elem2].childs[4].height = 150 * porc2
    covers[elem2].childs[4].width = 150 * porc2

    if midPlus and covers[elem1].active then
        covers[elem1].active = false
        covers[elem2].active = true
        txtPName.text = covers[elem2].name
        txtPConcept.text = covers[elem2].concept
        covers[elem2]:toFront()
        covers[elem1].childs[5].alpha = .3
        covers[elem2].childs[5].alpha = 0
    elseif not(midPlus) and covers[elem2].active then
        covers[elem2].active = false
        covers[elem1].active = true
        txtPName.text = covers[elem1].name
        txtPConcept.text = covers[elem1].concept
        covers[elem1]:toFront()
        covers[elem2].childs[5].alpha = .3
        covers[elem1].childs[5].alpha = 0
    end
    if midPlus then 
        covers[elem1].childs[5].height = 150 * porc1
        covers[elem1].childs[5].width = 250 * porc1
    else
        covers[elem2].childs[5].height = 150 * porc2
        covers[elem2].childs[5].width = 250 * porc2
    end
    
    return true
end

-- Crea el coverflow de comercios destacados
function getCoverFirstFlow(obj)
    
    local scrViewPD = widget.newScrollView
    {
        top = 120,
        left = 10,
        width = display.contentWidth - 20,
        isBounceEnabled = false,
        height = 150,
        friction = 0,
        verticalScrollDisabled = true,
        listener = scrollListener,
        backgroundColor = { 1 } 
    }
    scrViewP:insert(scrViewPD)
    
    -- Get first covers
    for z = 1, #obj.items, 1 do 
        createCover(scrViewPD, obj.items[z])
    end
    -- Set new scroll position
    scrViewPD:setScrollWidth((200 * #obj.items) + 258)
    
    covers[1]:toFront()
    covers[1].active = true
    covers[1].height = 150
    covers[1].width = 250
    covers[1].childs[1].height = 150
    covers[1].childs[1].width = 250
    covers[1].childs[2].height = 75
    covers[1].childs[2].width = 250
    covers[1].childs[4].height = 150
    covers[1].childs[4].width = 150
    covers[1].childs[5].alpha = 0
    
    -- Textos informativos
    txtPName = display.newText({
        text = covers[1].name,     
        x = midW, y = 290, width = 440,
        font = native.systemFontBold,   
        fontSize = 26, align = "center"
    })
    txtPName:setFillColor( .3 )
    scrViewP:insert(txtPName)

    txtPConcept = display.newText({
        text = covers[1].concept,     
        x = midW, y = 315, width = 440,
        font = native.systemFont,   
        fontSize = 20, align = "center"
    })
    txtPConcept:setFillColor( .68 )
    scrViewP:insert(txtPConcept)
    
end

-- Creamos un cover
function createCover(parent, partner)
    local idx = #covers + 1
    
    covers[idx] = display.newContainer( 175, 105 )
    covers[idx].active = false
    covers[idx]:translate( 40 + (idx * 200), 75 )
    covers[idx].childs = {}
    covers[idx].name = partner.name
    covers[idx].concept = partner.description
    covers[idx].idCommerce = partner.id
    covers[idx]:addEventListener( 'tap', tapCommerce)
    parent:insert( covers[idx] )
    
    covers[idx].childs[1] = display.newRoundedRect(0, 0, 175, 105, 10 )
    covers[idx].childs[1]:setFillColor( tonumber(partner.colorB1)/255, tonumber(partner.colorB2)/255, tonumber(partner.colorB3)/255 )
    covers[idx]:insert( covers[idx].childs[1] )
    
    covers[idx].childs[2] = display.newRoundedRect(0, 0, 175, 52, 10 )
    covers[idx].childs[2].anchorY = 0
    covers[idx].childs[2]:setFillColor( tonumber(partner.colorA1)/255, tonumber(partner.colorA2)/255, tonumber(partner.colorA3)/255 )
    covers[idx]:insert( covers[idx].childs[2] )
    
    local vertices = { -150,20, 150,20, 150,60, 0,100, -150,60 }
    covers[idx].childs[3] = display.newPolygon( 0, 5, vertices )
    covers[idx].childs[3]:setFillColor( tonumber(partner.colorB1)/255, tonumber(partner.colorB2)/255, tonumber(partner.colorB3)/255 )
    covers[idx]:insert( covers[idx].childs[3] )
    
    covers[idx].childs[4] = display.newImage( partner.image, system.TemporaryDirectory )
    covers[idx].childs[4].height = 105
    covers[idx].childs[4].width = 105
    covers[idx].childs[4]:translate( 0, 0 )
    covers[idx]:insert( covers[idx].childs[4] )
    
    covers[idx].childs[5] = display.newRoundedRect(0, 0, 175, 105, 10 )
    covers[idx].childs[5]:setFillColor( 0 )
    covers[idx].childs[5].alpha = .3
    covers[idx]:insert( covers[idx].childs[5] )
    
end

-- Creamos lista de comercios
function setListCommerce(items)
    lastYP = 290
    
    for z = 1, #items, 1 do 
        rowPartner[z] = display.newContainer( 480, 110 )
        rowPartner[z]:translate( midW, lastYP + (110*z) )
        scrViewP:insert( rowPartner[z] )
        
        local bg1 = display.newRect( 0, 0, 460, 100 )
        bg1:setFillColor( .91 )
        rowPartner[z]:insert( bg1 )
        
        local bg2 = display.newRect( 0, 0, 456, 96 )
        bg2:setFillColor( 1 )
        bg2.idCommerce = items[z].id
        bg2:addEventListener( 'tap', tapCommerce)
        rowPartner[z]:insert( bg2 )
        
        local bgFav = display.newRect( -200, 0, 60, 100 )
        bgFav:setFillColor( .91 )
        bgFav.idCommerce = items[z].id
        bgFav:addEventListener( 'tap', tapFavComer)
        rowPartner[z]:insert( bgFav )
        
        bgFav.iconHeart1 = display.newImage("img/icon/iconRewardHeart1.png")
        bgFav.iconHeart1:translate( -200, 0 )
        rowPartner[z]:insert( bgFav.iconHeart1 )
        
        bgFav.iconHeart2 = display.newImage("img/icon/iconRewardHeart2.png")
        bgFav.iconHeart2:translate( -200, 0 )
        rowPartner[z]:insert( bgFav.iconHeart2 )
        
        -- Fav actions
        if items[z].id == items[z].fav  then
            bgFav:setFillColor( 46/255, 190/255, 239/255 )
            bgFav.iconHeart1.alpha = 0
        else
            bgFav.iconHeart2.alpha = 0
        end
        
        local bgImg = display.newRect( -120, 0, 100, 100 )
        bgImg:setFillColor( tonumber(items[z].colorA1)/255, tonumber(items[z].colorA2)/255, tonumber(items[z].colorA3)/255 )
        rowPartner[z]:insert( bgImg )
        
        local img = display.newImage( items[z].image, system.TemporaryDirectory )
        img:translate( -120, 0 )
        img.width = 90
        img.height = 90
        rowPartner[z]:insert( img )
        
        local name = display.newText({
            text = items[z].name,     
            x = 80, y = -15, width = 270, 
            font = native.systemFont,   
            fontSize = 24, align = "left"
        })
        name:setFillColor( .3 )
        rowPartner[z]:insert( name )
        
        local concept = display.newText({
            text = items[z].description, 
            x = 80, y = 15, width = 270, 
            font = native.systemFont,   
            fontSize = 20, align = "left"
        })
        concept:setFillColor( .68 )
        rowPartner[z]:insert( concept )
        
    end
    -- Set new scroll position
    scrViewP:setScrollHeight(lastYP + (110 * #items) + 70)
    tools:setLoading(false)
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------
function scene:createScene( event )
	screen = self.view
    
    tools = Tools:new()
    tools:buildHeader()
    tools:buildNavBar()
    tools:buildBottomBar()
    screen:insert(tools)
    
    local initY = h + 140 -- inicio en Y del worksite
    local hWorkSite = intH - (h + 220)
    
    scrViewP = widget.newScrollView
	{
		top = initY,
		left = 0,
		width = display.contentWidth,
		height = hWorkSite,
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	screen:insert(scrViewP)
    scrViewP:toBack()
    
    tools:getFilters(scrViewP)
    tools:setLoading(true, scrViewP)
    RestManager.getCommerceFlow()
    RestManager.getCommerces()
    
    
    
    --getCoverFirstFlow()
    
    
    --tools:setLoading(true, scrViewP)
    --filterReward()
    --RestManager.getRewards()
    
    --filterPartner()
    --currentP = partnerFav
    --setListPartner()
    
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