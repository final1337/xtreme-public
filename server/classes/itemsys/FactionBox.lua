FactionBoxClass = inherit(Object)

registerElementClass("factionBox", FactionBoxClass)

function FactionBoxClass:initBox(id, model, posX, posY, posZ, rotX, rotY, rotZ, faction)
    self.m_Box = createObject(model, posX, posY, posZ, rotX, rotY, rotZ)
    setElementData(self.m_Box, "factionBox", faction)
    setElementData(self.m_Box, "factionBoxId", id)
    return self.m_Box
end

function FactionBoxClass:getId()
    return self.Id
end

function FactionBoxClass:getLobby()
    return lobbymanager:getLobbys()[1][1]
end

function FactionBoxClass:getBox()
    return self.m_Box
end