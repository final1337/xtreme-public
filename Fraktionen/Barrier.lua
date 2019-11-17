Barrier = inherit(Object)

Barrier.MOVE_TIME_FULL = 1500 -- ms
Barrier.ROT_AT_BARRIER = 90 -- rot in deg
Barrier.MOVE_EFFECT = "InOutQuad"
Barrier.COLSHAPE_SIZE = 12 -- gta units

function Barrier:constructor(posX, posY, posZ, rotX, rotY, rotZ, negateMovement, allowedFactions)

	self.m_PosX = posX
	self.m_PosY = posY
	self.m_PosZ = posZ
	self.m_RotX = rotX
	self.m_RotY = rotY
	self.m_RotZ = rotZ
	self.m_AllowedFactions = allowedFactions

	self.m_MoveStyle = negateMovement and -1 or 1

	self.m_MaxRotation = Barrier.ROT_AT_BARRIER

	self.m_Object = createObject (968, posX, posY, posZ, rotX, rotY, rotZ)
	self.m_ColShape = ColShape.Sphere(posX, posY, posZ, Barrier.COLSHAPE_SIZE)
	self.m_Timer = false

	self.m_Counter = 0

	self.m_Open   = false
	self.m_Moving = false
	self.m_MoveDirection = false

	addEventHandler("onColShapeHit", self.m_ColShape, bind(self.Event_OnColShapeHit, self))
	addEventHandler("onColShapeLeave", self.m_ColShape, bind(self.Event_OnColShapeLeave, self))
	addEventHandler("onPlayerQuit", root, bind(self.Event_OnPlayerQuit, self))
end

function Barrier:getObject() return self.m_Object end
function Barrier:setMaxRotation(max) self.m_MaxRotation = max end

function Barrier:setInteractionSize(size)
	self.m_ColShape:destroy()
	self.m_ColShape = ColShape.Sphere(self.m_PosX, self.m_PosY, self.m_PosZ, size)
	self.m_ColShape:attach(self.m_Object, 0, 0, -3.5)
	local x,y,z = getElementPosition(self.m_ColShape)
	self.m_ColShape:detach()

	setTimer(setElementPosition, 1000, 1, self.m_ColShape, x,y,z)

	addEventHandler("onColShapeHit", self.m_ColShape, bind(self.Event_OnColShapeHit, self))
	addEventHandler("onColShapeLeave", self.m_ColShape, bind(self.Event_OnColShapeLeave, self))	
end

function Barrier:isPermitted(player)
	for key, value in ipairs(self.m_AllowedFactions) do
		if getElementData(player, "Fraktion") == value then
			return true
		end
	end
	return false
end

function Barrier:Event_OnPlayerQuit()
	if isElementWithinColShape(source, self.m_ColShape) then
		self.m_Counter = self.m_Counter - 1
	end
end

function Barrier:Event_OnColShapeHit(hitElement, matchingDimension)
	if self:isPermitted(hitElement) and hitElement:getType() == "player" and matchingDimension then
		self.m_Counter = self.m_Counter + 1
		if ( not self.m_Open or self.m_MoveDirection == "down" ) and self.m_MoveDirection ~= "up" then
			self:open()
		end
	end
end

function Barrier:open()
	if isTimer(self.m_Timer) then
		killTimer(self.m_Timer)
	end
	if self.m_Moving then
		if self.m_MoveDirection == "down" then
			local cRotX, cRotY, cRotZ = getElementRotation(self.m_Object)
			local rotToFinal = cRotY - (self.m_RotY - self.m_MaxRotation)
			local lastTime = (rotToFinal/self.m_MaxRotation)*Barrier.MOVE_TIME_FULL
			if self.m_MoveStyle == -1 then
				rotToFinal = (self.m_RotY + self.m_MaxRotation) - cRotY
				lastTime = (rotToFinal/self.m_MaxRotation)*Barrier.MOVE_TIME_FULL
			end

			-- Supress that lastTime is under 50ms; timer limitations

			lastTime = lastTime >= 50 and lastTime or 50

			self.m_MoveDirection = "up"
			self.m_Moving = true

			self.m_Object:move(lastTime, self.m_PosX, self.m_PosY, self.m_PosZ, 0, -rotToFinal *  self.m_MoveStyle, 0, Barrier.MOVE_EFFECT)

			self.m_Timer = Timer ( function () 
				self.m_MoveDirection = false
				self.m_Moving = false
				self.m_Open = true
			end, lastTime, 1)
		end
	else
		self.m_MoveDirection = "up"
		self.m_Moving = true
		
		self.m_Object:move(Barrier.MOVE_TIME_FULL, self.m_PosX, self.m_PosY, self.m_PosZ, 0, -self.m_MaxRotation  * self.m_MoveStyle, 0, Barrier.MOVE_EFFECT)

		self.m_Timer = Timer ( function () 
			self.m_MoveDirection = false
			self.m_Moving = false
			self.m_Open = true
		end, Barrier.MOVE_TIME_FULL, 1)		
	end
end

function Barrier:close()
	if isTimer(self.m_Timer) then
		killTimer(self.m_Timer)
	end
	if self.m_Moving then
		if self.m_MoveDirection == "up" then
			local cRotX, cRotY, cRotZ = getElementRotation(self.m_Object)
			local rotToFinal = cRotY - self.m_RotY
			local lastTime = (-rotToFinal/self.m_MaxRotation)*Barrier.MOVE_TIME_FULL	
			if self.m_MoveStyle == -1 then
				rotToFinal = self.m_RotY - cRotY
				lastTime = (-rotToFinal/self.m_MaxRotation)*Barrier.MOVE_TIME_FULL
			end

			-- Supress that lastTime is under 50ms; timer limitations

			lastTime = lastTime >= 50 and lastTime or 50			

			self.m_MoveDirection = "down"
			self.m_Moving = true

			self.m_Object:move(lastTime, self.m_PosX, self.m_PosY, self.m_PosZ, 0, -rotToFinal * self.m_MoveStyle, 0, Barrier.MOVE_EFFECT)

			self.m_Timer = Timer ( function () 
				self.m_MoveDirection = false
				self.m_Moving = false
				self.m_Open = false
			end, lastTime, 1)
		end
	else
		self.m_MoveDirection = "down"
		self.m_Moving = true
		
		self.m_Object:move(Barrier.MOVE_TIME_FULL, self.m_PosX, self.m_PosY, self.m_PosZ, 0, self.m_MaxRotation  * self.m_MoveStyle, 0, Barrier.MOVE_EFFECT)

		self.m_Timer = Timer ( function () 
			self.m_MoveDirection = false
			self.m_Moving = false
			self.m_Open = false
		end, Barrier.MOVE_TIME_FULL, 1)		
	end
end


function Barrier:Event_OnColShapeLeave(leavingElement, matchingDimension)
	if self:isPermitted(leavingElement) and leavingElement:getType() == "player" and matchingDimension then
		self.m_Counter = self.m_Counter - 1
		if self.m_Counter <= 0 and  self.m_MoveDirection ~= "down" then
			if self.m_Open or self.m_MoveDirection == "up" then
				self:close()
			end
		end
	end
end


function Barrier.initAll()
	for key, value in ipairs(Barrier.Instances) do
		Barrier:new(unpack(value))
	end
end

Barrier.Instances = {
	-- Firefighter instances
	--{ -2563.2, 579.90002, 14.2, 0, 270, 0, true, {10,1,2,3} },
	--{ -2663.25, 580.80499, 14.3,0,270,0, true, {10,1,2,3} },
	--{ -2599, 596.5, 14.2, 0, 270, 90, true, {10,1,2,3}},
	--{ -2614.6001, 628.59998, 14.3, 0,270,90, true, {10,1,2,3}},
	--{ -2613.5, 595, 14.3, 0,270,90, true, {10,1,2,3}},
	--{ -2599.19,  687.59997558594, 27.700000762939, 0, 90, 270, false, {10,1,2,3}},	
	-- SFPD
	{-1701.4419, 687.56891, 24.6938, 0, 270, 90, true, {1,2,3}},
	{-1572.2007, 658.6684, 6.9165, 0, 270, 270, true, {1,2,3}},
	-- Reporter
	{-2485.7487792969, -612.18011474609, 132.33219909668, 0, 268.9599609375, 86.720581054688, true, {4}},
	-- Da Nang Boys
	{-2632.6125, 1330.4034, 6.8887, 0, 270, 358.704, true, {5}},
}

Barrier.initAll()