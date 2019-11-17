FireVehicle = inherit(FactionVehicleClass)

FireVehicle.USAGE_DURING_SHOOTING = 50 -- liters
FireVehicle.REFILL_RATE 		  = 150 -- liters
FireVehicle.MAX_TANK_SIZE         = 15000 -- liters

addEvent("XTM:FF:setPlayerWatching", true)
addEvent("XTM:FF:getChainSaw", 	true)
addEvent("XTM:FF:getDynamite", 	true)
addEvent("XTM:FF:getPickAxe", 	true)
addEvent("XTM:FF:getBeatmung", 	true)
addEvent("XTM:FF:getBarricades", 	true)

function FireVehicle:constructor(kilometer, pBreak, fuel, id, faction, preDenial)
	FactionVehicleClass.constructor(self, kilometer, pBreak, fuel, id, faction, preDenial)

	self.m_FireVehicle = true
	self.m_ControlTimer = {}
	self.m_ColShape = ColShape.Sphere(0,0,0, 6.5)
	
	self.m_ColShape:attach(self)
	
	-- Set the stuff, which needs the be synchronised
	self:setData("Firefighter", true)
	self:setData("Extinguisher", 1, true)
	self:setData("Chainsaw", 1, true)
	self:setData("Dynamite", 1, true)
	self:setData("Pickaxe",  1, true)
	self:setData("Respiratory_Equipment", true)
	
	addEventHandler("XTM:FF:getChainSaw", 	self, bind ( self.Event_GetChainSaw, self ))
	addEventHandler("XTM:FF:getDynamite", 	self, bind ( self.Event_GetDynamite, self ))
	addEventHandler("XTM:FF:getPickAxe", 	self, bind ( self.Event_GetPickAxe, self ))
	addEventHandler("XTM:FF:getBarricades", self, bind ( self.Event_GetBarricades, self ))
	addEventHandler("XTM:FF:getBeatmung", 	self, bind ( self.Event_GetBeatmung, self ))	
	
end

function FireVehicle:Event_GetChainSaw()
	--call( getResourceFromName("Xtream"), "inventarAddItem", client, "Kettensäge", 1)
	if getElementData(client,"Fraktion") ~= 9 then return end
	client:addItem(16, 1, "none", true)
	client:sendNotification("Kettensäge erhalten!", 0, 125, 0)
end

function FireVehicle:Event_GetBarricades()
	--call( getResourceFromName("Xtream"), "inventarAddItem", client, "Feuerloescher", 500)
	if getElementData(client,"Fraktion") ~= 9 then return end
	client:addItem(69, 50, "none", true)
	client:sendNotification("Barrikaden erhalten!", 0, 125, 0)
end

function FireVehicle:Event_GetDynamite()
	if getElementData(client,"Fraktion") ~= 9 then return end
	--call( getResourceFromName("Xtream"), "inventarAddItem", client, "Feuerloescher", 500)
end

function FireVehicle:Event_GetPickAxe()
	if getElementData(client,"Fraktion") ~= 9 then return end
	--call( getResourceFromName("Xtream"), "inventarAddItem", client, "Spitzhacke", 1)
	client:addItem(12, 1, "none", true)
	client:sendNotification("Spitzhacke erhalten!", 0, 125, 0)
end

function FireVehicle:Event_GetBeatmung()

end

function FireVehicle.create(model,x,y,z,rotx,roty,rotz,plate)
	local vehicle = Vehicle(model, x,y,z,rotx,roty,rotz,plate)
	enew(vehicle, FireVehicle)
	return vehicle
end