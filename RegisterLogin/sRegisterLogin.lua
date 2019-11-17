--

addEvent("stopResource",true)

clearChatBox();
local xtmTeam = createTeam("Xtreme");
local PaydayTimer = {};

local Datas = {"Username", "Serial", "Spielstunden","Geld","Bankgeld","Fraktion","Rang","Adminlevel","VIP","Aepfel","Orangen","Salat","Hanf","Level","Erfahrungspunkte","Job","Apfelsamen","Orangensamen","Hanfsamen","Salatsamen","Eisen","Holz","Skin","Wanteds","Levelpoints","Metall","Reifenpumpe","PremiumSilber","PremiumGold","Benzinkanister","Ghettoblaster","Knastzeit","Gloops","Graffitis","STVO","Kills","Tode","PAN","GWD","Eisenerz","FuehrerscheinTheorie","FuehrerscheinPraxis","MotorradscheinTheorie","MotorradscheinPraxis","LKWScheinTheorie","LKWScheinPraxis","BootscheinTheorie","BootscheinPraxis","HelikopterscheinTheorie","HelikopterscheinPraxis","FlugscheinTheorie","FlugscheinPraxis", "Hausschluessel","Warns","SniperPerm", "Telefonnummer","Muskeln","Fett", "Waffenschein", "ErfahrungspunkteZumAusgeben","Language", "Schwarzpulver", "RadarID", "vanish", "Bonus", "Krankenhaus", "lastLogin"}
handler = dbConnect("mysql","dbname=xtreme;host=;charset=utf8","root","");



if(handler)then
	outputDebugString("Datenbankverbindung hergestellt.");
else
	outputDebugString("Datenbankverbindung nicht hergestellt.");
end

function getPlayerData(from,where,name,data)
	if(from and where and name and data)then
		local sql = dbQuery(handler,"SELECT ?? FROM ?? WHERE ?? = ?", data, from, where, name);
		if(sql)then
			local rows = dbPoll(sql,-1);
			for _,v in pairs(rows)do
				return v[data];
			end
		end
	end
end

function getAllPlayerData(from,where,name)
	if(from and where and name)then
		local sql = dbQuery(handler,"SELECT * FROM ?? WHERE ?? = ?", from, where, name);
		if(sql)then
			local rows = dbPoll(sql,-1);
			for _,v in pairs(rows)do
				return v;
			end
		end
	end
end

-- Anti Color
addEventHandler("onPlayerConnect", root, function(playerNick)
	if pregFind(playerNick, "#\w{6}", "i") then
		cancelEvent(true, "Colorcodes sind nicht erlaubt!");
	end
end, true, "high")

addEvent("RegisterLogin.checkAccount",true)
addEventHandler("RegisterLogin.checkAccount",root,function()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Username = '"..getPlayerName(client).."'"),-1);
	if(#result == 0)then typ = "Registrieren" else typ = "Einloggen" end
	triggerClientEvent(client,"RegisterLogin.createWindow",client,typ);
end)

addEvent("RegisterLogin.server",true)
addEventHandler("RegisterLogin.server",root,function(type,password)
	local password = password;
	if(type == "Registrieren")then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Serial = '"..getPlayerSerial(client).."'"),-1);
		if(#result == 0)then
			infobox(client,"Du hast dich erfolgreich registriert.",0,120,0);
			dbExec(handler,"INSERT INTO userdata (Username,Passwort,Serial) VALUES ('"..getPlayerName(client).."','"..md5(password).."','"..getPlayerSerial(client).."')");
			dbExec(handler,"INSERT INTO waffenbox (Username) VALUES ('"..getPlayerName(client).."')");
			setDatasAfterLogin(client);
			setElementData(client, "Skin", 78)
			setElementModel(client, "Skin", 78)
			setPlayerTelefonnummer(client);
			triggerClientEvent(client,"Tutorial.start",client);
		else infobox(client,"Du hast bereits einen Account bei uns!",120,0,0)end
	else
		local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Username = '"..getPlayerName(client).."'"),-1);

		local res = result[1]
		
		
		local salt, sha;
		
		if res["Password_256"] == "" then
			if res["Passwort"] == md5(password) then
				salt = md5(getTickCount())
				sha = sha256(password .. salt)
				dbExec(handler,"UPDATE userdata SET Password_256 = ?, Salt = ?, Passwort = ? WHERE Username = ?", sha, salt, "invalid", getPlayerName(client))
				outputChatBox("Dein Passwort wurde angepasst.", client, 0, 125, 0 )
			else
				infobox(client,"Das angegebene Passwort ist nicht korrekt!",120,0,0)
				return
			end
		else
			salt = res["Salt"]
			sha = res["Password_256"]
		end

		if(#result >= 1 and sha256(password .. salt) == sha) then
			infobox(client,"Du hast dich erfolgreich eingeloggt.",0,120,0);
			setDatasAfterLogin(client);
		else infobox(client,"Das angegebene Passwort ist nicht korrekt!",120,0,0)end
	end
end)

function changePasswordFunc(player, cmd, passwordConfirm, password)
	if cmd == "apwchange" and passwordConfirm then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Username = '"..passwordConfirm.."'"),-1);
		if #result > 0 then
			local res = result[1]
			if getElementData(player,"Adminlevel") >= tonumber(res["Adminlevel"]) then
				local rndpassword = "xtm" .. math.random(1111,9999)
				local salt = md5(getTickCount())
				local sha = sha256(rndpassword .. salt)	
				dbExec(handler,"UPDATE userdata SET Password_256 = ?, Salt = ? WHERE Username = ?", sha, salt, passwordConfirm)
				player:sendMessage("#FFFFFFDas Passwort wurde zu #FF0000%s#FFFFFF geändert.", 255, 255, 255, rndpassword)					
			end
		end		
	elseif cmd == "pwchange" and password and passwordConfirm then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Username = '"..getPlayerName(player).."'"),-1);
		
		local salt = result[1]["Salt"]
		local sha = result[1]["Password_256"]
		
		if not ( sha256(passwordConfirm .. salt) == sha ) then
			player:sendMessage("Passwortbestätigung nicht korrekt!", 255, 0, 0)
			return
		end
		
		if getElementData(player, "loggedin") == 1 and password:len() > 5 then
			local salt = md5(getTickCount())
			local sha = sha256(password .. salt)			
			dbExec(handler,"UPDATE userdata SET Password_256 = ?, Salt = ? WHERE Username = ?", sha, salt, getPlayerName(player))
			outputChatBox("Dein Passwort wurde angepasst.", player, 0, 255, 0 )	
		else
			player:sendMessage("Dein Passwort muss mindestens 6 Zeichen betragen!", 255, 0, 0)
		end	
	elseif cmd == "pwchange" then
		player:sendMessage("Syntax: /pwchange <altesPasswort> <neuesPasswort>", 255, 0, 0)
	end
end
addCommandHandler("pwchange", changePasswordFunc)
addCommandHandler("apwchange", changePasswordFunc)



function setDatasAfterLogin(player)
	if getElementData(player,"loggedin") == 1 then return end
	local data = getAllPlayerData("userdata", "Username", player:getName());
	player:setId(data.ID)
	player:xtremePastLogin()
	player:triggerEvent("RP:Client:OnPastLogin")
	for _,v in pairs(Datas)do
		setElementData(player, v, data[v]);
	end
	
	if (getElementData(player, "vanish") > 0) then
		outputChatBox("ACHTUNG! Du bist noch im Vanish!", player, 190, 0, 0)
	end

	player:setData("lastLogin", getRealTime()["timestamp"])
	checkOfflineMSGs(player)
	triggerClientEvent(player,"RegisterLogin.destroy",player);
	setCameraTarget(player);
	if player:getData("Krankenhaus") > 0 then
		fadeCamera(player, true);
		putPlayerInHospital(player, player:getData("Krankenhaus"));
	else
		newSpawnPlayer(player);
	end
	setElementData(player,"loggedin",1);
	setElementFrozen(player,false);
	
	--[[setTimer(function(player)

	end,50,1,player)]]
	
	toggleAllControls(player,true);
	setPlayerTeam(player,xtmTeam);
	Bergarbeiter.setDatas(player);
	loadGangwarAnzeige(player);
	Fabrikwar.loadBlips(player);
	setElementData(player, "call", "none")
    setElementData(player, "callWith", "none")
    setElementData(player, "caller", "none")
	setElementData(player, "Handystatus", "on")
	setElementData(player, "AFK", false)
	player.LastPosition = player:getPosition()
	player.AfkCounter = 0

	PaydayTimer[player] = setTimer(function(player)
		if(isElement(player))then
			local currentPosition = player:getPosition()

			if (currentPosition-player.LastPosition):getLength() < 0.3 and getElementData(player,"Knastzeit") == 0 then
				player.AfkCounter = math.min( player.AfkCounter + 1, 5)
				
				if player.AfkCounter == 5 then
					player:sendNotification("[AFK-System] Du bist nun AFK.", 120, 0, 0, player.AfkCounter)
					setElementData(player, "AFK", true)
				elseif player.AfkCounter >= 5 then
					setElementData(player, "AFK", true)
				end
			else
				player.AfkCounter = 0
				setElementData(player,"AFK", false)
			end

			player.LastPosition = currentPosition

			if not getElementData(player,"AFK", true) then
				setElementData(player,"Spielstunden",getElementData(player,"Spielstunden")+1);
			end
			if getElementData(player,"Knastzeit") > 0 then
				setElementData(player,"Knastzeit", getElementData(player,"Knastzeit") - 1)
				if getElementData(player,"Knastzeit") <= 0 then
					freeFromJail(player);
				end
			end
			if(math.floor(getElementData(player,"Spielstunden")/60) == (getElementData(player,"Spielstunden")/60)) and not getElementData(player,"AFK") then
				local Fraktionsgehalt = (getElementData(player,"Rang")+1)*500;
				local Zinsen = math.floor(getElementData(player,"Bankgeld")*0.005);
				if(Zinsen > 5000)then Zinsen = 5000 end
				local Fahrzeuge = 0;
				if(not(Autohaus.vehicles[getPlayerName(player)]))then
					Autohaus.vehicles[getPlayerName(player)] = {};
				end
				for i = 1,10 do
					if(isElement(Autohaus.vehicles[getPlayerName(player)][i]))then
						Fahrzeuge = Fahrzeuge + 1;
					end
					if(not(isElement(Autohaus.vehicles[getPlayerName(player)][i])))then break end
				end
				local Fahrzeugsteuern = Fahrzeuge*50;
				local Miete = 0;
				local result = dbPoll(dbQuery(handler,"SELECT * FROM houses"),-1);
				if(#result >= 1)then
					for _,v in pairs(result)do
						if(isMieter(player,v["ID"]))then
							Miete = Miete + getPlayerData("houses","ID",v["ID"],"Mietpreis");
							dbExec(handler,"UPDATE houses SET Hauskasse = '"..getPlayerData("houses","ID",v["ID"],"Hauskasse") + Miete.."' WHERE ID = '"..v["ID"].."'");
						end
					end
				end
				local Bonus = player:getBonus();
				if(Flaggenjagd.hasFactionFlag(player))then Bonus = Bonus + 750 end
				local Gesamteinnahmen = Fraktionsgehalt + Zinsen + Bonus + Miete;
				local Ausgaben = Fahrzeugsteuern + Miete;
				outputChatBox("Payday",player,0,125,0);
				outputChatBox("Fraktionsgehalt: "..Fraktionsgehalt.."€",player,0,125,0);
				outputChatBox("Zinsen: "..Zinsen.."€, Miete: "..Miete.."€",player,0,125,0);
				outputChatBox("Fahrzeugsteuern: "..Fahrzeugsteuern.."€",player,0,125,0);
				outputChatBox("Bonus: "..Bonus.."€",player,0,125,0);
				outputChatBox("",player,100,0,0);
				outputChatBox("Gesamteinnahmen: "..Gesamteinnahmen.."€, Ausgaben: "..Ausgaben.."€",player,0,125,0);
				
				setElementData(player,"Wanteds", math.max(0, getElementData(player,"Wanteds")-1))

				setElementData(player,"Bankgeld",getElementData(player,"Bankgeld")+Gesamteinnahmen);
				setElementData(player,"Bankgeld",getElementData(player,"Bankgeld")-Ausgaben);
				Levelsystem.givePoints(player,500);
				if(getElementData(player,"Bankgeld") < 0)then setElementData(player,"Bankgeld",0) end
				player:setData("Bonus", 0);
			end
		end
	end,60000,0,player)
	local frac = getElementData(player, "Fraktion")
	local rang = getElementData(player, "Rang")
	if not frac == 0 or not frac == 1 or not frac == 2 or not frac == 3 or not frac == 4 or not frac == 9 then
		setElementModel(player, getElementData(player, "Skin"))
		giveFactionSkin(player);
	else
		setElementModel(player, getElementData(player, "Skin"))
	end
	
	triggerEvent("loginSuccess", root, player)
	triggerClientEvent(player,"loginSuccess", player)
end
addEvent("loginSuccess", true)

function savePlayerDatas(player)
	if(getElementData(player,"loggedin") == 1)then
		for _,v in pairs(Datas)do
			dbExec(handler,"UPDATE userdata SET "..v.." = '"..getElementData(player,v).."' WHERE Username = '"..getPlayerName(player).."'");
		end
	end
end

function savePlayerData(player, data)
	if (getElementData(player,"loggedin") == 1) then
		dbExec(handler,"UPDATE userdata SET "..data.." = '"..getElementData(player,data).."' WHERE Username = '"..getPlayerName(player).."'");
	end
end

addEventHandler("onPlayerQuit",root,function()
	savePlayerDatas(source);
	if(isTimer(PaydayTimer[source]))then
		killTimer(PaydayTimer[source]);
	end
end)

addEventHandler("onResourceStop", resourceRoot,
	function ()
		for key, value in ipairs(getElementsByType("player")) do
			savePlayerDatas(value)
		end
	end
)

function newSpawnPlayer(player)
	local data = getAllPlayerData("userdata", "Username", player:getName());
	local x,y,z,rot,int,dim = data.Spawnx, data.Spawny, data.Spawnz, data.Spawnrotz, data.Spawnint, data.Spawndim;
	spawnPlayer(player,x,y,z,rot,getElementData(player,"Skin"),int,dim);
	setElementModel(player, getElementData(player, "Skin"))
	setPedHeadless(player, false)
	putPlayerInJail(player);
	setCameraTarget(player);
	giveMuskelnAndFett(player);
	setElementAlpha(player, 150)
	setTimer ( function()
		setElementAlpha(player, 255)
	end, 5000, 1 )
end
addEvent("newSpawnPlayer",true)
addEventHandler("newSpawnPlayer",root,newSpawnPlayer)

function setPlayerTelefonnummer(player)
	local nr = math.random(100000,999999);
	local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Telefonnummer = '"..nr.."'"),-1);
	if(#result == 0)then
		setElementData(player,"Telefonnummer",nr);
	else setPlayerTelefonnummer(player)end
end

addCommandHandler("changelanguage",
	function (player)
		setElementData(player,"Language", getElementData(player,"Language") == "DE" and "EN" or "DE")
		player:sendNotification("LAN_CHANGE", 0, 120, 0)
	end
)


function checkForRestart ()
	local time = getRealTime()
	
	if time.hour == 5 and time.minute == 53 then
		outputChatBox("Serverrestart in 5 Minuten!", root, 125, 0, 0)
		outputChatBox("Dieser ist um 6 Uhr abgeschlossen!", root, 125, 0, 0)
	elseif time.hour == 5 and time.minute == 58 then
		setServerPassword("xtmrestart")
		for key, player in ipairs(getElementsByType("player")) do
			setTimer(kickPlayer,350*tonumber(key),1,player,"Serverrestart!")
		end
	elseif time.hour == 6 and time.minute == 00 then
		 restartResource ( getThisResource() )
		 setServerPassword(nil)
		--checkPlayerActivity ()
	end
end
setTimer(checkForRestart,60000,0)