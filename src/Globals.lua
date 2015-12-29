--Include sqlite

-- Mediciones de pantalla
intW = display.contentWidth
intH = display.contentHeight
midW = display.contentCenterX
midH = display.contentCenterY
hm3 = intH / 3
h = display.topStatusBarContentHeight

-- Colors
cWhite = { 1 }
cGrayM = { .63 }
cGrayH = { .14 }
cTurquesa = { .18, .74, .93  }
cBlueH = { .02, .16, .35  }

-- Fonts
fLatoBold = 'Lato Bold'
fLatoRegular = 'Lato-Regular'

-- Otras
local Globals = {}
Globals.filtros = {
    {"TODO", "iconFilterA"}, 
    {"RESTAURANTES", "iconFilterB"}, 
    {"BARES Y DISCOS", "iconFilterC"}, 
    {"SERVICIOS", "iconFilterD"}, 
    {"HOTELES", "iconFilterE"}, 
    {"FITNESS", "iconFilterF"}, 
    {"PARQUES Y TOURS", "iconFilterG"}, 
    {"COMPRAS", "iconFilterH"},
    {"AUTOSERVICIOS", "iconFilterI"},
    {"OTROS", "iconFilterJ"}
}
Globals.scenes = { }
Globals.menu = nil
return Globals