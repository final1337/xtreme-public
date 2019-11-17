--// playerSound

addEvent("playSoundForPlayer", true)
addEventHandler("playSoundForPlayer", root, function(player, path)
    triggerClientEvent(player, "playSoundForPlayerCL", root, path)
end)

--// canelSound

addEvent("handyAuflegen_server", true)
addEventHandler("handyAuflegen_server", root, function(player)
    triggerClientEvent(player, "handyAuflegen_client", root)
end)

--// Animation

addEvent("phoneAnimation", true)
addEventHandler("phoneAnimation", root, function(player, state)
    if state == "on" then
        setPedAnimation(player, "ped", "PHONE_IN", 0, false)
    elseif state == "off" then
        setPedAnimation(player, "ped", "PHONE_OUT", 1000, false)
    end
end)


--// SMS

addEvent("SMS", true)
addEventHandler("SMS", root, function(text, player, r, g, b)
    outputChatBox(text, player, r, g, b)
end)