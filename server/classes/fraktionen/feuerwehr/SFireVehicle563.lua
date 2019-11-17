FireVehicleHelicopter = inherit(FireVehicle)

addEvent("XTM:FF:RaindanceCheckSuccess", true)
addEvent("XTM:FF:fillFireExtHelicopter", true)

FireVehicleHelicopter.MAX_TANK_SIZE       	  = 50000 -- liters
FireVehicleHelicopter.LITER_PER_WAVE 		  = FireVehicleHelicopter.MAX_TANK_SIZE/10 -- liters
FireVehicleHelicopter.WAVE_RADIUS             = 7 -- GTA Units
FireVehicleHelicopter.WAVE_AMOUNT             = 9
FireVehicleHelicopter.SYNC_RAGE               = 200 -- GTA Units
FireVehicleHelicopter.REFILL_FIREEXT      	  = 250 -- liters

function FireVehicleHelicopter:constructor(kilometer, pBreak, fuel, id, faction, preDenial)
	FireVehicle.constructor(self, kilometer, pBreak, fuel, id, faction, preDenial)
	
	self:setData("Tank", FireVehicleHelicopter.MAX_TANK_SIZE )
	self:setData("TankMaximum", FireVehicleHelicopter.MAX_TANK_SIZE)
	
	self.m_Recharge = false
	
	-- Add events, etc.
	self.m_ShootHandler = bind(self.waterShoot, self)
	addEventHandler("onVehicleExit", self, bind(self.Event_OnVehicleLeave, self))		
	addEventHandler("onVehicleEnter", self, bind(self.Event_OnVehicleEnter, self))
	addEventHandler("XTM:FF:RaindanceCheckSuccess", self, bind(self.Event_ReceiveWavePosition, self))
	addEventHandler("XTM:FF:fillFireExtHelicopter",  self, bind ( self.Event_fillFireExtHelicopter, self ))
end

function FireVehicleHelicopter:Event_fillFireExtHelicopter()
	--[[if self:getData("Tank") > FireVehicleHelicopter.REFILL_FIREEXT then
		call( getResourceFromName("Xtream"), "inventarAddItem", client, "Feuerlöscher", FireVehicleHelicopter.REFILL_FIREEXT)
		self:setData("Tank", self:getData("Tank") - FireVehicleHelicopter.REFILL_FIREEXT)
		client:sendNotification("Feuerlöscher erhalten! Aktuelles Wasservolumen: %d l", 255, 255, 255, self:getData("Tank"))	
	else
		client:sendNotification("Der Wasserstand ist zu niedrig. ( derzeit: %d l)", 255, 255, 255, self:getData("Tank"))
	end]]
end

function FireVehicleHelicopter:Event_ReceiveWavePosition(x,y,groundZ)
	if not client then return end
	if self:getData("Tank") < FireVehicleHelicopter.LITER_PER_WAVE then return client:sendMessage("Nicht genug Wasser im Tank!") end
	self:setData("Tank", self:getData("Tank") - FireVehicleHelicopter.LITER_PER_WAVE)
	
	local col = createColSphere(x,y,groundZ, 200)
	
	setTimer(function (client, synchElements)
		-- sync the effect
		local x, y, z = getElementPosition(self)
		local effects = {}
		for i = math.floor(groundZ), math.floor(z) do
			table.insert(effects, {"prt_watersplash", x,y,i})
		end
		
		table.insert(effects, {"prt_watersplash", x + 1.4, y, groundZ + 1})
		table.insert(effects, {"prt_watersplash", x - 1.4, y, groundZ + 1})
		table.insert(effects, {"prt_watersplash", x, y + 1.4, groundZ + 1})
		table.insert(effects, {"prt_watersplash", x, y - 1.4, groundZ + 1})
		
		
		for _, player in ipairs(synchElements) do
			player:triggerEvent("CreateRemoteEffect", effects, 2000)
		end
		
		-- Delete The Fires
		for key, fire in pairs (FireManager:getSingleton():getEntities()) do
			if getDistanceBetweenPoints3D(x,y,groundZ,fire:getPosition()) < FireVehicleHelicopter.WAVE_RADIUS then
				if fire and fire.getExtinguishedState and not fire:getExtinguishedState() then
					if fire.onFinish then
						fire:onFinish()
					end
					fire:extinguish(true)
					delete(fire)
				end
			end
		end
	end, 150, FireVehicleHelicopter.WAVE_AMOUNT, client, getElementsWithinColShape(col, "player"))
	
	destroyElement(col)
end

function FireVehicleHelicopter:waterShoot(player, state, down)
	if not self.m_Recharge then
		player:triggerEvent("XTM:FF:RaindanceCheck")
		self.m_Recharge = true
		self.m_Recharge = setTimer( function () self.m_Recharge = false  end, 6000, 1 )
	end
end

function FireVehicleHelicopter:Event_OnVehicleEnter(player, seat)
	if seat == 0 then
		bindKey(player, "vehicle_fire", "up", self.m_ShootHandler)
	end
end


function FireVehicleHelicopter:Event_OnVehicleLeave(player, seat)
	if seat == 0 then
		unbindKey(player, "vehicle_fire", "up", self.m_ShootHandler)
	end
end

function FireVehicleHelicopter.create(x,y,z,rotx,roty,rotz,plate)
	local vehicle = Vehicle(563, x,y,z,rotx,roty,rotz,plate)
	enew(vehicle, FireVehicleHelicopter)
	return vehicle
end

local markerPos = Vector3(-2091.73, 77.82, 43.10)
local marker = Marker(markerPos, "corona", 3, 0, 125, 0)

addEventHandler("onMarkerHit", marker,
	function (hitElement, matchingDimension)
		if hitElement:getType() == "vehicle" and getElementData(hitElement, "Fraktion") == 9 and hitElement:getModel() == 563 then
			hitElement:setData("Tank", FireVehicleHelicopter.MAX_TANK_SIZE)
		end
	end
)