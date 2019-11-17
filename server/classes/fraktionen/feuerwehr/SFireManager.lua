FireManager = inherit(Singleton)

addEvent("XTM:Fire:onPlayerReady", true)
addEvent("XTM:Fire:delete"       , true)

function FireManager:constructor()
   	self.m_FireEntities = {}
	self.m_UniqueIterator = 1

	addEventHandler("XTM:Fire:onPlayerReady", root, bind(self.Event_OnPlayerReady, self))
	addEventHandler("XTM:Fire:delete", root, bind(self.Event_DeleteFire, self))
end

function FireManager:getEntities()
	return self.m_FireEntities
end

function FireManager:Event_DeleteFire(id)
	if self.m_FireEntities[id] and not self.m_FireEntities[id]:getExtinguishedState() then
		self.m_FireEntities[id]:extinguish()
		self:syncNewFire(id)
		-- client:setData("fires", client:getData("fires") + 1)
		if self.m_FireEntities[id].onFinish then
			self.m_FireEntities[id]:onFinish()
		end

		self.m_FireEntities[id]:delete()
		self.m_FireEntities[id] = nil
	end
end

function FireManager:Event_OnPlayerReady()
	triggerClientEvent(client, "XTM:Fire:sync", client, self:getSynchronizedTable())
end

function FireManager:getSynchronizedTable(id)
	local tbl = {}
	for key, value in pairs(self.m_FireEntities) do
		if id and key == id or not id then
			local x,y,z = value:getPosition()
			tbl[key] = { posX = x, posY = y, posZ = z, interior = value:getInterior(), dimension = value:getDimension(), isExtinguished = value:getExtinguishedState() }
		end
	end
	return tbl
end

function FireManager:syncNewFire(id)
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then
			triggerClientEvent(value,"XTM:Fire:sync", value, self:getSynchronizedTable(id))
		end
	end
end

function FireManager:addEntity(x,y,z,dim,int)
	--self.m_FireEntities[self.m_UniqueIterator] = { posX = x, posY = y, posZ = z, interior = int or 0, dimension = dim or 0, onFinish = false, isExtinguished = false }
	self.m_FireEntities[self.m_UniqueIterator] = Fire:new(self.m_UniqueIterator,x,y,z,dim,int)
    self:syncNewFire(self.m_UniqueIterator)
	self.m_UniqueIterator = self.m_UniqueIterator + 1
	return self.m_FireEntities[self.m_UniqueIterator - 1]
end