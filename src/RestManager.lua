---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
    local DBManager = require('src.DBManager')
    local dbConfig = DBManager.getSettings()

    local site = "http://tukicard.com/beta_ws/"
    --local site = "http://mytuki.com/api/"
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end

    function reloadConfig()
        dbConfig = DBManager.getSettings()
    end

    -- Envia al metodo
    function goToMethod(obj)
        if obj.name == "HomeCommerces" then
            getCarCom(obj.items)
        elseif obj.name == "HomeRewards" then
            buildCardsR(obj.items)
        elseif obj.name == "ListWelcome" then
            setListWelcome(obj.items)
        elseif obj.name == "AccountCommerces" then
            showAccountCom(obj.items)
        elseif obj.name == "Reward" then
            setReward(obj.items[1])
        elseif obj.name == "RewardLogo" then
            setRewardLogo(obj.items[1])
        elseif obj.name == "CommerceFlow" then
            getCoverFirstFlow(obj)
        elseif obj.name == "Commerces" then
            setListCommerce(obj.items)
        elseif obj.name == "Commerce" then
            setCommerce(obj.items[1], obj.branchs, obj.rewards)
            if #obj.photos > 0 then
                loadImage({idx = 0, name = "CommercePhotos", path = "assets/img/api/commerce/photos/", items = obj.photos})
            end
        elseif obj.name == "CommercePhotos" then
            setCommercePhotos(obj.items)
        elseif obj.name == "Wallet" then
            setListWallet(obj.items)
        elseif obj.name == "WalletLogos" then
            setWalletLogos(obj.items)
        elseif obj.name == "Messages" then
            setListMessages(obj.items)
        elseif obj.name == "Message" then
            setMessage(obj.items[1])
        elseif obj.name == "RetriveQR" then
            local item = obj.items[1]
            local mask = graphics.newMask( "img/deco/qrMask.jpg" )
            local imagen = display.newImage( item.image, system.TemporaryDirectory )
            item.parent:insert(imagen)
            imagen:setMask( mask )
            imagen.width = item.w
            imagen.height = item.h
            imagen:translate(item.x, item.y)
        end
    end 

    -- Carga de la imagen del servidor o de TemporaryDirectory
    function loadImage(obj)
        -- Next Image
        if obj.idx < #obj.items then
            -- Add to index
            obj.idx = obj.idx + 1
            -- Determinamos si la imagen existe
            if obj.items[obj.idx].image then
                local img = obj.items[obj.idx].image
                local path = system.pathForFile( img, system.TemporaryDirectory )
                local fhd = io.open( path )
                if fhd then
                    fhd:close()
                    loadImage(obj)
                else
                    local function imageListener( event )
                        if ( event.isError ) then
                        else
                            event.target:removeSelf()
                            event.target = nil
                            loadImage(obj)
                        end
                    end
                    -- Descargamos de la nube
                    display.loadRemoteImage( site..obj.path..img, "GET", imageListener, img, system.TemporaryDirectory ) 
                end
            else
                loadImage(obj)
            end
        else
            -- Dirigimos al metodo pertinente
            goToMethod(obj)
        end
    end

    -- Carga de la imagen del servidor o de TemporaryDirectory
    function retriveImage(img, url, parent, x, y, w, h, isMenu)
        -- Next Image
        local path = system.pathForFile( img, system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
            local sizeMask = 'maskLogo100.png'
            if w == 120 then
                sizeMask = 'maskLogo120.png'
            end
            local mask = graphics.newMask( "img/deco/"..sizeMask )
            local imagen = display.newImage( img, system.TemporaryDirectory )
            parent:insert(imagen)
            imagen:setMask( mask )
            imagen.width = w
            imagen.height = h
            imagen:translate(x, y)
            return true;
        else
            local function imageListener( event )
                if ( event.isError ) then
                else
                    local sizeMask = 'maskLogo100.png'
                    if w == 120 then
                        sizeMask = 'maskLogo120.png'
                    end
                    local mask = graphics.newMask( "img/deco/"..sizeMask )
                    parent:insert(event.target)
                    event.target:setMask( mask )
                    event.target.width = w
                    event.target.height = h
                    event.target:translate(x, y)
                    if isMenu then getFrameFB(x, y) end
                end
            end
            -- Descargamos de la nube
            display.loadRemoteImage( url, "GET", imageListener, img, system.TemporaryDirectory ) 
            return false;
        end
    end

    RestManager.retriveQR = function(key, parent, x, y, w, h)
        -- Verificamos si existe el codigo
        local path = system.pathForFile( key..".png", system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
            local mask = graphics.newMask( "img/deco/qrMask.jpg" )
            local imagen = display.newImage( key..".png", system.TemporaryDirectory )
            parent:insert(imagen)
            imagen:setMask( mask )
            imagen.width = w
            imagen.height = h
            imagen:translate(x, y)
        else
            -- Solicitamos el codigo
            local url = site.."mobile/getQR/"..key
            local function callback(event)
                if ( event.isError ) then
                else
                    -- Almacenamos QR
                    local data = {}
                    data[1] = {
                        image = key..".png",
                        parent = parent,
                        w = w, h = h, x = x, y = y
                    }
                    loadImage({idx = 0, name = "RetriveQR", path = "assets/img/api/qr/", items = data})
                end
                return true
            end
            -- Do request
            network.request( url, "GET", callback )
        end
	end

    RestManager.getQR = function(key)
        -- Verificamos si existe el codigo
        local key = dbConfig.id
        local path = system.pathForFile( key..".png", system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
        else
            -- Solicitamos el codigo
            local url = site.."mobile/getQR/"..key
            local function callback(event)
                if ( event.isError ) then
                else
                    -- Almacenamos QR
                    local data = {}
                    data[1] = {image = key..".png"}
                    loadImage({idx = 0, name = "", path = "assets/img/api/qr/", items = data})
                end
                return true
            end
            -- Do request
            network.request( url, "GET", callback )
        end
	end

    RestManager.validateUser = function(email, pass)
		local url = site.."mobile/validateUser/format/json/email/"..urlencode(email).."/password/"..urlencode(pass)
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
                    DBManager.updateUser(data.user)
                    if tonumber(data.user.totalCom) == 0 then
                        toLoginUser(true)
                    else
                        toLoginUser(false)
                    end
                else
                    native.showAlert( "TUKI", 'El email y/o password es incorrecto.', { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.createUser = function(email, pass)
		local url = site.."mobile/createUser/format/json/email/"..urlencode(email).."/password/"..urlencode(pass)
        local deviceID = system.getInfo( "deviceID" )
        url = url.."/deviceID/"..urlencode(deviceID)
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
                    DBManager.updateUser(data.user)
                    toLoginUser(true)
                else
                    native.showAlert( "TUKI", 'El email ya se encuentra ligado a una cuenta.', { "OK"})
                end
            end
            return true
        end
        -- Do request
        
        network.request( url, "GET", callback )
	end

    RestManager.createUserFB = function(fbid, fbName, fbFirstName, fbLastName, 
                fbAgeMin, fbAgeMax, fbGender, fbLocale, fbTimezone, fbEmail )
		local url = site.."mobile/createUserFB/format/json/fbid/"..fbid
        if not(fbName == '') then url = url.."/name/"..urlencode(fbName) end
        if not(fbFirstName == '') then url = url.."/firstName/"..urlencode(fbFirstName) end
        if not(fbLastName == '') then url = url.."/lastName/"..urlencode(fbLastName) end
        if not(fbAgeMin == '') then url = url.."/ageMin/"..urlencode(fbAgeMin) end
        if not(fbAgeMax == '') then url = url.."/ageMax/"..urlencode(fbAgeMax) end
        if not(fbGender == '') then url = url.."/gender/"..urlencode(fbGender) end
        if not(fbLocale == '') then  url = url.."/locale/"..fbLocale end
        if not(fbTimezone == '') then url = url.."/timezone/"..urlencode(fbTimezone) end
        if not(fbEmail == '') then url = url.."/email/"..urlencode(fbEmail) end
        
        local deviceID = system.getInfo( "deviceID" )
        url = url.."/deviceID/"..urlencode(deviceID)
    
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
                    DBManager.updateUser(data.user)
                    if tonumber(data.user.totalCom) == 0 then
                        toLoginFB(true)
                    else
                        toLoginFB(false)
                    end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.updateOneSignalId = function(oneSignalId)
		local url = site.."mobile/updateOneSignalId/format/json/oneSignalId/"..oneSignalId.."/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getHomeRewards = function()
		local url = site.."mobile/getHomeRewards/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                local wallet = tonumber(data.wallet)
                local message = tonumber(data.message)
                showB(wallet, message)
                loadImage({idx = 0, name = "HomeCommerces", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        print(url)
        network.request( url, "GET", callback )
	end

    RestManager.getAccount = function()
		local url = site.."mobile/getAccount/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                showAccount(data.user)
                loadImage({idx = 0, name = "AccountCommerces", path = "assets/img/api/commerce/", items = data.user.joined})
            end
            return true
        end
        -- Do request
        
        network.request( url, "GET", callback )
	end

    RestManager.getProfile = function()
		local url = site.."mobile/getProfile/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                showProfile(data.user)
            end
            return true
        end
        -- Do request
        print(url)
        network.request( url, "GET", callback )
	end

    RestManager.updateProfile = function(email, phone, gender, birthDate)
		local url = site.."mobile/updateProfile/format/json/idUser/"..dbConfig.id.."/email/"..urlencode(email).."/phone/"..phone
        if not(gender == '') then
            url = url.."/gender/"..gender
        end
        if not(birthDate == '') then
            url = url.."/birthDate/"..birthDate
        end
        
        local function callback(event)
            if ( event.isError ) then
            else
                isUpdProfile()
            end
            return true
        end
        -- Do request
        print(url)
        network.request( url, "GET", callback )
	end

    RestManager.getPointsBar = function()
		local url = site.."mobile/getPointsBar/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                getPointsBar(data)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommercesByGPS = function(latitude, longitude)
		local url = site.."mobile/getCommercesByGPS/format/json/latitude/"..latitude.."/longitude/"..longitude
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "ListWelcome", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommercesByGPSLite = function(latitude, longitude)
		local url = site.."mobile/getCommercesByGPSLite/format/json/latitude/"..latitude.."/longitude/"..longitude
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                setIconMap(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    
    RestManager.getCommercesWCat = function(filters)
		local url = site.."mobile/getCommercesWCat/format/json/filters/"..filters
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "ListWelcome", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getRewards = function(filters)
		local url = site.."mobile/getRewards/format/json/idUser/"..dbConfig.id.."/filters/"..filters
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                setListReward(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.setRewardFav = function(idReward, isFav)
		local url = site.."mobile/setRewardFav/format/json/idUser/"..dbConfig.id.."/idReward/"..idReward.."/isFav/"..isFav
        
        local function callback(event)
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    
    RestManager.getRewardFavs = function(filters)
		local url = site.."mobile/getRewardFavs/format/json/idUser/"..dbConfig.id.."/filters/"..filters
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                setListReward(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getReward = function(idReward)
		local url = site.."mobile/getReward/format/json/idUser/"..dbConfig.id.."/idReward/"..idReward
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Reward", path = "assets/img/api/rewards/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.isGiftRedem = function(idReward)
		local url = site.."mobile/isGiftRedem/format/json/idUser/"..dbConfig.id.."/idReward/"..idReward
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
                    isRedem()
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommerces = function(filters)
		local url = site.."mobile/getCommerces/format/json/idUser/"..dbConfig.id.."/filters/"..filters
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Commerces", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.multipleJoin = function(idx)
        dbConfig = DBManager.getSettings()
		local url = site.."mobile/multipleJoin/format/json/idUser/"..dbConfig.id.."/idComms/"..idx
        local deviceID = system.getInfo( "deviceID" )
        url = url.."/deviceID/"..urlencode(deviceID)
        
        local function callback(event)
            local data = json.decode(event.response)
            if data.success then
                DBManager.updateAfiliated(1)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getJoined = function(filters)
		local url = site.."mobile/getJoined/format/json/idUser/"..dbConfig.id.."/filters/"..filters
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Commerces", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommerceFlow = function()
		local url = site.."mobile/getCommerceFlow/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if #data.items > 3 then
                    loadImage({idx = 0, name = "CommerceFlow", path = "assets/img/api/commerce/", items = data.items})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.setCommerceFav = function(idCommerce, isFav)
		local url = site.."mobile/setCommerceFav/format/json/idUser/1/idCommerce/"..idCommerce.."/isFav/"..isFav
        
        local function callback(event)
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.setCommerceJoin = function(idCommerce)
		local url = site.."mobile/setCommerceJoin/format/json/idUser/"..dbConfig.id.."/idCommerce/"..idCommerce
        local deviceID = system.getInfo( "deviceID" )
        url = url.."/deviceID/"..urlencode(deviceID)
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                local gift = tonumber(data.gift)
                if gift > 0 then
                    addB(gift)
                end
                readyJoined(idCommerce)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommerce = function(idCommerce)
		local url = site.."mobile/getCommerce/format/json/idUser/"..dbConfig.id.."/idCommerce/"..idCommerce.."/idCity/1"
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Commerce", path = "assets/img/api/commerce/", items = data.items, branchs = data.branchs, rewards = data.rewards, photos = data.photos})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getWallet = function()
		local url = site.."mobile/getWallet/format/json/idUser/"..dbConfig.id
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Wallet", path = "assets/img/api/rewards/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    
    RestManager.setReadMessage = function(idMessage)
		local url = site.."mobile/setReadMessage/format/json/idUser/"..dbConfig.id.."/idMessage/"..idMessage
        
        local function callback(event)
            if ( event.isError ) then
            else
                
            end
            return true
        end
        -- Do request
    print(url)
        network.request( url, "GET", callback )
	end

    RestManager.setReadGift = function(idReward)
		local url = site.."mobile/setReadGift/format/json/idUser/"..dbConfig.id.."/idReward/"..idReward
        
        local function callback(event)
            if ( event.isError ) then
            else
                
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.setCity = function(idCity)
		local url = site.."mobile/setCity/format/json/idUser/"..dbConfig.id.."/idCity/"..idCity
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCities = function(search)
		local url = site.."mobile/getCities/format/json/idUser/"..dbConfig.id.."/data/"..search
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                showCities(data.items)
            end
            return true
        end
        -- Do request
        
        network.request( url, "GET", callback )
	end

    RestManager.getMessagesSeg = function()
		local url = site.."mobile/getMessagesSeg/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Messages", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getMessageSeg = function(idMessage)
		local url = site.."mobile/getMessageSeg/format/json/idMessage/"..idMessage
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                local path = "assets/img/api/message_photos/"
                loadImage({idx = 0, name = "Message", path = path, items = data.items})
            end
            return true
        end
        -- Do request
        print(url)
        network.request( url, "GET", callback )
	end
    
    RestManager.getLocationCity = function(lat, long)
		local url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="..lat..","..long.."&result_type=locality|country&key=AIzaSyCS_rZYTdUyi7w0rleSWpXU_cUpfdebpYY"
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.results then
                    if #data.results > 1 then
                        if data.results[1].formatted_address then
                            RestManager.getIdCity(data.results[1].formatted_address)
                        end
                    end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    
    RestManager.getIdCity = function(address)
		local url = site.."mobile/getIdCity/format/json/address/"..urlencode(address)
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                locIdCity = data.idCity
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    
    RestManager.cardLink = function(idCard)
		local url = site.."mobile/cardLink/format/json/idUser/"..dbConfig.id.."/idCard/"..idCard
        local deviceID = system.getInfo( "deviceID" )
        url = url.."/deviceID/"..urlencode(deviceID)
    
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
                    DBManager.updateIdCard(data.idCard)
                    if data.message and data.message == 'NewCard' then
                        showMess(true, 'Tarjeta vinculada, ahora podras usar tambien tu tarjeta para acumular puntos')
                    else
                        if data.gift then
                            local gift = tonumber(data.gift)
                            if gift > 0 then
                                addB(gift)
                            end
                        end
                        showMess(true, 'Se han acumulado tus puntos, podras usar seguir usando tu tarjeta para acumular mas puntos')
                    end
                else
                    if data.message == 'UserExist' then
                        showMess(false, 'Ya existe una tarjeta registrada a tu cuenta')
                    elseif data.message == 'CardExist' then
                        showMess(false, 'La tarjeta ya fue asignada a otra cuenta')
                    end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	
return RestManager