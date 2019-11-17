--

Waffenbox = {};

addEvent("Waffenbox.createWindow",true)
addEventHandler("Waffenbox.createWindow",root,function(weapons,state)
	if(isWindowOpen())then
		Elements.window[1] = Window:create(556, 364, 328, 172,"Waffenbox",1440,900);
		Elements.edit[1] = Edit:create(566, 434, 107, 24,1440,900);
		Elements.edit[2] = Edit:create(566, 468, 107, 24,1440,900);
		Elements.edit[3] = Edit:create(566, 502, 107, 24,1440,900);
		Elements.button[1] = Button:create(683, 434, 191, 24,"","Waffenbox.auslagern1",1440,900);
		Elements.button[2] = Button:create(683, 468, 191, 24,"","Waffenbox.auslagern2",1440,900);
		Elements.button[3] = Button:create(683, 502, 191, 24,"","Waffenbox.auslagern3",1440,900);
		Waffenbox.loadWeapons(weapons);
		setWindowDatas();
	else
		if(state and state == true)then
			Waffenbox.loadWeapons(weapons);
		end
	end
end)

function Waffenbox.loadWeapons(weapons)
	for i = 1,3 do
		if(weapons[i][1] == 1337)then
			datas = "Einlagern";
		else
			datas = getWeaponNameFromID(weapons[i][1]).." - "..weapons[i][2].." Schuss";
		end
		Elements.button[i]:setText(datas);
	end
end

function Waffenbox.auslagern1()
	local ammo = Elements.edit[1]:getText();
	triggerServerEvent("Waffenbox.server",localPlayer,1,ammo);
end

function Waffenbox.auslagern2()
	local ammo = Elements.edit[2]:getText();
	triggerServerEvent("Waffenbox.server",localPlayer,2,ammo);
end

function Waffenbox.auslagern3()
	local ammo = Elements.edit[3]:getText();
	triggerServerEvent("Waffenbox.server",localPlayer,3,ammo);
end