--

-- [[ TABLES ]] --

local Knastspawn = {
	{215.53283691406,111.33550262451,999.015625,0},
	{219.46109008789,111.91826629639,999.015625,0},
	{223.4437713623,112.00965881348,999.015625,0},
	{227.35340881348,111.65621185303,999.015625,0},
};

local Alkatrazspawn = {
	{-3549.1108398438,420.34930419922,2.3512620925903,180},
	{-3576.2580566406,425.34671020508,2.5964722633362,270},
	{-3557.0324707031,404.02938842773,6.9857149124146,180},
	{-3559.5842285156,409.07409667969,17.891965866089,270},
	{-3556.4135742188,467.86776733398,1.9512023925781,180},
};

local FBISpawn = {
	{319.80178833008,312.11752319336,999.1484375,270},
	{319.72848510742,316.15902709961,999.1484375,270},
};

-- [[ EINKNASTMARKER ]] --

Einknasten_SFPD = createMarker(-1590.1864013672,716.22076416016,-5.2421875-2,"cylinder",4,200,200,0,75);
Einknasten_SFPDHeli = createMarker(-1651.6053466797,700.51708984375,37.182998657227,"cylinder",4,200,200,0,75);

-- [[ SPIELER INS GEFÄNGNIS STECKEN ]] --

function putPlayerInJail(player)
	setPedHeadless(player,false)
	if isPedInVehicle(player) then
		removePedFromVehicle(player)
	end
	toggleAllControls(player,true)
	if(getElementData(player,"Knastzeit") >= 1)then
		if(getElementData(player,"Giftpfeil") == true)then
			local rnd = math.random(1,#FBISpawn);
			x,y,z,rot = FBISpawn[rnd][1],FBISpawn[rnd][2],FBISpawn[rnd][3],FBISpawn[rnd][4];
			setElementInterior(player,5);
			setElementDimension(player,0);
			setElementPosition(player,x,y,z)
			setElementRotation(player,0,0,rot)
		else
			if(getElementData(player,"Knastzeit") >= 5000)then
				local rnd = math.random(1,#Alkatrazspawn);
				x,y,z,rot = Alkatrazspawn[rnd][1],Alkatrazspawn[rnd][2],Alkatrazspawn[rnd][3],Alkatrazspawn[rnd][4];
				setElementDimension(player,0);
				setElementInterior(player,0);
				setElementPosition(player,x,y,z)
				setElementRotation(player,0,0,rot)
			else
				local rnd = math.random(1,#Knastspawn);
				x,y,z,rot = Knastspawn[rnd][1],Knastspawn[rnd][2],Knastspawn[rnd][3],Knastspawn[rnd][4];
				setElementInterior(player,10);
				setElementDimension(player,0);
				setElementPosition(player,x,y,z)
				setElementRotation(player,0,0,rot)
			end
		end
		toggleControl(player,"jump",false);
		toggleControl(player,"sprint",false);
		toggleControl(player,"fire",false);
		toggleControl(player,"aim_weapon", false)
		toggleControl(player,"action", false)
		setElementData(player,"grabbed",false,true)
		setElementData(player,"getazert",false,true)		
		setElementData(player,"Duty",false);
		if(not(isCop(player)) and not(isFBI(player)) and not(isArmy(player)) and not(isReporter(player)) and not(isFeuerwehr(player)))then
			setElementModel(player,getElementData(player,"Skin"));
		end
	end
end

-- [[ SPIELER ENTLASSEN ]] --

function freeFromJail(player)
	infobox(player,"Du wurdest entlassen.",0,120,0);
	setElementPosition(player,-1605.5430908203,713.40338134766,13.491200447083);
	setElementRotation(player,0,0,0);
	setElementInterior(player, 0)
	setElementDimension(player, 0)
	toggleAllControls(player,true);
end

-- [[ SPIELER EINKNASTEN ]] --

function putPlayerInJailFromVehicle(player)
	if(getElementType(player) == "vehicle")then
		local player = getVehicleOccupant(player,0);
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(getElementData(player,"Fraktion") == 1 or getElementData(player,"Fraktion") == 2 or getElementData(player,"Fraktion") == 3)then
				local veh = getPedOccupiedVehicle(player);
				if(getElementData(veh,"Fraktion") == 1 or getElementData(veh,"Fraktion") == 2 or getElementData(veh,"Fraktion") == 3)then
					for _,v in pairs(getElementsByType("player"))do
						if(isPedInVehicle(v))then
							if(getPedOccupiedVehicle(v) == getPedOccupiedVehicle(player))then
								if(getElementData(v,"Wanteds") >= 1)then
									local time = tonumber(getElementData(v,"Wanteds"))*2+5
									setElementData(v,"Knastzeit",time);
									putPlayerInJail(v);
									player:addBonus(getElementData(v,"Wanteds")*100);
									fraktionskassen[getElementData(player,"Fraktion")] = fraktionskassen[getElementData(player,"Fraktion")] + getElementData(v,"Wanteds")*100									
									outputChatBox(getPlayerName(v).." wurde von "..getPlayerName(player).." eingesperrt!",root,100,100,0);
									player:sendNotification("Du hast "..getPlayerName(v).." eingesperrt.");
									v:sendNotification("Du wurdest von "..getPlayerName(player).." für "..(math.round(getElementData(v,"Wanteds")*time)).." Minuten eingesperrt!",120,0,0);
									setElementData(v,"Wanteds",0);
									Levelsystem.givePoints(player,150);
								end
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onMarkerHit",Einknasten_SFPD,putPlayerInJailFromVehicle)
addEventHandler("onMarkerHit",Einknasten_SFPDHeli,putPlayerInJailFromVehicle)

-- Offline Flucht
local function playerQuit(quitType)
	if quitType ~= "Timed out" and quitType ~= "Bad Connection" then
		if source:getData("loggedin") == 1 and source:getData("Wanteds") > 0 then
			local x, y, z = getElementPosition(source);
			local players = getElementsWithinRange(x, y, z, 50, "player");
			local copNearby = false;
			for i, player in ipairs(players) do
				if (isCop(player) or isFBI(player) or isArmy(player)) and player:getData("Duty") == true then
					copNearby = true;
					outputChatBox("Der Gesuchte "..source:getName().." ist offline gegangen. Er wird beim nächsten Einloggen im Knast sein!", player, 200, 0, 0);
				end
			end
			if copNearby == true then
				local time = 5 + tonumber(source:getData("Wanteds")) * 4;
				source:setData("Knastzeit", time);
				source:setData("Wanteds", 0);
				offlineMessage(source:getName(), "Du hast beim letzten Ausloggen Offlineflucht begangen, du wurdest in das Gefängnis gesteckt.");
			end
		end
	end
end
addEventHandler("onPlayerQuit", root, playerQuit, true, "high-1")