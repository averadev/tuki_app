---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

display.setStatusBar( display.DarkStatusBar )
display.setDefault( "background", 1, 1, 1 )

local composer = require( "composer" )
local DBManager = require('src.DBManager')
DBManager.setupSquema() 


-- Clear images
--[[
local lfs = require "lfs"
local doc_path = system.pathForFile( "", system.TemporaryDirectory )
for file in lfs.dir(doc_path) do
    os.remove( system.pathForFile( file, system.TemporaryDirectory  ) ) 
end
]]

local dbConfig = DBManager.getSettings()
if dbConfig.id == '' then
    composer.gotoScene("src.Login")
elseif dbConfig.afiliated == 0 then
    composer.gotoScene("src.WelcomeHome")
else
    composer.gotoScene("src.CardLink")
    --composer.gotoScene("src.Rewards")
    --composer.gotoScene("src.Reward", { params = { idReward = 18 } } )
    --composer.gotoScene("src.Partner", { params = { idCommerce = 1 } } )
end
