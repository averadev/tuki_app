--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
    local site = "http://localhost/unify/"
	
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
        if obj.name == "" then
            getFirstCards(obj)
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
	
	RestManager.getHomeRewards = function(idCoupon)
		local url = site.."api/getHomeRewards/format/json/"
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                loadImage({idx = 0, name = "", path = "assets/img/api/rewards/", items = data.items})
            end
            return true
        end
        -- Do request
        print(url)
        network.request( url, "GET", callback )
	end

    RestManager.getPointsBar = function(idCoupon)
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

    RestManager.getRewards = function(idCoupon)
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


	
	
return RestManager