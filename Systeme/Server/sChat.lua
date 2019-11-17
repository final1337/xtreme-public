--[[

	(c) FiNAL
	Xtreme Reallife
	2019

]]--

chat = {}

playerCanChat = function(player)
	if getElementData(player, "loggedin") == 1 and not isPedDead(player) then
		return true
	else
		return false
	end
end


chat.sendMsg = function (message, messageTyp)
    if getElementData(source, "loggedin") == 1 then
		if messageTyp == 0 then
			if not isPedDead(source) then
				local x, y, z = getElementPosition(source)
				local chatSphere = createColSphere(x, y, z, 30)
				local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")

				if getElementData(source, "callWith") ~= "none" then
					outputSpy("chat", "%s am Handy: %s", source, message)
					handyChatLog:write(source:getName(), message)
				else
					chatLog:write(source:getName(), message)
					outputSpy("chat", "%s sagt: %s", source, message)
				end

				for _, nearbyPlayer in ipairs(nearbyPlayers) do
					if getElementData(nearbyPlayer, "loggedin") == 1 then
						if getElementData(source, "callWith") ~= "none" then
							outputChatBox(getPlayerName(source) .. " am Handy: " .. message, nearbyPlayer, 255, 255, 255)
						else
							outputChatBox(getPlayerName(source) .. " sagt: " .. message, nearbyPlayer, 255, 255, 255)
						end
					end
				end
				
				if getElementData(source,"Live") and getPedOccupiedVehicle(source) and getElementData(getPedOccupiedVehicle(source),"Fraktion") then
					if getElementData(getPedOccupiedVehicle(source), "Fraktion") then
						outputChatBox("Gast "..getPlayerName(source) .. ": " .. message, root, 250,150,0)
					end
				end
				
				if getElementData(source, "callWith") ~= "none" then
					local target = getPlayerFromName(getElementData(source, "callWith"))
					outputChatBox(getPlayerName(source) .. " am Handy: " .. message, target, 200, 200, 50)
				end
			end
		elseif messageTyp == 2 then
			executeCommandHandler("t",source,message);
		end
    end
    cancelEvent()
end
addEventHandler("onPlayerChat", root, chat.sendMsg)

addEventHandler("onPlayerPrivateMessage", root, function()
	cancelEvent()
	infobox(player, "Seit wann können Tote sprechen?", 200, 200, 0)
end)

chat.meMsg = function(player, cmd, string)
	if playerCanChat(player) then
		local input = {string}
		local text = table.concat(input, " ")
		local x, y, z = getElementPosition(player)
		if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
			for k, v in ipairs (getElementsByType("player")) do
				if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 15 then
					outputChatBox("☆ "..getPlayerName(player).."  "..text, v, 180, 0, 180)
				end
			end
		end
	end
end
addCommandHandler("me", chat.meMsg)

chat.shout = function(player, cmd, string)
	if playerCanChat(player) then
		local input = {string}
		local text = table.concat(input, " ")
		local x, y, z = getElementPosition(player)
		if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
			for k, v in ipairs (getElementsByType("player")) do
				if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 30 then
					outputChatBox(getPlayerName(player).." schreit: "..text, v, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("s", chat.shout)

chat.whisper = function(player, cmd, string)
	if playerCanChat(player) then
		local input = {string}
		local text = table.concat(input, " ")
		local x, y, z = getElementPosition(player)
		if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
			for k, v in ipairs (getElementsByType("player")) do
				if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 4 then
					outputChatBox(getPlayerName(player).." flüstert: "..text, v, 175, 175, 175)
				end
			end
		end
	end
end
addCommandHandler("fl", chat.whisper)

chat.ooc = function(player, cmd, string)
	if playerCanChat(player) then
		local input = {string}
		local text = table.concat(input, " ")
		local x, y, z = getElementPosition(player)
		if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
			for k, v in ipairs (getElementsByType("player")) do
				if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 15 then
					outputChatBox("[OOC] "..getPlayerName(player)..":  "..text, v, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("ooc", chat.ooc)

offlineMessage = function(name, text)
	if name and text then
		dbExec(handler, "INSERT INTO offlinemessages (Name, Text) VALUES ('"..name.."', '"..text.."')")
	else
		print("Fehler in der Funktion offlineMessage")
	end
end

checkOfflineMSGs = function(player)
	local msg = dbPoll(dbQuery(handler, "SELECT * FROM offlinemessages"), -1)
	for k, v in ipairs(msg) do
		if v["Name"] == getPlayerName(player) then
			outputChatBox("#ff0000[Offline Nachricht] #ffffff"..v["Text"], player, 255, 255, 255, true)
			dbExec(handler, "DELETE FROM offlinemessages WHERE ID = '"..v["ID"].."'")
		end
	end
end
