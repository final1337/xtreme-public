TicketGUI = inherit(Object)

TicketGUI.TEST_TEXT = [[
Bitte beachten sie folgende Dinge beim Erstellen eines Tickets:

1.) Unnötige Tickets werden geahndet.

]]

TicketGUI.AdminRanks = {
    [1] = "Ticketbeauftragter",
    [2] = "Supporter",
    [3] = "Moderator",
    [4] = "Developer",
    [5] = "Administrator",
    [6] = "Servermanager",
    [7] = "Stellv. Projektleiter",
    [8] = "Projektleiter",
    [9] = "Alles"
}

TicketGUI.ProblemReasons = {
    "Grundlegendes",
    "Bug",
    "Beschwerde",
    "Wiedererstattung",
    "Anderes",
    "Alles"
}

addEvent("RP:Client:receiveTickets", true)
addEvent("RP:Client:receiveTicket", true)
addEvent("RP:Client:requestTickets", true)

function TicketGUI:constructor()
    self.m_Window = GUIWindow:new(screenWidth/2 - 700/2, screenHeight / 2 - 391/2, 700, 391, "Ticketmenü", true)

    self.m_Window:setColor(50, 50, 50, 220)

    --self.m_CreateTicket = GUIClassicButton:new("Ticket erstellen", 525, 34, 158, 52, self.m_Window)
    self.m_EditTicket = GUIClassicButton:new("Ticketverlauf anzeigen", 525, 35, 158, 52, self.m_Window)
    --self.m_CloseTicket = GUIClassicButton:new("Ticket schließen", 525, 158, 158, 52, self.m_Window)
    self.m_CurrentTickets = GUIClassicButton:new("Archivierte Tickets", 525, 247, 158, 52, self.m_Window)
    self.m_SendTicket = GUIClassicButton:new("Ticket erstellen", 525, 319, 158, 52, self.m_Window)


    GUILabel:new("Grund des Problems:", 525, 115, 158, 32, self.m_Window)
    self.m_ReasonProblem = GUICombobox:new(525, 140, 158, 32, self.m_Window)

    self.m_ReasonProblem:addEntrys(TicketGUI.ProblemReasons)
    self.m_ReasonProblem:setText(TicketGUI.ProblemReasons[1])

    GUILabel:new("Ausgewählter Adminrang:", 525, 175, 158, 32, self.m_Window)
    self.m_RankComboBox = GUICombobox:new(525, 200, 158, 32, self.m_Window)
    self.m_RankComboBox:addEntrys(TicketGUI.AdminRanks)
    self.m_RankComboBox:setText(TicketGUI.AdminRanks[#TicketGUI.AdminRanks])    

    self.m_RankComboBox.onComboSelect = bind(self.Action_RankChange, self)

    self.m_EditTicket.onLeftUp = bind(self.Action_EditTicket, self)
    self.m_CurrentTickets.onLeftUp = bind(self.Action_ChangeTicketKind, self)
    self.m_CurrentTickets.onRightUp = bind(self.requestTickets, self)
    self.m_SendTicket.onLeftUp = bind(self.Action_SendReply, self)

    self.m_RequestType = "current"
    self.m_EditingTicket = false

    self.m_Window:setVisible(false)

    self.m_Window:getCloseButton().onLeftUp = function () self.m_Window:setVisible(false) showCursor(false) end

    bindKey("F3", "down", bind(self.Key_ShowPanel, self))

    self.m_ItemListDropDown = bind(self.Action_TicketDropdown, self)

    addEventHandler("RP:Client:receiveTickets", root, bind(self.Event_ReceiveTickets, self))
    addEventHandler("RP:Client:receiveTicket", root, bind(self.Event_ReceiveTicket, self))
    addEventHandler("RP:Client:requestTickets", root, bind(self.Event_RequestTickets, self))
end

function TicketGUI:Event_RequestTickets()
    self:requestTickets()
end

function TicketGUI:Action_RankChange()
    if self.m_TicketArea then
        if getElementData(localPlayer,"Adminlevel") > 0 then
            self:requestTickets()
            localPlayer:sendNotification("Du filterst nun nach: %s.", 255, 255, 0, self.m_RankComboBox:getText())
        else
            localPlayer:sendNotification("Dieser Filter ist nur für die Administration relevant.")
        end
    end
end

function TicketGUI:Event_ReceiveTicket(content, ticketId)
    self:openWriteArea()
    self.m_EditingTicket = ticketId
    self.m_TextArea.Label:setText("")
    local string = ""
    for key, value in pairs(content) do
        string = string .. ("%s schrieb:\n%s\n\n"):format(value.writer, value.content)
    end
    self.m_TextArea.Label:setText(string)
end

function TicketGUI:getPriority()
    local rank = 9
    local text = self.m_RankComboBox:getText()
    for key, value in ipairs(TicketGUI.AdminRanks) do
        if value == text then
            rank = key
            break
        end
    end
    return rank
end

function TicketGUI:requestTickets()
    local prio = self:getPriority()
    triggerServerEvent("RP:Server:requestTickets", resourceRoot, self.m_RequestType, prio)
end

function TicketGUI:Action_SendReply()
    if self.m_WriteArea and self.m_EditingTicket then
        triggerServerEvent("RP:Server:onReplyTicket", resourceRoot, self.m_EditingTicket, self.m_Memo:getText())
    elseif self.m_WriteArea and not self.m_EditingTicket then
        triggerServerEvent("RP:Server:onSendTicket", resourceRoot, self.m_Memo:getText(), self.m_ReasonProblem:getText())
    elseif self.m_TicketArea then
        self:openWriteArea()
        self.m_SendTicket:setText("Ticket erstellen")
    end
end

function TicketGUI:Action_ChangeTicketKind()

    if self.m_WriteArea and self.m_WriteArea:isVisible() then
        self:openTicketArea()
        self.m_CurrentTickets:setText(self.m_RequestType == "current" and "Archivierte Tickets" or "Aktuelle Tickets")
        return
    end

    self.m_RequestType = self.m_RequestType == "current" and "archive" or "current"
    self.m_CurrentTickets:setText(self.m_RequestType == "current" and "Archivierte Tickets" or "Aktuelle Tickets")
    self:requestTickets()
end

function TicketGUI:Action_EditTicket()
    local row = self.m_TicketList:getActiveRow()

    if row then
        triggerServerEvent("RP:Server:onRequestTicket", resourceRoot, row.Value.Id)
    end
end

function TicketGUI:Event_ReceiveTickets(tickets)
    self.m_Window:setVisible(false)
    self.m_TicketList:flush()

    for key, value in pairs(tickets) do
        local row = self.m_TicketList:addRow()
        row.Value = value
        row:setValue("Ticket", value["Id"])
        row:setValue("Spieler", value["playerNick"])
        row:setValue("Admin", value["adminNick"])
        row:setValue("Problem", value["reason"])
        row:setValue("Status", value["closedby"] ~= 0 and "Geschlossen" or "Offen")
        
        row.onRightDown = self.m_ItemListDropDown
    end

    self.m_Window:setVisible(true)
end

function TicketGUI:Action_TicketDropdown(row)
    local dropdown = {}
    
    if self.m_RequestType == "current" then
        if getElementData(localPlayer,"Adminlevel") > 0 then
            if row.Value.assigned == 0 then
                table.insert(dropdown,
                {text="Reservieren", func= function () triggerServerEvent("RP:Server:onAssignTicket", resourceRoot, row.Value.Id) end})
            else
                table.insert(dropdown,
                {text="Freigeben", func= function () triggerServerEvent("RP:Server:releaseTicket", resourceRoot, row.Value.Id) end})
            end
            table.insert(dropdown, {text="Priorisieren", func= function () triggerServerEvent("RP:Server:onIncreasePriority", resourceRoot, row.Value.Id) end})
            table.insert(dropdown, {text="Archivieren", func= function () triggerServerEvent("RP:Server:archieveTicket", resourceRoot, row.Value.Id) end})
            if row.Value.closedby == 0 then
                table.insert(dropdown, {text="Schließen", func= function () triggerServerEvent("RP:Server:onCloseTicket", resourceRoot, row.Value.Id) end})
            else
                table.insert(dropdown, {text="Öffnen", func= function () triggerServerEvent("RP:Server:openTicket", resourceRoot, row.Value.Id) end})
            end
            table.insert(dropdown, {text="Anzeigen", func= function () triggerServerEvent("RP:Server:onRequestTicket", resourceRoot, row.Value.Id) end})
        else
            table.insert(dropdown,
                {text="Anzeigen", func= function () triggerServerEvent("RP:Server:onRequestTicket", resourceRoot, row.Value.Id) end})

        end
    else
        if getElementData(localPlayer,"Adminlevel") > 0 then
            table.insert(dropdown,
                {text="Entstauben", func= function () triggerServerEvent("RP:Server:dearchieveTicket", resourceRoot, row.Value.Id) end})
            table.insert(dropdown,
                {text="Anzeigen", func= function () triggerServerEvent("RP:Server:onRequestTicket", resourceRoot, row.Value.Id) end})                
        else
            table.insert(dropdown,
                {text="Anzeigen", func= function () triggerServerEvent("RP:Server:onRequestTicket", resourceRoot, row.Value.Id) end})
        end        
    end
    
    local cx, cy = getCursorPosition()

 	dropdownmenu:setup(dropdown, cx*screenWidth, cy*screenHeight)
	if dropdownmenu:getControlElement() then
		dropdownmenu:getControlElement().ItemFrameMenu = self.m_Window
	end   
end

function TicketGUI:openWriteArea()
    if self.m_WriteArea then
        delete(self.m_WriteArea)
        self.m_WriteArea = false
    end
    if self.m_TicketArea then
        delete(self.m_TicketArea)
        self.m_TicketArea = false
    end    

    self.m_WriteArea = GUIRectangle:new(11, 27, 504, 352, self.m_Window)

    self.m_WriteArea:setColor(50, 50, 50, 150)

    self.m_TextArea = GUIScrollArea:new(2, 0, 500, 325, 500, 2000, self.m_WriteArea)

    self.m_TextArea.Label = GUILabel:new("", 0, 0, 500, 2000, self.m_TextArea)

    self.m_TextArea.Label:setWordBreak(true):setAlignX("left"):setAlignY("top")

    self.m_TextArea.Label:setText(TicketGUI.TEST_TEXT)
    self.m_TextArea.Label:setInteractable(false)

    self.m_TextArea:changeScrollSpeedOnYAxis(10)

    self.m_CurrentTickets:setText("Zurück zur Ticketliste")
    self.m_SendTicket:setText("Absenden")

    self.m_Memo = GUIEditbox:new(0, 325, 504, 25, self.m_WriteArea)

    self.m_Window:setVisible(true)
    self.m_EditTicket:setVisible(false)
end

function TicketGUI:openTicketArea()
    if self.m_WriteArea then
        delete(self.m_WriteArea)
        self.m_WriteArea = false
    end
    if self.m_TicketArea then
        delete(self.m_TicketArea)
        self.m_TicketArea = false
    end    

    self.m_EditingTicket = false

    self.m_TicketArea = GUIRectangle:new(11, 27, 504, 352, self.m_Window)

    self.m_TicketList = GUIGridList:new(0,0, 504, 352, self.m_TicketArea)
    self.m_TicketList:addColumn("", 0.03)
    self.m_TicketList:addColumn("Ticket", 0.1)
    self.m_TicketList:addColumn("Spieler", 0.15)
    self.m_TicketList:addColumn("Admin", 0.15)
    self.m_TicketList:addColumn("Status", 0.15)
    self.m_TicketList:addColumn("Problem", 0.45)


    self.m_TicketList.m_ScrollArea:changeScrollSpeedOnYAxis(10)

    self.m_SendTicket:setText("Ticket erstellen")

    self.m_Window:setVisible(true)
    self.m_EditTicket:setVisible(true)

    self:requestTickets()

end

function TicketGUI:Key_ShowPanel()
    if not getKeyState("lshift") then
        self:openTicketArea()
        showCursor(true)
    end
end