--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	
	RestManager.getGdacsData = function(idCoupon)
		settings = DBManager.getSettings()
		local url = "http://www.gdacs.org/xml/rss.xml"
	   
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
	
	
return RestManager