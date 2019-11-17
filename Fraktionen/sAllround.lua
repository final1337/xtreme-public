--

-- [[ TABLES ]] --

Fraktionen = {
	["Namen"] = {
		[0] = "Zivilist",
		[1] = "SFPD",
		[2] = "F.B.I",
		[3] = "Army",
		[4] = "Reporter",
		[5] = "Da Nang Boys",
		[6] = "San Fierro Rifa",
		[7] = "Mafia",
		[8] = "Nordic Angels",
		[9] = "Feuerwehr",
		[10] = "Ballas",
		[11] = "Terroristen",
	},
	["Farben"] = {
		[0] = {255,255,255},
		[1] = {0,255,0},
		[2] = {188,237,8},
		[3] = {0,150,0},
		[4] = {255,127,0},
		[5] = {150,0,0},
		[6] = {0,162,255},
		[7] = {0,0,0},
		[8] = {158,94,41},
		[9] = {200,0,0},
		[10] = {101,18,104},
		[11] = {205,170,125},
		[12] = {225,225,0},
	},
	["Skins"] = {
		[1] = {284,281,280,266,267,265},
		[2] = {286,286,286,286,166,165},
		[3] = {312,287,287,287,287,61},
		[4] = {170,250,188,185,187,147},
		[5] = {122,121,186,120,123,49},
		[6] = {175,114,174,173,116,115},
		[7] = {124,111,112,125,126,113},
		[8] = {292,181,192,247,248,100},
		[9] = {277,277,277,277,278,279},
		[10] = {103,103,13,102,195,104},
		[11] = {30,179,127,222,221,220},
	},
	["Rangnamen"] = {
		[1] = {"Cadet","Officer","Sergeant","Captain","Assistant Chief","Chief of Police"},
		[2] = {"Trainee","Junior Agent","Special Agent","Supervisory Agent","Assistant Director","Director"},
		[3] = {"Private","Sergeant","Lieutenant","Major","Colonel","General"},
		[4] = {"Praktikant","Zeitungsbursche","Nachrichtensprecher","Journalist","Redakteur","Chefredakteur"},
		[5] = {"Hug Do","Hai Trong","Vu Chan","Quan Trong","Xon Chi","Xin Chan"},
		[6] = {"Novicio","Miembro","Trepador","Capitan","Baron","Jefe"},
		[7] = {"Giovane D'Honore","Capola","Picciotte","Sgarrista","Capo Bastone","Capo Crimini"},
		[8] = {"Newbie","Rider","Lowrider","Nightrider","Hellrider","Ghostrider"},
		[9] = {"Anwärter","Firefighter","Lieutnant","Captain","Assistant Chief","Chief"},
		[10] = {"Rookie","Dealer","Ricky Harris","Derrick Edmond","Little Weasel","Kane"},
		[11] = {"Kanonenfutter","Bully","Achmed","Kisto","Taliban","Bin Laden"},
	},
	["Spawns"] = {
		[0] = {-2754.4501953125,376.03469848633,4.138111114502,0,0},
		[1] = {222.2548828125,111.56640625,1010.2117919922,10,0},
		[2] = {326.61032104492,303.65188598633,999.1484375,5,0},
		[3] = {-1345.6518554688,491.06954956055,11.202690124512,0,0},
		[4] = {-2170.333984375,645.97332763672,1057.59375,1,0},
		[5] = {-2636.7141113281,1404.4771728516,906.4609375,3,0},
		[6] = {-2162.853515625,-223.81932067871,36.515625,0,0},
		[7] = {959.07214355469,-59.351169586182,1001.1171875,3,0},
		[8] = {-225.77104187012,1395.2117919922,28.359519958496,18,0},
		[9] = {234.66743,78.66093,1005.03906,6,0},
		[10] = {2569.2680664063,-1283.6324462891,1037.7734375,2,0},
		[11] = {490.23840332031,-77.500900268555,998.7578125,11,0},
	},
};

-- [[ IST SPIELER IN BÖSER FRAKTION? ]] --

function isEvil(player)
	local faction = getElementData(player,"Fraktion");
	if(faction == 5 or faction == 6 or faction == 7 or faction == 8 or faction == 10 or faction == 11)then
		return true
	else
		return false
	end
end

-- [[ FRAKTIONSMITGLIEDER ONLINE ]] --

function getMembersOnline(id)
	local counter = 0;
	for _,v in pairs(getElementsByType("player"))do
		if(getElementData(v,"Fraktion") == id)then
			counter = counter + 1;
		end
	end
	return counter;
end

-- [[ FRAKTIONSABFRAGEN ]] --

function isCop(player) if(getElementData(player,"Fraktion") == 1)then return true else return false end end
function isFBI(player) if(getElementData(player,"Fraktion") == 2)then return true else return false end end
function isArmy(player) if(getElementData(player,"Fraktion") == 3)then return true else return false end end
function isReporter(player) if(getElementData(player,"Fraktion") == 4)then return true else return false end end
function isDNB(player) if(getElementData(player,"Fraktion") == 5)then return true else return false end end
function isRifa(player) if(getElementData(player,"Fraktion") == 6)then return true else return false end end
function isMafia(player) if(getElementData(player,"Fraktion") == 7)then return true else return false end end
function isNordic(player) if(getElementData(player,"Fraktion") == 8)then return true else return false end end
function isFeuerwehr(player) if(getElementData(player,"Fraktion") == 9)then return true else return false end end
function isBallas(player) if(getElementData(player,"Fraktion") == 10)then return true else return false end end
function isTerrorist(player) if(getElementData(player,"Fraktion") == 11)then return true else return false end end
function isSwatDuty(player) return getElementModel(player) == 285 end
function isArmyOnDuty(player) return ( getElementModel(player) == 287 or getElementModel(player) == 61 ) end

-- [[ FRAKTIONSMESSAGE ]] --

function sendFactionMessage(faction,text,r,g,b)
	for _,v in pairs(getElementsByType("player"))do
		if(getElementData(v,"loggedin") == 1 and getElementData(v,"Fraktion") == faction)then
			outputChatBox(text,v,r,g,b,true);
		end
	end
end

addEvent("sendFactionMessage", true)
addEventHandler("sendFactionMessage", root, function(text, fraktion, r, g, b)
	for _, v in ipairs(fraktion)do
		outputChatBox(text, v, r, g, b)
	end
end)

-- [[ FRAKTIONSFAHRZEUG ERSTELLEN ]] --

DangerousVehicle = {520, 432, 425}

function createFactionVehicle(model,x,y,z,rx,ry,rz,faction,rang)
	
	if(model and x and y and z and rx and ry and rz and faction and rang)then
		if true then
			local veh = FactionVehicleClass.new(model,x,y,z,rx,ry,rz,Fraktionen["Namen"][faction], faction)
			veh:newAccess(faction, rang)
			return false
		end
		local vehicle;
		if faction == 9 then
			if model == 407 then
				vehicle = FireVehicleWater.create(x,y,z,rx,ry,rz, Fraktionen["Namen"][faction])
			elseif  model == 544 then
				vehicle = FireVehicleLadder.create(x,y,z,rx,ry,rz, Fraktionen["Namen"][faction])
			elseif model == 563 then
				vehicle = FireVehicleHelicopter.create(x,y,z,rx,ry,rz, Fraktionen["Namen"][faction])
			elseif model == 490 then
				vehicle = FireVehicle.create(490, x,y,z,rx,ry,rz, Fraktionen["Namen"][faction])
			else
				vehicle = createVehicle(model, x,y,z,rx,ry,rz, Fraktionen["Namen"][faction])
			end
		else
			vehicle = createVehicle(model, x,y,z,rx,ry,rz, Fraktionen["Namen"][faction])
		end		
		if vehicle then setVehicleRespawnPosition(vehicle, x, y, z, rx, ry, rz) end
		if(model ~= 407 and model ~= 544 and model ~= 596 and model ~= 599 and model ~= 597 and model ~= 427 and faction ~= 1)then
			setVehicleColor(vehicle,Fraktionen["Farben"][faction][1],Fraktionen["Farben"][faction][2],Fraktionen["Farben"][faction][3]);
		end
		setVehicleRespawnPosition (vehicle,x,y,z,rx,ry,rz)
		toggleVehicleRespawn ( vehicle, true )
		setVehicleIdleRespawnDelay(vehicle,10*60000)

		setElementData(vehicle,"Fraktion",faction);
		addFactionSirens(vehicle)
		if(faction == 2)then setVehicleColor(vehicle,0,0,0)end
		if(faction == 3)then setVehicleColor(vehicle,60,67,40,122,97,52)end
		setElementData(vehicle, "Fraktionsfahrzeug", faction)
		if not DangerousVehicle[model] then
			--[[addEventHandler("onVehicleEnter",vehicle,function(player)
				if(getPedOccupiedVehicleSeat(player) == 0)then
					if(getElementData(player,"Fraktion") == faction)then
						if(getElementData(player,"Rang") < rang)then
							infobox(player,"Du musst mindestens Rang "..rang.." sein, um dieses Fahrzeug fahren zu können!",120,0,0);
							ExitVehicle(player);
						end
					else
						infobox(player,"Du bist nicht befugt, dieses Fahrzeug zu fahren!",120,0,0);
						ExitVehicle(player);
					end
				end
			end)]]
		else
			--[[addEventHandler("onVehicleStartEnter",vehicle,function(player)
				if(getPedOccupiedVehicleSeat(player) == 0)then
					if(getElementData(player,"Fraktion") == faction)then
						if(getElementData(player,"Rang") < rang)then
							infobox(player,"Du musst mindestens Rang "..rang.." sein, um dieses Fahrzeug fahren zu können!",120,0,0);
							cancelEvent()
						end
					else
						infobox(player,"Du bist nicht befugt, dieses Fahrzeug zu fahren!",120,0,0);
					end
				end
			end)	]]		
		end
	end
end

--[[ FAHRZEUGSIRENE HINZUFÜGEN]] --

SirenFactions = {
	[1] = true,
	[2] = true,
	[3] = true,
	[9] = true,
}

function addFactionSirens(veh)
	if getElementData(veh, "Fraktion") and SirenFactions[getElementData(veh,"Fraktion")] then
		local model = getElementModel(veh)
		if model == 507 then -- Elegant
			removeVehicleSirens(veh)
			addVehicleSirens(veh, 2, 2, false, true, true, false)
			setVehicleSirens(veh, 1, -0.1, -0.1, 3.1, 107.1, 0, 0, 255, 0)
			setVehicleSirens(veh, 2, 0, -0.5, 0.8, 0, 0, 0, 198.9, 198.9)	
			return
		elseif model == 597 then
			removeVehicleSirens(veh)
			addVehicleSirens(veh, 7, 2, true, true, false, false)
			setVehicleSirens(veh, 1, -0.5, -0.4, 1, 255, 0, 0, 255, 255)
			setVehicleSirens(veh, 2, 0.5, -0.4, 1, 0, 0, 255, 255, 255)
			setVehicleSirens(veh, 3, 0, -0.4, 1, 255, 255, 255, 255, 255)
			setVehicleSirens(veh, 4, 0.6, 2.5, 0, 255, 255, 255, 255, 150)
			setVehicleSirens(veh, 5, -0.6, 2.5, 0, 255, 255, 255, 255, 150)
			setVehicleSirens(veh, 6, -0.65, -2.88, 0, 255, 0, 0, 255, 175)
			setVehicleSirens(veh, 7, 0.65, -2.88, 0, 255, 0, 0, 255, 175)
		
			return
		elseif getElementModel(veh) == 598 then
			removeVehicleSirens(veh)
			addVehicleSirens(veh, 7, 2, true, true, false, false)
			setVehicleSirens(veh, 1, -0.5, -0.4, 1, 255, 0, 0, 255, 255)
			setVehicleSirens(veh, 2, 0.5, -0.4, 1, 0, 0, 255, 255, 255)
			setVehicleSirens(veh, 3, 0, -0.4, 1, 255, 255, 255, 255, 255)
			setVehicleSirens(veh, 4, 0.6, 2.5, 0, 255, 255, 255, 255, 150)
			setVehicleSirens(veh, 5, -0.6, 2.5, 0, 255, 255, 255, 255, 150)
			setVehicleSirens(veh, 6, -0.65, -2.88, 0, 255, 0, 0, 255, 175)
			setVehicleSirens(veh, 7, 0.65, -2.88, 0, 255, 0, 0, 255, 175)
			return
		elseif getElementModel(veh) == 427 then
			removeVehicleSirens(veh)
			addVehicleSirens(veh, 8, 2, true, true, false, false)
			setVehicleSirens(veh, 1, 1.2, 0.1, 1.3, 255, 142.8, 0, 198.9, 198.9)
			setVehicleSirens(veh, 2, 1.2, -1.6, 1.3, 255, 145.4, 0, 200, 200)
			setVehicleSirens(veh, 3, 1.2, -3.4, 1.3, 255, 145.4, 0, 200, 200)
			setVehicleSirens(veh, 4, -1.2, 0.1, 1.3, 255, 145.4, 0, 200, 200)
			setVehicleSirens(veh, 5, -1.2, -1.6, 1.3, 255, 145.4, 0, 200, 200)
			setVehicleSirens(veh, 6, -1.2, -3.4, 1.3, 255, 145.4, 0, 200, 200)
			setVehicleSirens(veh, 7, -0.4, 1.1, 1.5, 255, 0, 0, 255, 255)
			setVehicleSirens(veh, 8, 0.4, 1.1, 1.5, 255, 0, 0, 255, 255)
			return
		end
		if getElementModel(veh) == 525 then
			addVehicleSirens(veh,1,2)
			addVehicleSirens(veh,2,2)
			setVehicleSirens(veh,1,0.3,0.5,0.35,255,0,0,255,255)
			setVehicleSirens(veh,2,-0.3,0.5,0.35,0,0,255,255,255)			
		end
		if getElementModel(veh) == 415 then
			addVehicleSirens(veh,1,2)
			addVehicleSirens(veh,2,2)
			setVehicleSirens(veh,1,0.3,0.5,0.35,255,0,0,255,255)
			setVehicleSirens(veh,2,-0.3,0.5,0.35,0,0,255,255,255)
		elseif getElementModel(veh) == 541 then
			addVehicleSirens(veh,1,2)
			addVehicleSirens(veh,2,2)
			setVehicleSirens(veh,1,0.3,1,0.35,255,0,0,255,255)
			setVehicleSirens(veh,2,-0.3,1,0.35,0,0,255,255,255)
		elseif getElementModel(veh) == 470 then
			addVehicleSirens(veh,1,2)
			addVehicleSirens(veh,2,2)
			setVehicleSirens(veh,1,0.3,1.0,0.5,255,0,0,255,255)
			setVehicleSirens(veh,2,-0.3,1.0,0.5,0,0,255,255,255)
		end
	end
end

-- [[ FRAKTIONSFAHRZEUGE RESPAWNEN ]] --
function respawnFactionVehicles(player, _, faction)
	if(getElementData(player,"loggedin") == 1)then
		if (getElementData(player,"Fraktion") >= 0 and getElementData(player,"Rang") >= 3) or getElementData(player,"Adminlevel") >= 1 then
			local fraktion
			if faction then
				fraktion = tonumber(faction)
				if Fraktionen["Namen"][fraktion] then
					player:sendMessage("Du hast die Fraktionsfahrzeuge von %s respawned.", 255, 255, 0, Fraktionen["Namen"][fraktion])
				end
			else
				fraktion = getElementData(player,"Fraktion")
			end

			local vehicles = vehiclemanager:getFactionVehicles(fraktion)

			for _,v in ipairs(vehicles) do
				--if(getElementData(v,"Fraktion") and getElementData(v,"Fraktion") == fraktion ) then
					if(v:isEmpty())then
						respawnVehicle(v);
						if v:getData("Tank") and v:getData("Tank") ~= 1 then
							v:setData("Tank", FireVehicle.MAX_TANK_SIZE)
							if getElementModel(v) == 563 then
								v:setData("Tank", 50000)	
							end
						end
					end
				--end
			end
			sendFactionMessage(fraktion, "Die Fraktionsfahrzeuge wurden respawned.", 255, 255, 0)
		end
	end
end
addCommandHandler("frespawn",respawnFactionVehicles)

-- [[ FRAKTIONSSKIN VERGEBEN ]] --

function giveFactionSkin(player)
	local faction = getElementData(player,"Fraktion");
	if(faction > 0)then
		local skin = Fraktionen["Skins"][faction][getElementData(player,"Rang")+1];
		setElementModel(player,skin);
		if(not(isCop(player)) and not(isFBI(player)) and not(isArmy(player)) and not(isReporter(player)) and not(isFeuerwehr(player)))then
			setElementData(player,"Skin",skin);
		end
	end
end

-- [[ TEAMCHAT ]] --

addCommandHandler("t",function(player,cmd,...)
	if(playerCanChat(player))then
		if(getElementData(player,"Fraktion") > 0)then
			local rang = Fraktionen["Rangnamen"][getElementData(player,"Fraktion")][getElementData(player,"Rang")+1];
			local text = {...};
			local text = table.concat(text," ");
			
			if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
				for _,v in pairs(getElementsByType("player"))do
					if(getElementData(v,"loggedin") == 1 and getElementData(v,"Fraktion") == getElementData(player,"Fraktion"))then
						outputChatBox(rang.." "..getPlayerName(player)..": "..text,v, 0, 255, 0);
					end
				end
			end
		end
	end
end)

-- [[ STAATSCHAT ]] --

addCommandHandler("g",function(player,cmd,...)
	if(playerCanChat(player))then
		if(getElementData(player,"Fraktion") > 0 and ( isCop(player) or isFBI(player) or isArmy(player) ))then
			local rang = Fraktionen["Rangnamen"][getElementData(player,"Fraktion")][getElementData(player,"Rang")+1]
			local text = {...} local text = table.concat(text," ");
			if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
				for _,v in pairs(getElementsByType("player"))do
					if(getElementData(v,"loggedin") == 1 and isCop(v) or isFBI(v) or isArmy(v))then
						outputChatBox("#197DE1[Staat] "..rang.." "..getPlayerName(player)..": #ffffff"..text,v,120,87,104,true);
					end
				end
			end
		end
	end
end)

-- [[ LEADERCHAT ]] --

addCommandHandler("l",function(player,cmd,...)
	if(playerCanChat(player))then
		if(getElementData(player,"Fraktion") > 0 and isEvil(player))then
			if(getElementData(player,"Rang") >= 4)then
				local rang = Fraktionen["Rangnamen"][getElementData(player,"Fraktion")][getElementData(player,"Rang")+1];
				local text = {...};
				local text = table.concat(text," ");
				
				if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
					for _,v in pairs(getElementsByType("player"))do
						if(getElementData(v,"loggedin") == 1 and getElementData(v,"Fraktion") > 0 and isEvil(v) and getElementData(v,"Rang") >= 4)then
							outputChatBox(rang.." "..getPlayerName(player)..": "..text,v,120, 87, 104);
						end
					end
				end
			end
		end
	end
end)

-- [[ NORDIC ANGELS ]] --

function loadFactionVehiclesFirst()

createFactionVehicle(463,-87.2998046875,1375.7998046875,9.8999996185303,0,0,243.98986816406,8,0); 		-- Freeway
createFactionVehicle(463,-87.1025390625,1374.1708984375,9.8999996185303,0,0,243.98986816406,8,0); 		-- Freway
createFactionVehicle(463,-86.7568359375,1372.318359375,9.8999996185303,0,0,243.98986816406,8,0); 		-- Freeway
createFactionVehicle(463,-86.5087890625,1370.5087890625,9.8999996185303,0,0,243.98986816406,8,0); 		-- Freeway
createFactionVehicle(463,-86.21875,1368.607421875,9.8999996185303,0,0,243.98986816406,8,0); 			-- Freeway
createFactionVehicle(521,-88.599609375,1365,9.8999996185303,0,0,189.99755859375,8,2); 					-- FCR
createFactionVehicle(521,-90.4638671875,1364.681640625,9.8999996185303,0,0,189.99755859375,8,2); 		-- FCR
createFactionVehicle(521,-92.4140625,1364.3671875,9.8999996185303,0,0,189.99755859375,8,2);   			-- FCR
createFactionVehicle(554,-82.0185546875,1339.6181640625,11.10000038147,0,0,6.74560546875,8,3);  		-- Yosemite
createFactionVehicle(554,-88.298828125,1339.013671875,10.800000190735,0,0,7.4981689453125,8,3);  		-- Yosemite
createFactionVehicle(580,-94.62890625,1338.37109375,10.300000190735,0,0,7.4981689453125,8,3);  			-- Stafford 
createFactionVehicle(413,-102.7998046875,1367.2998046875,10.39999961853,0,0,9.99755859375,8,3);  		-- Pony
createFactionVehicle(487,-96.800003051758,1350.0999755859,10.300000190735,0,0,95.744750976563,8,3);  	-- Sparrow

-- [[ DA NANG BOYS ]]-- 

createFactionVehicle(409,-2643.83203125,1378.50390625,6.9098000526428,0,0,270,5,2);  					-- Stretch
createFactionVehicle(521,-2643.1474609375,1333.0400390625,6.6096000671387,0,0,319.78454589844,5,0);  	-- FCR
createFactionVehicle(521,-2646.37890625,1333.263671875,6.5896000862122,0,0,319.78454589844,5,0);  		-- FCR
createFactionVehicle(413,-2645.154296875,1373.1865234375,7.0423997879028,0,0,270,5,3);  				-- Pony
createFactionVehicle(560,-2644.5988769531,1368.1429443359,7.0830001831055,0,0,270,5,1);  				-- Sultan
createFactionVehicle(560,-2644.5988769531,1363.0391845703,7.0830001831055,0,0,270,5,1);  				-- Sultan
createFactionVehicle(550,-2644.5988769531,1357.9816894531,7.0830001831055,0,0,270,5,1); 				-- Sunrise
createFactionVehicle(550,-2644.5988769531,1352.97265625,7.0830001831055,0,0,270,5,1); 					-- Sunrise
createFactionVehicle(402,-2645.150390625,1347.9130859375,6.4604998588562,0,0,270,5,4);  				-- Buffalo
createFactionVehicle(487,-2671.134765625,1340.6552734375,17.106000900269,0,0,270,5,3);  				-- Maverick
createFactionVehicle(446,-2444.9274902344,1590.5073242188,0,0,0,0,5,2); 								-- Squalo
createFactionVehicle(446,-2432.4736328125,1590.5078125,0,0,0,0,5,2); 									-- Squalo

-- [[ MAFIA ]] --

createFactionVehicle(413,-2732.01171875,-280.98901367188,7.1470999717712,0,0,180,7,3);  				-- Pony
createFactionVehicle(442,-2736.9091796875,-281.57400512695,6.875500202179,0,0,180,7,2); 				-- Romero
createFactionVehicle(579,-2727.0270996094,-281.14169311523,6.978099822998,0,0,180,7,1); 				-- Huntley
createFactionVehicle(579,-2722.0651855469,-281.14239501953,6.9319000244141,0,0,180,7,1); 				-- Huntley
createFactionVehicle(560,-2711.5075683594,-299.37680053711,6.7195000648499,0,0,314.23767089844,7,4); 	-- Sultan
createFactionVehicle(545,-2718.1159667969,-305.8655090332,6.8421001434326,0,0,314.23767089844,7,0); 	-- Hustler
createFactionVehicle(545,-2724.25390625,-311.923828125,6.8421001434326,0,0,314.23645019531,7,0); 		-- Hustler
createFactionVehicle(545,-2739.0056152344,-325.51470947266,6.8421001434326,0,0,304.47326660156,7,0); 	-- Hustler
createFactionVehicle(487,-2653.4890136719,-287.94088745117,12.123900413513,0,0,45.551147460938,7,3); 	-- Maverick
createFactionVehicle(521,-2682.9306640625,-281.41390991211,6.7445001602173,0,0,5.0242919921875,7,0); 	-- FCR
createFactionVehicle(521,-2685.0874023438,-283.44171142578,6.7445001602173,0,0,5.020751953125,7,0); 	-- FCR

-- [[ SAN FIERRO RIFA ]] --

createFactionVehicle(468,-2149.1162109375,-177.87190246582,34.992099761963,0,0,343.35595703125,6,0); 	-- Sanchez
createFactionVehicle(468,-2146.662109375,-177.87890625,34.979499816895,0,0,343.35571289063,6,0); 		-- Sanchez
createFactionVehicle(468,-2144.2763671875,-177.96389770508,34.992099761963,0,0,343.35571289063,6,0);	-- Sanchez
createFactionVehicle(402,-2147.4326171875,-185.0283203125,35.142700195313,0,0,270,6,3); 				-- Buffalo
createFactionVehicle(560,-2147.783203125,-188.7275390625,35.016101837158,0,0,270,6,0); 					-- Sultan
createFactionVehicle(560,-2147.783203125,-192.322265625,35.016101837158,0,0,270,6,0); 					-- Sultan
createFactionVehicle(567,-2156.68359375,-203.0625,35.298698425293,0,0,90,6,2); 							-- Savanna
createFactionVehicle(567,-2156.68359375,-199.32421875,35.298698425293,0,0,90,6,2); 						-- Savanna
createFactionVehicle(482,-2156.43359375,-195.4453125,35.431701660156,0,0,90,6,3); 						-- Burrito
createFactionVehicle(482,-2156.43359375,-191.875,35.431701660156,0,0,90,6,3); 							-- Burrito
createFactionVehicle(534,-2174.162109375,-220.97169494629,35.042400360107,0,0,270,6,4); 				-- Remington
createFactionVehicle(409,-2136.1115722656,-229.12680053711,35.073101043701,0,0,0,6,2); 					-- Stretch
createFactionVehicle(487,-2119.3215332031,-186.86250305176,46.369899749756,0,0,90,6,3); 				-- Maverick

-- [[ NORDIC ANGELS SF ]] --

createFactionVehicle(463,-2237.822265625,156.166015625,34.814701080322,0,0,34.667358398438,8,0); 		-- Freeway
createFactionVehicle(463,-2235.2021484375,156.19140625,34.83570098877,0,0,34.667358398438,8,0); 		-- Freeway
createFactionVehicle(463,-2232.5927734375,156.3154296875,34.839900970459,0,0,34.667358398438,8,0); 		-- Freeway
createFactionVehicle(463,-2237.76171875,164.5419921875,34.83570098877,0,0,133.12133789063,8,0);			-- Freeway
createFactionVehicle(463,-2235.0634765625,164.53515625,34.814701080322,0,0,133.12133789063,8,0); 		-- Freeway
createFactionVehicle(463,-2232.330078125,164.4130859375,34.814701080322,0,0,133.12133789063,8,0); 		-- Freeway
createFactionVehicle(413,-2228.3740234375,160.392578125,35.411499023438,0,0,90,8,3); 					-- Pony

-- [[ SFPD ]] --

createFactionVehicle(597,-1616.6999511719,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1612.5515136719,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1608.4952392578,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1604.4051513672,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1600.2774658203,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1596.2208251953,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1592.1977539063,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1588.0568847656,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1583.9626464844,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1579.8055419922,750.1875,-5.4897999763489,0,0,180,1,0); 						-- Police SF
createFactionVehicle(597,-1572.4761962891,742.68017578125,-5.4897999763489,0,0,90,1,0); 				-- Police SFf
createFactionVehicle(597,-1572.4761962891,738.65747070313,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,734.66772460938,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,730.61541748047,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,726.56317138672,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,722.33502197266,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,718.24908447266,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,714.15521240234,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,710.09899902344,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(597,-1572.4761962891,706.04187011719,-5.4897999763489,0,0,90,1,0); 				-- Police SF
createFactionVehicle(523,-1586.7982177734,695.73779296875,-5.6868000030518,0,0,209.11926269531,1,1); 	-- Polizei Motorrad
createFactionVehicle(523,-1589.6292724609,695.73040771484,-5.6868000030518,0,0,209.11926269531,1,1); 	-- Polizei Motorrad
createFactionVehicle(523,-1592.1485595703,695.72137451172,-5.6868000030518,0,0,209.11926269531,1,1); 	-- Polizei Motorrad
createFactionVehicle(523,-1594.6372070313,695.72149658203,-5.6868000030518,0,0,209.11926269531,1,1); 	-- Polizei Motorrad
createFactionVehicle(523,-1596.9073486328,695.71478271484,-5.6868000030518,0,0,209.12109375,1,1); 		-- Polizei Motorrad
createFactionVehicle(427,-1596.1026611328,676.51177978516,-5.1076002120972,0,0,0,1,3); 					-- Entforcer
createFactionVehicle(427,-1600.2406005859,676.51177978516,-5.1076002120972,0,0,0,1,3); 					-- Entforcer
createFactionVehicle(599,-1612.5479736328,731.83618164063,-5.0796999931335,0,0,0,1,4); 					-- Police Ranger
createFactionVehicle(599,-1616.6358642578,731.83618164063,-5.0796999931335,0,0,0,1,4); 					-- Police Ranger
createFactionVehicle(497,-1679.6060791016,706.01220703125,30.698600769043,0,0,90,1,3);					-- Police Maverick
createFactionVehicle(430,-1477.3563232422,696.75708007813,0,0,0,180,1,2); 								-- Predator
createFactionVehicle(430,-1477.3701171875,683.71484375,0,0,0,180,1,2); 									-- Predator

-- [[ FBI ]] --

createFactionVehicle(415,-2429.9072265625,515.65521240234,29.695199966431,0,0,217.49322509766,2,3); 	-- Cheetah
createFactionVehicle(415,-2425.9887695313,518.69689941406,29.695199966431,0,0,222.19116210938,2,3); 	-- Cheetah
createFactionVehicle(490,-2416.8347167969,528.48059082031,29.929899215698,0,0,239.28259277344,2,0); 	-- FBI Rancher
createFactionVehicle(490,-2415.0205078125,531.92529296875,29.675100326538,0,0,248.09216308594,2,0); 	-- FBI Rancher
createFactionVehicle(490,-2413.798828125,535.671875,30.05708694458,0,0,260,2,0); 						-- FBI Rancher
createFactionVehicle(490,-2413.4833984375,539.94921875,30.058135986328,0,0,267,2,0); 					-- FBI Rancher
createFactionVehicle(528,-2422.19116210938,521.49957275391,30.249799728394,0,0,226.16998291016,2,2); 	-- FBI Truck
createFactionVehicle(601,-2419.0979003906,524.85308837891,30.249799728394,0,0,231.71691894531,2,3); 	-- SWAT 
createFactionVehicle(497,-2466.6433105469,523.33697509766,51.328800201416,0,0,180,2,3); 				-- Police Maverick
createFactionVehicle(427,-2437.8125,521.9345703125,30.033946990967,0,0,180,2,1); 						-- Enforcer

-- [[ REPORTER ]] --

createFactionVehicle(582,-2535.5771484375,-602.75830078125,132.62869262695,0,0,180,4,0); 				-- Newsvan
createFactionVehicle(582,-2531.7507324219,-602.75830078125,132.62869262695,0,0,180,4,0); 				-- Newsvan
createFactionVehicle(582,-2528.0830078125,-602.75830078125,132.62869262695,0,0,180,4,0); 				-- Newsvan
createFactionVehicle(582,-2524.3544921875,-602.7578125,132.62869262695,0,0,180,4,0); 				    -- Newsvan
createFactionVehicle(405,-2520.701171875,-602.3896484375,132.4449005127,0,0,180,4,2); 				    -- Sentinel
createFactionVehicle(402,-2516.8994140625,-602.36328125,132.40649414063,0,0,180,4,4); 				    -- Buffalo
createFactionVehicle(409,-2494.498046875,-602.4716796875,132.3050994873,0,0,180,4,3); 				    -- Stretch
createFactionVehicle(586,-2536.28125,-618.638671875,132.09230041504,0,0,337.91748046875,4,1); 	        -- Wayfarer
createFactionVehicle(586,-2534.0234375,-618.6298828125,132.09230041504,0,0,337.91748046875,4,1); 		-- Wayfarer
createFactionVehicle(586,-2531.6474609375,-618.6669921875,132.09230041504,0,0,337.91748046875,4,1); 	-- Wayfarer
createFactionVehicle(488,-2521.4404296875,-648.72229003906,148.17129516602,0,0,0,4,3); 					-- News Chopper

-- [[ BALLAS ]] --

createFactionVehicle(471,1067.1235351563,-287.15438842773,73.44539642334,0,0,180,10,1); 				-- Quad
createFactionVehicle(471,1070.7474365234,-287.15438842773,73.44539642334,0,0,180,10,1); 				-- Quad
createFactionVehicle(471,1073.9836425781,-287.15438842773,73.44539642334,0,0,180,10,1); 				-- Quad
createFactionVehicle(471,1077.3302001953,-287.15438842773,73.44539642334,0,0,180,10,1); 				-- Quad
createFactionVehicle(600,1090.3239746094,-292.19131469727,73.703796386719,0,0,90,10,0); 				-- Picador
createFactionVehicle(536,1089.865234375,-296.54730224609,73.737197875977,0,0,90,10,0); 					-- Blade
createFactionVehicle(522,1089.7607421875,-300.86221313477,73.737197875977,0,0,90,10,4); 				-- NRG-500
createFactionVehicle(517,1089.5528564453,-314.58679199219,73.856498718262,0,0,90,10,1); 				-- Majestic
createFactionVehicle(560,1089.9538574219,-318.44061279297,73.692199707031,0,0,90,10,3); 				-- Sultan
createFactionVehicle(560,1089.962890625,-322.2373046875,73.692199707031,0,0,90,10,3); 					-- Sultan
createFactionVehicle(487,1115.8210449219,-340.64581298828,74.093399047852,0,0,90,10,2); 				-- Maverick

-- [[ TERRORISTEN ]] --

createFactionVehicle(554,-777.9462890625,2420.658203125,157.35081481934,0,0,59.765625,11,3); 			-- Yosemite
createFactionVehicle(554,-779.7001953125,2417.8076171875,157.35081481934,0,0,57.183837890625,11,3); 	-- Yosemite
createFactionVehicle(476,-659.9697265625,2321.8037109375,139.28750610352,0,0,177.55554199219,11,3); 	-- Rustler
createFactionVehicle(579,-812.6708984375,2419.9794921875,156.74667358398,0,0,260.10681152344,11,1); 	-- Huntley
createFactionVehicle(487,-808.830078125,2434.5361328125,157.3217010498,0,0,244.54467773438,11,3); 		-- Maverick
createFactionVehicle(402,-811.88671875,2425.427734375,156.94158935547,0,0,260.43640136719,11,5);		-- Buffalo
createFactionVehicle(560,-773.732421875,2442.646484375,156.86470031738,0,0,136.91162109375,11,0); 		-- Sultan
createFactionVehicle(560,-771.443359375,2440.6162109375,156.84419250488,0,0,135.19775390625,11,0); 		-- Sultan
createFactionVehicle(495,-768.1728515625,2437.48828125,157.2463684082,0,0,133.21472167969,11,4); 		-- Sandking
createFactionVehicle(568,-765.5966796875,2435.720703125,156.99308776855,0,0,133.07189941406,11,0); 		-- Bandito
createFactionVehicle(468,-763.3984375,2431.279296875,156.78269958496,0,0,89.994506835938,11,0); 		-- Sanchez
createFactionVehicle(468,-763.37109375,2429.57421875,156.78269958496,0,0,88.126831054688,11,0); 		-- Sanchez
createFactionVehicle(468,-763.4716796875,2427.75,156.78269958496,0,0,88.126831054688,11,0); 			-- Sanchez

-- [[ FEUERWEHR ]] --

createFactionVehicle(563,-2083.576171875,93.4345703125,41.979499816895,0,0,270,9,3); 					-- Raindance
createFactionVehicle(490,-2051.361328125,73.404296875,28.710800170898,0,0,90,9,4); 						-- FBI Rancher
createFactionVehicle(490,-2051.3610839844,77.404197692871,28.710800170898,0,0,90,9,4); 					-- FBI Rancher
createFactionVehicle(407,-2052.16015625,82.00479888916,28.756099700928,0,0,90,9,0); 					-- Fire Truck 1
createFactionVehicle(407,-2052.2141113281,86.101898193359,28.756099700928,0,0,90,9,0); 					-- Fire Truck 1
createFactionVehicle(407,-2022.4841308594,92.741302490234,28.28989982605,356.32800292969,0,270,9,0); 	-- Fire Truck 1
createFactionVehicle(407,-2022.6055908203,84.039596557617,28.28989982605,356.32507324219,0,270,9,0); 	-- Fire Truck 1
createFactionVehicle(525,-2023.2833251953,75.700401306152,28.231199264526,357.083984375,0,270,9,0); 	-- Towtruck
createFactionVehicle(544,-2056.1179199219,95.656799316406,28.609399795532,0,0,90,9,0); 					-- Fire Truck Ladder
createFactionVehicle(544,-2056.0192871094,90.731101989746,28.609399795532,0,0,90,9,0); 					-- Fire Truck Ladder
createFactionVehicle(416,-2064.7509765625, 51.365234375, 28.814800262451,0,0,270,9,0); 					-- Ambulance
createFactionVehicle(416,-2064.7509765625, 55.3134765625, 28.814800262451,0,0,270,9,0); 				-- Ambulance

-- [[ BUNDESWEHR SF ]] --
 
 createFactionVehicle(548,-1416.0830078125,492.408203125,19.818700790405,0,0,270,3,0); 					-- Cargobob
 createFactionVehicle(520,-1396.826171875,507.6396484375,18.893600463867,0,0,270,3,2); 					-- Hydra
 createFactionVehicle(520,-1364.5546875,507.5986328125,18.893600463867,0,0,270,3,2); 					-- Hydra
 createFactionVehicle(520,-1456.5999755859,501.39999389648,12.10000038147,0,0,270,3,2); 					-- Hydra
 createFactionVehicle(520,-1414,503,12.10000038147,0,0,0,3,2); 					-- Hydra
 createFactionVehicle(425,-1288.5672607422,491.93600463867,18.980400085449,0,0,270,3,3); 				-- Hunter
 createFactionVehicle(541,-1339.9004,455.2998,6.9,0,0,0,3,3); -- Bullet
 createFactionVehicle(541,-1344,455.2998,6.9,0,0,0,3,3); -- Bullet
 createFactionVehicle(598,-1349.7,455.89999,7.1,0,0,0,3,3); -- LVPD
 createFactionVehicle(598,-1354.2,455.89999,7.1,0,0,0,3,3); -- LVPD
 createFactionVehicle(470,-1360.4,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1365.2,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1369.8,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1374.6,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1379.7,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1384.7,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1389.9,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(470,-1395.1,455.89999,7.3,0,0,0,3,0); -- Patriot
 createFactionVehicle(432,-1424.8,458.02319,7.3,0,0,0,3,2); -- Rhino
 createFactionVehicle(432,-1431.4,458.02319,7.3,0,0,0,3,2); -- Rhino
 createFactionVehicle(433,-1403.5,458.5,7.8,0,0,0,3,0); -- Barracks
 createFactionVehicle(433,-1409,458.5,7.8,0,0,0,3,0); -- Barracks
 createFactionVehicle(433,-1415,458.5,7.8,0,0,0,3,0); -- Barracks
 createFactionVehicle(497,-1505.1999511719,448,43.700000762939,0,0,90,3,0); -- Maverick
 createFactionVehicle(497,-1505.1999511719,424.79998779297,43.700000762939,0,0,90,3,0); -- Maverick
 createFactionVehicle(497,-1505.1999511719,399.20001220703,43.700000762939,0,0,90,3,0); -- Maverick
 createFactionVehicle(469,-1505.1999511719,374.20001220703,43.700000762939,0,0,90,3,0); -- Sparrow

-- [[ BUNDESWEHR AREA 51 ]] --
 
 createFactionVehicle(470,191.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(470,196.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(470,201.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(470,206.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(470,211.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(470,216.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(470,221.9521484375,1920.5234375,17.607799530029,0,0,180,3,0); 					-- Patriot
 createFactionVehicle(548,309.1669921875,1808.7685546875,19.200500488281,0,0,0,3,2); 					-- Cargobob
 createFactionVehicle(520,274.8134765625,2023.669921875,18.278799057007,0,0,270,3,3); 					-- Hydra
 createFactionVehicle(432,271.80078125,1989.55078125,17.681200027466,0,0,270,3,3); 						-- Rhino
 createFactionVehicle(433,271.740234375,1961.189453125,18.07200050354,0,0,270,3,2); 					-- Barracks
 createFactionVehicle(433,271.740234375,1956.189453125,18.07200050354,0,0,270,3,2); 					-- Barracks
 createFactionVehicle(433,271.740234375,1951.189453125,18.07200050354,0,0,270,3,2);						-- Barracks

 createFactionVehicle(425,307.9162902832,2048.9819335938,18.390800476074,0,0,180,3,3); 					-- Hunter
 

end