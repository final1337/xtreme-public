TradeManager = inherit(Singleton)

addEvent("RP:Server:Trading:startSession", true)
addEvent("RP:Server:Trading:itemChange", true)
addEvent("RP:Server:Trading:itemDelete", true)
addEvent("RP:Server:Trading:reset", true)
addEvent("RP:Server:Trading:close", true)
addEvent("RP:Server:Trading:confirm", true)

function TradeManager:constructor()

    self.m_TradingSessions = {}
    self.m_ActiveTradingPlayer = {}

    addEventHandler("RP:Server:Trading:startSession", root, bind(self.Event_StartSession, self))
    addEventHandler("RP:Server:Trading:itemChange", root, bind(self.Event_ItemChange, self))
    addEventHandler("RP:Server:Trading:itemDelete", root, bind(self.Event_ItemDelete, self))
    addEventHandler("RP:Server:Trading:reset", root, bind(self.Event_Reset, self))
    addEventHandler("RP:Server:Trading:close", root, bind(self.Event_Close, self))
    addEventHandler("RP:Server:Trading:confirm", root, bind(self.Event_Confirm, self))
    addEventHandler("onElementClicked", root, bind(self.Event_ElementClicked, self))
    addEventHandler("onPlayerQuit", root, bind(self.Event_OnPlayerQuit, self))
end

function TradeManager:Event_OnPlayerQuit()
    if self.m_TradingSessions[source] then
        self:close(source)
    end
end

function TradeManager:Event_Confirm()
    if not client then return end
    self:confirm(client)
end

function TradeManager:confirm(player)
    local session = self:getTradingSession(player)

    local playerOrTarget = session:getPlayer() == player and "player" or "target"

    local currentState = session:getReadyState(playerOrTarget)

    session:setReadyState(playerOrTarget, not currentState)

    self:sendConfirmation(session:getPlayer())
    self:sendConfirmation(session:getTarget())

    -- Both players agreed to trade
    if session:getReadyState("player") and session:getReadyState("target") then
        self:executeTrade(session)
    end
end

function TradeManager:executeTrade(session)
    local player = session:getPlayer()
    local target = session:getTarget()

    local playerItems = session:getPlayerItems()
    local targetItems = session:getTargetItems()

    local playerAmount = session:getPlayerItemAmount()
    local targetAmount = session:getTargetItemAmount()

    -- Check if players have enough space within their main storages
    local playerStorage = storagemanager:getStorageBySpecification(player, "OwnStorage", 1)
    local targetStorage = storagemanager:getStorageBySpecification(target, "OwnStorage", 1)

    local playerFreeSlots = playerStorage:getFreeSlotAmount()
    local targetFreeSlots = targetStorage:getFreeSlotAmount()

    if playerFreeSlots < targetAmount then
        return
    end
    if targetFreeSlots < playerAmount then
        return
    end

    for key, value in pairs(playerItems) do
        storagemanager:switchItem(player, value.General, value.Specific, value.Item.UniqueIdentifier, target, "OwnStorage", 1)
    end
    for key, value in pairs(targetItems) do
        storagemanager:switchItem(target, value.General, value.Specific, value.Item.UniqueIdentifier, player, "OwnStorage", 1)
    end

    -- Player with player or target
    self:close(player)
end

function TradeManager:Event_Close()
    if not client then return end
    self:close(client)
end

function TradeManager:close(player)
    local session = self:getTradingSession(player)

    session:getPlayer():triggerEvent("RP:Client:Trading:closeWindow")
    session:getTarget():triggerEvent("RP:Client:Trading:closeWindow")

    session:delete()
    self.m_TradingSessions[session:getPlayer()] = nil
    self.m_TradingSessions[session:getTarget()] = nil
end

function TradeManager:Event_Reset()
    if not client then return end
    self:reset(client)
end

function TradeManager:reset(player)
    local session = self:getTradingSession(player)

    if session:getPlayer() ~= player then
        session.m_TargetItems = {}
    else
        session.m_PlayerItems = {}
    end

    session:setReadyState("player", false)
    session:setReadyState("target", false)
       
    self:sendItems(session:getPlayer())
    self:sendItems(session:getTarget())     
end

function TradeManager:Event_ItemDelete(slot)
    if not client then return end
    self:itemDelete(client, slot)
end

function TradeManager:itemDelete(player, slot)
    local session = self:getTradingSession(player)

    if session:getPlayer() ~= player then
        -- decrement the slot amount by 6 otherwise we would change the wrong slot

        session.m_TargetItems[slot] = nil
    else
        session.m_PlayerItems[slot] = nil
    end

    session:setReadyState("player", false)
    session:setReadyState("target", false)


    self:sendItems(session:getPlayer())
    self:sendItems(session:getTarget())   

    self:sendConfirmation(session:getPlayer())
    self:sendConfirmation(session:getTarget())     
end

function TradeManager:Event_ItemChange(item, slot, general, specific)
    if not client then return end
    self:itemChange(client, item, slot, general, specific)
end

function TradeManager:itemChange(player, item, slot, general, specific)
    local session = self:getTradingSession(player)

    if session:getPlayer() ~= player then
        -- decrement the slot amount by 6 otherwise we would change the wrong slot
        session.m_TargetItems[slot] = { Item = item, General = general, Specific = specific }
    else
        session.m_PlayerItems[slot] = { Item = item, General = general, Specific = specific }
    end
	
    -- Reset all confirmations 2 reduce amount of scams

    session:setReadyState("player", false)
    session:setReadyState("target", false)

    self:sendItems(session:getPlayer())
    self:sendItems(session:getTarget())
    self:sendConfirmation(session:getPlayer())
    self:sendConfirmation(session:getTarget())
end

function TradeManager:Event_ElementClicked(mouseButton, buttonState, player, x, y, z)
    if player ~= source and source:getType() == "player" and mouseButton == "right" and buttonState == "up" then 
        self:startSession(player, source)
    end
end

function TradeManager:Event_StartSession(target)
    if not client then return end
    self:startSession(client, target)
end

function TradeManager:startSession(player, target)
    if self:isPlayerTrading(player) or self:isPlayerTrading(target) then
        player:sendNotification(loc"TRADE_BUSY", 255, 0, 0)
        return
    end
    self:resetTrading(player)
    self:resetTrading(target)
    local session = TradingSession:new(player, target)
    self:initTrading(player, target, session)
    self:initTrading(target, player, session)
    self:sendItems(player)
    self:sendItems(target)
    self:sendConfirmation(player)
    self:sendConfirmation(target)
end

function TradeManager:sendItems(player)
    local session = self:getTradingSession(player)

    local playerItems = session:getPlayerItems()
    local targetItems = session:getTargetItems()

    -- Merge the items to the right slot
    if session:getPlayer() == player then
        player:triggerEvent("RP:Client:Trading:refreshTrading", playerItems, targetItems)
    else
        player:triggerEvent("RP:Client:Trading:refreshTrading", targetItems, playerItems)
    end
end

function TradeManager:sendConfirmation(player)
    local session = self:getTradingSession(player)

    local playerReady = session:getReadyState("player")
    local targetReady = session:getReadyState("target")

    -- Merge the items to the right slot
    if session:getPlayer() == player then

        player:triggerEvent("RP:Client:Trading:refreshConfirmation", playerReady, targetReady)
    else
        player:triggerEvent("RP:Client:Trading:refreshConfirmation", targetReady, playerReady)
    end 
end

function TradeManager:initTrading(player, target, session)
    self.m_TradingSessions[player] = session
    player:triggerEvent("RP:Client:Trading:initTrading", target)
end

function TradeManager:resetTrading(player)
    if self:getTradingSession(player) then
        self.m_TradingSessions[player]:delete()
        self.m_TradingSessions[player] = nil
    end 
    player:triggerEvent("RP:Client:Trading:closeWindow")
end

function TradeManager:getTradingSession(player) return self.m_TradingSessions[player] end

function TradeManager:isPlayerTrading(player)
    return self.m_TradingSessions[player]
end