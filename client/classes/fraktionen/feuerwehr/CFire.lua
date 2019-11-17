FireExt = inherit(Singleton)

addEvent("XTM:Fire:sync", true)



FireExt.RANDOM_FIRE_EFFECTS = {
	"fire",
	"fire_med",
	"fire_large",
}

FireExt.PER_FIRE_VEHICLE_TICK = 2.3
FireExt.PER_FIRE_EXT_TICK     = 1.3

function FireExt:constructor()
	self.m_FireEntities = {}
	addEventHandler("XTM:Fire:sync", root, bind(self.Event_SyncFires, self))
	addEventHandler("onClientPedDamage", root, bind(self.Event_OnClientPedDamage, self))
	addEventHandler("onClientPedHitByWaterCannon", root, bind(self.Event_OnClientPedHitByWaterCannon, self))
	
	triggerServerEvent("XTM:Fire:onPlayerReady", root)
	
	addEventHandler("onClientRender", root, bind(self.draw, self))
end

function FireExt:draw()
	for key, value in pairs(self.m_FireEntities) do
		local npcPositionVector 	    = value.NPC:getPosition()
		local localPlayerPositionVector = localPlayer:getPosition()

		local x,y = getScreenFromWorldPosition(npcPositionVector)
		
		if x and y and (value.NPC:getPosition()-localPlayer:getPosition()).length < 10 and isLineOfSightClear(npcPositionVector, localPlayerPositionVector, true, false, false, true) then
			local width  = screenWidth/6 * ((value.NPC:getPosition()-localPlayer:getPosition()).length/20 - 1)
			local height = screenHeight*.03 * ((value.NPC:getPosition()-localPlayer:getPosition()).length/20 - 1)
			dxDrawRectangle(x-width/2  + 2.5 , y-height/2 + 2.5, width -5 , height - 5, tocolor ( 0, 0, 0, 125))
			dxDrawRectangle(x-width/2 + width , y-height/2 , - width * value.Progress/100, height, tocolor ( 125, 0, 0, 125))
			--dxDrawText(value.Progress .. "\n" .. width, x,y)
		end
	end
end

function FireExt:Event_OnClientPedHitByWaterCannon(pedHit)
	if getElementModel(source) == 407 and getVehicleOccupant(source, 0) == localPlayer and getElementData(localPlayer, "Fraktion") == 9 then
		if pedHit.m_FireDummy then
			self.m_FireEntities[pedHit.m_Id].Progress = self.m_FireEntities[pedHit.m_Id].Progress + FireExt.PER_FIRE_VEHICLE_TICK
			if self.m_FireEntities[pedHit.m_Id].Progress >= 100 then
				triggerServerEvent("XTM:Fire:delete", root, pedHit.m_Id)
			end			
		end
	end
end

function FireExt:Event_OnClientPedDamage(attacker, weapon)
	if attacker and weapon then
		if weapon == 42 and attacker == localPlayer and source.m_FireDummy then -- Fire extinguisher
			self.m_FireEntities[source.m_Id].Progress = self.m_FireEntities[source.m_Id].Progress + FireExt.PER_FIRE_EXT_TICK
			if self.m_FireEntities[source.m_Id].Progress >= 100 then
				triggerServerEvent("XTM:Fire:delete", root, source.m_Id)
			end
		end
	end
	if source.m_Invincible then
		cancelEvent()
	end
end

function FireExt:Event_SyncFires(fires)
	for key, value in pairs(fires) do
		-- If there is no fireElement with this id
		if not self.m_FireEntities[key] and not value.isExtinguished then

			self.m_FireEntities[key] = {
				NPC       = Ped(0, value.posX, value.posY, value.posZ),
				Effect    = self:getFireEffect(value.posX, value.posY, value. posZ),
				Progress  = 0,
			}
			-- Set the elements into the right dimension and interior
			for _, entity in pairs ( self.m_FireEntities[key] ) do
				if isElement(entity) then
					entity:setInterior(value.interior)
					entity:setDimension(value.dimension)
				end
			end
			
			-- Add Cosmetic stuff
			local npcShort = self.m_FireEntities[key].NPC
			
			npcShort.m_Id = key
			npcShort.m_FireDummy = true
			npcShort.m_Invincible = true
			npcShort:setFrozen(true)
			npcShort:setAlpha(0)
			npcShort:setVoice("PED_TYPE_DISABLED", "n/a")
			
			-- Add functions
			
			npcShort:setCollidableWith(localPlayer, false)
			
			-- Deactivate the collision with vehicles
			
			for _, vehicle in ipairs(getElementsByType("vehicle")) do
				npcShort:setCollidableWith(vehicle, false)
			end
			
		elseif self.m_FireEntities[key] and value.isExtinguished then
			-- Delete all elements of this fire
			for _, entity in pairs ( self.m_FireEntities[key] ) do
				if isElement(entity) then
					entity:destroy()
				end
			end	
			self.m_FireEntities[key] = nil
		end
	end
end

function FireExt:getFireEffect(x, y, z)
	return Effect(FireExt.RANDOM_FIRE_EFFECTS[math.random(1, #FireExt.RANDOM_FIRE_EFFECTS)], x, y, z, 0, 0, 0, 150)
end

