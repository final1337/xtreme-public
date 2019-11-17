--

-- [[ TABLES ]] --

Fraktionsgates = {objects = {},
	-- Model, x, y, z, rx, ry, rz, Fraktions-ID, Interior
	["Gates"] = {
		{17566,239.59240722656,117.5617980957,1003.2301025391,0,0,0,1, 10}, -- SFPD Stellen
		{17566,253.22239685059,109.05200195313,1003.2301025391,0,0,0,1, 10}, -- SFPD Dienst
		{3036,214.25520324707,116.55539703369,998.92462158203,0,0,0,1, 10}, -- SFPD Knast
		{10184,-1631.5999755859,688.20001220703,8.6999998092651,0,0,270,1}, -- SFPD Garage
		{980,-2127.3447265625,-80.40234375,37.099998474121,0,0,0,6}, -- SF Rifa
		{980,-2655.2236328125,-228.900390625,6.5100998878479,0,0,350.24963378906,7}, -- Mafia vorne
		{980,-2790.7060546875,-330.9111328125,8.8125,0,0,90,7}, -- Mafia hinten
		{980,-2592.978515625,1355.384765625,8.8125,0,0,223.51135253906,5}, -- Da Nang Boys
		{1966,-2180.5615234375,-209.474609375,37.435199737549,0,0,90,6}, -- SF Rifa Tor zum Haus
		{3050,-778.744140625,2311.5966796875,138.39604187012,12.332153320313,0,90.252685546875,11}, -- Terroristen
		{3049,-778.74609375,2311.5693359375,138.39663696289,347.66235351563,0,268.01147460938,11}, -- Terroristen
		{980,1024.4599609375,-366.587890625,75.701599121094,0,0,180,10}, -- Ballas
		{980,-2433.611328125,496.578125,31.710500717163,0,0,24.087524414063,2}, -- F.B.I
		{988,-2240.7041015625,162.015625,34.037300109863,0,0,270,8}, -- Nordic Angels SF
		{3050,-77.369598388672,1363.2103271484,11.53989982605,0,0,76.68017578125,8}, -- Nordic Angels LV
		{3050,-80.0771484375,1366.947265625,11.53989982605,0,0,125.95825195313,8}, -- Nordic Angels LV
		{970,-2033.2998046875,180.8681640625,28.297540664673,0,0,90,12}, -- Mechaniker Base
		{971,-1532.234375,482.072265625,8.7633104324341,0,0,178.81896972656,3}, -- Army Base SF Haupteingang
		{971,-1448.50390625,481.6884765625,8.834210395813,0,0,0.120849609375,3}, -- Army Base SF Steg 1
		{988,-1336.515625,436.0400390625,7.076000213623,0,0,144.12963867188,3}, -- Army Base SF Docks
		{980,-1333.9228515625,330.1103515625,8.77357006073,0,0,179.99450683594,3}, -- Army Base SF Docks 2
	},
}

-- [[ GATES ERSTELLEN ]] --

for i,v in pairs(Fraktionsgates["Gates"])do
	Fraktionsgates.objects[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7]);
	setElementData(Fraktionsgates.objects[i],"Fraktion",v[8]);
	setElementData(Fraktionsgates.objects[i],"Move",false);
	setElementData(Fraktionsgates.objects[i],"Status","Close");
	if v[9] then
		setElementInterior(Fraktionsgates.objects[i], v[9])
	end
end

-- [[ ÖFFNEN ]] --

addCommandHandler("gate",function(player)
	if(getElementData(player,"loggedin") == 1)then
		local id = 0;
		for _,v in pairs(Fraktionsgates.objects)do
			local x,y,z = getElementPosition(v);
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 20)then
				if(getElementDimension(player) == getElementDimension(v))then
					local fac = getElementData(v,"Fraktion");
					if(fac == 1 or fac == 2 or fac == 3)then
						if(getElementData(player,"Fraktion") ~= 1 and getElementData(player,"Fraktion") ~= 2 and getElementData(player,"Fraktion") ~= 3)then
							return false
						end
					else
						if(getElementData(player,"Fraktion") ~= fac and not isSwatDuty(player) and not isArmyOnDuty(player))then
							return false
						end
					end
						
					if(getElementData(v,"Move") == false)then
						id = id + 1
						if(getElementData(v,"Status") == "Close")then
							moveObject(v,2000,x,y,z-7);
							setElementData(v,"Status","Open");
						else
							moveObject(v,2000,x,y,z+7);
							setElementData(v,"Status","Close");
						end
						setElementData(v,"Move",true);
						setTimer(function(v)
							setElementData(v,"Move",false);
						end,2000,1,v)
						if(id >= 2)then break end
					end
				end
			end
		end
	end
end)


bundDeck1 = createObject ( 3115, -1456.7, 501.3, 9.9, 0, 0, 180 )
--Deck12 = createObject ( 3115, -1456.7, 501.3, 17, 0, 0, 180 )
bundDeck2 = createObject ( 3114, -1414.5, 516.45, 9.6, 0, 0, 0 )
--Deck22 = createObject ( 3114, -1414.5, 516.45, 16.65, 0, 0, 0 )
bundDeck3 = createObject ( 3114, -1505.8, 462.4, 6.7, 351.5, 0, 0 )
--Deck32 = createObject ( 3114, -1505.8, 462.4, 41.7, 0, 0, 0 )

bundDeck41 = createObject ( 3115, -1476.9833984375, 382.5537109375, 42.055999755859, 0, 0, 270)
--Deck412 = createObject ( 3115, -1475.5, 382.5, 28.8, 0, 0, 90)
bundDeck42 = createObject ( 3115, -1478.146484375, 392.826171875, 32.922401428223, 270, 270, 270)
--Deck422 = createObject ( 3115, -1484.7, 382.4, 19,6, 270, 180, 270)
bundDeck43 = createObject ( 3115, -1467.8544921875, 382.548828125, 32.931228637695, 270, 0, 270)
--Deck432 = createObject ( 3115, -1475.6, 392.8, 18.5, 0, 270, 270)
bundDeck44 = createObject ( 3115, -1476.99609375, 372.263671875, 31.78697013855, 0, 90, 270)
--Deck442 = createObject ( 3115, -1466.4, 382.5, 19.6, 270, 180, 90)
--bundDeck45 = createObject ( 3115, -1475.5, 372.1, 31.8, 0, 270, 90)
--Deck452 = createObject ( 3115, -1475.5, 372.1, 18.5, 0, 270, 90)createObject ( 987, 291.7, 1815.9, 16.5, 0, 0, 40 )

bundMovedDeck1 = 0
bundMovedDeck2 = 0
bundMovedDeck3 = 0
bundMovedDeck4 = 0

function bundDeck (player)
local plX, plY, plZ = getElementPosition (player)
local deck1X, deck1Y, deck1Z = getElementPosition (bundDeck1)
local deck2X, deck2Y, deck2Z = getElementPosition (bundDeck2)
local deck3X, deck3Y, deck3Z = getElementPosition (bundDeck3)
local deck4X, deck4Y, deck4Z = getElementPosition (bundDeck41)
	if getDistanceBetweenPoints3D(plX, plY, plZ, deck1X, deck1Y, deck1Z) < 20 then
		if tonumber(getElementData(player,"Fraktion")) == 3 then
			if bundMovedDeck1 == 0 then
				moveObject (bundDeck1, 7000, -1456.7, 501.3, 17, 0, 0, 0 )
				bundMovedDeck1 = 2
				setTimer(function()bundMovedDeck1 = 1 end,7100,1)
			elseif bundMovedDeck1 == 1 then
				moveObject (bundDeck1, 7000, -1456.7, 501.3, 9.9, 0, 0, 0 )
				bundMovedDeck1 = 2
				setTimer(function()bundMovedDeck1 = 0 end,7100,1)
			end
		end
	elseif getDistanceBetweenPoints3D(plX, plY, plZ, deck2X, deck2Y, deck2Z) < 20 then
		if tonumber(getElementData(player,"Fraktion")) == 3 then
			if bundMovedDeck2 == 0 then
				moveObject (bundDeck2, 7000, -1414.5, 516.45, 16.65, 0, 0, 0 )
				bundMovedDeck2 = 2
				setTimer(function()bundMovedDeck2 = 1 end,7100,1)
			elseif bundMovedDeck2 == 1 then
				moveObject (bundDeck2, 7000, -1414.5, 516.45, 9.6, 0, 0, 0 )
				bundMovedDeck2 = 2
				setTimer(function()bundMovedDeck2 = 0 end,7100,1)
			end
		end
	elseif getDistanceBetweenPoints2D(plX, plY, deck3X, deck3Y) < 20 then
		if tonumber(getElementData(player,"Fraktion")) == 3  then
			if bundMovedDeck3 == 0 then
				moveObject (bundDeck3, 1500, -1505.8, 462.4, 6.7, 8.5, 0, 0 )
				setTimer( function() moveObject (bundDeck3, 15500, -1505.8, 462.4, 41.7, 0, 0, 0 ) end, 1500,1)
				bundMovedDeck3 = 2
				setTimer(function()bundMovedDeck3 = 1 end,17500,1)
			elseif bundMovedDeck3 == 1 then
				moveObject (bundDeck3, 15500, -1505.8, 462.4, 6.7, 0, 0, 0 )
				setTimer( function() moveObject (bundDeck3, 1500, -1505.8, 462.4, 6.7, -8.5, 0, 0 ) end, 15500,1)
				bundMovedDeck3 = 2
				setTimer(function()bundMovedDeck3 = 0 end,17500,1)
			end
		end
	elseif getDistanceBetweenPoints2D(plX, plY, deck4X, deck4Y) < 20 then
		if tonumber(getElementData(player,"Fraktion")) == 3 then
			if bundMovedDeck4 == 0 then
				moveObject (bundDeck41, 7500, -1476.9833984375, 382.5537109375, 28.799999237061, 0, 0, 0 )
				moveObject (bundDeck42, 7500, -1478.146484375, 392.826171875, 19.700000762939, 0, 0, 0 )
				moveObject (bundDeck43, 7500, -1467.8544921875, 382.548828125, 19.700000762939, 0, 0, 0 )
				moveObject (bundDeck44, 7500, -1476.99609375, 372.263671875, 18.5, 0, 0, 0 )
				bundMovedDeck4 = 2
				setTimer(function()bundMovedDeck4 = 1 end,7600,1)
			elseif bundMovedDeck4 == 1 then
				moveObject (bundDeck41, 7500, -1476.9833984375, 382.5537109375, 42.055999755859, 0, 0, 0 )
				moveObject (bundDeck42, 7500, -1478.146484375, 392.826171875, 32.922401428223, 0, 0, 0 )
				moveObject (bundDeck43, 7500, -1467.8544921875, 382.548828125, 32.931228637695, 0, 0, 0 )
				moveObject (bundDeck44, 7500, -1476.99609375, 372.263671875, 31.78697013855, 0, 0, 0 )
				bundMovedDeck4 = 2
				setTimer(function()bundMovedDeck4 = 0 end,7600,1)
			end
		end
	end
end
addCommandHandler ( "deck", bundDeck )