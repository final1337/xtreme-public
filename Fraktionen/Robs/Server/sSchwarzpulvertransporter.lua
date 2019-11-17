Schwarzpulvertransport = {beladen = false, saveID = nil, vehs = {},
	["Active"] = {
		[5] = false,
		[6] = false,
		[7] = false,
		[8] = false,
		[10] = false,
	},
	["Kisten"] = {
		{964,-786.16729736328,2406.4145507813,155.93170166016,0,0,0},
		{964,-787.57598876953,2406.4091796875,155.90469360352,0,0,0},
		{964,-788.97259521484,2406.4013671875,155.90469360352,0,0,0},
		{964,-788.63439941406,2404.9289550781,155.8883972168,0,0,0},
		{964,-787.2373046875,2404.93359375,155.8883972168,0,0,0},
		{964,-785.84759521484,2404.9340820313,155.91369628906,0,0,0},
	},
	["Gabelstapler"] = {
		{530,-788.04327392578,2399.615234375,156.50970458984,0,0,90},
		{530,-788.04327392578,2397.5910644531,156.50970458984,0,0,90},
	};
};

Schwarzpulvertransport.marker = createMarker(-706.12701416016,2375.9904785156,127.60369873047,"cylinder",2,255,255,0);

addEventHandler("onMarkerHit",Schwarzpulvertransport.marker,function(player)
	if(not(isPedInVehicle(player)) and isRifa(player) or isDNB(player) or isMafia(player) or isNordic(player) or isBallas(player))then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"Schwarzpulvertransport.createWindow",player);
		end
	end
end)

addEvent("Schwarzpulvertransport.start",true)
addEventHandler("Schwarzpulvertransport.start",root,function()
	if(Schwarzpulvertransport["Active"][getElementData(client,"Fraktion")] == false)then
		if #getFactionMembers(11) == 0 then
			client:sendNotification("Es ist kein Terrorist online.")
			return
		end
		if(isRifa(client) or isDNB(client) or isMafia(client) or isNordic(client) or isBallas(client))then
			if(Schwarzpulvertransport.beladen == false and fraktionskassen[getElementData(client, "Fraktion")] >= 20000)then
				Schwarzpulvertransport.beladen = true;
				Schwarzpulvertransport["Active"][getElementData(client,"Fraktion")] = true;
				infobox(client,"Die Terroristen wurden benachrichtig, warte, bis sie das Fahrzeug beladen haben!",0,120,0);
				sendFactionMessage(11,"[#00ff00ROB#ffffff] Ein Schwarzpulvertransporter muss beladen werden!",255,255,255);
				Schwarzpulvertransport.vehicle = createVehicle(455,-696.56170654297,2367.8068847656,129.35459899902,0,0,353.25);
				setElementFrozen(Schwarzpulvertransport.vehicle,true);
				warpPedIntoVehicle(client,Schwarzpulvertransport.vehicle);
				Schwarzpulvertransport.saveID = getElementData(client,"Fraktion");
				Schwarzpulvertransport.beladenMarker = createMarker(-697.61358642578,2360.060546875,126.72830200195,"cylinder",5,150,100,0);
				triggerClientEvent(client,"Schwarzpulvertransport.createMarker",client,"create");
				triggerClientEvent(client,"dxClassClose",client);
				fraktionskassen[getElementData(client, "Fraktion")] = fraktionskassen[getElementData(client, "Fraktion")] - 20000
				
				addEventHandler("onMarkerHit",Schwarzpulvertransport.beladenMarker,function(player)
					if(getElementType(player) == "vehicle")then
						local player = getVehicleOccupant(player,0);
						local veh = getPedOccupiedVehicle(player);
						if(isTerrorist(player) and getElementModel(veh) == 530)then
							if(getElementData(veh,"HasSchwarzpulverKiste") == true)then
								local object = getElementData(veh,"SchwarzpulverKiste");
								destroyElement(object);
								setElementData(getPedOccupiedVehicle(player),"HasSchwarzpulverKiste",false);
								Schwarzpulvertransport.activeKisten = Schwarzpulvertransport.activeKisten - 1;
								if(Schwarzpulvertransport.activeKisten == 0)then
									Schwarzpulvertransport.beladen = false;
									setElementFrozen(Schwarzpulvertransport.vehicle,false);
									sendFactionMessage(Schwarzpulvertransport.saveID,"[#00ff00ROB#ffffff] Euer Schwarzpulvertransporter wurde fertig beladen!",255,255,255);
									for i = 1,2 do destroyElement(Schwarzpulvertransport.vehs[i]) end
									destroyElement(Schwarzpulvertransport.beladenMarker);
									outputChatBox("[#ff0000ROB#ffffff] Ein Schwarzpulvertransporter wurde beladen!",root,255,255,255,true);
									fraktionskassen[getElementData(player, "Fraktion")] = fraktionskassen[getElementData(player, "Fraktion")] + 20000
								end
							end
						end
					end
				end)

				for i,v in ipairs(Schwarzpulvertransport["Kisten"])do
					local kiste = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7]);
					Schwarzpulvertransport.activeKisten = i;
					setElementData(kiste,"SchwarzpulverKiste",true);
					addEventHandler("onElementClicked",kiste,function(button,state,player)
						if(button == "left" and state == "down")then
							local x,y,z = getElementPosition(source);
							if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
								local veh = getPedOccupiedVehicle(player);
								if(isTerrorist(player) and getElementModel(veh) == 530)then
									if(getElementData(veh,"HasSchwarzpulverKiste") ~= true)then
										attachElements(source,veh,0,0.8,0);
										setElementData(veh,"HasSchwarzpulverKiste",true);
										setElementData(veh,"SchwarzpulverKiste",source);
									else infobox(player,"Du hast bereits eine Kiste aufgeladen!",120,0,0)end
								end
							end
						end
					end)
				end
				for i,v in ipairs(Schwarzpulvertransport["Gabelstapler"])do
					Schwarzpulvertransport.vehs[i] = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7]);
					
					setVehicleDamageProof(Schwarzpulvertransport.vehs[i], true)

					addEventHandler("onVehicleEnter",Schwarzpulvertransport.vehs[i],function(player)
						if(getPedOccupiedVehicleSeat(player) == 0)then
							if(isTerrorist(player))then
								infobox(player,"Belade den Schwarzpulvertransporter.",0,120,0);
							else
								ExitVehicle(player);
								infobox(player,"Du bist nicht befugt, dieses Fahrzeug zu fahren!",120,0,0);
							end
						end
					end)
				end
				
				addEventHandler("onVehicleExit",Schwarzpulvertransport.vehicle,function(player)
					triggerClientEvent(player,"Schwarzpulvertransport.createMarker",player);
				end)
				
				addEventHandler("onVehicleEnter",Schwarzpulvertransport.vehicle,function(player)
					if(getPedOccupiedVehicleSeat(player) == 0)then
						if(isRifa(player) or isDNB(player) or isMafia(player) or isNordic(player) or isBallas(player))then
							triggerClientEvent(player,"Schwarzpulvertransport.createMarker",player,"create");
						else
							ExitVehicle(player);
							infobox(player,"Du bist nicht befugt, dieses Fahrzeug zu fahren!",120,0,0);
						end
					end
				end)
				
				addEventHandler("onVehicleExplode",Schwarzpulvertransport.vehicle,function(player)
					Schwarzpulvertransport.beladen = false;
					destroyElement(source);
					outputChatBox("[#ff0000ROB#ffffff] Ein Schwarzpulvertransporter wurde zerstört aufgefunden!",root,255,255,255,true);
					Schwarzpulvertransport.destroyElements();
				end)
				
				setTimer(function(faction)
					Schwarzpulvertransport.beladen = false;
					Schwarzpulvertransport["Active"][faction] = false;
					sendFactionMessage(faction,"[#00ff00ROB#ffffff] Ihr könnt wieder einen Schwarzpulvertransport starten.",255,255,255);
					Schwarzpulvertransport.destroyElements();
				end,3600000,1,getElementData(client,"Fraktion"))
			else infobox(client,"Zurzeit wird bereits ein Schwarzpulvertransport beladen!",120,0,0)end
		else infobox(client,"Du bist nicht befugt, einen Schwarzpulvertransport zu starten!",120,0,0)end
	else infobox(client,"Deine Fraktion hat vor kurzem bereits einen Schwarzpulvertransport beladen!",120,0,0)end
end)

addEvent("Schwarzpulvertransport.abgabe",true)
addEventHandler("Schwarzpulvertransport.abgabe",root,function()
	outputChatBox("[#ff0000ROB#ffffff] Ein Schwarzpulvertransporter wurde abgegeben!",root,255,255,255,true);
	infobox(client,"Schwarzpulvertransport abgegeben, deine Fraktion erhält 2000 Schwarzpulver.",0,120,0);
	local item = itemmanager:addItem(57, 2000, factionboxmanager:getFactionBoxes(getElementData(client,"Fraktion"))[1].Storage[5])
	item:merge()
	destroyElement(Schwarzpulvertransport.vehicle);
	Schwarzpulvertransport.beladen = false;
	Levelsystem.givePoints(client,150);
	triggerClientEvent(client,"Schwarzpulvertransport.createMarker",client);
end)

addCommandHandler("giveblackpowder",
	function(player, _, faction)
		if getElementData(player,"Adminlevel") >= 2 then
			if factionboxmanager:getFactionBoxes(tonumber(faction))[1] then
				itemmanager:addItem(57, 2000, factionboxmanager:getFactionBoxes(tonumber(faction))[1].Storage[5])
				player:sendNotification("Schwarzpulver hinzugefügt!", 0, 125, 0)
			end
		end
	end
)

function Schwarzpulvertransport.destroyElements()
	if(isElement(Schwarzpulvertransport.vehicle))then destroyElement(Schwarzpulvertransport.vehicle)end
	if(isElement(Schwarzpulvertransport.beladenMarker))then destroyElement(Schwarzpulvertransport.beladenMarker)end
	for _,v in pairs(getElementsByType("object"))do
		if(getElementData(v,"SchwarzpulverKiste"))then
			destroyElement(v);
		end
	end
	for _,v in pairs(Schwarzpulvertransport.vehs)do destroyElement(v)end
end

function Schwarzpulvertransport.destroyStuff(player)
	triggerClientEvent(player,"Schwarzpulvertransport.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Schwarzpulvertransport.destroyStuff(source) end)