---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db

	-- Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
	    path = system.pathForFile("tuki.db", system.DocumentsDirectory)
	    db = sqlite3.open( path )     
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end

    -- Verificamos campo en tabla
    local function updateTable(table, field, typeF)
	    local oldVersion = true
        for row in db:nrows("PRAGMA table_info("..table..");") do
            if row.name == field then
                oldVersion = false
            end
        end

        if oldVersion then
            local query = "ALTER TABLE "..table.." ADD COLUMN "..field.." "..typeF..";"
            db:exec( query )
        end   
	end
	 
	-- Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end

	-- obtiene los datos de configuracion
	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end

    -- Actualiza login
    dbManager.updateUser = function(user)
		openConnection( )
        local query = "UPDATE config SET id = '"..user.id.."', fbid = '"..user.fbid.."', name = '"..user.name.."'"
        if user.idCard then
            query = query..", idCard = '"..user.idCard.."'"
        end
        
        db:exec( query )
		closeConnection( )
	end

    -- Actualiza login
    dbManager.updateAfiliated = function(afiliated)
		openConnection( )
        local query = "UPDATE config SET afiliated = "..afiliated
        db:exec( query )
		closeConnection( )
	end

    -- Actualiza tarjeta
    dbManager.updateIdCard = function(idCard)
		openConnection( )
        local query = "UPDATE config SET idCard = "..idCard
        db:exec( query )
		closeConnection( )
	end

    -- deshabilita el welcome
    dbManager.disableWelcome = function()
		openConnection( )
        local query = "UPDATE config SET isNew = 0"
        db:exec( query )
		closeConnection( )
	end

	-- Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id TEXT PRIMARY KEY, fbid TEXT, name TEXT, city TEXT, afiliated INTEGER, idCard TEXT);"
		db:exec( query )
    
        updateTable('config', 'idCard', 'TEXT')

        for row in db:nrows("SELECT * FROM config;") do
            closeConnection( )
			do return end
		end
    
        query = "INSERT INTO config VALUES ('', '', '', 'Cancún, Quintana Roo', 0, '');"
        --query = "INSERT INTO config VALUES ('1015173253001603', '', 'Alberto Vera', 'Cancún, Quintana Roo', 0);"
		
        
		db:exec( query )
    
		closeConnection( )
    
        return 1
	end
	
	-- Setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager