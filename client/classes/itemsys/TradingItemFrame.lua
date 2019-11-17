TradingItemFrame = inherit(ItemFrameTemplate)

function TradingItemFrame:constructor(posX, posY, width, height, parent)
	ItemFrameTemplate.constructor(self, posX, posY, width, height, parent)

	self.m_Bind_DeleteItem  = bind(self.Action_DeleteItem, self)

	self.m_DefaultTable = {
		{text="Löschen", func = self.m_Bind_DeleteItem}
	}

	self.m_TemperalItem = false


	self.m_Entered = false
end


function TradingItemFrame:Action_DeleteItem()
	self:reset()
	trading:sendChange(self)
end

function TradingItemFrame:getTrading()
	return trading
end

function TradingItemFrame:Action_HalveItems()
	triggerServerEvent("Storage:splitItem", root, self.m_ParentStorage:getGeneral(), self.m_ParentStorage:getSpecific(), self.m_UniqueIdentifier)
end

function TradingItemFrame:onInternLeftDown()
	local dropItemFrame = ItemDragAndDrop:getSingleton():getItemFrame()

	-- Storage controller
	if dropItemFrame then
		if dropItemFrame.m_ParentStorage and trading:isEligibleToDrop(self) then
			-- Make sure that the item is from the players own storage
			if dropItemFrame.m_ParentStorage:getGeneral() == "OwnStorage" then
				local template = ItemManager:getSingleton():getItemTemplate(dropItemFrame:getItem().ItemId) 
				--if template:isTradable() then
					local cloned = dropItemFrame:getItem()
					self:setItem(cloned)
					trading:sendChange(self, dropItemFrame.m_ParentStorage)	
					trading.m_Window:sthChanged()
					ItemDragAndDrop:getSingleton():setItemFrame(false)
				--end
			end
		end
	end
end

function TradingItemFrame:onInternRightUp()

	dropdownmenu:setup(self.m_DefaultTable, self.m_PosX+self.m_Width, self.m_PosY)
	if dropdownmenu:getControlElement() then
		dropdownmenu:getControlElement().ItemFrameMenu = self.TradingItemFrame
	end
end