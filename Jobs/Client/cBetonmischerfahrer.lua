
Betonmischerfahrer = {
	["Marker"] = {
		{2655.4758300781,854.73083496094,6.1712436676025},
		{2436.1398925781,1921.9760742188,6.1557140350342},
		{-2064.8520507813,279.85446166992,35.397327423096},
	},
};

addEvent("Betonmischerfahrer.createMarker",true)
addEventHandler("Betonmischerfahrer.createMarker",root,function(type)
	if(isElement(Betonmischerfahrer.marker))then destroyElement(Betonmischerfahrer.marker)end
	if(isElement(Betonmischerfahrer.blip))then destroyElement(Betonmischerfahrer.blip)end
	if(type)then
		local rnd = math.random(1,#Betonmischerfahrer["Marker"]);
		local tbl = Betonmischerfahrer["Marker"][rnd];
		local x,y,z = tbl[1],tbl[2],tbl[3];
		Betonmischerfahrer.marker = createMarker(x,y,z,"checkpoint",3,255,0,0);
		Betonmischerfahrer.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Betonmischerfahrer.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Betonmischerfahrer.abgabe",localPlayer);
			end
		end)
	end
end)