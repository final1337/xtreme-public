Trading = inherit(Singleton)

addEvent("RP:Client:Trading:closeWindow", true)
addEvent("RP:Client:Trading:initTrading", true)
addEvent("RP:Client:Trading:refreshTrading", true)
addEvent("RP:Client:Trading:refreshConfirmation", true)

Trading.AcceptMark = utf8.char(10004)
Trading.DeclineMark = utf8.char(10008)

function Trading:constructor()
    self.m_Window = GUIWindow:new(1150*screenWidth/1600, 300*screenHeight/900, 300*screenWidth/1600, 425*screenHeight/900, "Handeln", true)
    
    self.m_Window:setColor( 25, 25, 25, 200 )

    GUILine:new(150*screenWidth/1600, GUIWindow.TitleThickness, 150*screenWidth/1600, (50+54*6)*screenHeight/900, 4, self.m_Window):setColor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3]):setInteractable(false)
    GUILine:new(0, (50+54*6)*screenHeight/900, 300*screenWidth/1600, (50+54*6)*screenHeight/900, 4, self.m_Window):setColor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3]):setInteractable(false)

    self.m_Slots = {}

    self.m_Slots[1] = TradingItemFrame:new(50*screenWidth/1600,45*screenHeight/900,		 48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[2] = TradingItemFrame:new(50*screenWidth/1600,(45+54*1)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[3] = TradingItemFrame:new(50*screenWidth/1600,(45+54*2)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[4] = TradingItemFrame:new(50*screenWidth/1600,(45+54*3)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[5] = TradingItemFrame:new(50*screenWidth/1600,(45+54*4)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[6] = TradingItemFrame:new(50*screenWidth/1600,(45+54*5)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)

    self.m_Slots[7] = TradingItemFrame:new( 202*screenWidth/1600, 45*screenHeight/900,		  48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[8] = TradingItemFrame:new( 202*screenWidth/1600,(45+54*1)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[9] = TradingItemFrame:new( 202*screenWidth/1600,(45+54*2)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[10] = TradingItemFrame:new(202*screenWidth/1600,(45+54*3)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[11] = TradingItemFrame:new(202*screenWidth/1600,(45+54*4)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window)
    self.m_Slots[12] = TradingItemFrame:new(202*screenWidth/1600,(45+54*5)*screenHeight/900,48*screenWidth/1600,48*screenHeight/900,self.m_Window) 


    self.m_ConfirmButton = GUIClassicButton:new(loc"CONFIRM", 15*screenWidth/1600, 385*screenHeight/900, 100*screenWidth/1600, 25*screenHeight/900, self.m_Window)
    self.m_ResetButton = GUIClassicButton:new(loc"RESET", 185*screenWidth/1600, 385*screenHeight/900, 100*screenWidth/1600, 25*screenHeight/900, self.m_Window)

    self.m_SelfName = GUILabel:new("civele", 50*screenWidth/1600, 23*screenHeight/900, 48*screenWidth/1600, 25*screenHeight/900, self.m_Window)
    self.m_PartnerName = GUILabel:new("debugy", 202*screenWidth/1600, 23*screenHeight/900, 48*screenWidth/1600, 25*screenHeight/900, self.m_Window)

    self.m_SelfName:setAlignX("center"):setFont("default-bold")
    self.m_PartnerName:setAlignX("center"):setFont("default-bold")

    self.m_SelfMark = GUILabel:new(Trading.DeclineMark, 135*screenWidth/1600 , 388*screenHeight/900, 4*screenWidth/1600, 16*screenHeight/900, self.m_Window)
    self.m_PartnerMark = GUILabel:new(Trading.DeclineMark, 155*screenWidth/1600, 388*screenHeight/900, 4*screenWidth/1600, 16*screenHeight/900, self.m_Window)

    self.m_SelfMark:setColor(255, 0, 0)
    self.m_PartnerMark:setColor(255, 0, 0)

    self.m_Window.m_CloseButton.onLeftUp = bind(self.Action_Close, self)

    self.m_ConfirmButton.onLeftUp = bind(self.Action_Confirm, self)
    self.m_ResetButton.onLeftUp = bind(self.Action_Reset, self)

    --self.m_Window:setVisible(true)

    addEventHandler("RP:Client:Trading:refreshTrading", root, bind(self.Event_RefreshTrading, self))
    addEventHandler("RP:Client:Trading:refreshConfirmation", root, bind(self.Event_RefreshConfirmation, self))
    addEventHandler("RP:Client:Trading:initTrading", root, bind(self.Event_InitTrading, self))
    addEventHandler("RP:Client:Trading:closeWindow", root, bind(self.Event_CloseWindow, self))
    addEventHandler("onClientResourceStop", resourceRoot, bind(self.Event_OnClientResourceStop, self))
end

function Trading:Event_OnClientResourceStop()
    if self.m_Window.m_Visible then
        triggerServerEvent("RP:Server:Trading:close", resourceRoot)
    end
end

function Trading:Action_Confirm()
    -- Check if player shouldnt be able to confirm trade, e.g. non-tradable item
    local confirmAllowed = true
    for i = 1, 6, 1 do
        if self.m_Slots[i]:getItem() then
            if not (self.m_Slots[i]:getTemplateItem():isTradable()) then
                confirmAllowed = false
                break
            end
        end
    end
    if confirmAllowed then
        triggerServerEvent("RP:Server:Trading:confirm", resourceRoot)
    else
        localPlayer:sendNotification(loc"NON_TRADABLE_ERROR", 255, 0, 0)
    end
end

function Trading:Action_Close()
    triggerServerEvent("RP:Server:Trading:close", resourceRoot)
end

function Trading:Action_Reset()
    triggerServerEvent("RP:Server:Trading:reset", resourceRoot)
end

function Trading:Event_RefreshConfirmation(playerConfirmation, targetConfirmation)
    -- Change player ready check
    if playerConfirmation then
        self.m_SelfMark:setText(Trading.AcceptMark)
        self.m_SelfMark:setColor(0, 255, 0)
    else
        self.m_SelfMark:setText(Trading.DeclineMark)
        self.m_SelfMark:setColor(255, 0, 0)
    end
    -- Change target ready-check
    if targetConfirmation then
        self.m_PartnerMark:setText(Trading.AcceptMark)
        self.m_PartnerMark:setColor(0, 255, 0)
    else
        self.m_PartnerMark:setText(Trading.DeclineMark)
        self.m_PartnerMark:setColor(255, 0, 0)
    end

    self.m_Window:sthChanged()
end

function Trading:Event_RefreshTrading(playerItems, targetItems, yourState, partnerState)
    self:reset()
    self:refreshTrading(playerItems, targetItems, yourState, partnerState)
end

function Trading:refreshTrading(playerItems, targetItems, yourState, partnerState)
    for key, value in ipairs(self.m_Slots) do
        if ( key >= 1 and key <= 6 ) then
            if playerItems[key] then
                value:setItem(playerItems[key].Item)
            end
        else -- key >= 7 and key <= 12
            if targetItems[key - 6] then
                value:setItem(targetItems[key - 6].Item)
            end
        end
    end

    self.m_Window:sthChanged()
end

function Trading:Event_InitTrading(tradingPartner)
    self:initTrading(tradingPartner)
end

function Trading:initTrading(tradingPartner)
    self:reset()
    self.m_SelfName:setText(localPlayer:getName())
    self.m_PartnerName:setText(tradingPartner:getName())
    
    itemmanager:openInventory()

    self.m_Window:setVisible(true)
end

function Trading:Event_CloseWindow()
    self:closeWindow()
end

function Trading:closeWindow()
    self:reset()
    self.m_Window:setVisible(false)
end

function Trading:sendChange(itemFrame, storage)
    -- Get Frame Id
    local slot = self:getSlotByFrame(itemFrame)

    -- Send item change to the server
    if itemFrame:getItem() then
        triggerServerEvent("RP:Server:Trading:itemChange", resourceRoot, itemFrame:getItem(), slot, storage:getGeneral(), storage:getSpecific())
    else
        triggerServerEvent("RP:Server:Trading:itemDelete", resourceRoot, slot)
    end
end

function Trading:getSlotByFrame(itemFrame)
    for key, value in ipairs(self.m_Slots) do
        if value == itemFrame then
            return key
        end
    end
end

function Trading:getSlots()
    return self.m_Slots
end

function Trading:isEligibleToDrop(frame)
    local answ = false
    for i = 1, 6, 1 do
        if self.m_Slots[i] == frame then
            answ = true
            break
        end
    end
    return answ
end

function Trading:refresh()
    
end

function Trading:reset()

    for key, value in ipairs(self.m_Slots) do
        value:reset()
    end
    self:refresh()
    self.m_Window:sthChanged()
end