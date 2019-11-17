CraftingGUI = inherit(Singleton)

addEvent("RP:Client:Crafting:receiveCraftingRequirements", true)

CraftingGUI.TIME_TO_CRAFT = 1500 -- ## in ms

function CraftingGUI:constructor()
    self.m_Active = false

    self.m_BindGridClick = bind(self.Action_OnGridClick, self)
    self.m_BindRender = bind(self.draw, self)

    addCommandHandler("crafting", bind(self.Command_Open, self))

    -- self:open()
    addEventHandler("RP:Client:Crafting:receiveCraftingRequirements", root, bind(self.Event_ReceiveCraftingRequirements, self))

end

function CraftingGUI:Command_Open()
    self:open()
end

function CraftingGUI:close()
    if self.m_Active then
        delete(self.m_Window)
        self.m_Active = false
    end
    showCursor(false)
    removeEventHandler("onClientRender", root, self.m_BindRender)
end

CraftingGUI.BackgroundColor = tocolor(100, 100, 100, 150)

function CraftingGUI:open()
    self:close()
    showCursor(true)
    
    self.m_Active = true

    self.m_Crafting = {}
    for i = 1, CRAFTING_REQUIREMENT_AMOUNT do self.m_Crafting[i] = {} end
    

    self.m_Window = GUIWindow:new(screenWidth/2 - 659/2, screenHeight/2 - 415 / 2, 659, 415, "Crafting - " .. localPlayer:getData("CraftingSkill") .. "/" .. CRAFTING_HIGHEST_SKILL, true)
    self.m_CraftingGrid = GUIGridList:new(10, GUIWindow.TitleThickness + 5, 267, 355, self.m_Window)
    self.m_Craftingdivision = GUIRectangle:new(291, GUIWindow.TitleThickness, 5, 386, self.m_Window):setColor(XTREAM_ORANGE_TOCOLOR)
    self.m_FinalBackGround = GUIRectangle:new(319, 29, 250, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_FinalItem = ItemFrameTemplate:new(319, 29, 59, 59, self.m_Window)
    self.m_FinalItemText = GUILabel:new("Craftingsystem!", 392, 25, 182, 63, self.m_Window)
    self.m_FinalItem:setTemplateItem(70)

    -- self.m_Available = GUIClassicButton:new("Bekannte",10, GUIWindow.TitleThickness + 5, 267/2 - 5, 24, self.m_Window)
    -- self.m_Unknown = GUIClassicButton:new("Unbekannte",10 + 267/2 + 5, GUIWindow.TitleThickness + 5, 267/2 - 5, 24, self.m_Window)

    self.m_Crafting[1].Background = GUIRectangle:new(319, 120, 156, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_Crafting[1].ItemFrame = CraftingFrame:new(319, 120, 59, 59, self.m_Window)
    self.m_Crafting[2].Background = GUIRectangle:new(475, 120, 156, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_Crafting[2].ItemFrame = CraftingFrame:new(475, 120, 59, 59, self.m_Window)
    self.m_Crafting[3].Background = GUIRectangle:new(319, 215, 156, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_Crafting[3].ItemFrame = CraftingFrame:new(319, 215, 59, 59, self.m_Window)
    self.m_Crafting[4].Background = GUIRectangle:new(475, 215, 156, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_Crafting[4].ItemFrame = CraftingFrame:new(475, 215, 59, 59, self.m_Window)
    self.m_Crafting[5].Background = GUIRectangle:new(319, 300, 156, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_Crafting[5].ItemFrame = CraftingFrame:new(319, 300, 59, 59, self.m_Window)
    self.m_Crafting[6].Background = GUIRectangle:new(475, 300, 156, 59, self.m_Window):setColor(CraftingGUI.BackgroundColor):setInteractable(false)
    self.m_Crafting[6].ItemFrame = CraftingFrame:new(475, 300, 59, 59, self.m_Window)
  
    -- move the labels to the bot so they're above the background in the render-order
    self.m_Crafting[1].Label     = GUILabel:new("Select an item in the gridlist to start crafting!", 378, 120, 97, 59, self.m_Window)
    self.m_Crafting[2].Label     = GUILabel:new("", 534, 120, 97, 59, self.m_Window)
    self.m_Crafting[3].Label     = GUILabel:new("Red blueprints are not yet discovered!", 378, 215, 97, 59, self.m_Window)
    self.m_Crafting[4].Label     = GUILabel:new("", 534, 215, 97, 59, self.m_Window)
    self.m_Crafting[5].Label     = GUILabel:new("A number behind an item indicates that\nyour crafting-skill is not high enough", 378, 300, 97, 59, self.m_Window)
    self.m_Crafting[6].Label     = GUILabel:new("", 534, 300, 97, 59, self.m_Window)         

    self.m_Create = GUIClassicButton:new("Herstellen", 319, 376, 90, 29, self.m_Window)
    self.m_Cancel = GUIClassicButton:new("Abbrechen", 419, 376, 90, 29, self.m_Window)
    self.m_Window:setColor(50, 50, 50, 200)

    self.m_CraftTimer = false


    self.m_CraftingGrid:addColumn("", 0.05)
    self.m_CraftingGrid:addColumn("Name", 0.95)

    self:loadActiveReceipes()

    self.m_Create.onLeftUp = bind(self.Action_StartCraft, self)
    self.m_Cancel.onLeftUp = bind(self.Action_CancelCraft, self)
    self.m_CraftingGrid.onGridSelect = self.m_BindGridClick

    self.m_Window:setVisible(true)
    
    self.m_Window:getTitleLabel():setFont("default-bold")
    self.m_Window:getCloseButton().onLeftUp = bind(self.close, self)  

    addEventHandler("onClientRender", root, self.m_BindRender, false, "low")
end

function CraftingGUI:Action_OnGridClick()
    local row = self.m_CraftingGrid:getActiveRow()

    if not row then return end
    if row.CraftingID then
        triggerServerEvent("RP:Server:Crafting:requestRequirements", resourceRoot, row.CraftingID)
    end
end

function CraftingGUI:Action_StartCraft()
    if isTimer(self.m_CraftTimer) then
        return
    end
    
    local row = self.m_CraftingGrid:getActiveRow()

    if not row then return end

    if row.CraftingID then
        self.m_CraftTimer = Timer(bind(self.Callback_TriggerCraft, self, row.CraftingID), CraftingGUI.TIME_TO_CRAFT, 1)
    end
end

function CraftingGUI:Callback_TriggerCraft(id)
    triggerServerEvent("RP:Server:Crafting:craftItem", resourceRoot, id)
end

function CraftingGUI:Action_CancelCraft()
    if isTimer(self.m_CraftTimer) then
        killTimer(self.m_CraftTimer)
        localPlayer:sendNotification("CRAFTING_CANCEL")
    end
end

function CraftingGUI:draw()
    if isTimer(self.m_CraftTimer) then
        local timeLeft, leftExecutes, totalExecutes = self.m_CraftTimer:getDetails()
        local time = CraftingGUI.TIME_TO_CRAFT
        local progress = (time-timeLeft)/time
        dxDrawRectangle(screenWidth/2 - 150/2, screenHeight/2 - 30/2, 150, 30, tocolor(0, 0, 0))
        dxDrawRectangle(screenWidth/2 - 150/2, screenHeight/2 - 30/2, 150*progress, 30, tocolor(0, 125, 0))
        dxDrawBorderedTextExt(1, "Crafting", screenWidth/2 - 150/2, screenHeight/2 - 30/2, screenWidth/2 + 75, screenHeight/2 + 15,
                            tocolor(255, 255, 255), 1.5, "default-bold", "center", "center")
    end
end

function CraftingGUI:loadActiveReceipes()
    local receipes = itemmanager:getSingleton():getCraftingReceipes()

    local category = {}
    local knownReceipes = localPlayer:getData("KnownReceipes")
        
    for key, value in pairs(receipes) do
        if not category[value:getCategory()] then
            category[value:getCategory()] = {}
        end
        table.insert(category[value:getCategory()], value)
    end

    for key, cat in pairs(category) do
        local row = self.m_CraftingGrid:addRow()
        row:setValue("Name", key)
        row:setColor(50, 50, 50, 240)
        row:setInteractable(false)
        for key, value in ipairs(cat) do
            -- Control if the player doesnt know the receipe and it should kept secret

            local addItem = true

            if not knownReceipes[value:getReceiptId()] and value:isSecret() then
                addItem = false
            end

            -- dont let the item on the list if the localPlayer isnt fulfilling its requirement
            if not localPlayer:isFullfillingItemCondition(value:getRewardItem()) then
                addItem = false
            end

            -- creates the receipt and checks if its craftable or not
            if addItem then
                local row = self.m_CraftingGrid:addRow()
                row.CraftingID = value:getReceiptId()
                row:setValue("Name", itemmanager:getItemTemplate(value:getRewardItem()):getName())
                -- Set the text red if the player doesnt know the receipt
                if not knownReceipes[value:getReceiptId()] and localPlayer:getData("CraftingSkill") >= value:getSkillRequirement() then
                    row:setColor(255, 0, 0, 200)
                elseif knownReceipes[value:getReceiptId()] and not (localPlayer:getData("CraftingSkill") >= value:getSkillRequirement()) then
                    row:setColor(255, 0, 0, 200)
                    row:setValue("Name", ("%s - [%d]"):format(itemmanager:getItemTemplate(value:getRewardItem()):getName(), value:getSkillRequirement()) )              
                elseif knownReceipes[value:getReceiptId()] then
                    row:setColor(0, 255, 0, 200)
                else
                    row:setColor(255, 0, 0, 200)
                end
            end
        end
    end 
end

function CraftingGUI:Event_ReceiveCraftingRequirements(id, currentInformation)
    self:loadReceipt(id, currentInformation)
end

function CraftingGUI:loadReceipt(id, currentInformation)

    -- Change window title maybe the level changed
        self.m_Window:getTitleLabel():setText("Crafting - " .. localPlayer:getData("CraftingSkill") .. "/" .. CRAFTING_HIGHEST_SKILL)
    --

    local receipt = itemmanager:getCraftingReceipt(id)
    local requirements = receipt:getRequiredItems()

    local finalItem = receipt:getRewardItem()
    local finalAmount = receipt:getRewardAmount()

    self.m_FinalItem:setTemplateItem(finalItem)
    self.m_FinalItem:setAmount(finalAmount)
    self.m_FinalItemText:setText(itemmanager:getItemTemplate(finalItem):getName())
    
    for i = 1, CRAFTING_REQUIREMENT_AMOUNT, 1 do
        if not (requirements[i].Item > 0) then
            self.m_Crafting[i].Background:setVisible(false)
            self.m_Crafting[i].ItemFrame:setVisible(false)
            self.m_Crafting[i].Label:setVisible(false)             
        else
            self.m_Crafting[i].ItemFrame:setTemplateItem(requirements[i].Item)
            self.m_Crafting[i].ItemFrame:setRequiredAmount(requirements[i].Amount)
            self.m_Crafting[i].ItemFrame:setCurrentAmount(currentInformation[i])
            self.m_Crafting[i].Label:setText(itemmanager:getItemTemplate(requirements[i].Item):getName())
            self.m_Crafting[i].Background:setVisible(true)
            self.m_Crafting[i].ItemFrame:setVisible(true)
            self.m_Crafting[i].Label:setVisible(true)  
        end

    end
end

