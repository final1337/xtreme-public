--

-- [[ TABLES ]] --

Fraktionspanel = {};

fraktionskassen = {}

 
-- [[ FRAKTIONSKASSEN ]]

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(handler,"SELECT * FROM fraktionskasse")
		local result = dbPoll(query, -1)

		for key, value in ipairs(result) do
			fraktionskassen[tonumber(value["Fraktion"])] = tonumber(value["Betrag"])
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function ()
		Fraktionspanel.saveFactionCash()
	end
)

function Fraktionspanel.saveFactionCash()
	for key, value in pairs(fraktionskassen) do
		if not DEVEL then
			dbExec(handler, "UPDATE fraktionskasse SET Betrag = ? WHERE Fraktion = ?", value, key)
		end
	end
end
Timer(Fraktionspanel.saveFactionCash, 1000*60*3, 0)

-- [[ REFRESH MEMBERLISTE ]] --

function Fraktionspanel.refreshMemberlist(player)
	local tbl = {};
	local gridlistItems = {"Spieler","Rang"};
	local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Fraktion = '"..getElementData(player,"Fraktion").."' ORDER BY Rang DESC"),-1);
	if(#result >= 1)then
		for _,v in pairs(result)do
			table.insert(tbl,{
				Name = v["Username"],
				Rang = v["Rang"],
				Warns = v["Warns"]
			});
		end
		triggerClientEvent(player,"Fraktionspanel.refreshMemberlist",player,tbl);
	end
end

-- [[ GELD ABFRAGEN ]] --

function Fraktionspanel.getCash(player)
	--local cash = getPlayerData("fraktionskasse","Fraktion",getElementData(player,"Fraktion"),"Betrag");
	local cash = fraktionskassen[getElementData(player,"Fraktion")]
	triggerClientEvent(player,"Fraktionspanel.updateKasse",player,cash);
end

-- [[ GET DATAS ]] --

addEvent("Fraktionspanel.getDatas",true)
addEventHandler("Fraktionspanel.getDatas",root,function()
	Fraktionspanel.refreshMemberlist(client);
	Fraktionspanel.getCash(client);
end)

-- [[ INVITEN ]] --

function Fraktionspanel.invite(target)
	if(getElementData(client,"Fraktion") >= 1 and getElementData(client,"Rang") >= 5)then
		local target = getPlayerFromName(target);
		if(isElement(target) and getElementData(target,"loggedin") == 1)then
			if(getElementData(target,"Fraktion") == 0)then
				setElementData(target,"Fraktion",getElementData(client,"Fraktion"));
				setElementData(target,"Rang",0);
				giveFactionSkin(target);
				infobox(client,"Du hast "..getPlayerName(target).." in deine Fraktion invitet.",0,120,0);
				infobox(target,getPlayerName(client).." hat dich in seine Fraktion invitet.",0,120,0);
				dbExec(handler,"UPDATE userdata SET Fraktion = '"..getElementData(client,"Fraktion").."' WHERE Username = '"..getPlayerName(target).."'");
				Fraktionspanel.refreshMemberlist(client);
			else infobox(client,"Der Spieler ist bereits in einer Fraktion!",120,0,0)end
		else infobox(client,"Der Spieler wurde nicht gefunden oder ist nicht eingeloggt!",120,0,0)end
	else infobox(client,"Du bist nicht befugt, diese Funktion zu nutzen!",120,0,0)end
end
addEvent("Fraktionspanel.invite",true)
addEventHandler("Fraktionspanel.invite",root,Fraktionspanel.invite)

-- [[ UNINVITEN ]] --

function Fraktionspanel.uninvite(target)
	if(getElementData(client,"Rang") >= 5)then
		local targetName = getPlayerFromName(target);
		if(isElement(targetName) and getElementData(targetName,"loggedin") == 1)then
			if(getElementData(targetName,"Fraktion") == getElementData(client,"Fraktion"))then
				setElementData(targetName,"Fraktion",0);
				setElementData(targetName,"Rang",0);
				infobox(client,"Du hast "..getPlayerName(targetName).." aus deiner Fraktion uninvitet.",0,120,0);
				infobox(targetName,getPlayerName(client).." hat dich aus seiner Fraktion uninvitet!",120,0,0);
				dbExec(handler,"UPDATE userdata SET Fraktion = '"..getElementData(client,"Fraktion").."' WHERE Username = '"..getPlayerName(targetName).."'");
				Fraktionspanel.refreshMemberlist(client);
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		else
			local faction = getPlayerData("userdata","Username",target,"Fraktion");
			if(faction == getElementData(client,"Fraktion"))then
				dbExec(handler,"UPDATE userdata SET Fraktion = '0', Rang = '0' WHERE Username = '"..target.."'");
				infobox(client,"Du hast "..target.." aus deiner Fraktion uninvitet!",120,0,0);
				offlineMessage(target,getPlayerName(client).." hat dich aus seiner Fraktion uninvitet!");
				Fraktionspanel.refreshMemberlist(client);
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		end
	else infobox(client,"Du bist nicht befugt, diese Funktion zu nutzen!",120,0,0)end
end
addEvent("Fraktionspanel.uninvite",true)
addEventHandler("Fraktionspanel.uninvite",root,Fraktionspanel.uninvite)

-- [[ RANG UP ]] --

function Fraktionspanel.rangUp(target)
	if(getElementData(client,"Rang") >= 5)then
		local targetName = getPlayerFromName(target);
		if(isElement(targetName) and getElementData(targetName,"loggedin") == 1)then
			if(getElementData(targetName,"Fraktion") == getElementData(client,"Fraktion"))then
				if(getElementData(targetName,"Rang") < 4)then
					setElementData(targetName,"Rang",getElementData(targetName,"Rang")+1);
					giveFactionSkin(targetName)
					infobox(client,"Du hast "..getPlayerName(targetName).." befördert.",0,120,0);
					infobox(targetName,getPlayerName(client).." hat dich befördert.",0,120,0);
					dbExec(handler,"UPDATE userdata SET Rang = '"..getElementData(targetName,"Rang").."' WHERE Username = '"..getPlayerName(targetName).."'");
					Fraktionspanel.refreshMemberlist(client);
				else infobox(client,"Der Spieler kann nicht mehr befördert werden!",120,0,0)end
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		else
			local faction = getPlayerData("userdata","Username",target,"Fraktion");
			local rang = getPlayerData("userdata","Username",target,"Rang");
			if(faction == getElementData(client,"Fraktion"))then
				if(rang < 4)then
					dbExec(handler,"UPDATE userdata SET Rang = '"..(rang+1).."' WHERE Username = '"..target.."'");
					infobox(client,"Du hast "..target.." befördert.",0,120,0);
					offlineMessage(target,getPlayerName(client).." hat dich befördert.");
					Fraktionspanel.refreshMemberlist(client);
				else infobox(client,"Der Spieler kann nicht mehr befördert werden!",120,0,0)end
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		end
	else infobox(client,"Du bist nicht befugt, diese Funktion zu nutzen!",120,0,0)end
end
addEvent("Fraktionspanel.rangUp",true)
addEventHandler("Fraktionspanel.rangUp",root,Fraktionspanel.rangUp)

-- [[ RANG DOWN ]] --

function Fraktionspanel.rangDown(target)
	if(getElementData(client,"Rang") >= 5)then
		local targetName = getPlayerFromName(target);
		if(isElement(targetName) and getElementData(targetName,"loggedin") == 1)then
			if(getElementData(targetName,"Fraktion") == getElementData(client,"Fraktion"))then
				if(getElementData(targetName,"Rang") > 0)then
					setElementData(targetName,"Rang",getElementData(targetName,"Rang")-1);
					infobox(client,"Du hast "..getPlayerName(targetName).." degradiert.",0,120,0);
					infobox(targetName,getPlayerName(client).." hat dich degradiert!",120,0,0);
					giveFactionSkin(targetName)
					dbExec(handler,"UPDATE userdata SET Rang = '"..getElementData(targetName,"Rang").."' WHERE Username = '"..getPlayerName(targetName).."'");
					Fraktionspanel.refreshMemberlist(client);
				else infobox(client,"Der Spieler kann nicht mehr degradiert werden!",120,0,0)end
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		else
			local faction = getPlayerData("userdata","Username",target,"Fraktion");
			local rang = getPlayerData("userdata","Username",target,"Rang");
			if(faction == getElementData(client,"Fraktion"))then
				if(rang > 0)then
					dbExec(handler,"UPDATE userdata SET Rang = '"..(rang-1).."' WHERE Username = '"..target.."'");
					infobox(client,"Du hast "..target.." degradiert.",0,120,0);
					offlineMessage(target,getPlayerName(client).." hat dich degradiert!");
					Fraktionspanel.refreshMemberlist(client);
				else infobox(client,"Der Spieler kann nicht mehr degradiert werden!",120,0,0)end
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		end
	else infobox(client,"Du bist nicht befugt, diese Funktion zu nutzen!",120,0,0)end
end
addEvent("Fraktionspanel.rangDown",true)
addEventHandler("Fraktionspanel.rangDown",root,Fraktionspanel.rangDown)

-- [[ WARN GEBEN ]] --

function Fraktionspanel.giveWarn(target)
	if(getElementData(client,"Rang") >= 4)then
		local targetName = getPlayerFromName(target);
		if(isElement(target) and getElementData(targetName,"loggedin") == 1)then
			if(getElementData(targetName,"Fraktion") == getElementData(client,"Fraktion"))then
				setElementData(targetName,"Warns",getElementData(targetName,"Warns")+1);
				infobox(client,"Du hast "..getPlayerName(targetName).." verwarnt!",0,120,0);
				infobox(targetName,getPlayerName(client).." hat dich verwarnt!",120,0,0);
				if(getElementData(targetName,"Warns") >= 3)then
					infobox(targetName,"Du wurdest aufgrund von drei Warns uninvitet!",120,0,0);
					setElementData(targetName,"Fraktion",0);
					setElementData(targetName,"Rang",0);
				end
				dbExec(handler,"UPDATE userdata SET Warns = '"..getElementData(targetName,"Warns").."', Fraktion = '"..getElementData(targetName,"Fraktion").."', Rang = '"..getElementData(targetName,"Rang").."' WHERE Username = '"..getPlayerName(targetName).."'");
				Fraktionspanel.refreshMemberlist(client);
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		else
			local faction = getPlayerData("userdata","Username",target,"Fraktion");
			local warns = getPlayerData("userdata","Username",target,"Warns");
			if(faction == getElementData(client,"Fraktion"))then
				dbExec(handler,"UPDATE userdata SET Warns = '"..(warns+1).."' WHERE Username = '"..target.."'");
				infobox(client,"Du hast "..target.." verwarnt.",0,120,0);
				offlineMessage(target,getPlayerName(client).." hat dich verwarnt!");
				if(warns+1 >= 3)then
					offlineMessage("Du wurdest aufgrund von drei Warns uninvitet!");
					dbExec(handler,"UPDATE userdata SET Fraktion = '0', Rang = '0' WHERE Username = '"..target.."'");
				end
				Fraktionspanel.refreshMemberlist(client);
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		end
	else infobox(client,"Du bist nicht befugt, diese Funktion zu nutzen!",120,0,0)end
end
addEvent("Fraktionspanel.giveWarn",true)
addEventHandler("Fraktionspanel.giveWarn",root,Fraktionspanel.giveWarn)

-- [[ WARN ENTFERNEN ]] --

function Fraktionspanel.deleteWarn(target)
	if(getElementData(client,"Rang") >= 4)then
		local targetName = getPlayerFromName(target);
		if(isElement(targetName) and getElementData(targetName,"loggedin") == 1)then
			if(getElementData(targetName,"Fraktion") == getElementData(client,"Fraktion"))then
				if(getElementData(targetName,"Warns") >= 1)then
					setElementData(targetName,"Warns",getElementData(targetName,"Warns")-1);
					infobox(client,"Du hast "..getPlayerName(targetName).." einen Warn entfernt.",0,120,0);
					infobox(targetName,getPlayerName(client).." hat dir einen Warn entfernt.",0,120,0);
					dbExec(handler,"UPDATE userdata SET Warns = '"..getElementData(targetName,"Warns").."' WHERE Username = '"..getPlayerName(targetName).."'");
					Fraktionspanel.refreshMemberlist(client);
				else infobox(client,"Der Spieler hat keine Warns!",120,0,0)end
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		else
			local faction = getPlayerData("userdata","Username",target,"Fraktion");
			local warns = getPlayerData("userdata","Username",target,"Warns");
			if(faction == getElementData(client,"Fraktion"))then
				if(warns >= 1)then
					dbExec(handler,"UPDATE userdata SET Warns = '"..(warns-1).."' WHERE Username = '"..target.."'");
					infobox(client,"Du hast "..target.." verwarnt.",0,120,0);
					offlineMessage(target,getPlayerName(client).." hat dir eine Verwarnung gelöscht!");
					Fraktionspanel.refreshMemberlist(client);
				else infobox(client,"Der Spieler hat keine Warns!",120,0,0)end
			else infobox(client,"Der Spieler ist nicht mehr in deiner Fraktion!",120,0,0)end
		end
	else infobox(client,"Du bist nicht befugt, diese Funktion zu nutzen!",120,0,0)end
end
addEvent("Fraktionspanel.deleteWarn",true)
addEventHandler("Fraktionspanel.deleteWarn",root,Fraktionspanel.deleteWarn)

-- [[ FRAKTIONSKASSE ]] --

function Fraktionspanel.einzahlen(summe)
	local summe = math.abs(tonumber(summe));
	local kasse = fraktionskassen[getElementData(client,"Fraktion")]
	-- local kasse = getPlayerData("fraktionskasse","Fraktion",getElementData(client,"Fraktion"),"Betrag");
	if(getElementData(client,"Geld") >= summe)then
		local newMoney = kasse + summe;
		setElementData(client,"Geld",getElementData(client,"Geld")-summe);
		fraktionskassen[getElementData(client,"Fraktion")] = newMoney
		frakEinzahlenLog:write(client:getName(), summe, getElementData(client,"Fraktion"), newMoney)
		outputSpy("faction", "[%s] %s hat %d€ eingezahlt!", Fraktionen["Namen"][client:getData("Fraktion")], client, summe)
		--dbExec(handler,"UPDATE fraktionskasse SET Betrag = '"..newMoney.."' WHERE Fraktion = '"..getElementData(client,"Fraktion").."'");
		triggerClientEvent(client,"Fraktionspanel.updateKasse",client,newMoney);
		infobox(client,"Du hast "..summe.."€ eingezahlt.",0,120,0);
	else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
end
addEvent("Fraktionspanel.einzahlen",true)
addEventHandler("Fraktionspanel.einzahlen",root,Fraktionspanel.einzahlen)

function Fraktionspanel.auszahlen(summe)
	local summe = math.abs(tonumber(summe));
	local kasse = fraktionskassen[getElementData(client,"Fraktion")]
	-- local kasse = getPlayerData("fraktionskasse","Fraktion",getElementData(client,"Fraktion"),"Betrag");
	if(getElementData(client,"Rang") >= 4)then
		if(kasse >= summe)then
			local newMoney = kasse - summe;
			setElementData(client,"Geld",getElementData(client,"Geld")+summe);
			fraktionskassen[getElementData(client,"Fraktion")] = newMoney
			frakAbhebenLog:write(client:getName(), summe, getElementData(client,"Fraktion"), newMoney)
			outputSpy("faction", "[%s] %s hat %d€ ausgezahlt!", Fraktionen["Namen"][client:getData("Fraktion")], client, summe)
			--dbExec(handler,"UPDATE fraktionskasse SET Betrag = '"..newMoney.."' WHERE Fraktion = '"..getElementData(client,"Fraktion").."'");
			triggerClientEvent(client,"Fraktionspanel.updateKasse",client,newMoney);
			infobox(client,"Du hast "..summe.."€ ausgezahlt.",0,120,0);
		else infobox(client,"In der Kasse befindet sich nicht genug Geld!",120,0,0)end
	else infobox(client,"Du bist nicht befugt, Geld auszuzahlen!",120,0,0)end
end
addEvent("Fraktionspanel.auszahlen",true)
addEventHandler("Fraktionspanel.auszahlen",root,Fraktionspanel.auszahlen)


--[[ WANTED-VERGABE ]]

function Fraktionspanel.Event_GiveWanteds(target, amount, reason)
	if not client then return end
	Fraktionspanel.giveWanteds(client, target, amount, reason)
end
addEvent("RP:Server:Fraktionspanel:giveWanteds", true)
addEventHandler("RP:Server:Fraktionspanel:giveWanteds", root, Fraktionspanel.Event_GiveWanteds)


Fraktionspanel.StateFactions = {
	[1] = true,
	[2] = true,
	[3] = true,
}

function Fraktionspanel.giveWanteds(player, target, amount, reason)
	if target and amount and reason then
		local targetPlayer = getPlayerFromName(target)
		local amount = tonumber(amount)
		if targetPlayer and isElement(targetPlayer) then
			setElementData(targetPlayer, "Wanteds", math.max( 0, math.min(12, getElementData(targetPlayer, "Wanteds") + amount)))
			targetPlayer:sendMessage("Dein Wantedlevel wurde auf %d(%s%d) von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"Wanteds"), amount >= 0 and "+" or "",amount, player:getName(), reason)
			targetPlayer:sendNotification("Dein Wantedlevel wurde auf %d(%s%d) von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"Wanteds"), amount >= 0 and "+" or "",amount, player:getName(), reason)

			for key, value in ipairs(getElementsByType("player")) do
				if Fraktionspanel.StateFactions[getElementData(value,"Fraktion")] then
					value:sendMessage("%s hat das Wantedlevel von %s auf %d(%s%d) gesetzt. Grund: %s", 255, 255, 0, player:getName(), target, getElementData(targetPlayer,"Wanteds"), amount >= 0 and "+" or "",amount, reason)
				end
			end
		end
	end
end

function Fraktionspanel.Event_DeleteWanteds(target, amount, reason)
	if not client then return end
	Fraktionspanel.deleteWanteds(client, target, amount, reason)
end
addEvent("RP:Server:Fraktionspanel:deleteWanteds", true)
addEventHandler("RP:Server:Fraktionspanel:deleteWanteds", root, Fraktionspanel.Event_DeleteWanteds)

function Fraktionspanel.deleteWanteds(player, target, amount, reason)
	if target then
		local targetPlayer = getPlayerFromName(target)
		if targetPlayer and isElement(targetPlayer) then
			setElementData(targetPlayer, "Wanteds", 0)
			targetPlayer:sendMessage("Deine Wanteds wurden auf %d von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"Wanteds"), player:getName(), "Gelöscht")
			targetPlayer:sendNotification("Deine Wanteds wurden auf %d von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"Wanteds"), player:getName(), "Gelöscht")

			for key, value in ipairs(getElementsByType("player")) do
				if Fraktionspanel.StateFactions[getElementData(value,"Fraktion")] then
					value:sendMessage("%s hat die Wanteds von %s auf %d gesetzt. Grund: %s", 255, 255, 0, player:getName(), target, getElementData(targetPlayer,"Wanteds"), "Gelöscht")
				end
			end
		end		
	end
end

--[[STVO-VERGABE]]

function Fraktionspanel.Event_GiveSTVO(target, amount, reason)
	if not client then return end
	Fraktionspanel.giveSTVO(client, target, amount, reason)
end
addEvent("RP:Server:Fraktionspanel:giveSTVO", true)
addEventHandler("RP:Server:Fraktionspanel:giveSTVO", root, Fraktionspanel.Event_GiveSTVO)

function Fraktionspanel.giveSTVO(player, target, amount, reason)
	if target and amount and reason then
		local targetPlayer = getPlayerFromName(target)
		local amount = tonumber(amount)
		if targetPlayer and isElement(targetPlayer) then
			setElementData(targetPlayer, "STVO", math.max(0, math.min(15, getElementData(targetPlayer, "STVO") + amount)))
			targetPlayer:sendMessage("Deine STVO-Punkte wurden auf %d(%s%d) von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"STVO"), amount >= 0 and "+" or "", amount, player:getName(), reason)
			targetPlayer:sendNotification("Deine STVO-Punkte wurden auf %d(%s%d) von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"STVO"), amount >= 0 and "+" or "", amount, player:getName(), reason)

			for key, value in ipairs(getElementsByType("player")) do
				if Fraktionspanel.StateFactions[getElementData(value,"Fraktion")] then
					value:sendMessage("%s hat die STVO-Punkte von %s auf %d(%s%d) gesetzt. Grund: %s", 255, 255, 0, player:getName(), target, getElementData(targetPlayer,"STVO"), amount >= 0 and "+" or "", amount, reason)
				end
			end
		end
	end
end

function Fraktionspanel.Event_DeleteSTVO(target, amount, reason)
	if not client then return end
	Fraktionspanel.deleteSTVO(client, target, amount, reason)
end
addEvent("RP:Server:Fraktionspanel:deleteSTVO", true)
addEventHandler("RP:Server:Fraktionspanel:deleteSTVO", root, Fraktionspanel.Event_DeleteSTVO)

function Fraktionspanel.deleteSTVO(player, target, amount, reason)
	if target then
		local targetPlayer = getPlayerFromName(target)
		if targetPlayer and isElement(targetPlayer) then
			setElementData(targetPlayer, "STVO", 0)
			targetPlayer:sendMessage("Deine STVO-Punkte wurden auf %d von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"STVO"), player:getName(), "Gelöscht")
			targetPlayer:sendNotification("Deine STVO-Punkte wurden auf %d von %s gesetzt. Grund: %s", 255, 255, 0, getElementData(targetPlayer,"STVO"), player:getName(), "Gelöscht")
			

			for key, value in ipairs(getElementsByType("player")) do
				if Fraktionspanel.StateFactions[getElementData(value,"Fraktion")] then
					value:sendMessage("%s hat die STVO-Punkte von %s auf %d gesetzt. Grund: %s", 255, 255, 0, player:getName(), target, getElementData(targetPlayer,"STVO"), "Gelöscht")
				end
			end
		end		
	end
end