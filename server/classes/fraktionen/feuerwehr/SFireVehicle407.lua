FireVehicleWater = inherit(FireVehicle)

FireVehicleWater.USAGE_DURING_SHOOTING 	  = 20 -- liters
FireVehicleWater.REFILL_RATE 		  	  = 150 -- liters
FireVehicleWater.MAX_TANK_SIZE       	  = 15000 -- liters
FireVehicleWater.REFILL_FIREEXT      	  = 250 -- liters

addEvent("XTM:FF:fillFireExt", true)
addEvent("XTM:FF:getPump", 		true)

function FireVehicleWater:constructor(kilometer, pBreak, fuel, id, faction, preDenial)
	FireVehicle.constructor(self, kilometer, pBreak, fuel, id, faction, preDenial)
	
	self.m_RefillTimer = false
	self.m_FirePump = FirePump.create(0,0,0,0,0,0, self)	
	
	-- Set other datas
	self:setData("Tank", FireVehicleWater.MAX_TANK_SIZE)
	self:setData("TankMaximum", FireVehicleWater.MAX_TANK_SIZE)
	self:setData("AufsteigbarDesc", "Nicht möglich")
	self:setData("PumpeDesc", "Vorhanden")
	
	
	
	-- Add events, etc.
	self.m_ShootHandler = bind(self.waterShoot, self)
	addEventHandler("onVehicleEnter", self, bind(self.Event_OnVehicleEnter, self))
	addEventHandler("onVehicleExit", self, bind(self.Event_OnVehicleLeave, self))
	addEventHandler("onPlayerQuit", self, bind(self.Event_OnPlayerQuit, self))	
	addEventHandler("onColShapeLeave", self.m_ColShape, bind(self.Event_ColShapeLeave, self))	
	addEventHandler("onColShapeHit", self.m_ColShape, bind(self.Event_ColShapeHit, self))
	addEventHandler("XTM:FF:fillFireExt",  self, bind ( self.Event_FillFireExt, self ))	
	addEventHandler("XTM:FF:getPump", self, bind(self.Event_GetPump, self))
end

function FireVehicleWater:Event_ColShapeHit(player, matchingDimension)

end

function FireVehicleWater:Event_FillFireExt()
	--[[if self:getData("Tank") > FireVehicleWater.REFILL_FIREEXT then
		call( getResourceFromName("Xtream"), "inventarAddItem", client, "Feuerlöscher", FireVehicleWater.REFILL_FIREEXT)
		self:setData("Tank", self:getData("Tank") - FireVehicleWater.REFILL_FIREEXT)
		client:sendNotification("Feuerlöscher erhalten! Aktuelles Wasservolumen: %d l", 255, 255, 255, self:getData("Tank"))	
	else
		client:sendNotification("Der Wasserstand ist zu niedrig. ( derzeit: %d l)", 255, 255, 255, self:getData("Tank"))
	end]]
end


function FireVehicleWater:Event_ColShapeHit(player, matchingDimension)
	if matchingDimension and player.type == "player" and getElementData(player, "Fraktion") == 10 then
		--toggleControl(player, "next_weapon", false)
		--toggleControl(player, "previous_weapon", false)
	end
end

function FireVehicleWater:Event_ColShapeLeave(player, matchingDimension)
	if matchingDimension and player.type == "player" then
		if self.m_FirePump:disarm(player) then
			outputChatBox("Du hast dich zu weit vom Feuerwehfahrzeug entfernt!", player, 125, 0, 0)
		end
		if getElementData(player, "Fraktion") == 10 then
			--toggleControl(player, "next_weapon", true)
			--toggleControl(player, "previous_weapon", true)			
		end
	end
end

function FireVehicleWater:Event_OnVehicleEnter(player, seat)
	if seat == 0 then
		bindKey(player, "vehicle_fire", "both", self.m_ShootHandler)
		bindKey(player, "vehicle_secondary_fire", "both", self.m_ShootHandler)
		toggleControl(player,"vehicle_fire", self:getData("Tank") > 0 )
		toggleControl(player,"vehicle_secondary_fire", self:getData("Tank") > 0 )
	end
end

function FireVehicleWater:Event_GetPump()
	if not client then return end
	self.m_FirePump:equip(client)
end

function FireVehicleWater:waterShoot(player, key, state)
	if state == "down" then
		if self:getData("Tank") > 0 then
			toggleControl(player, "vehicle_fire", true)
			toggleControl(player, "vehicle_secondary_fire", true)
			self:setData("Tank", self:getData("Tank") - FireVehicleWater.USAGE_DURING_SHOOTING)
		end
		if isTimer(self.m_ControlTimer[player]) then killTimer(self.m_ControlTimer[player]) end
		self.m_ControlTimer[player] = Timer( function ()
			if self:getData("Tank") > 0 then
				self:setData("Tank", math.max ( 0, self:getData("Tank") - FireVehicleWater.USAGE_DURING_SHOOTING))
				if self:getData("Tank") == 0 then
					toggleControl(player, "vehicle_fire", false)
					toggleControl(player, "vehicle_secondary_fire", false)
					outputChatBox("Dein Wassertank ist leer! Gehe mit der Pumpe zu einem Hydranten oder ins Wasser!", player, 125, 0, 0)
				end
			end
		end, 150, 0 )
	elseif state == "up" and self.m_ControlTimer[player] then
		if isTimer(self.m_ControlTimer[player]) then
			killTimer(self.m_ControlTimer[player])
		end
	end
end

function FireVehicleWater:Event_OnPlayerQuit()
	if source and getVehicleOccupuants(self)[0] == source then
		unbindKey(source, "vehicle_fire", "both", self.m_ShootHandler)
		unbindKey(source, "vehicle_secondary_fire", "both", self.m_ShootHandler)
		if isTimer(self.m_ControlTimer[source]) then
			killTimer(self.m_ControlTimer[source])
		end		
	end
end

function FireVehicleWater:Event_OnVehicleLeave(player, seat)
	if seat == 0 then
		unbindKey(player, "vehicle_fire", "both", self.m_ShootHandler)
		unbindKey(player, "vehicle_secondary_fire", "both", self.m_ShootHandler)
		if isTimer(self.m_ControlTimer[player]) then
			killTimer(self.m_ControlTimer[player])
		end
	end
end

function FireVehicleWater.create(x,y,z,rotx,roty,rotz,plate)
	local vehicle = Vehicle(407, x,y,z,rotx,roty,rotz,plate)
	enew(vehicle, FireVehicleWater)
	return vehicle
end
