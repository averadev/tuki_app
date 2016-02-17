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

local dbConfig = DBManager.getSettings()
if dbConfig.isNew == 1 then
    composer.gotoScene("src.Login")
else
    composer.gotoScene("src.Home")
    --storyboard.gotoScene("src.Rewards")
    --storyboard.gotoScene("src.Reward", { params = { idReward = 5 } } )
    --storyboard.gotoScene("src.Partner", { params = { idCommerce = 1 } } )
end
