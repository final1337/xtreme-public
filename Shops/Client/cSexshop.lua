--

-- [[ TABLES ]] --

Sexshop = {};

-- [[ ELEMENTE ERSTELLEN ]] --

Sexshop.ped = createPed(246,-106.06359863281,-8.881199836731,1000.7188110352,180);
setElementInterior(Sexshop.ped,3);
Sexshop.marker = createMarker(-106.05069732666,-10.791500091553,999.72882080078,"cylinder",1,0,0,255);
setElementInterior(Sexshop.marker,3);

addEventHandler("onClientMarkerHit",Sexshop.marker,function(player)
	if(player == localPlayer)then
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				Elements.window[1] = Window:create(597, 348, 246, 205,"Sexshop",1440,900);
				Elements.button[1] = Button:create(607, 514, 108, 29,"Dildo | 15cm \n110€","Sexshop.buyDildo1",1440,900);
				Elements.button[2] = Button:create(607, 475, 108, 29,"Dildo | 28cm \n130€","Sexshop.buyDildo2",1440,900);
				Elements.button[3] = Button:create(725, 475, 108, 29,"Vibrator | 28cm\n180€","Sexshop.buyVibrator",1440,900);
				Elements.button[4] = Button:create(725, 514, 108, 29,"Bitch Skin\n1000€","Sexshop.buyBitchSkin",1440,900);
				Elements.text[1] = Text:create(607, 418, 833, 465,"Hier kannst du dir Spielzeug kaufen.",1440,900);
				setWindowDatas();
			end
		end
	end
end)

-- [[ ARTIKEL KAUFEN ]] --

function Sexshop.buyDildo1()
	triggerServerEvent("Sexshop.buy",localPlayer,11,110);
end

function Sexshop.buyDildo2()
	triggerServerEvent("Sexshop.buy",localPlayer,10,130);
end

function Sexshop.buyVibrator()
	triggerServerEvent("Sexshop.buy",localPlayer,12,180);
end

function Sexshop.buyBitchSkin()
	triggerServerEvent("Sexshop.buy",localPlayer,246,100);
end