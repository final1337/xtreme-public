
Bergarbeiter = {blips = {}, marker = {},
	["Marker"] = {
		{-1080.5007324219,-1556.3499755859,76.502700805664,37},
		{-1192.8581542969,-1666.3718261719,82.191299438477,30},
		{-1045.9241943359,-1684.5185546875,73.446998596191,25},
	},
};

local TXD = engineLoadTXD("Files/Mods/Pickaxe.txd",336);
engineImportTXD(TXD,336);
local DFF = engineLoadDFF("Files/Mods/Pickaxe.dff",336);
engineReplaceModel(DFF,336);

addEvent("Bergarbeiter.createStuff",true)
addEventHandler("Bergarbeiter.createStuff",root,function(type)
	for i = 1,3 do
		if(isElement(Bergarbeiter.blips[i]))then
			destroyElement(Bergarbeiter.blips[i]);
		end
	end
	for i = 1,3 do
		if(isElement(Bergarbeiter.marker[i]))then
			destroyElement(Bergarbeiter.marker[i]);
		end
	end
	unbindKey("fire","down",Bergarbeiter.click);
	if(type)then
		for i,v in ipairs(Bergarbeiter["Marker"])do
			Bergarbeiter.blips[i] = createBlip(v[1],v[2],v[3],11,3,20);
		end
		for i,v in ipairs(Bergarbeiter["Marker"])do
			Bergarbeiter.marker[i] = createMarker(v[1],v[2],v[3],"cylinder",v[4],0,0,0,0);
			addEventHandler("onClientMarkerHit",Bergarbeiter.marker[i],function(player)
				if(player == localPlayer)then
					setElementData(localPlayer,"BergarbeiterMarker",i);
				end
			end)
			addEventHandler("onClientMarkerLeave",Bergarbeiter.marker[i],function(player)
				if(player == localPlayer)then
					setElementData(localPlayer,"BergarbeiterMarker",false);
				end
			end)
		end
		bindKey("fire","down",Bergarbeiter.click);
	end
end)

function Bergarbeiter.click()
	if(isElementWithinMarker(localPlayer,Bergarbeiter.marker[1]) or isElementWithinMarker(localPlayer,Bergarbeiter.marker[2]) or isElementWithinMarker(localPlayer,Bergarbeiter.marker[3]))then
		triggerServerEvent("Bergarbeiter.click",localPlayer);
	end
end