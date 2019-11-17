

Hanfsamentransporter = {};

function Hanfsamentransporter.createMarker(type)
	if(isElement(Hanfsamentransporter.abgabeMarker))then destroyElement(Hanfsamentransporter.abgabeMarker)end
	if(isElement(Hanfsamentransporter.blip))then destroyElement(Hanfsamentransporter.blip)end
	if(type)then
		Hanfsamentransporter.abgabeMarker = createMarker(2741.0954589844,-2009.7408447266,12.804699897766,"cylinder",4,0,0,0,0);
		Hanfsamentransporter.blip = createBlip(2741.0954589844,-2009.7408447266,12.804699897766,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Hanfsamentransporter.abgabeMarker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Hanfsamentransporter.abgabe",localPlayer);
			end
		end)
	end
end
addEvent("Hanfsamentransporter.createMarker",true)
addEventHandler("Hanfsamentransporter.createMarker",root,Hanfsamentransporter.createMarker)

function Hanfsamentransporter.destroy()
	if(isElement(Hanfsamentransporter.abgabeMarker))then destroyElement(Hanfsamentransporter.abgabeMarker)end
	if(isElement(Hanfsamentransporter.blip))then destroyElement(Hanfsamentransporter.blip)end
end
addEvent("Hanfsamentransporter.destroy",true)
addEventHandler("Hanfsamentransporter.destroy",root,Hanfsamentransporter.destroy)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		Hanfsamentransporter.destroy();
	end
end)