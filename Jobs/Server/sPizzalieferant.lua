

Pizzalieferant = {veh = {}};

addEvent("Pizzalieferant.start",true)
addEventHandler("Pizzalieferant.start",root,function()
	if(not(isElement(Pizzalieferant.veh[client])))then
		if(isElement(Pizzalieferant.veh[client]))then destroyElement(Pizzalieferant.veh[client])end
		Pizzalieferant.veh[client] = createVehicle(448,2100.0734863281,-1784.6715087891,13.067099571228,0,0,0,"Xtreme");
		warpPedIntoVehicle(client,Pizzalieferant.veh[client]);
		infobox(client,loc("JOB_PIZZALIEFERANT_START",client),0,120,0);
		triggerClientEvent(client,"Pizzalieferant.createMarker",client,"create","start");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Pizzalieferant");
		
		addEventHandler("onVehicleExit",Pizzalieferant.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,2101.0012207031,-1801.2839355469,13.5546875);
				setPedRotation(player,180);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Pizzalieferant.createMarker",player);
			end
		end)
	end
end)

addEvent("Pizzalieferant.abgabe",true)
addEventHandler("Pizzalieferant.abgabe",root,function()
	destroyElement(Pizzalieferant.veh[client]);
	infobox(client,loc("JOB_PIZZALIEFERANT_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+140);
	Levelsystem.givePoints(client,140/50);
	setTimer(function(client)
		if(isElement(client))then
			setElementPosition(client,2101.0012207031,-1801.2839355469,13.5546875);
			setPedRotation(client,180);
		end
	end,50,1,client)
	triggerClientEvent(client,"Pizzalieferant.createMarker",client);
end)

function Pizzalieferant.destroyStuff(player)
	if(isElement(Pizzalieferant.veh[player]))then
		destroyElement(Pizzalieferant.veh[player]);
	end
	triggerClientEvent(player,"Pizzalieferant.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Pizzalieferant.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Pizzalieferant.destroyStuff(source)end)