
Tankstelle = {};

addEvent("Tankstelle.openWindow",true)
addEventHandler("Tankstelle.openWindow",root,function()
	if(isWindowOpen())then
		setElementData(localPlayer,"Clicked", true)
		Elements.window[1] = Window:create(514, 360, 412, 180,"Tankstelle",1440,900);
		Elements.text[1] = Text:create(524, 430, 916, 456,"Preis pro Liter: 4€",1440,900);
		Elements.edit[1] = Edit:create(600, 466, 316, 27,1440,900);
		Elements.text[2] = Text:create(524, 466, 590, 493,"Liter:",1440,900);
		Elements.button[1] = Button:create(524, 503, 124, 27,"Liter tanken","Tankstelle.literTanken",1440,900);
		Elements.button[2] = Button:create(658, 503, 124, 27,"Volltanken","Tankstelle.volltanken",1440,900);
		Elements.button[3] = Button:create(792, 503, 124, 27,"Kanister kaufen\nKosten: 750€","Tankstelle.buyKanister",1440,900);
		setWindowDatas();
	end
end)

function Tankstelle.literTanken()
	local liter = Elements.edit[1]:getText();
	if(tonumber(liter) >= 1)then
		triggerServerEvent("Tankstelle.tanken",localPlayer,"Liter tanken",tonumber(liter));
	else infobox("Gib eine Literanzahl an!",120,0,0)end
end
addEvent("Tankstelle.literTanken",true)
addEventHandler("Tankstelle.literTanken",root,Tankstelle.literTanken)

function Tankstelle.volltanken()
	triggerServerEvent("Tankstelle.tanken",localPlayer,"Volltanken");
end
addEvent("Tankstelle.volltanken",true)
addEventHandler("Tankstelle.volltanken",root,Tankstelle.volltanken)

function Tankstelle.buyKanister()
	triggerServerEvent("Tankstelle.buyKanister",localPlayer);
end
addEvent("Tankstelle.buyKanister",true)
addEventHandler("Tankstelle.buyKanister",root,Tankstelle.buyKanister)