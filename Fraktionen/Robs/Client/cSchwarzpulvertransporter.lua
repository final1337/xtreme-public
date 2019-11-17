

Schwarzpulvertransport = {};

addEvent("Schwarzpulvertransport.createWindow",true)
addEventHandler("Schwarzpulvertransport.createWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(785, 406, 335, 265,"Schwarzpulvertransporter",1920,1080);
		Elements.button[1] = Button:create(885, 597, 130, 43,"Starten","Schwarzpulvertransport.start",1920,1080);
		Elements.rectangle[1] = Rectangle:create(785, 466, 335, 19,240,100,0,207,1920,1080);
		Elements.text[1] = Text:create(785, 482, 1116, 577,"Hier hast du die Möglichkeit, einen Schwarzpulvertransporter zu beladen.",1920,1080);
		setWindowDatas();
	end
end)

function Schwarzpulvertransport.start()
	triggerServerEvent("Schwarzpulvertransport.start",localPlayer);
end

function Schwarzpulvertransport.createMarker(type)
	if(isElement(Schwarzpulvertransport.marker))then destroyElement(Schwarzpulvertransport.marker)end
	if(isElement(Schwarzpulvertransport.blip))then destroyElement(Schwarzpulvertransport.blip)end
	if(type)then
		local fac = getElementData(localPlayer,"Fraktion");
		local x,y,z = Drogentruck["Abgabemarker"][fac][1],Drogentruck["Abgabemarker"][fac][2],Drogentruck["Abgabemarker"][fac][3];
		Schwarzpulvertransport.marker = createMarker(x,y,z,"checkpoint",3,255,0,0);
		Schwarzpulvertransport.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Schwarzpulvertransport.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Schwarzpulvertransport.abgabe",localPlayer);
			end
		end)
	end
end
addEvent("Schwarzpulvertransport.createMarker",true)
addEventHandler("Schwarzpulvertransport.createMarker",root,Schwarzpulvertransport.createMarker)