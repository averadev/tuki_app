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

    local site = "http://192.168.1.67/tuki_ws/"
    --local site = "http://geekbucket.com.mx/unify/"
	
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
            setCommerce(obj.items[1], obj.rewards)
            if #obj.photos > 0 then
                loadImage({idx = 0, name = "CommercePhotos", path = "assets/img/api/commerce/photos/", items = obj.photos})
            end
        elseif obj.name == "CommercePhotos" then
            setCommercePhotos(obj.items)
        elseif obj.name == "Wallet" then
            setListWallet(obj.items)
        elseif obj.name == "Messages" then
            setListMessages(obj.items)
        elseif obj.name == "Message" then
            setMessage(obj.items[1])
        elseif obj.name == "RetriveQR" then
            local item = obj.items[1]
            local imagen = display.newImage( item.image, system.TemporaryDirectory )
            item.parent:insert(imagen)
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
            local imagen = display.newImage( img, system.TemporaryDirectory )
            parent:insert(imagen)
            imagen.width = w
            imagen.height = h
            imagen:translate(x, y)
            return true;
        else
            local function imageListener( event )
                if ( event.isError ) then
                else
                    parent:insert(event.target)
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
            local imagen = display.newImage( key..".png", system.TemporaryDirectory )
            parent:insert(imagen)
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

    RestManager.createUserFB = function(fbid, name, email )
		local url = site.."mobile/createUserFB/format/json/fbid/"..fbid.."/email/"..urlencode(email).."/name/"..urlencode(name)
        
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
	
	RestManager.getHomeRewards = function()
		local url = site.."mobile/getHomeRewards/format/json/idUser/"..dbConfig.id
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "HomeCommerces", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getAccount = function()
		local url = site.."mobile/getAccount/format/json/idUser/"..dbConfig.id
        print(url)
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
        print(url)
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
		local url = site.."mobile/getCommerceFlow/format/json/idUser/1"
        
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
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                readyJoined(idCommerce)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommerce = function(idCommerce)
		local url = site.."mobile/getCommerce/format/json/idUser/"..dbConfig.id.."/idCommerce/"..idCommerce
        print(url)
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Commerce", path = "assets/img/api/commerce/", items = data.items, rewards = data.rewards, photos = data.photos})
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

    RestManager.getMessages = function()
		local url = site.."mobile/getMessages/format/json/idUser/"..dbConfig.id
        print(url)
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "Messages", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        print(url)
        network.request( url, "GET", callback )
	end

    RestManager.getMessage = function(idMessage)
		local url = site.."mobile/getMessage/format/json/idMessage/"..idMessage
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                local path = "assets/img/api/messages/"
                if data.items[1].user then
                    path = "assets/img/api/rewards/"
                end
                loadImage({idx = 0, name = "Message", path = path, items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    

	
	
return RestManager