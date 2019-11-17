--

KrankenhausZeit = 60;

Krankenhaus = {
	moneyPickup = {},
	deathPickup = {},
	timer = {},
	death = {}
};

function putPlayerInHospital(player, time)
	time = time or KrankenhausZeit;
	if isTimer(Krankenhaus.timer[player]) then
		killTimer(Krankenhaus.timer[player])
	end
	Krankenhaus.death[player] = getRealTime().timestamp;
	Krankenhaus.timer[player] = setTimer(function(player)
		Krankenhaus.death[player] = nil
		setElementData(player, "ShowHUD", true);
		newSpawnPlayer(player);
		triggerClientEvent(player, "Krankenhaus.stop", player);
		source:setData("Krankenhaus", 0)
	end, time * 1000, 1, player)
	triggerClientEvent(player, "Krankenhaus.start", player, time);
end

addEventHandler("onPlayerWasted",root,function(_,attacker,weapon)
	if(isElement(Krankenhaus.moneyPickup[source]))then destroyElement(Krankenhaus.moneyPickup[source])end
	if(isElement(Krankenhaus.deathPickup[source]))then destroyElement(Krankenhaus.deathPickup[source])end
	local money = getElementData(source,"Geld");
	local x,y,z = getElementPosition(source);

	source:setData("Tode", source:getData("Tode") + 1)

	if isElement(attacker) then
		attacker:setData("Kills", attacker:getData("Kills") + 1)
		outputSpy("kill", "%s wurde von %s getötet! (Waffe: %s)", source, attacker, getWeaponNameFromID(weapon))
	else
		outputSpy("kill", "%s ist gestorben.", source)
	end

	if(attacker)then
		if((getElementData(attacker,"Fraktion") == 1 or getElementData(attacker,"Fraktion") == 2 or getElementData(attacker,"Fraktion") == 3 ) and getElementData(attacker,"Duty"))then
			if(getElementData(source,"Wanteds") >= 1)then
				setElementData(source,"Knastzeit", tonumber(getElementData(source,"Wanteds"))*2+5)
				setTimer(newSpawnPlayer, 100, 1, source)
				attacker:giveMoney(getElementData(source,"Wanteds")*100)
				fraktionskassen[getElementData(attacker,"Fraktion")] = fraktionskassen[getElementData(attacker,"Fraktion")] + getElementData(source,"Wanteds")*100
				setElementData(source,"Wanteds", 0)
				outputChatBox(getPlayerName(source).." wurde von "..Fraktionen["Rangnamen"][getElementData(attacker,"Fraktion")][getElementData(attacker,"Rang")+1].." "..getPlayerName(attacker).." eingesperrt!",root,110,110,110);
				return
			end
		end
	end

	if(money >= 1)then
		Krankenhaus.moneyPickup[source] = createPickup(x,y,z,3,1212,50);
		setElementData(Krankenhaus.moneyPickup[source],"Geld",math.floor(money/4));
		setElementData(source,"Geld",getElementData(source,"Geld")-math.floor(money/4));
		addEventHandler("onPickupHit",Krankenhaus.moneyPickup[source],function(player)
			if(not(isPedDead(player)) and not(isPedInVehicle(player)))then
				local money = getElementData(source,"Geld");
				setElementData(player,"Geld",getElementData(player,"Geld")+money);
				infobox(player,"Du hast "..money.."€ gefunden.",0,120,0);
				destroyElement(source);
			end
		end)
	end

	putPlayerInHospital(source);
end)

addEventHandler("onPlayerQuit", root, function()
	if isTimer(Krankenhaus.timer[source]) then
		killTimer(Krankenhaus.timer[source])
	end
	if Krankenhaus.death[source] then
		local diff = getRealTime().timestamp - Krankenhaus.death[source];
		source:setData("Krankenhaus", KrankenhausZeit - diff)
	end
end, true, "high")