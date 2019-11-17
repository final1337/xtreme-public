
DropDownElement = inherit(GUIBlankControl)

function DropDownElement:constructor(posX, posY, elements, dropParentElement, parentElement)
	local dropDownMenu = DropDownMenu:getSingleton()
	local width, height = dropDownMenu:getWidth(), dropDownMenu:getHeight()
	GUIBlankControl.constructor(self, posX, posY, width, #elements*height, parentElement)
	
	self.m_DropParentElement = dropParentElement
	self.m_Elements = elements
	self.m_ChildButtons = {}
	self.m_DropChildren = {}

	self.m_ShowingChildElement = false
	self.m_Level = dropParentElement and dropParentElement.m_Level + 1 or 1

	self.Bind_ButtonLeftClick = bind(self.Action_ButtonLeftClick, self)

	self:generateDropElements()
end

function DropDownElement:Action_ButtonLeftClick(button)
	local value = button.values
	if value.children and #value.children > 0 then
		if self.m_ShowingChildElement and self.m_ShowingChildElement ~= button then
			self.m_ShowingChildElement:hideChildElements()
			self.m_ShowingChildElement:setVisible(false)
		end
		button.dropElement:setVisible(true)
		self.m_ShowingChildElement = button.dropElement
	end
	if value.func then
		self:destroy()
		value:func()
	end
end

function DropDownElement:destroy()
	local parentElement = false
	if not self.m_DropParentElement then
		delete(self)
	else
		parentElement = self.m_DropParentElement
		while(parentElement.m_DropParentElement) do
			parentElement = parentElement.m_DropParentElement
		end
		delete(parentElement)
	end
end

function DropDownElement:hideChildElements()
	for key, value in ipairs(self.m_DropChildren) do
		value:setVisible(false)
		value:hideChildElements()
	end
end

function DropDownElement:generateDropElements()
	local dropDownMenu = DropDownMenu:getSingleton()
	local width, height = dropDownMenu:getWidth(), dropDownMenu:getHeight()	
	local i;
	for key, value in ipairs(self.m_Elements) do
		i = key-1

		local button = GUIClassicButton:new(value.text, 0, i*height, width, height, self)

		button.values = value

		if value.children then
			local childElement = DropDownElement:new(self.m_PosX+width, self.m_PosY+i*height, value.children, self)

			button.m_Text:setText(value.text .. " >")

			button.dropElement = childElement

			table.insert(self.m_DropChildren, childElement)
		end

		button.onLeftUp = self.Bind_ButtonLeftClick

	end
end

function DropDownElement:drawThis()
	dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, tocolor(0,0,0))
end

function DropDownElement:destructor()

	for key, value in ipairs(self.m_DropChildren) do
		delete(value)
	end

	GUIBlank.destructor(self)
end