Stonefall = inherit(ActivityBase)
inherit(Singleton, Stonefall)
inherit(Bonus, Stonefall)


-- Phase 1

Stonefall.PHASE1_STONE_POSITIONS = 
{
	[1] = {
		{898,-1522.9000244141,-825.20001220703,58.799999237061},
		{898,-1522.9000244141,-814.20001220703,58.799999237061},
		{898,-1522.9000244141,-808.20001220703,58.799999237061},
	},
	[2] = {
		{880,-2001.6000000,2555.1001000,56.3000000,0.0000000,0.0000000,0.0000000},
		{897,-1995.5000000,2567.8000000,59.3000000,0.0000000,0.0000000,0.0000000},
		{905,-1998.9000000,2557.3000000,57.3000000,0.0000000,0.0000000,0.0000000},
		{867,-1993.5000000,2565.5000000,54.4000000,0.0000000,0.0000000,292.00000},
		{879,-1991.3000000,2557.2000000,56.3000000,0.0000000,0.0000000,0.0000000},
		{898,-1991.9000000,2595.2000000,56.5000000,0.0000000,264.0000000,40.0000},
		{867,-1988.5000000,2587.2000000,50.5000000,0.0000000,0.0000000,240.00000},
		{879,-1981.4000000,2594.3000000,52.2000000,0.0000000,0.0000000,90.000000},
		{880,-1990.9000000,2582.3999000,52.3000000,0.0000000,0.0000000,348.00000},
		{828,-1986.8000000,2588.2000000,49.7000000,0.0000000,0.0000000,0.0000000},
	},
	[3] = {
		{758,-898.7999900,-236.2000000,35.1000000,0.0000000,0.0000000,0.0000000},
		{807,-899.0000000,-239.0000000,35.2000000,0.0000000,0.0000000,0.0000000},
		{868,-898.9000200,-245.2000000,35.5000000,0.0000000,0.0000000,92.000000},
		{880,-900.4000200,-255.8000000,37.7000000,0.0000000,0.0000000,0.0000000},
		{868,-902.7999900,-239.3000000,35.5000000,0.0000000,0.0000000,312.00000},
		{828,-900.2000100,-248.8999900,35.8000000,0.0000000,0.0000000,0.0000000},
		{807,-901.9000200,-238.2000000,34.9000000,0.0000000,0.0000000,0.0000000},
		{905,-901.2999900,-246.8999900,35.2000000,0.0000000,0.0000000,0.0000000},
		{828,-898.2000100,-247.1000100,35.1000000,0.0000000,0.0000000,0.0000000},
		{879,-897.2999900,-247.3999900,37.6000000,0.0000000,0.0000000,0.0000000},
	},
	[4] = {
		{868,-712.2000100,-1496.1000000,56.5000000,0.0000000,0.0000000,34.000000},
		{901,-717.5000000,-1490.7000000,58.6000000,9.2690000,0.0000000,186.07100},
		{879,-698.5999800,-1481.7000000,58.5000000,0.0000000,2.0000000,108.00000},
		{906,-707.9000200,-1482.7000000,57.9000000,0.0000000,0.0000000,0.0000000},
		{816,-709.0000000,-1482.1000000,55.9000000,0.0000000,0.0000000,0.0000000},
		{880,-691.4000200,-1479.0000000,61.0000000,0.0000000,0.0000000,0.0000000},
		{867,-701.5000000,-1483.2000000,57.4000000,0.0000000,346.0000000,8.00000},
		{867,-708.5999800,-1488.8000000,56.1000000,0.0000000,0.0000000,312.00000},
		{868,-694.2999900,-1478.1000000,58.5000000,0.0000000,0.0000000,0.0000000},	
	},
}

-- Phase 2

Stonefall.PHASE2_DYNAMITE_POSITIONS = 
{
	[1] = {
		{-1531.8388671875,-808.8203125,56.176399230957		  },
		{-1531.1484375,-814.6767578125,56.113349914551         },
		{-1529.7412109375,-822.357421875,56.477802276611       },
		{-1529.9677734375,-805.873046875,56.421741485596	   },
	},
	[2] = {
		{-1991.341796875,2556.259765625,55.32674407959		},
		{-1989.5439453125,2561.658203125,55.25569152832     },
		{-1989.8671875,2568.3193359375,55.550037384033      },
		{-1986.5439453125,2583.6474609375,51.458808898926   },
		{-1980.5478515625,2593.240234375,51.671157836914    },
		{-1997.375,2590.0234375,51.615642547607             },
		{-2000.39453125,2574.388671875,55.160522460938      },
		{-1999.521484375,2563.3662109375,55.214683532715    },
	},
	[3] = {
		{-896.39453125,-242.951171875,37.654293060303		},
		{-895.9345703125,-249.8095703125,37.628135681152    },
		{-894.5341796875,-254.8505859375,37.848068237305    },
		{-902.5185546875,-251.658203125,37.730270385742     },
		{-903.9794921875,-243.0400390625,37.776996612549    },
	},
	[4] = {
		{-721.9765625,-1497.6025390625,57.829956054688		},
		{-715.1201171875,-1496.416015625,57.870628356934    },
		{-710.23046875,-1484.861328125,58.21284866333       },
		{-719.36328125,-1482.94921875,58.272087097168       },
		{-705.4677734375,-1479.08203125,58.736175537109     },
		{-690.5400390625,-1476.080078125,61.599964141846    },
	}
	
}

-- Phase 4

Stonefall.PHASE4_PICKAXE_STONES_POSTIIONS = {
	[1] = {

	},
	[2] = {
		
	},
	[3] = {
		{-898.328125,-241.607421875,36.683303833008			},
		{-898.4326171875,-251.822265625,36.668395996094     },
		{-900.8876953125,-252.3525390625,36.705348968506    },
	},
	[4] = {
		{-719.5087890625,-1490.6005859375,57.042129516602	},
		{-711.2568359375,-1479.798828125,57.362976074219    },
		{-698.2783203125,-1482.9931640625,58.89998626709    },
	},
}



Stonefall.AVAILABLE_FACTIONS = {
	[9] = true,
}

Stonefall.CHAT_FACTION = {}

for key, value in pairs ( Stonefall.AVAILABLE_FACTIONS ) do table.insert(Stonefall.CHAT_FACTION, key) end

function Stonefall:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	Bonus.constructor(self)

	self.m_Phase4_ClickHandler = bind(self.Event_OnElementClicked,self)
	self.m_Phase4_FailHandler  = bind(self.Event_OnPlayerFailed,  self)
	self.m_ExplodeHandler      = bind(self.Event_OnVehicleExplode, self)
	
	self:addBonusFaction(9)
end

function Stonefall:FailPhase1()
	for key, value in ipairs(self.m_Objects) do
		destroyElement(value)
	end
end

function Stonefall:AfterPhase1()
	if isElement(self.m_DynamiteMarker) then
		destroyElement(self.m_DynamiteMarker)
		destroyElement(self.m_DynamiteBlip)
	end
end

function Stonefall:Event_OnVehicleExplode()
	self:failCurrentPhase()
	removeEventHandler("onVehicleExplode", self.m_TransportVehicle, self.m_ExplodeHandler)
end

function Stonefall:Phase1()
	self:resetBonus()
	self.m_ActiveMission = math.random(3,4)
	self.m_ActiveMissionPosition = Vector3(select(2,unpack(Stonefall.PHASE1_STONE_POSITIONS[self.m_ActiveMission][1])))
	local zoneName = getZoneName(self.m_ActiveMissionPosition)
	self:sendFactionSlideMessage({"Felssturz!", "Unfallort bei ".. zoneName, "Holen sie das Dynamit\nbei der Basis in SF ab!"}, Stonefall.CHAT_FACTION, 500, 3500)
	self:sendFactionMessage("Das verwendete Fahrzeug wird auch als Transportfahrzeug verwendet!", Stonefall.CHAT_FACTION)
	self.m_DynamiteBlip   = self:sendElementFactionVisibleTo ( Blip  (-2018.16, 49.32, 31.19), Stonefall.CHAT_FACTION)
	self.m_DynamiteMarker = Marker(-2018.16, 49.32, 31.19, "cylinder", 3.5, 0, 125, 0)
	
	self.m_Objects = {}
	
	for key, value in ipairs(Stonefall.PHASE1_STONE_POSITIONS[self.m_ActiveMission]) do
		self.m_Objects[key] = createObject(value[1], value[2], value[3], value[4])
	end
	
	addEventHandler("onMarkerHit", self.m_DynamiteMarker,	
		function(hitElement, matchingDimension)
			if hitElement:getType() == "vehicle" and getElementData(hitElement, "Firefighter") then
				self:sendFactionSlideMessage({"Das Dynamit wurde abgeholt."}, Stonefall.CHAT_FACTION, 500, 3500)
				self.m_TransportVehicle = hitElement
				self:addBonus(500)
				self:nextPhase()
			end
		end
	)

end

function Stonefall:FailPhase2()
	if isElement(self.m_AccBlip) then
		self.m_AccBlip:destroy()
	end
	for key, value in ipairs(self.m_Objects) do
		destroyElement(value)
	end	
end

function Stonefall:AfterPhase2()
	for key, value in ipairs(self.m_DynamiteMarkers) do
		if isElement(value) then
			value:destroy()
		end
	end
end

function Stonefall:Phase2()
	self.m_AccBlip   = self:sendElementFactionVisibleTo ( Blip  (self.m_ActiveMissionPosition), Stonefall.CHAT_FACTION)
	addEventHandler("onVehicleExplode", self.m_TransportVehicle, self.m_ExplodeHandler)
	-- Create the dynamite marker
	self.m_DynamiteMarkers = {}
	self.m_DynamitePlanted = 0
	
	for key, value in ipairs(Stonefall.PHASE2_DYNAMITE_POSITIONS[self.m_ActiveMission]) do
		self.m_DynamiteMarkers[key] = self:sendElementFactionVisibleTo ( Marker  (value[1], value[2], value[3], "corona", 1.2), Stonefall.CHAT_FACTION)
		self:sendElementFactionVisibleTo( Blip(value[1],value[2], value[3], 0, 2, 0, 255, 0), Stonefall.CHAT_FACTION):setParent(self.m_DynamiteMarkers[key])
		
		addEventHandler("onMarkerHit", self.m_DynamiteMarkers[key],
			function(hitElement, matchingDimension)
				if hitElement:getType() == "player" then
					if not Stonefall.AVAILABLE_FACTIONS[getElementData(hitElement, "Fraktion")] then
						hitElement:sendMessage("Sie sind in der falschen Fraktion!")
					else
						setElementFrozen(hitElement, true)
						setPedAnimation( hitElement, "BOMBER", "BOM_Plant_Loop", true, false, false)
						setTimer( function ()
							setPedAnimation(hitElement, false)
							setElementFrozen(hitElement, false)
						end, 1500, 1)
						self:addBonus(600)
						self.m_DynamitePlanted = self.m_DynamitePlanted + 1
						self:sendFactionMessage(("Noch %d Stellen verbleidend!"):format(#Stonefall.PHASE2_DYNAMITE_POSITIONS[self.m_ActiveMission] - self.m_DynamitePlanted), Stonefall.CHAT_FACTION)
						source:destroy()
						if self.m_DynamitePlanted >= #Stonefall.PHASE2_DYNAMITE_POSITIONS[self.m_ActiveMission] then
							self:nextPhase()
						end
					end
				end
			end
		)
	end
	
end

function Stonefall:FailPhase3()
	if isElement(self.m_AccBlip) then
		self.m_AccBlip:destroy()
	end	
	for key, value in ipairs(self.m_Objects) do
		destroyElement(value)
	end	
end

function Stonefall:AfterPhase3()
	if isTimer(self.m_ExplosionTimer) then
		killTimer(self.m_ExplosionTimer)
		if isTimer(self.m_SingleExplosionTimer) then
			killTimer(self.m_SingleExplosionTimer)
		end
	end
end

function Stonefall:Phase3()
	 self:sendFactionSlideMessage({"Explosion in 5", 4, 3, 2, 1, "Boom"}, Stonefall.CHAT_FACTION, 500, 1000)
	
	self.m_ExplosionTimer = setTimer( function ()
		self.m_SingleExplosionTimer = setTimer( function ()
			for key, value in ipairs(Stonefall.PHASE2_DYNAMITE_POSITIONS[self.m_ActiveMission]) do
				createExplosion(value[1], value[2], value[3], 10)
				local _, lastCounts, _ = getTimerDetails(self.m_SingleExplosionTimer)
				if lastCounts == 1 and key == #Stonefall.PHASE2_DYNAMITE_POSITIONS[self.m_ActiveMission] then
					self:nextPhase()
				 end
			end
		end, 350, 5)
	end, 5000, 1)
end
	-- GRABBEN SOLL ROCK ID : 2936 / 3929
	-- 758
function Stonefall:AfterPhase4()
	if isElement(self.m_AccBlip) then
		self.m_AccBlip:destroy()
	end	
	for key, value in ipairs(self.m_PickAxeStones) do
		DamageObject:getSingleton():delete(value.Iterator)
		self.m_PickAxeStones[key] = nil
	end
	for key, value in ipairs(self.m_GeneratedGrabStone) do
		if isElement(value) then
			value:destroy()
		end
	end
	if isElement(self.m_TransportMarker) then
		self.m_TransportMarker:destroy()
		self.m_TransportColShape:destroy()
	end
	removeEventHandler("onElementClicked", resourceRoot, self.m_Phase4_ClickHandler)
	removeEventHandler("onPlayerWasted"  , root,         self.m_Phase4_FailHandler)
	removeEventHandler("onPlayerQuit"    , root,         self.m_Phase4_FailHandler)	
end
	
function Stonefall:Phase4()
	local spawnCount  = 0
	local alreadyUsed = {}
	self.m_GrabedStones = 0
	self.m_GeneratedGrabStone = {}
	self.m_PickAxeStones = {}
	self.m_GrabStones = {}
	
	for key, value in ipairs(self.m_Objects) do
		destroyElement(value)
	end
	
	self.m_TransportMarker = Marker(self.m_TransportVehicle:getPosition(), "cylinder", 2, 0, 125, 0, 125, root)
	self.m_TransportColShape = ColShape.Sphere(self.m_TransportVehicle:getPosition(), 2)

	attachElements(self.m_TransportMarker, self.m_TransportVehicle, 3.5, 0, 0)
	attachElements(self.m_TransportColShape, self.m_TransportVehicle, 3.5, 0, 0)
	
	addEventHandler("onColShapeHit", self.m_TransportColShape,
		function(hitElement, matchingDimension)
			if hitElement and getElementType(hitElement) == "player" and hitElement.m_CarryingStone then
				self:addBonus(150)
				detachElements(hitElement.m_CarryingStone)
				destroyElement(hitElement.m_CarryingStone)
				hitElement.m_CarryingStone = nil
				self.m_GrabedStones = self.m_GrabedStones + 1
				toggleControl(hitElement, "fire", true)
				toggleControl(hitElement, "enter_exit", true)
				toggleControl(hitElement, "sprint", true)					
				toggleControl(hitElement, "jump", true)		
				setTimer( function () setPedAnimation(hitElement, false) end, 100, 1)
				if self.m_GrabedStones >= 12 then
					self:nextPhase()
				end
			end
		end
	)		

	while spawnCount < 3 do
		for key, value in ipairs(Stonefall.PHASE4_PICKAXE_STONES_POSTIIONS[self.m_ActiveMission]) do
			if not alreadyUsed[key] then
				if spawnCount >= 3 then
					break
				else
					if math.random(2) == 1 then
						spawnCount = spawnCount + 1
						alreadyUsed[key] = true
						self.m_PickAxeStones[spawnCount] = DamageObject:getSingleton():addEntity(758, value[1], value[2], value[3], 0, 0, 50, {[5] = true})
						self.m_PickAxeStones[spawnCount].onFinish = bind(self.finishedWorkingStone, self)
					end
				end
			end
		end
	end
	
	addEventHandler("onElementClicked", resourceRoot, self.m_Phase4_ClickHandler)
	addEventHandler("onPlayerWasted"  , root,         self.m_Phase4_FailHandler)
	addEventHandler("onPlayerQuit"    , root,         self.m_Phase4_FailHandler)
end

function Stonefall:Event_OnPlayerFailed()
	if source.m_CarryingStone and source.m_CarryingStone.m_IsFireFighterStone then
		detachElements(source.m_CarryingStone)
		setElementCollisionsEnabled(source.m_CarryingStone, true)
		source.m_CarryingStone.m_Carrier       = nil
		source.m_CarryingStone = nil
		toggleControl(source, "fire", true)
		toggleControl(source, "enter_exit", true)
		toggleControl(source, "sprint", true)		
		toggleControl(source, "jump", true)	
		setPedAnimation(source, false)
	end
end

function Stonefall:Event_OnElementClicked(mouseButton, buttonState, player)
	if source.m_IsFireFighterStone and not source.m_Carrier and not player.m_CarryingStone then
		if (source:getPosition()-player:getPosition()).length < 10 then
			if Stonefall.AVAILABLE_FACTIONS[getElementData(player, "Fraktion")] then
				player.m_CarryingStone = source
				source.m_Carrier = player
				setPedAnimation(player, "CARRY", "crry_prtial", 1, true, true, false)
				setElementCollisionsEnabled(source, false)
				toggleControl(player, "fire", false)
				toggleControl(player, "enter_exit", false)
				toggleControl(player, "sprint", false)
				toggleControl(player, "jump", false)
				attachElements(source,player, 0, .55, 0.2)
			else
				player:sendMessage("Du befindest dich in der falschen Fraktion!", 0, 125, 0)
			end
		else
			player:sendMessage("Ihr seid zu weit entfernt!", 0, 125, 0)
		end
	end
end

function Stonefall:finishedWorkingStone(object)
	table.insert(self.m_GeneratedGrabStone, createObject(3929, object.posX + 1, object.posY, object.posZ + .4))
	table.insert(self.m_GeneratedGrabStone, createObject(3929, object.posX - 1, object.posY, object.posZ + .4))
	table.insert(self.m_GeneratedGrabStone, createObject(3929, object.posX, object.posY + 1, object.posZ + .4))
	table.insert(self.m_GeneratedGrabStone, createObject(3929, object.posX, object.posY - 1, object.posZ + .4))
	
	for i = #self.m_GeneratedGrabStone, #self.m_GeneratedGrabStone - 3, -1 do
		local object = self.m_GeneratedGrabStone[i]
		local x,y,z  = getElementPosition(object)
		object.m_IsFireFighterStone = true
		object.marker = Marker(x,y,z, "arrow", 0.3, 0, 125, 0)
		object.marker:setParent(object)	
		object.marker:attach(object, 0, 0,1)
		object:setScale(0.6)
	end
end

function Stonefall:AfterPhase5()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
	end
end

function Stonefall:Phase5()
	self:sendFactionSlideMessage("Fahren sie nun zur markierten Baustelle!", Stonefall.CHAT_FACTION, 500, 3500)

	self.m_EndMarker = Marker(-2099.4384765625,291.8828125,37.301162719727, "corona", 3, 0, 255, 0)
	self.m_EndBlip   = self:sendElementFactionVisibleTo( Blip(-2099.4384765625,291.8828125,37.301162719727, 0, 2, 0, 255, 0), Stonefall.CHAT_FACTION)
	
	addEventHandler("onMarkerHit", self.m_EndMarker, 
		function (hitElement, matchingDimension)
			if hitElement == self.m_TransportVehicle then
				self:nextPhase()
			end
		end
	)
end

function Stonefall:Phase6()
	self:sendFactionSlideMessage({"Felssturz beendet!", "Gesamter Bonus: " .. self:getBonus() .. " €"}, SurfaceFire.CHAT_FACTION, 500, 3500 )

	self:payBonus()
	self:resetBonus()

	for key, value in ipairs ( getElementsByType("player")) do
		if self.m_BonusFactions[value:getData("Fraktion")] and value:getData("Duty") then
		--	levelup(value, 116)
		end
	end		
end