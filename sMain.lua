--

-- [[ TABLES & VARIABLEN ]] --

local daytable = {"So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"};
local Dim = 99;
setFPSLimit(65);
setGameType("Xtreme Reallife");

-- [[ NAMETAG DEAKTIVIEREN ]] --

function deactivateNametag(player)
	setPlayerNametagShowing(player,false);
end

for _,v in pairs(getElementsByType("player"))do
	deactivateNametag(v);
end

addEventHandler("onPlayerJoin",root,function()
	deactivateNametag(source);
end)

function getDay()
	local realtime = getRealTime();
	local day = daytable[realtime.weekday+1];
	return day;
end


local time = getRealTime();
setTime(time.hour,time.hour);
setMinuteDuration(60000);

function infobox(player,text,r,g,b)
	triggerClientEvent(player,"infobox",player,text,r,g,b);
end

function getFreeDimension()
	Dim = Dim + 1;
	return Dim;
end

addEvent("setPlayerInFreeDimension",true)
addEventHandler("setPlayerInFreeDimension",root,function()
	local dim = getFreeDimension();
	setElementDimension(client,dim);
end)

function getSecTime(duration)
	local time = getRealTime();
	local year = time.year;
	local day = time.yearday;
	local hour = time.hour;
	local minute = time.minute;
	local total = year*365*24*60+day*24*60+(hour+duration)*60+minute;
	
	return total;
end

function convertMS(ms)
	local seconds = math.ceil(ms/1000);
	local minutes = math.floor(seconds/60);
	local seconds = seconds % 60;
	if(minutes < 10)then minutes = "0"..minutes end
	if(seconds < 10)then seconds = "0"..seconds end
	return minutes..":"..seconds;
end

addEvent("setPlayerSpawn", true)
addEventHandler("setPlayerSpawn", root, function(player, ort)
    if ort == "Straße" then
        dbExec(handler, "UPDATE userdata SET Spawnx = ?, Spawny = ?, Spawnz = ?, Spawnint = ?, Spawndim = ? WHERE Username = ?", Fraktionen["Spawns"][0][1], Fraktionen["Spawns"][0][2], Fraktionen["Spawns"][0][3], Fraktionen["Spawns"][0][4], Fraktionen["Spawns"][0][5], getPlayerName(player))
	elseif ort == "Fraktion" then
        dbExec(handler, "UPDATE userdata SET Spawnx = ?, Spawny = ?, Spawnz = ?, Spawnint = ?, Spawndim = ? WHERE Username = ?", Fraktionen["Spawns"][getElementData(player, "Fraktion")][1], Fraktionen["Spawns"][getElementData(player, "Fraktion")][2], Fraktionen["Spawns"][getElementData(player, "Fraktion")][3], Fraktionen["Spawns"][getElementData(player, "Fraktion")][4], Fraktionen["Spawns"][getElementData(player, "Fraktion")][5], getPlayerName(player))
    elseif ort == "Haus" then
        local ID = getElementData(player,"HouseID");
        local int = Haussystem["Interiors"][Haussystem[ID][7]];
        dbExec(handler, "UPDATE userdata SET Spawnx = ?, Spawny = ?, Spawnz = ?, Spawnint = ?, Spawndim = ? WHERE Username = ?", int[1],int[2],int[3], int[4], ID, getPlayerName(player))
    elseif ort == "Hier" then
        local x, y, z = getElementPosition(player)
        local int = getElementInterior(player)
        local dim = getElementDimension(player)
        dbExec(handler, "UPDATE userdata SET Spawnx = ?, Spawny = ?, Spawnz = ?, Spawnint = ?, Spawndim = ? WHERE Username = ?", x, y, z, int, dim, getPlayerName(player))
    end
end)

function cancelNickchange()
    outputChatBox("Du kannst dein Namen aktuell nicht ändern! Melde dich dazu beim Admin!", source, 0, 255, 0)
    cancelEvent()
end
addEventHandler("onPlayerChangeNick", getRootElement(), cancelNickchange)

function getFreeDimension()
	Dimension = Dimension + 1;
	return Dimension;
end