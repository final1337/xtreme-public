AdvancedWater = inherit(Object)

function AdvancedWater:constructor(posX, posY, posZ, width, length, dimension, interior)
	self.m_Elements = {}
	
	self.m_PosX      = posX
	self.m_PosY      = posY
	self.m_PosZ      = posZ
	self.m_Width     = width
	self.m_Length    = length
	self.m_Dimension = dimension
	self.m_Interior  = interior
	
	self.m_WaterElement = Water(posX, posY, posZ, 
	posX+width, posY, posZ,
	posX, posY+length, posZ,
	posX+width, posY+length, posZ,
	true)
	self.m_WaterElement:setInterior(interior)
	self.m_WaterElement:setDimension(dimension)
	
	self.m_ColCuboid = ColShape.Cuboid(posX, posY, 0, width, length, posZ)
	self.m_ColCuboid:setInterior(interior)
	self.m_ColCuboid:setDimension(dimension)
	
	self.m_ColEnterHandler = bind(self.Event_OnColShapeHit, self)
	self.m_ColLeaveHandler = bind(self.Event_OnColShapeLeave, self)
	self.m_ColQuitHandler  = bind(self.Event_OnPlayerQuit, self)
	
	addEventHandler("onColShapeHit", self.m_ColCuboid, self.m_ColEnterHandler)
	addEventHandler("onColShapeLeave", self.m_ColCuboid, self.m_ColLeaveHandler)
	addEventHandler("onPlayerQuit", root, self.m_ColQuitHandler)
	addEventHandler("onPlayerWasted", root, self.m_ColQuitHandler)
end

function AdvancedWater:destructor()
	outputChatBox("destroy")
	self.m_WaterElement:destroy()
	self.m_ColCuboid:destroy()
	removeEventHandler("onPlayerQuit", root, self.m_ColQuitHandler)
	removeEventHandler("onPlayerWasted", root, self.m_ColQuitHandler)
end

function AdvancedWater:Event_OnPlayerQuit()
	self:Event_OnColShapeLeave(source, true)
end

function AdvancedWater:isPlayerInsideWater(player)
	for key, value in ipairs(self.m_Elements) do
		if value == player then
			return true
		end
	end
	return false
end

function AdvancedWater:Event_OnColShapeHit(hitElement, matchingDimension)
	if matchingDimension and not self:isPlayerInsideWater(hitElement) and hitElement:getType() == "player" then
		if self.onElementEnterWater then
			self:onElementEnterWater(hitElement)
		end	
		table.insert(self.m_Elements, hitElement)		
	end
end

function AdvancedWater:Event_OnColShapeLeave(leaveElement, matchingDimension)
	if matchingDimension and self:isPlayerInsideWater(leaveElement) and leaveElement:getType() == "player" then
		if self.onElementLeaveWater then
			self:onElementLeaveWater(leaveElement)
		end
		for key, value in ipairs(self.m_Elements) do
			if value == leaveElement then
				table.remove(self.m_Elements, key)
			end
		end
	end
end

--AdvancedWater:new(-814.17, 1906.98, 7.00, 50, 50, 0, 0)