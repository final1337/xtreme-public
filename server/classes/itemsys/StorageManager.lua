StorageManager = inherit(Object)
--inherit(LobbyChild, StorageManager)

addEvent("Storage:getStorageItems", true)
addEvent("Storage:swapItems", true)
addEvent("Storage:splitItem", true)
addEvent("Storage:selectItem", true)
addEvent("Storage:switchItem", true)
addEvent("Storage:changeSlot", true)
addEvent("Storage:useItem", true)
addEvent("Storage:deleteItem", true)
addEvent("Storage:StorageClosed", true)
addEvent("RP:Server:StorageManager:fastSwitch", true)

StorageManager.VALID_REQUESTS = {
	["OwnStorage"] = true,
	["VehicleStorage"] = true,
	["FactionStorage"] = true,
	["TradeStorage"] = false,
}

--//TODO: Add synchronization if more than 1 person is interacting with the storage

function StorageManager:constructor(lobby)
	--LobbyChild.constructor(self, lobby)

	addEventHandler("Storage:getStorageItems", resourceRoot, bind(self.Event_GetStorageItems, self))
	addEventHandler("Storage:swapItems",  resourceRoot, bind(self.Event_SwapItems, self))
	addEventHandler("Storage:selectItem", resourceRoot, bind(self.Event_SelectItem, self))
	addEventHandler("Storage:switchItem", resourceRoot, bind(self.Event_SwitchItem, self))
	addEventHandler("Storage:changeSlot", resourceRoot, bind(self.Event_ChangeSlot, self))
	addEventHandler("Storage:useItem",    resourceRoot, bind(self.Event_UseItem, self))
	addEventHandler("Storage:StorageClosed", resourceRoot, bind(self.Event_StorageClosed, self))
	addEventHandler("Storage:deleteItem", resourceRoot, bind(self.Event_DeleteItem, self))
	addEventHandler("Storage:splitItem", resourceRoot, bind(self.Event_SplitItem, self))
	addEventHandler("RP:Server:StorageManager:fastSwitch", resourceRoot, bind(self.Event_FastSwitch, self))

	self.m_StorageSettings = {}

	self:loadSettings()
end

function StorageManager:Event_StorageClosed(general, specific)
	if not client then return end
	--if not self:getLobby():isPlayerInLobby(client) then return end
	local storage = self:getStorageBySpecification(client, general, specific)

	storage:removeInteractingPlayer(client)
end

function StorageManager:loadSettings()
	local rootNode = xmlLoadFile("shared/StorageInfos.xml")

	local optionsNode = xmlFindChild(rootNode, "options", 0)

	local i = 0

	while xmlFindChild(optionsNode, "storage", i) do

		local child = xmlFindChild(optionsNode, "storage", i)

		local type = tonumber(xmlNodeGetAttribute(child,"type"))
		local size = xmlNodeGetAttribute(child,"size")
		size = size == "unlimited" and math.huge or tonumber(size)
		local usage = xmlNodeGetAttribute(child,"useage") == "true"
		local name = xmlNodeGetAttribute(child,"name")

		self.m_StorageSettings[type] = StorageSettings:new(type, name, size, usage)

		i = i + 1
	end

	xmlUnloadFile(rootNode)
end

function StorageManager:getStorageSettings(type)
	if not type then type = 5000 end
	return self.m_StorageSettings[type]
end

function StorageManager:Event_GetStorageItems(general, specific, justInformation)
	if not client then return end
	if general == "VehicleStorage" then
		if not specific:isAligable(client) then
			return
		end
	end
	self:getStorageItems(client, general, specific, justInformation)
end

function StorageManager:getStorageItems(player, general, specific, justInformation)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	local storage = self:getStorageBySpecification(player, general, specific)
	storage:addInteractingPlayer(player)

	self:sendRequestedItems(player, general, specific, justInformation)
end

function StorageManager:Event_UseItem(general, specific, uniqueIdentifier)
	if not client then return end
	self:useItem(client, general, specific, uniqueIdentifier)
end

function StorageManager:useItem(player, general, specific, uniqueIdentifier)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	local storage = self:getStorageBySpecification(player, general, specific)
	if storage then
		local usable = storagesettings:getStorageSettings(storage:getType()):getUsage()
		local item, slot = storage:getItemByUId(uniqueIdentifier)
		if item then
			player:useSpecificItem(item)

			for key, value in ipairs(storage:getInteractingPlayers()) do
				self:sendRequestedItems(value, general, specific)
			end		
		end
	end
end

function StorageManager:Event_FastSwitch(amount, forced)
	if not client then return end
	self:fastSwitch(client, amount, forced)
end

function StorageManager:fastSwitch(player, amount, forced)
	if getControlState(player,"aim_weapon") then return end
	--if not self:getLobby():isPlayerInLobby(player) then return end
	takeAllWeapons(player)
	local general = "OwnStorage"
	local specific = 2
	local storage = self:getStorageBySpecification(player, general, specific)
	local items = storage:getItems()
	local currentItem = player.m_SelectedItem
	local sizeOfInventory = storagesettings:getStorageSettings(2):getSize()
	local next = player.m_SelectedIter + amount
	
	
	local copyTable = {}
	
	for key, value in pairs(items) do
		copyTable[key] = value
	end
	

	copyTable[11] = true
	
	local currentIter = player.m_SelectedIter
	
	if sizeOfInventory == storage:getFreeSlotAmount() then
		return
	else
		if amount == -1 then
			for i = 1, sizeOfInventory+1, 1 do
				currentIter = currentIter - 1
				if copyTable[currentIter] then
					break
				end				
				if currentIter <= 1 then
					currentIter = 11
					if copyTable[currentIter] then
						break
					end		
				end
			end
		elseif amount == 1 then
			for i = 1, sizeOfInventory+1, 1 do
				currentIter = currentIter + 1
				if copyTable[currentIter] then
					break
				end				
				
				if currentIter >= 11 then
					currentIter = 1
					if copyTable[currentIter] then
						break
					end						
				end
			end
		end
	end
	

	if currentIter == 11 then
		if player.m_SelectedItem then
			player:deselectItem()
		end
	end

	player.m_SelectedIter = currentIter
	
	if items[currentIter] and currentIter ~= 11 then

		player:selectItem(player.m_SelectedIter)
	end

end

function StorageManager:Event_SelectItem(general, specific, uniqueIdentifier)
	if not client then return end
	self:selectItem(client, general, specific, uniqueIdentifier)
end

function StorageManager:selectItem(player, general, specific, uniqueIdentifier)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	if general == "OwnStorage" and specific == 2 then
		takeAllWeapons(player)
		local storage = self:getStorageBySpecification(player, general, specific) -- get the fast selection storage
		local item, slot = storage:getItemByUId(uniqueIdentifier)
		-- call player switch method
		player:selectItem(slot)
	end
end


--[[
## Class: StorageManager
## Method: Event_SplitItem
## Purpose: Splits up in halves or a specific amount
]]

function StorageManager:Event_SplitItem(general, specific, uid, amount)
	if not client then return end
	self:splitItem(client, general, specific, uid, amount)
end

function StorageManager:splitItem(player, general, specific, uid, amount)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	local storage = self:getStorageBySpecification(player, general, specific)
	local item, slot = storage:getItemByUId(uid)
	if item and slot then
		local currentAmount = item:getAmount()
		amount = amount or math.floor(currentAmount/2)
		amount = math.abs(amount)
		if amount > 0 and storage:hasPlace() and amount <= currentAmount then
			newItem = itemmanager:add(item:getItemId(), player:getId(), player:getId(), player:getId(), amount, 0, 0, 100, 0, item:getSpecialText(), storage, item:getTemporary())
			storage:addItem(newItem)
			item:setAmount(item:getAmount()-amount)

			for key, value in ipairs(storage:getInteractingPlayers()) do
				self:sendRequestedItems(value, general, specific)
			end					
		end
	end
end

function StorageManager:Event_DeleteItem(general, specific, uid)
	if not client then return end
	self:deleteItem(client, general, specific, uid)
end

function StorageManager:deleteItem(player, general, specific, uid)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	
	local storage = self:getStorageBySpecification(player, general, specific)
	local item, slot = storage:getItemByUId(uid)
	if item then

		if item == player:getSelectedItem() then
			player:deselectItem()
		end	

		storage:destroyItem(slot)

		for key, value in ipairs(storage:getInteractingPlayers()) do
			self:sendRequestedItems(value, general, specific)
		end		

	end
end

-- USED FOR NON SWAPPING HANDLINGS WITHIN THE INVENTORIES

function StorageManager:Event_SwitchItem(originGeneral, originSpecifc, originUniqueIdentifier, destinationGeneral, destinationSpecific)
	if not client then return end
	self:switchItem(client, originGeneral, originSpecifc, originUniqueIdentifier, client, destinationGeneral, destinationSpecific)
end

function StorageManager:switchItem(player, originGeneral, originSpecifc, originUniqueIdentifier, target, destinationGeneral, destinationSpecific)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	local originStorage = self:getStorageBySpecification(player, originGeneral, originSpecifc)
	local destinationStorage = self:getStorageBySpecification(target, destinationGeneral, destinationSpecific)

	assert(originStorage and destinationStorage, "invalid storages given")
	local originRank = originStorage:getSettings():getRequiredRank()

	if originRank then
		if originRank and not ( player:getData("Rang") >= originRank ) then 
			player:sendNotification("FACTION_RANK_NOT_HIGH_ENOUGH", 120, 0, 0)
			return
		end
	end	

	local originItem, originSlot = originStorage:getItemByUId(originUniqueIdentifier)

	assert(originItem, "Cant find item within storage @ someone may cheat")
	if originItem then
		if destinationStorage:addItem(originItem) then
			originStorage:removeItem(originSlot)
			-- [[ resend storage information
			for key, value in ipairs(destinationStorage:getInteractingPlayers()) do
				self:sendRequestedItems(value, destinationGeneral, destinationSpecific)
			end
			for key, value in ipairs(originStorage:getInteractingPlayers()) do
				self:sendRequestedItems(value, originGeneral, originSpecifc)
			end			
			--self:sendRequestedItems(player, originGeneral, originSpecifc)
			--self:sendRequestedItems(player, destinationGeneral, destinationSpecific)

			-- ANTI-ABUSE
			if originItem == player:getSelectedItem() then
				player:deselectItem()
			end

		end
	end
end

function StorageManager:Event_ChangeSlot(dragGeneral, dragSpecific, dragUniqueIdentifier, hoverGeneral, hoverSpecific, hoverSlot)
	if not client then return end
	self:changeSlot(client, dragGeneral, dragSpecific, dragUniqueIdentifier, hoverGeneral, hoverSpecific, hoverSlot)
end

--[[
** Name: StorageManager::changeSlot
** Arguments : userdata player, string dragGeneral, string dragSpecific, UID dragUniqueIdentifier
** Arguments2: string hoverGeneral, string hoverSpecific, UID hoverUniqueIdentifier
** Purpose: changes the slot of an item, could happen within the same storage, no items on hoverSlot
]]

function StorageManager:changeSlot(player, dragGeneral, dragSpecific, dragUniqueIdentifier, hoverGeneral, hoverSpecific, hoverSlot)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	local dragStore 	= self:getStorageBySpecification(player, dragGeneral, dragSpecific)
	local hoverStore 	= self:getStorageBySpecification(player, hoverGeneral, hoverSpecific)
	local dragItem, dragSlot	= dragStore:getItemByUId(dragUniqueIdentifier)

	assert(dragStore and hoverStore, "invalid storages given")
	local dragRank = dragStore:getSettings():getRequiredRank()

	if dragRank then
		if dragRank and not ( player:getData("Rang") >= dragRank ) then 
			player:sendNotification("FACTION_RANK_NOT_HIGH_ENOUGH", 120, 0, 0)
			return
		end
	end	

	if hoverStore:hasPlace() then
		dragStore:removeItem(dragSlot)
		local addSlot = hoverStore:addItem(dragItem)
		if addSlot ~= hoverSlot then
			hoverStore:changeItemSlot(addSlot, hoverSlot)
		end

		if dragStore ~= hoverStore then
			for key, value in ipairs(dragStore:getInteractingPlayers()) do
				self:sendRequestedItems(value, dragGeneral, dragSpecific)
			end
		end

		for key, value in ipairs(hoverStore:getInteractingPlayers()) do
			self:sendRequestedItems(value, hoverGeneral, hoverSpecific)
		end		
		
	end

	-- ANTI-ABUSE

	if dragItem == player:getSelectedItem() then
		player:deselectItem()
	end	
end

--// drag:

function StorageManager:Event_SwapItems(dragGeneral, dragSpecific, dragUniqueIdentifier, hoverGeneral, hoverSpecific, hoverUniqueIdentifier)
	if not client then return end
	self:swapItems(client, dragGeneral, dragSpecific, dragUniqueIdentifier, client, hoverGeneral, hoverSpecific, hoverUniqueIdentifier)
end

--[[
** Name: StorageManager::swapItems
** Arguments : userdata player, string dragGeneral, string dragSpecific, UID dragUniqueIdentifier
** Arguemnts2: userdata target, string hoverGeneral, string hoverSpecific, UID hoverUniqueIdentifier
** Purpose: swaps items between two storages
]]

function StorageManager:swapItems(player, dragGeneral, dragSpecific, dragUniqueIdentifier, target, hoverGeneral, hoverSpecific, hoverUniqueIdentifier)
	--if not self:getLobby():isPlayerInLobby(player) then return end
	local dragStore 	= self:getStorageBySpecification(player, dragGeneral, dragSpecific)
	local hoverStore 	= self:getStorageBySpecification(target, hoverGeneral, hoverSpecific)
	local dragItem, dragSlot	= dragStore:getItemByUId(dragUniqueIdentifier)
	local hoverItem, hoverSlot 	= hoverStore:getItemByUId(hoverUniqueIdentifier)
	assert(dragItem and hoverItem, "StorageManager:Event_SwapItems cant find item within storages @ someone may cheat")

	local dragRank = dragStore:getSettings():getRequiredRank()
	local hoverRank = hoverStore:getSettings():getRequiredRank()

	if dragRank or hoverRank then
		if dragRank and not ( player:getData("Rang") >= dragRank ) then
			player:sendNotification("FACTION_RANK_NOT_HIGH_ENOUGH", 120, 0, 0)
			return
		end
		if hoverRank and not ( player:getData("Rang") >= hoverRank ) then
			player:sendNotification("FACTION_RANK_NOT_HIGH_ENOUGH", 120, 0, 0)
			return
		end
	end

	if dragItem and hoverItem then
		if dragItem:getItemId() ~= hoverItem:getItemId() then
			dragStore:removeItem(dragSlot)
			hoverStore:removeItem(hoverSlot)
			local addedDragSlot, addedHoverSlot
			if dragSlot < hoverSlot then
				addedDragSlot = dragStore:addItem(hoverItem)
				addedHoverSlot = hoverStore:addItem(dragItem)
			else
				addedHoverSlot = hoverStore:addItem(dragItem)	
				addedDragSlot = dragStore:addItem(hoverItem)
			end
			dragStore:changeItemSlot(addedDragSlot, dragSlot)
			hoverStore:changeItemSlot(addedHoverSlot, hoverSlot)
		else
			if not hoverItem:getTemporary() and not dragItem:getTemporary() or ( hoverItem:getTemporary() and dragItem:getTemporary() ) then
				hoverItem:setAmount(dragItem:getAmount() + hoverItem:getAmount())
				dragStore:destroyItem(dragSlot)
			else
				player:sendNotification(loc("TEMP_ITEM_MERGE",player))
			end
		end
		-- [[resend storage information
		for key, value in ipairs(dragStore:getInteractingPlayers()) do
			self:sendRequestedItems(value, dragGeneral, dragSpecific)
		end
		for key, value in ipairs(hoverStore:getInteractingPlayers()) do
			self:sendRequestedItems(value, hoverGeneral, hoverSpecific)
		end		

		-- ANTI-ABUSE
		if dragItem == player:getSelectedItem() or hoverItem == player:getSelectedItem() then
			player:deselectItem()
		end

	end
end

--[[
** Name: StorageManager::getStorageBySpecification
** Arguments: userdata player, string general, string, specific
** Purpose: returns the storage which is defined by general and specific
]]

function StorageManager:getStorageBySpecification(player, general, specific)
	local storage, items = false, false
	if (general == "OwnStorage") then
		if (player.m_Storages[tonumber(specific)]) then
			storage = player.m_Storages[specific]
			items = storage:getItems()
		end
	elseif (general == "VehicleStorage") then
		if specific and isElement(specific) then
			if specific:getData("GotStorage") then
				storage = specific.Storage[8]
				items = storage:getItems()
			end
		end
	elseif (general == "FactionStorage") then
		if specific and isElement(specific) then
			if specific:getData("factionBox") then
				local realBox = specific.Parent
				storage = realBox.Storage[5]
				if realBox.LastInteraction == nil then
					factionboxmanager:loadItems(specific)
					realBox.LastInteraction = true
				end
				items = storage:getItems()
			end
		end
	end
	return storage, items
end

--[[
** Name: StorageManager::sendRequestedItems
** Arguments: userdata player, string general, string specific, bool justInformation
** Purpose: sends itemm-information to the client and also triggers storage opening
]]

function StorageManager:sendRequestedItems(player, general, specific, justInformation)
	if not StorageManager.VALID_REQUESTS[general] then return end
	local storage, items = false, false
	local specificInformation = {}
	local generalInformation = {}	
	
	storage, items = self:getStorageBySpecification(player, general, specific)

	if not (storage or items) then return end

	for key, value in pairs(items) do
		specificInformation[key] = {
			UniqueIdentifier = value:getUniqueIdentifier(),
			ItemId = value:getItemId(),
			Owner = value:getOwner(),
			Creator = value:getCreator(),
			Gift = value:getGift(),
			Amount = value:getAmount(),
			Flags = value:getFlags(),
			ConditionFlags = value:getConditionFlags(),
			Durability = value:getDurability(),
			Played = value:getPlayed(),
			SpecialText = value:getSpecialText(),
			Storage = value:getStorage(),
			Temporary = value:getTemporary()			
		}      
	end
															-- ~ 1MB/s
	triggerLatentClientEvent(player, "Storage:receiveStorage", 1024*1024, false, player, specificInformation, general, specific, storage:getType(), justInformation);
end

function StorageManager:send(itemTable)

end

function StorageManager:destructor()

end