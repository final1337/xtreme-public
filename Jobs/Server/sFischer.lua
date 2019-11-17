

Fischer = {veh = {}};

addEvent("Fischer.start",true)
addEventHandler("Fischer.start",root,function()
	if(not(isElement(Fischer.veh[client])))then
		if(isElement(Fischer.veh[client]))then destroyElement(Fischer.veh[client])end
		Fischer.veh[client] = createVehicle(453,-1718.9123535156,1435.7150878906,0,0,0,0,"Xtreme");
		warpPedIntoVehicle(client,Fischer.veh[client]);
		infobox(client,loc("JOB_FISCHER_START",client),0,120,0);
		triggerClientEvent(client,"Fischer.createMarker",client,"create");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Fischer");
		
		addEventHandler("onVehicleExit",Fischer.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,-1726.1511230469,1435.4931640625,1.4067000150681);
				setPedRotation(player,270);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Fischer.createMarker",player);
			end
		end)
	end
end)

addEvent("Fischer.abgabe",true)
addEventHandler("Fischer.abgabe",root,function()
	destroyElement(Fischer.veh[client]);
	local fische = math.floor(getElementData(client,"FischerjobFische"));
	local gehalt = math.floor(fische*1.7);
	infobox(client,loc("JOB_FISCHER_GEHALT",client):format(fische,gehalt),0,120,0);
	Levelsystem.givePoints(client,gehalt/50);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+gehalt);
	setTimer(function(client)
		if(isElement(client))then
			setElementPosition(client,-1726.1511230469,1435.4931640625,1.4067000150681);
			setPedRotation(client,270);
		end
	end,50,1,client)
	triggerClientEvent(client,"Fischer.createMarker",client);
end)

function Fischer.destroyStuff(player)
	if(isElement(Fischer.veh[player]))then
		destroyElement(Fischer.veh[player]);
	end
	triggerClientEvent(player,"Fischer.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Fischer.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Fischer.destroyStuff(source)end)