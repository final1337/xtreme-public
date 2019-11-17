--

-- [[ TABLES ]] --

Holzlager = {};

-- [[ MARKER ERSTELLEN ]] --

Holzlager.marker = createMarker(-2012.8825683594, -2398.4548339844, 29.625,"cylinder",1,120,120,0);

addEventHandler("onClientMarkerHit",Holzlager.marker,function(player)
	if(player == localPlayer)then
		if(not(isPedInVehicle(localPlayer)))then
			if(getElementDimension(localPlayer) == getElementDimension(source))then
				Elements.window[1] = Window:create(533, 355, 374, 191,"Holzlager",1440,900);
				Elements.text[1] = Text:create(543, 425, 897, 455,"Hier kannst du dein Holz für 5€ das Stück verkaufen.",1440,900);
				Elements.text[2] = Text:create(543, 465, 672, 495,"Menge:",1440,900);
				Elements.button[1] = Button:create(543, 505, 354, 31,"Verkaufen","Holzlager.sell",1440,900);
				Elements.edit[1] = Edit:create(682, 465, 215, 30,1440,900);
				setWindowDatas();
			end
		end
	end
end)

-- [[ VERKAUFEN ]] --

function Holzlager.sell()
	local menge = Elements.edit[1]:getText();
	if(#menge >= 1)then
		if(isOnlyNumbers(menge))then
			triggerServerEvent("Holzlager.sell",localPlayer,menge);
		end
	else infobox("Gib eine Summe an!",120,0,0)end
end