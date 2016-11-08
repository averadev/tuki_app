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
        elseif (additionalData.actionSelected) then 
            composer.gotoScene("src.Messages")
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