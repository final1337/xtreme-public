PermanentVehicleClass = inherit(TemporaryVehicleClass)

function PermanentVehicleClass:constructor(kilometer, pBreak, fuel, id)
    TemporaryVehicleClass.constructor(self, kilometer, pBreak, fuel)
    self:setData("PermanentVehicle", true)
    
    self.m_Interacted = false
    self.m_Owner = {}
    self.Storage = {[8] = ElementStorage:new(8, self)}
	self:setData("GotStorage", true)
    self:setData("Id", id)
end

-- Adds the possibility for more than 1 owner (key-system)

function PermanentVehicleClass:getInteractionState()
    return self.m_Interacted
end

function PermanentVehicleClass:getId()
    return self:getData("Id")
end

function PermanentVehicleClass:saveData()
    local model = self:getModel()
    local variant1, variant2 = self:getVariant()
    local x, y, z = self:getRespawnPosition()
    local rotx, roty, rotz = self:getRespawnRotation()
    local dim = self.RespawnDimension
    local int = self.RespawnInterior
    local numberplate = self:getPlateText()
    local kilometer = self:getData("Kilometer")
    local gasoline = self:getData("Fuel")

    db:exec([[UPDATE vehicles_general SET model = ?, variant1 = ?, variant2 = ?, posX = ?, posY = ?, posZ = ?, rotX = ?, rotY = ?, rotZ = ?, dimension = ?, interior = ?,
    numberplate = ?, kilometer = ?, gasoline = ? WHERE vehicleId = ?]], model, variant1, variant2, x, y, z, rotx, roty, rotz,
                                                                       dim, int, numberplate, kilometer, gasoline, self:getId())
end