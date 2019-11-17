Drogentruck = {
	["Active"] = {
		[5] = false,
		[6] = false,
		[7] = false,
		[8] = false,
	},
};

Drogentruck.marker = createMarker(1709.5328369141,701.48101806641,9.770299911499,"cylinder",2,0,0,255);

addEventHandler("onMarkerHit",Drogentruck.marker,function(player)
	if(not(isPedInVehicle(player)) and isRifa(player) or isDNB(player) or isMafia(player) or isNordic(player))then
		if(getElementDimension(player) == getElementDimension(source))then
			local fkasse = fraktionskassen[getElementData(player,"Fraktion")]
			triggerClientEvent(player,"Drogentruck.openWindow",player,fkasse);
		end
	end
end)

addEvent("Drogentruck.start",true)
addEventHandler("Drogentruck.start",root,function()
	if(isRifa(client) or isDNB(client) or isMafia(client) or isNordic(client))then
		if(Drogentruck["Active"][getElementData(client,"Fraktion")] == false)then
			local fkasse = fraktionskassen[getElementData(client,"Fraktion")]
			if(fkasse >= 10000)then
				local vehicle = createVehicle(455,1705.5919189453,682.490234375,10.8203125,0,0,0);
				warpPedIntoVehicle(client,vehicle);
				infobox(client,"Bringe den Transporter nun zu deiner Base!",0,120,0);

				outputChatBox("[#ff0000ROB#ffffff] Ein Drogentransporter wurde beladen!",root,255,255,255,true);
				fraktionskassen[getElementData(client,"Fraktion")] = fraktionskassen[getElementData(client,"Fraktion")] - 10000

				Drogentruck["Active"][getElementData(client,"Fraktion")] = true;
				triggerClientEvent(client,"Drogentruck.createMarker",client,"create");
				triggerClientEvent(client,"dxClassClose",client);
				
				addEventHandler("onVehicleExit",vehicle,function(player)
					triggerClientEvent(player,"Drogentruck.createMarker",player);
				end)
				
				addEventHandler("onVehicleEnter",vehicle,function(player)
					if(getPedOccupiedVehicleSeat(player) == 0)then
						if(isRifa(player) or isDNB(player) or isMafia(player) or isNordic(player))then
							triggerClientEvent(player,"Drogentruck.createMarker",player,"create");
						else
							exitVehicle(player);
							infobox(player,"Du bist nicht befugt, dieses Fahrzeug zu fahren!",120,0,0);
						end
					end
				end)
				
				addEventHandler("onVehicleExplode",vehicle,function()
					destroyElement(source);
					outputChatBox("[#ff0000ROB#ffffff] Ein Drogentransporter wurde zerstört aufgefunden!",root,255,255,255,true);
				end)
				
				setTimer(function(faction)
					Drogentruck["Active"][faction] = false;
					sendFactionMessage(faction,"[#00ff00ROB#ffffff] Ihr könnt wieder einen Drogentransporter starten.",255,255,255);
				end,3600000,1,getElementData(client,"Fraktion"))
			else infobox(client,"In eurer Fraktionskasse befindet sich nicht mehr genug Geld! (10.000€)",120,0,0)end
		else infobox(client,"Deine Fraktion hat vor kurzem bereits einen Drogentransporter gestartet!",120,0,0)end
	end
end)

addEvent("Drogentruck.abgabe",true)
addEventHandler("Drogentruck.abgabe",root,function()
	fraktionskassen[getElementData(client,"Fraktion")] = fraktionskassen[getElementData(client,"Fraktion")] + 20000
	destroyElement(getPedOccupiedVehicle(client));
	outputChatBox("[#ff0000ROB#ffffff] Ein Drogentransporter wurde abgegeben!",root,255,255,255,true);
	Levelsystem.givePoints(client,150);
	triggerClientEvent(client,"Drogentruck.createMarker",client);
end)

function Drogentruck.destroyStuff(player)
	triggerClientEvent(player,"Drogentruck.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Drogentruck.destroyStuff(source) end)