Item = inherit(Object)

Item.Classes = {
	[0] = "Consumables",
	[1] = "Weapons",
	[2] = "Placeable",
	[3] = "Permanent",
}

function Item:constructor(uid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, storage)
	self.m_UniqueIdentifer = uid
	self.m_ItemId = itemId
	self.m_Owner = owner
	self.m_Creator = creator
	self.m_Gift = gift
	self.m_Amount = amount
	self.m_Flags = flags
	self.m_ConditionFlags = conditionFlags
	self.m_Durability = durability
	self.m_Played = played
	self.m_SpecialText = specialtext
	self.m_Temporary = false
	self.m_Storage = false
	self.m_TemplateItem = itemmanager:getItem(self.m_ItemId)
	self.m_Storage = storage or JunkStorage
end

function Item:getOwner()
	if tonumber(self.m_Owner) then
		return getPlayerData("userdata","ID",self.m_Owner,"Username")
	end 
	return "none"
end

function Item:merge()
	self.m_Storage:mergeItem(self)
end

function Item:getUniqueIdentifier() return self.m_UniqueIdentifer end
function Item:getItemId() return self.m_ItemId end
function Item:getCreator() return self.m_Creator end
function Item:getGift() return self.m_Gift end
function Item:getAmount() return self.m_Amount end
function Item:getFlags() return self.m_Flags end
function Item:getConditionFlags() return self.m_ConditionFlags end
function Item:getDurability() return self.m_Durability end
function Item:getPlayed() return self.m_Played end
function Item:getSpecialText() return self.m_SpecialText end
function Item:setTemporary(bool) self.m_Temporary = bool end
function Item:getTemporary() return self.m_Temporary end
function Item:setStorage(storage) self.m_Storage = storage end
function Item:getStorage() return self.m_Storage end
function Item:getTemplateItem() return itemmanager:getItem(self.m_ItemId) end

function Item:setOwner(name)
	self.m_Owner = name
end

function Item:setCreator(creator)
	self.m_Creator = creator
end

function Item:setSpecialText(text)
	self.m_SpecialText = text
end

function Item:setAmount(amount)
	self.m_Amount = amount
end

function Item:setDurability(durability)
	self.m_Durability = durability
end

function Item:remove()
	self.m_Storage:removeItemInternal(self)
end

function Item:checkTemplateFlags()
	local templateFlags = self:getTemplateItem():getConditionFlags()
	local flagAmount = math.floor(tonumber(templateFlags:len()/8))
	local owner = self:getStorage():getPlayer()

	if flagAmount > 0 then
		for i = 1, flagAmount, 1 do
			local ri = i - 1
			local condition = tonumber(templateFlags:sub(ri+ri*8, i*8))
			if not ItemConditions[condition].Func(owner, self) then
				owner:sendNotification(ItemConditions[condition].Negative["DE"])
				return false
			end
		end
	end

	return true
end

function Item:checkConditionFlags()
	return true
end

function Item:setStorage(storage)
	self.m_Storage = storage
end

function Item:checkFlagStatus()
	if not ( self:checkTemplateFlags() and self:checkConditionFlags()) then
		self:getStorage():getPlayer():sendNotification("Du erfüllst nicht alle Bedingungen!")
		return false
	end
	return true
end

-- Placeholder function
-- also check if the requirements are fulfilled

function Item:select()
	return true
end

function Item:deselect()
	return true
end