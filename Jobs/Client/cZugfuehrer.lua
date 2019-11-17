
Zugfuehrer = {};

function Zugfuehrer.createMarker(type)
	if(isElement(Zugfuehrer.marker))then destroyElement(Zugfuehrer.marker)end
	if(isElement(Zugfuehrer.blip))then destroyElement(Zugfuehrer.blip)end
	if(type)then
		Zugfuehrer.marker = createMarker(1733.25098,-1953.29150,15.63398,"checkpoint",2,255,0,0);
		Zugfuehrer.blip = createBlip(1733.25098, -1953.29150, 15.63398,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Zugfuehrer.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Zugfuehrer.abgabe",localPlayer);
				Zugfuehrer.createMarker("create");
			end
		end)
	end
end
addEvent("Zugfuehrer.createMarker",true)
addEventHandler("Zugfuehrer.createMarker",root,Zugfuehrer.createMarker)