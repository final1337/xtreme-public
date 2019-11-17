ItemFrameTemplate = inherit(GUIBlankControl)
inherit(GUIColourable, ItemFrameTemplate)

function ItemFrameTemplate:constructor(posX, posY, width, height, parent)
	GUIBlankControl.constructor(self, posX, posY, width, height, parent)
	GUIColourable.constructor(self)

	self:setColor(11, 11, 11, 255)

	self.m_Item = false
	self.m_TemplateItem = false
	self.m_Amount = 0
	self.m_Entered = false
	self.m_InteractionState = false
end

function ItemFrameTemplate:setItem(item)
	self.m_Item = item
	self.m_TemplateItem = ItemManager:getSingleton():getItemTemplate(item.ItemId) 
	self.m_Amount = self.m_Item.Amount
end

function ItemFrameTemplate:setStatus(bool)
	self.m_InteractionState = bool
end

function ItemFrameTemplate:setAmount(int)
	self.m_Amount = int
end

function ItemFrameTemplate:getAmount()
	return self.m_Amount
end

function ItemFrameTemplate:isDragable()
	local answ = true
	for key, value in ipairs(trading:getSlots()) do
		if not self:getItem() or (value:getItem() and value:getItem().UniqueIdentifier == self:getItem().UniqueIdentifier) then
			answ = false
			break
		end
	end	
	return answ
end

function ItemFrameTemplate:getStatus()			return self.m_InteractionState end
function ItemFrameTemplate:getTemplateItem()	return self.m_TemplateItem end
function ItemFrameTemplate:getItem() 			return self.m_Item end

function ItemFrameTemplate:setTemplateItem(itemId)
	self.m_TemplateItem = itemmanager:getItemTemplate(itemId)
end

function ItemFrameTemplate:reset()
	self.m_Item = false
	self.m_TemplateItem = false
	self.m_Amount = 0
	if self.m_Entered  then
		self.m_Entered = false
		Tooltip:getSingleton():hide()
	end
	if ItemDragAndDrop:getSingleton():getItemFrame() == self then
		ItemDragAndDrop:getSingleton():setItemFrame(false)
	end
end

function ItemFrameTemplate:onInternHoverStart()
	local string = "Kein Gegenstand"
	if self.m_Item then
		string = ("Name: %s  \nAnzahl: %d\nErsteller: %s"):format(self.m_TemplateItem:getName(), self.m_Item.Amount,
		self.m_Item.Owner)
		if self.m_Item.SpecialText ~= "none" then
			string = (("%s\n%s"):format(string, self.m_Item.SpecialText)):gsub("\n", "\n")
		end
		
		if self.m_Item.Temporary then
			string = ("%s\n%s"):format(string, "Temporär")
		end			



		if trading.m_Window.m_Visible then
			if self.m_TemplateItem:isTradable() then
				string = ("%s\n#00FF00Handelbar#FFFFFF"):format(string, self.m_Item.SpecialText)
			else
				string = ("%s\n#FF0000Nicht Handelbar#FFFFFF"):format(string, self.m_Item.SpecialText)
			end
		end
	elseif self.m_TemplateItem and self.m_TemplateItem:getName() then
		string = ("Name: %s"):format(self.m_TemplateItem:getName())
	end

	Tooltip:getSingleton():show(string)	
end

function ItemFrameTemplate:onInternHoverStop()
	Tooltip:getSingleton():hide()
end


function ItemFrameTemplate:onInternLeftUp()
	self.m_Entered = false
	Tooltip:getSingleton():hide()
end

function ItemFrameTemplate:drawThis()
	--dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
	if self.m_TemplateItem and self.m_TemplateItem:getDisplayPicture() then
		--dxDrawLine(self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width, self.m_AltY)
		--dxDrawLine(self.m_AltX, self.m_AltY, self.m_AltX, self.m_AltY + self.m_Height)
		--dxDrawLine(self.m_AltX + self.m_Width, self.m_AltY + self.m_Height, self.m_AltX + self.m_Width, self.m_AltY)
		--dxDrawLine(self.m_AltX + self.m_Width, self.m_AltY + self.m_Height, self.m_AltX, self.m_AltY + self.m_Height)		
		if fileExists("Files/".. self.m_TemplateItem:getDisplayPicture()) then
			dxDrawImage(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, "Files/".. self.m_TemplateItem:getDisplayPicture())
		elseif fileExists("files/".. self.m_TemplateItem:getDisplayPicture()) then
			dxDrawImage(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, "files/".. self.m_TemplateItem:getDisplayPicture())
		end
	else
		dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
	end
	
	if (self:getItem() and tonumber(self:getItem().Amount) > 1) or (self.m_Amount and self.m_Amount > 1) then
		--dxDrawText(tostring(self.m_Amount), self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width - 3, self.m_AltY + self.m_Height, tocolor(255,255,255),
			--		1, "default", "right", "bottom")
		dxDrawBorderedTextExt(1, tostring(self.m_Amount), self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width - 3, self.m_AltY + self.m_Height, tocolor(255,255,255),
					1, "default", "right", "bottom")
	end
end