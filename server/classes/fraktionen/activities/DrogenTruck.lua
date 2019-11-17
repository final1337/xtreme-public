Drogentruck = inherit(ActivityBase)
inherit(Singleton, Drogentruck)

addEvent("DT:requestStart", true)

Drogentruck.MAX_TIME_FOR_ACTION = 1000*60*20
Drogentruck.MAX_TIME_FOR_ACTION_IN_SECONDS = Drogentruck.MAX_TIME_FOR_ACTION/1000

Drogentruck.ALLOWED_FACTIONS_GOOD = {
	[1] = true,
	[2] = true,
	[3] = true,
}

Drogentruck.CHAT_FACTION_GOOD = {}

for key, value in pairs ( Drogentruck.ALLOWED_FACTIONS_GOOD ) do table.insert(Drogentruck.CHAT_FACTION_GOOD, key) end

Drogentruck.ALLOWED_FACTIONS_EVIL = {
	[11] = true,
	[5] = true,
	[10] = true,
	[6] = true,
	[7] = true,
	[8] = true,
}

Drogentruck.PHASE2_MARKER_POSITIONS = {
{1606.61, 731.38, 10.82},
{1605.33, 709.73, 10.82},
{1663.05, 731.61, 10.82},
{1664.01, 710.73, 10.82},
}

Drogentruck.PHASE5_CAR_POSTIONS = {
{-2484.41, 58.68, 26.10, 0.00, 0.00, 173.61},
{-2751.88, 97.49, 7.03, 0.00, 0.00, 239.47},
{-2286.42, -9.88, 35.32, 0.00, 0.00, 0.95},
{-2316.76, -147.9, 35.32, 0.00, 0.00, 177.81},
}

Drogentruck.PHASE6_FINAL_MARKER = {
[4] = {-2104.22, -90.53, 34.33},            -- RIFA
[5] = {-2622.00, 1363.33, 6.07},			-- DNB
[6] ={-2714.15, -296.90, 6.04},				-- MAFIA
[8] ={-86.77, 1358.20, 9.31},			    -- NORDIC ANGELS
}

Drogentruck.CHAT_FACTION_EVIL = {}

for key, value in pairs ( Drogentruck.ALLOWED_FACTIONS_EVIL ) do table.insert(Drogentruck.CHAT_FACTION_EVIL, key) end

function Drogentruck:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	
	self.m_CurrentGang = 0
	self.m_CurrentDepotAmount = 50000
	setGarageOpen(30, true)
	
	self.m_StartMarker = createMarker ( 1709.7159423828, 701.49212646484, 9.8203125, "cylinder", 2, 0, 0, 255 )
	
	addEventHandler("onMarkerHit", self.m_StartMarker,
		function(player, matchingDimension)
			if matchingDimension and getElementType(player) == "player" then
				if Drogentruck.ALLOWED_FACTIONS_EVIL[getElementData(player,"Fraktion")] then
					if getElementType(player) == "player" and getRealTime()["timestamp"] >= self.m_LastStart + Drogentruck.MAX_TIME_FOR_ACTION_IN_SECONDS then
						triggerClientEvent(player,"DT:openGUI",player, self.m_CurrentDepotAmount, 3000)
					else
						outputChatBox("Derzeit ist es noch nicht möglich den Drogentruck zu starten!", player, 125, 0, 0)
					end
				else
					outputChatBox("Ihre Fraktion kann keinen Drogentruck starten.", player, 125, 0, 0)
				end
			end
		end
	)	
	
	
	addEventHandler("DT:requestStart", root, bind(self.onRequestStart, self))
end

function Drogentruck:getDrugAmount()
	return self.m_CurrentDepotAmount
end

function Drogentruck:setDrugAmount(amount)
	self.m_CurrentDepotAmount = amount
end

function Drogentruck:onRequestStart(drugs)
	if drugs and tonumber(drugs) and math.abs(drugs) >= 0 and math.abs(drugs) <= 95000 then
		if self.m_CurrentDepotAmount >= drugs then
			self.m_CurrentDepotAmount = self.m_CurrentDepotAmount - drugs
			--local cash = getPlayerData("fraktionskasse","Fraktion",getElementData(client,"Fraktion"),"Betrag");
			--dbExec(handler,"UPDATE fraktionskasse SET Betrag = '"..cash-math.abs(math.floor(drugs).."' WHERE Fraktion = '"..getElementData(client,"Fraktion").."'");
			self.m_CurrentGang = getElementData(client,"Fraktion")
			self.m_TransportingDrugs = drugs
			self:initActivity()
		end
	end
end

function Drogentruck:FailPhase1()
	if isElement(self.m_SelectCar1) then
		destroyElement(self.m_SelectCar1)
	end
	if isElement(self.m_SelectCar2) then
		destroyElement(self.m_SelectCar2)
	end
	
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end	
	self:RewardGood()
	self:sendFactionMessage("Der Drogentruck scheiterte in der 1. Phase", Drogentruck.CHAT_FACTION_GOOD)
end

function Drogentruck:Phase1()
	self:sendFactionSlideMessage({"Suchen Sie sich ein Fahrzeug aus!","Flatbad = Mehr Leben, langsamer","Boxville = Weniger Leben, schneller"}, { self.m_CurrentGang }, 500, 3000)
	self:sendFactionAlertMessage("Unsere Fraktion startet\n einen Drogentransport!", { self.m_CurrentGang })
	
	self.m_SelectCar1 = createVehicle(455, 1724.48, 727.72, 10.82, 0.00, 0.00, 90.09)
	self.m_SelectCar2 = createVehicle( 609, 1724.94, 711.61, 10.82, 0.00, 0.00, 84.94)

	setElementHealth(self.m_SelectCar1, 2000)
	setVehicleHandling(self.m_SelectCar1, "maxVelocity", 50)	
	
	setElementHealth(self.m_SelectCar2, 1000)
	setVehicleHandling(self.m_SelectCar2, "maxVelocity", 110)
	
	addEventHandler("onVehicleExplode", self.m_SelectCar1, bind(self.failCurrentPhase, self))
	addEventHandler("onVehicleExplode", self.m_SelectCar2, bind(self.failCurrentPhase, self))
	
	self.m_EnterFunction = function(player, seat)
		if Drogentruck.ALLOWED_FACTIONS_EVIL[getElementData(player,"Fraktion")] and seat == 0 then
			if source == self.m_SelectCar1 then
				destroyElement(self.m_SelectCar2)
			else
				destroyElement(self.m_SelectCar1)
			end
			self:nextPhase()
		end
	end
	
	addEventHandler("onVehicleEnter",  self.m_SelectCar1, self.m_EnterFunction)
	addEventHandler("onVehicleEnter",  self.m_SelectCar2, self.m_EnterFunction)
	
	-- Add a reset timer
	self.m_ResetTimer = setTimer( function () self:failCurrentPhase(true) end, Drogentruck.MAX_TIME_FOR_ACTION, 1 )

end

function Drogentruck:FailPhase2()
	if isElement(self.m_EventCar) then
		destroyElement(self.m_EventCar)
	end
	
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end
	self:RewardGood()
	self:sendFactionMessage("Der Drogentruck scheiterte in der 2. Phase", Drogentruck.CHAT_FACTION_GOOD)
end

function Drogentruck:AfterPhase2()
	for key, value in ipairs(self.m_EventCrateMarker) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	for key, value in ipairs(self.m_Crates) do
		if isElement(value) then
			destroyElement(value)
			if value.Carrier then
				value.Carrier.CarryingHanfCrate = nil
			end			
		end
	end
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
	end

	removeEventHandler("onPlayerClick", root, self.m_ClickHandler)
	removeEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	removeEventHandler("onPlayerWasted", root, self.m_WastedHandler)		
end

function Drogentruck:Phase2()
	self:sendFactionMessage("Unsere Fraktion erreichte Phase 2!", { self.m_CurrentGang })
	self:sendFactionSlideMessage({"Laden Sie nun die Kisten auf!","Diese befinden sich in den roten Markern!"}, { self.m_CurrentGang }, 500)
	
	self.m_EventCar = isElement(self.m_SelectCar1) and self.m_SelectCar1 or self.m_SelectCar2
	removeEventHandler("onVehicleEnter", self.m_EventCar, self.m_EnterFunction)
	
	self.m_EventCrateMarker = {}
	self.m_Crates = {}
	self.m_EndMarker = createMarker(0,0,0, "corona", 2, 0, 125, 0, 125, root)
	
	attachElements(self.m_EndMarker, self.m_EventCar, 0, -5, 0)
	
	for key, value in ipairs(Drogentruck.PHASE2_MARKER_POSITIONS) do
		self.m_EventCrateMarker[key] = createMarker(value[1], value[2], value[3] - 1, "cylinder", 3, 125, 0, 0, 25)
	end
	
	local tonAmount = math.ceil(self.m_TransportingDrugs/1000)
	
	local cC = 1
	
	for section = 1, math.min(4, math.ceil(tonAmount/4)) do
		local x,y,z = getElementPosition(self.m_EventCrateMarker[section])
		for i = 0, 3, 1 do
			self.m_Crates[cC] = createObject(1558, x + i - (math.floor((i/2))*2),y + math.random(-2,2)/10,z + 0.7 + math.floor((i/2)))
			setElementFrozen(self.m_Crates[cC], true)
			self.m_Crates[cC].IsHanfCrate = true
			cC = cC + 1
		end
	end
	
	self.m_CrateMaxCount = #self.m_Crates
	self.m_CrateCount = 0
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function(hitElement, matchingDimension)
			if getElementType(hitElement) == "player" and hitElement.CarryingHanfCrate then
				destroyElement(hitElement.CarryingHanfCrate)
				hitElement.CarryingHanfCrate = nil
				self.m_CrateCount = self.m_CrateCount + 1
				if self.m_CrateCount >= self.m_CrateMaxCount then
					self:nextPhase()
				end
			end
		end
	)	
	
	
	
	triggerClientEvent(root, "setObjectsUnbreakable", root, self.m_Crates)
	
	self.m_ClickHandler = function (button,state,element)
		if button == "left" and state == "up" and element and element.IsHanfCrate and not element.Carrier and not source.CarryingHanfCrate and not getPedOccupiedVehicle(source) then
			if (element.position - source.position).length < 4 then
				if Drogentruck.ALLOWED_FACTIONS_EVIL[getElementData(source, "Fraktion")] then
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
	
end

function Drogentruck:FailPhase3()
	if self.m_Beagle then
		destroyElement(self.m_Beagle)
	end
	if self.m_EventChar then
		destroyElement(self.m_EventCar)
	end
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end	
	self:RewardGood()
	self:sendFactionMessage("Der Drogentruck scheiterte in der 3. Phase", Drogentruck.CHAT_FACTION_GOOD)
end

function Drogentruck:AfterPhase3()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
	end
end

function Drogentruck:Phase3()
	self:sendFactionAlertMessage("Aktivitäten am Drogendepot!", Drogentruck.CHAT_FACTION_GOOD)
	self:sendFactionMessage("Unsere Fraktion erreichte Phase 3!", { self.m_CurrentGang })
	self:sendFactionSlideMessage({"Die Polizei wurde alarmiert!","Fahren Sie nun zum LV Flughafen!"}, { self.m_CurrentGang }, 500)
	
	self.m_Beagle = createVehicle(511, 1578.37, 1172.06, 12.19, 0.51, 0.00, 358.82)
	setElementFrozen(self.m_Beagle, true)
	
	self.m_EndMarker = createMarker(1606.71, 1171.37, 13.22, "cylinder", 3, 125, 0, 0, 125)
	self.m_EndBlip = createBlip(1606.71, 1171.37, 13.22, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_EndBlip, Drogentruck.CHAT_FACTION_EVIL)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_EventCar == hitElement and matchingDimension and getVehicleOccupants(hitElement)[0] then
				self:nextPhase()
			end
		end
	)	
	
	addEventHandler("onVehicleExplode", self.m_Beagle, bind(self.failCurrentPhase, self))
end

function Drogentruck:FailPhase4()
	if self.m_Beagle then
		destroyElement(self.m_Beagle)
	end
	for key, value in ipairs(self.m_Crates) do
		if isElement(value) then
			destroyElement(value)
			if value.Carrier then
				value.Carrier.CarryingHanfCrate = nil
			end			
		end		
	end
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end	
	self:RewardGood()
	self:sendFactionMessage("Der Drogentruck scheiterte in der 4. Phase", Drogentruck.CHAT_FACTION_GOOD)
end

function Drogentruck:AfterPhase4()
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
	end
	if self.m_EventCar then
		destroyElement(self.m_EventCar)
	end	
	removeEventHandler("onPlayerClick", root, self.m_ClickHandler)
	removeEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	removeEventHandler("onPlayerWasted", root, self.m_WastedHandler)	
end

function Drogentruck:Phase4()
	self:sendFactionMessage("Unsere Fraktion erreichte Phase 4!", { self.m_CurrentGang })
	self:sendFactionSlideMessage({"Laden Sie die Kisten ins Flugzeug!"}, { self.m_CurrentGang }, 500)
	
	self.m_EndMarker = createMarker(1590.46, 1170.60, 14.22, "corona", 2, 0, 125, 0, 125, root)
	
	self.m_Crates = {}
	self.m_CrateCount = 0
	
	for i = 0, self.m_CrateMaxCount - 1, 1 do
		self.m_Crates[i+1] = createObject(1558, 1605.38135 + i - (math.floor((i/7))*7),1177.31873 + math.random(-2,2)/10,13.22041 + 0.7 + math.floor((i/7)))
		self.m_Crates[i+1].IsHanfCrate = true
	end

	addEventHandler("onMarkerHit", self.m_EndMarker,
		function(hitElement, matchingDimension)
			if getElementType(hitElement) == "player" and hitElement.CarryingHanfCrate then
				destroyElement(hitElement.CarryingHanfCrate)
				hitElement.CarryingHanfCrate = nil
				self.m_CrateCount = self.m_CrateCount + 1
				if self.m_CrateCount >= self.m_CrateMaxCount then
					self:nextPhase()
				end
			end
		end
	)	
	
	triggerClientEvent(root, "setObjectsUnbreakable", root, self.m_Crates)
	
	addEventHandler("onPlayerClick", root, self.m_ClickHandler)
	addEventHandler("onPlayerQuit",  root, self.m_QuitHandler)
	addEventHandler("onPlayerWasted", root, self.m_WastedHandler)	
end

function Drogentruck:FailPhase5()
	if isElement(self.m_Flatbed) then
		destroyElement(self.m_Flatbed)
	end	
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end	
	self:sendFactionMessage("Der Drogentruck scheiterte in der 5. Phase", Drogentruck.CHAT_FACTION_GOOD)
end

function Drogentruck:AfterPhase5()
	if self.m_EndMarker then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
		destroyElement(self.m_FlatbedBlip)
	end
	if isElement(self.m_Beagle) then
		destroyElement(self.m_Beagle)
	end	
	self:RewardGood()
end

function Drogentruck:Phase5()
	self:sendFactionMessage("Unsere Fraktion erreichte Phase 5!", { self.m_CurrentGang })
	self:sendFactionSlideMessage({"Fliegen Sie mit dem Flugzeug\n in den Marker vom Flatbed!","Sprechen Sie die Landeposition\nmit ihren Fraktionsmitgliedern ab!"}, { self.m_CurrentGang }, 500)
	
	setElementFrozen(self.m_Beagle, false)
		
	self.m_EndMarker = createMarker(0,0,0, "corona", 3, 0, 125, 0, 125, root)
	self.m_EndBlip = createBlip(0,0,0, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	attachElements(self.m_EndMarker, self.m_Beagle, 0, -12, 0)
	attachElements(self.m_EndBlip, self.m_Beagle, 0, 0, 0)
	self:sendElementFactionVisibleTo(self.m_EndBlip, { self.m_CurrentGang } )
		
	local x, y, z, rx, ry, rz = unpack(Drogentruck.PHASE5_CAR_POSTIONS[math.random(1, #Drogentruck.PHASE5_CAR_POSTIONS)])
	self.m_Flatbed = createVehicle(455, x, y, z, rx, ry, rz)
	self.m_FlatbedBlip = createBlip(0,0,0, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	attachElements(self.m_FlatbedBlip, self.m_Flatbed)
	self:sendElementFactionVisibleTo(self.m_FlatbedBlip, { self.m_CurrentGang })
	
	addEventHandler("onVehicleStartEnter", self.m_Flatbed,
		function(player, seat)
			if seat == 0 and getElementData(player,"Fraktion") ~= self.m_CurrentGang then
				cancelEvent()
			end
		end
	)
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_Flatbed == hitElement and matchingDimension and getVehicleOccupants(hitElement)[0] then
			-- Save the beagle coordinates for the pcj-spawn later
				self.m_BeaglePosition, self.m_BeagleRotation = self.m_Beagle.position, self.m_Beagle.rotation
			--			
				self:nextPhase()
			end
		end
	)			
	
	addEventHandler("onVehicleExplode", self.m_Flatbed, bind(self.failCurrentPhase, self))
end


function Drogentruck:FailPhase6()
	if self.m_Flatbed then
		destroyElement(self.m_Flatbed)
	end
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end	
	self:sendFactionMessage("Der Drogentruck scheiterte in der 6. Phase", Drogentruck.CHAT_FACTION_GOOD)
	self:RewardGood()
end


function Drogentruck:AfterPhase6()
	if isElement(self.m_PCJ) then
		destroyElement(self.m_PCJ)
	end
	
	if isElement(self.m_EndMarker) then
		destroyElement(self.m_EndMarker)
		destroyElement(self.m_EndBlip)
	end
end

function Drogentruck:Phase6()
	self:sendFactionSlideMessage({"Fahren Sie nun sicher in ihre Basis!"}, { self.m_CurrentGang }, 500)
	self:sendFactionAlertMessage("Laut Informanten,\n befindet sich die Ladung nun\n wieder sicher auf dem Boden!", Drogentruck.CHAT_FACTION_GOOD)
	self.m_PCJ = createVehicle(461, self.m_BeaglePosition, self.m_BeagleRotation)

	local x,y,z = unpack(Drogentruck.PHASE6_FINAL_MARKER[self.m_CurrentGang])
	
	self.m_EndMarker = createMarker(x, y, z, "cylinder", 3, 125, 0, 0, 125)
	self.m_EndBlip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 99999, root)
	self:sendElementFactionVisibleTo(self.m_EndMarker, { self.m_CurrentGang })
	self:sendElementFactionVisibleTo(self.m_EndBlip, { self.m_CurrentGang })
	
	addEventHandler("onMarkerHit", self.m_EndMarker,
		function ( hitElement, matchingDimension ) 
			if hitElement and self.m_Flatbed == hitElement and matchingDimension and getVehicleOccupants(hitElement)[0] then
				self:nextPhase()
			end
		end
	)		

end

function Drogentruck:RewardGood()
	for key, value in ipairs(getElementsByType("player")) do
		if Drogentruck.ALLOWED_FACTIONS_GOOD[getElementData(value,"Fraktion")] then
			--questsys:updateConditionForPlayer(value, "dt_fail", 1)
		end
	end
end

function Drogentruck:FinalReward()
	self:sendFactionAlertMessage("Der Drogentruck wurde\n erfolgreich beendet!", Drogentruck.CHAT_FACTION_EVIL)
	self:sendFactionAlertMessage("Der Drogentruck wurde\n erfolgreich beendet!", Drogentruck.CHAT_FACTION_GOOD)
	
	local driver = getVehicleOccupants(self.m_Flatbed)[0]

	--local cash = getPlayerData("fraktionskasse","Fraktion",getElementData(driver,"Fraktion"),"Betrag");
	--dbExec(handler,"UPDATE fraktionskasse SET Betrag = '"..cash+math.floor(self.m_TransportingDrugs*2).."' WHERE Fraktion = '"..getElementData(driver,"Fraktion").."'");	

	if isElement(self.m_Flatbed) then
		destroyElement(self.m_Flatbed)
	end
	
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value, "Fraktion") == self.m_CurrentGang then
		--	questsys:updateConditionForPlayer(value, "dt_deliv", 1)
		end
	end
	
	
	
	if math.random(1,20) == 3 then
	--	outputChatBox("Du hast in einer der Kisten noch eine M4 entdeckt und erhalten!", driver, 0, 125, 0)
	--	inventarAddItem(driver,"M4", 500)
	end
	if isTimer(self.m_ResetTimer) then
		destroyElement(self.m_ResetTimer)
	end	
end