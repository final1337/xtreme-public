Baumfall = inherit(ActivityBase)
inherit(Singleton, Baumfall)
inherit(Bonus, Baumfall)

Baumfall.CASES = {
	[1] = {
		{848, -2019.8662109375, 583.7197265625, 36.052429199219, 0, 0, 0					 },
		{845, -2007.69921875, 588, 35, 0, 0, 176                                             },
		{844, -2000.6177978516, 590.94384765625, 34.933200836182, 0, 0, 0                    },
		{843, -2018.5224609375, 582.70202636719, 34.956398010254, 0, 0, 247.99438476562      },
		{840, -2015.1788330078, 585.76293945312, 36.162376403809, 0, 0, 0                    },
		{846, -2002.7998046875, 594.69921875, 34.541599273682, 0, 0, 309.99572753906         },
		{845, -2000, 593.7998046875, 35.099998474121, 0, 0, 170                              },
		{684, -2000.2998046875, 598.69921875, 34.369998931885, 0, 0, 325.99182128906         },
	},

	[2] = {
		{837,-1762.7000000,314.8999900,6.6000000,0.0000000,0.0000000,0.000000},
		{840,-1758.7000000,317.8999900,7.3000000,0.0000000,0.0000000,0.0000000},
		{833,-1756.8000000,322.1000100,6.9000000,0.0000000,0.0000000,0.000000},
		{845,-1752.7000000,322.5000000,7.1000000,0.0000000,0.0000000,0.0000000},
		{845,-1761.9000000,314.1000100,7.1000000,0.0000000,0.0000000,334.0000000},
		{847,-1755.3000000,324.5000000,8.0000000,0.0000000,0.0000000,0.0000000},
	},	
	[3] = {
		{835,-2028.8574000,-317.8994100,36.2618500,0.0000000,0.0000000,182.9990000},
		{836,-2022.3000000,-317.5000000,35.4000000,0.0000000,3.9990000,2.0000000},
		{838,-2031.9279800,-314.3376500,35.7550800,0.0000000,0.0000000,305.0000000},
		{840,-2024.7000000,-314.8999900,35.8000000,4.9990000,1.0000000,143.9980000},
	},
}


Baumfall.AVAILABLE_FACTIONS = {
	[9] = true,
}

Baumfall.VISIBILE_FACTIONS = {
	[1] = 9,
}

Baumfall.CHAT_FACTION = {}

for key, value in pairs ( Baumfall.AVAILABLE_FACTIONS ) do table.insert(Baumfall.CHAT_FACTION, key) end

function Baumfall:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
	Bonus.constructor(self)

	self.m_Objects = {}
	self.m_Blip = {}

	for faction in pairs(Baumfall.AVAILABLE_FACTIONS) do
		self:addBonusFaction(faction)
	end			
end

function Baumfall:AfterPhase1()
	for key, value in ipairs(self.m_Objects) do
		DamageObject:getSingleton():delete(value.Iterator)
		self.m_Objects[key] = nil
	end
	if isElement(self.m_Blip) then
		self.m_Blip:destroy()
	end	
end

function Baumfall:Phase1()
	self:sendFactionSlideMessage({"Baumsturz!"}, Baumfall.VISIBILE_FACTIONS, 500, 3500 )
	self:resetBonus()

	self.m_Vehicles = {}
	
	self.m_ActiveMission = math.random(1, 3)
	
	local model,x,y,z = unpack(Baumfall.CASES[self.m_ActiveMission][1])

	self.m_Blip = Blip(Vector3(x,y,z), 0, 2, 255, 0, 0)
	self:sendElementFactionVisibleTo( self.m_Blip, Baumfall.VISIBILE_FACTIONS)
	
	self.m_Objects = {}
	self.m_Count = 0
	
	for key, value in ipairs(Baumfall.CASES[self.m_ActiveMission]) do
		self.m_Objects[key] = DamageObject:getSingleton():addEntity(value[1], value[2], value[3], value[4], 0, 0, 2000, {[9] = true}, value[5], value[6], value[7])
		self.m_Objects[key].onFinish = bind(self.finishedCuttingTree, self)
		self:addBonus(450)
	end
end

function Baumfall:finishedCuttingTree()
	self.m_Count = self.m_Count + 1
	if self.m_Count >= #Baumfall.CASES[self.m_ActiveMission] then
		self:nextPhase()
	end
end

function Baumfall:Phase2()
	self:sendFactionSlideMessage({"Baumsturz beendet!", "Gesamter Bonus: " .. self:getBonus() .. " €"}, Baumfall.CHAT_FACTION, 500, 3500 )

	self:payBonus()	
	self:resetBonus()

	for key, value in ipairs ( getElementsByType("player")) do
		if self.m_BonusFactions[value:getData("Fraktion")] and value:getData("Duty") then
		--	levelup(value, 144)
		end
	end	
end