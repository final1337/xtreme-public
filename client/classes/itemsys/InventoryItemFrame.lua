ItemFrame = inherit(ItemFrameTemplate)

function ItemFrame:constructor(posX, posY, width, height, parent)
	ItemFrameTemplate.constructor(self, posX, posY, width, height, parent)

	self.m_Bind_SelectItem = bind(self.Action_SelectItem, self)
	self.m_Bind_UseItem    = bind(self.Action_UseItem, self)	
	self.m_Bind_DeleteItem = bind(self.Action_DeleteItem, self)
	self.m_Bind_HalveItem  = bind(self.Action_HalveItems, self)
	self.m_Bind_SplitItem  = bind(self.Action_SplitItem, self)

	self.m_DefaultTable = {
		{text="Benutzen", func= self.m_Bind_UseItem},
		{text="Teilen", children = 
		{
			{text="Halbieren", func = self.m_Bind_HalveItem},
			{text="Spezifisch", func = self.m_Bind_SplitItem}
		}},
		{text="Löschen", func = self.m_Bind_DeleteItem}
	}

	self.m_StorageInteraction = {

	}

	self.m_FastSelection = {
		{text="Benutzen", func= self.m_Bind_UseItem},
		{text="Selektieren", func= self.m_Bind_SelectItem},
	}

	self.m_Entered = false
end

function ItemFrame:Action_DeleteItem()
	triggerServerEvent("Storage:deleteItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function ItemFrame:Action_SplitItem()
	textquery:start(("Du willst %s teilen. Gebe hier die genaue Anzahl ein!"):format(self:getTemplateItem():getName()),
					"Teilen", "Abbrechen", bind(self.Split_Positive, self), bind(self.Split_Negative, self))
end

function ItemFrame:Split_Negative()

end

function ItemFrame:Split_Positive(amount)
	triggerServerEvent("Storage:splitItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier, tostring(amount))
end

function ItemFrame:Action_HalveItems()
	triggerServerEvent("Storage:splitItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function ItemFrame:Action_SelectItem()
	triggerServerEvent("Storage:selectItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function ItemFrame:Action_UseItem()
	triggerServerEvent("Storage:useItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function ItemFrame:onInternLeftUp()
	self.m_Entered = true

	local dropItemFrame = ItemDragAndDrop:getSingleton():getItemFrame()

	-- Storage controller
	if not dropItemFrame and self:getItem() then
		ItemDragAndDrop:getSingleton():setItemFrame(self)
	elseif dropItemFrame == self then -- handle drag and drop between different itemframes
		ItemDragAndDrop:getSingleton():setItemFrame(false)
	elseif dropItemFrame and self:getItem() and self:isDragable() then
		-- Todo: at serverside handling between frames or storages
		if dropItemFrame.m_ParentStorage and self.m_ParentStorage then
			local dropStorage = dropItemFrame.m_ParentStorage
			local selfStorage = self.m_ParentStorage
			triggerServerEvent("Storage:swapItems", root, 
				dropStorage:getGeneral(), dropStorage:getSpecific(), dropItemFrame.m_UniqueIdentifier,
				selfStorage:getGeneral(), selfStorage:getSpecific(), self.m_UniqueIdentifier
			)
			Tooltip:getSingleton():hide()
			ItemDragAndDrop:getSingleton():setItemFrame(false)
		end
	elseif dropItemFrame and not self:getItem() and self.m_ParentStorage == dropItemFrame.m_ParentStorage then
		if dropItemFrame.m_ParentStorage and self.m_ParentStorage then
			local dropStorage = dropItemFrame.m_ParentStorage
			local selfStorage = self.m_ParentStorage
			triggerServerEvent("Storage:changeSlot", root, 
				dropStorage:getGeneral(), dropStorage:getSpecific(), dropItemFrame.m_UniqueIdentifier,
				selfStorage:getGeneral(), selfStorage:getSpecific(), self.m_ParentStorageSlot
			)
			Tooltip:getSingleton():hide()
			ItemDragAndDrop:getSingleton():setItemFrame(false)
		end
	elseif dropItemFrame and not self:getItem() and self.m_ParentStorage ~= dropItemFrame.m_ParentStorage then
		if dropItemFrame.m_ParentStorage and self.m_ParentStorage then
			local dropStorage = dropItemFrame.m_ParentStorage
			local selfStorage = self.m_ParentStorage
			triggerServerEvent("Storage:changeSlot", root, 
				dropStorage:getGeneral(), dropStorage:getSpecific(), dropItemFrame.m_UniqueIdentifier,
				selfStorage:getGeneral(), selfStorage:getSpecific(), self.m_ParentStorageSlot
			)
			Tooltip:getSingleton():hide()
			ItemDragAndDrop:getSingleton():setItemFrame(false)
		end
	end
end

function ItemFrame:onInternRightUp()
	if not self.m_ParentStorage or not self:isDragable() then return end

	local useTable = self.m_StorageInteraction

	if self.m_ParentStorage:getType() == 2 then
		useTable = self.m_FastSelection
	elseif self.m_ParentStorage:getType() == 1 then
		useTable = self.m_DefaultTable
	end

	dropdownmenu:setup(useTable, self.m_PosX+self.m_Width, self.m_PosY)
	if dropdownmenu:getControlElement() then
		dropdownmenu:getControlElement().ItemFrameMenu = self.m_ParentStorage
	end
end