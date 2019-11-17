

Adminsystem = {
	["Namen"] = {
		[1] = "Ticketbeauftragter",
		[2] = "Supporter",
		[3] = "Moderator",
		[4] = "Developer",
		[5] = "Administrator",
		[6] = "Servermanager",
		[7] = "Stellv. Projektleiter",
		[8] = "Projektleiter",
	},
	["Farben"] = {
		[1] = "#808080",
		[2] = "#40e0d0",
		[3] = "#0000ff",
		[4] = "#c71585",
		[5] = "#32cd32",
		[6] = "#006400",
		[7] = "#8b0000",
		[8] = "#ff0000",
	},
    spectate = {},
};

function timestamp()
	local time = getRealTime();
	local year = time.year + 1900;
	local month = time.month + 1;
	local day = time.monthday;
	local hour = time.hour;
	if(hour == 24)then hour = 0 end
	local minute = time.minute;
	return tostring(day.."."..month.."."..year..", "..hour..":"..minute);
end

function getFactionMembers(faction)
	local tbl = {}
	for key, value in ipairs(getElementsByType("player")) do
		if faction == getElementData(value,"Fraktion") then
			table.insert(tbl, value)
		end
	end
	return tbl
end

function sendAdminMessage(text, r, g, b)
	for _, v in pairs(getElementsByType("player"))do
		if getElementData(v, "loggedin") == 1 and getElementData(v,"Adminlevel") >= 1 then
			outputChatBox("[Adminmsg]: "..text, v, r or 255, g or 255, b or 255, true);
		end
	end
end

addCommandHandler("unban",function(player,cmd,nick)
	if(getElementData(player,"loggedin") == 1)then
		if(nick)then
			local result = dbPoll(dbQuery(handler,"SELECT * FROM bans WHERE Username = '"..nick.."'"),-1);
			if(#result >= 1)then
				local admin = getPlayerData("bans","Username",nick,"Admin");
				if(getElementData(player,"Adminlevel") >= 4 or admin == getPlayerName(player))then
					dbExec(handler,"UPDATE bans SET Active = 0 WHERE Username = '"..nick.."'");
					outputChatBox(getPlayerName(player).." hat "..nick.." entbannt!",root,200,0,0);
				else infobox(player,"Du bist nicht dazu befugt, den Spieler zu entbannen!",120,0,0)end
			else infobox(player,"Der angegebene Spieler ist nicht gebannt!",120,0,0)end
		else infobox(player,"Es wurde kein Spieler angegeben!",120,0,0)end
	end
end)

-- [[ INSERT BAN ]]
function insertBan(targetName, adminName, ip, serial, time, reason)
    dbExec(handler, "INSERT INTO bans (Username, Admin, Grund, Datum, IP, Serial, STime) VALUES ('"..targetName.."', '"..adminName.."','"..reason.."', UNIX_TIMESTAMP(), '"..ip.."', '"..serial.."', "..(time * 60 * 60)..")")
    if (time ~= 0) then
        banLog:write(adminName, targetName, reason, time)
        outputChatBox("Der Spieler "..targetName.." wurde von "..adminName.." für "..time.." Stunden gebannt! Grund: "..reason, root, 200, 0, 0)
    else
        outputChatBox("Der Spieler "..targetName.." wurde von "..adminName.." permanent gebannt! Grund: "..reason, root, 200, 0, 0)
        banLog:write(adminName, targetName, reason, "Permanent")
	end
end

-- [[ PERM/TIME BAN PLAYERS ]]
addCommandHandler("rban", function(player, cmd, targetName, time, ...)
    if (getElementData(player, "Adminlevel") >= 2) then
        local reason = table.concat({...}, " ")
        local target = getPlayerFromName(targetName)
        local adminname = getPlayerName(player)
        if (tonumber(time) == nil) then
            reason = time.." "..reason
            time = 0
        end
        time = tonumber(time)
        if target and isElement(target) then
            if getElementData(target, "loggedin") == 1 then
                local username = getPlayerName(target)
                local ip = getPlayerIP(target)
                local serial = getPlayerSerial(target)
                if getElementData(target, "Adminlevel") < getElementData(player, "Adminlevel") then
                    insertBan(username, adminname, ip, serial, time, reason)
                    if (time ~= 0) then
                        kickPlayer(target, "Du wurdest von "..getPlayerName(player).." für "..time .." Stunden gebannt! Grund: "..reason)
                    else
                        kickPlayer(target, "Du wurdest von "..getPlayerName(player).." permanent gebannt! Grund: "..reason)
                    end
                else 
                    infobox(player, "Der Spieler hat einen höheren Adminlevel als du!", 120,0,0)
                end
            end
        else
            local result = getPlayerData("userdata", "Username", targetName, "Serial")
            if result then
                insertBan(targetName, adminname, "", result, time, reason)
            else
                infobox(player, "Der Spieler existiert nicht!", 200, 0, 0)
            end
        end
    else
        infobox(player, "Du darfst diesen Befehl nicht nutzen", 200, 0, 0)
	end
end)

-- [[ KICK PLAYER FROM SERVER ]]

addCommandHandler("rkick",function(player,cmd,target, ...)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			local reason = table.concat({...}, " ")
			if(target and reason)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					outputChatBox(getPlayerName(target).." wurde von "..getPlayerName(player).." gekickt! Grund: "..reason,root,200,0,0);
					kickPlayer(target,player,tostring(reason));
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Nutze /rkick [Spieler], [Grund]!",120,0,0)end
		end
	end
end)

-- [[ MAKE PLAYER FACTIONLEADER ]]

addCommandHandler("makeleader",function(player,cmd,target,faction)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 4)then
			if(target and faction)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local faction = tonumber(faction);
					setElementData(target,"Fraktion",faction);
					setElementData(target,"Rang",5);
					setElementData(target,"Duty",false);
					bindKey(target,"y","down","chatbox");
					infobox(target,"Du bist nun Leader!",0,120,0);
					infobox(player,"Du hast "..getPlayerName(target).." zum Leader von Fraktion "..faction.." gemacht.",0,120,0);
					giveFactionSkin(target);
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Nutze /makeleader [Spieler], [Fraktion]!",120,0,0)end
		end
	end
end)

-- [[ CHECK IF PLAYER IS BANNED ]]

function Adminsystem.kickPlayer(player)
    local result = dbPoll(dbQuery(handler, "SELECT * FROM ?? WHERE Username = ?", "bans", player), -1)

    if result and result[1] then
        for i = 1, #result do
            if tonumber(result[i]["Active"]) == 1 then
                if result[i]["STime"] ~= 0 and getRealTime().timestamp > result[i]["Datum"] + result[i]["STime"] then
                    dbExec(handler, "UPDATE bans SET Active = 0 WHERE ID = '"..result[i]["ID"].."'")
                else
                    local diff = (result[i]["Datum"] + result[i]["STime"]-getRealTime().timestamp)/60
                    if diff >= 0 then
                        cancelEvent(true, string.format("Du bist noch für %.2d:%.2d Stunden gebannt! Grund: %s", diff/60, diff%60, result[i]["Grund"]))
                    else
                        cancelEvent(true, "Du bist permanent gebannt! Grund: "..result[i]["Grund"])
                    end
                    return false
                end
            end
        end
    else
        return true
    end
end
addEventHandler("onPlayerConnect", root, Adminsystem.kickPlayer)

addCommandHandler("a",function(player,cmd,...)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 1)then
			local text = {...}
			text = table.concat(text," ");
			for _,v in pairs(getElementsByType("player"))do
				if(getElementData(v,"Adminlevel") >= 1)then
					outputChatBox("[ADMININTERN]: "..getPlayerName(player)..": "..text,v,99,184,255,true);
				end
			end
		end
	end
end)

addCommandHandler("o",function(player,cmd,...)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			local text = {...};
			text = table.concat(text," ");
			local rang = getElementData(player,"Adminlevel");
			outputChatBox("{{ "..Adminsystem["Farben"][rang]..Adminsystem["Namen"][rang].." "..getPlayerName(player).."#ffffff: "..text.." }}",root,255,255,255,true);
		end
	end
end)

local SavePos = {};

addCommandHandler("aspec",function(player,cmd,target)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			if(target)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local x,y,z = getElementPosition(player);
					local int,dim = getElementInterior(player),getElementDimension(player);
					setElementFrozen(player,true);
					setCameraTarget(player,target);
					setElementInterior(player,getElementInterior(target));
					setElementDimension(player,getElementDimension(target));
					SavePos[player] = {x,y,z,int,dim};
					infobox(player,"Nutze /stopspec, um aufzuhören, den Spieler zu specten.",0,120,0);
					fadeCamera(player,true);
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Du hast keinen Spieler angegeben!",120,0,0)end
		end
	end
end)

addCommandHandler("stopspec",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(SavePos[player])then
			fadeCamera(true);
			setElementFrozen(player,false);
			setElementPosition(player,SavePos[player][1],SavePos[player][2],SavePos[player][3]);
			setElementInterior(player,SavePos[player][4]);
			setElementDimension(player,SavePos[player][5]);
			setCameraTarget(player);
		end
	end
end)

local Adminveh = {};

addCommandHandler("acar",function(player,cmd,id)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 3)then
			if(not(isPedInVehicle(player)))then
				if(getElementInterior(player) == 0 and getElementDimension(player) == 0)then
					local x,y,z = getElementPosition(player);
					local rx,ry,rz = getElementRotation(player);
					if(isElement(Adminveh[player]))then destroyElement(Adminveh[player])end
					if(not(id))then id = 411 end
					Adminveh[player] = createVehicle(tonumber(id),x,y,z,rx,ry,rz);
					setVehicleColor(Adminveh[player],0,0,0);
					warpPedIntoVehicle(player,Adminveh[player]);
					setVehicleDamageProof(Adminveh[player],true);
					
					addEventHandler("onVehicleExit",Adminveh[player],function(_,seat)
						if(seat == 0)then
							destroyElement(source);
						end
					end)
				else infobox(player,"Hier nicht möglich!",120,0,0)end
			else infobox(player,"Du sitzt bereits in einem Fahrzeug!",120,0,0)end
		end
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(isElement(Adminveh[source]))then
		destroyElement(Adminveh[source]);
	end
end)

addCommandHandler("setadmin",function(player,cmd,target,lvl)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 6)then
			if(target and lvl)then
				local lvl = tonumber(lvl);
				if(lvl >= 0 and lvl <= 8)then
					local target = getPlayerFromName(target);
					if(isElement(target) and getElementData(target,"loggedin") == 1)then
						setElementData(target,"Adminlevel",lvl);
						infobox(player,"Das Adminlevel von "..getPlayerName(target).." wurde auf "..lvl.." gesetzt.",0,120,0);
						infobox(target,"Dein Adminlevel wurde auf "..lvl.." gesetzt.",0,120,0);
					else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
				else infobox(player,"Nur Adminlevel 0 - 6 möglich!",120,0,0)end
			else infobox(player,"Nutze /setadmin [Spieler], [Level]!",120,0,0)end
		end
	end
end)

addCommandHandler("cc",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 1)then
			clearChatBox();
			infobox(player,"Chat geleert.",0,120,0);
		end
	end
end)

addCommandHandler("mypos",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 1)then
			local x,y,z = getElementPosition(player);
			local rx,ry,rz = getElementRotation(player);
			outputChatBox("Position: "..x..", "..y..", "..z,player,255,255,0);
			outputChatBox("Rotation: "..rx..", "..ry..", "..rz,player,255,255,0);
		end
	end
end)

addCommandHandler("gotoveh",function(player,cmd,target,slot)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			if(target and slot)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local slot = tonumber(slot);
					local targetName = getPlayerName(target);
					if(isElement(Autohaus.vehicles[targetName][slot]))then
						local veh = Autohaus.vehicles[targetName][slot];
						local x,y,z = getElementPosition(veh);
						local int = getElementInterior(veh);
						local dim = getElementDimension(veh);
						if(int == 0 and dim == 0)then
							setElementPosition(player,x,y,z+1);
							setElementInterior(player,int);
							setElementDimension(player,dim);
						else infobox(player,"Nicht möglich, da Fahrzeug nicht in Dimension 0 oder in einem Interior!",120,0,0)end
					else infobox(player,"Das angegebene Fahrzeug existiert nicht!",120,0,0)end
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Nutze /gotoveh [Spieler], [Slot]!",120,0,0)end
		end
	end
end)

addCommandHandler("getveh",
	function(player,cmd,target,slot)
		if(getElementData(player,"loggedin") == 1)then
			if(getElementData(player,"Adminlevel") >= 2)then
				if(target and slot)then
					local target = getPlayerFromName(target)
					if(isElement(target) and getElementData(target,"loggedin") == 1)then
						local slot = tonumber(slot)
						local targetName = getPlayerName(target)
						if isElement(target:getVehicles()[slot]) then
							local veh = target:getVehicles()[slot]
							local x,y,z = getElementPosition(player)
							local int = getElementInterior(player)
							local dim = getElementDimension(player)

							local carparkId, carparkInstance = veh:getCarpark()

							if(int == 0 and dim == 0)then
								if carparkId ~= 0 then
									carparkInstance:removeVehicle(veh)
								end
							
								setElementPosition(veh,x,y+1,z)
								setElementInterior(veh,0)
								setElementDimension(veh,0)
							else
								infobox(player,"Nicht möglich, da du nicht in Dimension 0 oder in einem Interior bist!",120,0,0)
							end
						else 
							infobox(player,"Das angegebene Fahrzeug existiert nicht!",120,0,0)
						end
					else 
						infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)
					end
				else 
					infobox(player,"Nutze /gotoveh [Spieler], [Slot]!",120,0,0)
				end
			end
		end
	end
)



addCommandHandler("askin",function(player,cmd,target,skinID)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 3)then
			if(target and skinID)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local skinID = tonumber(skinID);
					if(skinID <= 311)then
						setElementModel(target,skinID);
						setElementData(target,"Skin",skinID);
					else infobox(player,"ID nicht verfügbar!",120,0,0)end
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Nutze /askin [Spieler], [Skin]!",120,0,0)end
		end
	end
end)

function Adminsystem.fix(player)
	if(getElementData(player,"loggedin") == 1)then
		if(isPedInVehicle(player))then
			if(getElementData(player,"Adminlevel") >= 4)then
				local veh = getPedOccupiedVehicle(player);
				fixVehicle(veh);
				infobox(player,"Fahrzeug repariert.",0,120,0);
			end
		end
	end
end
addCommandHandler("afix",Adminsystem.fix)

addCommandHandler("ausknasten",function(player,cmd,target)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 3)then
			if(target)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					if(getElementData(target,"Knastzeit") >= 1)then
						setElementData(target,"Knastzeit",0);
						freeFromJail(target);
						infobox(player,"Der Spieler wurde ausgeknastet.",0,120,0);
					else infobox(player,"Der Spieler ist nicht im Gefängnis!",120,0,0)end
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Du hast keinen Spieler angegeben!",120,0,0)end
		end
	end
end)

addCommandHandler("goto",function(player,cmd,target)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			if(target)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local x,y,z = getElementPosition(target);
					local int = getElementInterior(target);
					local dim = getElementDimension(target);
					if(isPedInVehicle(player))then
						if(int == 0)then
							local veh = getPedOccupiedVehicle(player);
							setElementPosition(veh,x,y+1,z);
							setElementDimension(veh,dim);
						else infobox(player,"Nicht möglich, spieler sitzt in einem Fahrzeug!",120,0,0)end
					else
						setElementPosition(player,x,y+1,z);
						setElementDimension(player,dim);
						setElementInterior(player,int);
					end
					teleportGetLog:write(player:getName(),target:getName());
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Du hast keinen Spieler angegeben!",120,0,0)end
		end
	end
end)

addCommandHandler("gethere",function(player,cmd,target)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			if(target)then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local x,y,z = getElementPosition(player);
					local int = getElementInterior(player);
					local dim = getElementDimension(player);
					if(isPedInVehicle(target))then
						if(int == 0)then
							local veh = getPedOccupiedVehicle(target);
							setElementPosition(veh,x,y+1,z);
							setElementDimension(veh,dim);
						else infobox(player,"Nicht möglich, Spieler sitzt in einem Fahrzeug!",120,0,0)end
					else
						setElementPosition(target,x,y+1,z);
						setElementDimension(target,dim);
						setElementInterior(target,int);
					end
					teleportGetLog:write(player:getName(),target:getName());
				else infobox(player,"Spieler nicht gefunden / nicht eingeloggt!",120,0,0)end
			else infobox(player,"Du hast keinen Spieler angegeben!",120,0,0)end
		end
	end
end)

addCommandHandler("vanish",function(player,cmd,mode)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			mode = tonumber(mode) or 0;
			setElementData(player, "vanish", mode);
			if (mode ~= false and mode > 0) then
				if (mode == 2) then
					setElementAlpha(player, 0);
				end
				outputChatBox("Vanish Mode "..mode.." aktiviert!", player, 0, 190, 0);
			else
				setElementAlpha(player, 255);
				outputChatBox("Du bist nun nicht mehr im Vanish!", player, 190, 0, 0);
			end
		end
	end
end)

-- Spy
local spyData = {}
function hasSpyOn(player, spy)
	if (spyData[player][spy] == nil) then
		return false
	end
	return spyData[player][spy]
end

function outputSpy(spy, message, ...)
    for player, key in pairs(spyData) do
		if (spyData[player] ~= nil) and (spyData[player][spy] ~= nil) then
			if (spyData[player][spy] == true) then
                local args = {...}
                local nArgs = {}
                for i, arg in ipairs(args) do
                    if (type(arg) == "userdata") and (getElementType(arg) == "player") then
                        table.insert(nArgs, string.format("#FF9D00%s#B0B0B0", getPlayerName(arg)))
                    else
                        table.insert(nArgs, arg)
                    end
                end
                outputChatBox("#B0B0B0[#FF7700SPY#B0B0B0] #B0B0B0"..string.format(message, unpack(nArgs)), player, 255, 255, 255, true)

			end
		end
	end
end

local function spyCmd(player, cmd, spy)
	if spy then
		if (player:getData("Adminlevel") >= 3 and player:getData("loggedin") == 1) then
			if not spyData[player] then
				spyData[player] = {}
			end
			if not spyData[player][spy] then
				spyData[player][spy] = false
			end
			spyData[player][spy] = not spyData[player][spy]
			local str = "#008C02eingeschaltet#B0B0B0"
			if spyData[player][spy] then
				str = "#008C02eingeschaltet#B0B0B0"
			else
				str = "#9E0000ausgeschaltet#B0B0B0"
			end
			outputChatBox(string.format("#B0B0B0Du hast %s Benachrichtigungen %s!", spy, str), player, 255, 255, 255, true)
		else
			outputChatBox("Du bist dazu nicht befugt!", player, 200, 0, 0)
		end
	end
end
addCommandHandler("spy", spyCmd)

addEventHandler("onElementDataChange", root, function(key, oldVal, newVal)
	if (key == "Geld" or key == "Bankgeld") and oldVal and newVal then
		outputSpy("rawmoney", "%s %s wurde von %d€ zu %d€ (%d€) geändert!", source, key, oldVal, newVal, newVal - oldVal)
	end
end)

function Adminsystem.getCamMatrix(me)
	local cx, cy, cz, lx, ly, lz = getCameraMatrix(me) 
	outputChatBox("camMatrix: "..cx..", "..cy..", "..cz..", "..lx ..", "..ly..", "..lz, me) 
end
addCommandHandler("getmatrix", Adminsystem.getCamMatrix)