--

Lotto = {};
Lotto.createMarker = createMarker(822.00854492188,4.1270370483398,1004.1796875-1,"cylinder",1.5,214,28,211);
setElementInterior(Lotto.createMarker,3);

function Lotto.getJackpot()
	Lotto.jackpotXTM = "XML/Jackpot.xtm";
	local jackpotfile = fileOpen(Lotto.jackpotXTM);
	local filesize = fileGetSize(jackpotfile);
	Lotto.jackpot = tonumber(fileRead(jackpotfile,filesize));
	fileClose(jackpotfile);
end

addEventHandler("onMarkerHit",Lotto.createMarker,function(player)
	if(not(isPedInVehicle(player)))then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"Lotto.createWindow",player,Lotto.jackpot);
		end
	end
end)

addEvent("Lotto.save",true)
addEventHandler("Lotto.save",root,function(numbers)
	local nr1,nr2,nr3,nr4,nr5 = numbers[1],numbers[2],numbers[3],numbers[4],numbers[5];
	local result = dbPoll(dbQuery(handler,"SELECT * FROM lotto WHERE Username = '"..getPlayerName(client).."'"),-1);
	if(#result == 0)then
		if(getElementData(client,"Geld") >= 3500)then
			Lotto.jackpot = Lotto.jackpot + 2500;
			local file = fileCreate(Lotto.jackpotXTM);
			fileWrite(file,tostring(Lotto.jackpot));
			fileClose(file);
			setElementData(client,"Geld",getElementData(client,"Geld")-3500);
			infobox(client,"Ticket gekauft, die Ziehung findet am Sonntag um 20:00 Uhr statt.",0,120,0);
		else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
	else infobox(client,"Du nimmst bereits an der nächsten Ziehung teil!",120,0,0)end
end)

Lotto.timer = setTimer(function()
	local time = getRealTime();
	if(getDay() == "So")then
		if(time.hour >= 20)then
			killTimer(Lotto.timer);
			local nr1,nr2,nr3,nr4,nr5 = math.random(0,9),math.random(0,9),math.random(0,9),math.random(0,9),math.random(0,9);
			local numberTable = {nr1,nr2,nr3,nr4,nr5};
			local result = dbPoll(dbQuery(handler,"SELECT * FROM lotto"),-1);
			if(#result >= 1)then
				local winner = {};
				for _,v in pairs(result)do
					local id = 0;
					local nummer1,nummer2,nummer3,nummer4,nummer5 = getPlayerData("lotto","Username",v["Username"],"Nr1"),getPlayerData("lotto","Username",v["Username"],"Nr2"),getPlayerData("lotto","Username",v["Username"],"Nr3"),getPlayerData("lotto","Username",v["Username"],"Nr4"),getPlayerData("lotto","Username",v["Username"],"Nr5");
					if(nr1 == nummer1)then id = id + 1 end
					if(nr2 == nummer2)then id = id + 1 end
					if(nr3 == nummer3)then id = id + 1 end
					if(nr4 == nummer4)then id = id + 1 end
					if(nr5 == nummer5)then id = id + 1 end
					if(id == 5)then
						table.insert(winner,v["Username"]);
					end
				end
			end
			outputChatBox("Die Lottozahlen lauten wie folgt:",root,255,140,0);
			local NRID = 0;
			setTimer(function()
				NRID = NRID + 1;
				outputChatBox(numberTable[NRID],root,150,0,20);
				if(NRID == 5)then
					if(winner and #winner >= 1)then
						local gewinn = math.floor(Lotto.jackpot/#winner);
						outputChatBox("Der Jackpot von "..Lotto.jackpot.."€ wurde geknackt!",root,255,140,0);
						outputChatBox("Gewonnen hat/haben:",root,255,135,0);
						for _,v in pairs(winner)do
							local winnerName = getPlayerFromName(v);
							outputChatBox(v,root);
							if(isElement(winnerName) and getElementData(winnerName,"loggedin") == 1)then
								infobox(winnerName,"Du hast "..gewinn.."€ im Lotto gewonnen, das Geld wurd dir auf dein Konto überwiesen.",0,120,0);
								setElementData(winnerName,"Bankgeld",getElementData(winnerName,"Bankgeld")+gewinn);
							else
								local oldMoney = getPlayerData("userdata","Username",v,"Bankgeld");
								dbExec(handler,"UPDATE userdata SET Bankgeld = '"..oldMoney+gewinn.."' WHERE Username = '"..v.."'");
								sendOfflineMessage(v,"Du hast "..gewinn.."€ im Lotto gewonnen, das Geld wurde dir auf dein Konto überwiesen.");
							end
						end
					else
						outputChatBox("Niemand hat gewonnen.",root,255,140,0);
					end
				end
			end,1000,5)
		end
	else
		killTimer(Lotto.timer);
	end
end,60000,0)

Lotto.getJackpot();