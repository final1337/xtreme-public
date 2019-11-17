FireFighterCentral = inherit(Singleton)

FireFighterCentral.TIME_FOR_NEXT_MISSION = 1000*60*17.5
FireFighterCentral.TIME_FOR_NEXT_MISSION_MINOR = 1000*9*60

addEvent("FireFighterCentral:newTask", true)

FireFighterCentral.FireFighterClasses = {
	[407] = FireVehicleWater,
	[544] = FireVehicleLadder,
	[563] = FireVehicleHelicopter,
	[490] = FireVehicle
}

function FireFighterCentral:constructor()

	self.m_CurrentMission = false
	self.m_CurrentMinorMission = false

	self.m_MinorMissionName = false
	self.m_MajorMissionName = false

	self.m_MajorFinished = false
	self.m_MinorFinished = false

	self.m_NewHandler = bind(self.startNewMission, self)
	--self.m_Timer = Timer (self.m_NewHandler, FireFighterCentral.TIME_FOR_NEXT_MISSION, 0)

	self.m_NewHandlerMinor = bind(self.startNewMinor, self)
	-- self.m_TimerMinor = Timer (self.m_NewHandlerMinor, FireFighterCentral.TIME_FOR_NEXT_MISSION_MINOR, 0)	

	self.m_FireActivities = {
		{Stonefall:new("Steinfall", "SF", "Stonefall"), 1000*60*15},
		{HouseFire:new("Hausbrand", "HOF", "HouseFire"), 1000*60*15},
		{SurfaceFire:new("Flächenbrand", "FB", "Flächenbrand"), 1000*60*15},
		{WaterRescue:new("Wasserrettung", "WR", "Wasserrettung"), 1000*60*15}	
	}

	self.m_MinorAcitivies = {
		[1] = {TrafficAccident:new("Verkehrsunfall", "TA", "TrafficAccident"),1000*60*7},
		[2] = {Baumfall:new("Baumfall", "BF", "Baumfall"),1000*60*7},
	}

	for key, value in ipairs(self.m_FireActivities) do
		ActivityManager:getSingleton():addActivity(value)
	end

	for key, value in ipairs(self.m_MinorAcitivies) do
		ActivityManager:getSingleton():addActivity(value)
	end	

	self.m_BindMajorPhaseChange = bind(self.phaseSwapMajor, self)
	self.m_BindMinorPhaseChange = bind(self.phaseSwapMinor, self)	

	self.m_BindFinishedMajor = bind(self.finishedMajor, self)
	self.m_BindFinishedMinor = bind(self.finishedMinor, self)		
	
	self:startNewMission()
	self:startNewMinor()
	
	addEventHandler("loginSuccess", root, bind(self.playerLogin, self))
	addCommandHandler("einsaetze", bind(self.activateOverview, self))
	addEventHandler("FireFighterCentral:newTask", root, bind(self.Event_RemoteNewTask, self))
end

function FireFighterCentral:Event_RemoteNewTask(typ)
	if typ == "main" then
		if isTimer(self.m_Timer) then
			killTimer(self.m_Timer)
		end
		self:startNewMission()
	else
		if isTimer(self.m_TimerMinor) then
			killTimer(self.m_TimerMinor)
		end
		self:startNewMinor()
	end
end

function FireFighterCentral:activateOverview(player)
	if ( getElementData(player,"Fraktion") == 9 ) then
		local remainMajor = math.ceil(select(1, getTimerDetails(self.m_Timer))/60000)
		local remainMinor = math.ceil(select(1, getTimerDetails(self.m_TimerMinor))/60000)		
		local majorFinished = self.m_MajorFinished and "#00FF00" or "#FF0000"
		local minorFinished = self.m_MinorFinished and "#00FF00" or "#FF0000"
		local msg = ("%sHaupteinsatz (%s) :\n %d Minuten %s\nNebeneinsatz(%s):\n %d Minuten"):format(majorFinished, self.m_MajorMissionName, remainMajor, minorFinished,self.m_MinorMissionName, remainMinor)

		player:triggerEvent("XTM:AlertMessage", msg, true)
	end
end

function FireFighterCentral:playerLogin(player)
	if getElementData(player, "Fraktion") == 9 then
		if self.m_MinorMissionName then
			local remainMajor = math.ceil(select(1, getTimerDetails(self.m_Timer))/60000)
			local remainMinor = math.ceil(select(1, getTimerDetails(self.m_TimerMinor))/60000)
			triggerClientEvent(player, "XTM:Reward:show", player, {("Derzeitige Einsätze:\n%s und %s"):format(self.m_MajorMissionName, self.m_MinorMissionName), ("Verbleibende Zeit:\n%d min. und %d min."):format(remainMajor, remainMinor)}, 500, 6000)
			-- triggerClientEvent(player, "XTM:Reward:show", player, {("Verbleibende Zeit:\n%d min. und %d min."):format(remainMajor, remainMinor)}, 500, 6000)
		else
			triggerClientEvent(player, "XTM:Reward:show", player, {("Derzeitige Einsätze:\n%s"):format(self.m_MajorMissionName), ""}, 500, 6000)
		end
	end
end

function FireFighterCentral:startNewMission()
	if self.m_CurrentMission then
		self.m_CurrentMission:failCurrentPhase(true)
	end

	local rnd = math.random(1, #self.m_FireActivities)

	self.m_MajorMissionName = self.m_FireActivities[rnd][1]:getName()
	self.m_MajorFinished = false

	self.m_CurrentMission = self.m_FireActivities[rnd][1]
	self.m_CurrentMission:initActivity()

	self.m_CurrentMission.onPhaseChange = self.m_BindMajorPhaseChange
	self.m_CurrentMission.onRealLastPhase = self.m_BindFinishedMajor

	self.m_Timer = Timer (self.m_NewHandler, self.m_FireActivities[rnd][2], 1)
end

function FireFighterCentral:phaseSwapMinor(last)
	if not last then
		self.m_TimerMinor:reset()
	end
end

function FireFighterCentral:phaseSwapMajor(last)
	if not last then
		self.m_Timer:reset()
	end
end

function FireFighterCentral:finishedMajor()
	self.m_MajorFinished = true
end

function FireFighterCentral:finishedMinor()
	self.m_MinorFinished = true
end

function FireFighterCentral:startNewMinor()
	if self.m_CurrentMinorMission then
		self.m_CurrentMinorMission:failCurrentPhase(true)
	end

	local rnd = math.random(1, #self.m_MinorAcitivies)

	self.m_MinorMissionName = self.m_MinorAcitivies[rnd][1]:getName()
	self.m_MinorFinished = false

	self.m_CurrentMinorMission = self.m_MinorAcitivies[rnd][1]
	self.m_CurrentMinorMission:initActivity()

	self.m_CurrentMinorMission.onPhaseChange = self.m_BindMinorPhaseChange
	self.m_CurrentMinorMission.onRealLastPhase = self.m_BindFinishedMinor

	self.m_TimerMinor = Timer (self.m_NewHandlerMinor, self.m_MinorAcitivies[rnd][2], 1)
end
