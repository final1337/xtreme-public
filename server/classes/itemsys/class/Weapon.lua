-- Itemclass: Weapon
-- Purpose: Manage things like munition on use

Item.Classes[1] = inherit(Item)

local temp = Item.Classes[1]

function temp:constructor(...)
	Item.constructor(self, ...)

	self.m_Clip = self.m_MaxClip
	self.m_Weapon = tonumber(self:getTemplateItem():getSubClass())
	self.m_MaxClip = getOriginalWeaponProperty(self.m_Weapon, "pro", "maximum_clip_ammo")

end

function temp:select(player)
	if self:checkFlagStatus() then
		player:takeAllWeapons();
		player:giveWeapon(self.m_Weapon, self.m_Amount, true);
		--setWeaponAmmo(player, self.m_Weapon, self.m_Amount, self.m_Clip);
		return true
	end
	return false
end

function temp:deselect(player)
	player:takeAllWeapons();
end

function temp:useItem(player)
	if self:checkFlagStatus() then
		
		self.m_Clip = getPedAmmoInClip(player) - 1

		if ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())] and ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())].Func then
			ItemScripts[tonumber(self:getTemplateItem():getSpecialScript())].Func(player, obj, self)
		end
	
		self:getStorage():decrementItemAmount(self:getStorage():getItemSlot(self))
	end
end