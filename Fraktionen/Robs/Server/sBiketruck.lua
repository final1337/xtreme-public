Biketruck = {active = false, vehicles = {}, markers = {}, ID = 0,
	["Bikes"] = {
		471,468,586,462,461,
	},
	["Spawn"] = {
		{-2240.2053222656,116.30940246582,34.917301177979,180,-2240.2053222656,114.5179977417,34.309299468994},
		{-2235.8056640625,116.30940246582,34.924999237061,180,-2235.8056640625,114.5179977417,34.309299468994},
		{-2231.2001953125,116.30940246582,34.924999237061,180,-2231.2001953125,114.5179977417,34.309299468994},
		{-2226.7023925781,116.30940246582,34.924999237061,180,-2226.7023925781,114.5179977417,34.309299468994},
		{-2222.1391601563,116.30940246582,34.924999237061,180,-2222.1391601563,114.5179977417,34.309299468994},
		{-2217.4895019531,116.30940246582,34.924999237061,180,-2217.4895019531,114.5179977417,34.309299468994},
		{-2212.9145507813,116.30940246582,34.924999237061,180,-2212.9145507813,114.5179977417,34.309299468994},
	},
	["Preise"] = {
		[471] = 50000,
		[468] = 35000,
		[586] = 25000,
		[462] = 15000,
		[461] = 40000,
	},
};

Biketruck.marker = createMarker(2793.5720214844,-2396.5141601563,12.648599624634,"cylinder",1.5,0,0,255);

function Biketruck.loadShop()
	Biketruck.ID = 0;
	for _,v in pairs(Biketruck.vehicles)do destroyElement(v) end
	for _,v in pairs(Biketruck.markers)do destroyElement(v) end
	Biketruck.vehicles = {}; Biketruck.markers = {};
	local node = xmlLoadFile("XML/Bikeshop.xml");
	for i,v in ipairs(xmlNodeGetChildren(node))do
		local model = tonumber(xmlNodeGetAttribute(v,"model"));
		if(tonumber(model) > 0)then
			Biketruck.ID = Biketruck.ID + 1;
			local x,y,z,rot = Biketruck["Spawn"][Biketruck.ID][1],Biketruck["Spawn"][Biketruck.ID][2],Biketruck["Spawn"][Biketruck.ID][3],Biketruck["Spawn"][Biketruck.ID][4];
			Biketruck.vehicles[Biketruck.ID] = createVehicle(model,x,y,z,0,0,rot);
			Biketruck.markers[Biketruck.ID] = createMarker(Biketruck["Spawn"][Biketruck.ID][5],Biketruck["Spawn"][Biketruck.ID][6],Biketruck["Spawn"][Biketruck.ID][7]+0.1,"cylinder",1,0,0,255);
			setElementFrozen(Biketruck.vehicles[Biketruck.ID],true);
			setVehicleDamageProof(Biketruck.vehicles[Biketruck.ID],true);
			setElementData(Biketruck.markers[Biketruck.ID],"BiketruckMarkerID",Biketruck.ID);
			
			addEventHandler("onMarkerHit",Biketruck.markers[Biketruck.ID],function(player)
				if(not(isPedInVehicle(player)))then
					if(getElementDimension(player) == getElementDimension(source))then
						setElementData(player,"BiketruckMarkerID",getElementData(source,"BiketruckMarkerID"));
						triggerClientEvent(player,"Autohaus.openWindow",player,model,Biketruck["Preise"][model]);
					end
				end
			end)
		end
	end
	xmlUnloadFile(node);
end
Biketruck.loadShop();

function Biketruck.deleteVehicle(ID)
	local node = xmlLoadFile("XML/Bikeshop.xml");
	local bikenode = xmlFindChild(node,"bike",ID);
	xmlNodeSetAttribute(bikenode,"model","0");
	xmlSaveFile(node);
	xmlUnloadFile(node);
	Biketruck.loadShop();
end

addEventHandler("onMarkerHit",Biketruck.marker,function(player)
	if(not(isPedInVehicle(player)) and isNordic(player))then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"Biketruck.openWindow",player);
		end
	end
end)

addEvent("Biketruck.start",true)
addEventHandler("Biketruck.start",root,function()
	if(isNordic(client))then
		local fkasse = fraktionskassen[getElementData(client,"Fraktion")]
		if(fkasse >= 10000)then
			if(Biketruck.active == false)then
				local bike = Biketruck["Bikes"][math.random(1,#Biketruck["Bikes"])];
				Biketruck.walton = createVehicle(478,2779.1711425781,-2403.1960449219,13.730400085449,0,0,90,"Xtreme");
				Biketruck.bike = createVehicle(bike,0,0,0,0,0,0,"Xtreme");
				attachElements(Biketruck.bike,Biketruck.walton,0,-1.5,0.5);
				warpPedIntoVehicle(client,Biketruck.walton);
				infobox(client,"Bringe das Bike zum Bikeshop!",0,120,0);
				outputChatBox("[#ff0000ROB#ffffff] Ein Biketransporter wurde beladen!",root,255,255,255,true);
				triggerClientEvent(client,"dxClassClose",client);
				fraktionskassen[getElementData(client,"Fraktion")] = fraktionskassen[getElementData(client,"Fraktion")] - 10000
				Biketruck.active = true;
				triggerClientEvent(client,"Biketruck.createMarker",client,"create");
				
				addEventHandler("onVehicleExit",Biketruck.walton,function(player)
					triggerClientEvent(player,"Biketruck.createMarker",player);
				end)
				
				addEventHandler("onVehicleEnter",Biketruck.walton,function(player)
					if(getPedOccupiedVehicleSeat(player) == 0)then
						if(isNordic(player))then
							triggerClientEvent(player,"Biketruck.createMarker",player,"create");
						else
							exitVehicle(player);
							infobox(player,"Du bist nicht befugt, dieses Fahrzeug zu fahren!",120,0,0);
						end
					end
				end)
				
				addEventHandler("onVehicleExplode",Biketruck.walton,function()
					destroyElement(source);
					destroyElement(Biketruck.bike);
					outputChatBox("[#ff0000ROB#ffffff] Der Biketransporter wurde zerstört aufgefunden!",root,255,255,255,true);
				end)
				
				setTimer(function()
					Biketruck.active = false;
					sendFactionMessage(8,"[#00ff00ROB#ffffff] Ihr könnt wieder einen Biketransporter beladen.",255,255,255);
				end,3600000,1)
			else infobox(client,"Vor kurzem wurde bereits ein Biketransport gestartet!",120,0,0)end
		else infobox(client,"In eurer Fraktionskasse befindet sich nicht mehr genug Geld! (10.000€)",120,0,0)end
	else infobox(client,"Du bist kein Mitglied der Nordic Angels!",120,0,0)end
end)

addEvent("Biketruck.abgabe",true)
addEventHandler("Biketruck.abgabe",root,function()
	if(#Biketruck.vehicles < 7)then
		local node = xmlLoadFile("XML/Bikeshop.xml");
		local bikenode = xmlFindChild(node,"bike",Biketruck.ID);
		xmlNodeSetAttribute(bikenode,"model",getElementModel(Biketruck.bike));
		xmlSaveFile(node);
		xmlUnloadFile(node);
		Biketruck.loadShop();
	else infobox(client,"Der Shop ist bereits voll!",120,0,0) end
	Levelsystem.givePoints(client,150);
	triggerClientEvent(client,"Biketruck.createMarker",client);
	outputChatBox("[#ff0000ROB#ffffff] Der Biketransporter wurde abgegeben!",root,255,255,255,true);
	destroyElement(Biketruck.walton);
	destroyElement(Biketruck.bike);
end)

function Biketruck.destroyStuff(player)
	triggerClientEvent(player,"Biketruck.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Biketruck.destroyStuff(source) end)