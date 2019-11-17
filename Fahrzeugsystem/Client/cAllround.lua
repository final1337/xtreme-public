
addEvent("openVehicleWindow",true)
addEventHandler("openVehicleWindow",root,function(lockstate,breakstate)
	if(isWindowOpen())then
		Elements.window[1] = Window:create(589, 378, 263, 144,"Fahrzeugmenü",1440,900);
		Elements.button[1] = Button:create(599, 448, 117, 27,lockstate,"lockAndUnlockVehicle",1440,900);
		Elements.button[2] = Button:create(725, 448, 117, 27,breakstate,"breakAndUnbreakVehicle",1440,900);
		Elements.button[3] = Button:create(599, 485, 117, 27,"Respawnen","newRespawnVehicle",1440,900);
		Elements.button[4] = Button:create(725, 485, 117, 27,"Parken","parkVehicle",1440,900);
		setWindowDatas();
	end
end)

function lockAndUnlockVehicle()
	local clickedElement = getElementData(localPlayer,"clickedElement");
	local owner,slot = getElementData(clickedElement,"Besitzer"),getElementData(clickedElement,"Slot");
	triggerServerEvent("lockCar",localPlayer,owner,slot);
end
addEvent("lockAndUnlockVehicle",true)
addEventHandler("lockAndUnlockVehicle",root,lockAndUnlockVehicle)

addEvent("refreshLockstate",true)
addEventHandler("refreshLockstate",root,function()
	if(Elements.button[1]:getText() == "Aufschließen")then
		Elements.button[1]:setText("Abschließen");
	else
		Elements.button[1]:setText("Aufschließen");
	end
end)

addEvent("refreshBrakeState",true)
addEventHandler("refreshBrakeState",root,function()
	if(Elements.button[2]:getText() == "Handbremse lösen")then
		Elements.button[2]:setText("Handbremse anziehen");
	else
		Elements.button[2]:setText("Handbremse lösen");
	end
end)

function breakAndUnbreakVehicle()
	local clickedElement = getElementData(localPlayer,"clickedElement");
	local owner,slot = getElementData(clickedElement,"Besitzer"),getElementData(clickedElement,"Slot");
	triggerServerEvent("breakCar",localPlayer,owner,slot);
end
addEvent("breakAndUnbreakVehicle",true)
addEventHandler("breakAndUnbreakVehicle",root,breakAndUnbreakVehicle)

function newRespawnVehicle()
	local clickedElement = getElementData(localPlayer,"clickedElement");
	local owner,slot = getElementData(clickedElement,"Besitzer"),getElementData(clickedElement,"Slot");
	triggerServerEvent("newRespawnVehicle",localPlayer,owner,slot);
end
addEvent("newRespawnVehicle",true)
addEventHandler("newRespawnVehicle",root,newRespawnVehicle)

function parkVehicle()
	local clickedElement = getElementData(localPlayer,"clickedElement");
	local owner,slot = getElementData(clickedElement,"Besitzer"),getElementData(clickedElement,"Slot");
	triggerServerEvent("parkVehicle",localPlayer,owner,slot);
end
addEvent("parkVehicle",true)
addEventHandler("parkVehicle",root,parkVehicle)