--

-- [[ TABLES ]] --

Ammunation = {
	["Waffen"] = {
		["Schlagring"] = {1,1,40},
		["Baseballschläger"] = {5,1,50},
		["Messer"] = {4,1,30},
		["Colt"] = {22,34,150},
		["Deagle"] = {24,21,500},
		["Rifle"] = {33,15,2500},
		["Sawnoff"] = {26,20,500},
		["Combat"] = {27,20,500},
		["Shotgun"] = {25,10,480},
		["Uzi"] = {28,200,850},
		["Mp5"] = {29,120,2300},
		["M4"] = {31,200,2500},
		["Sniper"] = {34,5,10000},
		["Schutzweste"] = {0,0,40},
	},
	["Marker"] = { -- x,y,z,int,dim,fac
		{-2188.7983398438,-205.51461791992,36.512176513672,0,0,6}, --SF Rifa
		{295.58486938477,-80.811538696289,1001.515625,4,0}, --Ammunation SF
		{956.96057128906,-53.502613067627,1001.1171875,3,0,7}, --Mafia
		{-2379.798828125,1555.5876464844,2.1171875,0,0,5}, --Da Nang Boys
		{-217.65475463867,1401.4371337891,27.7734375,18,0,8}, --Nordics
		{308.15594482422,-141.46383666992,999.6015625,7,0}, -- Ammunation LS
		{2566.5930175781,-1294.6739501953,1037.2882080078,2,0,10}, --Ballas
		{505.81100463867,-80.466300964355,998.55718994141,11,0,11}, --Terroristen
		{-1324.6999511719,500.39999389648,10.599999809265,0,0,3},
	},
};

-- [[ MARKER ERSTELLEN ]] --

for _,v in pairs(Ammunation["Marker"])do
	local marker = createMarker(v[1],v[2],v[3],"corona",1,0,0,255);
	setElementInterior(marker,v[4]);
	setElementDimension(marker,v[5]);
	if (#v == 6 and v[6]) then
		setElementData(marker, "Fraktion", v[6]);
	end
	addEventHandler("onMarkerHit",marker,function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				local Fraktion = getElementData(source, "Fraktion");
				if Fraktion and (Fraktion ~= getElementData(player, "Fraktion")) then
					infobox(player, "Du bist nicht befugt!", 120, 0, 0)
					return
				end
				triggerClientEvent(player,"Ammunation.openWindow",player);
			end
		end
	end)
end

-- [[ KAUFEN ]] --

addEvent("Ammunation.buy",true)
addEventHandler("Ammunation.buy",root,function(weapon)
	local preis = Ammunation["Waffen"][weapon][3];
	if(getElementData(client,"VIP") >= 1 or isEvil(client))then preis = preis/2 end
	if getElementData(client,"Spielstunden") < 180 then
		client:sendNotification("Du hast noch keine 3 Spielstunden!", 120, 0, 0)
		return
	end
	if(getElementData(client,"Geld") >= preis) then
		if(weapon ~= "Schutzweste")then
			local item = itemmanager:add(Weapon_To_Database[Ammunation["Waffen"][weapon][1]], client:getId(), client:getId(), client:getId(), Ammunation["Waffen"][weapon][2], 0, 0, 100, 0, "none", client.m_Storages[1])
			client.m_Storages[1]:addItem(item)	
			item:merge()
			infobox(client,"Waffe gekauft.",0,120,0);
		else
			setPedArmor(client,100);
			infobox(client,"Schutzweste gekauft.",0,120,0);
		end
		setElementData(client,"Geld",getElementData(client,"Geld")-preis);
		putMoneyInBusiness(1,preis);
	else infobox(client,"Du hast nicht genug Geld bei dir!",120,0,0)end
end)