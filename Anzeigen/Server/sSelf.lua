
--// showLicense

addCommandHandler("showlicense", function(player, cmd, target)
    local target = getPlayerFromName(target)
    local tx, ty, tz = getElementPosition(target)
    local px, py, pz = getElementPosition(player)
    if getDistanceBetweenPoints3D(tx, ty, tz, px, py, pz) <= 5 then
        if target then
            if getElementData(player, "FuehrerscheinPraxis") == 1 then KlasseA = "vorhanden" else KlasseA = "keins" end
            if getElementData(player, "MotorradscheinPraxis") == 1 then KlasseB = "vorhanden" else KlasseB = "keins" end
            if getElementData(player, "LKWScheinPraxis") == 1 then KlasseC = "vorhanden" else KlasseC = "keins" end
            if getElementData(player, "BootscheinPraxis") == 1 then KlasseD = "vorhanden" else KlasseD = "keins" end
            if getElementData(player, "HelikopterscheinPraxis") == 1 then KlasseT = "vorhanden" else KlasseT = "keins" end
            if getElementData(player, "FlugscheinPraxis") == 1 then Flugschein = "vorhanden" else Flugschein = "keins" end
            if getElementData(player, "Waffenschein") == 1 then Waffenschein = "vorhanden" else Waffenschein = "keins" end

            infobox(player, "Du hast " .. getPlayerName(target) .. " deine Lizenzen gezeigt.", 0, 120, 0)
            infobox(target, getPlayerName(player) .. " zeigt dir seine Lizenzen.", 0, 120, 0)

            outputChatBox(getPlayerName(player) .. " zeigt dir seine Lizenzen:", target, 0, 200, 0)
            outputChatBox("Führerschein: " .. KlasseA, target, 0, 175, 0)
            outputChatBox("Motorradschein: " .. KlasseB, target, 0, 175, 0)
            outputChatBox("LKW-Schein: " .. KlasseC, target, 0, 175, 0)
            outputChatBox("Bootschein: " .. KlasseD, target, 0, 175, 0)
            outputChatBox("Helikopterschein: " .. KlasseT, target, 0, 175, 0)
            outputChatBox("Flugschein: " .. Flugschein, target, 0, 175, 0)
            outputChatBox("Waffenschein: " .. Waffenschein, target, 0, 175, 0)
        else infobox(player, "Du hast keinen Spieler angegeben, dem du deine Lizenzen zeigen willst.", 120, 0, 0) end
    else infobox(player, "Du bist nicht nah genug am Spieler", 120, 0, 0) end
end)

--// zeigePANGWDNote

addCommandHandler("showgwd", function(player, cmd, target)
    local target = getPlayerFromName(target)
    local tx, ty, tz = getElementPosition(target)
    local px, py, pz = getElementPosition(player)
    if getDistanceBetweenPoints3D(tx, ty, tz, px, py, pz) <= 5 then
        if target then
            infobox(player, "Du hast "..getPlayerName(target).." deine GWD Note gezeigt!", 0, 120, 0)
            infobox(target, getPlayerName(player).." hat dir seine GWD Note gezeigt!", 0, 120, 0)
            outputChatBox("GWD Note: " .. getElementData(player, "GWD"), target, 0, 200, 0)
        else infobox(player, "Du hast keinen Spieler angegeben, dem du deine GWD zeigen willst.", 120, 0, 0) end
    else infobox(player, "Du bist nicht nah genug am Spieler", 120, 0, 0) end
end)

addCommandHandler("pay", function(player, cmd, target, amount)
    if (getElementData(player, "loggedin") ~= 1) then return end
    if not amount then return end
    local target = getPlayerFromName(target)
    local amount = math.abs(tonumber(amount)) -- disables every negative nummber
    if target and amount and amount < 999999999 then
        local tx, ty, tz = getElementPosition(target)
        local px, py, pz = getElementPosition(player)
        if getDistanceBetweenPoints3D(tx, ty, tz, px, py, pz) > 5 then
            infobox(player,"Der Spieler ist nicht in deiner Nähe",120,0,0)
            return
        end
        
        local playerMoney = getElementData(player, "Geld")
        if (playerMoney < amount) then
            amount = playerMoney
        end

        setElementData(player, "Geld", playerMoney - amount)
        local targetMoney = getElementData(target, "Geld")
        setElementData(target, "Geld", targetMoney + amount)

        infobox(player, "Du hast "..getPlayerName(target).." "..amount.."€ zugesteckt.", 0, 120, 0)
        infobox(target, getPlayerName(player).." hat dir "..amount.."€ zugesteckt.", 0, 120, 0)
		payLog:write(player.name, target.name, amount)
		outputSpy("money", "%s hat %s %d€ gegeben.", player, target, amount)
    else
        outputChatBox("Syntax: /pay [NAME] [BETRAG]",player , 120, 0, 0)
    end
end)