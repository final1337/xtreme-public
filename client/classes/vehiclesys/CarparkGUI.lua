CarparkGUI = inherit(Singleton)

addEvent("RP:Client:Carpark:openWindow", true)

function CarparkGUI:constructor()
    self.m_Active = false
    self.m_Vehicles = {}

    addEventHandler("RP:Client:Carpark:openWindow", root, bind(self.Event_OpenGUI, self))
end

function CarparkGUI:Event_OpenGUI(id, vehicles)
    if self.m_Active then
        delete(self.m_Window)
    end
    self:createWindow()
    showCursor(true)
    setElementData(localPlayer,"Clicked", true)

    self.m_Active = id
    self.m_Vehicles = vehicles



    for key, value in ipairs(vehicles) do
        local row = self.m_GridList:addRow()
        row:setValue("Id", value.Id)
        row:setValue("Fahrzeug", getVehicleNameFromModel(value.Vehicle:getModel()))
        row:setValue("Besitzer", value.OwnerName)
        row.Vehicle = value.Vehicle
    end

    self.m_Window:setVisible(true)
end


function CarparkGUI:closeWindow()
    delete(self.m_Window)
    showCursor(false)
    setElementData(localPlayer,"Clicked", false)
    self.m_Active = false
    self.m_Vehicles = {}
end

function CarparkGUI:Action_RemoveVehicle()
    local row = self.m_GridList:getActiveRow()

    if not row then return end
    local vehicle = row.Vehicle
    triggerServerEvent("RP:Server:Carpark:removeVehicle", resourceRoot, self.m_Active, vehicle)
    self:closeWindow()
end

function CarparkGUI:Action_AddVehicle()
    triggerServerEvent("RP:Server:Carpark:addVehicle", resourceRoot, self.m_Active)
end

function CarparkGUI:Action_ShowAllVehicles()
    triggerServerEvent("RP:Server:Carpark:requestVehicles", resourceRoot, self.m_Active, true)
end

function CarparkGUI:Action_ShowPlayerVehicles()
    triggerServerEvent("RP:Server:Carpark:requestVehicles", resourceRoot, self.m_Active, false)
end

function CarparkGUI:createWindow()
    self.m_Window = GUIWindow:new(screenWidth/2 - 500/2, screenHeight/2 - 380/2, 500, 380, "Parkhaus", true)
    self.m_Window:setColor(50, 50, 50, 220)

    self.m_Window:getCloseButton().onLeftUp = bind(self.closeWindow, self)

    self.m_Remove = GUIClassicButton:new(loc"VEHPARK_OUT", 255, 330, 115, 40, self.m_Window)
    self.m_Add    = GUIClassicButton:new(loc"VEHPARK_IN", 375, 330, 120, 40, self.m_Window)

    if getElementData(localPlayer,"Adminlevel") > 0 then
        self.m_OwnCars = GUIClassicButton:new(loc"VEHPARK_OWN", 5, 330, 120, 40, self.m_Window)
        self.m_AllCars = GUIClassicButton:new(loc"VEHPARK_ALL", 130, 330, 120, 40, self.m_Window)

        self.m_AllCars.onLeftUp = bind(self.Action_ShowAllVehicles, self)
    else
        self.m_OwnCars = GUIClassicButton:new(loc"VEHPARK_OWN", 5, 330, 245, 40, self.m_Window)
    end

    self.m_OwnCars.onLeftUp = bind(self.Action_ShowPlayerVehicles, self)

    self.m_GridList = GUIGridList:new(5, 30, 490, 300, self.m_Window)
    self.m_GridList:addColumn("", 0.05)
    self.m_GridList:addColumn("Id", 0.15)
    self.m_GridList:addColumn("Fahrzeug", 0.6)
    self.m_GridList:addColumn("Besitzer", 0.2)

    self.m_Remove.onLeftUp = bind(self.Action_RemoveVehicle, self)
    self.m_Add.onLeftUp    = bind(self.Action_AddVehicle, self)
end
