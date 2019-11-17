FirePump = inherit(Object)

function FirePump:constructor(vehicle)
	self.m_Vehicle = vehicle
	self.m_AtVehicle = true
	self.m_IsWearing = false
	self.m_FillTimer = false
	
	self:attach(self.m_Vehicle, 0.75, 0.25, 0)
	
	self.m_WastedHandler 	= bind(self.Event_OnPedWasted, self)
	self.m_QuitHandler   	= bind(self.Event_OnPlayerQuit, self)
	self.m_FillBindHandler  = bind(self.fillVehicleStart, self)
end

function FirePump:fillVehicleStart(player, key, state)
	if state == "down" then
		if ( player:isInWater() or player.m_IsInHydrant ) and not isTimer(self.m_FillTimer) then
			self.m_FillTimer = Timer ( function (filler) 
				self.m_Vehicle:setData("Tank", math.min ( FireVehicleWater.MAX_TANK_SIZE, self.m_Vehicle:getData("Tank") + FireVehicleWater.USAGE_DURING_SHOOTING*32))
				filler:sendNotification(("%d/%d"):format(self.m_Vehicle:getData("Tank"), FireVehicleWater.MAX_TANK_SIZE))
			end, 1000, 0, player)
			self:detach()
			local x,y,z = getElementPosition(player)
			self:setPosition(x,y, z  - .3)
		end
	elseif isTimer(self.m_FillTimer) and state == "up" then
		self:attach(player, 0, - 0.55,0,0,0,0)
		killTimer(self.m_FillTimer)
	end
end

function FirePump:activatePump(player)
	self:attach(player)
end

function FirePump:isWearable()
	return self.m_AtVehicle
end

function FirePump:Event_OnPedWasted()
	if self.m_IsWearing then
		self:disarm(source)
	end
end

function FirePump:Event_OnPlayerQuit()
	if self.m_IsWearing then
		self:disarm(source)
	end	
end

function FirePump:disarm(player)
	if not self:isWearable() and player.m_WearingPump == self then
		if isTimer( self.m_FillTimer ) then
			killTimer(self.m_FillTimer)
		end	
		self:detach()
		player.m_WearingPump = false
		self.m_IsWearing = false
		self.m_AtVehicle = true
		self:attach(self.m_Vehicle, 0.75, 0.25, 0)
		toggleControl(player, "enter_exit", true)
		setElementCollisionsEnabled(self, true)
		unbindKey( player, "enter_exit", "both", self.m_FillBindHandler)
		removeEventHandler("onPlayerWasted", player, self.m_WastedHandler)
		removeEventHandler("onPlayerQuit"  , player, self.m_QuitHandler)
		return true
	end
	return false
end	

function FirePump:equip(player)
	if self:isWearable() and not player.m_WearingPump then
		self.m_AtVehicle = false
		player.m_WearingPump = self
		self.m_IsWearing = player
		self:detach()
		self:attach(player, 0, - 0.55,0,0,0,0)
		setElementCollisionsEnabled(self, false)
		toggleControl(player, "enter_exit", false)
		bindKey( player, "enter_exit", "both", self.m_FillBindHandler)		
		addEventHandler("onPlayerWasted", self.m_IsWearing, self.m_WastedHandler)
		addEventHandler("onPlayerQuit"  , self.m_IsWearing, self.m_QuitHandler)		
	elseif not self:isWearable() and player.m_WearingPump == self then
		self:disarm(player)
	end
end

function FirePump.create(x,y,z,rotx,roty,rotz,vehicle)
	local object = createObject(1337, x,y,z,rotx,roty,rotz)
	setElementCollisionsEnabled(object, false)
	setElementDoubleSided(object, true)
	enew(object, FirePump, vehicle)
	return object
end