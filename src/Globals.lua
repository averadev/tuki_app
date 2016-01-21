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
cGrayXL = { .9 }
cGrayL = { .7 }
cGrayM = { .63 }
cGrayH = { .45 }
cGrayXH = { .29 }
cGrayXXH = { .14 }
cBlue = { 0, .62, .89  }
cBlueH = { .02, .16, .35  }
cPurple = { .27, .11, .36  }
cPurpleL = { .38, .17, .51  }
cTurquesa = { .18, .74, .93  }
cTurquesaL = { .49, .81, .96  }
cFB = { 0, .42, .68 }

-- Fonts
fLatoBold = 'Lato-Heavy'
fLatoItalic = 'Lato-Regular'
fLatoRegular = 'Lato-Regular'

-- Otras
myTuks = ''
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