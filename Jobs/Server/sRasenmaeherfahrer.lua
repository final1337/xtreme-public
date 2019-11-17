

Rasenmaeherfahrer = {veh = {}};

addEvent("Rasenmaeherfahrer.start",true)
addEventHandler("Rasenmaeherfahrer.start",root,function()
	if(not(isElement(Rasenmaeherfahrer.veh[client])))then
		if(isElement(Rasenmaeherfahrer.veh[client]))then destroyElement(Rasenmaeherfahrer.veh[client])end
		Rasenmaeherfahrer.veh[client] = createVehicle(572,2014.8631591797,-1279.5943603516,23.460300445557,0,0,0,"Xtreme");
		warpPedIntoVehicle(client,Rasenmaeherfahrer.veh[client]);
		infobox(client,loc("JOB_RASENMAEHER_START",client),0,120,0);
		triggerClientEvent(client,"Rasenmaeherfahrer.createMarker",client,"create");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Rasenmaeherfahrer");
		
		addEventHandler("onVehicleExit",Rasenmaeherfahrer.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,2013.1016845703,-1283.2025146484,23.974166870117);
				setPedRotation(player,360);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Rasenmaeherfahrer.createMarker",player);
			end
		end)
	end
end)

addEvent("Rasenmaeherfahrer.abgabe",true)
addEventHandler("Rasenmaeherfahrer.abgabe",root,function()
	infobox(client,loc("JOB_RASENMAEHER_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+100);
	Levelsystem.givePoints(client,100/50);
end)

function Rasenmaeherfahrer.destroyStuff(player)
	if(isElement(Rasenmaeherfahrer.veh[player]))then
		destroyElement(Rasenmaeherfahrer.veh[player]);
	end
	triggerClientEvent(player,"Rasenmaeherfahrer.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Rasenmaeherfahrer.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Rasenmaeherfahrer.destroyStuff(source)end)