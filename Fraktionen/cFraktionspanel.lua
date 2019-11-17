--

-- [[ TABLES ]] --

Fraktionspanel = {};

Fraktionspanel.init = false

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

WantedComputer = {}

WantedComputer.punishReasons = {}
table.insert(WantedComputer.punishReasons,{"Körperverletzung","1"})	
table.insert(WantedComputer.punishReasons,{"Beamtenbehinderung","1"})		
table.insert(WantedComputer.punishReasons,{"Beleidigung/Belästigung","1"})
table.insert(WantedComputer.punishReasons,{"Befehlsverweigerung","1"})	
table.insert(WantedComputer.punishReasons,{"Sexistische Gesten","1"})
table.insert(WantedComputer.punishReasons,{"Drohung","1"})
table.insert(WantedComputer.punishReasons,{"Sachbeschädigung","1"})	
table.insert(WantedComputer.punishReasons,{"illegale Anzeige","1"})	
table.insert(WantedComputer.punishReasons,{"Diebstahl","2"})	
table.insert(WantedComputer.punishReasons,{"Beihilfe zur Flucht","2"})	
table.insert(WantedComputer.punishReasons,{"Beschuss","2"})		
table.insert(WantedComputer.punishReasons,{"Raubüberfall","3"})	
table.insert(WantedComputer.punishReasons,{"Mord","3"})	
table.insert(WantedComputer.punishReasons,{"Geiselnahme","4"})	
table.insert(WantedComputer.punishReasons,{"Baseeinbruch","4"})	
table.insert(WantedComputer.punishReasons,{"illegaler Transport","4"})	
table.insert(WantedComputer.punishReasons,{"Fahren ohne Führerschein","5"})
table.insert(WantedComputer.punishReasons,{"Terrorismus","6"})	
table.insert(WantedComputer.punishReasons,{"Knastausbruch","8"})	
table.insert(WantedComputer.punishReasons,{"Bankraub","12"})	
table.insert(WantedComputer.punishReasons,{"Sinnloses DM","12"})


WantedComputer.stvoReasons = {}
table.insert(WantedComputer.stvoReasons,{"Burnout","1"})	
table.insert(WantedComputer.stvoReasons,{"Wheelie","1"})		
table.insert(WantedComputer.stvoReasons,{"Parken auf der Straße","1"})
table.insert(WantedComputer.stvoReasons,{"Zerstören von Objekten","1"})
table.insert(WantedComputer.stvoReasons,{"Missachtung der Vorfahrtsregeln","2"})		
table.insert(WantedComputer.stvoReasons,{"Landen auf der Straße","3"})	
table.insert(WantedComputer.stvoReasons,{"Unfall bauen","4"})	
table.insert(WantedComputer.stvoReasons,{"Geisterfahrer","4"})	
table.insert(WantedComputer.stvoReasons,{"Illegale Straßenrennen","4"})	
table.insert(WantedComputer.stvoReasons,{"Rasen (120km/h)","5"})	
table.insert(WantedComputer.stvoReasons,{"Überfahren vom Passanten","6"})	
table.insert(WantedComputer.stvoReasons,{"Nitronutzung","6"})

function WantedComputer.load()
	WantedComputer.window = GUIWindow:new(screenWidth/2-500/2,screenHeight /2 -500/2, 500, 500, "Wantedcomputer", true)
	WantedComputer.window:getTitleLabel():setFont("default-bold")
	WantedComputer.window:setColor(50, 50, 50, 220)

	WantedComputer.wanteds 		= GUIClassicButton:new("Wanteds", 10, 30, 100, 40, WantedComputer.window)
	WantedComputer.stvo    	 	= GUIClassicButton:new("STVO", 110, 30, 100, 40, WantedComputer.window)
	WantedComputer.verwaltung 	= GUIClassicButton:new("Verwaltung", 210, 30, 100, 40, WantedComputer.window)

	GUIRectangle:new(233, 80, 8, 380, WantedComputer.window):setColor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3])


	WantedComputer.stvo.onLeftUp = WantedComputer.showSTVOPanel
	WantedComputer.wanteds.onLeftUp = WantedComputer.showWantedPanel
	WantedComputer.verwaltung.onLeftUp = WantedComputer.backToMenu


	WantedComputer.window:getCloseButton().onInternLeftUp = function () WantedComputer.window:setVisible(false) showCursor(false) end
	
end

WantedComputer.savedReasonsWanted = {}

function WantedComputer.showWantedPanel()
	
	if WantedComputer.stvoFrame then
		delete(WantedComputer.stvoFrame)
	end

	if WantedComputer.wantedFrame then
		delete(WantedComputer.wantedFrame)
	end

	--[[ WANTED-PANEL ]]

	WantedComputer.wantedFrame = GUIRectangle:new(0, 70, 500, 400, WantedComputer.window)
	WantedComputer.wantedFrame:setColor(0,0,0,0)

	GUILabel:new("Spieler: ", 10, 52, 300, 100, WantedComputer.window):setInteractable(false)
	WantedComputer.wantedFrame.searchedit = GUIEditbox:new(60, 20, 80, 24, WantedComputer.wantedFrame)
	WantedComputer.wantedFrame.searchclear = GUIClassicButton:new("Filter", 155, 20, 60, 24, WantedComputer.wantedFrame)

	WantedComputer.wantedFrame.searchclear.onLeftUp = WantedComputer.searchButtonWanted

	WantedComputer.wantedFrame.give = GUIClassicButton:new(loc"FP_GIVE_WANTEDS", 245, 280, 125, 50, WantedComputer.wantedFrame)
	WantedComputer.wantedFrame.delete   = GUIClassicButton:new(loc"FP_DELETE_WANTEDS",375, 280, 125, 50, WantedComputer.wantedFrame)
	WantedComputer.wantedFrame.orten = GUIClassicButton:new(loc"FP_TRACK", 245, 335, 255, 50, WantedComputer.wantedFrame)

	WantedComputer.wantedFrame.orten.onLeftUp = WantedComputer.wantedOrten

	WantedComputer.wantedFrame.wantedGrid = GUIGridList:new(10, 55, 220, 330, WantedComputer.wantedFrame)
	WantedComputer.wantedFrame.wantedGrid:addColumn("Spieler", 0.75)
	WantedComputer.wantedFrame.wantedGrid:addColumn("Wanteds", 0.25)
	WantedComputer.wantedFrame.wantedGrid.m_ScrollArea:changeScrollSpeedOnYAxis(10)

	WantedComputer.wantedFrame.punishGrid = GUIGridList:new(245, 15, 250, 250, WantedComputer.wantedFrame)
	WantedComputer.wantedFrame.punishGrid:addColumn("Grund", 0.8)
	WantedComputer.wantedFrame.punishGrid:addColumn("Wanteds", 0.2)
	WantedComputer.wantedFrame.punishGrid.m_ScrollArea:changeScrollSpeedOnYAxis(10)

	WantedComputer.wantedFrame.punishGrid:setMultiSelection(true)
	WantedComputer.wantedFrame.wantedGrid:setMultiSelection(true)
	WantedComputer.wantedFrame.punishGrid.onGridSelect = WantedComputer.saveChange

	WantedComputer.wantedFrame.give.onLeftUp = WantedComputer.giveWanted
	WantedComputer.wantedFrame.delete.onLeftUp = WantedComputer.deleteWanted

	WantedComputer.wantedFrame.searchedit.onChange = WantedComputer.searchWanted

	for key, value in ipairs(WantedComputer.punishReasons) do
		local row = WantedComputer.wantedFrame.punishGrid:addRow()
		row:setValue("Grund", value[1])
		row:setValue("Wanteds", value[2])

	end

	for key, value in ipairs(WantedComputer.wantedFrame.punishGrid:getEntrys()) do
		if WantedComputer.savedReasonsWanted[value:getColumnValue("Grund")] then
			WantedComputer.wantedFrame.punishGrid:setActiveRow(value, true, true)
		end
	end

	WantedComputer.searchWanted()

	WantedComputer.window:setVisible(true)

end

function WantedComputer.saveChange()
	WantedComputer.savedReasonsWanted = {}
	for key, row in ipairs(WantedComputer.wantedFrame.punishGrid:getActiveRows()) do
		WantedComputer.savedReasonsWanted[row:getColumnValue("Grund")] = true
	end
end

function WantedComputer.wantedOrten()
	local playerRows = WantedComputer.wantedFrame.wantedGrid:getActiveRows()

	for _, playerRow in ipairs(playerRows) do
		local player = playerRow:getColumnValue("Spieler")
		player = getPlayerFromName(player)

		if player and getElementData(player, "Handystatus") ~= "off" then
			if getElementInterior(player) == 0 then
				local x,y,z = getElementPosition(player)
				local blip = createBlipAttachedTo(player, 0, 2, 255, 0, 0, 255, 0, 6000)
				localPlayer:sendNotification("TRACK_NOTIFICATION", 0, 120, 0)
				Timer(destroyElement, 20000, 1, blip)
			else
				localPlayer:sendNotification("TRACK_WRONG_INTERIOR")
			end
		else
			localPlayer:sendNotification("TRACK_ERROR", 120, 0, 0)
		end
	end
end

function WantedComputer.stvoOrten()
	local playerRows = WantedComputer.stvoFrame.wantedGrid:getActiveRows()

	for _, playerRow in ipairs(playerRows) do
		local player = playerRow:getColumnValue("Spieler")
		player = getPlayerFromName(player)

		if player and getElementData(player, "Handystatus") ~= "off" then
			if getElementInterior(player) == 0 then			
				local x,y,z = getElementPosition(player)
				local blip = createBlipAttachedTo(player, 0, 2, 255, 0, 0, 255, 0, 6000)
				localPlayer:sendNotification("TRACK_NOTIFICATION", 0, 120, 0)
				Timer(destroyElement, 20000, 1, blip)
			else
				localPlayer:sendNotification("TRACK_WRONG_INTERIOR")
			end				
		else
			localPlayer:sendNotification("TRACK_ERROR", 120, 0, 0)
		end
	end
end

function WantedComputer.giveWanted()
	local playerRows = WantedComputer.wantedFrame.wantedGrid:getActiveRows()
	local wantedRows = WantedComputer.wantedFrame.punishGrid:getActiveRows()

	for _, playerRow in ipairs(playerRows) do
		local target = playerRow:getColumnValue("Spieler")
		for _, wantedRow in ipairs(wantedRows) do
			if playerRow and wantedRow then
				local reason = wantedRow:getColumnValue("Grund")
				local amount = wantedRow:getColumnValue("Wanteds")
				
				if target and reason and amount then
					triggerServerEvent("RP:Server:Fraktionspanel:giveWanteds", root, target, tonumber(amount), reason)
					setTimer(WantedComputer.searchWanted, 50, 1)
				end
			end
		end
	end
end

function WantedComputer.deleteWanted()
	local playerRows = WantedComputer.wantedFrame.wantedGrid:getActiveRows()
	local wantedRows = WantedComputer.wantedFrame.punishGrid:getActiveRows()

	for _, playerRow in ipairs(playerRows) do
		local target = playerRow:getColumnValue("Spieler")
		if playerRow and #wantedRows > 0 then
			for _, wantedRow in ipairs(wantedRows) do
				local reason = wantedRow:getColumnValue("Grund")
				local amount = wantedRow:getColumnValue("Wanteds")
				
				if target and reason and amount then
					triggerServerEvent("RP:Server:Fraktionspanel:giveWanteds", root, target, tonumber(amount)*-1, reason)
					setTimer(WantedComputer.searchWanted, 50, 1)
				end
			end
		elseif playerRow then
			triggerServerEvent("RP:Server:Fraktionspanel:deleteWanteds", root, target)
			setTimer(WantedComputer.searchWanted, 50, 1)
		end
	end
end

function WantedComputer.orten()

end

function WantedComputer.showSTVOPanel()

	if WantedComputer.stvoFrame then
		delete(WantedComputer.stvoFrame)
	end

	if WantedComputer.wantedFrame then
		delete(WantedComputer.wantedFrame)
	end

	--[[ STVO-PANEL ]]

	WantedComputer.stvoFrame = GUIRectangle:new(0, 70, 500, 400, WantedComputer.window)
	WantedComputer.stvoFrame:setColor(0,0,0,0)

	GUILabel:new("Spieler: ", 10, 52, 300, 100, WantedComputer.window):setInteractable(false)
	WantedComputer.stvoFrame.searchedit = GUIEditbox:new(60, 20, 80, 24, WantedComputer.stvoFrame)
	WantedComputer.stvoFrame.searchclear = GUIClassicButton:new("Filter", 155, 20, 60, 24, WantedComputer.stvoFrame)

	WantedComputer.stvoFrame.searchclear.onLeftUp = WantedComputer.searchButtonStvo

	WantedComputer.stvoFrame.give = GUIClassicButton:new(loc"FP_GIVE_STVO", 245, 280, 125, 50, WantedComputer.stvoFrame)
	WantedComputer.stvoFrame.delete   = GUIClassicButton:new(loc"FP_DELETE_STVO",375, 280, 125, 50, WantedComputer.stvoFrame)
	WantedComputer.stvoFrame.orten = GUIClassicButton:new(loc"FP_TRACK", 245, 335, 255, 50, WantedComputer.stvoFrame)

	WantedComputer.stvoFrame.orten.onLeftUp = WantedComputer.stvoOrten

	WantedComputer.stvoFrame.wantedGrid = GUIGridList:new(10, 55, 220, 330, WantedComputer.stvoFrame)
	WantedComputer.stvoFrame.wantedGrid:addColumn("Spieler", 0.75)
	WantedComputer.stvoFrame.wantedGrid:addColumn("Punkte", 0.25)
	WantedComputer.stvoFrame.wantedGrid.m_ScrollArea:changeScrollSpeedOnYAxis(10)

	WantedComputer.stvoFrame.punishGrid = GUIGridList:new(245, 15, 250, 250, WantedComputer.stvoFrame)
	WantedComputer.stvoFrame.punishGrid:addColumn("Grund", 0.8)
	WantedComputer.stvoFrame.punishGrid:addColumn("Punkte", 0.2)
	WantedComputer.stvoFrame.punishGrid.m_ScrollArea:changeScrollSpeedOnYAxis(10)

	WantedComputer.stvoFrame.punishGrid:setMultiSelection(true)
	WantedComputer.stvoFrame.wantedGrid:setMultiSelection(true)	

	WantedComputer.stvoFrame.give.onLeftUp = WantedComputer.giveSTVO
	WantedComputer.stvoFrame.delete.onLeftUp = WantedComputer.deleteSTVO

	WantedComputer.stvoFrame.searchedit.onChange = WantedComputer.searchSTVO	

	for key, value in ipairs(WantedComputer.stvoReasons) do
		local row = WantedComputer.stvoFrame.punishGrid:addRow()
		row:setValue("Grund", value[1])
		row:setValue("Punkte", value[2])
	end

	WantedComputer.searchSTVO()

	WantedComputer.window:setVisible(true)

end

function WantedComputer.giveSTVO()
	local playerRows = WantedComputer.stvoFrame.wantedGrid:getActiveRows()
	local wantedRows = WantedComputer.stvoFrame.punishGrid:getActiveRows()

	for _, playerRow in ipairs(playerRows) do
		local target = playerRow:getColumnValue("Spieler")
		for _, wantedRow in ipairs(wantedRows) do
			if playerRow and wantedRow then
				local reason = wantedRow:getColumnValue("Grund")
				local amount = wantedRow:getColumnValue("Punkte")
				
				if target and reason and amount then
					triggerServerEvent("RP:Server:Fraktionspanel:giveSTVO", root, target, tonumber(amount), reason)
					setTimer(WantedComputer.searchWanted, 50, 1)
				end
			end
		end
	end
end

function WantedComputer.deleteSTVO()
	local playerRows = WantedComputer.stvoFrame.wantedGrid:getActiveRows()
	local wantedRows = WantedComputer.stvoFrame.punishGrid:getActiveRows()

	for _, playerRow in ipairs(playerRows) do
		local target = playerRow:getColumnValue("Spieler")
		if playerRow and #wantedRows > 0 then
			for _, wantedRow in ipairs(wantedRows) do
				local reason = wantedRow:getColumnValue("Grund")
				local amount = wantedRow:getColumnValue("Punkte")
				
				if target and reason and amount then
					triggerServerEvent("RP:Server:Fraktionspanel:giveSTVO", root, target, tonumber(amount)*-1, reason)
					setTimer(WantedComputer.searchWanted, 50, 1)
				end
			end
		elseif playerRow then
			triggerServerEvent("RP:Server:Fraktionspanel:deleteSTVO", root, target)
			setTimer(WantedComputer.searchWanted, 50, 1)
		end
	end
end

local isFactionOrderingActive = true


local factionOrderColoured = {
	[1] =  { Name = "Da Nang Boys", FactionID = 5, Color = { 150,0,0 } },
	[2] =  { Name = "SF Rifa", FactionID = 6, Color = { 0,152,255 } },
	[3] =  { Name = "Nordic Angels", FactionID = 8, Color = { 150,70,0 } },
	[4] =  { Name = "Ballas", FactionID = 10, Color = { 77,4,59 } },
	[5] =  { Name = "Mafia", FactionID = 7, Color = { 150,150,150 } },
	[6] =  { Name = "Terroristen", FactionID = 11, Color = { 225, 182, 114 } },
	[7] =  { Name = "Zivilisten", FactionID = 0, Color = { 255, 255, 255 } },
	[8] =  { Name = "Feuerwehr", FactionID = 9, Color = { 255, 0, 0 } },
	[9] =  { Name = "Vekehrsordnung", FactionID = 12, Color = { 0, 252, 116 } },
	[10] =  { Name = "Reporter", FactionID = 4, Color = { 255, 150, 0 } },
	[11] = { Name = "SFPD", FactionID = 1, Color = { 0, 255, 0 } },
	[12] = { Name = "FBI", FactionID = 2, Color = { 200, 255, 0 } },
	[13] = { Name = "Bundeswehr", FactionID = 3, Color = { 0, 140, 0 } },
}


function WantedComputer.searchWanted(spielerName)
	spielerName = WantedComputer.wantedFrame.searchedit:getText()
	local player_wanted = {}
	local player_nowanted = {}

	-- factionOrderColoured
	
	if isFactionOrderingActive then
		local allPlayers = getElementsByType("player")
		for key, value in ipairs(factionOrderColoured) do
			table.insert(player_wanted, key)
			local addAble, addedSth = {}, false
			for _, player in ipairs ( allPlayers ) do
				local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
				if getElementData(player,"loggedin") == 1 and ( playerName:find(spielerName:lower()) or #spielerName == 0 ) and value.FactionID == getElementData(player, "Fraktion") then
					table.insert(addAble, {getPlayerName(player), getElementData(player,"Wanteds")})
					addedSth = true
				end
			end
			if addedSth then
				table.sort ( addAble, function (a,b) return a[2] > b[2] end )
				for key, value in ipairs ( addAble ) do
					table.insert(player_wanted, value)
				end
			else
				table.remove(player_wanted, #player_wanted)
			end
		end
	else
		for all,player in ipairs (getElementsByType("player")) do
			if #spielerName > 0 then
				local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
				if getElementData(player,"loggedin") == 1 and playerName:find(spielerName:lower()) then
					local wanted = getElementData(player,"Wanteds")
					if wanted and wanted > 0 then
						table.insert(player_wanted,{getPlayerName(player),wanted})
					else
						table.insert(player_nowanted,{getPlayerName(player),wanted})
					end
				end
			else
				if getElementData(player,"loggedin") == 1 then
					local wanted = getElementData(player,"Wanteds")
					if wanted and wanted > 0 then
						table.insert(player_wanted,{getPlayerName(player),wanted})
					else
						table.insert(player_nowanted,{getPlayerName(player),wanted})
					end
				end			
			end
		end	
		table.sort(player_wanted,sorttblby1)
		table.sort(player_nowanted,sorttblby1)	
		for k,v in pairs (player_nowanted) do 
			table.insert(player_wanted,v)
		end			
	end
	

	
	-- Get old selected players

	local oldSelected = {}

	local current = WantedComputer.wantedFrame.wantedGrid:getActiveRows()

	for key, currentRow in ipairs(current) do
		table.insert(oldSelected, currentRow:getColumnValue("Spieler"))
	end
	
	WantedComputer.wantedFrame.wantedGrid:flush()
	
	for key, value in ipairs ( player_wanted ) do
		if type(value) ~= "number" then
			local row = WantedComputer.wantedFrame.wantedGrid:addRow()
			row:setValue("Spieler", value[1])
			row:setValue("Wanteds", value[2])
			if value[2] > 0 then
				row:setColor(255,200,0,200)
			end
			for key, v in ipairs(oldSelected) do
				if v == value[1] then
					WantedComputer.wantedFrame.wantedGrid:setActiveRow(row, true)
					break
				end
			end
		else
			local row = WantedComputer.wantedFrame.wantedGrid:addRow()
			row:setValue("Spieler", factionOrderColoured[value].Name)
			row:setValue("Wanteds", "")
			row:setColor(unpack(factionOrderColoured[value].Color))
		end
	end
	
	WantedComputer.window:setVisible(true)	
end


function WantedComputer.searchSTVO(spielerName)
	spielerName = WantedComputer.stvoFrame.searchedit:getText()
	local player_wanted = {}
	local player_nowanted = {}

	-- factionOrderColoured
	
	if isFactionOrderingActive then
		local allPlayers = getElementsByType("player")
		for key, value in ipairs(factionOrderColoured) do
			table.insert(player_wanted, key)
			local addAble, addedSth = {}, false
			for _, player in ipairs ( allPlayers ) do
				local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
				if getElementData(player,"loggedin") == 1 and ( playerName:find(spielerName:lower()) or #spielerName == 0 ) and value.FactionID == getElementData(player, "Fraktion") then
					table.insert(addAble, {getPlayerName(player), getElementData(player,"STVO")})
					addedSth = true
				end
			end
			if addedSth then
				table.sort ( addAble, function (a,b) return a[2] > b[2] end )
				for key, value in ipairs ( addAble ) do
					table.insert(player_wanted, value)
				end
			else
				table.remove(player_wanted, #player_wanted)
			end
		end
	else
		for all,player in ipairs (getElementsByType("player")) do
			if #spielerName > 0 then
				local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
				if getElementData(player,"loggedin") == 1 and playerName:find(spielerName:lower()) then
					local wanted = getElementData(player,"STVO")
					if wanted and wanted > 0 then
						table.insert(player_wanted,{getPlayerName(player),wanted})
					else
						table.insert(player_nowanted,{getPlayerName(player),wanted})
					end
				end
			else
				if getElementData(player,"loggedin") == 1 then
					local wanted = getElementData(player,"STVO")
					if wanted and wanted > 0 then
						table.insert(player_wanted,{getPlayerName(player),wanted})
					else
						table.insert(player_nowanted,{getPlayerName(player),wanted})
					end
				end			
			end
		end	
		table.sort(player_wanted,sorttblby1)
		table.sort(player_nowanted,sorttblby1)	
		for k,v in pairs (player_nowanted) do 
			table.insert(player_wanted,v)
		end			
	end
	

	
	-- Get old selected players
	
	local oldSelected = {}

	local current = WantedComputer.stvoFrame.wantedGrid:getActiveRows()

	for key, currentRow in ipairs(current) do
		table.insert(oldSelected, currentRow:getColumnValue("Spieler"))
	end
	

	WantedComputer.stvoFrame.wantedGrid:flush()
	
	for key, value in ipairs ( player_wanted ) do
		if type(value) ~= "number" then
			local row = WantedComputer.stvoFrame.wantedGrid:addRow()
			row:setValue("Spieler", value[1])
			row:setValue("Punkte", value[2])
			if value[2] > 0 then
				row:setColor(255,200,0,200)
			end
			for key, v in ipairs(oldSelected) do
				if v == value[1] then
					WantedComputer.stvoFrame.wantedGrid:setActiveRow(row, true)
					break
				end
			end
		else
			local row = WantedComputer.stvoFrame.wantedGrid:addRow()
			row:setValue("Spieler", factionOrderColoured[value].Name)
			row:setValue("Punkte", "")
			row:setColor(unpack(factionOrderColoured[value].Color))
		end
	end
	
	WantedComputer.window:setVisible(true)	
end

function sorttblby1(w1,w2)
	if string.lower(w1[1]) < string.lower(w2[1]) then
		return true
	end
end


function WantedComputer.searchButtonWanted()
	isFactionOrderingActive = not isFactionOrderingActive
	WantedComputer.wantedFrame.searchedit:setText("")
	WantedComputer.searchWanted()
end

function WantedComputer.searchButtonStvo()
	isFactionOrderingActive = not isFactionOrderingActive
	WantedComputer.wantedFrame.searchedit:setText("")
	WantedComputer.searchSTVO()	
end

function WantedComputer.backToMenu()
	Fraktionspanel.window:setVisible(true)
	WantedComputer.window:setVisible(false)
	triggerServerEvent("Fraktionspanel.getDatas",localPlayer);
end

function Fraktionspanel.load()
	Fraktionspanel.window = GUIWindow:new(733, 315, 455, 451, "Fraktionsmenü", true)
	Fraktionspanel.window:getTitleLabel():setFont("default-bold")
	Fraktionspanel.window:setColor(50, 50, 50, 220)
	Fraktionspanel.buttons = {}
	Fraktionspanel.text = {}
	Fraktionspanel.edit = {}
	Fraktionspanel.gridlist = GUIGridList:new(10, 70, 222, 371, Fraktionspanel.window)
	Fraktionspanel.gridlist:addColumn("", 0.02)
	Fraktionspanel.gridlist:addColumn("Name", 0.6)
	Fraktionspanel.gridlist:addColumn("Rang", 0.15)
	Fraktionspanel.gridlist:addColumn("Warns", 0.2)
	Fraktionspanel.buttons[1] = GUIClassicButton:new("Einzahlen", 242, 136, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[2] = GUIClassicButton:new("Auszahlen", 242, 167, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[3] = GUIClassicButton:new("Inviten", 242, 234, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[4] = GUIClassicButton:new("Uninviten", 242, 265, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[5] = GUIClassicButton:new("Rang Up", 242, 296, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[6] = GUIClassicButton:new("Rang Down", 242, 327, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[7] = GUIClassicButton:new("Warn geben", 242, 358, 203, 21, Fraktionspanel.window)
	Fraktionspanel.buttons[8] = GUIClassicButton:new("Warn löschen", 242, 389, 203, 21, Fraktionspanel.window)
	if(getElementData(localPlayer,"Fraktion") == 1 or getElementData(localPlayer,"Fraktion") == 2 or getElementData(localPlayer,"Fraktion") == 3)then
		Fraktionspanel.buttons[9] = GUIClassicButton:new("Wantedcomputer", 242, 420, 203, 21, Fraktionspanel.window)
		Fraktionspanel.buttons[9].onLeftUp = Fraktionspanel.openWantedComputer
	elseif(getElementData(localPlayer,"Fraktion") == 4)then
		Fraktionspanel.buttons[9] = GUIClassicButton:new("Wettermenü", 242, 420, 203, 21, Fraktionspanel.window)
	else
		Fraktionspanel.buttons[9] = GUIClassicButton:new("Blacklist", 242, 420, 203, 21, Fraktionspanel.window)
	end	
	Fraktionspanel.text[1] = GUILabel:new("Fraktionskasse: 0 €",242, 70, 203, 30, Fraktionspanel.window)
	Fraktionspanel.text[2] = GUILabel:new("Summe: ",			242, 102, 203, 30, Fraktionspanel.window)
	Fraktionspanel.text[3] = GUILabel:new("Spielername: ",		242, 198, 203, 30, Fraktionspanel.window)

	Fraktionspanel.text[1]:setInteractable(false)
	Fraktionspanel.text[2]:setInteractable(false)
	Fraktionspanel.text[3]:setInteractable(false)

	Fraktionspanel.edit[1] = GUIEditbox:new(353, 100, 92, 26, Fraktionspanel.window)
	Fraktionspanel.edit[2] = GUIEditbox:new(353, 202, 92, 26, Fraktionspanel.window)
	-- Fraktionspanel.buttons[1] = GUIClassicButton:new("Einzahlen", 242, 136, 203, 21, self.m_Window)

	Fraktionspanel.buttons[1].onLeftUp = Fraktionspanel.einzahlen
	Fraktionspanel.buttons[2].onLeftUp = Fraktionspanel.auszahlen
	Fraktionspanel.buttons[3].onLeftUp = Fraktionspanel.invite
	Fraktionspanel.buttons[4].onLeftUp = Fraktionspanel.uninvite
	Fraktionspanel.buttons[5].onLeftUp = Fraktionspanel.rangUp
	Fraktionspanel.buttons[6].onLeftUp = Fraktionspanel.rangDown
	Fraktionspanel.buttons[7].onLeftUp = Fraktionspanel.giveWarn
	Fraktionspanel.buttons[8].onLeftUp = Fraktionspanel.deleteWarn


	Fraktionspanel.window:getCloseButton().onInternLeftUp = function () Fraktionspanel.window:setVisible(false) showCursor(false) end
	
end


-- [[ FENSTER ÖFFNEN ]] --

bindKey("f2","down",function()
	if(isWindowOpen())then
		if(getElementData(localPlayer,"Fraktion") >= 1) then
			if not Fraktionspanel.init then
				Fraktionspanel.load()
				WantedComputer.load()
				Fraktionspanel.init = true
			end

			if getElementData(localPlayer,"Fraktion") == 1 or getElementData(localPlayer,"Fraktion") == 2 or getElementData(localPlayer,"Fraktion") == 3 then
				if Fraktionspanel.window:isVisible() or WantedComputer.window:isVisible() then
					if Fraktionspanel.window:isVisible() then
						Fraktionspanel.window:setVisible(false)
					end
					if WantedComputer.window:isVisible() then
						WantedComputer.window:setVisible(false)
					end
					showCursor(false)
				else
					showCursor(true)
					WantedComputer.window:setVisible(true)
					WantedComputer.showWantedPanel()
				end
			else
				if Fraktionspanel.window then
					Fraktionspanel.window:setVisible(not Fraktionspanel.window:isVisible())
					if Fraktionspanel.window:isVisible() then
						triggerServerEvent("Fraktionspanel.getDatas",localPlayer);
						showCursor(true)
					else
						showCursor(false)
					end
				end
			end


		end
	end
end)

function Fraktionspanel.openWantedComputer()
	Fraktionspanel.window:setVisible(false)
	showCursor(true)
	WantedComputer.window:setVisible(true)
	WantedComputer.showWantedPanel()	
end

-- [[ REFRESH MEMBERLIST ]] --

addEvent("Fraktionspanel.refreshMemberlist",true)
addEventHandler("Fraktionspanel.refreshMemberlist",root,function(items)
	Fraktionspanel.gridlist:flush()
	for key, value in ipairs(items) do
		local row = Fraktionspanel.gridlist:addRow()
		row:setValue("Name",value.Name)
		row:setValue("Rang",value.Rang)
		row:setValue("Warns",value.Warns)
	end
	Fraktionspanel.window:setVisible(true)
end)

-- [[ REFRESH KASSE ]] --

addEvent("Fraktionspanel.updateKasse",true)
addEventHandler("Fraktionspanel.updateKasse",root,function(summe)
	Fraktionspanel.text[1]:setText("Fraktionskasse: "..summe.."€");
end)

-- [[ EIN- / AUSZAHLEN ]] --

function Fraktionspanel.einzahlen()
	local summe = Fraktionspanel.edit[1]:getText();
	if(#summe >= 1)then
		if(isOnlyNumbers(summe))then
			triggerServerEvent("Fraktionspanel.einzahlen",localPlayer,summe);
		end
	else infobox("Gib eine Summe an!",120,0,0)end
end
addEvent("Fraktionspanel.einzahlen",true)
addEventHandler("Fraktionspanel.einzahlen",root,Fraktionspanel.einzahlen)

function Fraktionspanel.auszahlen()
	local summe = Fraktionspanel.edit[1]:getText();
	if(#summe >= 1)then
		if(isOnlyNumbers(summe))then
			triggerServerEvent("Fraktionspanel.auszahlen",localPlayer,summe);
		end
	else infobox("Gib eine Summe an!",120,0,0)end
end
addEvent("Fraktionspanel.auszahlen",true)
addEventHandler("Fraktionspanel.auszahlen",root,Fraktionspanel.auszahlen)

-- [[ INVITEN / UNINVITEN ]] --

function Fraktionspanel.invite()
	local name = Fraktionspanel.edit[2]:getText();
	if(#name >= 1)then
		triggerServerEvent("Fraktionspanel.invite",localPlayer,name);
	else infobox("Gib einen Spielernamen ein!",120,0,0)end
end
addEvent("Fraktionspanel.invite",true)
addEventHandler("Fraktionspanel.invite",root,Fraktionspanel.invite)

function Fraktionspanel.uninvite()
	local row = Fraktionspanel.gridlist:getActiveRow()
	local spieler = row:getColumnValue("Name")
	if(#spieler >= 1 and spieler ~= "")then
		triggerServerEvent("Fraktionspanel.uninvite",localPlayer,spieler);
	else infobox("Wähle einen Spieler aus!",120,0,0)end
end
addEvent("Fraktionspanel.uninvite",true)
addEventHandler("Fraktionspanel.uninvite",root,Fraktionspanel.uninvite)

-- [[ RANG UP / DOWN ]] --

function Fraktionspanel.rangUp()
	local row = Fraktionspanel.gridlist:getActiveRow()
	local spieler = row:getColumnValue("Name")
	if(#spieler >= 1 and spieler ~= "")then
		triggerServerEvent("Fraktionspanel.rangUp",localPlayer,spieler);
	else infobox("Wähle einen Spieler aus!",120,0,0)end
end
addEvent("Fraktionspanel.rangUp",true)
addEventHandler("Fraktionspanel.rangUp",root,Fraktionspanel.rangUp)

function Fraktionspanel.rangDown()
	local row = Fraktionspanel.gridlist:getActiveRow()
	local spieler = row:getColumnValue("Name")
	if(#spieler >= 1 and spieler ~= "")then
		triggerServerEvent("Fraktionspanel.rangDown",localPlayer,spieler);
	else infobox("Wähle einen Spieler aus!",120,0,0)end
end
addEvent("Fraktionspanel.rangDown",true)
addEventHandler("Fraktionspanel.rangDown",root,Fraktionspanel.rangDown)

-- [[ WARN GEBEN / LÖSCHEN ]] --

function Fraktionspanel.giveWarn()
	local row = Fraktionspanel.gridlist:getActiveRow()
	local spieler = row:getColumnValue("Name")
	if(#spieler >= 1 and spieler ~= "")then
		triggerServerEvent("Fraktionspanel.giveWarn",localPlayer,spieler);
	else infobox("Wähle einen Spieler aus!",120,0,0)end
end
addEvent("Fraktionspanel.giveWarn",true)
addEventHandler("Fraktionspanel.giveWarn",root,Fraktionspanel.giveWarn)

function Fraktionspanel.deleteWarn()
	local row = Fraktionspanel.gridlist:getActiveRow()
	local spieler = row:getColumnValue("Name")
	if(#spieler >= 1 and spieler ~= "")then
		triggerServerEvent("Fraktionspanel.deleteWarn",localPlayer,spieler);
	else infobox("Wähle einen Spieler aus!",120,0,0)end
end
addEvent("Fraktionspanel.deleteWarn",true)
addEventHandler("Fraktionspanel.deleteWarn",root,Fraktionspanel.deleteWarn)

-- [[ BLACKLIST ]] --

function Fraktionspanel.openBlacklist()
	infobox("Kommt bald!",0,120,0);
end
addEvent("Fraktionspanel.openBlacklist",true)
addEventHandler("Fraktionspanel.openBlacklist",root,Fraktionspanel.openBlacklist)