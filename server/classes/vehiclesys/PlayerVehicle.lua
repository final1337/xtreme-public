PlayerVehicleClass = inherit(PermanentVehicleClass)

function PlayerVehicleClass:constructor(kilometer, pBreak, fuel, id, faction, preDenial)
    PermanentVehicleClass.constructor(self, kilometer, pBreak, fuel, id)
    self.m_Owner = false
    self.m_Keys = {}

    self:setLockState(true)
    self:setBreakState(true)
end

function PlayerVehicleClass:setOwner(id)
    self.m_Owner = id
    self:setData("Owner", id)
end

function PlayerVehicleClass:addKey(playerId, hour)
    if self:gotKey(playerId) then
        return 
    end
    db:exec("INSERT INTO vehicles_player_keys (playerId, vehicleId, expireDate) VALUES (?,?,?)", playerId, self:getId(), getRealTime()["timestamp"]+(math.ceil(hour)*60*60))
    table.insert(self.m_Keys, {PlayerId = playerId, ExpireDate = getRealTime()["timestamp"]+(math.ceil(hour)*60*60)})
end

function PlayerVehicleClass:changeOwner(playerId)
    local ownerCopy = self:getOwner()
    db:exec("UPDATE vehicles_player SET playerId = ? WHERE playerId = ? AND vehicleId = ?", playerId, ownerCopy, vehicle:getId())
    self:setOwner(playerId)
    dbExec("DELETE FROM vehicles_player_keys WHERE vehicleId = ?", vehicle:getId())
end

function PlayerVehicleClass:removeKey(playerId)
    for key, value in ipairs(self.m_Keys) do
        if value.PlayerId == playerId then
            table.remove(self.m_Keys, key)
            db:exec("DELETE FROM vehicles_player_keys WHERE vehicleId=? AND playerId=?", self:getId(), playerId)
            break
        end
    end
end

function PlayerVehicleClass:isAligable(player)
    if not self.m_Interacted then
        self:loadKeys()
        vehiclemanager:loadItems(self)       
        self.m_Interacted = true
    end
    return self:gotKey(player) or self.m_Owner == player:getId()
end

function PlayerVehicleClass:loadKeys()
    local query = db:query("SELECT * FROM vehicles_player_keys WHERE vehicleId = ?", self:getId())
    local result = db:poll(query, - 1)

    local now = getRealTime()["timestamp"]

    for key, value in ipairs(result) do
        if now >= value.expireDate then
            db:exec("DELETE FROM vehicles_player_keys WHERE vehicleId=? AND playerId=?", self:getId(), value.playerId)
        else
            table.insert(self.m_Keys, {PlayerId = value.playerId, ExpireDate = value.expireDate})
        end
    end
end

function PlayerVehicleClass:checkKeys()
    local now = getRealTime()["timestamp"]
    for key, value in ipairs(self.m_Keys) do
        if now >= value.ExpireDate then
            db:exec("DELETE FROM vehicles_player_keys WHERE vehicleId=? AND playerId=?", self:getId(), id)
            table.remove(self.m_Keys, key)
        end
    end
end

function PlayerVehicleClass:getKeys()
    self:checkKeys()
    return self.m_Keys
end

function PlayerVehicleClass:setCarpark(id)
    if id ~= self:getData("Carpark") then
        db:exec("UPDATE vehicles_player SET carparkId = ? WHERE vehicleId = ?", id, self:getId())
    end
    self:setData("Carpark", id)
end

function PlayerVehicleClass:getCarpark()
    return self:getData("Carpark"), self:getData("Carpark") ~= 0 and carparkmanager:getCarparks()[self:getData("Carpark")] or nil
end

function PlayerVehicleClass:getOwner() return self.m_Owner end

-- Possible arguments: player or playerId
function PlayerVehicleClass:gotKey(playerId)
    if isElement(playerId) then
        playerId = playerId:getId()
    end
    -- Check if one of the keys is expired
    self:checkKeys()
    for key, value in ipairs(self.m_Keys) do
        if value.PlayerId == playerId then
            return true
        end
    end
    return false
end

function PlayerVehicleClass:saveData()
    if PermanentVehicleClass.saveData then
        PermanentVehicleClass.saveData(self)
    end
    local color = {self:getColor(true)}
    local tunings = vehiclemanager:getTuningString(self)
    local breaked = self:getBreakState() and 1 or 0
    local towed = 0
    local paintjob = self:getPaintjob()
    local color1 = vehiclemanager:combineColor(color[1], color[2], color[3])
    local color2 = vehiclemanager:combineColor(color[4], color[5], color[6])
    local color3 = vehiclemanager:combineColor(color[7], color[8], color[9])
    local color4 = vehiclemanager:combineColor(color[10], color[11], color[12])
    db:exec("UPDATE vehicles_player SET paintjob = ?, color1 = ?, color2 = ?, color3 = ?, color4 = ?, tunings = ? WHERE vehicleId = ?",
            paintjob, color1, color2, color3, color4, tunings, self:getId())
end

function PlayerVehicleClass.new(model, posX, posY, posZ, rotX, rotY, rotZ, numberplate, playerId)
    local query = db:query("INSERT INTO vehicles_general (model, posX, posY, posZ, rotX, rotY, rotZ, numberplate) VALUES (?,?,?,?,?,?,?,?)",
                    model, posX, posY, posZ, rotX, rotY, rotZ, numberplate)
    local result, num_affected_rows, last_insert_id = db:poll(query, -1)
    local vehicleId = last_insert_id
    
    db:exec("INSERT INTO vehicles_player (vehicleId, playerId) VALUES (?,?)", vehicleId, playerId)

    local veh = Vehicle(model, posX, posY, posZ, rotX, rotY, rotZ, numberplate, false, 0, 0)
    enew(veh, PlayerVehicleClass, 0, false, 100, vehicleId)

    veh:setOwner(playerId)
    veh:setCarpark(0)
    veh.RespawnInterior = 0
    veh.RespawnDimension = 0

    vehiclemanager:addVehicle(veh, "player", playerId)

    return veh
end

function PlayerVehicleClass.delete(vehicle)
    if not vehicle.getOwner then
        return
    end

    if vehicle:getCarpark() ~= 0 then
        carparkmanager:getCarparks()[vehicle:getCarpark()]:removeVehicle(vehicle)
    end

    vehiclemanager:removeVehicle(vehicle, "player")

    db:exec("DELETE FROM vehicles_general WHERE vehicleId = ?", vehicle:getId())
    db:exec("DELETE FROM vehicles_player WHERE vehicleId=?", vehicle:getId())
    db:exec("DELETE FROM vehicles_player_keys WHERE vehicleId = ?", vehicle:getId())

    destroyElement(vehicle)
end

addCommandHandler("loadprivatevehicles",
    function (player)
        if true then return end
        local query = db:query([[SELECT * FROM vehicles]])
        local result = db:poll(query, -1)

        if #result == 0 then return end

        local userNameToUserId = {}

        local userquery = db:query("SELECT Username, ID FROM userdata")
        local userresult = db:poll(userquery, -1)
        
        for k, v in ipairs(userresult) do
            userNameToUserId[v.Username] = v.ID
        end

        for k,v in ipairs(result) do
            if userNameToUserId[v.Besitzer] then
                PlayerVehicleClass.new(v.Model, v.Spawnx, v.Spawny, v.Spawnz, 0, 0, v.Rotation, v.Besitzer, userNameToUserId[v.Besitzer])
                iprint(k)
            end
        end

    end
)

addCommandHandler("givenewvehicle",
    function(player, cmd, id, target)
        if player:getData("Adminlevel") > 3 then
            local x,y,z = getElementPosition(player)
            if not target then
                target = player
            else
                target = getPlayerFromName(target)
            end
            if not target then return end
            PlayerVehicleClass.new(tonumber(id), x,y,z, 0, 0, getPedRotation(player), target:getName(), target:getId())
            player:sendNotification("New Vehicle has been given.")
        end
    end
)