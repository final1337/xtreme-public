

Landwirt = {veh = {}};

addEvent("Landwirt.start",true)
addEventHandler("Landwirt.start",root,function()
	if(not(isElement(Landwirt.veh[client])))then
		if(isElement(Landwirt.veh[client]))then destroyElement(Landwirt.veh[client])end
		Landwirt.veh[client] = createVehicle(531,-1192.0454101563,-1054.5201416016,129.22520446777,0,0,270,"Xtreme");
		warpPedIntoVehicle(client,Landwirt.veh[client]);
		infobox(client,loc("JOB_LANDWIRT_START",client),0,120,0);
		triggerClientEvent(client,"Landwirt.createMarker",client,"create");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Landwirt");
		
		addEventHandler("onVehicleExit",Landwirt.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,-1060.8725585938,-1192.1557617188,129.21879577637);
				setPedRotation(player,270);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Landwirt.createMarker",player);
			end
		end)
	end
end)

addEvent("Landwirt.abgabe",true)
addEventHandler("Landwirt.abgabe",root,function()
	infobox(client,loc("JOB_LANDWIRT_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+100);
	Levelsystem.givePoints(client,100/50);
end)

function Landwirt.destroyStuff(player)
	if(isElement(Landwirt.veh[player]))then
		destroyElement(Landwirt.veh[player]);
	end
	triggerClientEvent(player,"Landwirt.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Landwirt.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Landwirt.destroyStuff(source)end)