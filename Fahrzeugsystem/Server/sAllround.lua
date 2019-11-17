

function getCarData(slot,owner,data)
	local result = dbQuery(handler,"SELECT * FROM vehicles WHERE Slot = '"..slot.."' AND Besitzer = '"..owner.."'");
	if(result)then
		local rows = dbPoll(result,-1);
		for _,v in pairs(rows)do
			return v[data];
		end
	end
end

--[[addEventHandler("onVehicleEnter",root,function(player)
	if(not(getElementData(source,"Motor")))then setElementData(source,"Motor","Off")end
	if(not(getElementData(source,"Licht")))then setElementData(source,"Licht","Off")end
	if(not(getElementData(source,"Benzin")))then setElementData(source,"Benzin",100)end
	if (getElementData(source,"Motor") == "Off")then
		setVehicleEngineState(source,false);
	else
		setVehicleEngineState(source,true);
	end
	if getVehicleType(source) == "BMX" then
		setVehicleEngineState(source,true);
	end
	if(getElementData(source,"Licht") == "Off")then
		setVehicleOverrideLights(source,1);
	else
		setVehicleOverrideLights(source,2);
	end
end)]]

function Motor(player)
	if(isPedInVehicle(player))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local veh = getPedOccupiedVehicle(player);
			if(getElementData(veh,"Fraktion"))then
				if(getElementData(player,"Fraktion") ~= getElementData(veh,"Fraktion"))then
					return false
				end
			end
			if(getElementData(veh,"Besitzer"))then
				if(getPlayerName(player) ~= getElementData(veh,"Besitzer"))then
					return false
				end
			end
			if(getElementData(veh,"Benzin") >= 1)then
				if(getElementData(veh,"Motor") == "Off")then
					setVehicleEngineState(veh,true);
					setElementData(veh,"Motor","On");
				else
					setVehicleEngineState(veh,false);
					setElementData(veh,"Motor","Off");
				end
			else infobox(player,"Das Fahrzeug hat kein Benzin mehr!",120,0,0)end
		end
	end
end

function Licht(player)
	if(isPedInVehicle(player))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local veh = getPedOccupiedVehicle(player);
			if(getElementData(veh,"Fraktion"))then
				if(getElementData(player,"Fraktion") ~= getElementData(veh,"Fraktion"))then
					return false
				end
			end
			if(getElementData(veh,"Besitzer"))then
				if(getPlayerName(player) ~= getElementData(veh,"Besitzer"))then
					return false
				end
			end
			if(getElementData(veh,"Licht") == "Off")then
				setVehicleOverrideLights(veh,2);
				setElementData(veh,"Licht","On");
			else
				setVehicleOverrideLights(veh,1);
				setElementData(veh,"Licht","Off");
			end
		end
	end
end

addCommandHandler("lock",function(player,cmd,slot)
	if(getElementData(player,"loggedin") == 1)then
		if(slot)then
			local slot = tonumber(slot);
			if(isElement(player:getVehicles()[slot]))then
				local x,y,z = getElementPosition(player:getVehicles()[slot]);
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 3.5)then
					vehiclemanager:vehicleInteraction(player, player:getVehicles()[slot], "lock")
				else infobox(player,"Du bist zu weit von dem Fahrzeug entfernt!",120,0,0)end
			else infobox(player,"Du hast kein Fahrzeug mit dem angegebenen Slot!",120,0,0)end
		else
			for _,v in pairs(player:getVehicles())do
				local x,y,z = getElementPosition(v);
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 3.5)then
					vehiclemanager:vehicleInteraction(player, v, "lock")
					break
				end
			end
		end
	end
end)

addCommandHandler("break",function(player)
	if(getElementData(player,"loggedin") == 1)then
		local veh = player:getOccupiedVehicle()
		if veh then
			vehiclemanager:vehicleInteraction(player, veh, "break")
		end
	end
end)

addCommandHandler("kickout",function(player,cmd,target)
	target = getPlayerFromName(target)
	if not target then return end
	local targetVehicle = getPedOccupiedVehicle(target)
	local playerVehicle = getPedOccupiedVehicle(player)
	local playerSeat = getPedOccupiedVehicleSeat(player)
	if (targetVehicle == playerVehicle) and (playerSeat == 0) then
		ExitVehicle(target)
		infobox(target, "Du wurdest aus dem Fahrzeug geworfen",120,0,0)
		setElementData(target, "grabbed", false)
		toggleAllControls(target,true)
		setElementFrozen(target,false)		
		infobox(player, "Du hast "..getPlayerName(target).." aus dem Fahrzeug geworfen",0,120,0)
	end
end)

addEvent("sellVehicle", true)
addEventHandler("sellVehicle", root, function(slot, player)
    local id = getElementModel(player:getVehicles()[slot])
    local price = Autohaus["Preise"][id]
	PlayerVehicleClass.delete(player:getVehicles()[slot])
	player:giveMoney(price / 100 * 50)
    infobox(player, "Du hast dein Fahrzeug an den Server verkauft.", 0, 120, 0)
	vehSellLog:write(player.name, id, price * 0.5)
end)

addEvent("showVehicleBlip", true)
addEventHandler("showVehicleBlip", root, function(player, slot)
    if slot then
        if player:getVehicles()[slot]:getCarpark() == 0 then
            local x, y, z = getElementPosition(player:getVehicles()[slot])
			local blip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 6000, player)
            infobox(player, "Du findest nun dein Fahrzeug auf der Karte!", 0, 120, 0)
            setTimer(function()
                if isElement(blip) then
                    destroyElement(blip)
                end
            end, 30000, 1)
        elseif player:getVehicles()[slot]:getCarpark() ~= 0 then
			infobox(player, "Das Fahrzeug ist in der Tiefgarage!", 120, 0, 0)
		else
            infobox(player, "Dein Fahrzeug ist auf dem Abschlepphof!", 120, 0, 0)
        end
    end
end)

addEvent("respawnVehicle", true)
addEventHandler("respawnVehicle", root, function(player, slot)
	if slot then
		local vehicle = player:getVehicles()[slot]
		if vehicle and vehicle:isEmpty() then
			if vehicle:getCarpark() == 0 then
				if getElementData(player, "Bankgeld") >= 100 then
					local pname = getPlayerName(player)
					player:sendNotification("Du hast das Fahrzeug für 100€ erfolgreich respawnt!", 0, 120, 0)
					vehicle:respawn()
					player:takeMoney(100)
				else
					infobox(player, "Der Respawn kostet 100€", 120, 0, 0)
				end
			else
				player:sendNotification("VEHICLE_RESPAWN_GARAGE_ERROR")
			end
        else
			infobox(player, "Die Passanten sollten zuerst aus dem Fahrzeug aussteigen.", 120, 0, 0)
        end
    end
end)


addEvent("newRespawnVehicle",true)
addEventHandler("newRespawnVehicle",root,function(owner,slot)
	if(owner == getPlayerName(client))then
		if(isElement(Autohaus.vehicles[owner][slot]))then
			if(not(getVehicleOccupant(Autohaus.vehicles[owner][slot])))then
				if (getElementData(client, "Geld") >= 750) then
					local vx,vy,vz = getCarData(slot,owner,"Spawnx"),getCarData(slot,owner,"Spawny"),getCarData(slot,owner,"Spawnz");
					local vrot = getCarData(slot,owner,"Rotation");
					respawnVehicle(Autohaus.vehicles[owner][slot]);
					setElementPosition(Autohaus.vehicles[owner][slot],vx,vy,vz);
					setElementRotation(Autohaus.vehicles[owner][slot],0,0,vrot);
					fixVehicle(Autohaus.vehicles[owner][slot]);
					infobox(client,"Dein Fahrzeug wurde respawnt.",0,120,0);
					setElementDimension(Autohaus.vehicles[owner][slot],0);
					setVehicleEngineState(Autohaus.vehicles[owner][slot],false);
					setElementData(Autohaus.vehicles[owner][slot],"Motor","Off");
					setVehicleOverrideLights(Autohaus.vehicles[owner][slot],1);
					setElementData(Autohaus.vehicles[owner][slot],"Licht","Off");
					setElementData(client,"Geld",getElementData(client,"Geld")-750);
				else infobox(client, "Du hast nicht genug Geld", 120, 0, 0) end
			else infobox(client,"Das ausgewählte Fahrzeug ist nicht leer!",120,0,0)end
		else infobox(client,"Das ausgewählte Fahrzeug existiert nicht mehr!",120,0,0)end
	else infobox(client,"Das Fahrzeug gehört dir nicht!",120,0,0)end
end)

addEvent("parkVehicle",true)
addEventHandler("parkVehicle",root,
	function(owner,slot)
		if player:getVehicles()[slot] then
			vehiclemanager:vehicleInteraction(player, player:getVehicles()[slot], "park")
		else 
			infobox(client,"Das ausgewählte Fahrzeug existiert nicht mehr!",120,0,0)
		end
	end
)

addEvent("parkCar", true)
addEventHandler("parkCar", root, function(player)
    local veh = getElementData(player, "clickedElement")
    local slot = getElementData(veh, "Slot")
    local owner = getElementData(veh, "Besitzer")
    local benzin = getElementData(veh, "Benzin")
    local x, y, z = getElementPosition(veh)
    local _, _, rz = getElementRotation(veh)

    dbExec(handler, "UPDATE vehicles SET Spawnx = ?, Spawny = ?, Spawnz = ?, Rotation = ?, Benzin = ? WHERE Slot = ? AND Besitzer = ?", x, y, z, rz, benzin, slot, owner)
	infobox(player, "Du hast das Fahrzeug umgeparkt!", 0, 120, 0)
end)

addEvent("breakCar",true)
addEventHandler("breakCar",root,function(owner,slot)
	if(owner == getPlayerName(client))then
		if(isElement(Autohaus.vehicles[owner][slot]))then
			if(getElementData(Autohaus.vehicles[owner][slot],"Handbremse") == 1)then
				dbExec(handler,"UPDATE vehicles SET Handbremse = ?, WHERE Slot = ? AND Besitzer = ?",0,slot,owner);
				setElementData(Autohaus.vehicles[owner][slot],"Handbremse",0);
				setElementFrozen(Autohaus.vehicles[owner][slot],false);
				infobox(client,"Handbremse gelöst.",0,120,0);
			else
				dbExec(handler,"UPDATE vehicles SET Handbremse = ? WHERE Slot = ? AND Besitzer = ?",1,slot,owner);
				setElementData(Autohaus.vehicles[owner][slot],"Handbremse",1);
				setElementFrozen(Autohaus.vehicles[owner][slot],true);
				infobox(client,"Handbremse angezogen.",120,0,0);
			end
			triggerClientEvent(client,"refreshBrakeState",client);
		else infobox(client,"Das ausgewählte Fahrzeug existiert nicht mehr!",120,0,0)end
	else infobox(client,"Das Fahrzeug gehört dir nicht!",120,0,0)end
end)

addEvent("handbreakCar", true)
addEventHandler("handbreakCar", root, function(player)
    local veh = getElementData(player, "clickedElement")
    local slot = getElementData(veh, "Slot")
    local owner = getElementData(veh, "Besitzer")

    if getElementData(veh, "Handbremse") == 1 then
        dbExec(handler, "UPDATE vehicles SET Handbremse = ? WHERE Slot = ? AND Besitzer = ?", 0, slot, owner)
        setElementData(veh, "Handbremse", 0)
        setElementFrozen(veh, false)
    else
        dbExec(handler, "UPDATE vehicles SET Handbremse = ? WHERE Slot = ? AND Besitzer = ?", 1, slot, owner)
        setElementData(veh, "Handbremse", 1)
        setElementFrozen(veh, true)
    end
end)

addEvent("lockCar",true)
addEventHandler("lockCar",root,function(owner,slot)
	if(owner == getPlayerName(client))then
		if(isElement(Autohaus.vehicles[owner][slot]))then
			if(isVehicleLocked(Autohaus.vehicles[owner][slot]))then
				setVehicleLocked(Autohaus.vehicles[owner][slot],false);
				infobox(client,"Das Fahrzeug wurde aufgeschlossen.",0,120,0);
				setElementData(Autohaus.vehicles[owner][slot],"Verschlossen",0);
			else
				setVehicleLocked(Autohaus.vehicles[owner][slot],true);
				infobox(client,"Das Fahrzeug wurde abgeschlossen.",120,0,0);
				setElementData(Autohaus.vehicles[owner][slot],"Verschlossen",1);
			end
			triggerClientEvent(client,"refreshLockstate",client);
		else infobox(client,"Das ausgewählte Fahrzeug existiert nicht mehr!",120,0,0)end
	else infobox(client,"Das Fahrzeug gehört dir nicht!",120,0,0)end
end)

addEvent("handbreakCar", true)
addEventHandler("handbreakCar", root, function(player)
    local veh = getElementData(player, "clickedElement")
    local slot = getElementData(veh, "Slot")
    local owner = getElementData(veh, "Besitzer")

    if getElementData(veh, "Handbremse") == 1 then
        dbExec(handler, "UPDATE vehicles SET Handbremse = ? WHERE Slot = ? AND Besitzer = ?", 0, slot, owner)
        setElementData(veh, "Handbremse", 0)
        setElementFrozen(veh, false)
    else
        dbExec(handler, "UPDATE vehicles SET Handbremse = ? WHERE Slot = ? AND Besitzer = ?", 1, slot, owner)
        setElementData(veh, "Handbremse", 1)
        setElementFrozen(veh, true)
    end
end)

function ExitVehicle(player)
	local veh = getPedOccupiedVehicle(player);
	if(isElement(veh))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			setElementVelocity(veh,0,0,0);
		end
		setControlState(player,"enter_exit",false);
		setTimer(removePedFromVehicle,750,1,player);
		setTimer(setControlState,125,1,player,"enter_exit",false);
		setTimer(setControlState,125,1,player,"enter_exit",true);
		setTimer(setControlState,700,1,player,"enter_exit",false);
	end
end

exitVehicle = ExitVehicle

local noobVehicles = {
 {510,-2738.0148925781,375.01599121094,3.9412000179291,180},
 {510,-2736.5146484375,375.01599121094,3.9412000179291,180},
 {510,-2735.0148925781,375.01599121094,3.9412000179291,180},
 {510,-2733.5148925781,375.01599121094,3.9412000179291,180},
 {510,-2732.0148925781,375.01599121094,3.9412000179291,180},
 {510,-2730.5148925781,375.01599121094,3.9412000179291,180},
 {510,-2729.0146484375,375.01599121094,3.9412000179291,180},
 {510,-2727.5148925781,375.01599121094,3.9412000179291,180},
 {510,-2726.0148925781,375.01599121094,3.9412000179291,180},
 {510,-2724.5148925781,375.01599121094,3.9412000179291,180},
 {510,-2723.0151367188,375.01599121094,3.9412000179291,180},
 {510,-2738.0148925781,377.1123046875,3.9412000179291,0},
 {510,-2736.5148925781,377.1123046875,3.9412000179291,0},
 {510,-2735.0146484375,377.1123046875,3.9412000179291,0},
 {510,-2733.5146484375,377.1123046875,3.9412000179291,0},
 {510,-2732.0146484375,377.1123046875,3.9412000179291,0},
 {510,-2730.5146484375,377.1123046875,3.9412000179291,0},
 {510,-2729.0148925781,377.1123046875,3.9412000179291,0},
 {510,-2727.5146484375,377.1123046875,3.9412000179291,0},
 {510,-2726.0146484375,377.1123046875,3.9412000179291,0},
 {510,-2724.5146484375,377.1123046875,3.9412000179291,0},
 {510,-2723.0146484375,377.1123046875,3.9412000179291,0},
 
 --NoobFahrräder Hinten
 {510,-2674.5126953125,377.1123046875,3.9412000179291,0},
 {510,-2676.0126953125,377.1123046875,3.9412000179291,0},
 {510,-2677.5126953125,377.1123046875,3.9412000179291,0},
 {510,-2679.0126953125,377.1123046875,3.9412000179291,0},
 {510,-2680.5126953125,377.1123046875,3.9412000179291,0},
 {510,-2682.0126953125,377.1123046875,3.9412000179291,0},
 {510,-2683.5126953125,377.1123046875,3.9412000179291,0},
 {510,-2685.0126953125,377.1123046875,3.9412000179291,0},
 {510,-2686.5126953125,377.1123046875,3.9412000179291,0},
 {510,-2688.0126953125,377.1123046875,3.9412000179291,0},
 {510,-2689.5126953125,377.1123046875,3.9412000179291,0},
 {510,-2689.5126953125,375.01599121094,3.9412000179291,180},
 {510,-2688.0126953125,375.015625,3.9412000179291,180},
 {510,-2686.5126953125,375.015625,3.9412000179291,180},
 {510,-2685.0126953125,375.015625,3.9412000179291,180},
 {510,-2683.5126953125,375.015625,3.9412000179291,180},
 {510,-2682.0126953125,375.015625,3.9412000179291,180},
 {510,-2680.5126953125,375.015625,3.9412000179291,180},
 {510,-2679.0126953125,375.015625,3.9412000179291,180},
 {510,-2677.5126953125,375.015625,3.9412000179291,180},
 {510,-2676.0126953125,375.015625,3.9412000179291,180},
 {510,-2674.5126953125,375.015625,3.9412000179291,180},
 }
 
for key, v in ipairs(noobVehicles) do
	if key % 2 == 0 then
		local veh = createVehicle(v[1], v[2], v[3], v[4], 0, 0, v[5])
		setElementData(veh, "Fraktion", 0)
		setVehicleHandling(veh, "maxVelocity", 35)
	end
end	
 
