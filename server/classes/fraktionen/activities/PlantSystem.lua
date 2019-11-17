--
-- Created by dev0
--

PlantSystem = inherit(Singleton)

PlantSystem.BallasFinishTime = 54*100
PlantSystem.NormalFinishTime = 120*100
PlantSystem.OtherFinishTime = 240*100

function PlantSystem:constructor()
    self._tblAllPlants = {}
    self._tblPlantTimer = {}
    self._iPlantingTimer = 10 -- Time in sec
    self._iBallasID = 10 -- BallasID anpassen

    setTimer(function() self:createPlants() end, 1000, 1)

    addEventHandler("onPlayerClick", root, bind(self.onPlantClick, self))

    -- addCommandHandler("ph", bind(self.addPlant, self))
end

function PlantSystem:createPlants() -- Client übergabe bei Inventar nutzung für Ballas Abfrage in Zeile: 71
    local SQL = db:query("SELECT * FROM plants")
    if (SQL) then
        local tblResult, iRows = db:poll(SQL, -1)
        if (iRows >= 1) then
            for _, value in ipairs(tblResult) do
                self._plantID = tonumber(value["id"])
                self._plantOwner = tostring(value["owner"])
                self._plantFinish = tonumber(value["finished"])
                self._plantModelID = tonumber(value["type"])
                self._plantStarted = tonumber(value["planted"])

                if (not (isElement(self._tblAllPlants[self._plantID]))) then
                    self._tblAllPlants[self._plantID] = createObject(tonumber(value["type"]), tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]) - 9)

                    self._tblAllPlants[self._plantID]:setData("id", self._plantID)
                    self._tblAllPlants[self._plantID]:setData("owner", self._plantOwner)
                    self._tblAllPlants[self._plantID]:setData("finished", self._plantFinish)
                    self._tblAllPlants[self._plantID]:setData("isPlant", true)
                    self._tblAllPlants[self._plantID]:setData("planted", self._plantStarted)
                   
                    if (self._plantModelID == 3409) then 
                        moveObject(self._tblAllPlants[self._plantID], self._iPlantingTimer * 1000, tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]) - 1)
                        self._PlantPlaceHolder = createObject(2991, 0, 0, 0, 0, 0, 0)
                        self._PlantPlaceHolder1 = createObject(2991, 0, 0, 0, 0, 0, 0)
                        triggerClientEvent(root, "setObjectsUnbreakable", root, {self._PlantPlaceHolder, self._PlantPlaceHolder1})

                        self._PlantPlaceHolderPosition = Vector3(-2588.5119628906 - (-2589.3125), 330.2961730957 - (330.35571289063), -0.2)
                        self._PlantPlaceHolderPosition1 = Vector3(-2588.5119628906 - (-2587.8278808594), 330.2961730957 - (330.31005859375), -0.2)

                        self._PlantPlaceHolder:attach(self._tblAllPlants[self._plantID], self._PlantPlaceHolderPosition.x, self._PlantPlaceHolderPosition.y, self._PlantPlaceHolderPosition.z, 0, 0, 270)
                        self._PlantPlaceHolder1:attach(self._tblAllPlants[self._plantID], self._PlantPlaceHolderPosition1.x, self._PlantPlaceHolderPosition1.y, self._PlantPlaceHolderPosition1.z, 0, 0, 270)

                        self._PlantPlaceHolder:setParent(self._tblAllPlants[self._plantID])
                        self._PlantPlaceHolder1:setParent(self._tblAllPlants[self._plantID])

                        self._PlantPlaceHolder:setAlpha(0)
                        self._PlantPlaceHolder1:setAlpha(0)

                        self._PlantPlaceHolder:setData("weedObject", self._tblAllPlants[self._plantID])
                        self._PlantPlaceHolder1:setData("weedObject", self._tblAllPlants[self._plantID])
                    else
                        moveObject(self._tblAllPlants[self._plantID], self._iPlantingTimer * 1000, tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]) - 0.7)
                        self._tblAllPlants[self._plantID]:setData("weedObject", self._tblAllPlants[self._plantID])
                    end
                end
            end
        end
    end
end

function PlantSystem:deletePlant(uPlayer, uPlant)
    if (isElement(uPlant)) then
        for key, value in ipairs(self._tblAllPlants) do
            if value == uPlant then
                table.remove(self._tblAllPlants, key)
                break
            end
        end
        local now = getRealTime()["timestamp"]
        local finished = now >= uPlant:getData("finished")
        if (finished or getElementData(uPlayer, "Adminlevel") > 1) then
            -- uPlayer:setData("WEED", uPlayer:getData("WEED") + math.random(1, 5))
            if uPlant:getData("finished") - uPlant:getData("planted") == PlantSystem.BallasFinishTime and uPlant:getModel() == 3409 then
                local item = itemmanager:addItem(62, 10, factionboxmanager:getFactionBoxes(self._iBallasID)[1].Storage[5])
                item:merge()
            end
            if finished then
                if uPlant:getModel() == 3409 then
                    local item = uPlayer:addItem(62, math.random(1,5))
                    item:merge()
                elseif uPlant:getModel() == 681 then
                    local item = uPlayer:addItem(88, math.random(2,4))
                    item:merge()                   
                elseif uPlant:getModel() == 792 then
                    local item = uPlayer:addItem(90, math.random(2,4))
                    item:merge()                           
                end
            end
            db:exec("DELETE FROM plants WHERE id = '" .. uPlant:getData("id") .. "'")
            uPlayer:outputChat("Du hast die Pflanze abgeerntet!", 0, 120, 0)
            if isElement(uPlant) then uPlant:destroy() end
        else
            uPlayer:outputChat("Du kannst diese Pflanze noch nicht ernten!", 120, 0, 0)
        end
    end
end

function PlantSystem:getFinishedTimeStamp(player, plantId)
    if plantId == 3409 then
        return getRealTime()["timestamp"] + (player:getData("Fraktion") == 10 and PlantSystem.BallasFinishTime or PlantSystem.NormalFinishTime)
    end
    return getRealTime()["timestamp"] + PlantSystem.OtherFinishTime
end

function PlantSystem:addPlant(uPlayer, plantID)
    --> Vlt ne Abfrage, ob er schon eine bestimme Anzahl an Pflanzen gepflanzt hat & ob genug Hanfsamen am start sind
    if (not (uPlayer:getData("isPlanting"))) then
        local plantID = plantID
        local ownerName
        local pos = uPlayer:getPosition()
        setPedAnimation(uPlayer, "BOMBER", "BOM_Plant_Crouch_In", -1, false, false, false, true)
        uPlayer:setData("isPlanting", true)

        setTimer(function(uPlayer)
            setPedAnimation(uPlayer)
            if (uPlayer:getData("isPlanting")) then uPlayer:setData("isPlanting", false) end
        end, self._iPlantingTimer * 1000, 1, uPlayer)
        ownerName = uPlayer:getId()

        db:exec("INSERT INTO plants (owner, type, finished, posX, posY, posZ, planted) VALUES (?, ?, ?, ?, ?, ?, ?)",
                ownerName, plantID, self:getFinishedTimeStamp(uPlayer, plantID), pos.x, pos.y, pos.z, getRealTime()["timestamp"])
        self:createPlants()
    end
end

function PlantSystem:onPlantClick(strButton, strState, uElement)
    if (strButton == "left" and strState == "up") then
        if (uElement) then
            local playerPosition = Vector3(getElementPosition(source))
            if (getDistanceBetweenPoints3D(playerPosition.x, playerPosition.y, playerPosition.z, getElementPosition(uElement)) <= 5) then
                if (uElement:getData("weedObject")) then
                    local clickedPlant = uElement:getData("weedObject")
                    local finishedTimeFrame = uElement:getData("finished")-uElement:getData("planted")
                    local now = finishedTimeFrame - (uElement:getData("finished") - getRealTime()["timestamp"])

                    local progress = math.min(1, now/finishedTimeFrame)
                    local username = getPlayerData("userdata","ID",clickedPlant:getData("owner"),"Username")
                    local name = ""
                    if clickedPlant:getData("finished") - clickedPlant:getData("planted") == PlantSystem.BallasFinishTime then
                        name = "- Ballas"
                    end                    
                    source:sendMessage("Ersteller: %s - Fortschritt: %d/100 %s", 0, 175, 0, username, math.floor(progress*100), name)
                    --source:outputChat(string.format("PflanzenID: %s, Pflanzenowner: %s, Pflanzenzeit: %s", clickedPlant:getData("id"), clickedPlant:getData("owner"), clickedPlant:getData("time")), 255, 255, 0)
                end
            end
        end
    elseif (strButton == "right" and strState == "up") then
        if (uElement) then
            local playerPosition = Vector3(getElementPosition(source))
            if (getDistanceBetweenPoints3D(playerPosition.x, playerPosition.y, playerPosition.z, getElementPosition(uElement)) <= 5) then
                if (uElement:getData("weedObject")) then
                    local clickedPlant = uElement:getData("weedObject")
                    self:deletePlant(source, clickedPlant)
                end
            end
        end
    end
end