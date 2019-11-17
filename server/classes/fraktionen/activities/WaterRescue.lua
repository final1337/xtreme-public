WaterRescue = inherit(ActivityBase)
inherit(Singleton, WaterRescue)
inherit(Bonus, WaterRescue)

local unpack = unpack
local table = table
local math = math

WaterRescue.CASES = {
	[1] = {
		{-1388.70, 797.23, 0.01},
		{-1391.52, 796.22, -0.02},
		{-1390.15, 792.43, 0.43},
		{-1386.31, 793.76, 0.38},
		{-1380.55, 795.80, 0.31},
	},
	[2] = {
		{-1420.31, 255.92, -0.10},
		{-1417.93, 256.62, -0.13},
		{-1414.69, 257.61, -0.15},
		{-1411.74, 258.64, -0.19},
		{-1412.21, 265.70, -0.22},
		{-1417.88, 266.66, -0.23},
		{-1416.03, 252.67, -0.27},
		{-1398.64, 254.23, -0.32},
		{-1382.03, 266.36, -0.37},
	},
	[3] = {
		{-1086.32, 696.61, -0.29},
		{-1084.47, 696.85, -0.21},
		{-1078.51, 696.85, 0.01},
		{-1075.53, 693.97, 0.08},
		{-1067.71, 709.68, 0.34},
		{-1081.38, 726.94, -0.45},
		{-1098.18, 688.94, 0.22},
		{-1129.67, 656.39, 1.19},
		{-1104.98, 639.47, -0.24},
	},
	[4] = {
		{-1646.66, 1521.31, 0.43},
		{-1661.46, 1531.07, -0.11},
		{-1663.04, 1553.81, -0.32},
		{-1645.13, 1561.51, 0.07},
		{-1625.70, 1555.73, -0.05},
		{-1623.01, 1532.28, 0.23},
		{-1630.64, 1512.38, 0.66},
		{-1650.57, 1486.99, 0.25},
	},
	[5] = {
		{-2878.64, 1271.90, 0.31},
		{-2874.98, 1282.07, 0.47},
		{-2878.14, 1285.46, 0.05},
		{-2883.35, 1284.78, -0.06},
		{-2888.42, 1282.45, -0.02},
		{-2897.58, 1274.32, 0.24},
		{-2900.69, 1267.28, -0.13},
		{-2891.70, 1264.75, -0.01},
		{-2891.44, 1293.96, 0.14},
	},
}
-- Syntax: x, y, z, z-rot

WaterRescue.BOATS = {
	{472, -1470, 680, 10, 0},
	{472, -1473, 679, 10, 0},
	{472, -1478, 679, 10, 0},
}

WaterRescue.GRAB_DISTANCE = 10

WaterRescue.LANDING = Vector3(-1473.32, 681.23, 1.15)
WaterRescue.LANDING_SIZE = 20

WaterRescue.AMBULANCE_SPOT = Vector3(-1488.12, 715.97, 6.18)

WaterRescue.AMBULANCE_ENDING_SPOT = Vector3(-2657.90, 627.27, 13.45)

WaterRescue.AVAILABLE_FACTIONS = {
	[9] = true,
}

WaterRescue.VISIBILE_FACTIONS = {
	[1] = 9,
}

function WaterRescue:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	Bonus.constructor(self)

	self.m_Case = 0
	self.m_Peds = {}
	self.m_Boats = {}

	for faction in pairs(WaterRescue.AVAILABLE_FACTIONS) do
		self:addBonusFaction(faction)
	end		
end


function WaterRescue:FailPhase1()
	for key, value in ipairs(self.m_Boats) do
		value:destroy()
	end
	for key, value in pairs(self.m_Peds) do
		value:destroy()
	end
end

function WaterRescue:AfterPhase1()
	if isElement(self.m_Marker) then
		destroyElement(self.m_Marker)
	end
end

function WaterRescue:Phase1()
	self:sendFactionSlideMessage({"Wasserrettung!", "Holen Sie die vermissten Personen\naus dem Wasser!"}, WaterRescue.VISIBILE_FACTIONS, 500, 3500 )

	self.m_Case = math.random(1, #WaterRescue.CASES)

	self.m_Peds = {}
	self.m_Boats = {}
	self.m_Count = 0
	
	self.m_Marker = Marker(WaterRescue.LANDING-Vector3(0,0,1), "cylinder", WaterRescue.LANDING_SIZE, 0, 255, 0, 75)


	addEventHandler("onMarkerHit", self.m_Marker,
		function(hitElement)
			if hitElement and getElementType(hitElement) == "player" then
				local totalAmount = WaterRescue.CASES[self.m_Case]
				local veh = getPedOccupiedVehicle(hitElement)
				if veh and veh.CurrentRescued then
					veh.CurrentRescued = 0
					hitElement:sendNotification(("%d von %d Personen gerettet."):format(self.m_Count, #totalAmount))
				end
			end
		end
	)

	for key, value in ipairs(WaterRescue.BOATS) do
		local vehicleId, posX, posY, posZ, rotZ = unpack(value)
		local veh = Vehicle(vehicleId, Vector3(posX, posY, posZ), Vector3(0,0,rotZ))
		table.insert(self.m_Boats, veh)

		veh:setDamageProof(true)
		veh.CurrentRescued = 0

		addEventHandler("onVehicleStartEnter", veh,
			function(player)
				if player:getData("Fraktion") ~= 9 then
					player:sendMessage("Diese Boote sind nur für die Feuerwehr!")
					cancelEvent()
				end
			end
		)
	end

	for key, value in ipairs(WaterRescue.CASES[self.m_Case]) do

		local ped = Ped(0, Vector3(unpack(value)))

		Timer(function ()
		--ped:kill()
		ped:setAnimation("ped", "drown", -1, false, false, false, false)
		end, 500, 1)

		table.insert(self.m_Peds, ped)

		addEventHandler("onElementClicked", ped, bind(self.clickEvent, self))

		local blip = Blip.createAttachedTo(ped, 0, 2, 255, 0, 0, 255, 0, 99999)
		local marker = Marker(0,0,0, "arrow", 0.7, 255, 0, 0)

		marker:attach(ped, 0, 0, 1.6)
		marker:setParent(ped)
		blip:setParent(ped)

		ped:setData("PedBlip", blip)
		ped:setData("PedMarker", marker)

		self:sendElementFactionVisibleTo( marker, WaterRescue.VISIBILE_FACTIONS)
		self:sendElementFactionVisibleTo( blip, WaterRescue.VISIBILE_FACTIONS)

	end

end

function WaterRescue:clickEvent(mouseButton, buttonState, player, posX, posY, posZ)
	if mouseButton == "left" and buttonState == "down" then
		if not WaterRescue.AVAILABLE_FACTIONS[player:getData("Fraktion")] then
			player:sendMessage("Sie sind kein Mitglied der Feuerwehr.", 125, 0, 0)
			return
		else
			if (player:getPosition()-source:getPosition()).length < WaterRescue.GRAB_DISTANCE then
				local veh = getPedOccupiedVehicle(player) or getPedContactElement(player)
				if veh.CurrentRescued and veh.CurrentRescued < 3 then
					if isElement(source:getData("PedBlip")) then
						source:getData("PedBlip"):destroy()
						source:getData("PedMarker"):destroy()
					end
					veh.CurrentRescued = veh.CurrentRescued + 1
					source:destroy()
					self.m_Count = self.m_Count + 1
					self:addBonus(200)
					if self.m_Count >= #WaterRescue.CASES[self.m_Case] then
						self:nextPhase()
					end
				else
					player:sendNotification("Dein Boot ist voll!", 120, 0, 0)
				end

			end
		end
	end
end

function WaterRescue:FailPhase2()
	for key, value in ipairs(self.m_Boats) do
		value:destroy()
	end	
end

function WaterRescue:AfterPhase2()
	if isElement(self.m_PierMarker) then
		self.m_PierMarker:destroy()
	end
end

function WaterRescue:Phase2()
	self:sendFactionSlideMessage({"Bringen Sie die Personen und Boote wieder zum Steg!"}, WaterRescue.VISIBILE_FACTIONS, 500, 3500 )

	self.m_CurrentBoats = 0
	self.m_EnteredVehicle = {}

	self.m_PierMarker = ColShape.Sphere(WaterRescue.LANDING, WaterRescue.LANDING_SIZE)

	for key, value in ipairs(self.m_Boats) do
		if (value:getPosition()-WaterRescue.LANDING).length < WaterRescue.LANDING_SIZE then
			self.m_CurrentBoats = self.m_CurrentBoats + 1
			self:addBonus(300)
			self.m_EnteredVehicle[value] = true
			if self.m_CurrentBoats >= #WaterRescue.BOATS then
				self:nextPhase()
				return
			end
		end
	end
	
	addEventHandler("onColShapeHit", self.m_PierMarker, 
		function(hitElement, matchingDimension)
			if hitElement:getType() == "vehicle" and matchingDimension and not self.m_EnteredVehicle[hitElement] then
				for key, value in ipairs(self.m_Boats) do
					if value == hitElement then
						self:addBonus(300)
						self.m_CurrentBoats = self.m_CurrentBoats + 1
						self.m_EnteredVehicle[hitElement] = true
						break
					end
				end

				if self.m_CurrentBoats >= #WaterRescue.BOATS then
					self:nextPhase()
				end	

			end
		end
	)

end

function WaterRescue:AfterPhase3()
	for key, value in ipairs(self.m_Boats) do
		value:destroy()
	end
	if isElement(self.m_AmbulanceSpot) then
		self.m_AmbulanceSpot:destroy()
		self.m_AmbuBlip:destroy()
	end
end

function WaterRescue:onAmbulanceExplode()
	self:failCurrentPhase()
end

function WaterRescue:Phase3()
	self:sendFactionSlideMessage({"Holen Sie die Personen am Steg\nmit einem Krankenwagen ab!"}, WaterRescue.VISIBILE_FACTIONS, 500, 3500 )

	self.m_AmbulanceSpot = Marker(WaterRescue.AMBULANCE_SPOT, "cylinder", 4, 255, 0, 0)
	self.m_AmbuBlip      = Blip(WaterRescue.AMBULANCE_SPOT, 0, 2, 255, 0, 0, 255, 0, 99999)

	self.m_TransportingVehicle = false

	self:sendElementFactionVisibleTo( self.m_AmbulanceSpot, WaterRescue.VISIBILE_FACTIONS)
	self:sendElementFactionVisibleTo( self.m_AmbuBlip, WaterRescue.VISIBILE_FACTIONS)

	addEventHandler("onMarkerHit", self.m_AmbulanceSpot,
		function(hitElement, matchingDimension)
			if hitElement:getType() == "vehicle" and matchingDimension then
				if getElementData(hitElement,"Fraktion") == 9 and hitElement:getModel() == 416 then
					self.m_TransportingVehicle = hitElement
					addEventHandler("onVehicleExplode", hitElement, bind(self.failCurrentPhase, self))
					self:nextPhase()
				end 
			end
		end
	)
end

function WaterRescue:AfterPhase4()
	if isElement(self.m_EndMarker) then
		self.m_EndMarker:destroy()
		self.m_EndBlip:destroy()
	end
end

function WaterRescue:Phase4()
	self:sendFactionSlideMessage({"Fahren Sie nun zurück zum Krankenhaus!"}, WaterRescue.VISIBILE_FACTIONS, 500, 3500 )

	self.m_EndMarker = Marker(WaterRescue.AMBULANCE_ENDING_SPOT, "cylinder", 4, 255, 0, 0)
	self.m_EndBlip = Blip(WaterRescue.AMBULANCE_ENDING_SPOT, 0, 2, 255, 0, 0, 255, 0, 99999)

	self:sendElementFactionVisibleTo( self.m_EndMarker, WaterRescue.VISIBILE_FACTIONS)
	self:sendElementFactionVisibleTo( self.m_EndBlip, WaterRescue.VISIBILE_FACTIONS)

	addEventHandler("onMarkerHit", self.m_EndMarker,
		function (hitElement, matchingDimension)
			if hitElement:getType() == "vehicle" and matchingDimension then
				if hitElement == self.m_TransportingVehicle then
					self:addBonus(2000)
					self:nextPhase()
				else
					local occupants = hitElement:getOccupants()
					if occupants[0] and isElement(occupants[0]) then
						occupants[0]:sendMessage("Dieser Marker ist für den Krankenwagen der Feuerwehr!")
					end
				end
			end
		end
	)	
end

function WaterRescue:Phase5()
	self:sendFactionSlideMessage({"Wasserrettung beendet!", "Gesamter Bonus: " .. self:getBonus() .. " €"}, WaterRescue.VISIBILE_FACTIONS, 500, 3500 )

	self:payBonus()
	self:resetBonus()

	for key, value in ipairs ( getElementsByType("player")) do
		if self.m_BonusFactions[value:getData("Fraktion")] and value:getData("Duty") then
		--	levelup(value, 118)
		end
	end		
end