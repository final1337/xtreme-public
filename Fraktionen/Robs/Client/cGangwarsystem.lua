Gangwar = {clientDatas = {}};

addEvent("Gangwar.openWindow",true)
addEventHandler("Gangwar.openWindow",root,function(id,besitzer)
	if(isWindowOpen())then
		Elements.window[1] = Window:create(985, 825, 285, 189,"Gangwargebiet",1280,1024);
		Elements.image[1] = Image:create(995, 895, 116, 109,"Files/Fraktionen/GW/Fraktion"..id..".jpg",1280,1024);
		Elements.text[1] = Text:create(1121, 895, 1260, 930,"Dieses Gebiet gehört den/der "..besitzer..".",1280,1024);
		Elements.button[1] = Button:create(1121, 977, 139, 27,"Gangwar starten","Gangwar.start",1280,1024);
		setWindowDatas();
    end
end)

function Gangwar.start()
	triggerServerEvent("Gangwar.start",localPlayer);
end

addEvent("Gangwar.updateDatas",true)
addEventHandler("Gangwar.updateDatas",root,function(attacker,defender,x,y,z,type)
	if(type == "create")then
		Gangwar.clientDatas = {attacker,defender};
		Gangwar.pickup = {x,y,z};
		addEventHandler("onClientRender",root,Gangwar.dxDrawMitmachen);
		addEventHandler("onClientRender",root,Gangwar.dxDraw);
		addEventHandler("onClientClick",root,Gangwar.mitmachenClick);
		Gangwar.refreshMatesTimer = setTimer(function()
			Gangwar.clientDatas[3] = 0; -- Insgesamt Angreifer
			Gangwar.clientDatas[4] = 0; -- Insgesamt Verteidiger
			Gangwar.clientDatas[5] = 0; -- Lebende Angreifer
			Gangwar.clientDatas[6] = 0; -- Lebende Verteidiger
			for _,v in pairs(getElementsByType("player"))do
				if(tonumber(getElementData(v,"Fraktion")) == tonumber(Gangwar.clientDatas[1]))then
					Gangwar.clientDatas[3] = Gangwar.clientDatas[3] + 1;
					if(getElementData(v,"ImGangwarGestorben") ~= true)then
						Gangwar.clientDatas[5] = Gangwar.clientDatas[5] + 1;
					end
				elseif(tonumber(getElementData(v,"Fraktion")) == tonumber(Gangwar.clientDatas[2]))then
					Gangwar.clientDatas[4] = Gangwar.clientDatas[4] + 1;
					if(getElementData(v,"ImGangwarGestorben") ~= true)then
						Gangwar.clientDatas[6] = Gangwar.clientDatas[6] + 1;
					end
				end
			end
		end,50,0)
		Gangwar.afk = setTimer(function()
			removeEventHandler("onClientRender",root,Gangwar.dxDrawMitmachen);
			triggerServerEvent("Gangwar.nichtMitmachen",localPlayer,"AFK");
		end,60000,1)
	elseif(type == "destroy")then
		removeEventHandler("onClientRender",root,Gangwar.dxDrawMitmachen);
		removeEventHandler("onClientRender",root,Gangwar.dxDraw);
		removeEventHandler("onClientClick",root,Gangwar.mitmachenClick);
		if(isTimer(Gangwar.refreshMatesTimer))then
			killTimer(Gangwar.refreshMatesTimer);
		end
	end
end)

addEvent("Gangwar.updateDatasTime",true)
addEventHandler("Gangwar.updateDatasTime",root,function(time)
	Gangwar.clientDatas[7] = time;
end)

function Gangwar.mitmachenClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if(button == "left" and state == "down")then
		if(isCursorOnElement(1146*(x/1280), 311*(y/1024), 128*(x/1280), 26*(y/1024)))then
			removeEventHandler("onClientRender",root,Gangwar.dxDrawMitmachen);
			removeEventHandler("onClientClick",root,Gangwar.mitmachenClick);
			triggerServerEvent("Gangwar.mitmachen",localPlayer);
			if(isTimer(Gangwar.afk))then killTimer(Gangwar.afk)end
		elseif(isCursorOnElement(1146*(x/1280), 347*(y/1024), 128*(x/1280), 26*(y/1024)))then
			removeEventHandler("onClientRender",root,Gangwar.dxDrawMitmachen);
			removeEventHandler("onClientClick",root,Gangwar.mitmachenClick);
			triggerServerEvent("Gangwar.nichtMitmachen",localPlayer);
			if(isTimer(Gangwar.afk))then killTimer(Gangwar.afk)end
		end
	end
end

function Gangwar.dxDrawMitmachen()
	if(isWindowOpen())then
		dxDrawRectangle(1146*(x/1280), 311*(y/1024), 128*(x/1280), 26*(y/1024), tocolor(28, 28, 28, 213), false)
        dxDrawRectangle(1146*(x/1280), 347*(y/1024), 128*(x/1280), 26*(y/1024), tocolor(28, 28, 28, 213), false)
        dxDrawText("Mitmachen", 1146*(x/1280), 311*(y/1024), 1274*(x/1280), 337*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Nicht mitmachen", 1146*(x/1280), 347*(y/1024), 1274*(x/1280), 373*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
	end
end

function Gangwar.dxDraw()
	if(isWindowOpen())then
		if(Gangwar.clientDatas[1] and Gangwar.clientDatas[2] and Gangwar.clientDatas[3] and Gangwar.clientDatas[4] and Gangwar.clientDatas[5] and Gangwar.clientDatas[6] and Gangwar.clientDatas[7])then
			local distance = getDistanceBetweenPoints3D(Gangwar.pickup[1],Gangwar.pickup[2],Gangwar.pickup[3],getElementPosition(localPlayer));
			if(distance <= 15)then r,g,b = 0,255,0 else r,g,b = 255,0,0 end
			dxDrawRectangle(1056*(x/1280), 182*(y/1024), 218*(x/1280), 19*(y/1024), tocolor(255, 100, 0, 255), false)
			dxDrawText("Gangwarsystem", 1056*(x/1280), 182*(y/1024), 1274*(x/1280), 201*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawRectangle(1056*(x/1280), 201*(y/1024), 218*(x/1280), 81*(y/1024), tocolor(28, 28, 28, 213), false)
			dxDrawRectangle(1066*(x/1280), 211*(y/1024), 98*(x/1280), 32*(y/1024), tocolor(Fraktionen["Farben"][Gangwar.clientDatas[1]][1], Fraktionen["Farben"][Gangwar.clientDatas[1]][2], Fraktionen["Farben"][Gangwar.clientDatas[1]][3],213), false)
			dxDrawRectangle(1166*(x/1280), 211*(y/1024), 98*(x/1280), 32*(y/1024), tocolor(Fraktionen["Farben"][Gangwar.clientDatas[2]][1], Fraktionen["Farben"][Gangwar.clientDatas[2]][2], Fraktionen["Farben"][Gangwar.clientDatas[2]][3],213), false)
			dxDrawText(Fraktionen["Namen"][Gangwar.clientDatas[1]].."\n"..Gangwar.clientDatas[5].."/"..Gangwar.clientDatas[3], 1066*(x/1280), 211*(y/1024), 1164*(x/1280), 243*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(Fraktionen["Namen"][Gangwar.clientDatas[2]].."\n"..Gangwar.clientDatas[6].."/"..Gangwar.clientDatas[4], 1166*(x/1280), 211*(y/1024), 1264*(x/1280), 243*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(getElementData(localPlayer,"TemporaerGWDamage"), 1089*(x/1280), 253*(y/1024), 1125*(x/1280), 272*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawImage(1066*(x/1280), 253*(y/1024), 23*(x/1280), 19*(y/1024), "Files/Images/flash.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawImage(1125*(x/1280), 253*(y/1024), 23*(x/1280), 19*(y/1024), "Files/Images/skull.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawText(getElementData(localPlayer,"TemporaerGWKills"), 1148*(x/1280), 253*(y/1024), 1176*(x/1280), 272*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawImage(1176*(x/1280), 253*(y/1024), 23*(x/1280), 19*(y/1024), "Files/Images/time.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawText(Gangwar.clientDatas[7], 1199*(x/1280), 253*(y/1024), 1264*(x/1280), 272*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText("Entfernung zum TK: "..math.floor(distance).." Meter", 1056*(x/1280), 282*(y/1024), 1274*(x/1280), 301*(y/1024), tocolor(r,g,b, 255), 1.00*(y/1024), "default-bold", "right", "center", false, false, false, false, false)
		end
	end
end

FactionMemberBlip = {}
FactionMemberBlip.Blips = {}
FactionMemberBlip.firstInit = false

FactionMemberBlip.StateFactions = {
	[1] = true,
	[2] = true,
	[3] = true,
}

FactionMemberBlip.FactionColour = {
	[0] = {255,255,255},
	[1] = {0,255,0},
	[2] = {188,237,8},
	[3] = {0,150,0},
	[4] = {255,127,0},
	[5] = {150,0,0},
	[6] = {0,162,255},
	[7] = {0,0,0},
	[8] = {158,94,41},
	[9] = {200,50,0},
	[10] = {101,18,104},
	[11] = {205,170,125},
	[12] = {225,225,0},
}

function FactionMemberBlip.init()
	FactionMemberBlip.firstInit = true
	FactionMemberBlip.refreshBlips()
end
addEventHandler("loginSuccess", root, FactionMemberBlip.init)

function FactionMemberBlip.refreshBlips()
	for key, value in ipairs(getElementsByType("player")) do
		FactionMemberBlip.addBlip(value)
	end
end

function FactionMemberBlip.addBlip(player, disconnect)
	local req = false
	
	if player and isElement(player) and player ~= localPlayer and not disconnect then
		if getElementData(player,"loggedin") and getElementData(player,"loggedin") == 1 then
			local faction = getElementData(player,"Fraktion")
			local ownFaction = getElementData(localPlayer,"Fraktion")
			if ownFaction >= 1 then
				if not FactionMemberBlip.StateFactions[ownFaction] then
					if faction == ownFaction then
						req = true
					end
				else
					if FactionMemberBlip.StateFactions[faction] then
						req = true
					end
				end
			end
		end
	else
		-- Delete the blip if it exists eventually
		if FactionMemberBlip.Blips[player] and isElement(FactionMemberBlip.Blips[player]) then
			destroyElement(FactionMemberBlip.Blips[player])
			FactionMemberBlip.Blips[player] = nil
		end
		return
	end

	if not req then
		if FactionMemberBlip.Blips[player] and isElement(FactionMemberBlip.Blips[player]) then
			destroyElement(FactionMemberBlip.Blips[player])
			FactionMemberBlip.Blips[player] = nil
		end
	else
		if not FactionMemberBlip.Blips[player] then
			local r,g,b = unpack(FactionMemberBlip.FactionColour[getElementData(player,"Fraktion")])
			FactionMemberBlip.Blips[player] = createBlipAttachedTo(player, 0, 2, r, g, b, 255, 0, 6000)
		end
	end
end

function FactionMemberBlip.onElementDataChange(key, oldValue, newValue)
	if ( key == "Fraktion" and FactionMemberBlip.firstInit ) or ( key == "loggedin" and source ~= localPlayer and FactionMemberBlip.firstInit ) then
		FactionMemberBlip.addBlip(source)
	end
	if key == "loggedin" and source == localPlayer and newValue == 1 then
		FactionMemberBlip.init()
	end
	if key == "Fraktion" and source == localPlayer then
		for key, value in pairs(FactionMemberBlip.Blips) do
			destroyElement(value)
		end
		FactionMemberBlip.Blips = {}
		FactionMemberBlip.refreshBlips()
	end
end
addEventHandler("onClientElementDataChange", root, FactionMemberBlip.onElementDataChange)

function FactionMemberBlip.onPlayerQuit()
	FactionMemberBlip.addBlip(source, true)
end
addEventHandler("onClientPlayerQuit", root, FactionMemberBlip.onPlayerQuit)