StorageFrame = inherit(Object)

StorageFrame.Amount = {}
StorageFrame.ItemFrameWidth = 60*screenWidth/1600
StorageFrame.ItemFrameHeight = 60*screenHeight/900
StorageFrame.ItemFrameGap = 12
StorageFrame.ItemWidth = StorageFrame.ItemFrameWidth - StorageFrame.ItemFrameGap
StorageFrame.ItemHeight = StorageFrame.ItemFrameHeight - StorageFrame.ItemFrameGap

function StorageFrame:constructor(general, specific, storageType)
	self.m_Items = {}
	self.m_ItemFrames = {}
	self.m_General = general
	self.m_Specific = specific
	self.m_StorageType = storageType
	self.m_Settings = storagesettings:getStorageSettings(storageType)

	--//TODO: Add a more general layout
	if general == "OwnStorage" and specific == 1 then
		self.m_Window = GUIWindow:new(485*screenWidth/1600, 400*screenHeight/900, 10*StorageFrame.ItemFrameWidth + 20, 280*screenHeight/900, self.m_Settings:getName() or "Unknown", true)
	elseif general == "OwnStorage" and specific == 2 then
		self.m_Window = GUIWindow:new(485*screenWidth/1600, 700*screenHeight/900, 10*StorageFrame.ItemFrameWidth + 20, StorageFrame.ItemFrameHeight + GUIWindow.TitleThickness/2, self.m_Settings:getName() or "Unknown", true)
	elseif general == "VehicleStorage" then
		-- needs to be a dividable by StorageFrame.ItemFrameWidth + 20
		self.m_Window = GUIWindow:new(485*screenWidth/1600, 160*screenHeight/900, 4*StorageFrame.ItemFrameWidth + 20, 200*screenHeight/900, self.m_Settings:getName() or "Unknown", true)
	elseif general == "FactionStorage" then
		self.m_Window = GUIWindow:new(750*screenWidth/1600, 160*screenHeight/900, 6*StorageFrame.ItemFrameWidth + 20, 200*screenHeight/900, self.m_Settings:getName() or "Unknown", true)		
	elseif general == "OwnStorage" and specific == 9 then
		self.m_Window = GUIWindow:new(485*screenWidth/1600 -(1*StorageFrame.ItemFrameWidth + 40), 400*screenHeight/900, 1*StorageFrame.ItemFrameWidth + 20, 220*screenHeight/900, self.m_Settings:getName() or "Unknown", true)
	end

	local height = self.m_Window:getHeight()
	local width = self.m_Window:getWidth()

	self.m_WindowScrollPane = GUIScrollArea:new(0, GUIWindow.TitleThickness, width, height, width, 2000, self.m_Window)
	self.m_WindowScrollPane:changeScrollSpeedOnYAxis(12)

	-- SET WINDOW SETTINGS

	self.m_Window:setColor(25, 25, 25, 200)
	self.m_Window:getTitleLabel():setFont("default-bold")


	self.m_WindowScrollPane.onLeftUp = bind(self.Action_WindowClick, self)
	self.m_Window.m_CloseButton.onLeftUp = bind(self.Action_OnCloseButton, self)
end

function StorageFrame:getType() return self.m_StorageType end
function StorageFrame:getGeneral() return self.m_General end
function StorageFrame:getSpecific() return self.m_Specific end

function StorageFrame:Action_OnCloseButton()
	self:close()
end

function StorageFrame:close()
	ItemManager:getSingleton():closeStorage(self.m_General, self.m_Specific)
	triggerServerEvent("Storage:StorageClosed", resourceRoot, self.m_General, self.m_Specific)
end

function StorageFrame:Action_WindowClick()
	-- swap the item into this storage
	local destinationGeneral, destinationSpecific = self.m_General, self.m_Specific


	local dropItemFrame = ItemDragAndDrop:getSingleton():getItemFrame()

	if dropItemFrame then
		local originStorage = dropItemFrame.m_ParentStorage
		if not originStorage then return end
		local originGeneral, originSpecific = originStorage:getGeneral(), originStorage:getSpecific()
		local originUniqueIdentifier = dropItemFrame.m_UniqueIdentifier

		if originGeneral == destinationGeneral and originSpecific == destinationSpecific then
			localPlayer:sendNotification("Der Zielspeicher sollte nicht der selbe wie der Ursprungsspeicher sein.", 255, 0, 0)
			return
		end

		triggerServerEvent("Storage:switchItem", resourceRoot, originGeneral, originSpecific, originUniqueIdentifier, destinationGeneral, destinationSpecific)
	end
end

function StorageFrame:loadItems(items)
	for key, value in pairs(self.m_ItemFrames) do
		delete(value)
	end
	local maxSlots = storagesettings:getStorageSettings(self:getType()):getSize()
	self.m_Items = items
	self.m_ItemFrames = {}
	local width = self.m_WindowScrollPane:getWidth() - 20
	local slotsPerRow = math.floor(width/StorageFrame.ItemFrameWidth)
	--[[for key, value in pairs(items) do
		local renderKey = key - 1
		local req = math.floor(renderKey/slotsPerRow)
		local frame = ItemFrame:new(renderKey*50 - req * width, req*50, 48, 48, self.m_WindowScrollPane)
		frame:setItem(value)
		frame.m_ParentStorage = self
		frame.m_ParentStorageSlot = key
		frame.m_UniqueIdentifier = value.UniqueIdentifier
		table.insert(self.m_ItemFrames, frame)
	end]]
	for i = 1, maxSlots, 1 do
		local renderKey = i - 1
		local req = math.floor(renderKey/slotsPerRow)
		local frame = ItemFrame:new(StorageFrame.ItemFrameGap/2 + 10 + renderKey*StorageFrame.ItemFrameWidth - req * width, req*StorageFrame.ItemFrameHeight,
		 StorageFrame.ItemWidth, StorageFrame.ItemHeight, self.m_WindowScrollPane)
		frame.m_ParentStorage = self
		frame.m_ParentStorageSlot = i
		if items[i] then
			frame:setItem(items[i])
			frame.m_UniqueIdentifier = items[i].UniqueIdentifier
		end
		table.insert(self.m_ItemFrames, frame)
	end
end

function StorageFrame:setVisible(bool)
	self.m_Window:setVisible(bool)
end	

function StorageFrame:destructor()
	local dad = ItemDragAndDrop:getSingleton()
	if dad:getItemFrame() and dad:getItemFrame().m_ParentStorage and dad:getItemFrame().m_ParentStorage == self then
		dad:setItemFrame(false)
	end
	if dropdownmenu:getControlElement() and dropdownmenu:getControlElement().ItemFrameMenu == self then
		dropdownmenu:destroy()
	end
	delete(self.m_Window)
end
