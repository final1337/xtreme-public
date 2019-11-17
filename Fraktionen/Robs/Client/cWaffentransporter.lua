

Waffentransporter = {
	["Abgabemarker"] = {
		[5] = {-2572.5844726563,1459.5947265625,-0.55000001192093},
		[6] = {-1629.255859375,163.8645324707,-0.55000001192093},
		[7] = {-2948.7319335938,-212.24977111816,-0.55000001192093},
		[8] = {-427.18032836914,1163.5264892578,-0.55000001192093},
		[10] = {914.68292236328,-135.44960021973,-0.55000001192093},
		[11] = {-715.81457519531,2320.6301269531,127.63909912109},
	},
};

addEvent("Waffentransporter.createWindow",true)
addEventHandler("Waffentransporter.createWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(785, 406, 335, 265,"Waffentransporter",1920,1080);
		Elements.button[1] = Button:create(885, 597, 130, 43,"Starten","Waffentransporter.start",1920,1080);
		Elements.rectangle[1] = Rectangle:create(785, 466, 335, 19,240,100,0,207,1920,1080);
		Elements.text[1] = Text:create(785, 482, 1116, 577,"Hier hast du die Möglichkeit, einen Waffentransporter zu starten. Ihr müsst zu fünft im Marker stehen, damit dies funktioniert.",1920,1080);
		setWindowDatas();
    end
end)

addEvent("Waffentransporter.createTerrorWindow",true)
addEventHandler("Waffentransporter.createTerrorWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(785, 406, 335, 265,"Waffentransporter",1920,1080);
		Elements.button[1] = Button:create(885, 597, 130, 43,"Starten","Waffentransporter.terrorStart",1920,1080);
		Elements.rectangle[1] = Rectangle:create(785, 466, 335, 19,240,100,0,207,1920,1080);
		Elements.text[1] = Text:create(785, 482, 1116, 577,"Hier hast du die Möglichkeit, einen Waffentransporter zu starten.",1920,1080);
		setWindowDatas();
    end
end)

function Waffentransporter.start()
	triggerServerEvent("Waffentransporter.start",localPlayer);
end

function Waffentransporter.terrorStart()
	triggerServerEvent("Waffentransporter.terrorStart",localPlayer);
end

function Waffentransporter.createMarker(type)
	if(isElement(Waffentransporter.marker))then destroyElement(Waffentransporter.marker)end
	if(isElement(Waffentransporter.blip))then destroyElement(Waffentransporter.blip)end
	if(type)then
		local faction = getElementData(localPlayer,"Fraktion");
		local x,y,z = Waffentransporter["Abgabemarker"][faction][1],Waffentransporter["Abgabemarker"][faction][2],Waffentransporter["Abgabemarker"][faction][3];
		Waffentransporter.marker = createMarker(x,y,z,"checkpoint",2,255,0,0);
		Waffentransporter.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Waffentransporter.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Waffentransporter.abgabe",localPlayer);
			end
		end)
	end
end
addEvent("Waffentransporter.createMarker",true)
addEventHandler("Waffentransporter.createMarker",root,Waffentransporter.createMarker)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		Waffentransporter.createMarker();
	end
end)