--

-- [[ TABLES ]] --

Gartenclub = {};

-- [[ MARKER ERSTELLEN ]] --

Gartenclub.marker = createMarker(-2579.4287109375, 310.83639526367, 4.1796875,"cylinder",1,120,120,0);

addEventHandler("onClientMarkerHit",Gartenclub.marker,function(player)
	if(player == localPlayer)then
		if(not(isPedInVehicle(localPlayer)))then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				Elements.window[1] = Window:create(597, 348, 246, 205,"Gartenclub",1440,900);
				--Elements.button[1] = Button:create(607, 514, 108, 29,"Salatsamen\n20€","Gartenclub.buySalat",1440,900);
				Elements.button[1] = Button:create(607, 475, 108, 29,"Hanfsamen\n35€","Gartenclub.buyHanf",1440,900);
				Elements.button[2] = Button:create(725, 475, 108, 29,"Orangensamen\n50€","Gartenclub.buyOrangen",1440,900);
				Elements.button[3] = Button:create(725, 514, 108, 29,"Apfelsamen\n100€","Gartenclub.buyApfel",1440,900);
				Elements.text[1] = Text:create(607, 418, 833, 465,"Hier kannst du legale und illegale Pflanzensamen erwerben.",1440,900);
				setWindowDatas();
			end
		end
	end
end)

-- [[ OBJEKTE ERSTELLEN ]] --

engineSetModelLODDistance(2991,20);
engineSetModelLODDistance(3409,20);

for _,v in pairs(getElementsByType("object"))do
	if(getElementModel(v) == 2991 or getElementModel(v) == 3091 or getElementModel(v) == 1422 or getElementModel(v) == 792)then
		setObjectBreakable(v,false);
	end
end

-- [[ ARTIKEL KAUFEN ]] --

function Gartenclub.buySalat()
	triggerServerEvent("Gartenclub.buy",localPlayer,"Salat");
end

function Gartenclub.buyOrangen()
	triggerServerEvent("Gartenclub.buy",localPlayer,"Orangen");
end

function Gartenclub.buyApfel()
	triggerServerEvent("Gartenclub.buy",localPlayer,"Apfel");
end

function Gartenclub.buyHanf()
	triggerServerEvent("Gartenclub.buy",localPlayer,"Hanf");
end