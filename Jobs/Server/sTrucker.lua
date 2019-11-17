
Trucker = {veh = {}, trailer = {}, trailerTimer = {}};

addEvent("Trucker.start",true)
addEventHandler("Trucker.start",root,function()
	if(not(isElement(Trucker.veh[client])))then
		if(isElement(Trucker.veh[client]))then destroyElement(Trucker.veh[client])end
		if(isElement(Trucker.trailer[client]))then destroyElement(Trucker.veh[client])end
		if(isTimer(Trucker.trailerTimer[client]))then killTimer(Trucker.trailerTimer[client])end
		Trucker.veh[client] = createVehicle(403,-1833.7221679688,124.95829772949,15.817199707031,0,0,0,"Xtreme");
		Trucker.trailer[client] = createVehicle(591,-1833.8026123047,116.48529815674,15.77140045166,0,0,0);
		warpPedIntoVehicle(client,Trucker.veh[client]);
		infobox(client,loc("JOB_TRUCKER_START",client),0,120,0);
		triggerClientEvent(client,"Trucker.createMarker",client,"create");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Trucker");
		
		Trucker.trailerTimer[player] = setTimer(function(player)
			if(not(isElement(Trucker.veh[player])))then
				if(isElement(Trucker.trailer[player]))then
					destroyElement(Trucker.trailer[player]);
					killTimer(Trucker.trailerTimer[player]);
				end
			end
		end,1000,0,player)
		
		addEventHandler("onVehicleExit",Trucker.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				destroyElement(Trucker.trailer[player]);
				setElementPosition(player,-1830.0871582031,102.53269958496,15.117199897766);
				setPedRotation(player,270);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Trucker.createMarker",player);
			end
		end)
	end
end)

addEvent("Trucker.abgabe",true)
addEventHandler("Trucker.abgabe",root,function()
	local veh = getPedOccupiedVehicle(client);
	local trailer = getVehicleTowedByVehicle(veh);
	if(trailer and trailer == Trucker.trailer[client])then
		destroyElement(Trucker.veh[client]);
		destroyElement(Trucker.trailer[client]);
		killTimer(Trucker.trailerTimer[client]);
		infobox(client,loc("JOB_TRUCKER_FINISHED",client),0,120,0);
		setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+725);
		Levelsystem.givePoints(client,725/50);
		setTimer(function(client)
			if(isElement(client))then
				setElementPosition(client,-1830.0871582031,102.53269958496,15.117199897766);
				setPedRotation(client,270);
			end
		end,50,1,client)
		triggerClientEvent(client,"Trucker.createMarker",client);
	else infobox(client,loc("JOB_TRUCKER_TRAILER",client),120,0,0)end
end)

function Trucker.destroyStuff(player)
	if(isElement(Trucker.veh[player]))then
		destroyElement(Trucker.veh[player]);
		destroyElement(Trucker.trailer[player]);
	end
	triggerClientEvent(player,"Trucker.createMarker",player);
	if(isTimer(Trucker.trailerTimer[player]))then killTimer(Trucker.trailerTimer[player])end
end
addEventHandler("onPlayerWasted",root,function() Trucker.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Trucker.destroyStuff(source)end)