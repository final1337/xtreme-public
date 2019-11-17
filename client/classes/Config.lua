Config = inherit(Object)

Config.Path = "Config/Config.xml"

function Config:constructor()
    self.m_RootNode = false

    if not fileExists(Config.Path) then
        local file = File.new(Config.Path)
        file:write("<config></config>")
        file:close()
    end

    if fileExists(Config.Path) then
        local file = fileOpen(Config.Path)
        if fileRead(file, fileGetSize(file)) == "" then
            file:write("<config></config>")
        end
        fileClose(file)
    end

    self.m_RootNode = xmlLoadFile(Config.Path)

end

function Config:get(key)
    if self.m_RootNode:findChild(key, 0) then
        return (self.m_RootNode:findChild(key, 0)):getValue();
    end
    return false
end

function Config:set(key, value)
    if self.m_RootNode:findChild(key, 0) then
        (self.m_RootNode:findChild(key, 0)):setValue(value)
    else
        (self.m_RootNode:createChild(key)):setValue(value)
    end
end

function Config:destructor()
    xmlSaveFile(self.m_RootNode)
    xmlUnloadFile(self.m_RootNode)
end