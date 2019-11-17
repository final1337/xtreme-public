FactionVehicleClass = inherit(PermanentVehicleClass)

function FactionVehicleClass:constructor(kilometer, pBreak, fuel, id, faction, preDenial)
    PermanentVehicleClass.constructor(self, kilometer, pBreak, fuel, id)

    self:setData("Fraktion", faction)
    self:setData("Faction", faction)
    self:setData("PreDenial", preDenial == 1)

    self.m_Access = {}
end

function FactionVehicleClass:addAccess(faction, rang)
    self.m_Access[faction] = rang
end

function FactionVehicleClass:newAccess(faction, rang)
    if not self.m_Access[faction] then
        db:exec("INSERT INTO vehicles_faction_permission (vehicleId, faction, rank) VALUES(?,?,?)", self:getId(), faction, rang)
    else
        db:exec("UPDATE vehicles_faction_permission SET rank = ? WHERE vehicleId = ?", self:getId())
    end
    self:addAccess(faction, rang)
end

function FactionVehicleClass:removeAccess(faction)
    db:exec("DELETE FROM vehicles_faction_permission WHERE vehicleId = ? AND faction = ?", self:getId(), faction)
    self.m_Access[faction] = nil
end

function FactionVehicleClass:isPreDeny()
    return self:getData("PreDenial")
end

function FactionVehicleClass:getAccess()
    return self.m_Access
end

function FactionVehicleClass:isAligable(player)
    if not self.m_Interacted then
        self.m_Interacted = true
        vehiclemanager:loadItems(self)
    end
    if self.m_Access[player:getData("Fraktion")] and player:getData("Rang") >= self.m_Access[player:getData("Fraktion")] then
        return true
    end
    return false
end

function FactionVehicleClass:addSirens()
    addFactionSirens(self)
end

function FactionVehicleClass.new(model, posX, posY, posZ, rotX, rotY, rotZ, numberplate, factionId)
    local query = db:query("INSERT INTO vehicles_general (model, posX, posY, posZ, rotX, rotY, rotZ, numberplate) VALUES (?,?,?,?,?,?,?,?)",
                    model, posX, posY, posZ, rotX, rotY, rotZ, numberplate)
    local result, num_affected_rows, last_insert_id = db:poll(query, -1)
    local vehicleId = last_insert_id
    
    db:exec("INSERT INTO vehicles_faction (vehicleId, factionId, colorId) VALUES (?,?,?)", vehicleId, factionId, factionId)

    local veh = Vehicle(model, posX, posY, posZ, rotX, rotY, rotZ, numberplate, false, 0, 0)
    enew(veh, FactionVehicleClass, 0, false, 100, vehicleId)

    veh.RespawnInterior = 0
    veh.RespawnDimension = 0

    vehiclemanager:addVehicle(veh, "faction", factionId)

    return veh
end

function FactionVehicleClass.delete(vehicle)
    if not vehicle.getOwner then
        return
    end

    vehiclemanager:removeVehicle(vehicle, "faction")

    dbExec("DELETE FROM vehicles_general WHERE vehicleId = ?", vehicle:getId())
    dbExec("DELETE FROM vehicles_faction WHERE vehicleId = ?", vehicle:getOwner(), vehicle:getId())
    dbExec("DELETE FROM vehicles_faction_permission WHERE vehicleId = ?", vehicle:getId())

    destroyElement(vehicle)
end

function FactionVehicleClass.showAccess(player)
    local veh = player:getOccupiedVehicle()
    if not veh then return end
    if veh:getData("Faction") and player:getData("Adminlevel") > 2 then
        player:sendMessage("Dieses Auto kann benutzt werden von: ", 255, 255, 0)
        for key, value in pairs(veh:getAccess()) do
            player:sendMessage("%s mit Rang %d", 255, 255, 0, Fraktionen["Namen"][key], value)
        end
    end
end
addCommandHandler("showaccess", FactionVehicleClass.showAccess)

function FactionVehicleClass.Command_AddAccess(player, _, faction, rank)
    local veh = player:getOccupiedVehicle()
    if not veh then return end
    if veh:getData("Faction") and tonumber(faction) and tonumber(rank) and player:getData("Adminlevel") > 2 then
        veh:newAccess(tonumber(faction), tonumber(rank))
        player:sendMessage("Zugang hinzugefügt!", 255, 255, 0)
    end
end
addCommandHandler("addaccess", FactionVehicleClass.Command_AddAccess)

function FactionVehicleClass.Command_DeleteAccess(player, _, faction)
    local veh = player:getOccupiedVehicle()
    if not veh then return end
    if veh:getData("Faction") and tonumber(faction) and player:getData("Adminlevel") > 2 then
        veh:removeAccess(tonumber(faction))
        player:sendMessage("Zugang entfernt!", 255, 255, 0)
    end
end
addCommandHandler("delaccess", FactionVehicleClass.Command_DeleteAccess)