--

-- [[ TABLES ]] --

Fabrikwar = {attackerID = nil, defenderID = nil, text = nil, active = false, ID = nil};

-- [[ FABRIKEN LADEN ]] --

local result = dbPoll(dbQuery(handler,"SELECT * FROM fabrikwars"),-1);
if(#result >= 1)then
	for _,v in pairs(result)do
		if(v["Besitzer"] == 0)then
			dbExec(handler,"UPDATE fabrikwars SET Besitzer = '"..math.random(5,8).."' WHERE ID = '"..v["ID"].."'");
		end
	end
end

function Fabrikwar.load()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM fabrikwars"),-1);
	if(#result >= 1)then
		for _,v in pairs(result)do
			local ID = v["ID"];
			local x,y,z = v["Spawnx"],v["Spawny"],v["Spawnz"];
			local owner = v["Besitzer"];
			Fabrikwar[ID] = {
				["Pickup"] = createPickup(x,y,z,3,1313,50),
				["Owner"] = owner,
				["Blocked"] = false,
				["ActiveFabrikwar"] = false,
				["Marker"] = createMarker(x,y,z-0.9,"cylinder",3,255,255,0,0),
			};
			setElementInterior(Fabrikwar[ID]["Pickup"],v["Interior"]);
			setElementDimension(Fabrikwar[ID]["Pickup"],v["Dimension"]);
			setElementInterior(Fabrikwar[ID]["Marker"],v["Interior"]);
			setElementDimension(Fabrikwar[ID]["Marker"],v["Dimension"]);
			
			addEventHandler("onPickupHit",Fabrikwar[ID]["Pickup"],function(player)
				if(isEvil(player))then
					setElementData(player,"FabrikwarID",ID);
					if(Fabrikwar[ID]["ActiveFabrikwar"] == false)then
						triggerClientEvent(player,"Fabrikwar.openWindow",player);
					end
				end
			end)
		end
	end
end
Fabrikwar.load();

function Fabrikwar.loadBlips(player)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM fabrikwars"),-1);
	if(#result >= 1)then
		local tbl = {};
		for _,v in pairs(result)do
			table.insert(tbl,{v["Blipx"],v["Blipy"],v["Besitzer"]});
		end
		triggerClientEvent(player,"Fabrikwar.loadBlips",player,tbl);
	end
end

-- [[ ANGREIFEN ]] --

addEvent("Fabrikwar.attack",true)
addEventHandler("Fabrikwar.attack",root,function()
	local ID = getElementData(client,"FabrikwarID");
	if(isEvil(client))then
		if(Fabrikwar[ID]["Blocked"] == false)then
			if(Fabrikwar.active == false)then
				local neededMembers = 1;
				local time = getRealTime();
				if(time.hour >= 18 and time.hour <= 20)then neededMembers = 0 end
				if(getMembersOnline("Fraktion",Fabrikwar[ID]["Owner"]) >= tonumber(neededMembers))then
					if(getElementData(client,"Fraktion") ~= Fabrikwar[ID]["Owner"])then
						Fabrikwar.ID = ID;
						Fabrikwar.attackerID = getElementData(client,"Fraktion");
						Fabrikwar.defenderID = getPlayerData("fabrikwars","ID",ID,"Besitzer");
						Fabrikwar[ID]["Blocked"] = true;
						Fabrikwar[ID]["ActiveFabrikwar"] = true;
						dbExec(handler,"UPDATE fabrikwars SET Besitzer = '0' WHERE ID = '"..ID.."'");
						Fabrikwar.active = true;
						Fabrikwar.abbrechenTimer = setTimer(function(ID)
							dbExec(handler,"UPDATE fabrikwars SET Besitzer = '"..Fabrikwar.attackerID.."' WHERE ID = '"..ID.."'");
							Fabrikwar[ID]["Owner"] = Fabrikwar.attackerID;
							Fabrikwar.attackerID = nil;
							Fabrikwar.defenderID = nil;
							Fabrikwar[ID]["ActiveFabrikwar"] = false;
							Fabrikwar.active = false;
							for _,v in pairs(getElementsByType("player"))do
								Fabrikwar.loadBlips(v);
							end
						end,300000,1,ID)
						Fabrikwar.checkAttackTimer = setTimer(function()
							Fabrikwar.checkAttack();
						end,1000,0)
						
						sendFactionMessage(Fabrikwar.attackerID,"#fa6400[INFO] #ffffffIhr habt eine Fabrik der #fa6400"..Fraktionen["Namen"][Fabrikwar.defenderID].." #ffffffangegriffen.",0,125,0);
						sendFactionMessage(Fabrikwar.defenderID,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Fabrikwar.attackerID].." #ffffffgreifen eine eurer Fabriken an!",125,0,0);
						triggerClientEvent(client,"dxClassClose",client);
						for _,v in pairs(getElementsByType("player"))do
							Fabrikwar.loadBlips(v);
						end
					else infobox(client,"Du kannst deine eigene Fabrik nicht angreifen!",120,0,0)end
				else infobox(client,"Es muss mindestens ein Gegner online sein!",120,0,0)end
			else infobox(client,"Es läuft bereits ein Fabrikwar!",120,0,0)end
		else infobox(client,"Diese Fabrik wurde vor kurzem bereits angegriffen!",120,0,0)end
	end
end)

-- [[ ANGRIFF CHECKEN ]] --

function Fabrikwar.checkAttack()
	Fabrikwar.attacker = 0;
	Fabrikwar.defender = 0;
	for _,v in pairs(getElementsByType("player"))do
		if(getElementInterior(v) == 1 or getElementInterior(v) == 2 and getElementDimension(v) == 1 and isElementWithinMarker(v,Fabrikwar[Fabrikwar.ID]["Marker"]))then
			local fraktion = getElementData(v,"Fraktion");
			if(fraktion == Fabrikwar.attackerID)then
				Fabrikwar.attacker = Fabrikwar.attacker + 1;
			elseif(fraktion == Fabrikwar.defenderID)then
				Fabrikwar.defender = Fabrikwar.defender + 1;
			end
			setElementData(v,"InFabrikwar",true);
		else
			setElementData(v,"InFabrikwar",false);
		end
	end
	if(Fabrikwar.defender >= 1)then
		if(isTimer(Fabrikwar.abbrechenTimer))then killTimer(Fabrikwar.abbrechenTimer)end
	end
	if(Fabrikwar.attacker >= 1 and Fabrikwar.defender >= 1 and Fabrikwar.attacker == Fabrikwar.defender)then
		if(isTimer(Fabrikwar.checkAttackTimer))then killTimer(Fabrikwar.checkAttackTimer)end
		Fabrikwar.start();
	end
end

-- [[ STARTEN ]] --

function Fabrikwar.start()
	if(isTimer(Fabrikwar.abbrechenTimer))then killTimer(Fabrikwar.abbrechenTimer)end
	for _,v in pairs(getElementsByType("player"))do
		if(getElementData(v,"Fraktion") == Fabrikwar.attackerID or getElementData(v,"Fraktion") == Fabrikwar.defenderID)then
			triggerClientEvent(v,"Fabrikwar.dxDraw",v,"create","Der Kampf beginnt in 60 Sekunden, positioniert euch!");
		end
	end
	setTimer(function()
		for _,v in pairs(getElementsByType("player"))do
			if(getElementData(v,"Fraktion") == Fabrikwar.attackerID or getElementData(v,"Fraktion") == Fabrikwar.defenderID)then
				triggerClientEvent(v,"Fabrikwar.dxDraw",v,"create","Der Kampf beginnt, eliminiert alle Gegner!");
			end
		end
	end,60000,1)
end

-- [[ CHECKEN OB FERTIG ]] --

function Fabrikwar.checkFinish(player)
	if(getElementData(player,"InFabrikwar") == true)then
		local faction = getElementData(player,"Fraktion");
		if(faction == Fabrikwar.attackerID)then
			Fabrikwar.attacker = Fabrikwar.attacker - 1;
			if(Fabrikwar.attacker == 0)then
				Fabrikwar[Fabrikwar.ID]["Owner"] = Fabrikwar.defenderID;
				Fabrikwar.attackerID = nil;
				Fabrikwar.defenderID = nil;
				Fabrikwar[Fabrikwar.ID]["ActiveFabrikwar"] = false;
				Fabrikwar.active = false;
				dbExec(handler,"UPDATE fabrikwars SET Besitzer = '"..Fabrikwar.defenderID.."' WHERE ID = '"..Fabrikwar.ID.."'");
				sendFactionMessage(Fabrikwar.attackerID,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Fabrikwar.defenderID].." #ffffffkonnten ihre Fabrik verteidigen.",150,0,0);
				sendFactionMessage(Fabrikwar.defenderID,"#fa6400[INFO] #ffffffIhr konntet eure Fabrik gegen die #fa6400"..Fraktionen["Namen"][Fabrikwar.attackerID].." #ffffffverteidigen.",0,150,0);
				for _,v in pairs(getElementsByType("player"))do
					Fabrikwar.loadBlips(v);
				end
				Fabrikwar.active = false;
			end
		elseif(faction == Fabrikwar.defenderID)then
			Fabrikwar.defender = Fabrikwar.defender - 1;
			if(Fabrikwar.defender == 0)then
				Fabrikwar[Fabrikwar.ID]["Owner"] = Fabrikwar.attackerID;
				Fabrikwar.attackerID = nil;
				Fabrikwar.defenderID = nil;
				Fabrikwar[Fabrikwar.ID]["ActiveFabrikwar"] = false;
				Fabrikwar.active = false;
				dbExec(handler,"UPDATE fabrikwars SET Besitzer = '"..Fabrikwar.attackerID.."' WHERE ID = '"..Fabrikwar.ID.."'");
				sendFactionMessage(Fabrikwar.attackerID,"#fa6400[INFO] #ffffffIhr habt eine Fabrik der #fa6400"..Fraktionen["Namen"][Fabrikwar.defenderID].." #ffffffeingenommen.",0,150,0);
				sendFactionMessage(Fabrikwar.defenderID,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Fabrikwar.attackerID].." #ffffffhaben/hat eure Fabrik eingenommen.",150,0,0);
				for _,v in pairs(getElementsByType("player"))do
					Fabrikwar.loadBlips(v);
				end
				Fabrikwar.active = false;
			end
		end
		setElementData(player,"InFabrikwar",false);
	end
end

addEventHandler("onPlayerQuit",root,function() Fabrikwar.checkFinish(source) end)
addEventHandler("onPlayerWasted",root,function() Fabrikwar.checkFinish(source) end)