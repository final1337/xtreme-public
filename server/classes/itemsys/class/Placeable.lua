-- Itemclass: Placeable
-- Purpose: Default item which inherits from the consumable but uses place mechanism

Item.Classes[2] = inherit(Item)
inherit(Item.Classes[0], Item.Classes[2])

local temp = Item.Classes[2]

function temp:constructor(...)
	Item.constructor(self, ...)
end

function temp:useItem(player)
	if self:checkFlagStatus() and self:getAmount() > 0 then

		local placeId = tonumber(self:getTemplateItem():getSubClass())

		local obj = createObject(placeId, player:getPosition() - Vector3(0,0,0.7), player:getRotation())

		obj:setDimension(player:getDimension());
		
		if ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())] and ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())].Func then
			ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())].Func(player, obj, self)
		end
		
		self:getStorage():decrementItemAmount(self:getStorage():getItemSlot(self))
		
	end
end