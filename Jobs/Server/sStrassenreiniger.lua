
Strassenreiniger = {veh = {}};

addEvent("Strassenreiniger.start",true)
addEventHandler("Strassenreiniger.start",root,function()
	if(not(isElement(Strassenreiniger.veh[client])))then
		if(isElement(Strassenreiniger.veh[client]))then destroyElement(Strassenreiniger.veh[client])end
		Strassenreiniger.veh[client] = createVehicle(574,-2099.6657714844,-15.833800315857,35.114200592041,0,0,270,"Xtreme");
		warpPedIntoVehicle(client,Strassenreiniger.veh[client]);
		infobox(client,loc("JOB_STRASSENREINIGER_START",client),0,120,0);
		triggerClientEvent(client,"Strassenreiniger.createMarker",client,"create","start");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Strassenreiniger");
		
		addEventHandler("onVehicleExit",Strassenreiniger.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,-2102.0009765625,-19.807899475098,35.320301055908);
				setPedRotation(player,270);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Strassenreiniger.createMarker",player);
			end
		end)
	end
end)

addEvent("Strassenreiniger.abgabe",true)
addEventHandler("Strassenreiniger.abgabe",root,function()
	destroyElement(Strassenreiniger.veh[client]);
	infobox(client,loc("JOB_STRASSENREINIGER_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+800);
	Levelsystem.givePoints(client,800/50);
	setTimer(function(client)
		if(isElement(client))then
			setElementPosition(client,-2102.0009765625,-19.807899475098,35.320301055908);
			setPedRotation(client,270);
		end
	end,50,1,client)
	local rnd = math.random(1,2)
	local item = client:addItem(86, rnd, "none", false)
	item:merge()
	client:sendNotification("ITEM_FOUND", 255, 255, 0, "Gummi")			
	triggerClientEvent(client,"Strassenreiniger.createMarker",client);
end)

function Strassenreiniger.destroyStuff(player)
	if(isElement(Strassenreiniger.veh[player]))then
		destroyElement(Strassenreiniger.veh[player]);
	end
	triggerClientEvent(player,"Strassenreiniger.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Strassenreiniger.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Strassenreiniger.destroyStuff(source)end)