---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

display.setStatusBar( display.DarkStatusBar )
display.setDefault( "background", 1, 1, 1 )

local composer = require( "composer" )
local DBManager = require('src.DBManager')
local OneSignal = require("plugin.OneSignal")
DBManager.setupSquema() 

--[[
local lfs = require "lfs"
local doc_path = system.pathForFile( "", system.TemporaryDirectory )
local destDir = system.TemporaryDirectory
for file in lfs.dir(doc_path) do
local file_attr = lfs.attributes( system.pathForFile( file, destDir  ) )
os.remove( system.pathForFile( file, destDir  ) ) 
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
]]--

local dbConfig = DBManager.getSettings()
if dbConfig.id == '' then
    composer.gotoScene("src.Login")
elseif dbConfig.afiliated == 0 then
    composer.gotoScene("src.WelcomeHome")
else
    composer.gotoScene("src.Home")
    --composer.gotoScene("src.Message", { params = { idMessage = 3 } } )
end

-- This function gets called when the user opens a notification or one is received when the app is open and active.
function DidReceiveRemoteNotification(message, data, isActive)
    if (data) then
        if (isActive) then
            system.vibrate()
        else
            composer.gotoScene("src.Message", { params = { idMessage = data.idMessage } })
        end
        
    end
    
end
OneSignal.Init("774cd845-e756-4081-b185-c51855beb9cc", "7592263599", DidReceiveRemoteNotification)
-- obtiene el token por telefono
function IdsAvailable(playerID, pushToken)
    print('oneSignalId: '..playerID)
	oneSignalId = playerID
end
OneSignal.IdsAvailableCallback(IdsAvailable)