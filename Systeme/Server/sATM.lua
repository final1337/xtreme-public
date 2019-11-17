--

-- [[ TABLES ]] --

ATM = {
	["Marker"] = { -- x,y,z,int,dim
		{-2189.1416015625,-209.056640625,35.530200958252,0,0},
		{-2379.908203125,1553.4794921875,1.1172000169754,0,0},
		{957.17449951172,-48.75,1000.0941772461,3,0},
		{-221.28880310059,1406.9645996094,26.760400772095,18,0},
		{-2019.9267578125,-101.4560546875,34.162101745605,0,0},
		{-1981.2379150391,154.3630065918,26.676500320435,0,0},
		{2133.32421875,-1150.7303466797,23.16780090332,0,0},
		{191.35319519043,-235.66700744629,0.58609998226166,0,0},
		{-1970.3330078125,308.75680541992,34.144901275635,0,0},
		{-1641.5662841797,1208.1096191406,6.1856999397278,0,0},
		{-2764.7770996094,372.19320678711,5.3259000778198,0,0},
		{-2516.7329101563,-624.21337890625,131.79379272461,0,0},
		{1111.849609375,-304.2353515625,73.9421875-1,0,0}, -- Ballas
		{511.23941040039,-74.246398925781,997.75848388672,11,0}, -- Terroristen
		{-1321,492.20001220703,10.199999809265,0,0}, -- Army Base SF
	},
};

-- [[ MARKER ERSTELLEN ]] --

for _,v in pairs(ATM["Marker"])do
	local marker = createMarker(v[1],v[2],v[3]+0.1,"cylinder",1,0,0,200,125);
	setElementInterior(marker,v[4]);
	setElementDimension(marker,v[5]);
	
	addEventHandler("onMarkerHit",marker,function(player)
		if(not(isPedInVehicle(player)) and getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"ATM.createWindow",player);
		end
	end)
end

addEvent("Bank.payOut",true)
addEventHandler("Bank.payOut",root,function(summe)
	local summe = tonumber(summe)
	if(summe > 0)then
		if(getElementData(client,"Bankgeld") >= summe)then
			setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")-summe);
			setElementData(client,"Geld",getElementData(client,"Geld")+summe);
			infobox(client,"Du hast "..summe.."€ ausgezahlt.",0,120,0);
			withdrawLog:write (client.name, summe)
			outputSpy("money", "%s hat %d€ ausgezahlt!", client, summe)
		else
			infobox(client,"Du hast nicht genug Geld auf dem Konto!",120,0,0)
		end
	else
		infobox(client,"Hör auf nach Geldbugs zu suchen!\n- FiNAL",0,120,0);
	end
end)

addEvent("Bank.payIn",true)
addEventHandler("Bank.payIn",root,function(summe)
	local summe = tonumber(summe)
	if(summe > 0)then
		if(getElementData(client,"Geld") >= summe)then
			setElementData(client,"Geld",getElementData(client,"Geld")-summe);
			setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+summe);
			infobox(client,"Du hast "..summe.."€ eingezahlt.",0,120,0);
			depositLog:write(client.name, summe)
			outputSpy("money", "%s hat %d€ eingezahlt!", client, summe)
		else
			infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)
		end
	else
		infobox(client,"Hör auf nach Geldbugs zu suchen!\n- FiNAL",0,120,0);
	end
end)

addEvent("Bank.transfer",true)
addEventHandler("Bank.transfer",root,function(target,summe,reason)
	local summe = tonumber(summe);
	if(summe > 0)then
		if(getElementData(client,"Bankgeld") >= summe)then
			local targetPlayer = getPlayerFromName(target);
			if(isElement(targetPlayer) and getElementData(targetPlayer,"loggedin") == 1)then
				setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")-summe);
				setElementData(targetPlayer,"Bankgeld",getElementData(targetPlayer,"Bankgeld")+summe);
				infobox(client,"Du hast "..target.." "..summe.."€ überwiesen.",0,120,0);
				outputChatBox(getPlayerName(client).." hat dir "..summe.."€ überwiesen. Grund: "..reason,targetPlayer,0,150,0);
				transactionLog:write(client.name, target, summe, reason)
				outputSpy("money", "%s hat %s %d€ überwiesen. Verwendungszweck: %s", client, targetPlayer, summe, reason)
			else
				local result = dbPoll(dbQuery(handler,"SELECT * FROM userdata WHERE Username = '"..target.."'"),-1);
				if(#result >= 1)then
					setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")-summe);
					local newMoney = getPlayerData("userdata","Username",target,"Bankgeld")+summe;
					dbExec(handler,"UPDATE userdata SET Bankgeld = '"..newMoney.."' WHERE Username = '"..target.."'");
					offlineMessage(target,getPlayerName(client).." hat dir "..summe.."€ überwiesen. Grund: "..reason);
					infobox(client,"Du hast "..target.." "..summe.."€ überwiesen.",0,120,0);
					transactionLog:write(client.name, target, summe, reason)
					outputSpy("money", "%s hat %s %d€ überwiesen. Verwendungszweck: %s", client, target, summe, reason)
				else infobox(client,"Der angegebene Spieler existiert nicht!",120,0,0)end
			end
		else infobox(client,"Du hast nicht genug Geld auf dem Konto!",120,0,0)end
	else
		infobox(client,"Hör auf nach Geldbugs zu suchen!\n- FiNAL",0,120,0);
	end
end)