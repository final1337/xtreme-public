Bonus = {}

function Bonus:constructor()
	self.m_Bonus = 0
	self.m_ActiveBonus = true
	self.m_BonusFactions = {}
end

function Bonus:addBonusFaction(factionId)
	self.m_BonusFactions[factionId] = true
end

function Bonus:removeBonusFaction(factionId)
	self.m_BonusFactions[factionId] = nil
end

function Bonus:resetBonusFactions()
	self.m_BonusFactions = {}
end

function Bonus:payBonus()
	local factionMembers = {}
	for key, value in ipairs ( getElementsByType("player")) do
		if self.m_BonusFactions[value:getData("Fraktion")] and value:getData("Duty") and not value:getData("AFK") then
			table.insert ( factionMembers, value )
		end
	end
	local bonusPerPerson = math.floor(self.m_Bonus / #factionMembers)
	for _, player in ipairs ( factionMembers ) do
		setElementData(player, "Bankgeld", tonumber(getElementData(player,"Bankgeld")) + bonusPerPerson)
		player:sendMessage("Dir wurden %d € auf dein Konto überwiesen.", 255, 255, 255, bonusPerPerson)
	end
	for key, value in pairs(self.m_BonusFactions) do
		fraktionskassen[key] = fraktionskassen[key] + math.floor(self.m_Bonus/10)
	end
end

function Bonus:getFactionMemberAmount(faction)
	local i = 0
	for key, value in ipairs(getElementsByType("player")) do
		if getElementData(value,"Fraktion") == faction then
			i = i + 1
		end
	end
	return i
end

function Bonus:getFactionMembersTotal()
	local total = 0
	for faction in pairs(self.m_BonusFactions) do
		total = total + self:getFactionMemberAmount(faction)
	end
	return total
end

function Bonus:getBonus()
	return self.m_Bonus
end

function Bonus:setBonus(amount)
	self.m_Bonus = amount
end

function Bonus:setBonusActive()
	self.m_ActiveBonus = true
end

function Bonus:setBonusInactive()
	self.m_ActiveBonus = false
end

function Bonus:resetBonus()
	self.m_Bonus = 0
end

function Bonus:isBonusActive()
	return self.m_ActiveBonus
end

function Bonus:addBonus(amount)
	if not self:isBonusActive() then return end
	self.m_Bonus = self.m_Bonus + (amount * (0.5 + self:getFactionMembersTotal()*1))
end

function Bonus:subBonus(amount)
	if not self:isBonusActive() then return end
	self.m_Bonus = self.m_Bonus - amount
end