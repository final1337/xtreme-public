DropDownMenu = inherit(Singleton)

function DropDownMenu:constructor()
	self.m_Visible = false
	self.m_ControlElement = false
	self.m_TableElements = false
end

function DropDownMenu:getWidth()
	return (128/1920)*screenWidth
end

function DropDownMenu:getHeight()
	return (32/1080)*screenHeight
end

function DropDownMenu:destroy()
	if self.m_ControlElement then
		delete(self.m_ControlElement)
		self.m_ControlElement = false
	end	
end

function DropDownMenu:getControlElement() return self.m_ControlElement end

function DropDownMenu:setup(elementTable, posX, posY)
	
	if elementTable == self.m_TableElements then
		self.m_TableElements = false
		self:destroy(elementTable)
		return
	end
	self:destroy(elementTable)
	self.m_TableElements = elementTable

	local clonedTable = table.clone(self.m_TableElements)

	table.insert(clonedTable, {text="Zuklappen", func = function ()  end})

	self.m_ControlElement = DropDownElement:new(posX, posY, clonedTable, false)

	Renderer:getSingleton():sthInteracted(self.m_ControlElement)
	self.m_ControlElement:setVisible(true)
end