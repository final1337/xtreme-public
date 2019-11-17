

Drogentruck = {
	["Abgabemarker"] = {
		[5] = {-2612.0068359375,1361.7154541016,7.0650000572205},
		[6] = {-2124.7937011719,-97.387496948242,35.320301055908},
		[7] = {-2767.4252929688,-329.18188476563,7.0391001701355},
		[8] = {-86.736297607422,1356.1502685547,10.351300239563},
		[10] = {1036.8955078125, -331.765625, 72.9921875},
	},
};

addEvent("Drogentruck.openWindow",true)
addEventHandler("Drogentruck.openWindow",root,function(fkasse)
	if(isWindowOpen())then
		Drogentruck.fkasse = fkasse;
		Elements.window[1] = Window:create(785, 406, 335, 265,"Drogentransporter",1920,1080);
		Elements.button[1] = Button:create(885, 597, 130, 43,"Starten","Drogentruck.start",1920,1080);
		Elements.rectangle[1] = Rectangle:create(785, 466, 335, 19,240,100,0,207,1920,1080);
		Elements.text[1] = Text:create(785, 482, 1116, 577,"Hier hast du die Möglichkeit, einen Drogentransporter zu beladen. Für einen Transport wird 10.000€ benötigt.",1920,1080);
		Elements.text[2] = Text:create(765, 478, 1120, 472,"Es befinden sich noch "..Drogentruck.fkasse.."g Hanf im Lager.",1920,1080);
		setWindowDatas();
	end
end)

function Drogentruck.start()
	triggerServerEvent("Drogentruck.start",localPlayer);
end

addEvent("Drogentruck.createMarker",true)
addEventHandler("Drogentruck.createMarker",root,function(type)
	if(isElement(Drogentruck.marker))then destroyElement(Drogentruck.marker)end
	if(isElement(Drogentruck.blip))then destroyElement(Drogentruck.blip)end
	if(type)then
		local fac = getElementData(localPlayer,"Fraktion");
		local x,y,z = Drogentruck["Abgabemarker"][fac][1],Drogentruck["Abgabemarker"][fac][2],Drogentruck["Abgabemarker"][fac][3];
		Drogentruck.marker = createMarker(x,y,z,"checkpoint",3,255,0,0);
		Drogentruck.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Drogentruck.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Drogentruck.abgabe",localPlayer);
			end
		end)
	end
end)