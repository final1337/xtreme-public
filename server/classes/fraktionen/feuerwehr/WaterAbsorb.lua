WaterAbsorb = inherit(Object)

WaterAbsorb.WATER_PER_DRAIN = 50

function WaterAbsorb:constructor()
	self.m_Sources = {}
	self.m_EndSources = {}
	self.m_DrainWaterHandler = bind(self.drainWater, self)
	self.m_EndWaterHandler = bind(self.resetWater, self)
end

function WaterAbsorb:destructor()
	for key, value in ipairs(self.m_EndSources) do
		value:destroy()
	end
	for key, value in ipairs(self.m_Sources) do
		value:delete()
	end
	for key, value in ipairs(Player:getAllByType()) do
		if player.m_CarryingSource == self then
			player.m_CarryingSource = nil
			player.m_CarryingWater  = nil
		end
	end
end

function WaterAbsorb:onPlayerEnterWater(waterInstance, player)
	if player:getData("Fraktion") == 10 then
		bindKey(player, "e", "up", self.m_DrainWaterHandler, waterInstance.m_UId)
	end
end

function WaterAbsorb:onPlayerLeaveWater(waterInstance, player)
	if player:getData("Fraktion") == 10 then
		unbindKey(player, "e", "up", self.m_DrainWaterHandler)
	end
end

function WaterAbsorb:drainWater(player,key,state,waterInstance)
	if not player.m_CarryingWater and self.m_Sources[waterInstance] then
		player.m_CarryingWater = WaterAbsorb.WATER_PER_DRAIN
		player.m_CarryingSource = self
		self.m_Sources[waterInstance].m_WaterStorage = self.m_Sources[waterInstance].m_WaterStorage - WaterAbsorb.WATER_PER_DRAIN
		if self.m_Sources[waterInstance].m_WaterStorage <= 0 then
			self.m_Sources[waterInstance]:delete()
			self.m_Sources[waterInstance] = nil
		end
		if #self.m_Sources == 0 then
			self:delete()
		end
	else
		unbindKey(player, "e", "up", self.m_DrainWaterHandler)
	end
end

function WaterAbsorb:resetWater(player, matchingDimension)
	if player and matchingDimension and player:getType() == "player" and player.m_CarryingWater then
		player:outputChat(("Wassermenge von %dl abgegeben!"):format(player.m_CarryingWater), 255, 0, 0)
		player.m_CarryingWater = nil
		player.m_CarryingSource = nil
	end
end

function WaterAbsorb:addSource(x,y,z,width,height)
	assert(x and y and z and width and height, "Failure at adding a source @ WaterAbsorb:addSource")
	table.insert(self.m_Sources, AdvancedWater:new(x,y,z,width,height,0,0))
	self.m_Sources[#self.m_Sources].m_WaterStorage = 100
	self.m_Sources[#self.m_Sources].m_UId = #self.m_Sources
	self.m_Sources[#self.m_Sources].onElementEnterWater = bind(self.onPlayerEnterWater, self)
	self.m_Sources[#self.m_Sources].onElementLeaveWater = bind(self.onPlayerLeaveWater, self)
end

	
function WaterAbsorb:addEndSource(x,y,z, interior, dimension)
	self.m_EndSources[#self.m_EndSources+1] = createObject(1337, x,y,z)
	object = self.m_EndSources[#self.m_EndSources]
	object:setDimension(dimension)
	object:setInterior(interior)
	object.m_ColShape = ColShape.Sphere(x,y,z, 4)
	object.m_ColShape:setParent(object)
	object.m_ColShape:setInterior(interior)
	object.m_ColShape:setDimension(dimension)
	addEventHandler("onColShapeHit", object.m_ColShape, self.m_EndWaterHandler)
end