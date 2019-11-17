--[[

	(c) FiNAL
	Xtreme Reallife
	2019

]]--

local w, h = guiGetScreenSize()
local w, h = w/1920, h/1080

-- [[ Request Browser Domains
requestBrowserDomains({ "http://www.xtreme-rl.de" }, true)
-- ]]

Phone = { input = "", state = false, app = "none"}

    Phone.number0 = function()
        Phone.input = Phone.input.."0"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number1 = function()
        Phone.input = Phone.input.."1"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number2 = function()
        Phone.input = Phone.input.."2"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number3 = function()
        Phone.input = Phone.input.."3"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number4 = function()
        Phone.input = Phone.input.."4"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number5 = function()
        Phone.input = Phone.input.."5"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number6 = function()
        Phone.input = Phone.input.."6"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number7 = function()
        Phone.input = Phone.input.."7"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number8 = function()
        Phone.input = Phone.input.."8"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.number9 = function()
        Phone.input = Phone.input.."9"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.numberh = function()
        Phone.input = Phone.input.."#"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.numberk = function()
        Phone.input = Phone.input.."*"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.numbers = function()
        Phone.input = Phone.input.."+"
        Elements.text[2]:setText(Phone.input)
    end
    Phone.del = function()
        Phone.input = string.sub(Phone.input, 1, #Phone.input-1)
        Elements.text[2]:setText(Phone.input)
    end
    addEvent("Phone.numberh", true)
    addEvent("Phone.numbers", true)
    addEvent("Phone.numberk", true)
    addEventHandler("Phone.numberh", root, Phone.numberh)
    addEventHandler("Phone.numbers", root, Phone.numbers)
    addEventHandler("Phone.numberk", root, Phone.numberk)
    addEvent("Phone.number0", true)
    addEventHandler("Phone.number0", root, Phone.number0)
    addEvent("Phone.number1", true)
    addEventHandler("Phone.number1", root, Phone.number1)
    addEvent("Phone.number2", true)
    addEventHandler("Phone.number2", root, Phone.number2)
    addEvent("Phone.number3", true)
    addEventHandler("Phone.number3", root, Phone.number3)
    addEvent("Phone.number4", true)
    addEventHandler("Phone.number4", root, Phone.number4)
    addEvent("Phone.number5", true)
    addEventHandler("Phone.number5", root, Phone.number5)
    addEvent("Phone.number6", true)
    addEventHandler("Phone.number6", root, Phone.number6)
    addEvent("Phone.number7", true)
    addEventHandler("Phone.number7", root, Phone.number7)
    addEvent("Phone.number8", true)
    addEventHandler("Phone.number8", root, Phone.number8)
    addEvent("Phone.number9", true)
    addEventHandler("Phone.number9", root, Phone.number9)
    addEvent("Phone.del", true)
    addEventHandler("Phone.del", root, Phone.del)

    
Phone.constructor = function(type)
    if getElementData(localPlayer, "loggedin") == 1 then
    -- // Calls

    local time = getRealTime()
    local hour, minute = time.hour, time.minute
    if hour < 10 then hour = "0"..hour end
    if minute < 10 then minute = "0"..minute end

    -- // Call main app

    if not Phone.state then
        if getElementData(localPlayer, "Handystate") == "on" then
            Phone.state = true
            Elements.image[1] = Image:create(1608, 569, 285, 386, "Files/Images/Handy/phone_bg.png", 1920, 1080)
            Elements.image[2] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back.png", 1920, 1080)
            Elements.image[3] = Image:create(1635, 877, 63, 60, "Files/Images/Handy/call.png", 1920, 1080)
            Elements.image[4] = Image:create(1715, 877, 63, 60, "Files/Images/Handy/contact.png", 1920, 1080)
            Elements.image[5] = Image:create(1794, 877, 63, 60, "Files/Images/Handy/sms.png", 1920, 1080)
            Elements.image[6] = Image:create(1635, 807, 63, 60, "Files/Images/Handy/internet.png", 1920, 1080)
            Elements.text[1] = Text:create(1696, 569, 1800, 595, hour..":"..minute, 1920, 1080)
            setWindowDatas()
        elseif getElementData(localPlayer, "Handystate") == "off" then
            Phone.state = true
            dxClassClose()
            Elements.rectangle[1] = Rectangle:create(1608, 569, 285, 386, 0, 0, 0, 255, 1920, 1080)
            Elements.image[1] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back_off.png", 1920, 1080)                
            setWindowDatas()
        end
    else
        dxClassClose()
        Phone.browser = nil
        Phone.state = false
    end

    --[[
        callWith = incall
        Handystatus = Handystate
        call = call
        caller = Anrufer
    ]]
    addEvent("Phone.call", true)
    addEventHandler("Phone.call", root, function()
        Phone.telnr = Elements.text[2]:getText() print("1")
        if getElementData(localPlayer, "call") == "none" then print("2")
            for _, players in ipairs(getElementsByType("player")) do print("3")
                if getElementData(players, "loggedin") == true and tonumber(getElementData(players, "Telefonnummer")) == Phone.telnr then print("4")
                    if not tonumber(getElementData(localPlayer, "Telefonnummer")) == tonumber(getElementData(players, "Telefonnummer")) then print("5")
                        if getElementData(players, "Handystate") == true then print("6")
                            if getElementData(players, "incall") == "none" then 
                                triggerServerEvent("outputHandy", root, players, getPlayerName(localPlayer).." ruft an!", 0, 120, 0)
                                triggerServerEvent("playSound", root, players, "Files/Sounds/ringtone.mp3")
                                triggerServerEvent("hangUp", root, players)
                                infobox("Du rufst "..getPlayerName(players).." an!", 120, 0, 0)
                                setElementData(localPlayer, "call", getPlayerName(players))
                                setElementData(players, "Anrufer", getPlayerName(localPlayer))
                                Phone.connect(players)
                            else
                                infobox("Die Leitung ist besetzt...", 120, 0, 0)
                            end
                        else
                            infobox("Der Verbindungspartner hat sein Handy ausgeschaltet.", 120, 0, 0)
                        end
                     else
                        infobox("Guter Witz.", 120, 0, 0)
                    end
                else
                    infobox("Die Rufnummer existiert nicht!", 120, 0, 0)
                end
            end
        end
    end)
    addEventHandler("onClientClick", root, function(button, state)
         if Phone.state then 
            if button == "left" and state == "down" and isCursorOnElement(w*1635, h*877, w*63, h*60) then
                dxClassClose()
                destroyElement(Phone.browser)
                Elements.image[1] = Image:create(1608, 569, 285, 386, "Files/Images/Handy/phone_bg.png", 1920, 1080)
                Elements.image[2] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back.png", 1920, 1080)
                Elements.text[1] = Text:create(1696, 569, 1800, 595, hour..":"..minute, 1920, 1080)
                --
                Elements.rectangle[1] = Rectangle:create(1609, 601, 279, 46, 0, 0, 0, 200, 1920, 1080)
                Elements.rectangle[2] = Rectangle:create(1608, 653, 280, 284, 0, 0, 0, 200, 1920, 1080)
                Elements.rectangle[3] = Rectangle:create(1618, 663, 259, 42, 0, 0, 0, 200, 1920, 1080)
                Elements.text[2] = Text:create(1619, 663, 1877, 705, "Tastenfeld", 1920, 1080)
                Elements.text[3] = Text:create(1607, 601, 1885, 645, Phone.input, 1920, 1080)
                Elements.button[1] = Button:create(1618, 711, 47, 44, "0", "Phone.number0", 1920, 1080)
                Elements.button[2] = Button:create(1671, 711, 47, 44, "1", "Phone.number1", 1920, 1080)
                Elements.button[3] = Button:create(1724, 711, 47, 44, "2", "Phone.number2", 1920, 1080)
                Elements.button[4] = Button:create(1777, 711, 47, 44, "3", "Phone.number3", 1920, 1080)
                Elements.button[5] = Button:create(1830, 711, 47, 44, "4", "Phone.number4", 1920, 1080)
                Elements.button[6] = Button:create(1618, 759, 47, 44, "5", "Phone.number5", 1920, 1080)
                Elements.button[7] = Button:create(1671, 759, 47, 44, "6", "Phone.number6", 1920, 1080)
                -- Elements.button[8] = Button:create(1618, 711, 47, 44, "7", "Phone.number7", 1920, 1080) --
                Elements.button[8] = Button:create(1724, 759, 47, 44, "7", "Phone.number8", 1920, 1080)
                Elements.button[9] = Button:create(1777, 759, 47, 44, "8", "Phone.number9", 1920, 1080)
                Elements.button[10] = Button:create(1830, 759, 47, 44, "9", "Phone.numberh", 1920, 1080)
                Elements.button[11] = Button:create(1618, 881, 261, 46, "Anruf tätigen", "Phone.call", 1920, 1080)
                Elements.button[12] = Button:create(1618, 807, 47, 44, "+", "Phone.numbers", 1920, 1080) -- 
                Elements.button[13] = Button:create(1671, 807, 70, 44, "<<<<<<<", "Phone.del", 1920, 1080)                
                setWindowDatas()
            elseif button == "left" and state == "down" and isCursorOnElement(w*1635, h*807, w*63, h*60) then
                Phone.state = true
                dxClassClose()
                Elements.image[1] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back_nonotch.png", 1920, 1080)
                Phone.browser = guiCreateBrowser(w*1608, h*569, w*279, h*384, false, false, false)
                guiBringToFront(Phone.browser)
                loadBrowserURL(guiGetBrowser(Phone.browser), "http://www.xtreme-rl.de")
                addEventHandler("onClientBrowserCreated", Phone.browser, function()
                    loadBrowserURL(source, "http://www.xtreme-rl.de")
                    setBrowserProperty(guiGetBrowser(Phone.browser), "mobile", "1")
                end)
                setWindowDatas()
            elseif button == "left" and state == "down" and isCursorOnElement(w*1718, h*959, w*54, h*52) then
                Phone.state = true
                dxClassClose()
                destroyElement(Phone.browser)
                Elements.image[1] = Image:create(1608, 569, 285, 386, "Files/Images/Handy/phone_bg.png", 1920, 1080)
                Elements.image[2] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back.png", 1920, 1080)
                Elements.image[3] = Image:create(1635, 877, 63, 60, "Files/Images/Handy/call.png", 1920, 1080)
                Elements.image[4] = Image:create(1715, 877, 63, 60, "Files/Images/Handy/contact.png", 1920, 1080)
                Elements.image[5] = Image:create(1794, 877, 63, 60, "Files/Images/Handy/sms.png", 1920, 1080)
                Elements.image[6] = Image:create(1635, 807, 63, 60, "Files/Images/Handy/internet.png", 1920, 1080)
                Elements.text[1] = Text:create(1696, 569, 1800, 595, hour..":"..minute, 1920, 1080)
                setWindowDatas()
            elseif button == "left" and state == "down" and isCursorOnElement(w*1794, h*877, w*63, h*60) then
                dxClassClose()
                destroyElement(Phone.browser)
                Elements.image[1] = Image:create(1608, 569, 285, 386, "Files/Images/Handy/phone_bg.png", 1920, 1080)
                Elements.image[2] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back.png", 1920, 1080)
                Elements.text[1] = Text:create(1696, 569, 1800, 595, hour..":"..minute, 1920, 1080)
                --
                Elements.rectangle[1] = Rectangle:create(1609, 601, 279, 46, 0, 0, 0, 200, 1920, 1080)
                Elements.rectangle[2] = Rectangle:create(1608, 653, 280, 284, 0, 0, 0, 200, 1920, 1080)
                Elements.edit[1] = Edit:create(1618, 663, 259, 42, 1920, 1080)
                --Elements.rectangle[3] = Rectangle:create(1618, 663, 259, 42, 0, 0, 0, 200, 1920, 1080)
                Elements.text[2] = Text:create(1607, 601, 1885, 645, "Bitte bediene die Tastenfelder", 1920, 1080)
                Elements.button[1] = Button:create(1618, 711, 47, 44, "0", "Phone.number0", 1920, 1080)
                Elements.button[2] = Button:create(1671, 711, 47, 44, "1", "Phone.number1", 1920, 1080)
                Elements.button[3] = Button:create(1724, 711, 47, 44, "2", "Phone.number2", 1920, 1080)
                Elements.button[4] = Button:create(1777, 711, 47, 44, "3", "Phone.number3", 1920, 1080)
                Elements.button[5] = Button:create(1830, 711, 47, 44, "4", "Phone.number4", 1920, 1080)
                Elements.button[6] = Button:create(1618, 759, 47, 44, "5", "Phone.number5", 1920, 1080)
                Elements.button[7] = Button:create(1671, 759, 47, 44, "6", "Phone.number6", 1920, 1080)
                -- Elements.button[8] = Button:create(1618, 711, 47, 44, "7", "Phone.number7", 1920, 1080) --
                Elements.button[8] = Button:create(1724, 759, 47, 44, "7", "Phone.number7", 1920, 1080)
                Elements.button[9] = Button:create(1777, 759, 47, 44, "8", "Phone.number8", 1920, 1080)
                Elements.button[10] = Button:create(1830, 759, 47, 44, "9", "Phone.number9", 1920, 1080)
                Elements.button[11] = Button:create(1618, 881, 261, 46, "SMS versenden", "Phone.sms", 1920, 1080)
                Elements.button[12] = Button:create(1618, 807, 47, 44, "+", "Phone.numbers", 1920, 1080) -- 
                Elements.button[13] = Button:create(1671, 807, 70, 44, "<<<<<<<", "Phone.del", 1920, 1080)
                setWindowDatas()
            elseif button == "left" and state == "down" and isCursorOnElement(w*1655, h*967, w*35, h*34) then
                if getElementData(localPlayer, "Handystate") == "on" then
                    setElementData(localPlayer, "Handystate", "off")
                    dxClassClose()
                    Elements.rectangle[1] = Rectangle:create(1608, 569, 285, 386, 0, 0, 0, 255, 1920, 1080)
                    Elements.image[1] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back_off.png", 1920, 1080)                
                    setWindowDatas()
                elseif getElementData(localPlayer, "Handystate") == "off" then
                    setElementData(localPlayer, "Handystate", "on")
                    Phone.state = true
                    Elements.image[1] = Image:create(1608, 569, 285, 386, "Files/Images/Handy/phone_bg.png", 1920, 1080)
                    Elements.image[2] = Image:create(1548, 470, 400, 600, "Files/Images/Handy/phone_back.png", 1920, 1080)
                    Elements.image[3] = Image:create(1635, 877, 63, 60, "Files/Images/Handy/call.png", 1920, 1080)
                    Elements.image[4] = Image:create(1715, 877, 63, 60, "Files/Images/Handy/contact.png", 1920, 1080)
                    Elements.image[5] = Image:create(1794, 877, 63, 60, "Files/Images/Handy/sms.png", 1920, 1080)
                    Elements.image[6] = Image:create(1635, 807, 63, 60, "Files/Images/Handy/internet.png", 1920, 1080)
                    Elements.text[1] = Text:create(1696, 569, 1800, 595, hour..":"..minute, 1920, 1080)
                    setWindowDatas()
                end
            end
        end
    end)
    end
end
bindKey("u", "down", Phone.constructor)