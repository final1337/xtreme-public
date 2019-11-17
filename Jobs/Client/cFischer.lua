

Fischer = {};

addEvent("Fischer.createMarker",true)
addEventHandler("Fischer.createMarker",root,function(type)
	setElementData(localPlayer,"FischerjobFische",0);
	if(isElement(Fischer.marker))then destroyElement(Fischer.marker)end
	if(isElement(Fischer.blip))then destroyElement(Fischer.blip)end
	if(isTimer(Fischer.checkTimer))then killTimer(Fischer.checkTimer)end
	if(type)then
		Fischer.marker = createMarker(-1717.0786132813,1419.0155029297,-0.55000001192093,"checkpoint",2,255,0,0);
		Fischer.blip = createBlip(-1717.0786132813,1419.0155029297,-0.55000001192093,0,2,255,0,0);
		Fischer.x,Fischer.y,Fischer.z = getElementPosition(localPlayer);
		Fischer.checkTimer = setTimer(function()
			local fische = math.floor(getElementData(localPlayer,"FischerjobFische"));
			Fischer.xNew,Fischer.yNew,Fischer.zNew = getElementPosition(localPlayer);
			local distance = getDistanceBetweenPoints3D(Fischer.x,Fischer.y,Fischer.z,Fischer.xNew,Fischer.yNew,Fischer.zNew);
			if(fische <= 10000)then
				setElementData(localPlayer,"FischerjobFische",fische+distance/2);
				local fische = math.floor(getElementData(localPlayer,"FischerjobFische"));
				Fischer.x,Fischer.y,Fischer.z = Fischer.xNew,Fischer.yNew,Fischer.zNew;
				if(getElementData(localPlayer,"Language") == "DE")then
					infobox("Du hast "..fische.."/10.000 Gramm Fisch im Netz.",0,120,0);
				else
					infobox("You have "..fische.."/10,000 grams of fish in the net.",0,120,0);
				end
				if(fische > 10000)then setElementData(localPlayer,"FischerjobFische",10000) end
			end
		end,2500,0)
		
		addEventHandler("onClientMarkerHit",Fischer.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Fischer.abgabe",localPlayer);
			end
		end)
	end
end)