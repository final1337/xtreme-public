--

Reporter = {};

-- [[ BARRIKADEN PLATZIEREN ]] --

function Reporter.placeBarricade(player)
	if(getElementData(player,"loggedin") == 1 and isReporter(player))then
		if(getElementDimension(player) == 0 and getElementInterior(player) == 0)then
			local x,y,z = getElementPosition(player);
			local rot = getPedRotation(player);
			Reporter.barricade = createObject(3578,x,y,z-0.5,0,0,rot);
			setElementData(Reporter.barricade,"ReporterBarricade",true);
			setElementCollisionsEnabled(Reporter.barricade,false);
			local barricade = Reporter.barricade
			setTimer(function(barricade)
				setElementCollisionsEnabled(barricade,true);
			end,2500,1,barricade)
		else infobox(player,"Hier nicht möglich!",120,0,0)end
	end
end
addEvent("Reporter.placeBarricade",true)
addEventHandler("Reporter.placeBarricade",root,Reporter.placeBarricade)
addCommandHandler("placeBarricade",Reporter.placeBarricade)

-- [[ MARKER PLATZIEREN ]] --

function Reporter.placeMarker(player,cmd,type,r,g,b)
	if(getElementData(player,"loggedin") == 1 and isReporter(player))then
		if(isElement(Reporter.marker))then destroyElement(Reporter.marker)end
		if(isElement(Reporter.blip))then destroyElement(Reporter.blip)end
			if(getElementDimension(player) == 0 and getElementInterior(player) == 0)then
				local x,y,z = getElementPosition(player);
				if(not(r) and not(g) and not(b))then
					r,g,b = 255,0,0;
				else
					r,g,b = tonumber(r),tonumber(g),tonumber(b);
					if(r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255)then
						Reporter.marker = createMarker(x, y, z, "corona", 1, r, g, b, 255, root)
						Reporter.blip = createBlip(x, y, z, 0, 2, r, g, b, 255, 0, 99999, root)
					else
						infobox(player,"Ungültiger RGB-Code!",120,0,0);
						return false
					end
				end
			Reporter.marker = createBlip(x,y,z,0,2,r,g,b);
		else infobox(player,"Hier nicht möglich!",120,0,0)end
	end
end
addEvent("Reporter.placeMarker",true)
addEventHandler("Reporter.placeMarker",root,Reporter.placeMarker)
addCommandHandler("placeMarker",Reporter.placeMarker)

function Reporter.destroyMarker(player)
	if isReporter(player) then
		if(isElement(Reporter.marker))then destroyElement(Reporter.marker)end
		if(isElement(Reporter.blip))then destroyElement(Reporter.blip)end
	end
end
addEvent("Reporter.destroyMarker",true)
addEventHandler("Reporter.destroyMarker",root,Reporter.destroyMarker)
addCommandHandler("destroyMarker",Reporter.destroyMarker)

function Reporter.destroyBarricade(player)
	if isReporter(player) then
		if(isElement(Reporter.barricade))then destroyElement(Reporter.barricade)end
	end
end
addEvent("Reporter.destroyBarricade",true)
addEventHandler("Reporter.destroyBarricade",root,Reporter.destroyBarricade)
addCommandHandler("destroyBarricade",Reporter.destroyBarricade)

-- [[ NEWS ]] --

function Reporter.news(player,cmd,...)
	if(getElementData(player,"loggedin") == 1 and isReporter(player))then
		if(playerCanChat(player))then
			local veh = getPedOccupiedVehicle(player);
			if veh and (getElementData(veh,"Fraktion") == 4)then
				local text = {...};
				local text = table.concat(text," ");
				
				if(text ~= nil and text ~= "" and text ~= " " and text ~= "  ")then
					outputChatBox("Reporter "..getPlayerName(player)..": "..text,v,250,150,0);
				end
			else infobox(player,"Nur in Reporterfahrzeugen möglich!",120,0,0)end
		end
	end
end
addCommandHandler("news",Reporter.news)

-- [[ LIVE SCHALTEN ]] --

function Reporter.live(player,cmd,target)
	if(getElementData(player,"loggedin") == 1 and isReporter(player))then
		if(target)then
			local target = getPlayerFromName(target);
			if(isElement(target) and getElementData(target,"loggedin") == 1)then
				local veh = getPedOccupiedVehicle(player);
				if(getElementData(veh,"Fraktion") == 4)then
					if(getElementData(target,"Live") ~= true)then
						setElementData(target,"Live",true);
						infobox(target,"Du bist nun live!",0,120,0);
						infobox(player,getPlayerName(target).." ist nun live.",0,120,0);
					else
						setElementData(target,"Live",false);
						infobox(target,"Du bist nun nicht mehr live!",120,0,0);
						infobox(player,getPlayerName(target).." ist nun nicht mehr live.",120,0,0);
					end
				else infobox(player,"Nur in Reporterfahrzeugen möglich!",120,0,0)end
			else infobox(player,"Spieler konnte nicht gefunden werden!",120,0,0)end
		else infobox(player,"Du hast keinen Spieler mit angegeben!",120,0,0)end
	end
end
addCommandHandler("live",Reporter.live)

-- [[ RAMPEN PLATZIEREN ]] --

function Reporter.placeRamp(player)
	if(getElementData(player,"loggedin") == 1 and isReporter(player))then
		if(getElementDimension(player) == 0 and getElementInterior(player) == 0)then
			local x,y,z = getElementPosition(player);
			local rot = getPedRotation(player);
			local ramp = createObject(13645,x,y,z-0.3,0,0,rot);
			setElementData(ramp,"ReporterRamp",true);
			setElementCollisionsEnabled(ramp,false);
			setTimer(function(ramp)
				setElementCollisionsEnabled(ramp,true);
			end,2500,1,ramp)
		else infobox(player,"Hier nicht möglich!",120,0,0)end
	end
end
addEvent("Reporter.placeRamp",true)
addEventHandler("Reporter.placeRamp", root, Reporter.placeRamp)
addCommandHandler("placeRamp",Reporter.placeRamp)

-- [[ WETTER VERÄNDERN ]] --

function Reporter.changeWeather(weather)
	if(isReporter(client))then
	
	end
end
addEvent("Reporter.changeWeather",true)
addEventHandler("Reporter.changeWeather",root,Reporter.changeWeather)

-- [[ REPORTER ZAUN ENTFERNEN ]] --

removeWorldModel(1411,4000,-2484.1755,-601.57739,134.74283)
removeWorldModel(1411,4000,-2484.2874,-607.36774,134.58246)
removeWorldModel(1411,4000,-2491.8984,-594.289,134.62491)
removeWorldModel(1411,4000,-2499.1829,-594.48187,134.34781)
removeWorldModel(1411,4000,-2515.2244,-594.23279,134.70564)
removeWorldModel(1411,4000,-2508.9304,-594.29907,134.61038)
removeWorldModel(1411,4000,-2522.7766,-594.23059,134.70872)
removeWorldModel(1411,4000,-2527.8853,-594.1449,134.83183)
removeWorldModel(1411,4000,-2534.2532,-594.18329,134.77672)
removeWorldModel(1411,4000,-2538.5139,-594.28821,134.62602)