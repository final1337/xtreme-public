

Betonmischerfahrer = {veh = {}};

addEvent("Betonmischerfahrer.start",true)
addEventHandler("Betonmischerfahrer.start",root,function()
	if(not(isElement(Betonmischerfahrer.veh[client])))then
		if(isElement(Betonmischerfahrer.veh[client]))then destroyElement(Betonmischerfahrer.veh[client])end
		Betonmischerfahrer.veh[client] = createVehicle(524,2516.5620117188,-2116.4274902344,14.600099563599,0,0,0,"Xtreme");
		warpPedIntoVehicle(client,Betonmischerfahrer.veh[client]);
		infobox(client,loc("JOB_BETONMISCHER_START",client),0,120,0);
		triggerClientEvent(client,"Betonmischerfahrer.createMarker",client,"create");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Betonmischerfahrer");
		
		addEventHandler("onVehicleExit",Betonmischerfahrer.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,2524.8952636719,-2121.2067871094,13.546899795532);
				setPedRotation(player,0);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Betonmischerfahrer.createMarker",player);
			end
		end)
	end
end)

addEvent("Betonmischerfahrer.abgabe",true)
addEventHandler("Betonmischerfahrer.abgabe",root,function()
	destroyElement(Betonmischerfahrer.veh[client]);
	infobox(client,loc("JOB_BETONMISCHER_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+2000);
	Levelsystem.givePoints(client,2000/50);
	setTimer(function(client)
		if(isElement(client))then
			setElementPosition(client,2524.8952636719,-2121.2067871094,13.546899795532);
			setPedRotation(client,0);
		end
	end,50,1,client)
	triggerClientEvent(client,"Betonmischerfahrer.createMarker",client);
end)

function Betonmischerfahrer.destroyStuff(player)
	if(isElement(Betonmischerfahrer.veh[player]))then
		destroyElement(Betonmischerfahrer.veh[player]);
	end
	triggerClientEvent(player,"Betonmischerfahrer.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Betonmischerfahrer.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Betonmischerfahrer.destroyStuff(source)end)