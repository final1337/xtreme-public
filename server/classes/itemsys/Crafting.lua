Crafting = inherit(Singleton)

addEvent("RP:Server:Crafting:getItemAmount")
addEvent("RP:Server:Crafting:requestRequirements", true)
addEvent("RP:Server:Crafting:craftItem", true)

    -- Position as vector, dimension, interior, craftingReceiptId
Crafting.FoundReceipes = {
    {Vector3(-2487.02637, 2353.43823, 4.99229), 0, 0, 3},
    {Vector3(1267.42957, 1335.03650, 10.81298), 0, 0, 4},
    {Vector3(-1425.46045, -967.29626, 200.83177), 0, 0, 5},
    {Vector3(2789.63428, -1426.20593, 32.12500), 0, 0, 6},
}

function Crafting:constructor()
    addEventHandler("RP:Server:Crafting:requestRequirements", resourceRoot, bind(self.Event_RequestRequirements, self))
    addEventHandler("RP:Server:Crafting:craftItem", resourceRoot, bind(self.Event_CraftItem, self))

    self:loadReceiptPickups()

    addEventHandler("onPickupHit", root, bind(self.Event_OnPickupHit, self))
end

function Crafting:loadReceiptPickups()
    for key, value in ipairs(Crafting.FoundReceipes) do
        local pickup = Pickup(value[1], 3, 1248, 50, -1)
        pickup:setInterior(value[2])
        pickup:setDimension(value[3])
        pickup:setData("CraftingReceipt", value[4])
    end
end

function Crafting:Event_OnPickupHit(hitElement)
    if ( source:getData("CraftingReceipt") ) then
        if ( hitElement:getType() == "player" ) then
            if not hitElement:getData("KnownReceipes")[source:getData("CraftingReceipt")] then
                local item = itemmanager:getCraftingReceipt(source:getData("CraftingReceipt")):getRewardItem()
                local name = itemmanager:getTemplate(item):getName()
                hitElement:sendNotification("CRAFTING_FOUND_RECEIPT", 0, 125, 0, name)
                hitElement:learnReceipt(source:getData("CraftingReceipt"))
            else
                hitElement:sendNotification("CRAFTING_ALREADY_KNOWN", 125, 0, 0)
            end
        end
    end
end

function Crafting:Event_RequestRequirements(id)
    if not client then return end
    self:requestRequirements(client, id)
end

function Crafting:requestRequirements(player, id)
    local receipt = itemmanager:getCraftingReceipt(id):getRequiredItems()
    local current = {}
    for i = 1, CRAFTING_REQUIREMENT_AMOUNT, 1 do
        if receipt[i].Item > 0 then
            current[i] = player:getTotalItemAmount(receipt[i].Item)
        end
    end
    player:triggerEvent("RP:Client:Crafting:receiveCraftingRequirements", id, current)
end 

function Crafting:Event_CraftItem(id)
    if not client then return end
    self:craftItem(client, id)
end

function Crafting:isAbleToCraft(player, id)
    local receipt = itemmanager:getCraftingReceipt(id):getRequiredItems()

    for i = 1, CRAFTING_REQUIREMENT_AMOUNT, 1 do
        if receipt[i].Item > 0 then
            if player:getTotalItemAmount(receipt[i].Item) < receipt[i].Amount then
                return false
            end
        end
    end
    return true    
end

function Crafting:increaseSkill(player, amount)
    player:setData("CraftingSkill", math.min(CRAFTING_HIGHEST_SKILL, player:getData("CraftingSkill") + amount))
end

function Crafting:craftItem(player, id)
    local receipt = itemmanager:getCraftingReceipt(id)
    
    if not player:getStorages()[1]:hasPlace() then
        player:sendNotification("CRAFTING_MAIN_INVENTORY_FULL")
        return
    end

    if player:getData("CraftingSkill") < receipt:getSkillRequirement() then
        player:sendNotification("CRAFTING_SKILL_NOT_HIGH_ENOUGH")
        return
    end

    if not self:isAbleToCraft(player, id) then
        player:sendNotification("CRAFTING_NO_REQUIREMENTS")
        return
    end

    if not player:getData("KnownReceipes")[id] then
        player:sendNotification("CRAFTING_NO_RECEIPT")
        return        
    end

    
    local requirements = receipt:getRequiredItems()

    -- Remove player items
    for i = 1, CRAFTING_REQUIREMENT_AMOUNT, 1 do
        if requirements[i].Item > 0 then
            player:takeItemAmount(requirements[i].Item, requirements[i].Amount)
        end
    end

    -- Give player item-reward
    local item = player:addItem(receipt:getRewardItem(), receipt:getRewardAmount())
    item:merge()

    -- increae players crafting skill by 1
    self:increaseSkill(player, 1)
    player:sendNotification("CRAFTING_SUCCESS", 0, 255, 0, item:getTemplateItem():getName(), receipt:getRewardAmount())

    self:requestRequirements(player, id)
end