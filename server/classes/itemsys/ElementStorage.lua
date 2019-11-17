ElementStorage = inherit(Storage)

function ElementStorage:constructor(storageType, player)
	self.m_Element = player
	
	Storage.constructor(self, storageType)
end

function ElementStorage:getPlayer()
	return self.m_Element
end

-- // see Storage.lua
function ElementStorage:destroyItem(slot)
	local temp = self.m_Items[slot]:getTemporary()
	local bool = Storage.destroyItem(self, slot)
	if bool and not temp then
		dbExec(newDBHandler, "DELETE FROM inventory WHERE owner = ? AND elementType = ? AND inventory = ? AND slot = ?", 
							self.m_Element:getId(), self.m_Element:getType(), self.m_StorageType, slot)
	end
	return bool
end

-- // see Storage.lua
function ElementStorage:removeItem(slot)
	local temp = self.m_Items[slot]:getTemporary()
	local bool = Storage.removeItem(self, slot)
	if bool and not temp then
		dbExec(newDBHandler, "DELETE FROM inventory WHERE owner = ? AND elementType = ? AND inventory = ? AND slot = ?", 
							self.m_Element:getId(), self.m_Element:getType(), self.m_StorageType, slot)
	end	
	return bool
end

function ElementStorage:addItem(item)
	local temp = item:getTemporary()
	local slot = Storage.addItem(self, item)
	if slot and not temp then
		local query = dbQuery(newDBHandler, "SELECT uuid();")
		local uuid = dbPoll(query, -1)[1]["uuid()"]:gsub("-","")
		

		dbExec(newDBHandler, "INSERT INTO inventory (Id, owner, elementType, inventory, slot, item, serverId) VALUES (?,?,?,?,?,?,?)",
													uuid,self.m_Element:getId(), self.m_Element:getType(), self.m_StorageType, slot, item:getUniqueIdentifier(), 1)
	end
	return slot
end

function ElementStorage:changeItemSlot(currentSlot, newSlot)
	local temp = self.m_Items[currentSlot]:getTemporary()
	if Storage.changeItemSlot(self, currentSlot, newSlot) and not temp then
		dbExec(newDBHandler, "UPDATE inventory SET slot = ? WHERE owner = ? AND elementType = ? AND inventory = ? AND slot = ?",
								newSlot, self.m_Element:getId(), self.m_Element:getType(), self.m_StorageType, currentSlot)
	end
end

-- Todo: make that function useful or better
function ElementStorage:changeItemOwner(slot, storage, item)
	local temp = item:getTemporary()
	if Storage.changeItemOwner(self, slot, storage, item) and not temp then
		dbExec(newDBHandler, "DELETE FROM inventory WHERE owner = ? AND inventory = ? AND slot = ?", 
							self.m_Element:getId(), self.m_StorageType, slot)
	end
end