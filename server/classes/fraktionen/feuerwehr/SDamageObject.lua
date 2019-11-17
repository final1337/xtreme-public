DamageObject = inherit(Singleton)

addEvent("XTM:DamageObject:onPlayerReady", true)
addEvent("XTM:DamageObject:delete"       , true)

function DamageObject:constructor()
   	self.m_DamageEntities = {}
	self.m_UniqueIterator = 1
	
	addEventHandler("XTM:DamageObject:onPlayerReady", root, bind(self.Event_OnPlayerReady, self))
	addEventHandler("XTM:DamageObject:delete", root, bind(self.Event_DeleteWood, self))
end

function DamageObject:Event_DeleteWood(id)
	if self.m_DamageEntities[id] and not self.m_DamageEntities[id].isDestroyed then
		self.m_DamageEntities[id].isDestroyed = true
		self:syncNewObjects(self.m_DamageEntities[id], id)
		if self.m_DamageEntities[id].onFinish then
			self.m_DamageEntities[id]:onFinish(self.m_DamageEntities[id])
		end
		
		self.m_DamageEntities[id] = nil
	end
end

function DamageObject:delete(id)
	if self.m_DamageEntities[id] and not self.m_DamageEntities[id].isDestroyed then
		self.m_DamageEntities[id].isDestroyed = true
		self:syncNewObjects(self.m_DamageEntities[id], id)
		self.m_DamageEntities[id] = nil
	end
end

function DamageObject:Event_OnPlayerReady()
	triggerClientEvent(client, "XTM:DamageObject:sync", client, self.m_DamageEntities)
end

function DamageObject:syncNewObjects(object, id)
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then
			triggerClientEvent(value,"XTM:DamageObject:sync", value, { [id] = object })	
		end
	end
end

function DamageObject:addEntity(id,x,y,z,dim,int,health,valid, rx, ry, rz)
	self.m_DamageEntities[self.m_UniqueIterator] = { Iterator = self.m_UniqueIterator,Id = id, posX = x, posY = y, posZ = z,rotX = rx or 0, rotY = ry or 0, rotZ = rz or 0, interior = int or 0, dimension = dim or 0, onFinish = false, isDestroyed = false, health = health or 100, validWeapons = valid or {[9] = true}}
    self:syncNewObjects(self.m_DamageEntities[self.m_UniqueIterator], self.m_UniqueIterator)
	self.m_UniqueIterator = self.m_UniqueIterator + 1
	return self.m_DamageEntities[self.m_UniqueIterator - 1]
end