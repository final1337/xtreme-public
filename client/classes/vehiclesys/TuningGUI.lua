local vehiclePos = Vector3(1393.0378417969, -16.850021362305, 1000.9185791016)

TuningGUI = inherit(Singleton)

addEvent("RP:Client:Tuning:open", true)
addEvent("RP:Client:Tuning:close", true)

TuningGUI.CameraAngles = {
    Vector3(-5, 0, 0), -- Left
    Vector3(0, 5, 0), -- Front
    Vector3(5, 0, 0), -- Right
    Vector3(0, -5, 0), -- Back
    Vector3(0, 0, 8), -- Top
    Vector3(0, -5, 2), -- Backtop
    Vector3(0, 5, 0) -- Allroundsight
}

TuningGUI.CameraAngleEnums = {
    Left = 1,
    Front = 2,
    Right = 3,
    Back = 4,
    Top = 5,
    BackTop = 6,
    Allround = 7,
}

TuningGUI.SlotToAngle = {
    [0]	 = TuningGUI.CameraAngleEnums.Top,    -- Hood
    [1]	 = TuningGUI.CameraAngleEnums.Front,    -- Vent
    [2]	 = TuningGUI.CameraAngleEnums.Back,    -- Spoiler
    [3]	 = TuningGUI.CameraAngleEnums.Right,    -- Sideskirt
    [4]	 = TuningGUI.CameraAngleEnums.Front,    -- Front Bullbar
    [5]	 = TuningGUI.CameraAngleEnums.Back,    -- Rear Bullbar
    [6]	 = TuningGUI.CameraAngleEnums.Front,    -- Headlights
    [7]	 = TuningGUI.CameraAngleEnums.Top,    -- Roof
    [8]	 = TuningGUI.CameraAngleEnums.BackTop,    -- Nitrous
    [9]	 = TuningGUI.CameraAngleEnums.Right,    -- Hydraulics
    [10] = TuningGUI.CameraAngleEnums.Right,	-- Stereo
    [11] = TuningGUI.CameraAngleEnums.Right,	-- Unknown
    [12] = TuningGUI.CameraAngleEnums.Left,	-- Wheels
    [13] = TuningGUI.CameraAngleEnums.Back,	-- Exhaust
    [14] = TuningGUI.CameraAngleEnums.Front,	-- Front Bumper
    [15] = TuningGUI.CameraAngleEnums.Back,	-- Rear Bumper
    [16] = TuningGUI.CameraAngleEnums.Left,	-- Misc.
    [17] = TuningGUI.CameraAngleEnums.Right, -- Color this is not a gta slot
    [18] = TuningGUI.CameraAngleEnums.Top, -- Paintjob this is not a gta slot
    [19] = TuningGUI.CameraAngleEnums.Allround
}


function TuningGUI:constructor()
    self.m_Active = false
    self.m_CurrentGarage = 1
    self.m_CurrentAngle = 1
    self.m_PreviousBought = false
    self.m_CurrentUpgrades = {}

    self.m_BindKey = bind(self.Event_onClientKey, self)
    self.m_BindGridSelect = bind(self.Action_GridSelectCategory, self)
    self.m_BindPartSelect = bind(self.Action_GridSelectPart, self)
    self.m_BindColorChange = bind(self.Event_OnColorChange, self)
    self.m_BindColorSelect = bind(self.Event_OnColorSelect, self)
    self.m_BindDraw = bind(self.draw, self)
    
    addEventHandler("RP:Client:Tuning:open", root, bind(self.Event_Open, self))
    addEventHandler("RP:Client:Tuning:close", root, bind(self.Event_Close, self))
end

function TuningGUI:Event_Open(vehicle, garageID)
    if self.m_Active then
        self:close()
    end
    self:open(vehicle, garageID)
end

function TuningGUI:open(vehicle, garageID)
    localPlayer:setData("Clicked", true)
    self.m_Active = true
    showCursor(true)
    self.m_CurrentGarage = garageID
    self.m_Vehicle = vehicle
    -- self.m_Vehicle:setInterior(1)
    addEventHandler("onClientKey", root, self.m_BindKey)
    addEventHandler("onColorPickerChange", root, self.m_BindColorChange)
    addEventHandler("onColorPickerOK", root, self.m_BindColorSelect)
    addEventHandler("onClientRender", root, self.m_BindDraw)
    self.m_CurrentUpgrades = self.m_Vehicle:getUpgrades()
    self.m_CurrentColor = {self.m_Vehicle:getColor(true)}
    self.m_CurrentPaintJob = self.m_Vehicle:getPaintjob()

    self.m_Window = GUIWindow:new(10*(screenWidth/1920), 262*(screenHeight/1080), 555*(screenWidth/1920), 417*(screenHeight/1080), "Tuninggarage", true)

    self.m_Window:setColor(50, 50, 50, 200)

    self.m_CategoryGrid = GUIGridList:new(10*(screenWidth/1920), 28*(screenHeight/1080), 178*(screenWidth/1920), 338*(screenHeight/1080), self.m_Window)
    self.m_CategoryGrid:addColumn("Kategorie", 0.9)
    self.m_PartGrid = GUIGridList:new(198*(screenWidth/1920), 28*(screenHeight/1080), 347*(screenWidth/1920), 338*(screenHeight/1080), self.m_Window)
    self.m_PartGrid:addColumn("ID", 0.3)
    self.m_PartGrid:addColumn("Tuningteil", 0.4)
    self.m_PartGrid:addColumn("Preis", 0.3)
    self.m_Add = GUIClassicButton:new("Tuningteil anbauen", 10*(screenWidth/1920), 376*(screenHeight/1080), 178*(screenWidth/1920), 31*(screenHeight/1080), self.m_Window)
    self.m_Remove = GUIClassicButton:new("Tuningteil abbauen", 198*(screenWidth/1920), 376*(screenHeight/1080), 347*(screenWidth/1920), 31*(screenHeight/1080), self.m_Window)



    for i = 1, 19, 1 do
        if #getVehicleCompatibleUpgrades(self.m_Vehicle, i-1) > 0 and i ~= 18 then
            local row = self.m_CategoryGrid:addRow()
            row.Slot = i-1
            if i ~= 18 then
                row:setValue("Kategorie", getVehicleUpgradeSlotName(i-1))
            end
        elseif i >= 18 then
            local row = self.m_CategoryGrid:addRow()
            row.Slot = i-1
            row.Color  = true
            if row.Slot == 17 then
                row:setValue("Kategorie", "Color")
            else
                row:setValue("Kategorie", "Paintjob")
            end
        end
    end

    self.m_Window:getCloseButton().onLeftUp = bind(self.close, self)

    self.m_CategoryGrid.onGridSelect = self.m_BindGridSelect
    self.m_PartGrid.onGridSelect = self.m_BindPartSelect

    self.m_Add.onLeftUp = bind(self.Action_Add, self)
    self.m_Remove.onLeftUp = bind(self.Action_Remove, self)
    

    self.m_CategoryGrid.m_ScrollArea:changeScrollSpeedOnYAxis(10)
    self.m_PartGrid.m_ScrollArea:changeScrollSpeedOnYAxis(10)

    self.m_Window:setVisible(true)

    Timer(bind(self.changeToCurrentAngle, self), 500, 1)
end

function TuningGUI:Event_Close()
    self:close()
end

function TuningGUI:close()
    localPlayer:setData("Clicked", false)
    self:resetVehicle()
    removeEventHandler("onClientKey", root, self.m_BindKey)
    self.m_Active = false
    delete(self.m_Window)
    removeEventHandler("onClientKey", root, self.m_BindKey)
    removeEventHandler("onColorPickerChange", root, self.m_BindColorChange)
    removeEventHandler("onColorPickerOK", root, self.m_BindColorSelect) 
    removeEventHandler("onClientRender", root, self.m_BindDraw)  
    
    triggerServerEvent("RP:Server:Tuning:back", resourceRoot, self.m_CurrentGarage)
end

function TuningGUI:Action_Add()
    local categoryRow = self.m_CategoryGrid:getActiveRow()
    if categoryRow then
        local partRow = self.m_PartGrid:getActiveRow()
        if partRow then
            local partId = partRow:getColumnValue("ID")
            local slot = categoryRow.Slot
            if slot <= 16 then
                if localPlayer:getData("Bankgeld") >= TuningPrices[partId] then
                    triggerServerEvent("RP:Server:Tuning:add", resourceRoot, partId)
                    localPlayer:sendNotification("Upgrade hinzugefügt.")
                    self.m_CurrentUpgrades = self.m_Vehicle:getUpgrades()
                else
                    localPlayer:sendNotification("Du hast nicht genug Geld!", 120, 0, 0)
                end
            elseif slot == 18 then -- Add Paintjob
                if localPlayer:getData("Bankgeld") >= 15000 then
                    local partId = partRow:getColumnValue("ID")
                    self.m_CurrentPaintJob = partId
                    localPlayer:sendNotification("Paintjob hinzugefügt.")
                    triggerServerEvent("RP:Server:Tuning:add", resourceRoot, "paintjob", partId)
                else
                    localPlayer:sendNotification("Du hast nicht genug Geld!", 120, 0, 0)
                end
            end
        end
    end
end

function TuningGUI:draw()

end

function TuningGUI:Action_Remove()
    local categoryRow = self.m_CategoryGrid:getActiveRow()
    if categoryRow then
        -- Cunt
        if self.m_Vehicle:getUpgradeOnSlot(categoryRow.Slot) then
            if self:vehicleGotUpgrade(self.m_Vehicle:getUpgradeOnSlot(categoryRow.Slot)) then
                -- self.m_Vehicle:removeUpgrade(self.m_Vehicle:getUpgradeOnSlot(categoryRow.Slot))
                triggerServerEvent("RP:Server:Tuning:remove", resourceRoot, self.m_Vehicle:getUpgradeOnSlot(categoryRow.Slot))
                localPlayer:sendNotification("Upgrade entfernt.")
                self.m_CurrentUpgrades = self.m_Vehicle:getUpgrades()                
            end
        end
    end
end

function TuningGUI:vehicleGotUpgrade(id)
    for key, value in ipairs(self.m_CurrentUpgrades) do
        if id == value then
            return true
        end
    end
    return false
end

function TuningGUI:Action_GridSelectCategory()
    local row = self.m_CategoryGrid:getActiveRow()
    local slot = row.Slot

    if row then

        self.m_CurrentAngle = TuningGUI.SlotToAngle[row.Slot]
        self:listAvailableUpgrades()
        self:changeToCurrentAngle()

    end
end

function TuningGUI:Event_OnColorSelect(id, hex, r, g, b)
    if id ~= 1 then return end
    closePicker(1)
    if localPlayer:getData("Bankgeld") >= 500 then
        triggerServerEvent("RP:Server:Tuning:add", resourceRoot, r, g, b, self.m_SelectedColor)
        localPlayer:sendNotification("Farbe gesetzt.", 255, 255, 0)
        self.m_CurrentColor = {self.m_Vehicle:getColor(true)}
        showCursor(true)
    else
        localPlayer:sendNotification("Du hast nicht genug Geld.", 120, 0, 0)
    end
end

function TuningGUI:Event_OnColorChange(id, hex, r, g, b)
    if id ~= 1 then return end
    local c = table.copy(self.m_CurrentColor)
    local cur = self.m_SelectedColor
    c[1+(cur-1)*3] = r
    c[2+(cur-1)*3] = g
    c[3+(cur-1)*3] = b
    self.m_Vehicle:setColor(unpack(c))
end

function TuningGUI:Action_GridSelectPart()
    local category = self.m_CategoryGrid:getActiveRow()
    local row = self.m_PartGrid:getActiveRow()

    self:resetVehicle()
    if not row then return end

    if not category.Color then
        closePicker(1)
        showCursor(true)
        local id = row:getColumnValue("ID")
        local part = row:getColumnValue("Tuningteil")
        local price = row:getColumnValue("Preis")

        self.m_Vehicle:addUpgrade(id)
    elseif category.Slot == 17 then
        self.m_SelectedColor = row:getColumnValue("ID")
        local cc = {self.m_Vehicle:getColor(true)} -- currentcolor
        openPicker(1, rgb2hex(cc[1+(self.m_SelectedColor-1)*3], cc[2+(self.m_SelectedColor-1)*3], cc[3+(self.m_SelectedColor-1)*3]), "Tuningcolor")
    elseif category.Slot == 18 then
        local id = row:getColumnValue("ID")
        self.m_Vehicle:setPaintjob(id)
    end
end

function TuningGUI:resetVehicle()
    for key, value in ipairs(self.m_Vehicle:getUpgrades()) do
        if value then
            self.m_Vehicle:removeUpgrade(value)
        end
    end
    for key, value in ipairs(self.m_CurrentUpgrades) do
        if value then
            self.m_Vehicle:addUpgrade(value)
        end
    end
    local cc = self.m_CurrentColor
    self.m_Vehicle:setColor(cc[1], cc[2], cc[3], cc[4], cc[5], cc[6], cc[7], cc[8], cc[9], cc[10], cc[11], cc[12])
    self.m_Vehicle:setPaintjob(self.m_CurrentPaintJob)
end

function TuningGUI:listAvailableUpgrades()
    local row = self.m_CategoryGrid:getActiveRow()
    self.m_Window:setVisible(false)
    self.m_PartGrid:flush()
    if not row.Color then
        for key, value in ipairs(getVehicleCompatibleUpgrades(self.m_Vehicle, row.Slot)) do
            local row = self.m_PartGrid:addRow()
            row:setValue("ID", value)
            row:setValue("Tuningteil", TuningNames[value])
            row:setValue("Preis", TuningPrices[value])
            if self:vehicleGotUpgrade(value) then
                self.m_PartGrid:setActiveRow(row)
            end
        end
    else
        if row.Slot == 17 then -- Color
            for i = 1, 4, 1 do
                local row = self.m_PartGrid:addRow()
                row:setValue("ID", i)
                row:setValue("Tuningteil", "Color "..i)
                row:setValue("Preis", 500)            
            end
        else -- Paintjob
            for i = 0, 3, 1 do
                local row = self.m_PartGrid:addRow()
                row:setValue("ID", i)
                row:setValue("Tuningteil", "Paintjob "..i)
                row:setValue("Preis", 15000)            
            end            
        end
    end
    self.m_Window:setVisible(true)
end

function TuningGUI:Event_onClientKey(key, state)
    if ( key == "a" or key == "arrow_l" or key == "d" or key == "arrow_r") and state then
        if key == "arrow_r" or key =="d" then  
            self.m_CurrentAngle = math.min(#TuningGUI.CameraAngles, self.m_CurrentAngle+1)
        else
            self.m_CurrentAngle = math.max(1, self.m_CurrentAngle-1)
        end

        self:changeToCurrentAngle()
        --setCameraMatrix(vehiclePos+Camera.CameraAngles[Camera.CurrentAngle], vehiclePos)
    end
        
end

function TuningGUI:changeToCurrentAngle()

    local diff = vehiclePos+TuningGUI.CameraAngles[self.m_CurrentAngle]


    local x,y,z = diff.x, diff.y, diff.z
    local cx,cy,cz = vehiclePos.x, vehiclePos.y,vehiclePos.z

    local x1, y1, z1, x2, y2, z2 = getCameraMatrix()

    smoothMoveCamera(x1, y1, z1, x2, y2, z2, x,y,z, cx,cy,cz, 500)
end