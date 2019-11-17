TicketManager = inherit(Singleton)

addEvent("RP:Server:requestTickets", true)
addEvent("RP:Server:onSendTicket", true)
addEvent("RP:Server:onReplyTicket", true)
addEvent("RP:Server:onRequestTicket", true)
addEvent("RP:Server:onIncreasePriority", true)
addEvent("RP:Server:onCloseTicket", true)
addEvent("RP:Server:onAssignTicket", true)
addEvent("RP:Server:archieveTicket", true)
addEvent("RP:Server:releaseTicket", true)
addEvent("RP:Server:openTicket", true)
addEvent("RP:Server:dearchieveTicket", true)

function TicketManager:constructor()
    addEventHandler("RP:Server:requestTickets", root, bind(self.Event_LoadTickets, self))
    addEventHandler("RP:Server:onSendTicket", root, bind(self.Event_SendTicket, self))
    addEventHandler("RP:Server:onReplyTicket", root, bind(self.Event_ReplyTicket, self))
    addEventHandler("RP:Server:onRequestTicket", root, bind(self.Event_RequestTicket, self))
    addEventHandler("RP:Server:onIncreasePriority", root, bind(self.Event_IncreasePriority, self))
    addEventHandler("RP:Server:onCloseTicket", root, bind(self.Event_CloseTicket, self))
    addEventHandler("RP:Server:onAssignTicket", root, bind(self.Event_Assignticket, self))
    addEventHandler("RP:Server:archieveTicket", root, bind(self.Event_ArchieveTicket, self))
    addEventHandler("RP:Server:releaseTicket", root, bind(self.Event_ReleaseTicket, self))
    addEventHandler("RP:Server:openTicket", root, bind(self.Event_OpenTicket, self))
    addEventHandler("RP:Server:dearchieveTicket", root, bind(self.Event_DearchieveTicket, self))
end

function TicketManager:Event_DearchieveTicket(ticketId)
    if not client then return end
    self:dearchieveTicket(client, ticketId)
    client:sendNotification("Das Ticket ist nun wieder aktuell.", 255, 255, 0)
    client:triggerEvent("RP:Client:requestTickets")    
end

function TicketManager:dearchieveTicket(player, ticketId)
    db:exec("UPDATE tickets_new SET archieved = 0 WHERE Id=?", ticketId)
end

function TicketManager:Event_OpenTicket(ticketId)
    if not client then return end
    self:openTicket(client, ticketId)
    client:sendNotification("Das Ticket wurde geöffnet.", 255, 255, 0)
    client:triggerEvent("RP:Client:requestTickets")
end

function TicketManager:openTicket(player, ticketId)
    db:exec("UPDATE tickets_new SET closedby = 0 WHERE Id=?", ticketId)
end

function TicketManager:Event_ReleaseTicket(ticketId)
    if not client then return end
    self:releaseTicket(client, ticketId)
end

function TicketManager:releaseTicket(player, ticketId)
    local query = db:query("SELECT * FROM tickets_new WHERE Id=?", ticketId)
    local result = db:poll(query, -1)

    if #result == 0 then
        return
    end

    result = result[1]

    if result.assigned ~= player:getId() then
        player:sendNotification("Du kannst dieses Ticket nicht freigeben.", 120, 0, 0)
        player:triggerEvent("RP:Client:requestTickets")
        return
    end

    db:exec("UPDATE tickets_new SET assigned=0, adminNick='Niemand' WHERE Id=?", ticketId)
    player:sendNotification("Das Ticket wurde freigegeben.", 125, 0, 0)
    player:triggerEvent("RP:Client:requestTickets") 
end

function TicketManager:Event_Assignticket(ticketId)
    if not client then return end
    self:assignTicket(client, ticketId)
end

function TicketManager:assignTicket(player, ticketId)
    local query = db:query("SELECT * FROM tickets_new WHERE Id=?", ticketId)
    local result = db:poll(query, -1)

    if #result == 0 then
        return
    end

    result = result[1]

    if result.assigned ~= 0 then
        player:sendMessage("Das Ticket ist bereits reserviert.", 120, 0, 0)
        player:triggerEvent("RP:Client:requestTickets")
        return
    end

    db:exec("UPDATE tickets_new SET assigned=?, adminNick=? WHERE Id=?", player:getId(), player:getName(), ticketId)
    player:sendNotification("Das Ticket wurde für dich reserviert.", 125, 0, 0)
    self:loadTicket(player, ticketId)
end

function TicketManager:Event_CloseTicket(ticketId)
    if not client then return end
    self:closeTicket(client, ticketId)
    client:sendNotification("Das Ticket wurde geschlossen.", 255, 255, 0)
    client:triggerEvent("RP:Client:requestTickets")
end

function TicketManager:closeTicket(player, ticketId)
    db:exec("UPDATE tickets_new SET closedby = ? WHERE Id=?", player:getId(), ticketId)
end

function TicketManager:Event_ArchieveTicket(ticketId)
    if not client then return end
    local query = db:query("SELECT * FROM tickets_new WHERE Id = ?", ticketId)
    local result = db:poll(query, -1)

    if result[1].closedby ~= 0 and result[1].archieved == 0 then
        self:archieveTicket(ticketId)
        client:sendNotification("Das Ticket ist nun archiviert.")
    else
        client:sendNotification("Das Ticket ist noch nicht geschlossen oder ist bereits archiviert!", 120, 0, 0)
    end
    client:triggerEvent("RP:Client:requestTickets")
end

function TicketManager:archieveTicket(ticketId)
    db:exec("UPDATE tickets_new SET archieved = 1 WHERE Id=?", ticketId)
end

function TicketManager:Event_LoadTickets(typ, prio)
    if not client then return end
    self:loadTickets(client, typ, prio)
end

function TicketManager:Event_IncreasePriority(ticketId)
    if not client then return end
    client:sendNotification("Priorität erhöht!", 255, 255, 0)
    self:increasePriority(ticketId)
    client:triggerEvent("RP:Client:requestTickets")
end

function TicketManager:increasePriority(ticketId)
    db:exec("UPDATE tickets_new SET prio = LEAST( prio+1, 8 ), assigned = 0, adminNick = 'Niemand' WHERE Id = ?", ticketId)
end

function TicketManager:loadTickets(player, typ, prio)
    local results, query

    local archieved = typ == "current" and 0 or 1

    if getElementData(player, "Adminlevel") > 0 then
        if typ == "current" then
            if prio == 9 then
                query = db:query("SELECT * FROM tickets_new WHERE archieved = 0 AND ( assigned = 0 OR assigned = ? ) ORDER BY Id DESC ",  player:getId())
            else
                query = db:query("SELECT * FROM tickets_new WHERE archieved = 0 AND prio = ? AND ( assigned = 0 OR assigned = ? ) ORDER BY Id DESC ",  prio, player:getId())
            end
        else
            if prio == 9 then
                query = db:query("SELECT * FROM tickets_new WHERE archieved = 1 ORDER BY Id DESC ")
            else
                query = db:query("SELECT * FROM tickets_new WHERE archieved = 1 AND prio = ?  ORDER BY Id DESC ",  prio)
            end
        end           
    else
        query = db:query("SELECT * FROM tickets_new WHERE archieved = ? AND playerId = ? ORDER BY Id DESC", archieved, player:getId())
    end    
    results = db:poll(query, -1)    

    player:triggerEvent("RP:Client:receiveTickets", results)
end

function TicketManager:Event_RequestTicket(ticketId)
    if not client then return end
    self:loadTicket(client, ticketId)
end

function TicketManager:loadTicket(player, ticketId)

    local query = db:query("SELECT * FROM ticket_replies WHERE ticketId = ? ORDER BY replyId DESC", ticketId)
    local results = db:poll(query, -1)

    player:triggerEvent("RP:Client:receiveTicket", results, ticketId)
end

function TicketManager:Event_SendTicket(description, reason)
    if not client then return end
    if utf8.len(description) <= 10 then
        client:sendNotification("Dein Text ist leider zu kurz.", 120, 0, 0)
        return
    end
    local id = self:addTicket(client:getId(), client:getName(), reason)
    self:addReply(client, id, description)
end

function TicketManager:addTicket(playerId, playerNick, reason)
    local query = db:query("INSERT INTO tickets_new (playerId, playerNick, createtime, reason) VALUES (?,?,?,?) ", playerId, playerNick, getRealTime()["timestamp"], reason)
    local result, num_affected_rows, last_insert_id = db:poll(query, -1)

    for key, value in ipairs(getElementsByType("player")) do
        if getElementData(value,"Adminlevel") > 0 then
            value:sendNotification("%s hat ein neues Ticket mit der Nr. %d erstellt.", 255, 0, 0, playerNick, last_insert_id)
            value:sendMessage("%s hat ein neues Ticket mit der Nr. %d erstellt.", 255, 0, 0, playerNick, last_insert_id)
        end
    end

    return last_insert_id
end

function TicketManager:Event_ReplyTicket(ticketId, description)
    if not client then return end
    if utf8.len(description) == 0 then
        client:sendNotification("Dein Text ist leider zu kurz.", 120, 0, 0)
        return
    end    
    self:addReply(client, ticketId, description)
end

function TicketManager:addReply(player, ticketId, description)
    local query = db:query("SELECT COUNT(*) AS Count FROM ticket_replies WHERE ticketId = ?", ticketId)
    local result = db:poll(query, - 1)

    local count = 0

    if result[1] then
        count = result[1].Count
    end

    query = db:query("SELECT * FROM tickets_new WHERE Id = ?", ticketId)
    result = db:poll(query, -1)

    if result[1].closedby == 0 and result[1].archieved == 0 then
        db:exec("INSERT INTO ticket_replies (ticketId, replyId, content, writer) VALUES (?, ?, ?, ?)", 
                                ticketId, count+1, description, player:getName())
        self:loadTicket(player, ticketId)

        if getPlayerFromName(result[1].adminNick) and player:getName() ~= getPlayerFromName(result[1].adminNick) then
            getPlayerFromName(result[1].adminNick):sendMessage("Ticket Nr. %d von %s hat geantwortet.", 255, 0, 0, ticketId, result[1].playerNick)
            getPlayerFromName(result[1].adminNick):sendNotification("Ticketantwort ( siehe Chat ).", 0, 120, 0)
        end
        if getPlayerFromName(result[1].playerNick) and player:getName() ~= getPlayerFromName(result[1].playerNick) and result[1].adminNick ~= "Niemand" then
            getPlayerFromName(result[1].playerNick):sendMessage("%s hat auf dein Ticket Nr. %d geantwortet.", 255, 0, 0, result[1].adminNick, ticketId)
            getPlayerFromName(result[1].playerNick):sendNotification("Ticketantwort ( siehe Chat ).", 0, 120, 0)
        end

        player:sendNotification("Antwort gesendet.", 255, 255, 0)
    else
        player:sendNotification("Das Ticket ist bereits geschlossen.", 120, 0, 0)
    end
end