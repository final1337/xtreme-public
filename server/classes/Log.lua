Log = inherit(Object)

function Log:constructor(type)
    self.m_Type = type

    self.m_Attributes = {}
    self.m_PrepareString = ""
end

function Log:addAttributes(attributes)
    self.m_Attributes = {}
end

function Log:prepareString(string)
    self.m_PrepareString = string

    --[[local addstring = ""

    for key, value in ipairs({...}) do
        table.insert(self.m_Attributes, value)
        addstring = ("%s%s VARCHAR(25)%s"):format(addstring, value, key ~= #{...} and ",\n" or "")
    end]]

    db:exec( [[CREATE TABLE IF NOT EXISTS ?? (
        ID INT AUTO_INCREMENT PRIMARY KEY,
        Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        LogData VARCHAR(100)
    )  ENGINE=INNODB]], "log_" .. self.m_Type)
end

function Log:getTimeStamp()
    local t = getRealTime()
    return ("[%d / %d / %d - %.2d:%.2d:%.2d]"):format(t.year+1900, t.month+1, t.monthday, t.hour, t.minute, t.second)
end

function Log:prepareFilePath()
    local t = getRealTime()
    return (":XTM_LOGS/Logs/%s/%s/%s/%s.txt"):format(t.year+1900, t.month+1, t.monthday, self.m_Type)
end

function Log:getFile()
    local path = self:prepareFilePath()
    if fileExists(path) then
        return fileOpen(path)
    else
        return fileCreate(path)
    end
end

function Log:write(...)
    local arguments = {...}
    local string = self:getTimeStamp()
    local prepareString = self.m_PrepareString:format(unpack(arguments))

    string = ("%s %s\n"):format(string, prepareString)

    --[[local file = self:getFile()

    fileSetPos(file, fileGetSize(file))

    fileWrite(file, string)

    fileClose(file)]]

    --local attributes = table.concat(self.m_Attributes, ",")
   -- local adds = ("\"%s\""):format(table.concat({...}, "\",\""))

    --db:exec( ( "INSERT INTO %s (%s) VALUES (%s) "):format("log_" .. self.m_Type, attributes, adds) )
    db:exec("INSERT INTO ?? (LogData) VALUES (?)", "log_" .. self.m_Type, prepareString)
end