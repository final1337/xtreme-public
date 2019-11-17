DamageObject = inherit(Singleton)

addEvent("XTM:DamageObject:sync", true)

DamageObject.TICK_PER_HIT = 10

function DamageObject:constructor()
	self.m_DamageEntities = {}
	addEventHandler("XTM:DamageObject:sync", root, bind(self.Event_SyncWoods, self))
	addEventHandler("onClientObjectDamage", root, bind(self.Event_OnClientObjectDamage, self))
	
	triggerServerEvent("XTM:DamageObject:onPlayerReady", root)
	
	addEventHandler("onClientRender", root, bind(self.draw, self))
end

function DamageObject:draw()
	for key, value in pairs(self.m_DamageEntities) do
		local npcPositionVector 	    = value.Object:getPosition()
		local localPlayerPositionVector = localPlayer:getPosition()
		
		local x,y = getScreenFromWorldPosition(npcPositionVector)
		
		if x and y and (value.Object:getPosition()-localPlayer:getPosition()).length < 10 then
			local width  = screenWidth/6 * ((value.Object:getPosition()-localPlayer:getPosition()).length/20 - 1)
			local height = screenHeight*.03 * ((value.Object:getPosition()-localPlayer:getPosition()).length/20 - 1)
			dxDrawRectangle(x-width/2  + 2.5 , y-height/2 + 2.5, width -5 , height - 5, tocolor ( 0, 0, 0, 125))
			dxDrawRectangle(x-width/2 + width , y-height/2 , - width * value.Progress/value.Health, height, tocolor ( 125, 0, 0, 125))
			--dxDrawText(value.Progress .. "\n" .. width, x,y)
		end
	end
end

function DamageObject:Event_OnClientObjectDamage(tLoss, attacker)
	if getElementData(attacker, "Fraktion") and getElementData(attacker, "Fraktion") == 9 and attacker == localPlayer then
		if source.m_IsFireFighterWood and self.m_DamageEntities[source.m_Id].ValidWeapons[attacker:getWeapon()] then
			self.m_DamageEntities[source.m_Id].Progress = self.m_DamageEntities[source.m_Id].Progress + DamageObject.TICK_PER_HIT
			if self.m_DamageEntities[source.m_Id].Progress >= self.m_DamageEntities[source.m_Id].Health then
				triggerServerEvent("XTM:DamageObject:delete", root, source.m_Id)
			end
		end
	end
end

function DamageObject:Event_SyncWoods(fires)
	for key, value in pairs(fires) do
		-- If there is no fireElement with this id
		if not self.m_DamageEntities[key] and not value.isDestroyed then
			-- Create the wood entity
			self.m_DamageEntities[key] = {
				Object = createObject(value.Id,value.posX, value.posY, value.posZ, value.rotX, value.rotY, value.rotZ),
				Progress = 0,
				Health = value.health,
				ValidWeapons = value.validWeapons,
			}
			-- Set the elements into the right dimension and interior
			for _, entity in pairs ( self.m_DamageEntities[key] ) do
				if isElement(entity) then
					entity:setInterior(value.interior)
					entity:setDimension(value.dimension)
				end
			end
			self.m_DamageEntities[key].Object.m_Id = key
			self.m_DamageEntities[key].Object.m_IsFireFighterWood = true
		elseif self.m_DamageEntities[key] and value.isDestroyed then
			-- Delete all elements of this fire
			for _, entity in pairs ( self.m_DamageEntities[key] ) do
				if isElement(entity) then
					entity:destroy()
				end
			end	
			self.m_DamageEntities[key] = nil
		end
	end
end
