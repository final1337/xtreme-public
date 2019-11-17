Storage = inherit(Object)

Storage.BLACKLISTED = "SERVERSTORAGE_"
	
--[[
	virtual class
]]
function Storage:constructor(storageType)

	self.m_Items = {}

	self.m_StorageType = storageType
	self.m_MaxSize = self:getMaxSize()

	self.m_InteractingPlayers = {}

end

function Storage:addInteractingPlayer(player)
	if not self:isInteractingPlayer(player) then
		player:addSelectedStorage(self)
		table.insert(self.m_InteractingPlayers, player)
	end
end

function Storage:isInteractingPlayer(player)
	for key, value in ipairs(self.m_InteractingPlayers) do
		if value == player then
			return true
		end
	end
	return false
end

function Storage:removeInteractingPlayer(player)
	player:removeSelectedStorage(self)
	for key, value in ipairs(self.m_InteractingPlayers) do
		if value == player then
			table.remove(self.m_InteractingPlayers, key)
			return
		end
	end
end

function Storage:flushInteractionPlayers() self.m_InteractingPlayers = {}  end

function Storage:getInteractingPlayers() return self.m_InteractingPlayers end

function Storage:getMaxSize()
	return storagesettings:getStorageSettings(self.m_StorageType):getSize() or 0
	-- return Storage.SIZES[self.m_StorageType] or 0
end

function Storage:getType() return self.m_StorageType end

function Storage:initItem(slot, uid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext)
	
	local itemClass = itemmanager:getItem(itemId):getClass()
	itemClass = Item.Classes[itemClass]
	if itemClass then
		self.m_Items[slot] = itemClass:new(uid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, self)
	end
end

--[[
	returns: slot if it worked; false if failed
]]

function Storage:addItem(item)
	if self:hasPlace() then
		local slot = self:getFreeSlot()
		if slot then
			item:setStorage(self)
			self.m_Items[slot] = item

			return slot
		end
	end
	return false
end

function Storage:mergeItem(item)
	for key, value in pairs(self.m_Items) do
		if value:getItemId() == item:getItemId() and value:getUniqueIdentifier() ~= item:getUniqueIdentifier() then
			if not value:getTemporary() and not item:getTemporary() or ( value:getTemporary() and item:getTemporary() ) then
				value:setAmount(value:getAmount() + item:getAmount())
				item:getStorage():destroyItem(self:getItemSlot(item))
				return key
			end
		end
	end
	return false
end

function Storage:getFreeSlot()
	for i = 1, self:getMaxSize(), 1 do
		if not self.m_Items[i] then
			return  i
		end
	end
	-- no free slot
	return false
end

function Storage:changeItemSlot(currentSlot, wantedSlot)
	if wantedSlot <= self:getMaxSize() then
		if not self.m_Items[wantedSlot] and self.m_Items[currentSlot] then
			self.m_Items[wantedSlot] = self.m_Items[currentSlot]
			self.m_Items[currentSlot] = nil
			return true
		end
	end
	return false
end

function Storage:hasPlace()
	return (self:getOccupiedSlots() + 1 <= self:getMaxSize())
end

function Storage:getOccupiedSlots()
	local i = 0
	for key, value in pairs(self.m_Items) do
		i = i + 1
	end
	return i
end

function Storage:getFreeSlotAmount()
	return self:getMaxSize() - self:getOccupiedSlots()
end

function Storage:decrementItemAmount(slot)
	local item = self:getItems()[slot]
	item:setAmount(item:getAmount()-1)
	if item:getAmount() <= 0 then
		-- use other storage types; eventually
		if item.destroyItem then
			item:destroyItem(slot)
		end

		item:getStorage():destroyItem(slot)
	end
end

function Storage:getItemAmount(itemId)
	local i = 0
	for key, value in pairs(self:getItems()) do
		if value:getItemId() == itemId then
			i = i + value:getAmount()
		end
	end
	return i
end

function Storage:takeItemAmount(itemId, lossAmount)
	local itemType, amount, items, lossAmount = itemId, 0, {}, lossAmount
	for key, value in pairs(self:getItems()) do
		if value:getItemId() == itemType then
			amount = amount + value:getAmount()
			table.insert(items, {item = value, slot = key})
			-- we already got enough, so end the for-loop and continue with the decrementation of the items
			if amount >= lossAmount then
				break
			end
		end
	end
	if amount >= lossAmount then
		for key, entry in ipairs(items) do
			local value = entry.item
			local itemAmount = value:getAmount()
			if itemAmount - lossAmount > 0 then
				value:setAmount(itemAmount-lossAmount)
				lossAmount = 0
				break
			else
				self:destroyItem(entry.slot)
				lossAmount = lossAmount - itemAmount
			end
		end
		return true
	end
	return false
end

-- // completly removes the item from the database and the server
function Storage:destroyItem(slot)
	if self.m_Items[slot] then
		if not self.m_Items[slot]:getTemporary() then
		dbExec(newDBHandler, "DELETE FROM item_instance WHERE uid = ?", 
							self.m_Items[slot]:getUniqueIdentifier())
		end

		-- deselect item if available
		if self.m_Element and self.m_Element.m_SelectedItem == self.m_Items[slot] then
			self.m_Element:deselectItem()
		end		

		delete(self.m_Items[slot])
		self.m_Items[slot] = nil
		return true
	end
	return false
end

-- // removes the item from the storage
function Storage:removeItem(slot)
	if self.m_Items[slot] then
		self.m_Items[slot] = nil
		return true
	end
	return false
end

function Storage:changeItemStorage(slot, storage)
	if storage:addItem(self.m_Items[slot]) then
		self.m_Items[slot] = nil
		return true
	end
	return false
end

function Storage:getItemSlot(item)
	for key, value in pairs(self.m_Items) do
		if value == item then
			return key
		end
	end
	-- return false, if the item is not in this storage
	return false
end

-- // returns item and slot

function Storage:getItemByUId(uid)
	for key, value in pairs(self.m_Items) do
		if value:getUniqueIdentifier() == uid then
			return value, key
		end
	end
	return false
end

function Storage:changeItemOwner(slot, storage, item)
	if self:changeItemStorage(slot, storage) then
		return true
	end
	return false
end

function Storage:getSettings()
	return storagesettings:getStorageSettings(self.m_StorageType)
end

function Storage:getItems()
	return self.m_Items
end

-- Purpose: Delete all items

function Storage:destructor()
	local string = ""

	for key, value in pairs(self.m_Items) do
			if not value:getTemporary() then
				string = ("UPDATE item_instance SET amount = %d, flags = \"%s\", durability= %d, played = %d, specialtext = \"%s\" WHERE uid = \"%s\""):format(
						 value:getAmount(), value:getFlags(), value:getDurability(), value:getPlayed(), value:getSpecialText(), value:getUniqueIdentifier())

				dbExec(newDBHandler, string)
			end
	end
end