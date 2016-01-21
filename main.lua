---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

display.setStatusBar( display.DarkStatusBar )
display.setDefault( "background", 1, 1, 1 )

local storyboard = require('storyboard')
local DBManager = require('src.DBManager')
DBManager.setupSquema() 

local dbConfig = DBManager.getSettings()
if dbConfig.isNew == 1 then
    storyboard.gotoScene("src.Login")
else
    storyboard.gotoScene("src.Home")
    --storyboard.gotoScene("src.Rewards")
    --storyboard.gotoScene("src.Reward", { params = { idReward = 5 } } )
    --storyboard.gotoScene("src.Partner", { params = { idCommerce = 1 } } )
end
