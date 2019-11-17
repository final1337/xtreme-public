

Trucker = {
	["Marker"] = {
		{-2626.0729980469,217.79013061523,4.4669780731201},
		{-2439.5219726563,708.65466308594,35.013172149658},
		{-2314.6398925781,-154.66532897949,35.3203125},
	},
};

addEvent("Trucker.createMarker",true)
addEventHandler("Trucker.createMarker",root,function(type)
	if(isElement(Trucker.marker))then destroyElement(Trucker.marker)end
	if(isElement(Trucker.blip))then destroyElement(Trucker.blip)end
	if(type)then
		local rnd = math.random(1,#Trucker["Marker"]);
		local tbl = Trucker["Marker"][rnd];
		local x,y,z = tbl[1],tbl[2],tbl[3];
		Trucker.marker = createMarker(x,y,z,"checkpoint",3,255,0,0);
		Trucker.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Trucker.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Trucker.abgabe",localPlayer);
			end
		end)
	end
end)