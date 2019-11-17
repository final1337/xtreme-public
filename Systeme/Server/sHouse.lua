--

Haussystem = {outPickup = {}, pickups = {},
	["Interiors"] = {
		[1] = {223.1171875,1287.076171875,1082.140625,1}, -- Bude mit Zeit
		[2] = {2233.6784667969,-1115.2629394531,1050.8828125,5}, -- 1 Zimmer Wohnung Gelbe Wände
		[3] = {2365.2521972656,-1135.5981445313,1050.8825683594,8}, -- Mittelständige Wohnung - 2 S.Zimmer
		[4] = {2282.9541015625,-1140.2854003906,1050.8984375,11}, -- 1ZKB
		[5] = {2196.8513183594,-1204.3459472656,1049.0234375,6}, -- 3ZKB -> Großes Wohnzimmer
		[6] = {2270.4187011719,-1210.4476318359,1047.5625,10}, -- 1 ZKB -> Großes Wohnzimmer
		[7] = {2308.7807617188,-1212.9357910156,1049.0234375,6}, -- Wohnzimmer & Küche
		[8] = {2218.4028320313,-1076.2043457031,1050.484375,1}, -- Hotelzimmer
		[9] = {2237.4897460938,-1081.6453857422,1049.0234375,2}, -- Schlafzimmer, Wohnzimmer, Bad
		[10] = {2317.8435058594,-1026.7661132813,1050.2177734375,9}, -- 5 Zimmer Haus
		[11] = {260.99710083008,1284.2950439453,1080.2578125,4}, -- Wohnung mit Bad im Wohnzimmer
		[12] = {140.23556518555,1365.9215087891,1083.859375,5}, -- 4 Schlafzimmer + Esszimmer
		[13] = {83.084022521973,1322.2811279297,1083.8662109375,9}, -- 2 Schlafzimmer + Esszimmer + Küczhe
		[14] = {-283.43811035156,1470.9816894531,1084.375,15}, -- Himmel
		[15] = {-260.48501586914,1456.7393798828,1084.3671875,4}, -- Pärchen Haus
		[16] = {-42.563606262207,1405.4689941406,1084.4296875,8}, -- 1 Schlafzimmer komische Fenster
		[17] = {300.56094360352,300.35952758789,999.1484375,4}, -- SCheunen wohnung
		[18] = {2468.8422851563,-1698.3157958984,1013.5078125,2}, -- Ekelhaftes Klo
		[19] = {2807.6630859375,-1174.7573242188,1025.5703125,8}, -- Singeplayer Mission kisten klauen
		[20] = {318.63439941406,1114.4794921875,1083.8828125,5}, -- Komische Matratze
		[21] = {2324.5126953125,-1149.5473632813,1050.7100830078,12}, -- 2 Schlafziommer l. und r.
		[22] = {1298.9053955078,-797.00891113281,1084.0078125,5}, -- Mad Dog Villa
	},
};

-- [[ HÄUSER ERSTELLEN ]] --

function Haussystem.load()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM houses"),-1);
	if(#result >= 1)then
		for _,v in pairs(result)do
			if(not(isElement(Haussystem.pickups[v["ID"]])))then
				if(v["Besitzer"] == "Niemand")then ID = 1273 else ID = 1272 end
				Haussystem.pickups[v["ID"]] = createPickup(v["Spawnx"],v["Spawny"],v["Spawnz"],3,ID,50);
				setElementData(Haussystem.pickups[v["ID"]],"HouseID",v["ID"]);
				Haussystem[v["ID"]] = {v["Preis"],v["Besitzer"],v["Spawnx"],v["Spawny"],v["Spawnz"],v["Abgeschlossen"],v["Interior"],v["Mietpreis"],v["Text"],v["Mindestspielzeit"]};
				
				local int = Haussystem["Interiors"][Haussystem[v["ID"]][7]];
				Haussystem.outPickup[v["ID"]] = createPickup(int[1],int[2],int[3],3,1318,50);
				setElementInterior(Haussystem.outPickup[v["ID"]],int[4]);
				setElementDimension(Haussystem.outPickup[v["ID"]],v["ID"]);
				
				addEventHandler("onPickupHit",Haussystem.pickups[v["ID"]],function(player)
					if(not(isPedInVehicle(player)))then
						setElementData(player,"HouseID",getElementData(source,"HouseID"));
						local ID = getElementData(player,"HouseID");
						if(ID)then
							local x,y,z = Haussystem[ID][3],Haussystem[ID][4],Haussystem[ID][5];
							if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
								local datas = {Haussystem[ID][1],Haussystem[ID][2],Haussystem[ID][10],ID};
								triggerClientEvent(player,"Haussystem.openWindow",player,datas);
							end
						end
					end
				end)
				
				addEventHandler("onPickupHit",Haussystem.outPickup[v["ID"]],function(player)
					setElementPosition(player,v["Spawnx"],v["Spawny"],v["Spawnz"]);
					setElementInterior(player,0);
					setElementDimension(player,0);
					unbindKey(player,"f7","down",Haussystem.verwaltung);
					setElementData(player,"InHouse",false);
				end)
			end
		end
	end
end
Haussystem.load();

-- [[ KAUFEN / VERKAUFEN ]] --

addEvent("Haussystem.server",true)
addEventHandler("Haussystem.server",root,function(type)
	local ID = getElementData(client,"HouseID");
	local x,y,z = Haussystem[ID][3],Haussystem[ID][4],Haussystem[ID][5];
	if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(client)) <= 5)then
		local preis = Haussystem[ID][1];
		local owner = Haussystem[ID][2];
		if(type == "Kaufen")then
			if(getElementData(client,"Geld") >= preis)then
				if(owner == "Niemand")then
					setElementData(client,"Geld",getElementData(client,"Geld")-preis);
					Haussystem[ID][2] = getPlayerName(client);
					dbExec(handler,"UPDATE houses SET Besitzer = '"..getPlayerName(client).."' WHERE ID = '"..ID.."'");
					infobox(client,"Herzlichen Glückwunsch, das Haus gehört nun Dir!",0,120,0);
					triggerClientEvent(client,"dxClassClose",client);
					Haussystem.reload(ID);
				else infobox(client,"Dieses Haus steht nicht mehr zum Verkauf!",120,0,0)end
			end
		else
			if(owner == getPlayerName(client))then
				setElementData(client,"Geld",getElementData(client,"Geld")+preis/100*75);
				Haussystem[ID][2] = "Niemand";
				dbExec(handler,"UPDATE houses SET Besitzer = 'Niemand' WHERE ID = '"..ID.."'");
				infobox(client,"Du hast dein Haus verkauft und 75% des Kaufpreises zurückbekommen.",0,120,0);
				triggerClientEvent(client,"dxClassClose",client);
				Haussystem.reload(ID);
			else infobox(client,"Du bist nicht der Besitzer dieses Hauses!",120,0,0)end
		end
	end
end)

function Haussystem.reload(ID)
	if(isElement(Haussystem.pickups[ID]))then
		destroyElement(Haussystem.pickups[ID]);
		Haussystem.load();
	end
end

-- [[ HAUS BETRETEN ]] --

addEvent("Haussystem.in",true)
addEventHandler("Haussystem.in",root,function()
	local ID = getElementData(client,"HouseID");
	local x,y,z = Haussystem[ID][3],Haussystem[ID][4],Haussystem[ID][5];
	if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(client)) <= 5)then
		if(Haussystem[ID][6] == "Abgeschlossen")then
			if(isMieter(client,ID) == false and Haussystem[ID][2] ~= getPlayerName(client))then
				infobox(client,"Das Haus ist abgeschlossen!",120,0,0);
				return false
			end
		end
		
		local int = Haussystem["Interiors"][Haussystem[ID][7]];
		setElementPosition(client,int[1],int[2],int[3]);
		setElementInterior(client,int[4]);
		setElementDimension(client,ID);	
		bindKey(client,"f7","down",Haussystem.verwaltung);
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"InHouse",true);
	end
end)

-- [[ AUF- / ABSCHLIESSEN ]] --

addEvent("Haussystem.lock",true)
addEventHandler("Haussystem.lock",root,function()
	local ID = getElementData(client,"HouseID");
	if(Haussystem[ID][2] == getPlayerName(client) or isMieter(client,ID) == true)then
		if(Haussystem[ID][6] == "Abgeschlossen")then
			Haussystem[ID][6] = "Aufgeschlossen";
			infobox(client,"Das Haus wurde aufgeschlossen.",0,120,0);
		else
			Haussystem[ID][6] = "Abgeschlossen";
			infobox(client,"Das Haus wurde abgeschlossen.",120,0,0);
		end
	else infobox(client,"Du hast keinen Schlüssel für dieses Haus!",120,0,0)end
end)

-- [[ EIN- / AUSMIETEN ]] --

addEvent("Haussystem.mieten",true)
addEventHandler("Haussystem.mieten",root,function()
	local text = "";
	local ID = getElementData(client,"HouseID");
	local x,y,z = Haussystem[ID][3],Haussystem[ID][4],Haussystem[ID][5];
	if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(client)) <= 5)then
		if(Haussystem[ID][2] ~= "Niemand")then
			if(Haussystem[ID][2] ~= getPlayerName(client))then
				if(Haussystem[ID][8] >= 1)then
					if(isMieter(client,ID) == true)then
						for _,v in pairs(getMieter(ID))do
							if(v ~= getPlayerName(client))then
								text = text..v.."|";
							end
						end
						infobox(client,"Du hast dich ausgemietet.",120,0,0);
						counter = getPlayerData("houses","ID",ID,"MieterAnzahl") - 1;
					else
						counter = getPlayerData("houses","ID",ID,"MieterAnzahl") + 1;
						text = getPlayerData("houses","ID",ID,"Mieter")..getPlayerName(client).."|";
						infobox(client,"Du hast dich eingemietet.",0,120,0);
					end
					dbExec(handler,"UPDATE houses SET Mieter = '"..text.."', MieterAnzahl = '"..counter.."' WHERE ID = '"..ID.."'");
				else infobox(client,"Der Besitzer dieses Hauses lässt keine Mieter zu!",120,0,0)end
			else infobox(client,"Du kannst dich nicht in dein eigene Haus einmieten!",120,0,0)end
		else infobox(client,"Du kannst dich nicht in zum Verkauf stehende Häuser einmieten!",120,0,0)end
	end
end)

-- [[ MIETE ÄNDERN ]] --

addEvent("Haussystem.changeMiete",true)
addEventHandler("Haussystem.changeMiete",root,function(miete)
	local miete = tonumber(miete);
	local ID = getElementData(client,"HouseID");
	if(Haussystem[ID][2] == getPlayerName(client))then
		if(miete >= 0 and miete <= 500)then
			dbExec(handler,"UPDATE houses SET Mietpreis = '"..miete.."' WHERE ID = '"..ID.."'");
			infobox(client,"Deine Mieter zahlen nun "..miete.."€ an ihrem Payday.",0,120,0);
			Haussystem[ID][8] = miete;
			triggerClientEvent(client,"refreshHouseMiete",client,miete);
		else infobox(client,"Wähle eine Summe zwischen 0€ und 500€!",120,0,0)end
	else infobox(client,"Du bist nicht befugt, den Mietpreis zu ändern!",120,0,0)end
end)

-- [[ HAUSVERWALTUNG ]] --

function Haussystem.verwaltung(player)
	local ID = getElementData(player,"HouseID");
	if(Haussystem[ID][2] == getPlayerName(player) or isMieter(player,ID) == true)then
		local datas = {Haussystem[ID][8],Haussystem[ID][9],Haussystem[ID][2]};
		triggerClientEvent(player,"Haussystem.verwaltung",player,datas,getMieter(ID));
	end
end

addEvent("Haussystem.kickMieter",true)
addEventHandler("Haussystem.kickMieter",root,function(mieter)
	local text = "|";
	local ID = getElementData(client,"HouseID");
	if(Haussystem[ID][2] == getPlayerName(client))then
		local counter = 0;
		for _,v in pairs(getMieter(ID))do
			if(v ~= mieter)then
				counter = counter + 1;
				text = text..v.."|";
			end
		end
		dbExec(handler,"UPDATE houses SET Mieter = '"..text.."', MieterAnzahl = '"..counter.."' WHERE ID = '"..ID.."'");
		infobox(client,"Dem Mieter wurde gekündigt!",120,0,0);
	else infobox(client,"Du bist nicht befugt, Mietern zu kündigen!",120,0,0)end
end)

addEvent("Haussystem.saveText",true)
addEventHandler("Haussystem.saveText",root,function(text)
	dbExec(handler,"UPDATE houses SET Text = '"..text.."' WHERE ID = '"..getElementData(client,"HouseID").."'");
	infobox(client,"Die Haushaltsregeln wurden gespeichert.",0,120,0);
end)

-- [[ IST SPIELER MIETER? ]] --

function isMieter(player,id)
	local state = false;
	
	for _,v in pairs(getMieter(id))do
		if(v == getPlayerName(player))then
			state = true;
			break
		end
	end
	return state;
end

-- [[ ALLE MIETER LADEN ]] --

function getMieter(id)
	local tbl = {};
	local Mieter = getPlayerData("houses","ID",id,"Mieter");
	local MieterAnzahl = getPlayerData("houses","ID",id,"MieterAnzahl");
	for i = 1,MieterAnzahl do
		local mstring = gettok(Mieter,i,string.byte("|"));
		if(mstring and #mstring >= 1)then
			table.insert(tbl,mstring);
		end
	end
	return tbl;
end

-- [[ NEUES HAUS ERSTELLEN ]] --

addCommandHandler("createhouse",function(player,cmd,stunden,preis,int)
    if getElementData(player, "Adminlevel") >= 6 then
        if(stunden and preis and int)then
            if (tonumber(int) >= 1 and tonumber(int) <= 22) then
                local house = tonumber(int)
                local x,y,z = getElementPosition(player);
                dbExec(handler,"INSERT INTO houses (Besitzer,Preis,Mindestspielzeit,Spawnx,Spawny,Spawnz,Interior,Mieter,Abgeschlossen,MieterAnzahl,Text) VALUES ('Niemand','"..preis.."','"..stunden.."','"..x.."','"..y.."','"..z.."','"..house.."','','Abgeschlossen','0','Keine Angaben.')");
                Haussystem.load();
            else infobox(player,"Nur Interior 1-22 möglich!",120,0,0)end
        else infobox(player,"Nutze /createhouse [Mindestspielzeit], [Preis], [Interior]!",120,0,0)end
    end
end)

-- [[ TP INTERIOR ]]

addCommandHandler("tpint",
    function(player, _, int)
        if player:getData("Adminlevel") > 2 then
            int = tonumber(int)
            if int then
                local x,y,z,interior = unpack(Haussystem["Interiors"][int])
                setElementFrozen(player, true)
                Timer(setElementFrozen, 500, 1, player, false)
                player:setInterior(interior)
                player:setPosition(x,y,z)
                player:sendNotification("You got tp'ed. iksde.")
            end
        end
    end
)