HanfTransport = inherit(ActivityBase)
inherit(Singleton, HanfTransport)

HanfTransport.CRATES_POS_FIRST = {
{165.3999900,-8.7000000,1.2000000,0.0000000,0.0000000,320.0000000 },
-- {164.5996100,-9.5000000,1.2000000,0.0000000,0.0000000,319.9990000 },
-- {169.2000000,-8.5000000,1.2000000,0.0000000,0.0000000,319.9990000 },
-- {167.7000000,-12.9000000,1.2000000,0.0000000,0.0000000,319.9990000},
-- {167.8000000,-12.8000000,2.2000000,0.0000000,0.0000000,319.9990000},
-- {168.3000000,-12.1000000,1.2000000,0.0000000,0.0000000,319.9990000},
-- {170.5000000,-10.3000000,1.2000000,0.0000000,92.0000000,253.9990000},
}



HanfTransport.CRATES_POS_SECOND = 
{
{2819.1001000,894.0999800,9.6000000,0.0000000,0.0000000,0.0000000},
-- {2817.8999000,893.5999800,9.5000000,0.0000000,0.0000000,0.0000000},
-- {2818.3999000,893.7000100,10.5000000,0.0000000,0.0000000,0.0000000},
-- {2858.1001000,944.7999900,11.8000000,0.0000000,0.0000000,0.0000000},
-- {2857.5000000,944.9003900,10.8000000,0.0000000,0.0000000,0.0000000},
-- {2858.6006000,944.7002000,10.8000000,0.0000000,0.0000000,0.0000000},
-- {2877.8000000,897.0999800,11.3000000,0.0000000,0.0000000,0.0000000},
-- {2877.9004000,897.0996100,10.3000000,0.0000000,0.0000000,0.0000000},
}


HanfTransport.MAX_TIME_FOR_ACTION = 1000*60*30
HanfTransport.MAX_TIME_FOR_ACTION_IN_SECONDS = HanfTransport.MAX_TIME_FOR_ACTION/1000

HanfTransport.ALLOWED_FACTIONS_GOOD = {
	[1] = true,
	[2] = true,
	[3] = true,
}

HanfTransport.CHAT_FACTION_GOOD = {}

for key, value in pairs ( HanfTransport.ALLOWED_FACTIONS_GOOD ) do table.insert(HanfTransport.CHAT_FACTION_GOOD, key) end

HanfTransport.ALLOWED_FACTIONS_EVIL = {
	[10] = true,
}

HanfTransport.CHAT_FACTION_EVIL = {}

for key, value in pairs ( HanfTransport.ALLOWED_FACTIONS_EVIL ) do table.insert(HanfTransport.CHAT_FACTION_EVIL, key) end

function HanfTransport:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	
	self.m_StartGate = createObject(969, 161.3, -20, 0.6, 0, 0, 270)
	self.m_StartMarker = createMarker(162.67, -25.89, 0.58, "cylinder", 1.2, 125, 0, 0, 125, root)
	addEventHandler("onMarkerHit", self.m_StartMarker,
		function(player, matchingDimension)
			if matchingDimension and getElementType(player) == "player" and getRealTime()["timestamp"] >= self.m_LastStart + HanfTransport.MAX_TIME_FOR_ACTION_IN_SECONDS and HanfTransport.ALLOWED_FACTIONS_EVIL[getElementData(player,"Fraktion")] then
				self:initActivity()
			end
		end
	)
	
	setGarageOpen(6, true)
end

function HanfTransport:Phase1 ()
	
	self.m_Crates = {}
	self.m_CrateCount = 0
	
	self:sendFactionAlertMessage("Unsere Fraktion belädt\n den Hanfsamentransport", HanfTransport.CHAT_FACTION_EVIL)
	
	moveObject(self.m_StartGate, 3000, 161.3, -24.5, 0.6, 0, 0, 0)
	
	self.m_Dune = createVehicle(573, 157.78, -21.41, 2.23, 0.00, 0.00, 88.07)
	setVehicleColor ( self.m_Dune, 120, 0, 120, 120, 0, 120, 120, 0, 120 )
	--self.m_Dune = createVehicle(560, 157.78, -21.41, 2.23, 0.00, 0.00, 88.07)
	self.m_EndMarker = createMarker(161.79, -21.77, 2.58, "corona", 2, 0, 125, 0, 125, root)
	setElementFrozen(self.m_Dune, true)
	setVehicleLocked(self.m_Dune, true)
	
	addEventHandler("onVehicleExplode", self.m_Dune, bind(self.failCurrentPhase, self))
	
	for key, value in ipairs ( HanfTransport.CRATES_POS_FIRST ) do
		self.m_Crates[key] = createObject(1558, value[1], value[2], value[3], value[4], value[5], value[6])
		setElementFrozen(self.m_Crates[key], true)
		self.m_Crates[key].IsHanfCrate = true
	end
	
	-- Todo: add, when job's done
	triggerClientEvent(root, "setObjectsUnbreakable", root, self.m_Crates)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function(hitElement, matchingDimension)
			if getElementType(hitElement) == "player" and hitElement.CarryingHanfCrate then
				destroyElement(hitElement.CarryingHanfCrate)
				hitElement.CarryingHanfCrate = nil
				self.m_CrateCount = self.m_CrateCount + 1
				if self.m_CrateCount >= #HanfTransport.CRATES_POS_FIRST then
					self:nextPhase()
				end
			end
		end
	)
	
	self.m_ClickHandler = function (button,state,element)
		if button == "left" and state == "up" and element and element.IsHanfCrate and not element.Carrier and not source.CarryingHanfCrate and not getPedOccupiedVehicle(source) then
			if (element.position - source.position).length < 4 then
				if HanfTransport.ALLOWED_FACTIONS_EVIL[getElementData(source, "Fraktion")] then
					source.CarryingHanfCrate = element
					element.Carrier = source
					attachElements(element, source, 0, 1, 0)
				else
					outputChatBox("Du befindest dich in der falschen Fraktion!", source, 125, 0, 0)
				end
			else
				outputChatBox("Sie sind zu weit von der Kiste entfernt!", source, 125, 0, 0)
			end
		end
	end
	
	self.m_QuitHandler = function ()
		if source.CarryingHanfCrate then
			detachElements(source.CarryingHanfCrate)
			source.CarryingHanfCrate.Carrier = nil
			source.CarryingHanfCrate = nil
		end
	end
	
	self.m_WastedHandler = function ()
		if source.CarryingHanfCrate then
			detachElements(source.CarryingHanfCrate)
			source.CarryingHanfCrate.Carrier = nil
			source.CarryingHanfCrate = nil
		end
	end	
	
	
	addEventHandler("onPlayerClick", root, self.m_ClickHandler)
	addEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	addEventHandler("onPlayerWasted", root, self.m_WastedHandler)
	
	
	-- Add a reset timer
	self.m_ResetTimer = setTimer( function () self:failCurrentPhase(true) end, HanfTransport.MAX_TIME_FOR_ACTION, 1 )
	
end

function HanfTransport:FailPhase1()
	self:sendFactionMessage("Der Hanftransport scheiterte in der ersten Phase!", HanfTransport.CHAT_FACTION_EVIL)
	
	if isElement(self.m_Dune) then
		destroyElement(self.m_Dune)
	end
	
	moveObject(self.m_StartGate, 3000, 161.3, -20, 0.6, 0, 0, 0)
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:AfterPhase1(typ)
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
	end
	for key, element in ipairs ( self.m_Crates ) do
		if isElement(element) then
			destroyElement(element)
			if element.Carrier then
				element.Carrier.CarryingHanfCrate = nil
			end
		end
	end
	
	removeEventHandler("onPlayerClick", root, self.m_ClickHandler)
	removeEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	removeEventHandler("onPlayerWasted", root, self.m_WastedHandler)
end

function HanfTransport:FailPhase2(forceFail)
	-- Let to police do the rest of the mission
	if not forceFail then
		self:forcePhase(100)
	end
	
	if isElement(self.m_Dune) then
		destroyElement(self.m_Dune)
	end
	
	moveObject(self.m_StartGate, 3000, 161.3, -20, 0.6, 0, 0, 0)
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:AfterPhase2()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
	end
end

function HanfTransport:Phase2()
	self:sendFactionSlideMessage({"Phase 2 wurde gestartet!", "Fahren sie zum roten Marker"}, HanfTransport.CHAT_FACTION_EVIL, 500)
	
	setElementFrozen(self.m_Dune, false)
	setVehicleLocked(self.m_Dune, false)
	
	self.m_EndMarker = createMarker(2811.31, 897.86, 9.76, "cylinder", 2.5, 125, 0, 0, 125, root)
	self.m_EndBlip = createBlip(2811.31, 897.86, 9.76, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_EndBlip, HanfTransport.CHAT_FACTION_EVIL)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_Dune == hitElement and matchingDimension then
				self:nextPhase()
			end
		end
	)
end

function HanfTransport:FailPhase3(forceFail)
	self:sendFactionMessage("Der Hanftransport scheiterte\n in der dritten Phase!", HanfTransport.CHAT_FACTION_GOOD)
	-- Let to police do the rest of the mission
	if not forceFail then
		self:forcePhase(100)
	end
		
	if isElement(self.m_Dune) then
		destroyElement(self.m_Dune)
	end
	
	moveObject(self.m_StartGate, 3000, 161.3, -20, 0.6, 0, 0, 0)	
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:AfterPhase3()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
	end
	for key, element in ipairs ( self.m_Crates ) do
		if isElement(element) then
			destroyElement(element)
			if element.Carrier then
				element.Carrier.CarryingHanfCrate = nil
			end
		end
	end
	
	removeEventHandler("onPlayerClick", root, self.m_ClickHandler)
	removeEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	removeEventHandler("onPlayerWasted", root, self.m_WastedHandler)	
end

function HanfTransport:Phase3()
	self:sendFactionAlertMessage("Aktivitäten beim Hanflieferanten!", HanfTransport.CHAT_FACTION_GOOD)
	self:sendFactionSlideMessage({"Fahren Sie zu der Ballasgarage\nin Los Santos!", "Optional:\n Versuchen Sie den Dune abzufangen"}, HanfTransport.CHAT_FACTION_GOOD, 500)
	self:sendFactionSlideMessage({"Phase 3 wurde gestartet!", "Laden sie die Kisten auf!"}, HanfTransport.CHAT_FACTION_EVIL, 500)

	setElementFrozen(self.m_Dune, true)
	setVehicleLocked(self.m_Dune, true)	
	
	self.m_Crates = {}
	self.m_CrateCount = 0
 
	self.m_EndMarker = createMarker(0, 0, 0, "corona", 2, 0, 125, 0, 125, root)
	attachElements(self.m_EndMarker, self.m_Dune, 0, -4, 0)
	
	for key, value in ipairs ( HanfTransport.CRATES_POS_SECOND ) do
		self.m_Crates[key] = createObject(1558, value[1], value[2], value[3], value[4], value[5], value[6])
		self.m_Crates[key].IsHanfCrate = true
	end
	
	-- Todo: add, when job's done
	triggerClientEvent(root, "setObjectsUnbreakable", root, self.m_Crates)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function(hitElement, matchingDimension)
			if getElementType(hitElement) == "player" and hitElement.CarryingHanfCrate then
				destroyElement(hitElement.CarryingHanfCrate)
				hitElement.CarryingHanfCrate = nil
				self.m_CrateCount = self.m_CrateCount + 1
				if self.m_CrateCount >= #HanfTransport.CRATES_POS_SECOND then
					self:nextPhase()
				end
			end
		end
	)
	
	-- Use the old functions from Phase 1
	addEventHandler("onPlayerClick", root, self.m_ClickHandler)
	addEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	addEventHandler("onPlayerWasted", root, self.m_WastedHandler)
end

function HanfTransport:FailPhase4(forceFail)
	self:sendFactionMessage("Der Hanftransport scheiterte\n in der vierten Phase!", HanfTransport.CHAT_FACTION_GOOD)
	-- Let to police do the rest of the mission
	if not forceFail then
		self:forcePhase(100)
	end
		
	if isElement(self.m_Dune) then
		destroyElement(self.m_Dune)
	end
	
	moveObject(self.m_StartGate, 3000, 161.3, -20, 0.6, 0, 0, 0)
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end	
end

function HanfTransport:AfterPhase4()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
	end
	
	moveObject(self.m_StartGate, 3000, 161.3, -20, 0.6, 0, 0, 0)
end

function HanfTransport:Phase4()
	self:sendFactionSlideMessage({"Phase 4 wurde gestartet!", "Fahren sie nun nach LS!"}, HanfTransport.CHAT_FACTION_EVIL, 500)
	
	setElementFrozen(self.m_Dune, false)
	setVehicleLocked(self.m_Dune, false)		
	
	self.m_EndMarker = createMarker(2741.29, -2008.88, 12.55, "cylinder", 3, 125, 0, 0, 125, root)
	self.m_EndBlip = createBlip(2741.29, -2008.88, 12.55, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_EndBlip, HanfTransport.CHAT_FACTION_EVIL)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_Dune == hitElement and matchingDimension and getVehicleOccupants(self.m_Dune)[0] then
				self:nextPhase()
			end
		end
	)
end


--[[
## ########################
##	Police
##	Section
## ########################
]]

function HanfTransport:FailPhase100()
	if isElement(self.m_PoliceCar) then
		destroyElement(self.m_PoliceCar)
	end
	if isElement(self.m_LastBox) then
		destroyElement(self.m_LastBox)
	end
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:AfterPhase100()
	if self.m_CrateMarker then
		destroyElement(self.m_CrateMarker)
		destroyElement(self.m_CrateBlip)
		destroyElement(self.m_PoliceCarBlip)
	end
end

function HanfTransport:Phase100()
	self.m_PoliceCar = createVehicle(609, 1599.68, -1609.78, 13.46, 0.00, 0.00, 134.79)
	self.m_PoliceCarBlip = createBlip(0,0,0, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_PoliceCarBlip, HanfTransport.CHAT_FACTION_GOOD)
	attachElements(self.m_PoliceCarBlip, self.m_PoliceCar)
	
	local x,y,z = getElementPosition(self.m_Dune)
	self.m_LastBox = createObject(1558, x,y,z - 0.3)
	setElementFrozen(self.m_LastBox, true)
	self.m_LastBox.IsHanfCrate = true
	self:sendFactionSlideMessage({"Holen sie das Polizeifahrzeug!", "Dieses befindet sich in der LS-Base!"}, HanfTransport.CHAT_FACTION_GOOD, 500)
	triggerClientEvent(root, "setObjectsUnbreakable", root, {self.m_LastBox})

	self.m_CrateMarker = createMarker(x,y,z - 1,"cylinder", 6, 125, 0, 0, 50, root)
	self.m_CrateBlip = createBlip(x,y,z - 1, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_CrateBlip, HanfTransport.CHAT_FACTION_GOOD)
	
	addEventHandler("onMarkerHit", self.m_CrateMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_PoliceCar == hitElement and matchingDimension then
				self:nextPhase()
			end
		end
	)	
	
	addEventHandler("onVehicleExplode", self.m_PoliceCar, bind(self.failCurrentPhase, self))
	
	
	-- Die Mission wird automatisch gefailt, wenn der Dune noch in der Garage steht.
	if (self.m_LastBox.position - Vector3(157.78, -21.41, 2.23)).length < 10 then
		self:sendFactionMessage("Die Kiste war an einem unerreichbarem Ort!", HanfTransport.CHAT_FACTION_GOOD)
		self:failCurrentPhase()
	end
end

function HanfTransport:FailPhase101()
	if isElement(self.m_PoliceCar) then
		destroyElement()
	end
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:AfterPhase101()
	if isElement(self.m_LastBox) then
		destroyElement(self.m_LastBox)
	end	
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
	end		
	
	if self.m_LastBox.carrier then
		hitElement.CarryingHanfCrate = nil
	end
	
	removeEventHandler("onPlayerClick", root, self.m_PoliceClickHandler)
	removeEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	removeEventHandler("onPlayerWasted", root, self.m_WastedHandler)
end

function HanfTransport:Phase101()
	
	self.m_EndMarker = createMarker(0, 0, 0, "corona", 2, 0, 125, 0, 125, root)
	attachElements(self.m_EndMarker, self.m_PoliceCar, 0, -4, 0)
	
	self:sendFactionSlideMessage({"Laden Sie die Kiste per Mausklick\nin das Fahrzeug ein!"}, HanfTransport.CHAT_FACTION_GOOD, 500)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function(hitElement, matchingDimension)
			if getElementType(hitElement) == "player" and hitElement.CarryingHanfCrate then
				hitElement.CarryingHanfCrate = nil
				self:nextPhase()
			end
		end
	)	
	
	self.m_PoliceClickHandler = function (button,state,element)
		if button == "left" and state == "up" and element and element.IsHanfCrate and not element.Carrier and not source.CarryingHanfCrate and not getPedOccupiedVehicle(source) then
			if (element.position - source.position).length < 4 then
				if HanfTransport.ALLOWED_FACTIONS_GOOD[getElementData(source, "Fraktion")] then
					source.CarryingHanfCrate = element
					element.Carrier = source
					attachElements(element, source, 0, 1, 0)
				else
					outputChatBox("Du bist in keiner Staatsfraktion!", source, 125, 0, 0)
				end
			else
				outputChatBox("Sie sind zu weit von der Kiste entfernt!", source, 125, 0, 0)
			end
		end
	end	
	
	addEventHandler("onPlayerClick", root, self.m_PoliceClickHandler)
	addEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	addEventHandler("onPlayerWasted", root, self.m_WastedHandler)	
end

function HanfTransport:FailPhase102()
	if isElement(self.m_PoliceCar) then
		destroyElement(self.m_PoliceCar)
	end
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:AfterPhase102()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
		destroyElement(self.m_BallasMarker)
		destroyElement(self.m_BallasBlip)
	end
end

function HanfTransport:Phase102()
	self.m_EndMarker = createMarker(2198.04, -2032.02, 12.55,"cylinder", 4, 125, 0, 0, 50, root)
	self.m_EndBlip = createBlip(2198.04, -2032.02, 12.55, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_EndBlip, HanfTransport.CHAT_FACTION_GOOD)
	
	self.m_BallasMarker = createMarker(1086.72, -320.22, 72.99,"cylinder", 4, 125, 0, 0, 50, root)
	self.m_BallasBlip = createBlip(1086.72, -320.22, 72.99, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_BallasBlip, HanfTransport.CHAT_FACTION_EVIL)
	
	self:sendFactionSlideMessage("Entsorgen sie das Twizzla\nauf der Müllhalde in LS!", HanfTransport.CHAT_FACTION_GOOD, 500)
	self:sendFactionSlideMessage("Versuche das Fahrzeug zu klauen,\num die Reste zu erhalten!", HanfTransport.CHAT_FACTION_EVIL, 500)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_PoliceCar == hitElement and matchingDimension and getVehicleOccupants(hitElement)[0] then
				self:deleteCurrentPhase()
				self:Alternative_Reward_Good()
			end
		end
	)	

	addEventHandler("onMarkerHit", self.m_BallasMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_PoliceCar == hitElement and matchingDimension and getVehicleOccupants(hitElement)[0] then
				self:deleteCurrentPhase()
				self:Alternative_Reward_Evil()
			end
		end
	)	
	
		
end

function HanfTransport:Alternative_Reward_Good()
	self:sendFactionAlertMessage("Der Hanftransport wurde\n erfolgreich zerschlagen!", HanfTransport.CHAT_FACTION_GOOD)
	self:sendFactionSlideMessage("12.500 € - Fraktionskasse", HanfTransport.CHAT_FACTION_GOOD, 500)
	for key, value in ipairs(HanfTransport.CHAT_FACTION_GOOD) do
		-- fraktionskassen[value] = fraktionskassen[value] + 12500
	end
	if isElement(self.m_PoliceCar) then
		destroyElement(self.m_PoliceCar)
	end
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:Alternative_Reward_Evil()
	self:sendFactionAlertMessage("Sie haben das restliche Hanf erhalten!", HanfTransport.CHAT_FACTION_EVIL)
	--inventarAddItem(getVehicleOccupants(self.m_PoliceCar)[0],"Hanfsamen",25)
	itemmanager:addItem(62, 250, factionboxmanager:getFactionBoxes(10)[1].Storage[5])
	if isElement(self.m_PoliceCar) then
		destroyElement(self.m_PoliceCar)
	end
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end

function HanfTransport:FinalReward()
	self:sendFactionAlertMessage("Der Hanftransport wurde\n erfolgreich beendet!", { 1, 2, 3 })
	self:sendFactionMessage("Ihre Fraktion hat 500 Hanf erhalten!", HanfTransport.CHAT_FACTION_EVIL)
	--inventarAddItem(getVehicleOccupants(self.m_Dune)[0],"Hanfsamen", 50)
	itemmanager:addItem(62, 500, factionboxmanager:getFactionBoxes(10)[1].Storage[5])
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value, "Fraktion") == 11 then
		--	questsys:updateConditionForPlayer(value, "ht_deliv", 1)
		end
	end
	if isElement(self.m_Dune) then
		destroyElement(self.m_Dune)
	end	
	if isTimer(killTimer) then
		killTimer(self.m_ResetTimer)
	end
end