ItemManager = inherit(Singleton)

addEvent("Storage:receiveStorage"	, true)
addEvent("Storage:receiveItems"		, true)
addEvent("Storage:showNewItem"		, true)

-- TODO: AT CLIENTSIDE "DATABASE" FOR SAVING WEAPONS -- kinda done;
-- TODO: AT ITEM-CLASS FOR TEMPLATES FOR EASIER HANDLING -- kinda done;

function ItemManager:constructor()
	self.m_Items = {}
	self.m_Receipes = {}
	self.m_Storages = {}
	self.m_StorageItems = {}
	self.m_GeneralInformation = {}
	self.m_SpecificInformation = {}
	self.m_StorageSettings = {}

	self.m_ActiveStorages = 0

	self:loadTemplateItems()
	self:loadItems()

	self.m_Bind_Command_GetInventory = bind(self.Command_GetInventory, self)
	self.m_Bind_Event_ReceiveStorage = bind(self.Event_ReceiveStorage, self)
	self.m_Bind_Event_ShowNewItem = bind(self.Event_ShowNewItem, self)
	self.m_Bind_Event_ClientClicked = bind(self.Event_OnClientClick, self)
	self.m_Bind_Event_ProjectileCreaton = bind(self.Event_ProjectileCreation, self)

end

function ItemManager:activate()
	addCommandHandler("getinv", self.m_Bind_Command_GetInventory)
	addEventHandler("Storage:receiveStorage", root, self.m_Bind_Event_ReceiveStorage)
	addEventHandler("Storage:showNewItem", root, self.m_Bind_Event_ShowNewItem)
	addEventHandler("onClientClick", root, self.m_Bind_Event_ClientClicked)
	addEventHandler("onClientProjectileCreation", root, self.m_Bind_Event_ProjectileCreaton)
end

function ItemManager:deactivate()
	for general, specifics in pairs(self.m_Storages) do
		for specific, storageHimSelf in pairs(specifics) do
			self:closeStorage(general, specific)
		end
	end

	removeCommandHandler("getinv", self.m_Bind_Command_GetInventory)
	removeEventHandler("Storage:receiveStorage", root, self.m_Bind_Event_ReceiveStorage)
	removeEventHandler("Storage:showNewItem", root, self.m_Bind_Event_ShowNewItem)
	removeEventHandler("onClientClick", root, self.m_Bind_Event_ClientClicked)
	removeEventHandler("onClientProjectileCreation", root, self.m_Bind_Event_ProjectileCreaton)
end

function ItemManager:Event_ShowNewItem()

end

function ItemManager:Event_ProjectileCreation(player)
	if player == localPlayer then
		triggerServerEvent("RP:Server:ProjectileCreation", resourceRoot, getProjectileType(source))
	end
end

function ItemManager:Event_OnClientClick(button, state, _, _, wX, wY, wZ, clickedElement)
	if button == "right" and state == "up" then
		if clickedElement and isElement(clickedElement) and clickedElement:getType() == "vehicle" then
			if clickedElement:getData("PermanentVehicle") then
				if not clickedElement:getData("GotStorage") then
					return
				end
				self:refreshStorage("VehicleStorage", clickedElement)
			end
		elseif clickedElement and isElement(clickedElement) and clickedElement:getType() == "object" then
			if getElementModel(clickedElement) == 944 and not getElementData(clickedElement,"factionBox") then
				self:refreshStorage("OwnStorage", 1)
				self:refreshStorage("OwnStorage", 2)				
				self:refreshStorage("OwnStorage", 9)
			elseif isElement(clickedElement) and getElementData(clickedElement,"factionBox") then
				if ( getElementData(clickedElement,"factionBox") == getElementData(localPlayer,"Fraktion") ) or getElementData(clickedElement,"factionBox") == 0 then
					self:refreshStorage("FactionStorage", clickedElement)
				end
			end
		end
	end
end

function ItemManager:Command_GetInventory()
	if not self.m_Storages["OwnStorage"] or not self.m_Storages["OwnStorage"][1] then
		self:refreshStorage("OwnStorage", 1)
		self:refreshStorage("OwnStorage", 2)
		showCursor(true)
	else
		self:getStorage("OwnStorage", 1):close()
		self:getStorage("OwnStorage", 2):close()
		showCursor(false)
	end
end

function ItemManager:openInventory()
	self:refreshStorage("OwnStorage", 1)
	self:refreshStorage("OwnStorage", 2)
	showCursor(true)	
end

function ItemManager:loadSettings()

end

function ItemManager:getActiveStorages() return self.m_ActiveStorages end
function ItemManager:setActiveStorages(storages)
	self.m_ActiveStorages = storages
end

function ItemManager:getStorageSettings(type)
	if not type then type = 5000 end
	return storagesettings.m_StorageSettings[type]
end

function ItemManager:refreshStorage(general, specific, justInformation)
	triggerServerEvent("Storage:getStorageItems", resourceRoot, general, specific, justInformation)
end

function ItemManager:closeStorage(general, specific)
	local storage = self.m_Storages[general][specific]--self:getStorage(general, specific)
	-- delete storage from the index
	self.m_ActiveStorages = self.m_ActiveStorages - 1
	self.m_Storages[general][specific] = nil
	delete(storage)
end

-- TODO: es sollte keinen general-eintrag mehr geben, welcher als einzelnen wert ein StorageFrame besitzt.
function ItemManager:getStorage(general, specific, storageType)
	assert(type(general) == "string" and type(general) == "string", "Bad Argument at ItemManager:getStorage")

	if not self.m_Storages[general] then
		self.m_Storages[general] = {}
	end
	if self.m_Storages[general][specific] then
		self:closeStorage(general, specific)
	end

	self.m_Storages[general][specific] = StorageFrame:new(general, specific, storageType)
	return self.m_Storages[general][specific]
end

function ItemManager:getTotalStorages()
	local i = 0
	for key, value in pairs(self.m_Storages) do
		i = #value
	end
	return i
end

function ItemManager:getItemTemplate(itemId)
	return self.m_Items[itemId]
end

function ItemManager:getCraftingReceipt(id)
	return self.m_Receipes[id]
end

function ItemManager:getCraftingReceipes()
	return self.m_Receipes
end

function ItemManager:getStorageItems(general, specific)
	if self.m_StorageItems[general] and self.m_StorageItems[general][specific] then
		return self.m_StorageItems[general][specific]
	end
	return false
end

function ItemManager:Event_ReceiveStorage(specificInformation, general, specific, storageType, justInformation)
	if not self.m_SpecificInformation[general] then
		self.m_SpecificInformation[general] = {}
	end
	self.m_SpecificInformation[general][specific] = specificInformation
	
	if justInformation then
		if not self.m_StorageItems[general] then
			self.m_StorageItems[general] = {}
		end
		self.m_StorageItems[general][specific] = specificInformation		
	else
		local k = self:getStorage(general, specific, storageType)
		k:loadItems(specificInformation)
		k.m_Window:setVisible(true)
	end
end


function ItemManager:loadItems()
	triggerServerEvent("ItemManager:requestAllExitingItems", resourceRoot)
end

function ItemManager:loadStorage()

end

function ItemManager:loadTemplateItems()
	self.m_Items = {}
	local file = fileOpen("generated/ItemTemplate.json")
	local results = fromJSON(fileRead(file, fileGetSize(file)))
	fileClose(file)

	for k, v in pairs(results) do
		self.m_Items[v["itementry"]] = ItemTemplate:new(v["itementry"], v["class"], v["subclass"], v["nameDE"], v["nameEN"],
										v["displayPicture"], v["quality"], v["flags"], v["conditionFlags"], v["allowedFactions"],
										v["stackable"], v["maxdurability"], v["duration"], v["specialscript"],
										v["descriptionDE"], v["descriptionEN"], v["tradable"], v["illegal"])
	end

	self.m_Receipes = {}
	file = fileOpen("generated/CraftingTemplate.json")
	results = fromJSON(fileRead(file, fileGetSize(file)))
	fileClose(file)

	for k, v in pairs(results) do
		self.m_Receipes[v["receiptId"]] = CraftingReceipt:new(v.receiptId, v.skillRequired, v.category, v.secret, v.rewardItem, v.rewardAmount,
                                    v.requiredItem1, v.requiredAmount1, v.requiredItem2, v.requiredAmount2, v.requiredItem3, v.requiredAmount3,
                                    v.requiredItem4, v.requiredAmount4, v.requiredItem5, v.requiredAmount5, v.requiredItem6, v.requiredAmount6)
	end	
end

function ItemManager:loadItem()

end

function ItemManager:getItemData(uid)

end

function ItemManager:destructor()

end