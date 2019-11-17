ActivityManager = inherit(Singleton)

function ActivityManager:constructor()
	-- Order
	self.m_Activities = {
		--HanfTransport:new("Hanftransport", "HT", "Hanftransport"),
		--Drogentruck:new("Drogentruck", "DT", "Drogentruck"),
		--Biketruck:new("Biketruck", "BT", "Biketruck"),
		--DamBlow:new("Dambruch", 4, "DB"),
		-- Firefighter acitivies
	}
	
	-- HanfTransport:getSingleton():initActivity()
end

function ActivityManager:addActivity(activity)
	table.insert(self.m_Activities, activity)
end

function ActivityManager:getActivityByName(name)
	for key, value in ipairs(self.m_Activities) do
		if value:getName() == name then
			return value
		end
	end
	return false
end