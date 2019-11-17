--

-- [[ TABLES ]] --

Bauernhof = {};

-- [[ MARKER ERSTELLEN ]] --

Bauernhof.marker = createMarker(-103.97663879395, 9.2488031387329, 2.1171875,"cylinder",1,120,120,0);

addEventHandler("onClientMarkerHit",Bauernhof.marker,function(player)
	if(player == localPlayer)then
		if(not(isPedInVehicle(localPlayer)) and getElementDimension(localPlayer) == getElementDimension(source))then
			Elements.window[1] = Window:create(566, 285, 308, 331,"Bauernhof",1440,900);
			Elements.text[1] = Text:create(576, 355, 864, 384,"Hier kannst du dein Obst für gutes Geld verkaufen.",1440,900);
			Elements.text[2] = Text:create(576, 394, 690, 421,"Salatköpfe:",1440,900);
			Elements.text[3] = Text:create(576, 468, 690, 495,"Orangen:",1440,900);
			Elements.text[4] = Text:create(576, 542, 690, 569,"Äpfel:",1440,900);
			Elements.edit[1] = Edit:create(700, 394, 164, 27,1440,900);
			Elements.edit[2] = Edit:create(700, 468, 164, 27,1440,900);
			Elements.edit[3] = Edit:create(700, 542, 164, 27,1440,900);
			Elements.button[1] = Button:create(576, 431, 288, 27,"Stück für je 50€ verkaufen","Bauernhof.sellSalat",1440,900);
			Elements.button[2] = Button:create(576, 505, 288, 27,"Stück für je 10€ verkaufen","Bauernhof.sellOrange",1440,900);
			Elements.button[3] = Button:create(576, 579, 288, 27,"Stück für je 15€ verkaufen","Bauernhof.sellApfel",1440,900);
			setWindowDatas();
		end
	end
end)

-- [[ VERKAUFEN ]] --

function Bauernhof.sellSalat()
	local menge = Elements.edit[1]:getText();
	if(#menge >= 1)then
		if(isOnlyNumbers(menge))then
			triggerServerEvent("Bauernhof.sell",localPlayer,"Salat",menge);
		end
	else infobox("Du hast keine Menge angegeben!",120,0,0)end
end

function Bauernhof.sellOrange()
	local menge = Elements.edit[2]:getText();
	if(#menge >= 1)then
		if(isOnlyNumbers(menge))then
			triggerServerEvent("Bauernhof.sell",localPlayer,"Orange",menge);
		end
	else infobox("Du hast keine Menge angegeben!",120,0,0)end
end

function Bauernhof.sellApfel()
	local menge = Elements.edit[3]:getText();
	if(#menge >= 1)then
		if(isOnlyNumbers(menge))then
			triggerServerEvent("Bauernhof.sell",localPlayer,"Apfel",menge);
		end
	else infobox("Du hast keine Menge angegeben!",120,0,0)end
end