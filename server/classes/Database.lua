Database = inherit(Singleton)

Database.Prefix = "xtreme"

function Database:constructor()
    newDBHandler = dbConnect( "mysql")
    self.m_DbHandler = newDBHandler

    if not newDBHandler then
        outputDebugString("Primary database-connection failed ...")
        outputDebugString("Try to use alternative database-connection")
        newDBHandler = dbConnect("mysql");
        self.m_DbHandler = newDBHandler
    end

    if not self.m_DbHandler then
        outputDebugString("Can't connect to database.")
        stopResource(getThisResource())
    else
        outputDebugString("Database-connection succesful.")
    end
end

function Database:getPrefix()
    return self.Prefix
end

function Database:query(query, callBackFunction, callBackArguments, ...)
    return dbQuery(self.m_DbHandler, query, callBackFunction, callBackArguments, ...)
end

function Database:poll(query, timeout)
    return dbPoll(query, timeout)
end

function Database:exec(query, ...)
    return dbExec(self.m_DbHandler, query, ...)
end
