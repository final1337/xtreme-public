HouseFire = inherit(ActivityBase)
inherit(Singleton, HouseFire)
inherit(Bonus, HouseFire)
-- 2495.9013671875,-1692.796875,1014.7421875; interior : 3
-- Challenge mode - Herausforderung durch hochsteigen
-- Deathmatch-Mode: ScheinEffekt; Mini-WM ( Teams )
-- Fratkiosnauto designer rotieren etc
HouseFire.CASES = {
	[1] = {
		Enterposition = Vector3(-2721.0322265625,-127.9609375,4.3359375),
		Leaveposition = Vector3(2807.6337890625,-1173.986328125,1025.5703125),
		InteriorID    = 8,
		Startposition = Vector3(-2712.1318359375,-134.5302734375,3.328125),
		Fires = 
		{
			Outside  = {
				{-2722.0693359375,-133.416015625,4.3359375},
				{-2721.393359375,-133.416015625,7.3359375},
				{-2721.393359375,-128.416015625,7.3359375},
			}, 
			Inside = {
			    {2811.7900390625,-1167.3154296875,1025.3703125  },
                {2807.41796875,-1168.3935546875,1025.3703125    },
                {2804.265625,-1167.673828125,1026.3592041016    },
                {2803.80859375,-1163.8720703125,1028.9046142578 },
                {2817.0615234375,-1166.015625,1028.971875       },
                {2818.7138671875,-1168.1005859375,1028.971875   },
                {2815.1796875,-1168.740234375,1028.971875       },
                {2809.1015625,-1162.2685546875,1028.9645507813  },
                {2806.9833984375,-1166.3779296875,1025.3703125  },
                {2812.1142578125,-1170.837890625,1025.3703125   },
                {2817.1650390625,-1172.3896484375,1025.5703125      },
                {2819.1025390625,-1169.1875,1025.5703125            },
                {2816.3193359375,-1166.6826171875,1025.5777587891   },
                {2814.2451171875,-1168.3974609375,1025.5777587891   },
			},
		},
        
        NPCS = {
            {2814.794921875,-1170.0888671875,1029.171875        },
            {2812.74609375,-1168.4423828125,1029.171875         },
            {2803.8642578125,-1161.6416015625,1029.171875       },
            {2812.6259765625,-1173.01953125,1025.5777587891     },
            {2819.935546875,-1165.611328125,1025.5777587891     },
            {2819.8837890625,-1173.287109375,1025.5703125       },
        },
		
		RoofNPCS = {
			{-2722.880859375,-127.5810546875,10.348371505737	},
			{-2723.8837890625,-122.4033203125,10.203276634216	},	
			{-2726.7861328125,-131.2275390625,11.9609375		},	
		},
		
		RoofRescuePosition = Vector3(-2716.2783203125,-124.14453125,4.3359375),

        SmokeZones = {
            {2800.5712890625,-1175.576171875, 50, 50},        
        },
	},
	[2] = {
		Enterposition = Vector3(-2586.01171875,795.470703125,49.598983764648),
		Leaveposition = Vector3(2269.5400390625,-1210,1047.5625),
		InteriorID    = 10,
		Startposition = Vector3(-2580.603515625,799.6162109375,48.978378295898),
		Fires = 
		{
			Outside  = {
				{-2589.7802734375,797.1572265625,54.805648803711	},
				{-2582.1455078125,796.8701171875,54.619121551514    },
				{-2581.03515625,794.1748046875,49.42329788208       },
				{-2588.775390625,794.4970703125,49.467067718506     },
				{-2591.087890625,818.67578125,54.689552307129		},
				{-2587.9794921875,819.1220703125,54.436988830566    },
				{-2583.3740234375,819.6083984375,54.892810821533    },
			}, 
			Inside = {
				{2263.8955078125,-1210.2685546875,1049.0234375	},
				{2258.498046875,-1212.7685546875,1049.0234375   },
				{2260.869140625,-1216.09375,1049.0234375        },
				{2261.474609375,-1222.2822265625,1049.0234375   },
				{2258.7255859375,-1221.328125,1049.0234375      },
				{2252.95703125,-1216.96875,1049.0234375         },
				{2255.6298828125,-1211.67578125,1049.0234375    },
				{2253.287109375,-1208.9638671875,1049.0234375   },
				{2248.9755859375,-1210.021484375,1049.0234375   },
				{2260.3154296875,-1207.05859375,1049.0307617188	},
				{2257.6640625,-1218.0078125,1049.0234375        },
				{2261.111328125,-1206.42578125,1049.0234375		},		
			},
		},
        
        NPCS = {
			{2257.1767578125,-1205.7744140625,1049.0234375		},
			{2248.765625,-1207.8818359375,1049.0234375          },
			{2248.4287109375,-1213.8095703125,1049.0234375      },
			{2262.7822265625,-1218.4150390625,1049.0234375      },
			{2257.6298828125,-1224.412109375,1049.7917480469    },
			{2251.0595703125,-1217.5166015625,1049.0234375      },
			{2254.2470703125,-1213.8017578125,1049.0234375		},
        },
		
		RoofNPCS = {
			{-2590.5419921875,821.1376953125,57.155250549316	},
			{-2588.2021484375,821.287109375,57.155246734619     },
			{-2586.837890625,824.49609375,57.155250549316       },
		},
		
		RoofRescuePosition = Vector3(-2593.2138671875,801.8134765625,49.984375),

        SmokeZones = {
            {2246.66015625,-1227.6455078125, 50, 50},        
        },
	},	
	[3] = {
		Enterposition = Vector3(-2899.06, 479.86, 4.91),
		Leaveposition = Vector3(140.05, 1366.85, 1083.86),
		InteriorID    = 5,
		Startposition = Vector3(-2897.74, 473.08, 4.91),
		Fires = 
		{
			Outside  = {
				{-2910.85, 483.87, 6.74},
				{-2907.50, 484.04, 4.91},
				{-2898.80, 481.75, 6.43},
				{-2887.68, 483.95, 6.06},
				{-2888.65, 484.03, 4.91},
				{-2914.70, 492.70, 6.37},
			}, 
			Inside = {
				{151.35, 1386.22, 1088.37},
				{148.22, 1385.10, 1089.05},
				{152.08, 1380.28, 1088.37},
				{151.00, 1374.67, 1088.37},
				{149.96, 1371.22, 1088.37},
				{147.62, 1375.00, 1088.37},
				{146.88, 1381.43, 1088.37},
				{146.04, 1378.87, 1088.37},
				{137.67, 1380.58, 1088.37},
				{139.30, 1384.61, 1088.37},
				{144.05, 1385.16, 1088.37},
				{139.12, 1372.98, 1084.93},
				{140.57, 1375.33, 1086.69},
				{146.29, 1369.39, 1083.86},
				{150.36, 1374.84, 1083.86},
				{151.70, 1368.76, 1083.86},
				{136.69, 1371.58, 1083.87},
				{136.97, 1380.37, 1083.87},
				{135.66, 1383.41, 1083.87},
				{150.07, 1379.65, 1083.86},
				{152.44, 1383.07, 1083.86},
				{150.43, 1382.87, 1084.66},
				{148.56, 1383.21, 1083.86},
				{143.12, 1380.89, 1083.87},
				{145.94, 1375.82, 1083.86},
				{136.92, 1366.50, 1083.86},
				{138.17, 1378.20, 1088.37},	
				{140.49, 1382.75, 1083.87},
				{142.89, 1380.75, 1088.37},
				{141.94, 1383.53, 1088.37},
				{151.47, 1383.65, 1088.37},
				{152.08, 1377.26, 1089.05},
				{143.63, 1374.42, 1083.87},
			},
		},
        
        NPCS = {
			{137.15, 1386.52, 1083.87},
			{135.33, 1381.16, 1088.37},
			{154.08, 1375.78, 1088.37},
			{153.88, 1382.73, 1088.37},
			{153.04, 1376.14, 1083.86},
			{144.79, 1382.62, 1088.37},
			{153.29, 1386.52, 1083.86},
			{140.80, 1385.72, 1084.43},
        },
		
		RoofNPCS = {
			{-2893.73, 483.71, 9.28	},
			{-2906.58, 483.62, 9.28},
			{-2903.63, 501.71, 9.28},
			{-2893.21, 493.58, 15.71},
			{-2907.66, 488.78, 15.20},
			{-2898.90, 498.80, 15.21},			
		},
		
		RoofRescuePosition = Vector3(-2905.82, 476.37, 4.91),

        SmokeZones = {
            {110.05, 1336.85, 100, 100},        
        },
	},	
}

HouseFire.DIMENSION = 2312

HouseFire.AVAILABLE_FACTIONS = {
	[9] = true,
}

HouseFire.CHAT_FACTION = {}

for key, value in pairs ( HouseFire.AVAILABLE_FACTIONS ) do table.insert(HouseFire.CHAT_FACTION, key) end

function HouseFire:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	Bonus.constructor(self)


	for faction in pairs(HouseFire.AVAILABLE_FACTIONS) do
		self:addBonusFaction(faction)
	end	
end

function HouseFire:FailPhase1()
	
end

function HouseFire:AfterPhase1()
	if self.m_StartMarker then
		self.m_StartMarker:destroy()
	end
	if isElement(self.m_StartBlip) then
		self.m_StartBlip:destroy()
	end
end

function HouseFire:Phase1()

	self:resetBonus()
	self.m_Bonus = 0
	
	self.m_ActiveMission = math.random(1,3)
	self.m_StartMarker = Marker(HouseFire.CASES[self.m_ActiveMission].Startposition, "cylinder", 4, 0, 0, 125, 125)
	self.m_StartBlip   = self:sendElementFactionVisibleTo ( Blip(HouseFire.CASES[self.m_ActiveMission].Startposition, 0, 2, 255, 0, 0), HouseFire.CHAT_FACTION)

	self:sendFactionSlideMessage({"Hausbrand bei : ".. getZoneName(HouseFire.CASES[self.m_ActiveMission].Startposition), "Beteiligte Zivilisten im Haus: " .. #HouseFire.CASES[self.m_ActiveMission].NPCS}, HouseFire.CHAT_FACTION, 500, 3500 )

	addEventHandler("onMarkerHit", self.m_StartMarker,
		function(hitElement, matchingDimension)
			if hitElement:getType() == "player" and matchingDimension and HouseFire.AVAILABLE_FACTIONS[getElementData(hitElement, "Fraktion")] then
				self:nextPhase()
			end
		end
	)
end	

function HouseFire:AfterPhase2()
	-- Teleport the players out of the interior
	for key, value in ipairs(getElementsByType("player")) do
		if value:getInterior() == HouseFire.CASES[self.m_ActiveMission].InteriorID and value:getDimension() == HouseFire.DIMENSION then
			value:setPosition(HouseFire.CASES[self.m_ActiveMission].Startposition)
			value:setDimension(0)
			value:setInterior(0)
		end
	end	
	
    for key, value in pairs(self.m_OuterFires) do
        value:delete()
    end
    for key, value in pairs(self.m_InnerFires) do
        value:delete()
    end
    if isTimer(self.m_InnerFireTimer) then
        killTimer(self.m_InnerFireTimer)
    end
    if isTimer(self.m_OuterFireTimer) then
        killTimer(self.m_OuterFireTimer)
    end
    for key, value in pairs(self.m_SmokeZones) do
        value:delete()
    end
    for key, value in pairs(self.m_NPCS) do
		if isElement(value) then
			if value.isGettingCarried then
				value.isGettingCarried:setData("isGettingCarried", false)
			end
			value:destroy()
		end
    end
	
	for key, value in ipairs(self.m_RoofNPCElements) do
		if isElement(value) then
			value:destroy()
		end
	end
	
	if self.m_InsideTeleporter then
		self.m_InsideTeleporter:destroy()
		self.m_OutsideTeleporter:destroy()
	end
	
	if isElement(self.m_RoofRescueMarker) then
		self.m_RoofRescueMarker:destroy()
	end
end

function HouseFire:onOuterFireFinish (fire)
    self.m_DamageForNPCS = self.m_DamageForNPCS - ( 9 / (#HouseFire.CASES[self.m_ActiveMission].Fires.Outside) )
    for _, smokezone in ipairs(self.m_SmokeZones) do
        smokezone:setDamage(self.m_DamageForNPCS)
    end
    self:addBonus(100)
	self.m_ResetOuterCounts[fire.Key] = getTickCount()
end

function HouseFire:Phase2()
	-- Init Fires
	
    self.m_DamageForNPCS = 9
	self.m_DeliveredNPCS = 0

    -- Fires Outside

	self.m_OuterFires = {}
	self.m_ResetOuterCounts = {}
	
	for key, value in ipairs(HouseFire.CASES[self.m_ActiveMission].Fires.Outside) do
		self.m_OuterFires[key] = FireManager:getSingleton():addEntity(value[1], value[2], value[3], 0, 0)
		self.m_OuterFires[key].Key = key
        self.m_OuterFires[key].onFinish = bind(self.onOuterFireFinish, self)
		self.m_OuterFires[key].onTouchFire = function (fire,hitElement) setPedOnFire(hitElement, true) end
	end
	
	self.m_OuterFireTimer = Timer( function ()
		for key, fire in ipairs(self.m_OuterFires) do
			if fire:getExtinguishedState() and ( not self.m_ResetOuterCounts[key] or getTickCount() >= 60000*2+self.m_ResetOuterCounts[key] ) then
				local x,y,z = unpack(HouseFire.CASES[self.m_ActiveMission].Fires.Outside[key])
				self.m_OuterFires[key] = FireManager:getSingleton():addEntity(x,y,z,0,0)
                self.m_DamageForNPCS = self.m_DamageForNPCS + ( 9 / (#HouseFire.CASES[self.m_ActiveMission].Fires.Outside) )
				self.m_OuterFires[key].Key = key
                self.m_OuterFires[key].onFinish = bind(self.onOuterFireFinish, self)
				self.m_OuterFires[key].onTouchFire = function (fire,hitElement) setPedOnFire(hitElement, true) end
                for _, smokezone in ipairs(self.m_SmokeZones) do
                    smokezone:setDamage(self.m_DamageForNPCS)
                end
			end
		end
	end, 5000, 0 )

    -- Fires Inside

	self.m_InnerFires = {}
	self.m_ResetInnerCounts = {}
	
	for key, value in ipairs(HouseFire.CASES[self.m_ActiveMission].Fires.Inside) do
		self.m_InnerFires[key] = FireManager:getSingleton():addEntity(value[1], value[2], value[3], HouseFire.CASES[self.m_ActiveMission].InteriorID, HouseFire.DIMENSION)
		self.m_InnerFires[key].onTouchFire = function (fire,hitElement) setPedOnFire(hitElement, true) end
		self.m_InnerFires[key].Key = key
		self.m_InnerFires[key].onFinish    = function (fire) self.m_ResetInnerCounts[fire.Key] = getTickCount() end
	end
	
	self.m_InnerFireTimer = Timer( function ()
		for key, fire in ipairs(self.m_InnerFires) do
			if fire:getExtinguishedState() and ( not self.m_ResetInnerCounts[key] or getTickCount() >= 45000+self.m_ResetInnerCounts[key] ) then
				local x,y,z = unpack(HouseFire.CASES[self.m_ActiveMission].Fires.Inside[key])
				self.m_InnerFires[key] = FireManager:getSingleton():addEntity(x,y,z,HouseFire.CASES[self.m_ActiveMission].InteriorID, HouseFire.DIMENSION)
				self.m_InnerFires[key].Key = key
				self.m_InnerFires[key].onFinish    = function (fire) self:addBonus (125) self.m_ResetInnerCounts[fire.Key] = getTickCount() end
				self.m_InnerFires[key].onTouchFire = function (fire,hitElement) setPedOnFire(hitElement, true) end
			end
		end
	end, 5000, 0 )
    
    -- SmokeZone
    
    self.m_SmokeZones = {}

    for key, value in ipairs(HouseFire.CASES[self.m_ActiveMission].SmokeZones) do
		self.m_SmokeZones[key] = SmokeZone:new(value[1], value[2], value[3], value[4], HouseFire.CASES[self.m_ActiveMission].InteriorID,  HouseFire.DIMENSION )
        self.m_SmokeZones[key]:setDamage(self.m_DamageForNPCS)
		self.m_SmokeZones[key].onDamage = bind(self.onSmokeAreaDamage, self)
    end


    -- NPCS

    self.m_NPCS = {}

    for key, value in ipairs(HouseFire.CASES[self.m_ActiveMission].NPCS) do
        self.m_NPCS[key] = Ped(math.random(20,30), unpack(value))
		local npc = self.m_NPCS[key]
        npc:setInterior(HouseFire.CASES[self.m_ActiveMission].InteriorID)
		npc.Marker = Marker(0,0,0,"arrow", 0.3, 0, 255, 0, 255)
		npc.Marker:setDimension(HouseFire.DIMENSION)
		npc.Marker:setInterior(HouseFire.CASES[self.m_ActiveMission].InteriorID)
		
        npc:setDimension(HouseFire.DIMENSION)
        npc:setAnimation("ped", "cower")
		npc.Marker:attach(npc, 0, 0, 1)
		npc.Marker:setParent(npc)
		
		addEventHandler("onElementClicked", npc, bind(self.onPedClicked, self))
    end
	
	-- RoofNPCS
	
	self.m_RoofNPCElements = {}
	
    for key, value in ipairs(HouseFire.CASES[self.m_ActiveMission].RoofNPCS) do
        self.m_RoofNPCElements[key] = Ped(math.random(20,30), unpack(value))
		local npc = self.m_RoofNPCElements[key]
		npc.Marker = Marker(0,0,0,"arrow", 0.3, 0, 255, 0, 255)
		npc.Marker:setDimension(0)
        npc:setDimension(0)
       
		npc.Marker:attach(npc, 0, 0, 1)
		npc.Marker:setParent(npc)
		
		npc:setFrozen(true)
		npc:setAnimation("ped", "cower")
		addEventHandler("onElementClicked", npc, bind(self.onPedClicked, self))
    end	
	
	if HouseFire.CASES[self.m_ActiveMission].RoofRescuePosition then
		self.m_RoofRescueMarker = Marker ( HouseFire.CASES[self.m_ActiveMission].RoofRescuePosition, "corona", 3, 0, 255, 0)
		
		addEventHandler("onMarkerHit", self.m_RoofRescueMarker, bind (self.safeRescueMarker, self))
	end
	
    -- Teleporter
	
	self.m_InsideTeleporter  = Marker ( HouseFire.CASES[self.m_ActiveMission].Leaveposition, "corona", 1.2)
	self.m_OutsideTeleporter = Marker ( HouseFire.CASES[self.m_ActiveMission].Enterposition, "corona", 1.2)
    self.m_InsideTeleporter:setInterior(HouseFire.CASES[self.m_ActiveMission].InteriorID)
    self.m_InsideTeleporter:setDimension(HouseFire.DIMENSION)
	
	addEventHandler("onMarkerHit", self.m_InsideTeleporter, bind ( self.teleportToMarker, self, self.m_OutsideTeleporter))
    addEventHandler("onMarkerHit", self.m_OutsideTeleporter, bind( self.teleportToMarker, self, self.m_InsideTeleporter))
	
	addEventHandler("onPlayerWasted", root, bind(self.failPed, self))
	addEventHandler("onPlayerQuit", root, bind(self.failPed, self))
end

function HouseFire:safeRescueMarker(hitElement, matchingDimension)
	if hitElement:getData("isCarryingHouseFirePed") and matchingDimension then
		local ped = hitElement:getData("isCarryingHouseFirePed")
		ped:destroy()
		self:addBonus(175)
		hitElement:setData("isCarryingHouseFirePed", false)
		self.m_DeliveredNPCS = self.m_DeliveredNPCS + 1	
		if self.m_DeliveredNPCS >= (#HouseFire.CASES[self.m_ActiveMission].NPCS+#HouseFire.CASES[self.m_ActiveMission].RoofNPCS) then
			self:nextPhase()
		end
	end	
end

function HouseFire:onSmokeAreaDamage(smokezone, damage)
	for key, value in pairs(self.m_NPCS) do
		if value and isElement(value) and not value.isGettingCarried then
			value:setHealth ( value:getHealth() - damage/10 )
			local progress =   (100 - value:getHealth())/100
			value.Marker:setColor ( progress*255, 255 - progress*255, 0, 255)
			if value:getHealth () <= 0 then
				self.m_DeliveredNPCS = self.m_DeliveredNPCS + 1
				value:destroy()
				if self.m_DeliveredNPCS >= #HouseFire.CASES[self.m_ActiveMission].NPCS	 then
					self:nextPhase()
				end
			end
		end
	end
end

function HouseFire:failPed(player)
	if source then player = source end
	if player and player:getData("isCarryingHouseFirePed") then
		local ped = player:getData("isCarryingHouseFirePed")
		ped:detach()
		ped:setAnimation("ped", "cower")
		player:setData("isCarryingHouseFirePed", false)
		ped.isGettingCarried = false
	end
end

function HouseFire:onPedClicked(mouseButton, buttonState, player)
	if mouseButton == "left" and buttonState == "up" and HouseFire.AVAILABLE_FACTIONS[getElementData(player, "Fraktion")] and not player:getData("isCarryingHouseFirePed") and (player:getPosition()-source:getPosition()).length < 4 then
		if player:isOnFire() then
			player:sendMessage("Sie können derzeit nicht den NPC mitnehmen, da sie brennen!")
		elseif not player:getData("isCarryingHouseFirePed") and not source.isGettingCarried then
			player:setData("isCarryingHouseFirePed", source)
			source.isGettingCarried = player
			source:attach(player, 0, 1, 0)
			source:setAnimation(false)
		end
	elseif mouseButton == "left" and buttonState == "up" and HouseFire.AVAILABLE_FACTIONS[getElementData(player,"Fraktion")] and player:getData("isCarryingHouseFirePed") and player:getData("isCarryingHouseFirePed") == source then
		self:failPed(player)
	end
end

function HouseFire:teleportToMarker(teleportToMarker, hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and not getPedOccupiedVehicle(hitElement)  and not getElementData(hitElement, "gotPreviouslyTeleported") and matchingDimension then
        setElementData(hitElement, "gotPreviouslyTeleported", true)
        Timer( setElementData, 500, 1, hitElement, "gotPreviouslyTeleported", false )
        local markerDim = teleportToMarker:getDimension()
        local markerInt = teleportToMarker:getInterior()
        local markerPos = teleportToMarker:getPosition()
        
        hitElement:setPosition(markerPos)
        hitElement:setDimension(markerDim)
        hitElement:setInterior(markerInt)
		
		if teleportToMarker == self.m_OutsideTeleporter then
			if hitElement:getData("isCarryingHouseFirePed") then
				local ped = hitElement:getData("isCarryingHouseFirePed")
				self.m_DeliveredNPCS = self.m_DeliveredNPCS + 1
				self:addBonus(325)
				ped:destroy()
				hitElement:setData("isCarryingHouseFirePed", false)	
				if self.m_DeliveredNPCS >= (#HouseFire.CASES[self.m_ActiveMission].NPCS+#HouseFire.CASES[self.m_ActiveMission].RoofNPCS) then
					self:nextPhase()
				end
			end
		end
	end
end

function HouseFire:Phase3()
	self:sendFactionSlideMessage({"Hausbrand beendet!", "Gesamter Bonus: " .. self:getBonus() .. " €"}, HouseFire.CHAT_FACTION, 500, 3500 )
	self:payBonus()
	self:resetBonus()

	for key, value in ipairs ( getElementsByType("player")) do
		if self.m_BonusFactions[value:getData("Fraktion")] and value:getData("Duty") then
		--	levelup(value, 120)
		end
	end			
end

addCommandHandler("getp",
	function (player)
		local x,y,z = getElementPosition(player)
		player:sendMessage("%.2f, %.2f, %.2f", 125, 125, 125, x,y,z)
	end
)