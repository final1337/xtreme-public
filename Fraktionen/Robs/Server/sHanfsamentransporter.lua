
Hanfsamentransporter = {};

function Hanfsamentransporter.createElements()
	Hanfsamentransporter.vehicle = createVehicle(573,158.0693359375,-22.3525390625,1.7935999631882,0,0,270,"Hanfsamentransporter");
	setVehicleColor(Hanfsamentransporter.vehicle,Fraktionen["Farben"][10][1],Fraktionen["Farben"][10][2],Fraktionen["Farben"][10][3]);
	sendFactionMessage(10,"[#00ff00ROB#ffffff] Ein Hanfsamentransporter steht bereit!",255,255,255);
	
	addEventHandler("onVehicleExplode",Hanfsamentransporter.vehicle,function(player)
		if(isTimer(Hanfsamentransporter.timer))then killTimer(Hanfsamentransporter.timer)end
		setTimer(Hanfsamentransporter.createElements,1800000,1);
		destroyElement(source);
		outputChatBox("[#ff0000ROB#ffffff] Der Hanfsamentransporter wurde zerstört aufgefunden!",root,255,255,255,true);
	end)
	
	addEventHandler("onVehicleEnter",Hanfsamentransporter.vehicle,function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(not(isBallas(player)))then
				ExitVehicle(player);
			else
				if(not(isTimer(Hanfsamentransporter.timer)))then
					infobox(player,"Bringe den Transporter innerhalb von 10 Minuten zu der markierten Stelle auf der Karte!",0,120,0);
					Hanfsamentransporter.timer = setTimer(function()
						if(isElement(Hanfsamentransporter.vehicle))then
							destroyElement(Hanfsamentransporter.vehicle);
							setTimer(Hanfsamentransporter.createElements,1800000,1);
						end
					end,600000,1)
					outputChatBox("[#ff0000ROB#ffffff] Ein Hanfsamentransporter wurde beladen!",root,255,255,255,true);
				end
				triggerClientEvent(player,"Hanfsamentransporter.createMarker",player,"create");
			end
		end
	end)
	
	addEventHandler("onVehicleExit",Hanfsamentransporter.vehicle,function(player)
		triggerClientEvent(player,"Hanfsamentransporter.destroy",player);
	end)
end
Hanfsamentransporter.createElements();

addEvent("Hanfsamentransporter.abgabe",true)
addEventHandler("Hanfsamentransporter.abgabe",root,function()
	destroyElement(Hanfsamentransporter.vehicle);
	infobox(client,"Du hast 15 Hanfsamen erhalten.",0,120,0);
	outputChatBox("[#ff0000ROB#ffffff] Der Hanfsamentransporter wurde abgegeben!",root,255,255,255,true);
	local item = itemmanager:addItem(67, 15, factionboxmanager:getFactionBoxes(getElementData(client,"Fraktion"))[1].Storage[5])
	item:merge()
	if(isTimer(Hanfsamentransporter.timer))then killTimer(Hanfsamentransporter.timer)end
	setTimer(Hanfsamentransporter.createElements,1800000,1);
	Levelsystem.givePoints(client,150);
	triggerClientEvent(client,"Hanfsamentransporter.destroy",client,"create");
end)