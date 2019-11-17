ItemTemplate = inherit(Object)

function ItemTemplate:constructor(itemId, class, subclass, nameDE, nameEN, displayPicture, quality, flags, conditionFlags, allowedFactions, stackable,
								 maxDurability, duration, specialscript, descriptionDE, descriptionEN, tradable, illegal)
	self.m_ItemId = itemId
	self.m_Class = class
	self.m_SubClass = subclass
	self.m_NameDE = nameDE
	self.m_NameEN = nameEN
	self.m_DisplayPicture = displayPicture
	self.m_Quality = quality
	self.m_Flags = flags
	self.m_ConditionFlags = conditionFlags
	self.m_AllowedFactions = allowedFactions
	self.m_Stackable = stackable == 1
	self.m_MaxDurability = maxDurability
	self.m_Duration = duration
	self.m_SpecialScript = specialscript
	self.m_DescriptionDE = descriptionDE
	self.m_DescriptionEN = descriptionEN
	self.m_Tradable = tradable == 1
	self.m_Illegal = illegal == 1
end

function ItemTemplate:getItemId() return self.m_ItemId end
function ItemTemplate:getClass() return self.m_Class end
function ItemTemplate:getSubClass() return self.m_SubClass end
function ItemTemplate:getName() return self.m_NameDE, self.m_NameEN end
function ItemTemplate:getDisplayPicture() return self.m_DisplayPicture end
function ItemTemplate:getQuality() return self.m_Quality end
function ItemTemplate:getFlags() return self.m_Flags end
function ItemTemplate:getConditionFlags() return self.m_ConditionFlags end
function ItemTemplate:getAllowedFactions() return self.m_AllowedFactions end
function ItemTemplate:isStackable() return self.m_Stackable end
function ItemTemplate:getMaxDurability() return self.m_MaxDurability end
function ItemTemplate:getDuration() return self.m_Duration end
function ItemTemplate:getSpecialScript() return self.m_SpecialScript end
function ItemTemplate:getDescription() return self.m_DescriptionDE, self.m_DescriptionEN end
function ItemTemplate:isTradable() return self.m_Tradable end
function ItemTemplate:isIllegal() return self.m_Illegal end