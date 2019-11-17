Tuning = inherit(Singleton)

addEvent("RP:Server:Tuning:add", true)
addEvent("RP:Server:Tuning:remove", true)
addEvent("RP:Server:Tuning:back", true)


Tuning.TuningPos = Vector3(1393.0378417969, -16.850021362305, 1000.9185791016)

Tuning.Garages = {
    {
        Enter = Vector3(-1936.19140625, 247.0615234375, 33.4609375),
        LeavePos = Vector3(-1936.7314453125, 221.8056640625, 34.3125),
        LeaveRot = Vector3(0,0,90),
    }
}

setGarageOpen( 7, true)
setGarageOpen(10, true)
setGarageOpen(15, true)
setGarageOpen(18, true)
setGarageOpen(33, true)

function Tuning:constructor()

    self.m_Marker = {}
    self.m_InsideTuning = {}
    self.m_UsedDimensions = {}

    for key, value in ipairs(Tuning.Garages) do
        self.m_Marker[key] = Marker( value.Enter, "cylinder", 3)
        self.m_Marker[key]:setData("Garage", key)

        addEventHandler("onMarkerHit", self.m_Marker[key],
            function (hitElement)
                if hitElement:getType() == "vehicle" and hitElement:getOccupants()[0] and hitElement.getOwner then
                    local player = hitElement:getOccupants()[0]
                    if hitElement:getOccupantAmount() ~= 1 then
                        player:sendMessage("Das Fahrzeug darf nur einen Fahrer haben.")
                        return
                    end
                    if hitElement:getOwner() ~= player:getId() then
                        player:sendMessage("Sie sind nicht der Besitzer des Fahrzeugs.")
                        return
                    end
                    local freeDimension = self:getFreeDimension()
                    hitElement:setInterior(1)
                    hitElement:setDimension(freeDimension)
                    hitElement:setPosition(Tuning.TuningPos)
                    hitElement:setRotation(0,0,0)
                    hitElement:setFrozen(true)
                    Timer(setElementFrozen, 750, 1, hitElement, false)
                    toggleAllControls(player, false)
                    self:addTuning(player, source:getData("Garage"), hitElement)
                    player:setInterior(1)
                    player:setDimension(freeDimension)
                    player:triggerEvent("RP:Client:Tuning:open", hitElement, source:getData("Garage"))
                end
            end
        )

    end

    addEventHandler("RP:Server:Tuning:add", root, bind(self.Event_Add, self))
    addEventHandler("RP:Server:Tuning:remove", root, bind(self.Event_Remove, self))
    addEventHandler("RP:Server:Tuning:back", root, bind(self.Event_TeleportBack, self))
    addEventHandler("onPlayerQuit", root, bind(self.Event_OnPlayerQuit, self))
    addEventHandler("onPlayerWasted", root, bind(self.Event_OnPlayerWasted, self))
end

function Tuning:getFreeDimension()
	for i = 512, 712, 1 do -- Max number of players is 200
		if not self.m_UsedDimensions[i] then
			self.m_UsedDimensions[i] = true
			return i
		end
	end
	return false
end

function Tuning:Event_OnPlayerWasted()
    for key, value in ipairs(self.m_InsideTuning) do
        if value.Player == source then
            source:triggerEvent("RP:Client:Tuning:close")
            break
        end
    end  
end

function Tuning:Event_OnPlayerQuit()
    for key, value in ipairs(self.m_InsideTuning) do
        if value.Player == source then
            self:teleportBack(source, value.Garage)
            break
        end
    end
end

function Tuning:Event_TeleportBack(garageId)
    if not client then return end
    self:teleportBack(client,garageId)
end

function Tuning:addTuning(player, id, vehicle)
    table.insert(self.m_InsideTuning, {Player = player, Garage = id, Vehicle = vehicle})
end

function Tuning:isTuning(player)
    for key, value in ipairs(self.m_InsideTuning) do
        if value.Player == player then
            return value
        end
    end
    return false
end

function Tuning:removeTuning(player)
    for key, value in ipairs(self.m_InsideTuning) do
        if value.Player == player then
            table.remove(self.m_InsideTuning, key)
            break
        end
    end
end

function Tuning:teleportBack(player, garageId)
    local data = self:isTuning(player)
    local veh = data.Vehicle
    local occupiedDimension = player:getDimension()
    self.m_UsedDimensions[occupiedDimension] = nil
    veh:setUntouchable()
    player:setCameraTarget(player)
    toggleAllControls(player, true)
    veh:setInterior(0)
    player:setInterior(0)
    player:setDimension(0)
    veh:setDimension(0)
    veh:setFrozen(false)
    local garage = Tuning.Garages[garageId]
    veh:setPosition(garage.LeavePos)
    veh:setRotation(garage.LeaveRot)
    self:removeTuning(player)
end

function Tuning:Event_Remove(part)
    if not client then return end
    local veh = client:getOccupiedVehicle()
    veh:removeUpgrade(part)
end

function Tuning:Event_Add(part1, part2, part3, colorBase)
    if not client then return end
    -- If there is only one part its not a color
    if not part2 then
        local veh = client:getOccupiedVehicle()
        veh:addUpgrade(part1)
        client:takeMoney(TuningPrices[part1])
        putMoneyInBusiness(3, TuningPrices[part1])
    elseif type(part1) == "string" then
        local veh = client:getOccupiedVehicle()
        veh:setPaintjob(part2)
        client:takeMoney(15000)
        putMoneyInBusiness(3, 15000)
    else
        local veh = client:getOccupiedVehicle()
        local c = {veh:getColor(true)}
        local r,g,b = part1, part2, part3
        local cur = colorBase
        c[1+(cur-1)*3] = r
        c[2+(cur-1)*3] = g
        c[3+(cur-1)*3] = b
        veh:setColor(unpack(c))   
        client:takeMoney(500) 
        putMoneyInBusiness(3, 500)    
    end 
end

function Tuning:destructor()

end
