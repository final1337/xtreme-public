local handyOpen = 0
handyWebsitesOpen = 0
local sub = ""
local anrufnummer = ""
local ringtone

bindKey("p", "down", function()
    if getElementData(getLocalPlayer(), "loggedin") == 1 and handyOpen == 0 then
        local x, y = screenx - 500, screeny / 2 - 600 / 2
        drawImage("xtmphone", "huelle_image", x, y, 400, 600, "Files/Images/Handy/phone_back")
        drawImage("xtmphone", "close", x + 110, y + 507, 23, 23, "Files/Images/Handy/platzhalter", "handySchliessen")
        drawImage("xtmphone", "shutdown", x + 260, y + 507, 23, 23, "Files/Images/Handy/platzhalter", "handyToggleState")
        drawImage("xtmphone", "home", x + 177, y + 498, 40, 40, "Files/Images/Handy/platzhalter", "handyMainMenu")
        showCursor(true)
        handyOpen = 1
        setElementData(getLocalPlayer(), "Clicked", true)
        triggerServerEvent("phoneAnimation", getRootElement(), getLocalPlayer(), "on")
        if getElementData(getLocalPlayer(), "Handystatus") == "off" then
            drawRectangle("xtmphone_bg", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(0, 0, 0, 255))
        else
            handyMainMenu()
        end
    else
        if not getElementData(getLocalPlayer(), "loggedin") then
            if sub == "xtmphone_internet" then
                guiSetInputEnabled(false)
                guiSetVisible(browser, false)
            end
            destroyWindow(sub)
            destroyWindow("xtmphone")
            destroyWindow("xtmphone_bg")
            setTimer(setElementData, 50, 1, getLocalPlayer(), "Clicked", false)
            handyOpen = 0
            anrufnummer = ""
            if isTimer(handyTimeTimer) then killTimer(handyTimeTimer) end
            triggerServerEvent("phoneAnimation", getRootElement(), getLocalPlayer(), "off")
        else
            handySchliessen()
        end
    end
end)

function handySchliessen()
    if sub == "xtmphone_internet" then
        guiSetInputEnabled(false)
        guiSetVisible(browser, false)
    end
    destroyWindow(sub)
    destroyWindow("xtmphone")
    destroyWindow("xtmphone_bg")
    showCursor(false)
    setTimer(setElementData, 50, 1, getLocalPlayer(), "Clicked", false)
    handyOpen = 0
    anrufnummer = ""
    if isTimer(handyTimeTimer) then killTimer(handyTimeTimer) end
    triggerServerEvent("phoneAnimation", getRootElement(), getLocalPlayer(), "off")
end

function handyFillFriendlist()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    local friendslist = {}
    local fileOld = xmlLoadFile("XML/friends.xml")
    local file = xmlLoadFile("XML/numbers.xml")
    if not file then
        file = xmlCreateFile("XML/numbers.xml", "xml")
        xmlSaveFile(file)
    end
    if fileOld then
        for k, v in pairs(xmlNodeGetChildren(fileOld)) do
            local spieler = xmlCreateChild(file, "Nmr" .. xmlNodeGetValue(v))
            xmlNodeSetValue(spieler, xmlNodeGetName(v))
        end
        xmlSaveFile(file)
        xmlUnloadFile(fileOld)
        fileDelete("XML/friends.xml")
    end
    for k, v in pairs(xmlNodeGetChildren(file)) do
        local nmr = tostring(xmlNodeGetName(v))
        table.insert(friendslist, { xmlNodeGetValue(v), tonumber(string.sub(nmr, 4, #nmr)) })
    end
    xmlSaveFile(file)
    xmlUnloadFile(file)
    if sub == "xtmphone_telefonbuch" then
        drawGridlist("xtmphone_telefonbuch", "Telefonbuch", x + 64, y + 160, 271, 210, { { "Name", 120 }, { "Nummer", 100 } }, friendslist)
    else
        drawGridlist("xtmphone_sms", "Telefonbuch", x + 64, y + 160, 271, 195, { { "Name", 120 }, { "Nummer", 100 } }, friendslist)
    end
end

function callMain()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    sub = "xtmphone_Anrufen"
    drawRectangle("xtmphone_Anrufen", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(100, 100, 100, 255))
    drawText("xtmphone_Anrufen", "ueberschrift_text", "Spieler Anrufen", x + 61, y + 102, 277, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    drawRectangle("xtmphone_Anrufen", "xtmphone4_bg", x + 61, y + 154, 277, 40, tocolor(0, 0, 0, 200))
    Nummereinfuegen()
    drawImage("xtmphone_Anrufen", "remove_image", x + 305, y + 163, 30, 20, "Files/Images/Handy/remove", "removeNumer")
    drawButton("xtmphone_Anrufen", "button1", "1", x + 72, y + 200, 80, 50, "HandyButton1")
    drawButton("xtmphone_Anrufen", "button2", "2", x + 159, y + 200, 80, 50, "HandyButton2")
    drawButton("xtmphone_Anrufen", "button3", "3", x + 246, y + 200, 80, 50, "HandyButton3")
    drawButton("xtmphone_Anrufen", "button4", "4", x + 72, y + 255, 80, 50, "HandyButton4")
    drawButton("xtmphone_Anrufen", "button5", "5", x + 159, y + 255, 80, 50, "HandyButton5")
    drawButton("xtmphone_Anrufen", "button6", "6", x + 246, y + 255, 80, 50, "HandyButton6")
    drawButton("xtmphone_Anrufen", "button7", "7", x + 72, y + 310, 80, 50, "HandyButton7")
    drawButton("xtmphone_Anrufen", "button8", "8", x + 159, y + 310, 80, 50, "HandyButton8")
    drawButton("xtmphone_Anrufen", "button9", "9", x + 246, y + 310, 80, 50, "HandyButton9")
    drawButton("xtmphone_Anrufen", "button*", "*", x + 72, y + 365, 80, 50, "HandyButtonsternchen")
    drawButton("xtmphone_Anrufen", "button0", "0", x + 159, y + 365, 80, 50, "HandyButton0")
    drawButton("xtmphone_Anrufen", "button#", "#", x + 246, y + 365, 80, 50, "HandyButtonraute")
    drawButton("xtmphone_Anrufen", "button_anrufen", "Anrufen", x + 72, y + 420, 254, 50, "HandyCall")
end

function Nummereinfuegen()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    if #anrufnummer <= 13 then
        drawText("xtmphone_Anrufen", "anrufen_text", "Nr: " .. anrufnummer, x + 61, y + 156, 250, 30, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    else
        infobox("Die Telefonnummer existiert nicht!", 125, 0, 0)
        anrufnummer = ""
    end
end


function Telefonbuch()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    sub = "xtmphone_telefonbuch"
    drawRectangle("xtmphone_telefonbuch", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(25, 25, 25, 255))
    drawRectangle("xtmphone_telefonbuch", "xtmphone2_bg", x + 61, y + 102, 277, 50, tocolor(255, 120, 0, 150))
    drawText("xtmphone_telefonbuch", "xtmphonetime_text", "Telefonbuch", x + 61, y + 102, 277, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    drawText("xtmphone_telefonbuch", "name_text", "Name:", x + 70, y + 414, 277, 50, tocolor(255, 255, 255, 255), 1.6, "default", "left", "top")
    drawRectangle("xtmphone_telefonbuch", "hinzufuegen_bg", x + 64, y + 410, 271, 70, tocolor(0, 0, 0, 180))
    drawRectangle("xtmphone_telefonbuch", "hinzufuegen2_bg", x + 64, y + 370, 271, 40, tocolor(255, 120, 0, 150))
    handyFillFriendlist()
    drawEdit("xtmphone_telefonbuch", "kontakt_edit", "", x + 130, y + 417, 200)
    drawButton("xtmphone_telefonbuch", "anrufen_btn", "Anrufen", x + 70, y + 375, 125, 30, "HandyCallFriend")
    drawButton("xtmphone_telefonbuch", "sms_btn", "SMS", x + 205, y + 375, 125, 30, "Nachricht")
    drawButton("xtmphone_telefonbuch", "hinzufuegne_btn", "Kontakt hinzufügen", x + 70, y + 446, 125, 30, "kontakt_hinzufuegen")
    drawButton("xtmphone_telefonbuch", "entfernen_btn", "Kontakt entfernen", x + 205, y + 446, 125, 30, "handyFriendlistDelete")
    sortGridlist("xtmphone_telefonbuch", "Telefonbuch", 1, true)
end

function kontakt_hinzufuegen()
    if #getEditText("xtmphone_telefonbuch", "kontakt_edit") >= 1 then
        local friend = getPlayerFromName(getEditText("xtmphone_telefonbuch", "kontakt_edit"))
        if friend and getElementData(friend, "loggedin") then
            local nmr = "Nmr" .. tostring(getElementData(friend, "Telefonnummer"))
            local file = xmlLoadFile("XML/numbers.xml")
            if not xmlFindChild(file, nmr, 0) then
                local spieler = xmlCreateChild(file, nmr)
                xmlNodeSetValue(spieler, getPlayerName(friend))
            end
            xmlSaveFile(file)
            xmlUnloadFile(file)
            Telefonbuch()
        else
            infobox("Der Spieler ist nicht on!", 120, 0, 0)
        end
    end
end

function handyFriendlistDelete()
    local friend = getGridlistSelectedItem("xtmphone_telefonbuch", "Telefonbuch")[2]
    if friend then
        local file = xmlLoadFile("XML/numbers.xml")
        local spieler = xmlFindChild(file, "Nmr" .. friend, 0)
        if spieler then
            xmlDestroyNode(spieler)
        end
        xmlSaveFile(file)
        xmlUnloadFile(file)
        handyFillFriendlist()
    end
end

function handyMainMenu()
    if getElementData(getLocalPlayer(), "Handystatus") == "on" then
        if getElementData(getLocalPlayer(), "caller") ~= "none" then
            einkommender_Anruf()
        elseif getElementData(getLocalPlayer(), "call") ~= "none" and getElementData(getLocalPlayer(), "callWith") == "none" then
            verbindung_aufbauen(getPlayerFromName(getElementData(getLocalPlayer(), "call")))
        elseif getElementData(getLocalPlayer(), "callWith") ~= "none" then
            telefonieren(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")))
        else
            local x, y = screenx - 500, screeny / 2 - 600 / 2
            destroyWindow(sub)
            if sub == "xtmphone_internet" then
                guiSetInputEnabled(false)
                guiSetVisible(browser, false)
            end
            sub = "xtmphone_main"
            drawImage("xtmphone_main", "bg_image", x + 61, y + 102, 277, 380, "Files/Images/Handy/phone_bg")

            local handyTimeTimer = setTimer(function()
                if getElementData(getLocalPlayer(), "Handystatus") == "on" and handyOpen == 1 and sub == "xtmphone_main" then
                    time = getRealTime()
                    drawText("xtmphone_main", "xtmphonetime_text", ((((time.hour < 10) and "0" .. time.hour) or time.hour) .. ":" .. (((time.minute < 10) and "0" .. time.minute) or time.minute)), x + 61, y + 110, 277, 100, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
                end
            end, 1000, 0)
            drawImage("xtmphone_main", "call", x + 65, y + 417, 60, 60, "Files/Images/Handy/call", "callMain")
            drawImage("xtmphone_main", "contact", x + 135, y + 417, 60, 60, "Files/Images/Handy/contact", "Telefonbuch")
            drawImage("xtmphone_main", "sms", x + 205, y + 417, 60, 60, "Files/Images/Handy/sms", "Nachricht")
            drawImage("xtmphone_main", "internet", x + 275, y + 417, 60, 60, "Files/Images/Handy/internet", "openInternet")
            drawImage("xtmphone_main", "settings", x + 275, y + 350, 60, 60, "Files/Images/Handy/settings", "openSettings")
        end
    end
end

function removeNumer()
    anrufnummer = ""
    Nummereinfuegen()
end

function Nachricht()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    sub = "xtmphone_sms"
    drawRectangle("xtmphone_sms", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(25, 25, 25, 255))
    drawRectangle("xtmphone_sms", "xtmphone2_bg", x + 61, y + 102, 277, 50, tocolor(255, 120, 0, 150))
    drawText("xtmphone_sms", "sms_text", "Nachricht", x + 61, y + 102, 277, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    handyFillFriendlist()
    drawRectangle("xtmphone_sms", "nummer_bg", x + 64, y + 358, 271, 45, tocolor(0, 0, 0, 140))
    drawText("xtmphone_sms", "nummer_text", "Telefonnummer:", x + 70, y + 360, 277, 50, tocolor(255, 255, 255, 255), 1.2, "default", "left", "top")
    drawEdit("xtmphone_sms", "nummer_edit", "", x + 70, y + 379, 258)
    drawRectangle("xtmphone_sms", "text_bg", x + 64, y + 405, 271, 70, tocolor(0, 0, 0, 180))
    drawText("xtmphone_sms", "name_text", "Nachricht:", x + 70, y + 414, 277, 50, tocolor(255, 255, 255, 255), 1.2, "default", "left", "top")
    drawEdit("xtmphone_sms", "nachricht_edit", "", x + 140, y + 414, 188)
    drawButton("xtmphone_sms", "sms_btn", "SMS schicken", x + 70, y + 440, 260, 30, "handySMSSend")
end

-- [[ SETTINGS APP ]]

-- | Standard Radar

function selectStandardRadar()
    config:set("Radar", "1")
    setElementData(localPlayer,"Radar", "1")
	setPlayerHudComponentVisible("radar", true)
	hideRadar()
	infobox("Standard Radar selektiert!", 0, 120, 0)
end
addEvent("selectStandardRadar", true)
addEventHandler("selectStandardRadar", root, selectStandardRadar)

-- | Xtreme Radar

function selectXtmRadar()
    config:set("Radar", "0")
    setElementData(localPlayer,"Radar", "0")
	setPlayerHudComponentVisible("radar", false)
	showRadar()
	infobox("Xtreme Custom Radar selektiert!", 0, 120, 0)
end
addEvent("selectXtmRadar", true)
addEventHandler("selectXtmRadar", root, selectStandardRadar)

function openSettings()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    sub = "xtmphone_settings"
    drawButton("xtmphone_settings", "settings_radar_standard", "Standard Radar auswählen", x + 70, y + 400, 260, 30, "selectStandardRadar")
    drawButton("xtmphone_settings", "settings_radar_xtm", "Xtreme Radar auswählen", x + 70, y + 440, 260, 30, "selectXtmRadar")
    drawRectangle("xtmphone_settings", "settings_bg", x + 61, y + 102, 277, 380, tocolor(25, 25, 25, 255))
end


function openInternet()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    local browsergeladen = 0
    destroyWindow(sub)
    sub = "xtmphone_internet"
    toggleControl("chatbox", false)
    screenWidth, screenHeight = guiGetScreenSize()
    guiSetInputEnabled(true)
    drawRectangle("xtmphone_internet", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(255, 255, 255, 255))
    -- drawText("xtmphone_internet", "Browser", "Vorerst Deaktivert!", x + 71, y + 102, 260, 300, tocolor(0, 0, 0, 255), 1.4, "default", "center", "center")
    browser = guiCreateBrowser(x + 61, y + 102, 277, 380, false, false, false, window)
    requestBrowserDomains({ "http://xtreme-rl.de/forum", true })
    theBrowser = guiGetBrowser(browser)
    addEventHandler("onClientBrowserCreated", theBrowser, function()
        loadBrowserURL(source, "http://xtreme-rl.de")
    end)
end

function HandyButton1()
    anrufnummer = anrufnummer .. "1"
    Nummereinfuegen()
end

function HandyButton2()
    anrufnummer = anrufnummer .. "2"
    Nummereinfuegen()
end

function HandyButton3()
    anrufnummer = anrufnummer .. "3"
    Nummereinfuegen()
end

function HandyButton4()
    anrufnummer = anrufnummer .. "4"
    Nummereinfuegen()
end

function HandyButton5()
    anrufnummer = anrufnummer .. "5"
    Nummereinfuegen()
end

function HandyButton6()
    anrufnummer = anrufnummer .. "6"
    Nummereinfuegen()
end

function HandyButton7()
    anrufnummer = anrufnummer .. "7"
    Nummereinfuegen()
end

function HandyButton8()
    anrufnummer = anrufnummer .. "8"
    Nummereinfuegen()
end

function HandyButton9()
    anrufnummer = anrufnummer .. "9"
    Nummereinfuegen()
end

function HandyButton0()
    anrufnummer = anrufnummer .. "0"
    Nummereinfuegen()
end

function HandyButtonsternchen()
    anrufnummer = anrufnummer .. "*"
    Nummereinfuegen()
end

function HandyButtonraute()
    anrufnummer = anrufnummer .. "#"
    Nummereinfuegen()
end

function einkommender_Anruf()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    if sub == "xtmphone_internet" then
        guiSetInputEnabled(false)
        guiSetVisible(browser, false)
    end
    sub = "xtmphone_incoming_call"
    drawRectangle("xtmphone_incoming_call", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(25, 25, 25, 255))
    drawRectangle("xtmphone_incoming_call", "xtmphone2_bg", x + 61, y + 102, 277, 50, tocolor(255, 120, 0, 150))
    drawText("xtmphone_incoming_call", "ueberschrift_text", "Sprachanruf", x + 61, y + 102, 277, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    drawRectangle("xtmphone_incoming_call", "xtmphone3_bg", x + 75, y + 210, 250, 150, tocolor(0, 0, 0, 150))
    drawText("xtmphone_incoming_call", "anruf_text", "Anruf von:\n" .. getElementData(getLocalPlayer(), "caller") .. "\n" .. tonumber(getElementData(getPlayerFromName(getElementData(getLocalPlayer(), "caller")), "Telefonnummer")), x + 75, y + 210, 250, 150, tocolor(255, 255, 255, 255), 1.6, "default", "center", "center")
    drawButton("xtmphone_incoming_call", "annehmen_btn", "Annehmen", x + 75, y + 420, 120, 50, "HandyCall")
    drawButton("xtmphone_incoming_call", "ablehnen_btn", "Ablehnen", x + 200, y + 420, 125, 50, "nicht_annehmen")
end

function telefonieren(player)
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    if sub == "xtmphone_internet" then
        guiSetInputEnabled(false)
        guiSetVisible(browser, false)
    end
    sub = "xtmphone_call"
    drawRectangle("xtmphone_call", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(25, 25, 25, 255))
    drawRectangle("xtmphone_call", "xtmphone2_bg", x + 61, y + 102, 277, 50, tocolor(255, 120, 0, 150))
    drawText("xtmphone_call", "ueberschrift_text", "Sprachanruf", x + 61, y + 102, 277, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    drawRectangle("xtmphone_call", "xtmphone3_bg", x + 75, y + 210, 250, 150, tocolor(0, 0, 0, 150))
    drawText("xtmphone_call", "anruf_text", "Du telefonierst mit:\n" .. getPlayerName(player) .. "\n" .. tonumber(getElementData(player, "Telefonnummer")), x + 75, y + 210, 250, 150, tocolor(255, 255, 255, 255), 1.6, "default", "center", "center")
    drawButton("xtmphone_call", "auflegen_btn", "Auflegen", x + 75, y + 420, 250, 50, "HandyStopCall")
end

function verbindung_aufbauen(player)
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    destroyWindow(sub)
    if sub == "xtmphone_internet" then
        guiSetInputEnabled(false)
        guiSetVisible(browser, false)
    end
    sub = "xtmphone_verbindung"
    drawRectangle("xtmphone_verbindung", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(25, 25, 25, 255))
    drawRectangle("xtmphone_verbindung", "xtmphone2_bg", x + 61, y + 102, 277, 50, tocolor(255, 120, 0, 150))
    drawText("xtmphone_verbindung", "ueberschrift_text", "Sprachanruf", x + 61, y + 102, 277, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    drawRectangle("xtmphone_verbindung", "xtmphone3_bg", x + 75, y + 210, 250, 150, tocolor(0, 0, 0, 150))
    drawText("xtmphone_verbindung", "anruf_text", "Rufe an...\n" .. getPlayerName(player) .. "\n" .. tonumber(getElementData(player, "Telefonnummer")), x + 75, y + 210, 250, 150, tocolor(255, 255, 255, 255), 1.6, "default", "center", "center")
    drawButton("xtmphone_verbindung", "auflegen_btn", "Auflegen", x + 75, y + 420, 250, 50, "HandyStopCall")
end

function nicht_annehmen()
    local spielercall = getPlayerFromName(getElementData(getLocalPlayer(), "caller"))
    setElementData(getLocalPlayer(), "call", "none")
    setElementData(spielercall, "call", "none")
    setElementData(spielercall, "caller", "none")
    setElementData(spielercall, "callWith", "none")
    setElementData(getLocalPlayer(), "callWith", "none")
    setElementData(getLocalPlayer(), "caller", "none")
    handyMainMenu()
    if isElement(ringtone) then destroyElement(ringtone) end
    triggerServerEvent("handyAuflegen_server", getRootElement(), spielercall)
    infobox("Du hast aufgelegt!", 120, 0, 0)
end

function HandyCall()
    if getElementData(getLocalPlayer(), "Handystatus") == "on" then
        if anrufnummer ~= "" and getElementData(getLocalPlayer(), "call") == "none" then
            local callNmr = anrufnummer
            for all, player in pairs(getElementsByType("player")) do
                if getElementData(player, "loggedin") then
                    if tonumber(getElementData(player, "Telefonnummer")) == tonumber(callNmr) then
                        if tonumber(getElementData(getLocalPlayer(), "Telefonnummer")) ~= tonumber(getElementData(player, "Telefonnummer")) then
                            if getElementData(player, "Handystatus") == "on" then
                                if getElementData(player, "callWith") == "none" then
                                    setElementData(player, "caller", getPlayerName(getLocalPlayer()))
                                    setElementData(getLocalPlayer(), "call", getPlayerName(player))
                                    infobox("Du rufst " .. getPlayerName(player) .. " an!", 0, 120, 0)
                                    verbindung_aufbauen(player)
                                    triggerServerEvent("playSoundForPlayer", getRootElement(), player, "Files/Images/Handy/Telephonee.mp3")
                                    triggerServerEvent("handyAuflegen_server", getRootElement(), player)
                                else
                                    infobox("Leitung ist belegt!", 125, 0, 0)
                                end
                            else

                                infobox("Spieler hat sein Handy ausgeschaltet!", 125, 0, 0)
                            end
                        else
                            infobox("Du kannst dich nicht selber anrufen!", 125, 0, 0)
                        end
                    end
                end
            end
        else
            if getElementData(getLocalPlayer(), "callWith") == "none" and getPlayerFromName(getElementData(getLocalPlayer(), "caller")) then
                telefonieren(getPlayerFromName(getElementData(getLocalPlayer(), "caller")))
                setElementData(getLocalPlayer(), "callWith", getPlayerName(getPlayerFromName(getElementData(getLocalPlayer(), "caller"))))
                setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "caller")), "callWith", getPlayerName(getLocalPlayer()))
                setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "caller")), "caller", "none")
                setElementData(getLocalPlayer(), "caller", "none")
                setElementData(getLocalPlayer(), "call", "none")
                triggerServerEvent("handyAuflegen_server", getRootElement(), getPlayerFromName(getElementData(getLocalPlayer(), "callWith")))
                if isElement(ringtone) then destroyElement(ringtone) end
                infobox("Du hast abgehoben!", 0, 125, 0)

            else

                infobox("Du kannst keinen Anruf annehmen!", 125, 0, 0)
            end
        end
    else
        infobox("Dein Handy ist aus!", 125, 0, 0)
    end
end

function HandyCallFriend()
    if getElementData(getLocalPlayer(), "Handystatus") == "on" then
        if getPlayerFromName(getGridlistSelectedItem("xtmphone_telefonbuch", "Telefonbuch")[1]) then
            local player = getPlayerFromName(getGridlistSelectedItem("xtmphone_telefonbuch", "Telefonbuch")[1])
            if getElementData(player, "Handystatus") == "on" then
                if getElementData(player, "callWith") == "none" then
                    setElementData(player, "caller", getPlayerName(getLocalPlayer()))
                    setElementData(getLocalPlayer(), "call", getPlayerName(player))
                    infobox("Du rufst " .. getPlayerName(player) .. " an!", 0, 125, 0)
                    verbindung_aufbauen(player)
                    triggerServerEvent("handyAuflegen_server", getRootElement(), player)
                    triggerServerEvent("playSoundForPlayer", getRootElement(), player, "Files/Images/Handy/Telephonee.mp3")
                else
                    infobox("Leitung ist belegt!", 125, 0, 0)
                end
            else
                infobox("Spieler hat sein Handy ausgeschaltet!", 125, 0, 0)
            end
        else
            infobox("Spieler ist nicht online!", 125, 0, 0)
        end
    else
        infobox("Dein Handy ist aus!", 125, 0, 0)
    end
end

function HandyStopCall()
    if getElementData(getLocalPlayer(), "callWith") ~= "none" then
        if getElementData(getLocalPlayer(), "callWith") == "none" then
            local spielercall = getElementData(getLocalPlayer(), "call")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "call")), "caller", "none")
            setElementData(getLocalPlayer(), "call", "none")
            setElementData(getLocalPlayer(), "callWith", "none")
            setElementData(getLocalPlayer(), "caller", "none")
            handyMainMenu()
            triggerServerEvent("handyAuflegen_server", getRootElement(), spieleranrufen)
        else
            local spieleranrufen = getPlayerFromName(getElementData(getLocalPlayer(), "callWith"))
            setElementData(getLocalPlayer(), "call", "none")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")), "call", "none")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")), "caller", "none")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")), "callWith", "none")
            setElementData(getLocalPlayer(), "callWith", "none")
            setElementData(getLocalPlayer(), "caller", "none")
            handyMainMenu()
            triggerServerEvent("handyAuflegen_server", getRootElement(), spieleranrufen)
        end
        handyMainMenu()
        infobox("Du hast aufgelegt!", 0, 125, 0)
    else
        infobox("Du musst auf Rückmeldung warten!", 0, 125, 0)
    end
end

function handyAuflegen_client()
    if handyOpen == 1 then
        setTimer(function()
            handyMainMenu()
        end, 500, 1)
    end
end

addEvent("handyAuflegen_client", true)
addEventHandler("handyAuflegen_client", getRootElement(), handyAuflegen_client)

function handySMSSend()
    if getElementData(getLocalPlayer(), "Handystatus") == "on" then
        if #getEditText("xtmphone_sms", "nachricht_edit") >= 1 then
            if #getEditText("xtmphone_sms", "nummer_edit") > 1 then
                local callNmr = getEditText("xtmphone_sms", "nummer_edit")
                for all, player in pairs(getElementsByType("player")) do
                    if getElementData(player, "loggedin") then
                        if tonumber(getElementData(player, "Telefonnummer")) == tonumber(callNmr) then
                            if tonumber(getElementData(getLocalPlayer(), "Telefonnummer")) ~= tonumber(getElementData(player, "Telefonnummer")) then
                                if getElementData(player, "Handystatus") == "on" then
                                    triggerServerEvent("SMS", getRootElement(), "SMS von " .. getPlayerName(getLocalPlayer()) .. "(" .. tonumber(getElementData(getLocalPlayer(), "Telefonnummer")) .. ") : " .. getEditText("xtmphone_sms", "nachricht_edit"), player, 0, 120, 0)
                                    Nachricht()
                                    infobox("Nachricht wurde gesendet!", 0, 125, 0)
                                else
                                    infobox("Spieler hat sein Handy ausgeschaltet!", 125, 0, 0)
                                end
                            else
                                infobox("Du kannst dir nicht selber eine SMS schreiben!", 125, 0, 0)
                            end
                        end
                    end
                end
            elseif getPlayerFromName(getGridlistSelectedItem("xtmphone_sms", "Telefonbuch")[1]) then
                if getElementData(getPlayerFromName(getGridlistSelectedItem("xtmphone_sms", "Telefonbuch")[1]), "Handystatus") == "on" then
                    triggerServerEvent("SMS", getRootElement(), "SMS von " .. getPlayerName(getLocalPlayer()) .. ": " .. getEditText("xtmphone_sms", "nachricht_edit"), getPlayerFromName(getGridlistSelectedItem("xtmphone_sms", "Telefonbuch")[1]), 0, 120, 0)
                    Nachricht()
                    infobox("Nachricht wurde gesendet!", 0, 125, 0)
                else
                    infobox("Spieler hat sein Handy ausgeschaltet!", 125, 0, 0)
                end
            else

                infobox("Spieler ist nicht online!", 125, 0, 0)
            end
        else
            infobox("Gib eine Nachricht ein!", 0, 0, 125)
        end
    else
        infobox("Dein Handy ist aus!", 125, 0, 0)
    end
end

function handyToggleState()
    local x, y = screenx - 500, screeny / 2 - 600 / 2
    if getElementData(getLocalPlayer(), "Handystatus") == "off" then
        setElementData(getLocalPlayer(), "Handystatus", "on")
        handyMainMenu()
        infobox("Handy eingeschaltet!", 0, 125, 0)
    else
        if getPlayerFromName(getElementData(getLocalPlayer(), "call")) then
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "call")), "caller", "none")
            setElementData(getLocalPlayer(), "call", "none")
            setElementData(getLocalPlayer(), "callWith", "none")
            setElementData(getLocalPlayer(), "caller", "none")
        elseif getPlayerFromName(getElementData(getLocalPlayer(), "callWith")) then
            setElementData(getLocalPlayer(), "call", "none")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")), "call", "none")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")), "caller", "none")
            setElementData(getPlayerFromName(getElementData(getLocalPlayer(), "callWith")), "callWith", "none")
            setElementData(getLocalPlayer(), "callWith", "none")
            setElementData(getLocalPlayer(), "caller", "none")
        end
        destroyWindow(sub)
        if sub == "xtmphone_internet" then
            guiSetInputEnabled(false)
            guiSetVisible(browser, false)
        end
        setElementData(getLocalPlayer(), "Handystatus", "off")
        drawRectangle("xtmphone", "xtmphone_bg", x + 61, y + 102, 277, 380, tocolor(0, 0, 0, 255))

        infobox("Handy wurde ausgeschaltet!", 125, 0, 0)
    end
end

function HandyWebSearch()
    handyWebAllClose()
    if string.find(string.lower(guiGetText(handyEdit[1])), "xtreme-rl.de") then
        guiSetVisible(handyWebsite_xtm, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "google.de") then
        guiSetVisible(handyWebsite_google, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "fbi.xtm") then
        guiSetVisible(handyWebsite_fbi, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "reporter.xtm") then
        guiSetVisible(handyWebsite_reporter, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "sfrifa.xtm") then
        guiSetVisible(handyWebsite_rifa, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "danangboys.xtm") then
        guiSetVisible(handyWebsite_dnb, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "mafia.xtm") then
        guiSetVisible(handyWebsite_mafia, true)
    elseif string.find(string.lower(guiGetText(handyEdit[1])), "nordicangels.xtm") then
        guiSetVisible(handyWebsite_nordic, true)
    end
end

function HandyWebSearchWeb()
    if string.find(string.lower(guiGetText(handyEdit[3])), "xtreme-rl.de") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_xtm, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "google.de") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_google, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "fbi.xtm") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_fbi, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "reporter.xtm") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_reporter, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "sfrifa.xtm") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_rifa, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "danangboys.xtm") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_dnb, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "mafia.xtm") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_mafia, true)
    elseif string.find(string.lower(guiGetText(handyEdit[3])), "nordicangels.xtm") then
        handyWebAllClose()
        guiSetVisible(handyWebsite_nordic, true)
    end
end

function HandyShowWebsites()
    if guiGetVisible(handyGrid[2]) == false then
        guiSetVisible(handyGrid[2], true)
        handyWebsitesOpen = 1
    else
        guiSetVisible(handyGrid[2], false)
        handyWebsitesOpen = 0
    end
end

function handyWebAllClose(web)
    guiSetVisible(handyButton[28], false)
    guiSetVisible(handyGrid[2], false)
    guiSetVisible(handyWebsite, true)
    guiSetVisible(handyWebsite_xtm, true)
    guiSetVisible(handyWebsite_error, false)
    guiSetVisible(handyWebsite_google, false)
    guiSetVisible(handyWebsite_fbi, false)
    guiSetVisible(handyWebsite_reporter, false)
    guiSetVisible(handyWebsite_rifa, false)
    guiSetVisible(handyWebsite_dnb, false)
    guiSetVisible(handyWebsite_mafia, false)
    guiSetVisible(handyWebsite_nordic, false)
    guiSetVisible(handyWebsite_me, false)
    guiSetVisible(handyLabel[6], false)
    guiSetVisible(handyLabel[7], false)
    guiSetVisible(handyEdit[1], false)
    guiSetVisible(handyTelefonieren, false)
end

function HandyShowWebsitesStart()
    if guiGridListGetItemText(handyGrid[2], guiGridListGetSelectedItem(handyGrid[2]), 1) == "www.xtreme-rl.de" then
        handyWebAllClose()
        guiSetVisible(handyWebsite_xtm, true)
    end
end

function playSoundForPlayerCL(sound)
    ringtone = playSound(sound, true)
end

addEvent("playSoundForPlayerCL", true)
addEventHandler("playSoundForPlayerCL", getRootElement(), playSoundForPlayerCL)