ItemScripts = {}

ItemScripts[1] = {}

ItemScripts[1].Func = function (player, obj)
    obj.Creator = player:getName()
    obj.TimeStamp = getRealTime()

    setElementData(obj, "isUnbreakable", true)

    addEventHandler("onElementClicked", obj, ItemScripts[1].Event_OnElementClicked)
end

ItemScripts[1].Event_OnElementClicked = function (mouseButton, buttonState, player)
    if buttonState == "up" then
        if mouseButton == "left" then
            if isCop(player) or isFBI(player) or isArmy(player) or getElementData(player,"Adminlevel") >= 1 then
                destroyElement(source)
            end
        elseif mouseButton == "right" then
            local string = ("Erstellt von #FF0000%s#FFFFFF am #FF0000 %.2d/%.2d/%.4d #FFFFFF um #FF0000%.2d:%.2d:%.2d#FFFFFF."):format(source.Creator, 
                            source.TimeStamp.monthday, source.TimeStamp.month + 1, source.TimeStamp.year + 1900,
                            source.TimeStamp.hour, source.TimeStamp.minute, source.TimeStamp.second)
            player:sendMessage(string)
        end
    end
end

ItemScripts[2] = {}

ItemScripts[2].Cooldown = {}

ItemScripts[2].Func = function (player, obj)
    player:sendNotification("Energy getrunken ( + 20 Leben )!", 255, 255, 0)
    setElementHealth(player, getElementHealth(player) + 20)
    healLog:write(player:getName())
    player:setData("EnergyUsed", getRealTime()["timestamp"]+5)
end


ItemScripts[3] = {}

ItemScripts[3].Func = function (player, obj)
    Bombe.place(player)
end


ItemScripts[4] = {}

ItemScripts[4].Func = function (player, obj)
    setElementCollisionsEnabled(obj, false)
    setElementAlpha(obj, 150)
    obj.Creator = player:getName()
    obj.TimeStamp = getRealTime()

    setElementData(obj, "isUnbreakable", true)

    Timer(function (obj)
        if obj and isElement(obj) then
            setElementCollisionsEnabled(obj, true)
            setElementAlpha(obj, 255)
        end
    end, 500, 1, obj)

    addEventHandler("onElementClicked", obj, ItemScripts[4].Event_OnElementClicked)
end

ItemScripts[4].Event_OnElementClicked = function (mouseButton, buttonState, player)
    if buttonState == "up" then
        if mouseButton == "left" and ( player:getData("Fraktion") == 9 or player:getData("Adminlevel") >= 1 or player:getData("Rang") == 5 ) then
            destroyElement(source)
        elseif mouseButton == "right" then
            local string = ("Erstellt von #FF0000%s#FFFFFF am #FF0000 %.2d/%.2d/%.4d #FFFFFF um #FF0000%.2d:%.2d:%.2d#FFFFFF."):format(source.Creator, 
                            source.TimeStamp.monthday, source.TimeStamp.month + 1, source.TimeStamp.year + 1900,
                            source.TimeStamp.hour, source.TimeStamp.minute, source.TimeStamp.second)
            player:sendMessage(string)
        end
    end
end

ItemScripts[5] = {}

ItemScripts[5].Func = function (player, obj)
    local veh = player:getOccupiedVehicle()
    if veh and veh:getData("Fuel") < 100 then
        veh:setData("Fuel", math.min(100, veh:getData("Fuel") + 30))
        player:sendNotification("30l Treibstoff hinzugefügt!", 255, 255, 0)
    end
end

-- ## Plantscript

ItemScripts[6] = {}

ItemScripts[6].Func = function (player, obj, item)
    local veh = player:getOccupiedVehicle()
    if player:getDimension() == 0 and player:getInterior() == 0 then
        local plantId = item:getTemplateItem():getSubClass()
        plantsystem:addPlant(player, plantId)
    end
end

-- ## Spawnvehiclescript

ItemScripts[7] = {}

ItemScripts[7].Func = function (player, obj, item)
    if player:getDimension() == 0 and player:getInterior() == 0 then
        local vehicleModel = item:getTemplateItem():getSubClass()
        local x,y,z = getElementPosition(player)
        local veh = PlayerVehicleClass.new(vehicleModel, x,y,z, 0, 0, getPedRotation(player), player:getName(), player:getId())
        veh:setUntouchable()
    end
end

-- ## Salat, Apfel, etc.

ItemScripts[8] = {}

ItemScripts[8].Cooldown = {}

ItemScripts[8].Func = function (player, obj)
    -- player:sendNotification("Energy getrunken ( + 20 Leben )!", 255, 255, 0)
    -- setElementHealth(player, getElementHealth(player) + 20)
    healLog:write(player:getName())
    if player:getHealth() + 10 <= 100 then
        player:setHealth(player:getHealth() + 10)
    elseif player:getHealth() < 100 then
        player:setHealth(100)
    end
    setPedAnimation( player, "FOOD", "EAT_Burger", -1, true, false, false, true )
    setElementData(player,"waitTime",true)
        setTimer(function()
        setPedAnimation(player)
        setElementData(player,"waitTime",false)
    end, 5000, 1, player)    
end
