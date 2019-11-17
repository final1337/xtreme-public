
Biketruck = {};

addEvent("Biketruck.createMarker",true)
addEventHandler("Biketruck.createMarker",root,function(type)
	if(isElement(Biketruck.marker))then destroyElement(Biketruck.marker)end
	if(isElement(Biketruck.blip))then destroyElement(Biketruck.blip)end
	if(type)then
		Biketruck.marker = createMarker(-2252.1086425781,104.47883605957,35.171875,"checkpoint",2,255,0,0);
		Biketruck.blip = createBlip(-2252.1086425781,104.47883605957,35.171875,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Biketruck.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Biketruck.abgabe",localPlayer);
			end
		end,false)
	end
end)

addEvent("Biketruck.openWindow",true)
addEventHandler("Biketruck.openWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(785, 406, 335, 265,"Biketransporter",1920,1080);
		Elements.button[1] = Button:create(885, 597, 130, 43,"Starten","Biketruck.start",1920,1080);
		Elements.rectangle[1] = Rectangle:create(785, 468, 335, 19,240,100,0,207,1920,1080);
		Elements.text[1] = Text:create(785, 482, 1116, 577,"Hier hast du die Möglichkeit, einen Biketransport zu starten, um den Bikeshop zu befüllen.\nAchte darauf, dass dieser nicht bereits voll ist!",1920,1080);
		setWindowDatas();
	end
end)

function Biketruck.start()
	triggerServerEvent("Biketruck.start",localPlayer);
end