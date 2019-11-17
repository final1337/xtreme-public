VehicleGUI = inherit(Singleton)

addEvent("RP:Client:VehicleGUI:open", true)
addEvent("RP:Client:VehicleGUI:close", true)

function VehicleGUI:constructor()
    self.m_Active = false
    self.m_Vehicle = false

    addEventHandler("RP:Client:VehicleGUI:open", root, bind(self.open, self))
    addEventHandler("RP:Client:VehicleGUI:close", root, bind(self.close, self))
    addEventHandler("onClientElementStreamIn", resourceRoot, bind(self.Event_ElementStreamIn, self))
    addEventHandler("onClientElementDataChange", resourceRoot, bind(self.Event_ElementDataChange, self))
end

function VehicleGUI:Event_ElementDataChange(key, oldValue, newValue)
    if getElementType(source) == "vehicle" then
        if key == "Untouchable" then
            if newValue then
                source:setAlpha(155)
                for key, value in ipairs(getElementsByType("vehicle", root, true)) do
                    if value ~= source then
                        source:setCollidableWith(value, false)
                    end
                end
                for key, value in ipairs(getElementsByType("player", root, true)) do
                    if value ~= source then
                        source:setCollidableWith(value, false)
                    end
                end
            else
                source:setAlpha(255)
                for key, value in ipairs(getElementsByType("vehicle", root, true)) do
                    if value ~= source then
                        source:setCollidableWith(value, true)
                    end
                end     
                for key, value in ipairs(getElementsByType("player", root, true)) do
                    if value ~= source then
                        source:setCollidableWith(value, true)
                    end
                end                              
            end
        end
    end
end

function VehicleGUI:Event_ElementStreamIn()
    if getElementType(source,"vehicle") then
        local touchable = getElementData(source,"Untouchable")
        if touchable then
            source:setAlpha(155)
            for key, value in ipairs(getElementsByType("vehicle", root, true)) do
                if value ~= source then
                    source:setCollidableWith(value, false)
                end
            end    
            for key, value in ipairs(getElementsByType("player", root, true)) do
                if value ~= source then
                    source:setCollidableWith(value, false)
                end
            end     
        end
    end
end 

function VehicleGUI:close()
    if self.m_Active then
        delete(self.m_Window)
        if localPlayer:getData("Adminlevel") > 0 then
            delete(self.m_AdminMenu)
        end
    end
    self.m_Vehicle = false
    self.m_Active = false
    showCursor(false)

    localPlayer:setData("Clicked", false)
end

function VehicleGUI:Action_Lock()
    triggerServerEvent("RP:Server:Vehicle:interaction", resourceRoot, self.m_Vehicle, "lock")
    self:close()
end

function VehicleGUI:Action_Break()
    triggerServerEvent("RP:Server:Vehicle:interaction", resourceRoot, self.m_Vehicle, "break")
    self:close()
end

function VehicleGUI:Action_Respawn()
    triggerServerEvent("RP:Server:Vehicle:interaction", resourceRoot, self.m_Vehicle, "respawn")
    self:close()
end

function VehicleGUI:Action_Park()
    triggerServerEvent("RP:Server:Vehicle:interaction", resourceRoot, self.m_Vehicle, "park")
    self:close()
end

function VehicleGUI:Action_Delete()
    triggerServerEvent("RP:Server:Vehicle:interaction", resourceRoot, self.m_Vehicle, "delete")
    self:close()
end

function VehicleGUI:Action_Garage()
    triggerServerEvent("RP:Server:Vehicle:interaction", resourceRoot, self.m_Vehicle, "garage")
    self:close()
end


function VehicleGUI:open(vehicle)
    self:close()

    self.m_Active = true
    self.m_Vehicle = vehicle
    localPlayer:setData("Clicked", true)
    showCursor(true)

    self.m_Window = GUIWindow:new(screenWidth/2 - 300/2, screenHeight/2 - 150/2, 300, 150, "Fahrzeugmenü", true)

    self.m_Window:getCloseButton().onLeftUp = bind(self.close, self)

    self.m_Window:setColor(50, 50, 50, 200)

    self.m_Lock      = GUIClassicButton:new("Aufschließen", 5, GUIWindow.TitleThickness + 15, 135, 40, self.m_Window)
    self.m_Break     = GUIClassicButton:new("Handbremse anziehen", 160, GUIWindow.TitleThickness + 15, 135, 40, self.m_Window)
    self.m_Respawn   = GUIClassicButton:new("Respawnen", 5, GUIWindow.TitleThickness + 60, 135, 40, self.m_Window)
    self.m_Park      = GUIClassicButton:new("Parken", 160, GUIWindow.TitleThickness + 60, 135, 40, self.m_Window)    

    self.m_Lock.onLeftUp = bind(self.Action_Lock, self)
    self.m_Break.onLeftUp = bind(self.Action_Break, self)
    self.m_Respawn.onLeftUp = bind(self.Action_Respawn, self)
    self.m_Park.onLeftUp = bind(self.Action_Park, self)

    if not vehicle:getData("Locked") then
        self.m_Lock:setText("Abschließen")
    end

    if vehicle:getData("Break") then
        self.m_Break:setText("Handbremse lösen")
    end

    if localPlayer:getData("Adminlevel") > 1 then

        GUIRectangle:new(0, 140, 300, 10, self.m_Window):setColor(unpack(XTREAM_ORANGE))

        self.m_AdminMenu = GUIRectangle:new(screenWidth/2 - 300/2, screenHeight/2 + 75, 300, 50)
        self.m_AdminMenu:setColor(50, 50, 50, 200)

        self.m_Delete = GUIClassicButton:new("Löschen", 5, 5, 135, 40, self.m_AdminMenu)
        self.m_Garage = GUIClassicButton:new("Tiefgarage", 160, 5, 135, 40, self.m_AdminMenu)

        self.m_Delete.onLeftUp = bind(self.Action_Delete, self)
        self.m_Garage.onLeftUp = bind(self.Action_Garage, self)

        self.m_AdminMenu:setVisible(true)
    end

    
    self.m_Window:setVisible(true)

end