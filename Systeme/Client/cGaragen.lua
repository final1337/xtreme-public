--

Garagen = {};

addEvent("Garagen.openWindow",true)
addEventHandler("Garagen.openWindow",root,function(besitzer)
	if(isWindowOpen())then
		if(besitzer == "Niemand")then Garagen.text = "Kaufen" else Garagen.text = "Verkaufen" end
		Elements.window[1] = Window:create(1143, 684, 287, 206,"Garage",1440,900);
		Elements.image[1] = Image:create(1087, 754, 271, 129,"Files/Images/Garage.png",1440,900);
		Elements.text[1] = Text:create(1297, 754, 1420, 849,"Besitzer: "..besitzer.."\nPreis: 150000€",1440,900);
		Elements.button[1] = Button:create(1297, 856, 123, 27,Garagen.text,"Garagen.server",1440,900);
		setWindowDatas();
	end
end)

function Garagen.server()
	if(Garagen.text == "Kaufen")then
		triggerServerEvent("Garagen.buy",localPlayer);
	else
		triggerServerEvent("Garagen.sell",localPlayer);
	end
end