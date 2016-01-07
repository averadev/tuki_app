--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
    local site = "http://192.168.1.70/tuki_ws/"
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

    -- Envia al metodo
    function goToMethod(obj)
        if obj.name == "HomeRewards" then
            getFirstCards(obj)
        elseif obj.name == "Reward" then
            setReward(obj.items[1])
        elseif obj.name == "CommerceFlow" then
            getCoverFirstFlow(obj)
        elseif obj.name == "Commerces" then
            setListCommerce(obj.items)
        elseif obj.name == "Commerce" then
            setCommerce(obj.items[1], obj.rewards)
            loadImage({idx = 0, name = "CommercePhotos", path = "assets/img/api/commerce/photos/", items = obj.photos})
        elseif obj.name == "CommercePhotos" then
            setCommercePhotos(obj.items)
        elseif obj.name == "Wallet" then
            setListWallet(obj.items)
        elseif obj.name == "Message" then
            setMessage(obj.items[1])
        end
    end 

    -- Carga de la imagen del servidor o de TemporaryDirectory
    function loadImage(obj)
        -- Next Image
        if obj.idx < #obj.items then
            -- Add to index
            obj.idx = obj.idx + 1
            -- Determinamos si la imagen existe
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
                display.loadRemoteImage( site..obj.path..img,"GET", imageListener, img, system.TemporaryDirectory ) 
            end
        else
            -- Dirigimos al metodo pertinente
            goToMethod(obj)
        end
    end

    RestManager.getQR = function(key)
        -- Verificamos si existe el codigo
        local path = system.pathForFile( key..".png", system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
        else
            -- Solicitamos el codigo
            local url = site.."api/getQR/"..key
            local function callback(event)
                if ( event.isError ) then
                else
                    -- Almacenamos QR
                    local data = {}
                    data[1] = {image = "1014858604001209.png"}
                    loadImage({idx = 0, name = "", path = "assets/img/api/qr/", items = data})
                end
                return true
            end
            -- Do request
            network.request( url, "GET", callback )
        end
	end
	
	RestManager.getHomeRewards = function()
		local url = site.."api/getHomeRewards/format/json/idUser/1"
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "HomeRewards", path = "assets/img/api/rewards/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getPointsBar = function()
		local url = site.."api/getPointsBar/format/json/idUser/1"
        
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

    RestManager.getRewards = function()
		local url = site.."api/getRewards/format/json/idUser/1"
        
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
		local url = site.."api/setRewardFav/format/json/idUser/1/idReward/"..idReward.."/isFav/"..isFav
        
        local function callback(event)
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
    
    RestManager.getRewardFavs = function()
		local url = site.."api/getRewardFavs/format/json/idUser/1"
        
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
		local url = site.."api/getReward/format/json/idUser/1/idReward/"..idReward
        
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
		local url = site.."api/getCommerces/format/json/idUser/1/filters/"..filters
        
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

    RestManager.getJoined = function(filters)
		local url = site.."api/getJoined/format/json/idUser/1/filters/"..filters
        
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
		local url = site.."api/getCommerceFlow/format/json/idUser/1"
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "CommerceFlow", path = "assets/img/api/commerce/", items = data.items})
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.setCommerceFav = function(idCommerce, isFav)
		local url = site.."api/setCommerceFav/format/json/idUser/1/idCommerce/"..idCommerce.."/isFav/"..isFav
        
        local function callback(event)
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getCommerce = function(idCommerce)
		local url = site.."api/getCommerce/format/json/idUser/1/idCommerce/"..idCommerce
        
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
		local url = site.."api/getWallet/format/json/idUser/1"
        
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
		local url = site.."api/getMessages/format/json/idUser/1"
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                setListMessages(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getMessage = function(idMessage)
		local url = site.."api/getMessage/format/json/idMessage/"..idMessage
        
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