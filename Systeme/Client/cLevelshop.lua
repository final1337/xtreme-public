--

Levelshop = {};

addCommandHandler("levelshop",function()
	if(isWindowOpen())then
		local Level = tonumber(getElementData(localPlayer,"Level"));
		local Button1,Button2,Button3,Button4,Button5,Button6,Button7,Button8,Button9,Button10,Button11,Button12 = "Premium Silber\n5500 Points","Premium Gold\n7000 Points","10.000€ auf die Hand\n8000 Points","Zivizeit entfernen\n25000 Points","Ghettoblaster\n7000 Points","Reifenpumpe\n3000 Points","Big Smoke mit Weste\n50000 Points","100 Metall\n10000 Points","- Platzhalter -","- Platzhalter -","- Platzhalter -","- Platzhalter -";
		if(Level < 18)then Button1 = "Nicht freigeschaltet\nMindestlevel 15" end
		if(Level < 20)then Button2 = "Nicht freigeschaltet\nMindestlevel 20" end
		if(Level < 15)then Button4 = "Nicht freigeschaltet\nMindestlevel 15" end
		if(Level < 25)then Button5 = "Nicht freigeschaltet\nMindestlevel 25" end
		if(Level < 15)then Button6 = "Nicht freigeschaltet\nMindestlevel 15" end
		if(Level < 30)then Button7 = "Nicht freigeschaltet\nMindestlevel 30" end
		Elements.window[1] = Window:create(395, 255, 650, 390,"Levelshop",1440,900);
		Elements.image[1] = Image:create(395, 315, 650, 131,"Files/Images/Levelshop.png",1440,900);
		Elements.button[1] = Button:create(405, 498, 150, 39,Button1,"Levelshop.Button1",1440,900);
		Elements.button[2] = Button:create(565, 498, 150, 39,Button2,"Levelshop.Button2",1440,900);
		Elements.button[3] = Button:create(725, 498, 150, 39,Button3,"Levelshop.Button3",1440,900);
		Elements.button[4] = Button:create(885, 498, 150, 39,Button4,"Levelshop.Button4",1440,900);
		Elements.button[5] = Button:create(405, 547, 150, 39,Button5,"Levelshop.Button5",1440,900);
		Elements.button[6] = Button:create(565, 547, 150, 39,Button6,"Levelshop.Button6",1440,900);
		Elements.button[7] = Button:create(725, 547, 150, 39,Button7,"Levelshop.Button7",1440,900);
		Elements.button[8] = Button:create(885, 547, 150, 39,Button8,"Levelshop.Button8",1440,900);
		Elements.button[9] = Button:create(405, 596, 150, 39,Button9,"Levelshop.Button9",1440,900);
		Elements.button[10] = Button:create(565, 596, 150, 39,Button10,"Levelshop.Button10",1440,900);
		Elements.button[11] = Button:create(725, 596, 150, 39,Button11,"Levelshop.Button11",1440,900);
		Elements.button[12] = Button:create(885, 596, 150, 39,Button12,"Levelshop.Button12",1440,900);
		Elements.text[1] = Text:create(428, 456, 1013, 488,"Dein Level: "..getElementData(localPlayer,"Level").." | Deine Erfahrungspunkte: "..getElementData(localPlayer,"Erfahrungspunkte"),1440,900);
		setWindowDatas();
	end
end)

function Levelshop.Button1()
	if(getElementData(localPlayer,"Level") >= 18)then
		triggerServerEvent("Levelshop.server",localPlayer,"Button1",5500); -- Premium Silber
	else infobox("Du hast diesen Artikel noch nicht freigeschaltet!",120,0,0)end
end

function Levelshop.Button2()
	if(getElementData(localPlayer,"Level") >= 20)then
		triggerServerEvent("Levelshop.server",localPlayer,"Button2",7000); -- Premium Gold
	else infobox("Du hast diesen Artikel noch nicht freigeschaltet!",120,0,0)end
end

function Levelshop.Button3()
	triggerServerEvent("Levelshop.server",localPlayer,"Button3",8000); -- 10.000€
end

function Levelshop.Button4()
	if(getElementData(localPlayer,"Level") >= 15)then
		triggerServerEvent("Levelshop.server",localPlayer,"Button4",25000) -- Zivizeit löschen
	else infobox("Du hast diesen Artikel noch nicht freigeschaltet!",120,0,0)end
end

function Levelshop.Button5()
	if(getElementData(localPlayer,"Level") >= 25)then
		triggerServerEvent("Levelshop.server",localPlayer,"Button5",7000) -- Ghettoblaster
	else infobox("Du hast diesen Artikel noch nicht freigeschaltet!",120,0,0)end
end

function Levelshop.Button6()
	if(getElementData(localPlayer,"Level") >= 25)then
		triggerServerEvent("Levelshop.server",localPlayer,"Button6",3000) -- Reifenpumpe
	else infobox("Du hast diesen Artikel noch nicht freigeschaltet!",120,0,0)end
end

function Levelshop.Button7()
	if(getElementData(localPlayer,"Level") >= 30)then
		triggerServerEvent("Levelshop.server",localPlayer,"Button7",50000) -- Big Smoke Skin
	else infobox("Du hast diesen Artikel noch nicht freigeschaltet!",120,0,0)end
end

function Levelshop.Button8()
	triggerServerEvent("Levelshop.server",localPlayer,"Button8",10000) -- Metall
end

--[[ function Levelshop.Button9()

end

function Levelshop.Button10()

end

function Levelshop.Button11()

end

function Levelshop.Button12()

end ]]--