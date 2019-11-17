TrafficAccident = inherit(ActivityBase)
inherit(Singleton, TrafficAccident)
inherit(Bonus, TrafficAccident)

TrafficAccident.CASES = {
	{-2387.9697265625,708.51953125,35.015625		},
	{-2373.12109375,509.0947265625,29.109140396118  },
	{-2253.912109375,50.0078125,35.171875           },
	{-2008.361328125,-292.41015625,35.3203125       },
	{-1802.7060546875,-236.134765625,18.2265625     },
}


TrafficAccident.AVAILABLE_FACTIONS = {
	[9] = true,
	--[12] = true,
}


TrafficAccident.VISIBILE_FACTIONS = {
	[1] = 9,
	--[2] =  12,
}


TrafficAccident.CHAT_FACTION = {}

for key, value in pairs ( TrafficAccident.AVAILABLE_FACTIONS ) do table.insert(TrafficAccident.CHAT_FACTION, key) end

TrafficAccident.AVAILABLE_CARS = {424,495,500, 429,541,415,480,562,565,434,494,502,503,411,559,561,560,506,451,558,555,602,496,401,518,527,589,419,587,533,526,474,545,517,410,600,436,439,549,491,445,604,507,585,466,492,546,551,516,467,426,547,405,580,550,566,540,421,529}

function TrafficAccident:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	Bonus.constructor(self)

	self.m_AttachHandler = bind(self.Event_OnTrailerAttach, self)
	
	self.m_DeliverMarker = Marker(Vector3(-2028.87, 136.36, 27.84), "cylinder", 5, 125, 0, 0, 50)
	
	self.m_DeliverdVehicles = 0
	self.m_NeededVehicles  = math.huge
	
	addEventHandler("onMarkerHit", self.m_DeliverMarker,
		function (hitElement, matchingDimension)
			if hitElement:getType() == "vehicle" and hitElement.m_IsAccidentVehicle then
				hitElement:destroy()
				self:addBonus(950)
				self.m_DeliverdVehicles = self.m_DeliverdVehicles + 1
				if self.m_DeliverdVehicles >= self.m_NeededVehicles then
					self:nextPhase()
				end
			end
		end
	)

	for faction in pairs(TrafficAccident.AVAILABLE_FACTIONS) do
		self:addBonusFaction(faction)
	end		
end

function TrafficAccident:FailPhase1()
	if self:getBonus() > 0 then
		self:Phase2()
	end	
end

function TrafficAccident:AfterPhase1()
	for key, value in ipairs(self.m_Vehicles) do
		if isElement(value) then
			value:destroy()
		end
	end
	for key, value in pairs ( self.m_Fires ) do
		value:delete()
	end
	if isElement(self.m_Blip) then
		self.m_Blip:destroy()
	end
	if isTimer(self.m_CreateFireTimer) then
		killTimer(self.m_CreateFireTimer)
	end
	
	self.m_DeliverMarker:setAlpha(50)
	
	removeEventHandler("onTrailerAttach", root, self.m_AttachHandler)
end

function TrafficAccident:Event_OnTrailerAttach(vehicle)
	if ((getElementData(vehicle,"Fraktion") == 12 or getElementData(vehicle,"Fraktion") == 14 or getElementData(vehicle,"Fraktion") == 9) and getVehicleOccupant(vehicle, 0) and getElementData(getVehicleOccupant(vehicle,0), "Adminlevel") > 0) and source.m_IsAccidentVehicle then
	
	else
		cancelEvent()
	end
end

function TrafficAccident:Phase1()
	self:resetBonus()

	self.m_DeliverdVehicles = 0

	self:sendFactionSlideMessage({"Autounfall!", "Die Autos müssen von den Mechanikern abgeschleppt werden!"}, TrafficAccident.VISIBILE_FACTIONS, 500, 3500 )

	self.m_Vehicles = {}
	
	self.m_ActiveMission = math.random(1, #TrafficAccident.CASES)
	
	local x,y,z = unpack(TrafficAccident.CASES[self.m_ActiveMission])
	
	self.m_Blip = Blip(x,y,z, 0, 2, 255, 0, 0)
	self:sendElementFactionVisibleTo( self.m_Blip, TrafficAccident.VISIBILE_FACTIONS)
	
	for i = 1, math.random(3,4) do
		self.m_Vehicles[i] = Vehicle( TrafficAccident.AVAILABLE_CARS[math.random(1, #TrafficAccident.AVAILABLE_CARS)], x + math.random ( -5, 5 ),y + math.random ( -5, 5 ),z, 0, 0, math.random ( 360 ))
		local veh = self.m_Vehicles[i]
		veh:setHealth(math.random(251, 800))
		veh:setDamageProof(true)
		veh:setLocked(true)
		veh.m_IsAccidentVehicle = true
		
		addEventHandler("onVehicleStartEnter", veh, function () cancelEvent() end )
	end
	
	self.m_Fires = {}
	
	self.m_HookedVehicles = {}
	
	self.m_NeededVehicles = #self.m_Vehicles
	
	self.m_CreateFireTimer = Timer( function ()
		for key, value in ipairs(self.m_Vehicles) do
			local vehx, vehy, vehz = getElementPosition(value)
			self.m_Fires[key] = FireManager:getSingleton():addEntity(vehx + math.random ( -3, 3), vehy, z, 0, 0)
			self.m_Fires[key].onFinish = function () self:addBonus(600) end
		end
	end, 4500, 1)
	
	for i = #self.m_Vehicles+1, #self.m_Vehicles+7 do 
		self.m_Fires[i] = FireManager:getSingleton():addEntity(x + math.random ( -3, 3), y + math.random ( -3, 3), z - 0.3, 0, 0)
	end
	
	self.m_DeliverMarker:setAlpha(50)
	
	addEventHandler("onTrailerAttach", root, self.m_AttachHandler)
end

function TrafficAccident:Phase2()
	self:sendFactionSlideMessage({"Autounfall beendet!", "Gesamter Bonus: " .. self:getBonus() .. " €"}, TrafficAccident.CHAT_FACTION, 500, 3500 )

	self:payBonus()
	self:resetBonus()

	for key, value in ipairs ( getElementsByType("player")) do
		if self.m_BonusFactions[value:getData("Fraktion")] and value:getData("Duty") then
		--	levelup(value, 118)
		end
	end		
end