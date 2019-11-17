
Muellmann = {veh = {}};

addEvent("Muellmann.start",true)
addEventHandler("Muellmann.start",root,function()
	if(not(isElement(Muellmann.veh[client])))then
		if(isElement(Muellmann.veh[client]))then destroyElement(Muellmann.veh[client])end
		Muellmann.veh[client] = createVehicle(408,-1891.6318359375,-1693.5131835938,22.49049949646,0,0,272.32946777344,"Xtreme");
		warpPedIntoVehicle(client,Muellmann.veh[client]);
		infobox(client,loc("JOB_MUELLMANN_START",client),0,120,0);
		triggerClientEvent(client,"Muellmann.createObjects",client,"create");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Muellmann");
		
		addEventHandler("onVehicleExit",Muellmann.veh[client],function(player,seat)
			if(seat == 0)then
				destroyElement(source);
				setElementPosition(player,-1893.5028076172,-1685.2628173828,23.015600204468);
				setPedRotation(player,270);
				infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
				triggerClientEvent(player,"Muellmann.createObjects",player);
			end
		end)
	end
end)

addEvent("Muellmann.finish",true)
addEventHandler("Muellmann.finish",root,function()
	destroyElement(Muellmann.veh[client]);
	triggerClientEvent(client,"Muellmann.createObjects",client);
	setTimer(function(client)
		if(client)then
			setElementPosition(client,-1893.5028076172,-1685.2628173828,23.015600204468);
			setPedRotation(client,270);
		end
	end,50,1,client)
	infobox(client,loc("JOB_MUELLMANN_FINISHED",client),0,120,0);
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+600);
	Levelsystem.givePoints(client,600/50);
	local rnd = math.random(1,5)
	local item = client:addItem(53, rnd, "none", false)
	item:merge()
	client:sendNotification("ITEM_FOUND", 255, 255, 0, "Eisen")	
	rnd = math.random(1,10)
	item = client:addItem(86, rnd, "none", false)
	item:merge()
	client:sendNotification("ITEM_FOUND", 255, 255, 0, "Gummi")		
end)

function Muellmann.destroyStuff(player)
	if(isElement(Muellmann.veh[player]))then
		destroyElement(Muellmann.veh[player]);
	end
	triggerClientEvent(player,"Muellmann.createObjects",player);
end
addEventHandler("onPlayerWasted",root,function() Muellmann.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Muellmann.destroyStuff(source)end)