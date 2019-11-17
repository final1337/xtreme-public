PlayerManager = inherit(Singleton)

addEvent("RP:Server:ProjectileCreation", true)


PlayerManager.LegitProjectiles = {
	[16] = true, -- Grenade
	[17] = true, -- Tear Gas
	[18] = true, -- Molotov
	[19] = true, -- Rocket Simple
	[20] = true, -- Rocket HS
	[39] = true, -- Satchel
}

PlayerManager.ProjectileToWeapon = {
	[16] = 16,
	[17] = 17,
	[18] = 18,
	[19] = 35,
	[20] = 36,
	[39] = 39
}

function PlayerManager:constructor()
	addEventHandler("onPlayerJoin", root, bind(self.onPlayerJoin, self))
	addEventHandler("onResourceStop", resourceRoot, bind(self.onResourceStop, self))

	addCommandHandler("select", bind(self.selectPlayerInventory, self))
	addCommandHandler("use", bind(self.usePlayerInventory, self))
	addCommandHandler("inv", bind(self.showPlayerInventory, self))
	addCommandHandler("del", bind(self.deletePlayerInventory, self))
	addCommandHandler("barricades", bind(self.addPlayerInventory, self))
	addCommandHandler("add", bind(self.debugTest, self))
	if DEVEL then
		addCommandHandler("removeamount", bind(self.removeTest, self))
	end

	addEventHandler("onPlayerWeaponFire", root, bind(self.Event_OnPlayerWeaponFire, self))
	addEventHandler("RP:Server:ProjectileCreation", root, bind(self.Event_OnProjectileCreation, self))

	addEventHandler("onPlayerWeaponSwitch", root, bind(self.Event_OnPlayerWeaponSwitch, self))

	self:loadPlayers()
end

function PlayerManager:Event_OnPlayerWeaponSwitch(previous, current)
end

function PlayerManager:removeTest(player, _, itemId, amount)
	if (itemId and tonumber(itemId)) and (amount and tonumber(amount)) then
		player:takeItemAmount(tonumber(itemId), tonumber(amount))
		player:sendMessage("You removed %s - %s.", 255, 255, 0, itemId, amount)
	end
end

function PlayerManager:debugTest(player, _, itemId, itemAmount, temp, ...)
	if getElementData(player,"Adminlevel") > 2 and itemAmount and tonumber(itemAmount) then
		player:addItem(tonumber(itemId), tonumber(itemAmount), table.concat({...}," "), temp == "yes" and true or false)
		player:sendMessage("Item hinzugefügt.")
	end
end

function PlayerManager:Command_SetMoney(player, _, money)
	if tonumber(money) then
		if player:inGame() then
			player:setData("Money", tonumber(money))
			player:sendMessage("Your money has been set to $ ".. money)
		end
	end
end

function PlayerManager:Event_OnProjectileCreation(projectile)
	if not client then return end
	if not projectile then return end
	if PlayerManager.LegitProjectiles[projectile] then
		self:onWeaponFire(client, PlayerManager.ProjectileToWeapon[projectile], 0, 0, 0, 0, 0, 0, 0)
	end
end

-- // Check if the player has an item selected and if the class of the item is a weapon
-- // Todo: add better checks, if the wepaon is really available
function PlayerManager:Event_OnPlayerWeaponFire(weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
	self:onWeaponFire(source, weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
end

function PlayerManager:onWeaponFire(player, weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
	local item = player:getSelectedItem()
	for key, value in pairs(player.m_Storages[2]:getItems()) do
		if value:getTemplateItem():getSubClass() == weapon then
			item = value
		end
	end
	if item and item:getTemplateItem():getClass() == 1 then
		item:useItem(player)
	end
end

function PlayerManager:selectPlayerInventory(player, _, slot)
	player:selectItem(tonumber(slot))
end

function PlayerManager:usePlayerInventory(player, _, slot)
	player:useItem(tonumber(slot))
end

function PlayerManager:addPlayerInventory(player)
	player:addInventory()
end

function PlayerManager:showPlayerInventory(player)
	-- player:showInventory()
end

function PlayerManager:deletePlayerInventory(player, ...)
	-- player:deleteInventarItem(...)
end

function PlayerManager:onPlayerJoin()
	source:init()
end

function PlayerManager:onResourceStop()
	for key, value in ipairs(getElementsByType("player")) do
		Player.destructor(value)
	end
end

function PlayerManager:loadPlayers()
	for _, player in ipairs(getElementsByType("player")) do
		player:init()
	end
end
