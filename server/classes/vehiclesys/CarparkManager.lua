
CarparkManager = inherit(Singleton)

function CarparkManager:constructor()
    self.m_Carparks = {}
    
    self:init()
end

function CarparkManager:init()
    local query = db:query("SELECT * FROM carparks")
    local result = db:poll(query, - 1)

    local carpark

    for key, value in ipairs(result) do
        carpark = Carpark:new(value.Id, value.enterX, value.enterY, value.enterZ, value.enterSize, value.enterDimension, value.enterInterior,
        value.leaveX, value.leaveY, value.leaveZ, value.rotX, value.rotY, value.rotZ, value.leaveDimension, value.leaveInterior)
        self.m_Carparks[value.Id] = carpark
    end
end

function CarparkManager:getCarparks()
    return self.m_Carparks
end


