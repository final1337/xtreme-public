Waffentransporter = {playersInMarker = 0, boat = {}, active = false,
	["Boote"] = {
		{2100.9777832031,-113.59909820557,0.0049999998882413,0,0,96.04248046875},
		{2090.3371582031,-116.8371963501,0.0049999998882413,0,0,96.04248046875},
		{2093.3933105469,-111.57720184326,0,0,0,96.047729492188},
		{2094.6381835938,-106.68509674072,0.0049999998882413,0,0,96.04248046875},
		{2087.5517578125,-104.42109680176,0.0049999998882413,0,0,96.04248046875},
	},
};

Waffentransporter.startMarker = createMarker(2160.6528320313,-98.114196777344,1.1059999465942,"cylinder",3,255,255,0,150);

addEventHandler("onMarkerHit",Waffentransporter.startMarker,function(player)
	if(not(isPedInVehicle(player)) and getElementDimension(player) == getElementDimension(source))then
		if(isNordic(player) or isRifa(player) or isDNB(player) or isMafia(player))then
			Waffentransporter.playersInMarker = Waffentransporter.playersInMarker + 1;
			if(Waffentransporter.playersInMarker >= 3)then
				triggerClientEvent(player,"Waffentransporter.createWindow",player);
			end
		elseif(isTerrorist(player))then
			triggerClientEvent(player,"Waffentransporter.createTerrorWindow",player);
		end
	end
end)

addEventHandler("onMarkerLeave",Waffentransporter.startMarker,function(player)
	if(getElementDimension(player) == getElementDimension(source))then
		if(Waffentransporter.playersInMarker > 0)then
			Waffentransporter.playersInMarker = Waffentransporter.playersInMarker - 1;
		end
	end
end)

addEvent("Waffentransporter.start",true)
addEventHandler("Waffentransporter.start",root,function()
	if(Waffentransporter.active == false)then
		local id = 0;
		Waffentransporter.active = true;
		for _,v in pairs(getElementsByType("player"))do
			if(isElementWithinMarker(v,Waffentransporter.startMarker))then
				id = id + 1;
				local tbl = Waffentransporter["Boote"][id];
				Waffentransporter.boat[id] = createVehicle(473,tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6]);
				warpPedIntoVehicle(v,Waffentransporter.boat[id]);
				triggerClientEvent(v,"Waffentransporter.createMarker",v,"create");
				
				addEventHandler("onVehicleEnter",Waffentransporter.boat[id],function(player)
					if(getPedOccupiedVehicleSeat(player))then
						if(isMafia(player) or isNordic(player) or isDNB(player) or isRifa(player))then
							triggerClientEvent(player,"Waffentransporter.createMarker",player,"create");
						else
							ExitVehicle(player);
						end
					end
				end)
				
				addEventHandler("onVehicleExit",Waffentransporter.boat[id],function(player)
					triggerClientEvent(player,"Waffentransporter.createMarker",player);
				end)
				
				addEventHandler("onVehicleExplode",Waffentransporter.boat[id],function()
					outputChatBox("[#ff0000ROB#ffffff] Ein Boot des Waffentransportes wurde zerstört aufgefunden!",root,255,255,255,true);
					destroyElement(source);
					if(#Waffentransporter.boat == 0)then
						outputChatBox("[#ff0000ROB#ffffff] Alle Boote des Waffentransportes wurden zerstört aufgefunden!",root,255,255,255,true);
					end
				end)
				
				if(id >= 5)then break end
			end
		end
		outputChatBox("[#ff0000ROB#ffffff] Ein Waffentransport wurde gestartet!",root,255,255,255,true);
		setTimer(function()
			Waffentransporter.active = false;
		end,3600000,1)
		triggerClientEvent(client,"dxClassClose",client);
	else infobox(client,"Vor kurzem wurde bereits ein Waffentransporter gestartet!",120,0,0)end
end)

addEvent("Waffentransporter.terrorStart",true)
addEventHandler("Waffentransporter.terrorStart",root,function()
	if(Waffentransporter.active == false)then
		Waffentransporter.active = true;
		Waffentransporter.terrorVehicle = createVehicle(456,2218.8664550781,-52.263698577881,26.734399795532,0,0,0,"Xtreme");
		warpPedIntoVehicle(client,Waffentransporter.terrorVehicle);
		
		triggerClientEvent(client,"Waffentransporter.createMarker",client,"create");

		addEventHandler("onVehicleEnter",Waffentransporter.terrorVehicle,function(player)
			if(getPedOccupiedVehicleSeat(player) == 0)then
				if(isTerrorist(player))then
					triggerClientEvent(player,"Waffentransporter.createMarker",player,"create");
				else
					ExitVehicle(player);
				end
			end
		end)
				
		addEventHandler("onVehicleExit",Waffentransporter.terrorVehicle,function(player)
			triggerClientEvent(player,"Waffentransporter.createMarker",player);
		end)
		
		addEventHandler("onVehicleExplode",Waffentransporter.terrorVehicle,function(player)
			outputChatBox("[#ff0000ROB#ffffff] Der Waffentransporter wurde zerstört aufgefunden!",root,255,255,255,true);
			destroyElement(source);
		end)
		
		outputChatBox("[#ff0000ROB#ffffff] Ein Waffentransporter wurde beladen!",root,255,255,255,true);
		setTimer(function()
			Waffentransporter.active = false;
		end,3600000,1)
		triggerClientEvent(client,"dxClassClose",client);
	else infobox(client,"Vor kurzem wurde bereits ein Waffentransporter gestartet!",120,0,0)end	
end)

addEvent("Waffentransporter.abgabe",true)
addEventHandler("Waffentransporter.abgabe",root,function()
	destroyElement(getPedOccupiedVehicle(client));
	if(isTerrorist(client))then
		local item = itemmanager:add(Weapon_To_Database[30],client:getId(),client:getId(),client:getId(),300,0,0,100,0,"none",client.m_Storages[1]);
		client.m_Storages[1]:addItem(item);
		local item = itemmanager:add(Weapon_To_Database[35],client:getId(),client:getId(),client:getId(),5,0,0,100,0,"none",client.m_Storages[1]);
		client.m_Storages[1]:addItem(item);
		local item = client:addItem(73, 10, "none", false)
		item:merge()
	else
		local item = itemmanager:add(Weapon_To_Database[24],client:getId(),client:getId(),client:getId(),35,0,0,100,0,"none",client.m_Storages[1]);
		client.m_Storages[1]:addItem(item);
		local item = itemmanager:add(Weapon_To_Database[29],client:getId(),client:getId(),client:getId(),120,0,0,100,0,"none",client.m_Storages[1]);
		client.m_Storages[1]:addItem(item);
		local item = itemmanager:add(Weapon_To_Database[31],client:getId(),client:getId(),client:getId(),200,0,0,100,0,"none",client.m_Storages[1]);
		client.m_Storages[1]:addItem(item);
	end
	Levelsystem.givePoints(client,150);
	triggerClientEvent(client,"Waffentransporter.createMarker",client);
end)