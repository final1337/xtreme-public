function showSelf()
    if not getElementData(getLocalPlayer(), "Clicked") then
        if getElementData(getLocalPlayer(), "loggedin") == 1 then
            local x, y = screenx, screeny
            showCursor(true)
            drawWindow("Selfmenu", "window", "Selfmenü", 0, 0, screenx, 200, "SelfSchliessen", true)
            drawRectangle("Selfmenu", "bgButtonInformationen", x / 2 - 230, 60, 40, 40, tocolor(125, 0, 0, 150))
            drawImage("Selfmenu", "Info_image", x / 2 - 228, 62, 36, 36, "Files/Images/Self/info")
            drawButton("Selfmenu", "annehmen", "Informationen", x / 2 - 190, 60, 100, 40, "SelfInformationen")
            drawRectangle("Selfmenu", "bgButtonSpawn", x / 2 - 80, 60, 40, 40, tocolor(125, 0, 0, 150))
            drawImage("Selfmenu", "spawn_image", x / 2 - 78, 62, 36, 36, "Files/Images/Self/spawn")
            drawButton("Selfmenu", "Spawn", "Spawn", x / 2 - 40, 60, 100, 40, "SelfSpawn")
            drawRectangle("Selfmenu", "bgButtonautos", x / 2 + 70, 60, 40, 40, tocolor(125, 0, 0, 150))
            drawImage("Selfmenu", "car_image", x / 2 + 72, 62, 36, 36, "Files/Images/Self/car")
            drawButton("Selfmenu", "Autos", "Fahrzeuge", x / 2 + 110, 60, 100, 40, "SelfAutos")
            drawRectangle("Selfmenu", "bgButtonFührerschein", x / 2 - 230, 110, 40, 40, tocolor(125, 0, 0, 150))
            drawImage("Selfmenu", "lizenzen", x / 2 - 228, 112, 36, 36, "Files/Images/Self/lizenz")
            drawButton("Selfmenu", "Führerscheine", "Führerscheine", x / 2 - 190, 110, 100, 40, "SelfFuehrerscheine")
            drawRectangle("Selfmenu", "bgButtonAdmins", x / 2 - 80, 110, 40, 40, tocolor(125, 0, 0, 150))
            drawImage("Selfmenu", "admins_image", x / 2 - 78, 112, 36, 36, "Files/Images/Self/admins")
            drawButton("Selfmenu", "Admins", "Admins", x / 2 - 40, 110, 100, 40, "SelfAdmins")
            drawRectangle("Selfmenu", "bgButtonClose", x / 2 + 70, 110, 40, 40, tocolor(125, 0, 0, 150))
            drawImage("Selfmenu", "report_image", x / 2 + 72, 112, 36, 36, "Files/Images/Self/Reports")
            drawButton("Selfmenu", "Reports", "Reports", x / 2 + 110, 110, 100, 40, "showTickets")
            if tonumber(getElementData(getLocalPlayer(), "Adminlevel")) >= 2 then
                drawButton("Selfmenu", "Close", "Schließen", x / 2 - 230, 160, 220, 30, "SelfSchliessen")
                drawButton("Selfmenu", "adminmenue", "Admin", x / 2 - 10, 160, 220, 30, "SelfAdminmenue")
            else
                drawButton("Selfmenu", "Close", "Schließen", x / 2 - 230, 160, 440, 30, "SelfSchliessen")
            end
            showChat(false)
            setElementData(getLocalPlayer(), "Clicked", true)
            --addEventHandler("onClientRender", getRootElement(), showStats) -- Funktion noch nicht eingebaut?
        end
    end
end
addEvent("showSelf", true)
addEventHandler("showSelf", getRootElement(), showSelf)
addCommandHandler("self", showSelf)

function selfUnterfensterSchliessen()
    destroyWindow("self_Informationen")
    destroyWindow("self_Autos")
    destroyWindow("self_Schluessel")
    destroyWindow("self_Fuehrerscheine")
    destroyWindow("self_Spawn")
    destroyWindow("self_admins")
end

function SelfSchliessen()
    --removeEventHandler("onClientRender", getRootElement(), showStats) -- Funktion noch nicht eingebaut?
    showChat(true)
    selfUnterfensterSchliessen()
    destroyWindow("Selfmenu")
    showCursor(false)
    setElementData(getLocalPlayer(), "clickedElement", false)
    setTimer(setElementData, 500, 1, getLocalPlayer(), "Clicked", false)
end

function SelfAdmins()
    selfUnterfensterSchliessen()
    local admins = {}
    for all, player in pairs(getElementsByType("player")) do
        if getElementData(player, "loggedin") then
			local rank = getElementData(player, "Adminlevel")
			local vanish = getElementData(player, "vanish") or false
            if rank > 0 and vanish == 0 then
                table.insert(admins, { getPlayerName(player), Adminsystem["Namen"][rank] or "" })
            end
        end
    end
    local x, y = screenx / 2 - 400 / 2, screeny / 2 - 300 / 2
    drawWindow("self_admins", "window", "Online Admins", x, y, 400, 280, "selfUnterfensterSchliessen")
    drawRectangle("self_admins", "bgadmins", x + 10, y + 70, 380, 180, tocolor(0, 0, 0, 150))
    drawGridlist("self_admins", "list", x + 15, y + 75, 370, 160, { { "Name", 190 }, { "Rang", 150 } }, admins)
    --sortGridlist("self_admins", "list", 1)
end

function SelfFuehrerscheine()
    selfUnterfensterSchliessen()
    local scheine = {}
    table.insert(scheine, { "Führerschein", getElementData(getLocalPlayer(), "FuehrerscheinPraxis") == 1 and "[X]" or "[ ]" })
    table.insert(scheine, { "Motorradschein", getElementData(getLocalPlayer(), "MotorradscheinPraxis") == 1 and "[X]" or "[ ]" })
    table.insert(scheine, { "LKW-Schein", getElementData(getLocalPlayer(), "LKWScheinPraxis") == 1 and "[X]" or "[ ]" })
    table.insert(scheine, { "Bootschein", getElementData(getLocalPlayer(), "BootscheinPraxis") == 1 and "[X]" or "[ ]" })
    table.insert(scheine, { "Helikopterschein", getElementData(getLocalPlayer(), "HelikopterscheinPraxis") == 1 and "[X]" or "[ ]" })
    table.insert(scheine, { "Flugschein", getElementData(getLocalPlayer(), "FlugscheinPraxis") == 1 and "[X]" or "[ ]" })
    local x, y = screenx / 2 - 400 / 2, screeny / 2 - 300 / 2
    drawWindow("self_Fuehrerscheine", "window", "Führerscheine", x, y, 400, 320, "selfUnterfensterSchliessen")
    drawRectangle("self_Fuehrerscheine", "bgAutos", x + 10, y + 70, 380, 220, tocolor(0, 0, 0, 150))
    drawGridlist("self_Fuehrerscheine", "list", x + 15, y + 75, 370, 210, { { "Typ", 260 }, { "Vorhanden", 150 } }, scheine)
end

function SelfInformationen()
    selfUnterfensterSchliessen()
    local name = getPlayerName(getLocalPlayer())
    local spielstunden = getElementData(localPlayer,"Spielstunden");
    local hour = math.floor(spielstunden/60);
    local minute = spielstunden-hour*60;
    local wochenzeit = "-" --math.floor(tonumber(getElementData(getLocalPlayer(), "aktivWeek")) / 60) .. ":" .. (tonumber(getElementData(getLocalPlayer(), "aktivWeek")) - math.floor(tonumber(getElementData(getLocalPlayer(), "aktivWeek")) / 60) * 60)
    local frak = getElementData(getLocalPlayer(), "Fraktion")
    local fraktion = Fraktionen["Namen"][frak] or "Fraktion nicht gefunden"
    local rank = getElementData(getLocalPlayer(), "Rang")
    local job = getElementData(getLocalPlayer(), "Job")
    local morde = getElementData(getLocalPlayer(), "Kills")
    local tode = getElementData(getLocalPlayer(), "Tode")
    local bargeld = getElementData(getLocalPlayer(), "Geld") .. "€"
    local bankgeld = getElementData(getLocalPlayer(), "Bankgeld") .. "€"
    local pangwd = "PAN: " .. getElementData(getLocalPlayer(), "PAN") .. "% / GWD: " .. getElementData(getLocalPlayer(), "GWD") .. "%"
    local graffitis = getElementData(getLocalPlayer(), "Graffitis") .. "/30"
    local gloops = getElementData(getLocalPlayer(), "Gloops") .. "/30"
    local stvo = getElementData(getLocalPlayer(), "STVO")
    local ziviZeit = 0 -- getElementData(getLocalPlayer(), "Zivizeit") + 432000 - getRealTime().timestamp
    --    if getElementData(getLocalPlayer(), "PremiumR") then
    --        ziviZeit = getElementData(getLocalPlayer(), "lastUninvite") + 432000 * 0.3 - getRealTime().timestamp
    --    elseif getElementData(getLocalPlayer(), "PremiumG") then
    --        ziviZeit = getElementData(getLocalPlayer(), "lastUninvite") + 432000 * 0.6 - getRealTime().timestamp
    --    elseif getElementData(getLocalPlayer(), "PremiumS") then
    --        ziviZeit = getElementData(getLocalPlayer(), "lastUninvite") + 432000 * 0.8 - getRealTime().timestamp
    --    end
    --    ziviZeit = math.ceil(ziviZeit / 60 / 60)
    --    if ziviZeit < 0 then
    --        ziviZeit = 0
    --    end
    local x, y = screenx / 2 - 300 / 2, screeny / 2 - 400 / 2
    drawWindow("self_Informationen", "window", "Informationen", x, y, 300, 400, "selfUnterfensterSchliessen")
    drawRectangle("self_Informationen", "bgInformationen", x + 10, y + 70, 280, 320, tocolor(0, 0, 0, 150))
    drawText("self_Informationen", "Name", "Name: " .. name, x + 30, y + 80, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Spielzeit", "Spielzeit: " .. ("%.2d, %.2d"):format(hour, minute), x + 30, y + 100, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "WochenZeit", "Wochenzeit: " .. wochenzeit, x + 30, y + 120, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Fraktion", "Fraktion: " .. fraktion, x + 30, y + 140, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Rang", "Rang: " .. rank, x + 30, y + 160, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Job", "Job: " .. job, x + 30, y + 180, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Morde", "Morde: " .. morde, x + 30, y + 200, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Tode", "Tode: " .. tode, x + 30, y + 220, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Bargeld", "Bargeld: " .. bargeld, x + 30, y + 240, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Bankgeld", "Bankgeld: " .. bankgeld, x + 30, y + 260, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "PAN", "PAN/GWD: " .. pangwd, x + 30, y + 280, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Graffitis", "Graffits: " .. graffitis, x + 30, y + 300, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Gloops", "Gloops: " .. gloops, x + 30, y + 320, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "STVO", "STVO: " .. stvo, x + 30, y + 340, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawText("self_Informationen", "Zivizeit", "Zivizeit: " .. ziviZeit .. "h", x + 30, y + 360, 200, 30, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
end

function SelfSpawn()
    selfUnterfensterSchliessen()
    local spawns = {}
    table.insert(spawns, { "Straße" })
    table.insert(spawns, { "Haus" })
    if getElementData(getLocalPlayer(), "Fraktion") >= 1 then
        table.insert(spawns, { "Fraktion" })
    end
    if getElementData(getLocalPlayer(), "Adminlevel") >= 3 then
        table.insert(spawns, { "Hier" })
    end
    local x, y = screenx / 2 - 400 / 2, screeny / 2 - 300 / 2
    drawWindow("self_Spawn", "window", "Spawn", x, y, 400, 300, "selfUnterfensterSchliessen")
    drawRectangle("self_Spawn", "bgSpawn", x + 10, y + 70, 380, 180, tocolor(0, 0, 0, 150))
    drawGridlist("self_Spawn", "list", x + 15, y + 75, 370, 160, { { "Ort", 360 } }, spawns)
    drawButton("self_Spawn", "wechseln", "Spawn wechseln", x + 150, y + 260, 100, 30, "spawnChange")
end


function spawnChange()
    local selected = getGridlistSelectedItem("self_Spawn", "list")
    if selected then
        selected = selected[1]
        if selected == "Straße" then
            triggerServerEvent("setPlayerSpawn", getRootElement(), getLocalPlayer(), "Straße")
			infobox("Du hast dein Spawnpunkt geändert!", 255, 120, 0)
        elseif selected == "Fraktion" then
            triggerServerEvent("setPlayerSpawn", getRootElement(), getLocalPlayer(), "Fraktion")
			infobox("Du hast dein Spawnpunkt geändert!", 255, 120, 0)
        elseif selected == "Haus" then
            if tonumber(getElementData(getLocalPlayer(), "Hausschluessel")) > 0 or tonumber(getElementData(getLocalPlayer(), "Hausschluessel")) < 0 then
                triggerServerEvent("setPlayerSpawn", getRootElement(), getLocalPlayer(), "Haus")
				infobox("Du hast dein Spawnpunkt geändert!", 255, 120, 0)
            end
        elseif selected == "Hier" then
            triggerServerEvent("setPlayerSpawn", getRootElement(), getLocalPlayer(), "Hier")
			infobox("Du hast dein Spawnpunkt geändert!", 255, 120, 0)
        end
    end
end

function SelfAutos()
    selfUnterfensterSchliessen()
    local anzahlautos = 0
    local autos = {}
    local name = getPlayerName(getLocalPlayer())
    for k, veh in ipairs(getElementsByType("vehicle")) do
        local owner = getElementData(veh, "Owner")
        local playerId = getElementData(localPlayer,"Id")
        if owner and owner == playerId then
            local slot = getElementData(veh,"Slot")
            local name = getVehicleName(veh)
            local expo = getElementData(veh, "Carpark") ~= 0 and "Garage" or "Draußen"
            local handbremse = getElementData(veh, "Break")
            if handbremse then
                handbremse = "an"
            else
                handbremse = "aus"
            end
            anzahlautos = anzahlautos + 1
            table.insert(autos, { slot, name, expo, handbremse })
        end
    end
    local x, y = screenx / 2 - 400 / 2, screeny / 2 - 370 / 2
    drawWindow("self_Autos", "window", "Fahrzeuge", x, y, 400, 370, "selfUnterfensterSchliessen")
    drawText("self_Autos", "text_anzahl:", "Anzahl Fahrzeuge: " .. anzahlautos .. "/10", x + 15, y + 55, 380, 40, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
    drawRectangle("self_Autos", "bgAutos", x + 10, y + 70, 380, 180, tocolor(0, 0, 0, 150))
    drawGridlist("self_Autos", "list", x + 15, y + 75, 370, 160, { { "Slot", 100 }, { "Typ", 100 }, { "Ort", 60 }, { "Handbremse", 120 } }, autos)
    drawButton("self_Autos", "orten", "Orten", x + 10, y + 260, 180, 30, "showVehicleBlip")
    drawButton("self_Autos", "handbremse", "Handbremse an/aus", x + 200, y + 260, 180, 30, "handbrakeoptions")
    drawButton("self_Autos", "respawn", "Respawnen", x + 10, y + 300, 180, 30, "respawnPlVehicle")
    drawButton("self_Autos", "verkaufen", "Verkaufen", x + 200, y + 300, 180, 30, "sellVehicle")
end

function showVehicleBlip()
    local slot = getGridlistSelectedItem("self_Autos", "list")[1]
    if slot then
        triggerServerEvent("showVehicleBlip", getRootElement(), getLocalPlayer(), tonumber(slot))
    end
end

function sellVehicle()
    local slot = getGridlistSelectedItem("self_Autos", "list")[1]
    if slot then
        triggerServerEvent("sellVehicle", getRootElement(), tonumber(slot), getLocalPlayer())
        setTimer(SelfAutos, 200, 1)
    end
end

function handbrakeoptions()
    local slot = getGridlistSelectedItem("self_Autos", "list")[1]
    if slot then
        triggerServerEvent("breakCar", getRootElement(), tonumber(slot), getLocalPlayer())
        setTimer(SelfAutos, 200, 1)
    end
end

function respawnPlVehicle()
    local slot = getGridlistSelectedItem("self_Autos", "list")[1]
    if slot then
        triggerServerEvent("respawnVehicle", getRootElement(), getLocalPlayer(), tonumber(slot))
        setTimer(SelfAutos, 200, 1)
    end
end



