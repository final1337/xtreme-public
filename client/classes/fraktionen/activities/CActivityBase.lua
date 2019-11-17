ActivityBase = inherit(Object)

function ActivityBase:constructor(name, id, abbreviation)
	self.m_Name = name
	self.m_Id = id
	self.m_Abbreviation = abbreviation	
	self.m_CurrentPhase = 0
	self.m_LastStart = 0
	
	self.m_Active = false
	self.m_Startable = false	
end

function ActivityBase:failPhase(phase, forceFail)
	-- Save the phase, because it could be changed within the FailPhase-Method
	local tempPhase = self.m_CurrentPhase	
	-- Call the fail method
	if self["FailPhase"..phase] then
		self["FailPhase"..phase](self, forceFail)
	end	
	-- And also the normal AfterPhase-method
	self:deletePhase(tempPhase)	
end

function ActivityBase:failCurrentPhase(forceFail)
	-- Save the phase, because it could be changed within the FailPhase-Method
	local tempPhase = self.m_CurrentPhase
	-- Call the fail method
	if self["FailPhase"..self.m_CurrentPhase] then
		self["FailPhase"..self.m_CurrentPhase](self, forceFail)
	end
	-- And also the normal AfterPhase-method
	self:deletePhase(tempPhase)	
end

function ActivityBase:forcePhase(phase)
	self.m_CurrentPhase = phase
	if self["Phase"..self.m_CurrentPhase] then
		self["Phase"..self.m_CurrentPhase](self)
	end	
end

function ActivityBase:deleteCurrentPhase()
	local phase = self.m_CurrentPhase
	if self["AfterPhase"..phase] then
		self["AfterPhase"..phase](self)
	end
end

function ActivityBase:deletePhase(phase)
	if self["AfterPhase"..phase] then
		self["AfterPhase"..phase](self)
	end	
end

function ActivityBase:initActivity()
	self:failPhase(self.m_CurrentPhase, true)
	self.m_CurrentPhase = 0
	self.m_LastStart = getTickCount()
	self:nextPhase()
end

function ActivityBase:nextPhase()
	self:deleteCurrentPhase()
	self.m_CurrentPhase = self.m_CurrentPhase + 1
	if self["Phase"..self.m_CurrentPhase] then
		self["Phase"..self.m_CurrentPhase](self)
	else
		if self.FinalReward then
			self:FinalReward()
		end
	end
end