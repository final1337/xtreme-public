
Zugfuehrer = {veh = {}};

addEvent("Zugfuehrer.start",true)
addEventHandler("Zugfuehrer.start",root,function()
	if(not(isElement(Zugfuehrer.client[veh])))then
		if(isElement(Zugfuehrer.veh[client]))then destroyElement(Zugfuehrer.veh[client])end
		Zugfuehrer.veh[client] = createVehicle(537, -1943.900390625, 142.5, 27.200000762939, 0, 0, 358,"Xtreme");
		warpPedIntoVehicle(client,Zugfuehrer.veh[client]);
		infobox(client,loc("JOB_ZUGFUEHRER_START",client),0,120,0);
		triggerClientEvent(client,"Zugfuehrer.createMarker",client,"create","start");
		triggerClientEvent(client,"dxClassClose",client);
		
		addEventHandler("onVehicleExit",Zugfuehrer.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,-1972.4417724609,116.78230285645,27.694049835205);
				setPedRotation(player,180);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Zugfuehrer.createMarker",player);
			end
		end)
	end
end)

addEvent("Zugfuehrer.abgabe",true)
addEventHandler("Zugfuehrer.abgabe",root,function()
	destroyElement(Zugfuehrer.veh[client]);
	setTimer(function(client)
		if(isElement(client))then
			setElementPosition(client,-1972.4417724609,116.78230285645,27.694049835205);
			setPedRotation(client,360);
		end
	end,50,1,client)
	infobox(client,loc("JOB_ZUGFUEHRER_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+Zugfuehrer.lohn);
	Levelsystem.givePoints(client,Zugfuehrer.lohn/50);
	triggerClientEvent(client,"Zugfuehrer.createMarker",client);
end)

function Zugfuehrer.destroyStuff(player)
	if(isElement(Zugfuehrer.veh[player]))then
		destroyElement(Zugfuehrer.veh[player]);
	end
	triggerClientEvent(player,"Zugfuehrer.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Zugfuehrer.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Zugfuehrer.destroyStuff(source)end)