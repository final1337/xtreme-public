
Gangwar = {datas = {},
	["Active"] = {
		[5] = false,
		[6] = false,
		[7] = false,
		[8] = false,
		[10] = false,
	},
	["Payday"] = {
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[10] = true,
	},
	["Attacks"] = {
		[5] = 4,
		[6] = 4,
		[7] = 4,
		[8] = 4,
		[10] = 4,
	},
	["Gangwarfahrzeuge"] = {
		
	};
};

function Gangwar.loadAreas()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM gangareas"),-1);
	if(#result >= 1)then
		for _,v in pairs(result)do
			local ID = v["ID"];
			local x1,y1 = tonumber(v["x1"]),tonumber(v["y1"]);
			local x2,y2 = tonumber(v["x2"]),tonumber(v["y2"]);
			local xs,ys = math.abs(x1-x2),math.abs(y1-y2);
			local owner = v["owner"];
			local px,py,pz = tonumber(v["px"]),tonumber(v["py"]),tonumber(v["pz"]);
			local r,g,b = Fraktionen["Farben"][owner][1],Fraktionen["Farben"][owner][2],Fraktionen["Farben"][owner][3];
			
			Gangwar[ID] = createRadarArea(x1,y1,xs,ys,r,g,b,175,root);
			Gangwar.datas[ID] = {
				["Pickup"] = createPickup(px,py,pz,3,1313,50),
				["Owner"] = owner,
				["Blocked"] = false,
				["Colshape"] = createColCuboid(x1,y1,-50,xs,ys,7500),
				["ActiveGangwar"] = false,
				["Started"] = nil,
			};
			
			addEventHandler("onPickupHit",Gangwar.datas[ID]["Pickup"],function(player)
				if(isEvil(player) and not(isPedInVehicle(player)))then
					setElementData(player,"GangwarID",ID);
					if(Gangwar.datas[ID]["ActiveGangwar"] == false)then
						triggerClientEvent(player,"Gangwar.openWindow",player,owner,Fraktionen["Namen"][owner]);
					end
				end
			end)
		end
	end
end
Gangwar.loadAreas()

addEvent("Gangwar.start",true)
addEventHandler("Gangwar.start",root,function()
	if(getElementData(client,"Rang") >= 3)then
		local faction = getElementData(client,"Fraktion");
		if(Gangwar["Active"][faction] == false)then
			local ID = getElementData(client,"GangwarID");
			if(Gangwar["Active"][Gangwar.datas[ID]["Owner"]] == false)then
				if(Gangwar["Attacks"][faction] >= 1)then
					local ID = getElementData(client,"GangwarID");
					local px,py,pz = getElementPosition(Gangwar.datas[ID]["Pickup"]);
					if(getDistanceBetweenPoints3D(px,py,pz,getElementPosition(client)) <= 5)then
						local neededMembers = 0;
						local time = getRealTime();
						if(time.hour >= 18 and time.hour <= 20)then neededMembers = 0 end
						if(getMembersOnline(Gangwar.datas[ID]["Owner"]) >= tonumber(neededMembers))then
							if(Gangwar.datas[ID]["Owner"] ~= getElementData(client,"Fraktion"))then
								if(Gangwar.datas[ID]["Blocked"] == false)then
									local owner = Gangwar.datas[ID]["Owner"];
									Gangwar.datas[ID]["Angreifer"] = getElementData(client,"Fraktion");
									Gangwar.datas[ID]["Verteidiger"] = owner;
									Gangwar.datas[ID]["ActiveGangwar"] = true;
									Gangwar.datas[ID]["Blocked"] = true;
									Gangwar["Active"][faction] = true;
									Gangwar["Active"][owner] = true;
									sendFactionMessage(6,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Angreifer"]].." #ffffffbereiten einen Gangwar gegen die #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Verteidiger"]].." #ffffffvor!",255,0,0);
									sendFactionMessage(7,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Angreifer"]].." #ffffffbereiten einen Gangwar gegen die #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Verteidiger"]].." #ffffffvor!",255,0,0);
									sendFactionMessage(8,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Angreifer"]].." #ffffffbereiten einen Gangwar gegen die #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Verteidiger"]].." #ffffffvor!",255,0,0);
									sendFactionMessage(9,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Angreifer"]].." #ffffffbereiten einen Gangwar gegen die #fa6400"..Fraktionen["Namen"][Gangwar.datas[ID]["Verteidiger"]].." #ffffffvor!",255,0,0);
									Gangwar["Attacks"][faction] = Gangwar["Attacks"][faction] - 1;
									
									local verteidiger = getMembersOnline(Gangwar.datas[ID]["Owner"]);
									if(verteidiger == 0)then vorbereitungszeit = 50 else vorbereitungszeit = 180000 end
									
									for _,v in pairs(Gangwar["Gangwarfahrzeuge"][ID])do
										local r,g,b = Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][1],Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][2],Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][3];
										local veh = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7]);
										setElementData(veh,"GangwarID",ID);
										setVehicleColor(veh,r,g,b);
										setVehicleDamageProof(veh,true);
									end
									triggerClientEvent(client,"dxClassClose",client);
									
									Gangwar.datas[ID]["VorbereitungsZeit"] = setTimer(function(client,ID)
										Gangwar.datas[ID]["Started"] = getTickCount();
										setRadarAreaFlashing(Gangwar[ID],true);
										setRadarAreaColor(Gangwar[ID],0,255,0,175);
										sendFactionMessage(owner,"#fa6400[INFO] #ffffffDie #fa6400"..Gangwar.datas[ID]["Angreifer"].." #ffffffgreifen eines eurer Gebiete an!",125,0,0);
										sendFactionMessage(getElementData(client,"Fraktion"),"#fa6400[INFO] #ffffffIhr habt einen Angriff gegen die #fa6400"..Gangwar.datas[ID]["Verteidiger"].." #ffffffgestartet, haltet die Position 15 Minuten lang, um zu gewinnen!",0,125,0);
										
										for _,v in pairs(getElementsByType("player"))do
											if(isEvil(v))then
												if(getElementData(v,"Fraktion") == Gangwar.datas[ID]["Angreifer"] or getElementData(v,"Fraktion") == Gangwar.datas[ID]["Verteidiger"])then
													local x,y,z = getElementPosition(Gangwar.datas[ID]["Pickup"]);
													setElementData(v,"ImGangwar",true);
													setElementData(v,"ImGangwarGestorben",false);
													setElementData(v,"TemporaerGWDamage",0);
													setElementData(v,"TemporaerGWKills",0);
													setElementData(v,"GangwarID",ID);
													triggerClientEvent(v,"Gangwar.updateDatas",v,Gangwar.datas[ID]["Angreifer"],Gangwar.datas[ID]["Verteidiger"],x,y,z,"create");
												end
											end
										end
										
										Gangwar.datas[ID]["UpdateTimeTimer"] = setTimer(function(ID)
											for _,v in pairs(getElementsByType("player"))do
												if(isEvil(v))then
													if(getElementData(v,"Fraktion") == Gangwar.datas[ID]["Angreifer"] or getElementData(v,"Fraktion") == Gangwar.datas[ID]["Verteidiger"])then
														local OldTick,NewTick = Gangwar.datas[ID]["Started"],getTickCount();
														local time = 900000 + (OldTick - NewTick);
														local gangwarZeit = convertMS(time);
														triggerClientEvent(v,"Gangwar.updateDatasTime",v,gangwarZeit);
													end
												end
											end
											local counter_defender = 0;
											local counter_attacker = 0;
											for _,v in pairs(getElementsByType("player"))do
												if(isEvil(v))then
													if(getElementData(v,"ImGangwar") == true and getElementData(v,"ImGangwarGestorben") ~= true)then
														if(getElementData(v,"Fraktion") == Gangwar.datas[ID]["Verteidiger"])then
															counter_defender = counter_defender + 1;
														elseif(getElementData(v,"Fraktion") == Gangwar.datas[ID]["Angreifer"])then
															counter_attacker = counter_attacker + 1;
														end
													end
												end
											end
											if(counter_defender == 0)then
												for _,v in pairs(getElementsByType("player"))do
													triggerClientEvent(v,"Gangwar.updateDatas",v,nil,nil,nil,nil,nil,"destroy");
													if(isEvil(v) and getElementData(v,"ImGangwar") == true)then
														Gangwar.giveBonus(v);
													end
												end
												sendFactionMessage(Gangwar.datas[ID]["Verteidiger"],"#fa6400[INFO] #ffffffIhr konntet euer Gebiet nicht verteidigen.",125,0,0);
												sendFactionMessage(Gangwar.datas[ID]["Angreifer"],"#fa6400[INFO] #ffffffEuer Angriff war erfolgreich.",0,125,0);
												if(isTimer(Gangwar.datas[ID]["UpdateTimeTimer"]))then killTimer(Gangwar.datas[ID]["UpdateTimeTimer"])end
												if(isTimer(Gangwar.datas[ID]["CheckTimer"]))then killTimer(Gangwar.datas[ID]["CheckTimer"])end
												local r,g,b = Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][1],Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][2],Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][3];
												setRadarAreaFlashing(Gangwar[ID],false);
												setRadarAreaColor(Gangwar[ID],r,g,b,175);
												dbExec(handler,"UPDATE gangareas SET owner = '"..Gangwar.datas[ID]["Angreifer"].."' WHERE ID = '"..ID.."'");
												Gangwar["Active"][Gangwar.datas[ID]["Angreifer"]] = false;
												Gangwar["Active"][Gangwar.datas[ID]["Verteidiger"]] = false;
												Gangwar.datas[ID]["Angreifer"] = false;
												Gangwar.datas[ID]["Verteidiger"] = false;
												Gangwar.datas[ID]["ActiveGangwar"] = false;
												Gangwar.destroyBurritos(ID);
												if(isTimer(Gangwar.datas[ID]["WinTimer"]))then killTimer(Gangwar.datas[ID]["WinTimer"])end
											end
											if(counter_attacker == 0)then
												for _,v in pairs(getElementsByType("player"))do
													triggerClientEvent(v,"Gangwar.updateDatas",v,nil,nil,nil,nil,nil,"destroy");
													if(isEvil(v) and getElementData(v,"ImGangwar") == true)then
														Gangwar.giveBonus(v);
													end
												end
												sendFactionMessage(Gangwar.datas[ID]["Verteidiger"],"#fa6400[INFO] #ffffffIhr konntet euer Gebiet nicht verteidigen.",125,0,0);
												sendFactionMessage(Gangwar.datas[ID]["Angreifer"],"#fa6400[INFO] #ffffffEuer Angriff war erfolgreich.",0,125,0);
												if(isTimer(Gangwar.datas[ID]["CheckTimer"]))then killTimer(Gangwar.datas[ID]["CheckTimer"])end
												if(isTimer(Gangwar.datas[ID]["StopTimer"]))then killTimer(Gangwar.datas[ID]["StopTimer"])end
												if(isTimer(Gangwar.datas[ID]["UpdateTimeTimer"]))then killTimer(Gangwar.datas[ID]["UpdateTimeTimer"])end
												local verteidiger = Gangwar.datas[ID]["Verteidiger"];
												local r,g,b = Fraktionen["Farben"][verteidiger][1],Fraktionen["Farben"][verteidiger][2],Fraktionen["Farben"][verteidiger][3];
												setRadarAreaFlashing(Gangwar[ID],false);
												setRadarAreaColor(Gangwar[ID],r,g,b,175);
												Gangwar["Active"][Gangwar.datas[ID]["Angreifer"]] = false;
												Gangwar["Active"][Gangwar.datas[ID]["Verteidiger"]] = false;
												Gangwar.datas[ID]["Angreifer"] = false;
												Gangwar.datas[ID]["Verteidiger"] = false;
												Gangwar.datas[ID]["ActiveGangwar"] = false;
												if(isTimer(Gangwar.datas[ID]["WinTimer"]))then killTimer(Gangwar.datas[ID]["WinTimer"])end
												Gangwar.destroyBurritos(ID);
											end
										end,50,0,ID)
										
										setTimer(function(ID)
											Gangwar.datas[ID]["Blocked"] = false;
										end,21600000,1,ID)
										
										Gangwar.datas[ID]["WinTimer"] = setTimer(function(ID)
											for _,v in pairs(getElementsByType("player"))do
												triggerClientEvent(v,"Gangwar.updateDatas",v,nil,nil,nil,nil,nil,"destroy");
												if(isEvil(v) and getElementData(v,"ImGangwar") == true)then
													Gangwar.giveBonus(v);
												end
											end
											sendFactionMessage(Gangwar.datas[ID]["Verteidiger"],"#fa6400[INFO] #ffffffIhr konntet euer Gebiet nicht verteidigen.",125,0,0);
											sendFactionMessage(Gangwar.datas[ID]["Angreifer"],"#fa6400[INFO] #ffffffEuer Angriff war erfolgreich.",0,125,0);
											if(isTimer(Gangwar.datas[ID]["UpdateTimeTimer"]))then killTimer(Gangwar.datas[ID]["UpdateTimeTimer"])end
											if(isTimer(Gangwar.datas[ID]["CheckTimer"]))then killTimer(Gangwar.datas[ID]["CheckTimer"])end
											local r,g,b = Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][1],Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][2],Fraktionen["Farben"][Gangwar.datas[ID]["Angreifer"]][3];
											setRadarAreaFlashing(Gangwar[ID],false);
											setRadarAreaColor(Gangwar[ID],r,g,b,175);
											dbExec(handler,"UPDATE gangareas SET owner = '"..Gangwar.datas[ID]["Angreifer"].."' WHERE ID = '"..ID.."'");
											Gangwar["Active"][Gangwar.datas[ID]["Angreifer"]] = false;
											Gangwar["Active"][Gangwar.datas[ID]["Verteidiger"]] = false;
											Gangwar.datas[ID]["Angreifer"] = false;
											Gangwar.datas[ID]["Verteidiger"] = false;
											Gangwar.datas[ID]["ActiveGangwar"] = false;
											Gangwar.destroyBurritos(ID);
										end,900000,1,ID)
										
										Gangwar.datas[ID]["CheckTimer"] = setTimer(function(ID)
											local counter = 0;
											for _,v in pairs(getElementsByType("player"))do
												if(getElementData(v,"Fraktion") == Gangwar.datas[ID]["Angreifer"])then
													local x,y,z = getElementPosition(Gangwar.datas[ID]["Pickup"]);
													if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(v)) <= 15)then
														if(not(isPedDead(v)))then
															counter = counter + 1;
														end
													end
												end
											end
											if(counter == 0)then
												if(not(isTimer(Gangwar.datas[ID]["StopTimer"])))then
													Gangwar.datas[ID]["StopTimer"] = setTimer(function(ID)
														for _,v in pairs(getElementsByType("player"))do
															triggerClientEvent(v,"Gangwar.updateDatas",v,nil,nil,nil,nil,nil,"destroy");
															if(isEvil(v) and getElementData(v,"ImGangwar") == true)then
																Gangwar.giveBonus(v);
															end
														end
														sendFactionMessage(Gangwar.datas[ID]["Verteidiger"],"#fa6400[INFO] #ffffffIhr konntet euer Gebiet nicht verteidigen.",125,0,0);
														sendFactionMessage(Gangwar.datas[ID]["Angreifer"],"#fa6400[INFO] #ffffffEuer Angriff war erfolgreich.",0,125,0);
														if(isTimer(Gangwar.datas[ID]["CheckTimer"]))then killTimer(Gangwar.datas[ID]["CheckTimer"])end
														if(isTimer(Gangwar.datas[ID]["StopTimer"]))then killTimer(Gangwar.datas[ID]["StopTimer"])end
														if(isTimer(Gangwar.datas[ID]["UpdateTimeTimer"]))then killTimer(Gangwar.datas[ID]["UpdateTimeTimer"])end
														local verteidiger = Gangwar.datas[ID]["Verteidiger"];
														local r,g,b = Fraktionen["Farben"][verteidiger][1],Fraktionen["Farben"][verteidiger][2],Fraktionen["Farben"][verteidiger][3];
														setRadarAreaFlashing(Gangwar[ID],false);
														setRadarAreaColor(Gangwar[ID],r,g,b,175);
														Gangwar["Active"][Gangwar.datas[ID]["Angreifer"]] = false;
														Gangwar["Active"][Gangwar.datas[ID]["Verteidiger"]] = false;
														Gangwar.datas[ID]["Angreifer"] = false;
														Gangwar.datas[ID]["Verteidiger"] = false;
														Gangwar.datas[ID]["ActiveGangwar"] = false;
														if(isTimer(Gangwar.datas[ID]["WinTimer"]))then killTimer(Gangwar.datas[ID]["WinTimer"])end
														Gangwar.destroyBurritos(ID);
													end,11000,1,ID)
												end
											else
												if(isTimer(Gangwar.datas[ID]["StopTimer"]))then
													killTimer(Gangwar.datas[ID]["StopTimer"]);
												end
											end
										end,10000,0,ID)
									end,vorbereitungszeit,1,client,ID)
								else infobox(client,"Dieses Gebiet wurde vor kurzem bereits angegriffen!",120,0,0)end
							else infobox(client,"Du kannst dein eigenes Gebiet nicht angreifen!",120,0,0)end
						else infobox(client,"Es müssen mindestens drei Gegner online sein!",120,0,0)end
					else infobox(client,"Du bist zu weit von dem Gebiet entfernt!",120,0,0)end
				else infobox(client,"Ihr habt keine Attacks mehr!",120,0,0)end
			else infobox(client,"Die Fraktion dieses Gebietes befindet sich bereits in einem Gangwar!",120,0,0)end
		else infobox(client,"Deine Fraktion befindet sich bereits in einem Gangwar!",120,0,0)end
	else infobox(client,"Du benötigst mindestens Rang 3, um ein Gebiet angreifen zu können!",120,0,0)end
end)

addCommandHandler("showgangareas",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(isEvil(player))then
			local result = dbPoll(dbQuery(handler,"SELECT * FROM gangareas"),-1);
			for _,v in pairs(result)do
				local ID = v["ID"];
				if(Gangwar.datas[ID]["Blocked"] == true)then
					r,g,b = 150,0,0;
				else
					r,g,b = 0,150,0;
				end
				outputChatBox(ID..". "..v["name"],player,r,g,b);
			end
		end
	end
end)

addCommandHandler("changeareaowner",function(player,cmd,id,owner)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			if(id and owner)then
				local id = tonumber(id);
				local owner = tonumber(owner);
				if(Gangwar.datas[id]["ActiveGangwar"] == false)then
					dbExec(handler,"UPDATE gangareas SET owner = '"..owner.."' WHERE ID = '"..id.."'");
					infobox(player,"Der Besitzer des Gebietes wurde geändert.",0,120,0);
					local r,g,b = Fraktionen["Farben"][owner][1],Fraktionen["Farben"][owner][2],Fraktionen["Farben"][owner][3];
					setRadarAreaColor(Gangwar[id],r,g,b,175);
					Gangwar.datas[id]["Owner"] = owner;
				else infobox(player,"Nicht möglich, da an dem Gebiet ein Gangwar läuft!",120,0,0)end
			else infobox(player,"Nutze /changeareaowner [ID], [Besitzer]!",120,0,0)end
		end
	end
end)

addCommandHandler("resetareablock",function(player,cmd,id)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Adminlevel") >= 2)then
			if(id)then
				local id = tonumber(id);
				if(Gangwar.datas[id]["Blocked"] == true)then
					Gangwar.datas[id]["Blocked"] = false;
					infobox(player,"Das Gebiet kann nun wieder angegriffen werden.",0,120,0);
				else infobox(player,"Das Gebiet kann bereits angegriffen werden!",0,120,0)end
			else infobox(player,"Nutze /resetareablock [ID]!",0,120,0)end
		end
	end
end)

setTimer(function()
	for i = 1,11 do
		if(Gangwar["Payday"][i] and Gangwar["Payday"][i] == true)then
			if(getMembersOnline(i) >= 2)then
				local gangareas = dbPoll(dbQuery(handler,"SELECT * FROM gangareas WHERE owner = '"..i.."'"),-1);
				local Geld = #gangareas * 500;
				sendFactionMessage(i,"#fa6400[INFO] #ffffffFür #fa6400"..#gangareas.." #fffffferhaltet ihr #fa6400"..Geld.."€ #ffffffin eure Fraktionskasse!",0,255,0);
				fraktionskassen[i] = fraktionskassen[i] - tonumber(Geld);
			end
		end
	end
end,3600000,0)

function Gangwar.destroyBurritos(ID)
	for _,v in pairs(getElementsByType("vehicle"))do
		if(getElementData(v,"GangwarID") == ID)then
			destroyElement(v);
		end
	end
end

function loadGangwarAnzeige(player)
	if(isEvil(player))then
		local result = dbPoll(dbQuery(handler,"SELECT * FROM gangareas"),-1);
		for i = 1,#result do
			if(Gangwar.datas[i]["Angreifer"] == getElementData(player,"Fraktion") or Gangwar.datas[i]["Verteidiger"] == getElementData(player,"Fraktion") and not(isTimer(Gangwar.datas[i]["VorbereitungsZeit"])))then
				local x,y,z = getElementPosition(Gangwar.datas[i]["Pickup"]);
				setElementData(player,"GangwarID",i);
				setElementData(player,"ImGangwar",true);
				setElementData(player,"ImGangwarGestorben",false);
				setElementData(player,"TemporaerGWDamage",0);
				setElementData(player,"TemporaerGWKills",0);
				triggerClientEvent(player,"Gangwar.updateDatas",player,Gangwar.datas[i]["Angreifer"],Gangwar.datas[i]["Verteidiger"],x,y,z,"create");
				break
			end
		end
	end
end

addEvent("Gangwar.nichtMitmachen",true)
addEventHandler("Gangwar.nichtMitmachen",root,function(reason)
	local GangwarID = getElementData(client,"GangwarID");
	setElementData(client,"ImGangwarGestorben",true);
	setElementData(client,"ImGangwar",false);
	if(not(reason))then
		sendFactionMessage(Gangwar.datas[GangwarID]["Angreifer"],"#fa6400[GW] #ffffffDer Spieler #fa6400"..getPlayerName(client).." #ffffffnimmt nicht am Gangwar teil!",255,255,255);
		sendFactionMessage(Gangwar.datas[GangwarID]["Verteidiger"],"#fa6400[GW] #ffffffDer Spieler #fa6400"..getPlayerName(client).." #ffffffnimmt nicht am Gangwar teil!",255,255,255);
	else
		sendFactionMessage(Gangwar.datas[GangwarID]["Angreifer"],"#fa6400[GW] #ffffffDer Spieler #fa6400"..getPlayerName(client).." #ffffffnimmt nicht am Gangwar teil! ("..reason..")",255,255,255);
		sendFactionMessage(Gangwar.datas[GangwarID]["Verteidiger"],"#fa6400[GW] #ffffffDer Spieler #fa6400"..getPlayerName(client).." #ffffffnimmt nicht am Gangwar teil! ("..reason..")",255,255,255);
	end
end)

addEvent("Gangwar.mitmachen",true)
addEventHandler("Gangwar.mitmachen",root,function()
	local GangwarID = getElementData(client,"GangwarID");
	sendFactionMessage(Gangwar.datas[GangwarID]["Angreifer"],"#fa6400[GW] #ffffffDer Spieler "..getPlayerName(client).." nimmt am Gangwar teil!",255,255,255);
	sendFactionMessage(Gangwar.datas[GangwarID]["Verteidiger"],"#fa6400[GW] #ffffffDer Spieler "..getPlayerName(client).." nimmt am Gangwar teil!",255,255,255);
end)

function Gangwar.giveBonus(player)
	local dmg = getElementData(player,"TemporaerGWDamage")*4;
	local kills = getElementData(player,"TemporaerGWKills")*150;
	outputChatBox("_____| Gangwar-Bonus |_____",player,0,150,0);
	outputChatBox("Damage: "..getElementData(player,"TemporaerGWDamage")..", Kills: "..getElementData(player,"TemporaerGWKills"),player,0,125,0);
	outputChatBox("Du hast $"..dmg + kills.." bekommen.",player,200,200,0);
	setElementData(player,"Geld",getElementData(player,"Geld")+(dmg+kills));
	setElementData(player,"ImGangwar",false);
	setElementData(player,"ImGangwarGestorben",false);
	setElementData(player,"TemporaerGWDamage",0);
	setElementData(player,"TemporaerGWKills",0);
end

addCommandHandler("buyAttack",
	function(player)
		if(getElementData(player,"loggedin") == 1)then
			local faction = getElementData(player,"Fraktion");
			if(Gangwar["Attacks"][faction])then
				if(fraktionskassen[faction] >= 25000)then
					fraktionskassen[faction] = fraktionskassen[faction]-25000;
					infobox(player,"Attack gekauft.",0,120,0);
					Gangwar["Attacks"][faction] = Gangwar["Attacks"][faction] + 1;
				else infobox(player,"In eurer Fraktionskasse befindet sich nicht mehr genug Geld!",120,0,0)end
			end
		end
	end
)