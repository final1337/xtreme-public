VehicleManager = inherit(Singleton)

addEvent("RP:Server:Vehicle:interaction", true)

function VehicleManager:constructor()
	self.m_Vehicles = {}
	-- Fraktionsfahrzeuge werden auch in self.m_Vehicles gespeichert, werden jedoch der wegen der Errechbarkeit auch hier noch einmal zwischen gespeichert.
	self.m_FactionVehicles = {}
	self.m_FactionColors = {}

	self.m_Loaded = {}

	self.m_VehicleRoot = createElement("VEHICLE_ROOT_" .. math.random(99999))

	self:preloadFactionColors()
	self:initFactionVehicles()
	self:initAllPlayerVehicles()
	
	addEventHandler("onResourceStop", resourceRoot, bind(self.saveAllVehicles, self))
	addEventHandler("onVehicleEnter", root, bind(self.Event_OnVehicleEnter, self))
	addEventHandler("onVehicleStartEnter", root, bind(self.Event_OnVehicleStartEnter, self))
	addEventHandler("onElementClicked", self.m_VehicleRoot, bind(self.Event_OnElementClicked, self))
	addCommandHandler("givekey", bind(self.Command_GiveKey, self))
	addCommandHandler("removekey", bind(self.Command_RemoveKey, self))
	addEventHandler("RP:Server:Vehicle:interaction", root, bind(self.Event_VehicleInteraction, self))
	addEventHandler("onVehicleRespawn", self.m_VehicleRoot, bind(self.Event_OnVehicleRespawn, self))
	addEventHandler("onVehicleExplode", self.m_VehicleRoot, bind(self.Event_OnVehicleExplode, self))
	addEventHandler("onVehicleDamage", self.m_VehicleRoot, bind(self.Event_OnVehicleDamage, self))
end

function VehicleManager:Event_OnVehicleDamage(loss)
	if source.getOwner then
		if not source:getEngineState() and source:getHealth() < 300 then
			source:setHealth(300)
		elseif not source:getEngineState() and source:getHealth() > 800 then
			source:setHealth(math.max(source:getHealth()+loss, 1000))
		end
	end
end

function VehicleManager:Event_OnVehicleExplode()
	if source.getOwner then
		Timer(setElementDimension, 5000, 1, source, 3)
	else
		Timer(respawnVehicle, 10000, 1, source)
	end
end

function VehicleManager:Event_OnVehicleRespawn()
	-- is a player vehicle

	source:setInterior(source.RespawnInterior)
	source:setDimension(source.RespawnDimension)
	source:setEngineState(false)
	source:setData("Engine", false)
	source:setOverrideLights(1)
	source:setData("Lights", 1)

	if source.getOwner then
		source:setBreakState(true)
		source:setLockState(true)
	else
		source:setBreakState(false)
		source:setLockState(false)
	end
end

function VehicleManager:Event_VehicleInteraction(vehicle, interaction)
	if not client then return end
	self:vehicleInteraction(client, vehicle, interaction)
end

function VehicleManager:vehicleInteraction(player, vehicle, interaction)
	if interaction == "lock" and vehicle:isAligable(player) then
		vehicle:setLockState(not vehicle:getLockState())
		player:sendNotification(vehicle:getLockState() and "VEHICLE_LOCKED" or "VEHICLE_UNLOCKED", 255, 255, 0)
	elseif interaction == "break" and vehicle:isAligable(player) then
		if (vehicle:getVelocity()):getLength() == 0 then
			vehicle:setBreakState(not vehicle:getBreakState())
			player:sendNotification(vehicle:getBreakState() and "VEHICLE_BREAKED" or "VEHICLE_UNBREAKED", 255, 255, 0)
		else
			player:sendNotification("VEHICLE_BREAK_SPEED_ERROR", 255, 0, 0)
		end
	elseif interaction == "respawn" and vehicle:isAligable(player) then
		if vehicle:isEmpty() then
			vehicle:respawn()
			vehicle:setUntouchable()
		end
	elseif interaction == "park" then
		if ( vehicle.getOwner and vehicle:isAligable(player) ) or ( vehicle:getData("Fraktion") == player:getData("Fraktion") and player:getData("Rang") == 5 ) then
			if vehicle:isOnGround() then
				vehicle:setRespawnPosition(vehicle:getPosition(), vehicle:getRotation())
				vehicle.RespawnInterior = vehicle:getInterior()
				vehicle.RespawnDimension = vehicle:getDimension()
				player:sendNotification("VEHICLE_PARKED", 255, 255, 0)
			end
		end
	elseif interaction == "garage" then
		if vehicle.getOwner then
			self:addToCarpark(vehicle)
			player:sendNotification("VEHICLE_PARKED", 255, 255, 0)
		end
	elseif interaction == "delete" then
		if client:getData("Adminlevel") > 3 then
			if vehicle.getOwner then
				PlayerVehicleClass.delete(vehicle)
				client:sendNotification("Fahrzeug gelöscht.")
			else
				client:sendNotification("Du kannst nur Privatfahrzeuge löschen!")
			end
		end
	end
end

function VehicleManager:addToCarpark(vehicle)
	if vehicle:getVehicleType() ~= "Helicopter" and vehicle:getVehicleType() ~= "Plane" then
		if vehicle:getCarpark() == 0 then
			carparkmanager:getCarparks()[1]:addVehicle(vehicle)
		end
	end
end

function VehicleManager:Event_OnElementClicked(mouseButton, buttonState, player)
	if (player:getPosition()-source:getPosition()):getLength() < 6 and mouseButton == "left" and buttonState == "up" then
		if not player:getData("Clicked") then
			local ownerString = "Niemand"
			if source.getOwner then
				ownerString = getPlayerData("userdata","ID",source:getOwner(),"Username")				
			elseif source:getData("Faction") then
				ownerString = Fraktionen["Namen"][source:getData("Faction")]
			end
			player:sendNotification("VEH_INFO", 0, 200, 0, getVehicleNameFromModel(source:getModel()), ownerString)
			player:triggerEvent("RP:Client:VehicleGUI:open", source)
		end
	end	
end

function VehicleManager:Command_GiveKey(player, _, target, hour)
	if not target then return end
	target = getPlayerFromName(target)
	if target and isElement(target) then
		local veh = player:getOccupiedVehicle()
		if veh and veh.getOwner and veh:getOwner() == player:getId() and hour and tonumber(hour) then
			veh:addKey(target:getId(), math.abs(tonumber(hour)))
			player:sendNotification("KEY_SHARED", 255, 255, 0, getVehicleNameFromModel(veh:getModel()), target:getName())
			target:sendNotification("KEY_RECEIVED", 255, 255, 0, player:getName(), getVehicleNameFromModel(veh:getModel()))
		end
	end
end

function VehicleManager:Command_RemoveKey(player, _, target)
	if not target then return end
	target = getPlayerFromName(target)
	if target and isElement(target) then
		local veh = player:getOccupiedVehicle()
		if veh and veh.getOwner and veh:getOwner() == player:getId() then
			veh:removeKey(target:getId())
			player:sendNotification("KEY_REMOVED", 255, 255, 0)
		end
	end
end

function VehicleManager:getVehicles()
    return self.m_Vehicles
end

function VehicleManager:Action_Engine(player)
	if player:getOccupiedVehicle() and player:getOccupiedVehicleSeat() == 0 then
		player:getOccupiedVehicle():changeEngine(player)
	end
end

function VehicleManager:Action_Lights(player)
	if player:getOccupiedVehicle() and player:getOccupiedVehicleSeat() == 0 then
		player:getOccupiedVehicle():changeLights(player)
	end
end

function VehicleManager:Event_OnVehicleEnter(player, seat)
	if seat ~= 0 then return end
	if source:isAligable(player) then
		-- player:sendNotification("You are allowed to drive this vehicle.")
	else
		player:sendNotification("VEH_NOT_ALIGABLE", 120, 0, 0)
		if source:getData("Fraktion") then
			player:leaveVehicle()
		end
	end
	source:setEngineState(source:getEngineStatus())
end

function VehicleManager:Event_OnVehicleStartEnter(player, seat)
	if seat ~= 0 then return end
	if source.isPreDeny and source:isPreDeny() then
		if source:isAligable(player) then
			-- player:sendNotification("You are allowed to drive this vehicle.")
		else
			cancelEvent(true)
			player:sendNotification("VEH_NOT_ALIGABLE", 120, 0, 0)
		end		
	end
end

function VehicleManager:saveVehicles()
    for key, value in ipairs(self.m_Vehicles) do
        
    end
end

function VehicleManager:preloadFactionColors()
	local query = db:query("SELECT * FROM vehicles_faction_color")
	local result = db:poll(query, -1)
	local v
	for key, value in ipairs(result) do
		self.m_FactionColors[value["colorId"]] = {}
		v = self.m_FactionColors[value["colorId"]]
		v[1] = {self:splitColor(value["color1"])}
		v[2] = {self:splitColor(value["color2"])}
		v[3] = {self:splitColor(value["color3"])}
		v[4] = {self:splitColor(value["color4"])}
	end
end

function VehicleManager:loadPlayerVehicle(player)
	if self.m_Loaded[player:getId()] then
		return
	end

	local query = db:query([[SELECT * FROM vehicles_player LEFT JOIN vehicles_general ON vehicles_player.vehicleId = vehicles_general.vehicleId
	WHERE playerId = ?]], player:getId())
	local result = db:poll(query, - 1)	

	if #result > 0 then
		self:loadPlayerVehicles(result)
	else
		self.m_Loaded[player:getId()] = {}
	end

	local vehicles = player:getVehicles()

	if vehicles and #vehicles > 0 then

		for key, value in ipairs(vehicles) do
			self:addToCarpark(value)
		end
		
	end

	-- outputChatBox("specific load")
end

function VehicleManager:initAllPlayerVehicles()


	-- outputChatBox("general load")
	
	local query = db:query([[SELECT * FROM vehicles_player LEFT JOIN vehicles_general ON vehicles_player.vehicleId = vehicles_general.vehicleId
	LEFT JOIN userdata ON userdata.ID = vehicles_player.playerId WHERE userdata.lastLogin > ?]], getRealTime()["timestamp"]-60*60*24*7)
	local result = db:poll(query, - 1)

	if #result > 0 then
		self:loadPlayerVehicles(result)
	end
	
end

function VehicleManager:getPlayerVehicles(playerId)
	return self.m_Loaded[playerId] or {}
end

function VehicleManager:getFactionVehicles(id)
	local tbl = {}
	for key, value in pairs(self.m_FactionVehicles) do
		if id == value:getData("Faction") then
			table.insert(tbl, value)
		end
	end
	return tbl
end

function VehicleManager:getAllFactionVehicles()
	return self.m_FactionVehicles
end

function VehicleManager:loadPlayerVehicles(databaseResult)

	local veh, color

	for key, value in ipairs(databaseResult) do
		if not self.m_Loaded[value.playerId] then
			self.m_Loaded[value.playerId] = {}
		end

		color = {}
		veh = Vehicle(value.model, value.posX, value.posY, value.posZ, value.rotX, value.rotY, value.rotZ, value.numberplate, false, value.variant1, value.variant2)
		enew(veh, PlayerVehicleClass, value.kilometer, value["break"], value.gasoline, value.vehicleId)

		veh.RespawnInterior = value.interior
		veh.RespawnDimension = value.dimension

		table.insert(self.m_Loaded[value.playerId], veh)

		color[1] = {self:splitColor(value.color1)}
		color[2] = {self:splitColor(value.color2)}
		color[3] = {self:splitColor(value.color3)}
		color[4] = {self:splitColor(value.color4)}


		veh:setPaintjob(value.paintjob)
		veh:setColor(color[1][1], color[1][2], color[1][3], color[2][1], color[2][2], color[2][3], 
					 color[3][1], color[3][2], color[3][3], color[4][1], color[4][2], color[4][3])
		self:addUpgradesViaString(veh, value.tunings)

		veh:setParent(self.m_VehicleRoot)
		veh:setInterior(value.interior)
		veh:setDimension(value.dimension)

		table.insert(self.m_Vehicles, veh)
		veh:setOwner(value.playerId)
		veh:setData("Slot", #self.m_Loaded[value.playerId])
		

		-- If carparkId is differnt than 0

		if value.carparkId > 0 then
			carparkmanager:getCarparks()[value.carparkId]:addVehicle(veh)
		else
			veh:setData("Carpark", 0)
		end

	end
end

function VehicleManager:getFactionColorId(id)
	return self.m_FactionColors[id]
end

-- Return r,g,b

function VehicleManager:splitColor(color)
	color = split(color, ",")
	return color[1], color[2], color[3]
end

function VehicleManager:combineColor(r,g,b)
	return ("%d,%d,%d"):format(r,g,b)
end

function VehicleManager:getTuningString(vehicle)
	local upgrades = {}
	for i = 0, 16, 1 do
		if vehicle:getUpgradeOnSlot(i) then
			table.insert(upgrades, vehicle:getUpgradeOnSlot(i))
		else
			table.insert(upgrades, "0")
		end	
	end
	return table.concat(upgrades, "|")
end

function VehicleManager:addUpgradesViaString(vehicle, string)
	local upgrades = split(string, "|")
	for key, value in ipairs(upgrades) do
		value = tonumber(value)
		if value ~= 0 then
			vehicle:addUpgrade(value)
		end
	end
end

function VehicleManager:getRoot()
	return self.m_VehicleRoot
end

function VehicleManager:addVehicle(vehicle, vehicleType, id)
	table.insert(self.m_Vehicles, vehicle)
	vehicle:setParent(self.m_VehicleRoot)
	
	if vehicleType == "faction" then
		self.m_FactionVehicles[vehicle:getId()] = vehicle
	elseif vehicleType == "player" then
		table.insert(self.m_Loaded[id], vehicle)
		vehicle:setData("Slot", #self.m_Loaded[id])
	end
end

function VehicleManager:removeVehicle(vehicle, vehicleType)
	if vehicleType == "player" then
		for key, value in ipairs(self.m_Loaded[vehicle:getOwner()]) do
			if value == vehicle then
				table.remove(self.m_Loaded[vehicle:getOwner()], key)
				break
			end
		end
		for key, value in ipairs(self.m_Loaded[vehicle:getOwner()]) do
			value:setData("Slot", key)
		end
	elseif vehicleType == "faction" then
		self.m_FactionVehicles[vehicle:getId()] = nil
	end
	for key, value in ipairs(self.m_Vehicles) do
		if value == vehicle then
			table.remove(self.m_Vehicles, key)
			break
		end
	end	
end

-- // TODO: do not load the items at the beginning -> they are now getting loaded when the vehicle got opened first
function VehicleManager:initFactionVehicles()
	local query = db:query("SELECT * FROM vehicles_faction LEFT JOIN vehicles_general ON vehicles_faction.vehicleId = vehicles_general.vehicleId")
	local result = db:poll(query, -1)

	local veh

	for key, value in ipairs(result) do
		
		local model = value.model

		if value.factionId == 9 then
			if value.model == 544 then
				model = 407
			end
		end

		veh = Vehicle(model, value.posX, value.posY, value.posZ, value.rotX, value.rotY, value.rotZ, value.numberplate, false, value.variant1, value.variant2)

		if value.factionId == 9 then
			if FireFighterCentral.FireFighterClasses[value.model] then
				enew(veh, FireFighterCentral.FireFighterClasses[value.model], value.kilometer, false, value.gasoline, value.vehicleId, value.factionId, value.preDenial)
			else
				enew(veh, FactionVehicleClass, value.kilometer, false, value.gasoline, value.vehicleId, value.factionId, value.preDenial)
			end
		else
			enew(veh, FactionVehicleClass, value.kilometer, false, value.gasoline, value.vehicleId, value.factionId, value.preDenial)
		end


		
		veh.RespawnInterior = value.interior
		veh.RespawnDimension = value.dimension

		-- Set vehicle color
		local color = self:getFactionColorId(value.colorId)
		veh:setColor(color[1][1], color[1][2], color[1][3], color[2][1], color[2][2], color[2][3], 
					 color[3][1], color[3][2], color[3][3], color[4][1], color[4][2], color[4][3])


		veh:addSirens()
		veh:setParent(self.m_VehicleRoot)
		veh:setInterior(value.interior)
		veh:setDimension(value.dimension)

		table.insert(self.m_Vehicles, veh)
		self.m_FactionVehicles[value.vehicleId] = veh
	end

	-- Now handle access
	query = db:query("SELECT * FROM vehicles_faction_permission")
	result = db:poll(query, - 1)

	for key, value in ipairs(result) do
		if self.m_FactionVehicles[value.vehicleId] then
			self.m_FactionVehicles[value.vehicleId]:addAccess(value.faction, value.rank)
		end
	end
end 

function VehicleManager:createVehicle(model, variant1, variant2, posX, posY, posZ, rotX, rotY, rotZ, dimension, interior, numberplate, kilometer, gasoline)
	local veh = Vehicle(model, posX, posY, posZ, rotX, rotY, rotZ, numberplate, false, variant1, variant2)
end

function VehicleManager:initVehicle(veh)
end 

function VehicleManager:loadItems(vehicle)

	local query = dbQuery(newDBHandler,"SELECT * FROM inventory WHERE owner = ? AND elementType = ?", vehicle:getId(), vehicle:getType())
	local results = dbPoll(query, -1)

	local tempItemIds = {}
	local fetchString = ""

	if #results == 0 then return end
	for k, v in ipairs(results) do
		local inv, itemId = tonumber(v["inventory"]), v["item"]

		tempItemIds[itemId] = {inv, v["slot"]}


		if #tostring(fetchString) == 0 then
			fetchString = ("\"%s\""):format(itemId)
		else
			fetchString = ("%s, \"%s\""):format(fetchString, itemId)
		end
	end


	fetchString = ("(%s)"):format(fetchString)

	query = dbQuery(newDBHandler, "SELECT * FROM item_instance WHERE uid IN ".. fetchString)
	results = dbPoll(query, -1)

	for k, v in ipairs(results) do
		local id = v["uid"]
		if tempItemIds[id] then
			vehicle.Storage[tempItemIds[id][1]]:initItem(tempItemIds[id][2], v["uid"], v["itemId"], v["owner"], v["creator"],
													v["gift"], v["amount"], v["flags"], v["conditionflags"], v["durability"],
													v["played"], v["specialtext"])
		end
	end
	-- Garbage collector
	tempItemIds = nil     
end

function VehicleManager:saveAllVehicles()
	for key, value in ipairs(self.m_Vehicles) do
		-- --// Just save the vehicles which got interacted with
		if value:getInteractionState() then
			value.Storage[8]:delete()
			value:saveData()
		end
	end
end

function VehicleManager:destructor()

end
