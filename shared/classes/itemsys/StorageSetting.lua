StorageSetting = inherit(Object)

function StorageSetting:constructor(type, name, size, usage, aka, rank)
	self.m_Type = type
	self.m_Name = name
	self.m_Size = size
	self.m_Usage = usage
	self.m_Alias = aka and split(aka, ";") or false
	self.m_RequiredRank = tonumber(rank) or false
end

function StorageSetting:getType() return self.m_Type end
function StorageSetting:getName() return self.m_Name end
function StorageSetting:getSize() return self.m_Size end
function StorageSetting:getUsage() return self.m_Usage end
function StorageSetting:getAlias() return self.m_Alias end
function StorageSetting:getRequiredRank() return self.m_RequiredRank end