PilotJob = inherit(Singleton)

DEV = true

-- Constants

PilotJob.ReturnPoint   = Vector3(-1423.02734375,-292.1396484375,14.1484375)
PilotJob.MainDimension = 0
PilotJob.LeavePanalty = 150

function PilotJob:constructor()
	self.m_Vehicles = {}
	self.m_Marker   = {}
	self.m_UsedDimension = {}
		
	--self.m_StartPickup = marker:create({x = -1422.0582275391, y = -286.94720458984, z = 14.1484375, typ = "jobs"})
	--self.m_StartPickup = createMarker( -1422.05822, -286.947, 14.148, "cylinder", 1.2)
		
	addEvent("xtr:pilot:start", true)
	addEventHandler("xtr:pilot:start", root, bind(self.startJob, self))
	
	addEvent("xtr:pilot:openWindow", true)
	addEventHandler("xtr:pilot:openWindow", root, bind(self.openJobWindow,self))
	
	-- Ziele erstellen
	self:loadMissions()
	
	--addEventHandler("onMarkerHit", self.m_StartPickup, bind(self.checkRequirements,self))
	addEventHandler("onPlayerWasted", root, function() self:onMissionFail(source,false) end)
	addEventHandler("onPlayerQuit",   root, function() self:onMissionFail(source,false) end)
	addEventHandler("onVehicleExit",  root, function(player) self:onMissionFail(player,true) end)
	
end

function PilotJob:onMissionFail(player,portBack)
	if not getElementData(player,"xtr:pilot:mission") then return end
	if portBack and tonumber(getElementData(player,"Bankgeld")) >= 150 then 
		setElementData(player,"Bankgeld",tonumber(getElementData(player,"Bankgeld"))-PilotJob.LeavePanalty)
		player:sendMessage("Mission abgebrochen € - "..PilotJob.LeavePanalty, 255,255,0)
	end
	setElementData(player,"xtr:pilot:mission",nil)
	self.m_UsedDimension[getElementData(player,"xtr:pilot:dimension")] = nil
	self:deleteJobElements(getPlayerName(player))
	
	setElementDimension(player,PilotJob.MainDimension)
	triggerClientEvent(player,"xtr:pilot:stopJob",player)
	
	if portBack then setElementPosition(player,PilotJob.ReturnPoint) end
end

function PilotJob:loadMissions()
	local x,y,z,tempMarker
	
	for kind, mission in pairs(PilotJob.AirPortMissions) do
		for missionId, missionInfo in ipairs(mission) do
			self.m_Marker[kind] = self.m_Marker[kind] ~= nil and self.m_Marker[kind] or {}
			x,y,z = unpack(missionInfo[2])
			self.m_Marker[kind][missionId] = createMarker(x,y,z, "cylinder", 15, 125, 0, 0, 0)	
			tempMarker = self.m_Marker[kind][missionId]
			setElementData(tempMarker,"xtr:pilot:kind",kind)
			setElementData(tempMarker,"xtr:pilot:mission",missionId)
			-- Rechne den Gewinn und die Level aus (- wenn nicht gegeben)
			if missionInfo[3] == 0 then missionInfo[3] =  math.floor((Vector3(x,y,z)-PilotJob.AverageSpawnPosition[kind]).length*PilotJob.Multiplicator[kind]) end
			if missionInfo[4] == 0 then missionInfo[4] =  math.floor((Vector3(x,y,z)-PilotJob.AverageSpawnPosition[kind]).length/1000) == 0 and 1 or math.floor((Vector3(x,y,z)-PilotJob.AverageSpawnPosition[kind]).length/750) end
			addEventHandler("onMarkerHit", tempMarker,
				function(hitElement,matchingDimension)
					if not isElement(hitElement) then return end -- Untedruecke Fehlermeldung, wenn der Spieler aus dem Flugzeug/Helikopter fliegt, sobald die Mission abgegeben wurde.
					if getElementType(hitElement) ~= "vehicle" then return end
					local player = getVehicleOccupant(hitElement,0) or nil
					if getVehicleType(hitElement) == getElementData(source,"xtr:pilot:kind") and getElementData(player,"xtr:pilot:mission") == getElementData(source,"xtr:pilot:mission") then
						self:finishMission(player,hitElement)
					end			
				end
			)
		end
	end	
end

function PilotJob:finishMission(player,vehicle)
	local kind = getVehicleType(vehicle)
	local mission = getElementData(player,"xtr:pilot:mission")
	
	if not PilotJob.AirPortMissions[kind][mission][5] then
		local velocity = (Vector3(getElementVelocity(vehicle)) * 180).length
		if velocity > 75 then return player:sendMessage("Sie sind zu schnell. Die maximale Geschwindigkeit betraegt 75km/h, ihre war: ".. math.floor(velocity), 200, 0, 0) end 
	end
	
	-- job_pilot_helicopter and job_pilot_plane
	--questsys:updateConditionForPlayer(player, "job_pilot_"..kind:lower(), 1)
	
	self.m_UsedDimension[getElementData(player,"xtr:pilot:dimension")] = nil
	setElementData(player,"xtr:pilot:mission",nil)
	player:sendMessage("Mission erfolgreich beendet € "..PilotJob.AirPortMissions[kind][mission][3], 255,255,0)
	setElementData(player,"Bankgeld",tonumber(getElementData(player,"Bankgeld"))+PilotJob.AirPortMissions[kind][mission][3])
	--levelup(player,15)
	--addxp(player,"xpJobPilot",30)
	triggerClientEvent(player,"xtr:pilot:stopJob",player)
	
	fadeCamera(player,false)
	
	setTimer(
	function()
		self:deleteJobElements(getPlayerName(player))
		setTimer(function()setElementPosition(player,PilotJob.ReturnPoint)
		setElementDimension(player,PilotJob.MainDimension) end,400,1)
		setTimer( fadeCamera, 750, 1, player, true)
	end, 1000, 1)
	
end

function PilotJob:getFreeDimension()
	for i = 512, 712, 1 do -- Max number of players is 200
		if not self.m_UsedDimension[i] then
			self.m_UsedDimension[i] = true
			return i
		end
	end
	return false
end

function PilotJob:openJobWindow()
	if not client then return end
	if not getElementData(client,"Job") == "Pilot" then return end
	triggerClientEvent(client,"xtr:pilot:openwindow", client, PilotJob.AirPortMissions, PilotJob.ValidAirCraftMissions)
end

function PilotJob:checkRequirements ( player, matchingDimension )
	if isElement(player) and getElementType(player) ~= "player" or isPedInVehicle(player) then return end
	
	if tonumber(getElementData(player,"FlugscheinPraxis")) == 1 or tonumber(getElementData(player,"HelikopterscheinPraxis")) == 1 then
		setElementData(player,"Job","Pilot");
		triggerClientEvent(player,"xtr:pilot:openwindow", player, PilotJob.AirPortMissions, PilotJob.ValidAirCraftMissions)
	else
		player:sendNotification("JOB_PILOT_VALID_LICENSE", 120, 0, 0)
	end
end

function PilotJob:startJob(kind,model,mission)
	if not client then
		return 
	end
	
	-- Securecheck
	if not PilotJob.AirPortMissions[kind][mission] then return outputDebugString(getPlayerName(client).." tries to start a non existing PilotJob-Mission") end
	
	local dimension = self:getFreeDimension()
	
	assert(type(dimension)=="number","Fehler beim Pilotenjob, mehr Dimensionen belegt als Slots verfuegbar.")
	
	-- Missionstext | Todo: Sprachen dynamisch machen.
	local message = PilotJob.Description[client:getData("Language")][getVehicleModelFromName(model)]:gsub("|ANZAHL|", math.random(3,6)):gsub("|STANDORT|",PilotJob.AirPortMissions[kind][mission][1]):gsub("|GELDMENGE|",PilotJob.AirPortMissions[kind][mission][3])
	client:sendMessage(message,255,255,0)
	
	-- Todo: Ersetze setElementData-Funktionen mit setData-Funktionen oder irgendwas aehnlichem.
	setElementData(client,"xtr:pilot:dimension",dimension)
	setElementData(client,"xtr:pilot:mission",mission)
	self:setupMission(client,kind,model,mission,dimension)
	
end

function PilotJob:setupMission(player,kind,model,mission,dimension)
	local nick = getPlayerName(player)
	local modelId = getVehicleModelFromName(model)
	
	fadeCamera(player,false)
	
	self.m_Vehicles[nick] = createVehicle(modelId,unpack(PilotJob.AirCraftSpawns[modelId]))
	setElementDimension(player,dimension)
	setElementDimension(self.m_Vehicles[nick],dimension)
	
	setTimer(
		function()
			warpPedIntoVehicle(player,self.m_Vehicles[nick])
			setTimer( fadeCamera, 750, 1, player, true)
		end, 1000, 1)
	-- Sende das Modell, die Art des Fahrzeugs und die Mission fuer die Wiederholung
	triggerClientEvent(player,"xtr:pilot:setupJob",player,PilotJob.AirPortMissions[kind][mission][2],dimension,kind,model,mission)
end

function PilotJob:deleteJobElements(playerName)
	if isElement(self.m_Vehicles[playerName]) then destroyElement(self.m_Vehicles[playerName]); self.m_Vehicles[playerName] = nil end
end

-- String Name, table[double] Position, int geld, int level_requirement, bool ignore_speed_limit
-- Solange geld und level_requirement auf 0 gesetzt sind, werden diese Werte automatisch berechnet.

PilotJob.AirPortMissions = {
	["Plane"] = 
	{
		[1]        = {"Las Venturas", 		{1477.798828125,1704.9658203125,10.8125}			,0,0},
		[2]        = {"Los Santos",			{1807.9248046875,-2593.599609375,13.226552009583}	,0,0},
		-- Hauptsaechlich Dodomissionen
		[3]        = {"Jump SF", 			{-1993.494140625,-22.99609375,154.95408630371}		,195,0,true},
		[4]        = {"Jump Bayside", 		{-2478.58984375,2336.1357421875,296.67065429688}	,0,0,true},
		[5]        = {"Jump Angelpine", 	{-2125.369140625,-2261.33984375,146.45555114746}	,0,0,true},
		[6]        = {"Jump Mitte",		 	{96.7685546875,-251.5625,124.51357269287}			,0,0,true},
		[7]        = {"Jump Staudamm", 	 	{-626.216796875,1966.396484375,156.18701171875}		,0,0,true},
		[8]        = {"Graveyard",		 	{406.00021, 2502.45898, 16.48438}	,0,0},
	},
	["Helicopter"] =
	{
		[1]  = {"Star Tower",		{1543.5830078125,-1353.4970703125,329.47375488281}		,0,0},
		[2]  = {"SF Carrier",		{-1263.98743, 458.52432, 6.59716}						,0,0},
		[3]  = {"SF Bank",			{-2062.8984375,448.2451171875,139.91917419434}			,0,0},
		[4]  = {"LS Airport",		{1768.7841796875,-2348.3759765625,23.83226776123}		,0,0},
		[5]  = {"LS Hafen",			{2593.6513671875,-2441.3251953125,13.800058364868}		,0,0},
		[6]  = {"LS Polizei",		{1566.818359375,-1650.392578125,28.576843261719}		,0,0},
		[7]  = {"LS General",		{2026.236328125,-1390.8623046875,48.513217926025}		,0,0},
		[8]  = {"LS City Centre",	{1085.0556640625,-1468.6162109375,30.095092773438}		,0,0},
		[9]  = {"LS Hospital",		{1159.8359375,-1373.48046875,26.793462753296}			,0,0},
		[10] = {"LS Studio",		{824.486328125,-1289.697265625,29.102657318115}			,0,0},
		[11] = {"LS Beach",			{399.6044921875,-1822.4033203125,14.906582832336}		,0,0},
		[12] = {"LS East",			{311.2001953125,-1513.2099609375,76.709197998047}		,0,0},
		[13] = {"LS Vinewood",		{491.3759765625,-1107.521484375,86.621910095215}		,0,0},
		[14] = {"LS Friedhof",		{816.15625,-1105.02734375,35.055988311768}				,0,0},
		[15] = {"LS Stadion",		{2671.74609375,-1686.2587890625,9.5532655715942}		,0,0},
	},
	["Automobile"] =
	{
		-- [1] = {"Gepaeck", 			{-1204.5654296875,-491.7939453125,13.773328781128}		,0,0},
	}
}

PilotJob.ValidAirCraftMissions = {

	["Plane"] =
	{
		[getVehicleModelFromName("Dodo")] = {[3]=true,[4]=true,[5]=true,[6]=true,[7]=true},
		[getVehicleModelFromName("Nevada")] = {[1]=true,[2]=true,[8]=true},
		[getVehicleModelFromName("Shamal")] = {[1]=true,[2]=true,[8]=true},
		[getVehicleModelFromName("Andromada")] = {[1]=true,[2]=true},
	},
	["Helicopter"] =
	{
		[getVehicleModelFromName("Cargobob")] = {[1]=true,[2]=true,[3]=true},
		[getVehicleModelFromName("Maverick")] = {[3]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[13]=true,[14]=true,[15]=true},
		[getVehicleModelFromName("Leviathan")] = {[1]=true,[2]=true,[4]=true,[5]=true},
	},
	["Automobile"] =
	{
		-- [getVehicleModelFromName("Baggage")] = {[1]=true},
	}
}

PilotJob.AirCraftSpawns = {
	-- Planes
	[getVehicleModelFromName("Dodo")]      = {-1342.7109375,107.0947265625,14.86897277832,0,0,45.846160888672},
	[getVehicleModelFromName("Nevada")]    = {-1658.548828125,-165.8671875,13.773582458496,0,0,316.35165405273},
	[getVehicleModelFromName("Shamal")]    = {-1658.548828125,-165.8671875,13.773582458496,0,0,316.35165405273},
	[getVehicleModelFromName("Andromada")] = {-1658.548828125,-165.8671875,13.773582458496,0,0,316.35165405273},
	--Helicopters
	[getVehicleModelFromName("Cargobob")]  = {-1454.2861328125,-620.587890625,19.1484375,0,0,326.57632446289},
	[getVehicleModelFromName("Maverick")]  = {-1365.9658203125,-294.9169921875,25.4375,0,0,346.39047241211},
	[getVehicleModelFromName("Leviathan")] = {-1454.2861328125,-620.587890625,14.1484375,0,0,326.57632446289},
	-- Automobiles
	[getVehicleModelFromName("Baggage")] = {0,0,10,0,0,0},
}

PilotJob.AverageSpawnPosition = { ["Helicopter"] = Vector3(-1365.9658203125,-294.9169921875,25.4375), ["Plane"] = Vector3(-1658.548828125,-165.8671875,13.773582458496), ["Automobile"] = Vector3(-1427.5703125,-293.2861328125,14) }
PilotJob.Multiplicator = { ["Helicopter"] = 0.8, ["Plane"] = 0.5, ["Automobile"] = 1.2 }

-- The description depents on the ModelId

PilotJob.Description = {
	["DE"] = 
	{
		[getVehicleModelFromName("Cargobob")] = "Liefern Sie die Waren nach |STANDORT|, dafuer werden Sie insgesamt € |GELDMENGE| erhalten.",
		[getVehicleModelFromName("Maverick")] = "Fliegen Sie fuer € |GELDMENGE| die |ANZAHL| Personen nach/zum |STANDORT|.",
		[getVehicleModelFromName("Leviathan")] = "Transportieren Sie |ANZAHL| Stahlbalken fuer € |GELDMENGE| nach |STANDORT|.",
		[getVehicleModelFromName("Dodo")] = "Bringen Sie die Fallschirmspringer zum |STANDORT|, diese werden Ihnen € |GELDMENGE| dafuer geben.",
		[getVehicleModelFromName("Nevada")] = "Eine Gang bietet ihnen € |GELDMENGE| an um diese nach |STANDORT| zu bringen.",
		[getVehicleModelFromName("Shamal")] = "Ein Boss bietet ihnen € |GELDMENGE| an um diesen nach |STANDORT| zu bringen.",
		[getVehicleModelFromName("Andromada")] = "Sie transportieren |ANZAHL|000kg an Waren zum |STANDORT| und erhalten dafuer € |GELDMENGE|.",
	},
	["EN"] =
	{
		[getVehicleModelFromName("Cargobob")] = "Deliver the goods to |STANDORT| for this you'll recive an amount of  € |GELDMENGE|.",
		[getVehicleModelFromName("Maverick")] = "Fly for € |GELDMENGE| |ANZAHL| persons to |STANDORT|.",
		[getVehicleModelFromName("Leviathan")] = "Transport the |ANZAHL| steel beams for € |GELDMENGE| to |STANDORT|.",
		[getVehicleModelFromName("Dodo")] = "Take the parachutists to |STANDORT|, they'll give you € |GELDMENGE| for this.",
		[getVehicleModelFromName("Nevada")] = "A gang offers you € |GELDMENGE| if you take them to |STANDORT|.",
		[getVehicleModelFromName("Shamal")] = "A boss offers you € |GELDMENGE| if you take him/her to |STANDORT|.",
		[getVehicleModelFromName("Andromada")] = "You're transporting |Andromada|000kg to |STANDORT| and you'll recive € |GELDMENGE| for this.",
	},	
}


PilotJob:new()