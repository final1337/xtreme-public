ActivityBase = inherit(Object)

addEvent("AM:clientIsReady", true)

ActivityBase.DutyFactions = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[9] = true
}

function ActivityBase:constructor(name, abbreviation, clientClass)
	self.m_Name = name
	self.m_Abbreviation = abbreviation
	self.m_ClientClass = clientClass
	self.m_Players = {}
	self.m_ActivityEntities = {}
	self.m_CurrentPhase = 0
	self.m_LastStart = 0
	self.m_LastFailedPhase = 0
	
	self.m_Active = false
	self.m_Startable = false
	
	self.m_PlayerLogin       = bind(self.Event_OnPlayerLogin, self)

	self.onPhaseChange = false
	self.onRealLastPhase = false

	--addEventHandler("AM:clientIsReady", root, self.m_PlayerConnectFunc)
	addEventHandler("loginSuccess", root, self.m_PlayerLogin)
	
	
end

function ActivityBase:destructor()
	removeEventHandler("loginSuccess", root, self.m_PlayerLogin)
end

function ActivityBase:getName()
	return self.m_Name
end

function ActivityBase:getClientClass()
	return self.m_ClientClass
end

function ActivityBase:Event_OnPlayerLogin(player)
	if self.m_CurrentPhase == 1 then
		triggerClientEvent(player, "AM:initPhase", player, self:getClientClass())
	elseif self.m_CurrentPhase > 1 then
		triggerClientEvent(player, "AM:forcePhase", player, self:getClientClass(), self.m_CurrentPhase)
	end
	-- Show the player the current available elements
	for key, value in ipairs(self.m_ActivityEntities) do
		local isPlayerInFaction = false
		for _, faction in ipairs(value.m_Factions) do
			if getElementData(player, "Fraktion") == faction then
				setElementVisibleTo(value, player, true)
			end
		end
	end
end

function ActivityBase:addPlayer(player)
	table.insert(self.m_Players, player)
end

function ActivityBase:removePlayer(player)
	for key, value in ipairs(self.m_Players) do
		if value == player then
			table.remove(self.m_Players, key)
		end
	end
end

function ActivityBase:sendFactionAlertMessage(message, factions)
	for _, factionId in pairs ( factions ) do
		for key, player in ipairs (getElementsByType("player")) do
			if getElementData(player, "Fraktion") == factionId then
				if ( ActivityBase.DutyFactions[getElementData(player,"Fraktion")] and getElementData(player,"Duty") ) or not ActivityBase.DutyFactions[getElementData(player,"Fraktion")] then
					-- Todo:
					--outputChatBox(("WARN [%s] %s"):format(self.m_Abbreviation, message), player, 255, 0, 0)
					triggerClientEvent(player,"XTM:AlertMessage", player, message)
				end
			end
		end
	end
end

function ActivityBase:sendFactionMessage(message, factions, r, g, b)
	for _, factionId in pairs ( factions ) do
		for key, player in ipairs (getElementsByType("player")) do
			if getElementData(player, "Fraktion") == factionId then
				if ( ActivityBase.DutyFactions[getElementData(player,"Fraktion")] and getElementData(player,"Duty") ) or not ActivityBase.DutyFactions[getElementData(player,"Fraktion")] then
					-- Todo:
					outputChatBox(("[%s] %s"):format(self.m_Abbreviation, message), player, r or 255, g or 255, b or 255)
				end
			end
		end
	end
end
 
function ActivityBase:sendFactionSlideMessage(message, factions, timeforanimation, timeforitem)
	for _, factionId in pairs ( factions ) do
		for key, player in ipairs (getElementsByType("player")) do
			if getElementData(player, "Fraktion") == factionId then
				if ( ActivityBase.DutyFactions[getElementData(player,"Fraktion")] and getElementData(player,"Duty") ) or not ActivityBase.DutyFactions[getElementData(player,"Fraktion")] then
					triggerClientEvent(player, "XTM:Reward:show", player, type(message) ~= "table" and {message} or message, timeforanimation, timeforitem)
				end
			end
		end
	end
end

function ActivityBase:failPhase(phase, forceFail)
	-- Save the phase, because it could be changed within the FailPhase-Method
	local tempPhase = phase	
	-- Call the fail method
	if tempPhase ~= self.m_LastFailedPhase then
		if self["FailPhase"..phase] then
			self["FailPhase"..phase](self, forceFail)
		end	
		-- And also the normal AfterPhase-method
		self:deletePhase(tempPhase, forceFail)	
		
	end
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then		
			triggerClientEvent(value, "AM:failPhase", resourceRoot, self:getClientClass(), phase, forceFail)
		end
	end
end

function ActivityBase:failCurrentPhase(forceFail)
	-- Save the phase, because it could be changed within the FailPhase-Method
	local tempPhase = self.m_CurrentPhase
	-- Call the fail method
	if tempPhase ~= self.m_LastFailedPhase then
		if self["FailPhase"..self.m_CurrentPhase] then
			self["FailPhase"..self.m_CurrentPhase](self, forceFail)
		end
		-- And also the normal AfterPhase-method
		self:deletePhase(tempPhase, forceFail)	
		
	end
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then		
			triggerClientEvent(value, "AM:failCurrentPhase", resourceRoot, self:getClientClass(), forceFail)
		end
	end
end

function ActivityBase:forcePhase(phase)
	self.m_CurrentPhase = phase
	if self["Phase"..self.m_CurrentPhase] then
		self["Phase"..self.m_CurrentPhase](self)
	end	
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then		
			triggerClientEvent(value, "AM:forcePhase", resourceRoot, self:getClientClass(), phase)
		end
	end
end

function ActivityBase:deleteCurrentPhase()
	local phase = self.m_CurrentPhase
	if self["AfterPhase"..phase] then
		self["AfterPhase"..phase](self)
	end
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then		
			triggerClientEvent(value, "AM:deleteCurrentPhase", resourceRoot, self:getClientClass())
		end
	end
end

function ActivityBase:deletePhase(phase, forceFail)
	-- Save the last failed phase 2 supress double failPhase-Calls
	self.m_LastFailedPhase = phase
	if self["AfterPhase"..phase] then
		self["AfterPhase"..phase](self)
	end	
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then	
			triggerClientEvent(value, "AM:deletePhase", resourceRoot, self:getClientClass(), phase)
		end
	end
	
	if forceFail then
		self.m_CurrentPhase = 0
	end
end

function ActivityBase:sendElementFactionVisibleTo(element, factions)
	element.m_Factions = factions
	setElementVisibleTo(element, root, false)
	for _, factionId in pairs ( factions ) do
		for key, player in ipairs (getElementsByType("player")) do
			if getElementData(player, "Fraktion") == factionId then
				setElementVisibleTo(element, player, true)
			end
		end
	end	
	table.insert(self.m_ActivityEntities, element)
	addEventHandler("onElementDestroy", element,
		function()
			for key, value in ipairs(self.m_ActivityEntities) do
				if value == source then
					table.remove(self.m_ActivityEntities, key)
					break
				end
			end
		end
	)
	return element
end

function ActivityBase:initActivity()
	self:failPhase(self.m_CurrentPhase, true)
	self.m_CurrentPhase = 0
	self.m_LastFailedPhase = 0
	self.m_LastStart = getRealTime()["timestamp"]
	self:nextPhase()
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then
			triggerClientEvent(value, "AM:initPhase", resourceRoot, self:getClientClass())
		end
	end
end

function ActivityBase:nextPhase()
	self:deleteCurrentPhase()
	self.m_CurrentPhase = self.m_CurrentPhase + 1

	if self["Phase"..self.m_CurrentPhase] then
		self["Phase"..self.m_CurrentPhase](self)
		if self.onPhaseChange then
			self:onPhaseChange(self["Phase"..self.m_CurrentPhase+1])
		end		
		if not self["Phase"..self.m_CurrentPhase+1] then
			if self.onRealLastPhase then
				self:onRealLastPhase()
			end
		end
	else
		if self.FinalReward then
			self:FinalReward()
		end
	end
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"loggedin") == 1 then	
			triggerClientEvent(value, "AM:nextPhase", resourceRoot, self:getClientClass())
		end
	end
end