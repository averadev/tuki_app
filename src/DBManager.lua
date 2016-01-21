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

    -- deshabilita el welcome
    dbManager.disableWelcome = function()
		openConnection( )
        local query = "UPDATE config SET isNew = 0"
        db:exec( query )
		closeConnection( )
	end

    -- deshabilita el welcome
    dbManager.setLogin = function(user)
		openConnection( )
        local query = "UPDATE config SET id = '"..user.id.."', fb = '"..user.fbid.."', name = '"..user.name..", isNew = 0"
        db:exec( query )
		closeConnection( )
	end

	-- Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id TEXT PRIMARY KEY, fbid TEXT, name TEXT, isNew INTEGER);"
		db:exec( query )

        for row in db:nrows("SELECT * FROM config;") do
            closeConnection( )
			do return end
		end

        --query = "INSERT INTO config VALUES ('', '', '', 1);"
		query = "INSERT INTO config VALUES (1014858604001209, 1088621194484293, 'Alberto', 0);"
        
		db:exec( query )
    
		closeConnection( )
    
        return 1
	end
	
	-- Setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager