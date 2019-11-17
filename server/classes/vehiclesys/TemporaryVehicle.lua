TemporaryVehicleClass = inherit(Object)

registerElementClass("vehicle", TemporaryVehicleClass)

function TemporaryVehicleClass:constructor(kilometer, pBreak, fuel)
    self.m_Data = {}
    self.m_EngineTimer = false

    self:setData("Kilometer", kilometer or 0)
    self:setData("Break", pBreak and pBreak == 1)
    self:setData("Fuel", fuel or 100)
    self:setData("Locked", false)

    self:setData("Engine", false)
    self:setData("Lights", 1)
  
    self:setEngineState(false)
    self:setOverrideLights(1)

    self.m_LastPosition = self:getPosition()

    self.m_EngineBind = bind(self.calculateFuelAndDistance, self)
end

function TemporaryVehicleClass:setLockState(bool)
    self:setLocked(bool)
    self:setData("Locked", bool)
end

function TemporaryVehicleClass:isEmpty()
    for key, value in pairs(self:getOccupants()) do
        return false
    end
    return true
end

function TemporaryVehicleClass:getOccupantAmount()
    local i = 0
    for key, value in pairs(self:getOccupants()) do
        i = i + 1
    end
    return i
end

function TemporaryVehicleClass:setBreakState(bool)
    if bool then
        self:setHandling("mass", 9000)
        self:setHandling("turnMass", 50000)
        self:setHandling("tractionMultiplier", 5)
        self:setHandling("engineAcceleration", self:getHandling()["engineAcceleration"]*0.02)
        self:setHandling("maxVelocity", self:getHandling()["maxVelocity"]*0.02)        
    else
        self:setHandling("mass", getOriginalHandling(self:getModel())["mass"])
        self:setHandling("turnMass", getOriginalHandling(self:getModel())["turnMass"])
        self:setHandling("tractionMultiplier", getOriginalHandling(self:getModel())["tractionMultiplier"])
        self:setHandling("engineAcceleration", getOriginalHandling(self:getModel())["engineAcceleration"])
        self:setHandling("maxVelocity", getOriginalHandling(self:getModel())["maxVelocity"]) 
    end
    self:setData("Break", bool)
end

function TemporaryVehicleClass:getBreakState()
    return self:getData("Break")
end

function TemporaryVehicleClass:getLockState()
    return self:getData("Locked")
end

function TemporaryVehicleClass:setUntouchable()
    self:setData("Untouchable", true)
    Timer(TemporaryVehicleClass.setData, 5000, 1, self, "Untouchable", false)
end

function TemporaryVehicleClass:calculateFuelAndDistance()
    if isElement(self) and self:getOccupants()[0] then
        if self:getEngineStatus() then
            local currentPosition = self:getPosition()

            if self.m_LastPosition then
                local dist = (currentPosition-self.m_LastPosition):getLength()
                -- Exclude teleports or buggy behaviour
                if dist > 1 and dist < 1000 then
                    self:setData("Kilometer", self:getData("Kilometer") + dist)


                    self:setData("Fuel", math.max(0, self:getData("Fuel") - dist/1000))

                    if self:getData("Fuel") == 0 then
                        self:getOccupants()[0]:sendMessage("Your fuel is empty.", 120, 0 ,0)
                        self:getOccupants()[0]:sendNotification("Your fuel is empty.", 120, 0 ,0)
                        self:setEngineState(false)
                        self:setData("Engine", false)
                        self.m_EngineTimer:destroy()
                    end
                end

            end

            self.m_LastPosition = currentPosition
        end
    else
        self.m_EngineTimer:destroy()
    end
end

function TemporaryVehicleClass:changeEngine(player)
    if self:isAligable(player) and self:getData("Fuel") > 0 then
        self:setEngineState( not self:getEngineState())
        if self:getEngineState() then
            self.m_EngineTimer = Timer(self.m_EngineBind, 1000, 0)
        end
    else
        self:setEngineState(false)
    end

    if isTimer(self.m_EngineTimer) and not self:getEngineState() then
        self.m_EngineTimer:destroy()
    end

    self:setData("Engine", self:getEngineState())
end

function TemporaryVehicleClass:changeLights(player)
    if self:isAligable(player) then
        self:setOverrideLights( self:getData("Lights") == 1 and 2 or 1)
    end
    self:setData("Lights", self:getOverrideLights())
end

function TemporaryVehicleClass:getEngineStatus()
    return self:getData("Engine")
end

function TemporaryVehicleClass:setData(key, value, noSync)
	self.m_Data[key] = value
	if not noSync then
		setElementData(self, key, value)
	end
end

function TemporaryVehicleClass:isAligable(player)
    return true
end

function TemporaryVehicleClass:getData(key)
	return getElementData(self,key) or self.m_Data[key]
end

function TemporaryVehicleClass:getLobby()
    return lobbymanager:getLobbys()[1][1]
end