
Busfahrer = {veh = {}};

addEvent("Busfahrer.start",true)
addEventHandler("Busfahrer.start",root,function()
	if(not(isElement(Busfahrer.veh[client])))then
		if(isElement(Busfahrer.veh[client]))then destroyElement(Busfahrer.veh[client])end
		Busfahrer.veh[client] = createVehicle(431,-2267.6999511719,168.30000305176,35.400001525879,0,0,270,"Xtreme");
		warpPedIntoVehicle(client,Busfahrer.veh[client]);
		 infobox(client,loc("JOB_BUSFAHRER_START",client),0,120,0);
		triggerClientEvent(client,"Busfahrer.createMarker",client,"create","start");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Busfahrer");
		
		addEventHandler("onVehicleExit",Busfahrer.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,-2270.2900390625,174.47979736328,35.3125);
				setPedRotation(player,180);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Busfahrer.createMarker",player);
			end
		end)
	end
end)

addEvent("Busfahrer.abgabe",true)
addEventHandler("Busfahrer.abgabe",root,function()
	if getElementModel(getPedOccupiedVehicle(client)) == 431 then
		destroyElement(Busfahrer.veh[client]);
		setTimer(function(client)
			if(isElement(client))then
				setElementPosition(client,-2270.2900390625,174.47979736328,35.3125);
				setPedRotation(client,180);
			end
		end,50,1,client)
		infobox(client,loc("JOB_BUSFAHRER_FINISHED",client),0,120,0);
		setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+1850);
		Levelsystem.givePoints(client,1850/50);
		triggerClientEvent(client,"Busfahrer.createMarker",client);
	else infobox(client, "Netter Versuch.", 200, 200, 0) end
end)

function Busfahrer.destroyStuff(player)
	if(isElement(Busfahrer.veh[player]))then
		destroyElement(Busfahrer.veh[player]);
	end
	triggerClientEvent(player,"Busfahrer.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Busfahrer.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Busfahrer.destroyStuff(source)end)