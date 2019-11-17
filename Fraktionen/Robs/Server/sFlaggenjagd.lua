Flaggenjagd = {besitzer = nil, flag = {},
	["Pos"] = {
		[5] = {-2611.525390625,1385.4296875,17.068199157715,0,289.9951171875,48.724365234375,-2613.00390625,1383.783203125,6.1298999786377},
		[6] = {-2122.9091796875,-126.1298828125,45.15599822998,0,289.9951171875,305.33752441406,-2124.0458984375,-124.408203125,34.242599487305},
		[7] = {-2706.3759765625,-280.2236328125,17.143199920654,0,289.9951171875,296.22436523438,-2707.279296875,-278.2822265625,6.0959000587463},
		[8] = {-95.2568359375,1356.982421875,20.306400299072,0,289.9951171875,267.50610351563,-95.099609375,1359,9.1999998092651},
		[10] = {1059.1298828125,-315.6171875,84.041397094727,0,289.9951171875,322.16857910156,1057.505859375,-314.2490234375,72.956001281738},
		[11] = {-790.109375,2393.0302734375,166.07620239258,0,289.9951171875,341.77368164063,-792.0400390625,2393.748046875,155.1708984375},
	},
	["AvailableFactions"] = {5,6,7,8,10,11},
};

function Flaggenjagd.placeFlag(faction)
	if(isElement(Flaggenjagd.object))then destroyElement(Flaggenjagd.object)end
	if(isElement(Flaggenjagd.marker))then destroyElement(Flaggenjagd.marker)end

	if(not(faction))then faction = Flaggenjagd["AvailableFactions"][math.random(1,#Flaggenjagd["AvailableFactions"])]end
	local tbl = Flaggenjagd["Pos"][faction];

	Flaggenjagd.besitzer = faction;
	Flaggenjagd.object = createObject(11245,tbl[1],tbl[2],tbl[3],tbl[4],tbl[5],tbl[6]);
	setObjectScale(Flaggenjagd.object,4);
	Flaggenjagd.marker = createMarker(tbl[7],tbl[8],tbl[9]+1,"cylinder",1,0,0,0,0);
	addEventHandler("onMarkerHit",Flaggenjagd.marker,Flaggenjagd.takeFlag);
	sendFactionMessage(5,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffhaben nun die Flagge!",255,255,255);
	sendFactionMessage(6,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffhaben nun die Flagge!",255,255,255);
	sendFactionMessage(7,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffhaben nun die Flagge!",255,255,255);
	sendFactionMessage(8,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffhaben nun die Flagge!",255,255,255);
	sendFactionMessage(10,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffhaben nun die Flagge!",255,255,255);
	sendFactionMessage(11,"#fa6400[INFO] #ffffffDie #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffhaben nun die Flagge!",255,255,255);
end
addEvent("Flaggenjagd.placeFlag",true)
addEventHandler("Flaggenjagd.placeFlag",root,Flaggenjagd.placeFlag)

function Flaggenjagd.takeFlag(player)
	if(isEvil(player))then
		local faction = getElementData(player,"Fraktion");
		if(not(faction == Flaggenjagd.besitzer))then
			destroyElement(Flaggenjagd.object);
			destroyElement(source);
			local x,y,z = getElementPosition(player);
			Flaggenjagd.object = createObject(11245,x,y,z,0,290,180);
			setObjectScale(Flaggenjagd.object,0.2);
			attachElements(Flaggenjagd.object,player,0.1,-0.2,0.2,0,290,0);
			Flaggenjagd.client(player);
			Flaggenjagd.flag[player] = true;
			sendFactionMessage(Flaggenjagd.besitzer,"#fa6400[INFO] #ffffffEure Flagge wurde geklaut!",255,255,255);
			sendFactionMessage(faction,"#fa6400[INFO] #ffffffIhr habt den #fa6400"..Fraktionen["Namen"][Flaggenjagd.besitzer].." #ffffffdie Flagge geklaut.",255,255,255);
		end
	end
end
Flaggenjagd.placeFlag();

function Flaggenjagd.refreshFlag(player)
	if(Flaggenjagd.flag[player] == true)then
		setElementInterior(Flaggenjagd.object,getElementInterior(player));
		setElementDimension(Flaggenjagd.object,getElementDimension(player));
	end
end

function Flaggenjagd.client(player)
	local faction = getElementData(player,"Fraktion");
	local tbl = Flaggenjagd["Pos"][faction];
	triggerClientEvent(player,"Flaggenjagd.client",player,tbl[7],tbl[8],tbl[9] + 1);
end

function Flaggenjagd.hasFactionFlag(player)
	if(Flaggenjagd.besitzer == getElementData(player,"Fraktion"))then
		return true
	else
		return false
	end
end

function Flaggenjagd.dropFlag(player)
	if(Flaggenjagd.flag[player] == true)then
		triggerClientEvent(player,"Flaggenjagd.client",player);
		Flaggenjagd.placeFlag(Flaggenjagd.besitzer);
		Flaggenjagd.flag[player] = false;
	end
end

addEventHandler("onPlayerWasted",root,function() Flaggenjagd.dropFlag(source) end)
addEventHandler("onPlayerQuit",root,function() Flaggenjagd.dropFlag(source) end)