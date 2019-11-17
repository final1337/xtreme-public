--

-- [[ TABLES ]] --

Stellen = {};

-- [[ FENSTER ÖFFNEN ]] --

addEvent("Stellen.openWindow",true)
addEventHandler("Stellen.openWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(538, 372, 364, 156,"Stellen",1440,900);
		Elements.text[1] = Text:create(548, 442, 892, 481,"Du hast "..getElementData(localPlayer,"Wanteds").." Wanteds. Wenn du dich stellst, wirst du für "..getElementData(localPlayer,"Wanteds")*1.5 .." Minuten eingesperrt.",1440,900);
		Elements.button[1] = Button:create(548, 491, 344, 27,"Stellen","Stellen.server",1440,900);
		setWindowDatas();
	end
end)

-- [[ STELLEN ]] --

function Stellen.server()
	triggerServerEvent("Stellen.server",localPlayer);
end
addEvent("Stellen.server",true)
addEventHandler("Stellen.server",root,Stellen.server)