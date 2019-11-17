FireVehicleLadder = inherit(FireVehicle)

addEvent("XTM:FF:getOnVehicle",	true)

FireVehicleLadder.MAX_PULLBACK = 6
FireVehicleLadder.MAX_ROTATE_XAXIS = 50 -- Deg

function FireVehicleLadder:constructor(kilometer, pBreak, fuel, id, faction, preDenial)
	FireVehicle.constructor(self, kilometer, pBreak, fuel, id, faction, preDenial)
	
	self.m_Recharge = false
	
	self:setData("Tank", 1)
	self:setData("TankMaximum", 1)
	self:setData("AufsteigbarDesc", "Möglich")
	self:setData("PumpeDesc", "Nicht vorhanden")
	
	self.m_Pull = FireVehicleLadder.MAX_PULLBACK
	self.m_RotX = 100
	self.m_RotZ = 0
	
	self.m_MainLadder = createObject ( 1437, -2578.2705078125,655.134765625,27.8125)
	self.m_MainLadder:attach(self, 0, 0, 1.4, self.m_RotX, 0, 0)
	self.m_PullLadder = createObject( 1437, -2578.2705078125,655.134765625,27.8125)
	self.m_PullLadder:attach(self.m_MainLadder, 0.1, 1.1, 6.2)

	setElementData(self.m_MainLadder,"Fireladder", self)
	setElementData(self.m_PullLadder,"Fireladder", self)
	
	triggerClientEvent(root, "setObjectsUnbreakable", root, { self.m_MainLadder, self.m_PullLadder })
	
	--attachElements(anothehrladdder, obj, 0.1, 1.1 - einziehen * 0.15, 6.2 - einziehen)
	
	--[[setTimer( function () 
		self.m_RotX = self.m_RotX - 0.3
		self.m_Pull = self.m_Pull + 0.1
		self.m_Pull = math.min(FireVehicleLadder.MAX_PULLBACK, self.m_Pull)
		self.m_RotX = math.min ( 100, math.max ( FireVehicleLadder.MAX_ROTATE_XAXIS, self.m_RotX ))
		
		
		attachElements(self.m_MainLadder, self, 0, 0, 1.3, self.m_RotX, 0, 90 )
		attachElements(self.m_PullLadder, self.m_MainLadder, 0.1, 1.1 - self.m_Pull * 0.15, 6.2 - self.m_Pull)
	end, 50, 0)]]

	
	self.m_PullLadder:attach ( self.m_MainLadder, 0, 1.1 -  FireVehicleLadder.MAX_PULLBACK * 0.15, 6.2 - FireVehicleLadder.MAX_PULLBACK)
	
	-- Add events, etc.
	self.m_RotateOnZAxis = bind(self.rotateZ, self)
	self.m_RotateOnXAxis = bind(self.rotateX, self)
	self.m_PullLadderHandler    = bind(self.pushLadder, self)
	self.m_JoinHandler = bind(self.setLaddersUnbreakable, self)
	addEventHandler("onVehicleEnter", self, bind(self.Event_OnVehicleEnter, self))
	addEventHandler("onVehicleExit", self, bind(self.Event_OnVehicleLeave, self))	
		
	addEventHandler("loginSuccess", root, self.m_JoinHandler)
	addEventHandler("XTM:FF:getOnVehicle", self, bind(self.Event_GetOnVehicle, self))
	addEventHandler("onVehicleRespawn", self, bind(self.resetLadder, self))
end

function FireVehicleLadder:resetLadder()
	self.m_Pull = FireVehicleLadder.MAX_PULLBACK
	self.m_RotX = 100
	self.m_RotZ = 0	
	self.m_MainLadder:attach(self, 0, 0, 1.4, self.m_RotX, 0, 0)
	self.m_PullLadder:attach ( self.m_MainLadder, 0, 1.1 -  FireVehicleLadder.MAX_PULLBACK * 0.15, 6.2 - FireVehicleLadder.MAX_PULLBACK)
end

function FireVehicleLadder:setLaddersUnbreakable()
	triggerClientEvent(root, "setObjectsUnbreakable", root, { self.m_MainLadder, self.m_PullLadder })
end

function FireVehicleLadder:rotateX(player, key, state)
	if state == "down" then
		if isTimer(self.m_RotXTimer) then
			killTimer(self.m_RotXTimer)
		end
		self.m_RotXTimer = setTimer ( function (pressedKey)
			local diff = pressedKey == "num_5" and 1 or -1
			self.m_RotX = self.m_RotX + diff
			self.m_RotX = math.min ( 100, math.max ( FireVehicleLadder.MAX_ROTATE_XAXIS, self.m_RotX ))
			attachElements(self.m_MainLadder, self, 0, 0, 1.3, self.m_RotX, 0, self.m_RotZ)
		end, 50, 0, key)
	elseif state == "up" then
		if isTimer(self.m_RotXTimer) then
			killTimer(self.m_RotXTimer)
		end	
	end
end

function FireVehicleLadder:Event_GetOnVehicle()
	if not client then return end
	if not getPedOccupiedVehicle(client) then
		local x,y,z = getElementPosition(self)
		setElementPosition(client, x,y, z + 2.2)
	end
end

function FireVehicleLadder:rotateZ(player, key, state)
	if state == "down" then
		if isTimer(self.m_RotZTimer) then
			killTimer(self.m_RotZTimer)
		end
		self.m_RotZTimer = setTimer ( function (pressedKey)
			local diff = pressedKey == "num_4" and 1 or -1
			self.m_RotZ = self.m_RotZ + diff
			attachElements(self.m_MainLadder, self, 0, 0, 1.4, self.m_RotX, 0, self.m_RotZ)
		end, 50, 0, key)
	elseif state == "up" then
		if isTimer(self.m_RotZTimer) then
			killTimer(self.m_RotZTimer)
		end	
	end
end

function FireVehicleLadder:pushLadder(player, key, state)
	if state == "down" then
		if isTimer(self.m_PullTimer) then
			killTimer(self.m_PullTimer)
		end
		self.m_PullTimer = setTimer ( function (pressedKey)
			local diff = pressedKey == "num_7" and -0.15 or 0.15
			self.m_Pull = self.m_Pull + diff
			self.m_Pull = math.max ( 0.5, math.min(FireVehicleLadder.MAX_PULLBACK, self.m_Pull))
			attachElements(self.m_PullLadder, self.m_MainLadder, 0, 1.1 - self.m_Pull * 0.15, 6.2 - self.m_Pull)
		end, 50, 0, key)
	elseif state == "up" then
		if isTimer(self.m_PullTimer) then
			killTimer(self.m_PullTimer)
		end	
	end
end

function FireVehicleLadder:Event_OnVehicleEnter(player, seat)
	if seat == 0 then
		self:setLaddersUnbreakable()
		bindKey(player, "num_4", "both", self.m_RotateOnZAxis)
		bindKey(player, "num_6", "both", self.m_RotateOnZAxis)
		bindKey(player, "num_8", "both", self.m_RotateOnXAxis)
		bindKey(player, "num_5", "both", self.m_RotateOnXAxis)
		bindKey(player, "num_7", "both", self.m_PullLadderHandler)
		bindKey(player, "num_9", "both", self.m_PullLadderHandler)	
		toggleControl(player,"vehicle_fire", false)
		toggleControl(player,"vehicle_secondary_fire", false)
		toggleControl(player, "special_control_left", false)
		toggleControl(player, "special_control_right", false)		
		--bindKey(player, "vehicle_fire", "up", self.m_ShootHandler)
	end
end


function FireVehicleLadder:Event_OnVehicleLeave(player, seat)
	if seat == 0 then
		unbindKey(player, "num_4", "both", self.m_RotateOnZAxis)
		unbindKey(player, "num_6", "both", self.m_RotateOnZAxis)
		unbindKey(player, "num_8", "both", self.m_RotateOnXAxis)
		unbindKey(player, "num_5", "both", self.m_RotateOnXAxis)
		unbindKey(player, "num_7", "both", self.m_PullLadderHandler)
		unbindKey(player, "num_9", "both", self.m_PullLadderHandler)	
		toggleControl(player,"vehicle_fire", true)
		toggleControl(player,"vehicle_secondary_fire", true)	
		toggleControl(player, "special_control_left", true)
		toggleControl(player, "special_control_right", true)			
		if isTimer(self.m_PullTimer) then
			killTimer(self.m_PullTimer)
		end		
		if isTimer(self.m_RotZTimer) then
			killTimer(self.m_RotZTimer)
		end		
		if isTimer(self.m_RotXTimer) then
			killTimer(self.m_RotXTimer)
		end			
	end
end

function FireVehicleLadder.create(x,y,z,rotx,roty,rotz,plate)
	local vehicle = Vehicle(407, x,y,z,rotx,roty,rotz,plate)
	enew(vehicle, FireVehicleLadder)
	return vehicle
end

function FireVehicleLadder:destructor()
	removeEventHandler("onPlayerJoin", root, self.m_JoinHandler)
end