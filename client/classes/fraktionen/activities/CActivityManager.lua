ActivityManager = inherit(Singleton)

addEvent("AM:failPhase", true)
addEvent("AM:failCurrentPhase", true)
addEvent("AM:nextPhase", true)
addEvent("AM:forcePhase", true)
addEvent("AM:deletePhase", true)
addEvent("AM:deleteCurrentPhase", true)
addEvent("AM:initPhase", true)

function ActivityManager:constructor()
	-- Order
	self.m_Activities = {
		--["Hanftransport"] = HanfTransport:new("Hanftransport", 1, "HT"),
		--["Drogentruck"]   = Drogentruck:new("Drogentruck", 2, "DT"),
		--["Biketruck"]     = Biketruck:new("Biketruck", 3, "BT"),]]
		--DamBlow:new("Dambruch", 4, "DB"),
	}
	--HanfTransport:getSingleton():initActivity()
	addEventHandler("AM:failPhase", root, bind(self.M_failPhase, self))
	addEventHandler("AM:failCurrentPhase", root, bind(self.M_failCurrentPhase, self))
	addEventHandler("AM:nextPhase", root, bind(self.M_nextPhase, self))
	addEventHandler("AM:forcePhase", root, bind(self.M_forcePhase, self))
	addEventHandler("AM:deletePhase", root, bind(self.M_deletePhase, self))
	addEventHandler("AM:deleteCurrentPhase", root, bind(self.M_deleteCurrentPhase, self))
	addEventHandler("AM:initPhase", root, bind(self.M_initPhase, self))
	
	addEventHandler("AM:showInstantMesssage", root, bind(self.Event_showInstantMessage,self))
	
	-- Tell the server that the client is ready for activities-status
	triggerServerEvent("AM:clientIsReady", resourceRoot)
end

function ActivityManager:Event_showInstantMessage(message,r,g,b)
	
end

function ActivityManager:M_failPhase (activity, id, forceFail)
	if not self.m_Activities[activity] then return end
	self.m_Activities[activity]:failPhase(id, forceFail)
end

function ActivityManager:M_failCurrentPhase (activity, forceFail)
	if not self.m_Activities[activity] then return end
	self.m_Activities[activity]:failCurrentPhase(forceFail)
end

function ActivityManager:M_nextPhase (activity)
	if not self.m_Activities[activity] then return end
	-- Ignore the first nextPhase-Event, if we wouldn't Phase1 would be triggered twice.
	if self.m_Activities[activity].m_CurrentPhase == 0 then return end
	self.m_Activities[activity]:nextPhase()
end

function ActivityManager:M_forcePhase (activity, phase)
	if not self.m_Activities[activity] then return end
	self.m_Activities[activity]:forcePhase(phase)
end

function ActivityManager:M_deletePhase (activity, phase)
	if not self.m_Activities[activity] then return end
	self.m_Activities[activity]:deletePhase(phase)
end

function ActivityManager:M_deleteCurrentPhase (activity)
	if not self.m_Activities[activity] then return end
	self.m_Activities[activity]:deleteCurrentPhase()
end

function ActivityManager:M_initPhase (activity)
	if not self.m_Activities[activity] then return end
	self.m_Activities[activity]:initActivity()
end