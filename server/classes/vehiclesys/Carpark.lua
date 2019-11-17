Carpark = inherit(Object)

addEvent("RP:Server:Carpark:removeVehicle", true)
addEvent("RP:Server:Carpark:addVehicle", true)
addEvent("RP:Server:Carpark:requestVehicles", true)

function Carpark:constructor(id, enterX, enterY, enterZ, enterSize, enterDimension, enterInterior,
                             leaveX, leaveY, leaveZ, rotX, rotY, rotZ, leaveDimension, leaveInterior)
    self.m_Id = id
    self.m_EnterMarker = Marker(enterX, enterY, enterZ, "cylinder", enterSize)
    self.m_EnterMarker:setDimension(enterDimension)
    self.m_EnterMarker:setInterior(enterInterior)
    self.m_EnterMarker:setColor(100, 100, 255, 125)

    self.m_LeavePosition = Vector3(leaveX, leaveY, leaveZ)
    self.m_LeaveRotation = Vector3(rotX, rotY, rotZ)
    self.m_LeaveInterior = leaveInterior
    self.m_LeaveDimension = leaveDimension

    self.m_LeaveMarker = Marker(self.m_LeavePosition - Vector3(0, 0, 1), "cylinder", 4.5)
    self.m_LeaveMarker:setColor(255, 255, 0, 100)

    self.m_Vehicles = {}


    addEventHandler("RP:Server:Carpark:removeVehicle", root, bind(self.Event_RemoveVehicle, self))
    addEventHandler("RP:Server:Carpark:addVehicle", root, bind(self.Event_AddVehicle, self))
    addEventHandler("RP:Server:Carpark:requestVehicles", root, bind(self.Event_RequestVehicles, self))
    addEventHandler("onMarkerHit", self.m_EnterMarker, bind(self.Event_MarkerHit, self))
end

function Carpark:Event_RequestVehicles(carparkId, all)
    if not client then return end
    if carparkId ~= self.m_Id then return end
    self:sendVehicleInformation(client, all)
end

function Carpark:Event_MarkerHit(hitElement, matchingDimension)
    if hitElement and isElement(hitElement) and hitElement:getType() == "player" and matchingDimension and not hitElement:getOccupiedVehicle() then
        local vehicles = self:getPlayerVehicles(hitElement)
        self:sendVehicleInformation(hitElement)
    end
end

function Carpark:sendVehicleInformation(player, all)
    local vehicles = self:getPlayerVehicles(player, all)
    player:triggerEvent("RP:Client:Carpark:openWindow", self.m_Id, vehicles)
end

function Carpark:getPlayerVehicles(player, all)
    local temp = {}
    local tempOwnerName = {}
    for key, value in ipairs(self.m_Vehicles) do
        if value:isAligable(player) or all then
            local name
            if not tempOwnerName[value:getOwner()] then
                tempOwnerName[value:getOwner()] = getPlayerData("userdata","ID",value:getOwner(),"Username")
                name = tempOwnerName[value:getOwner()]
            else
                name = tempOwnerName[value:getOwner()]
            end
            table.insert(temp, {Id = value:getId(), Vehicle = value, Owner = value:getOwner(), OwnerName = name})
        end
    end
    return temp
end

function Carpark:Event_AddVehicle(carparkId)
    if not client then return end
    if carparkId ~= self.m_Id then return end
    local colshape = self.m_LeaveMarker:getColShape()
    local elements = colshape:getElementsWithin()
    local added = false
    for key, vehicle in ipairs(elements) do
        if isElement(vehicle) and getElementType(vehicle) == "vehicle" then
            if vehicle.getOwner and vehicle:isAligable(client) then
                self:addVehicle(vehicle)
                added = true
            end
        end
    end
    if added then
        self:sendVehicleInformation(client)
    end
end

function Carpark:Event_RemoveVehicle(carparkId, vehicle)
    if not client then return end
    if carparkId ~= self.m_Id then return end
    if vehicle and isElement(vehicle) then
        if vehicle:isAligable(client) or client:getData("Adminlevel") >= 2 then
            self:removeVehicle(vehicle)
            -- Teleport the player into the vehicle if is not already sitting in another one
            if not client:getOccupiedVehicle() then
                client:warpIntoVehicle(vehicle, 0)
            end
        end
    end
end

function Carpark:getEnterMarker() return self.m_EnterMarker end
function Carpark:getEnterDimension() return self.m_EnterMarker:getDimension() end
function Carpark:getEnterInterior() return self.m_EnterMarker:getInterior() end

function Carpark:getLeavePosition() return self.m_LeavePosition end
function Carpark:getLeaveRotation() return self.m_LeaveRotation end
function Carpark:getLeaveInterior() return self.m_LeaveInterior end
function Carpark:getLeaveDimension() return self.m_LeaveDimension end

function Carpark:addVehicle(vehicle)
    if not ( self.m_LeaveMarker:getDimension() == vehicle:getDimension() ) then
        return
    end

    table.insert(self.m_Vehicles, vehicle)

    for key, value in pairs(vehicle:getOccupants()) do
        value:removeFromVehicle()
    end

    vehicle:setInterior(1000)
    vehicle:setDimension(1000)
    vehicle:setCollisionsEnabled(false)

    vehicle:setCarpark(self.m_Id)
end

-- Returns a boolean
function Carpark:removeVehicle(vehicle)
    local gotRemoved = false
    for key, value in ipairs(self.m_Vehicles) do
        if value == vehicle then
            table.remove(self.m_Vehicles, key)
            vehicle:setCarpark(0)
            gotRemoved = true
            break
        end
    end

    if gotRemoved then
        vehicle:setInterior(self.m_LeaveInterior)
        vehicle:setDimension(self.m_LeaveInterior)
        vehicle:setHealth(1000)
        vehicle:setCollisionsEnabled(true)
        vehicle:setPosition(self.m_LeavePosition)
        vehicle:setRotation(self.m_LeaveRotation)
        vehicle:setUntouchable()
    end

    return gotRemoved

end

function Carpark:getVehicles()
    return self.m_Vehicles
end