-- Itemclass: Consumable
-- Purpose: Default item which decreases on use


Item.Classes[0] = inherit(Item)

local temp = Item.Classes[0]

function temp:constructor(...)
	Item.constructor(self, ...)
end

function temp:useItem(player)
	if self:checkFlagStatus() and self:getAmount() > 0 then

		local placeId = tonumber(self:getTemplateItem():getSubClass())

		--local obj = createObject(placeId, player:getPosition() - Vector3(0,0,0.7), player:getRotation())

		if ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())] and ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())].Func then
			ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())].Func(player, obj, self)
		end

		self:getStorage():decrementItemAmount(self:getStorage():getItemSlot(self))
	end
end