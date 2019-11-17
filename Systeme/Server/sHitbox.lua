Hitbox = {}

setWeaponProperty(33, "poor","weapon_range", 250)
setWeaponProperty(33, "std","weapon_range", 250)
setWeaponProperty(33, "pro","weapon_range", 200)
setWeaponProperty(31, "pro","weapon_range", 100)
setWeaponProperty(31, "pro","accuracy", 0.9)
setWeaponProperty(24, "pro","accuracy", 1.6)

weaponDamages = {
	[0] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5 },
	[4] = { [3] = 10, [4] = 20, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 20 }, 
	[8] = { [3] = 20, [4] = 20, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 25 },
	[22] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 15 }, 
	[23] = { [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0 }, 
	[24] = { [3] = 49, [4] = 40, [5] = 29, [6] = 29, [7] = 35, [8] = 35, [9] = 75 }, 
	[25] = { [3] = 25, [4] = 25, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 35 }, 
	[26] = { [3] = 30, [4] = 30, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 40 }, 
	[27] = { [3] = 30, [4] = 30, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 40 }, 
	[28] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 10 }, 
	[29] = { [3] = 9, [4] = 9, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 12 }, 
	[32] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 10 }, 
	[30] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 14 }, 
	[31] = { [3] = 9, [4] = 9, [5] = 7, [6] = 7, [7] = 7, [8] = 7, [9] = 12 }, 
	[33] = { [3] = 15, [4] = 15, [5] = 12, [6] = 12, [7] = 12, [8] = 12, [9] = 20 }, 
	[34] = { [3] = 15, [4] = 15, [5] = 12, [6] = 12, [7] = 12, [8] = 12, [9] = 75 }, 
	[35] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130 }, 
	[36] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130 }, 
	[37] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 12 }, 
	[38] = { [3] = 8, [4] = 8, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 12 }, 
	[16] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130 }, 
	[17] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5 }, 
	[18] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5 }, 
	[39] = { [3] = 100, [4] = 100, [5] = 100, [6] = 100, [7] = 100, [8] = 100, [9] = 100 }
}

Koerperteile = {
	[3] = "Rumpf",
	[4] = "Arsch",
	[5] = "Linker Arm",
	[6] = "Rechter Arm",
	[7] = "Linkes Bein",
	[8] = "Rechtes Bein",
	[9] = "Kopf",
};

addEvent("damageCalcServer",true)
addEventHandler("damageCalcServer",root,function(attacker,weapon,bodypart,loss,player)
	triggerClientEvent(player,"showBloodFlash",player);
	local basicDMG = weaponDamages[weapon][bodypart];
	local x1,y1,z1 = getElementPosition(attacker);
	local x2,y2,z2 = getElementPosition(player);
	local dist = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2);
	local multiply = 1;
	if(weapon == 24 and dist <= 1)then multiply = 0.5 end
	damagePlayer(player,basicDMG*multiply,attacker,weapon,bodypart);
	if(getElementData(attacker,"ImGangwar") == true and getElementData(player,"ImGangwar") == true and getElementData(player,"ImGangwarGestorben") ~= true and tonumber(getElementData(attacker,"Fraktion")) ~= tonumber(getElementData(player,"Fraktion")))then
		triggerClientEvent(attacker,"showDMGAnzeige",attacker,getPlayerName(player),basicDMG*multiply,Koerperteile[bodypart]);
		setElementData(attacker,"TemporaerGWDamage",getElementData(attacker,"TemporaerGWDamage")+basicDMG*multiply);
	end
end)

function damagePlayer(player,amount,attacker,weapon,bodypart)
	local armor = getPedArmor(player);
	local health = getElementHealth(player);

	if attacker then

		local fraktion = getElementData(attacker,"Fraktion")
		local rank = getElementData(attacker,"Rang")
		if ( ( weapon == 33 or weapon == 34 ) and (player:getPosition()-attacker:getPosition()):getLength() > 20 and bodypart == 9 and not getElementData(attacker,"ImGangwar") and rank >= 4 and isEvil(attacker) ) then
			damageLog:write(attacker and attacker:getName() or "none", player and player:getName() or "none", weapon, amount, bodypart or "none")
			outputSpy("damage", "%s hat %s mit Waffe %s an Part %s getroffen, Schaden: %d", attacker or "none", player or "none", getWeaponNameFromID(weapon), bodypart, amount)
			killPed(player, attacker, weapon, bodypart)
			setPedHeadless(player, true)
			return
		elseif (player:getPosition()-attacker:getPosition()):getLength() > 20 and weapon == 34 and bodypart == 9 and ((isCop(attacker) or isFBI(attacker) and rank >= 3) or isArmy(attacker))  then
			damageLog:write(attacker and attacker:getName() or "none", player and player:getName() or "none", weapon, amount, bodypart or "none")
			outputSpy("damage", "%s hat %s mit Waffe %s an Part %s getroffen, Schaden: %d", attacker or "none", player or "none", getWeaponNameFromID(weapon), bodypart, amount)
			killPed(player, attacker, weapon, bodypart)
			setPedHeadless(player, true)
			return			
		end
	end
	
	if(armor > 0)then
		if(armor >= amount)then
			setPedArmor(player,armor - amount);
		else
			setPedArmor(player,0);
			local amount = math.abs(armor - amount);

			if(getElementHealth(player) - amount <= 0)then
				if(bodypart == 9)then setPedHeadless(player,true)end
				killPed(player, attacker, weapon, bodypart);
				pedGotKilled(player, attacker)
			else
				setElementHealth(player,health - amount);
			end
		end
	else
		if(health - amount <= 0)then
			if(bodypart == 9)then setPedHeadless(player,true)end
			killPed(player, attacker, weapon, bodypart);
			pedGotKilled(player, attacked)
		end
		setElementHealth(player,health - amount);
	end

	damageLog:write(attacker and attacker:getName() or "none", player and player:getName() or "none", weapon or "none", amount or "none", bodypart or "none")
	outputSpy("damage", "%s hat %s mit Waffe %s an Part %s getroffen, Schaden: %d", attacker or "none", player or "none", getWeaponNameFromID(weapon), bodypart, amount)
end

function pedGotKilled(ped, killer)
	if killer and ped then
		
	end
end

addEventHandler("onPlayerWasted", root,
	function(totalAmmo, killer, killerWeapon, bodypart)
		local zone = getElementZoneName(source)
		killLog:write(killer and killer:getName() or "none", source:getName(), killerWeapon, zone)
	end
)