---------------------------------------------------------------------------------
-- Trippy Rex
-- Alberto Vera Espitia
-- Parodiux Inc.
---------------------------------------------------------------------------------

display.setStatusBar( display.DarkStatusBar )
display.setDefault( "background", 1, 1, 1 )

local storyboard = require('storyboard')
local DBManager = require('src.DBManager')


local isNew = DBManager.setupSquema() 
if isNew then
    storyboard.gotoScene("src.Welcome1")
else
    storyboard.gotoScene("src.Home")
end
--storyboard.gotoScene("src.Welcome1")
--storyboard.gotoScene("src.Partner", { params = { idCommerce = 1 } } )
