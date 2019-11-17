--[[Inventory = {
	["Items"] = {"Aepfel","Orangen","Salat","Hanf","Apfelsamen","Orangensamen","Hanfsamen","Salatsamen","Eisen","Holz","Metall","Reifenpumpe","Ghettoblaster","PremiumSilber","PremiumGold","BigSmokeSkin","Benzinkanister","Eisenerz"},
	["Positions"] = {
		{592*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{666*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{740*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{814*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{888*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{962*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1036*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1110*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1184*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1259*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080)},
		{592*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{592*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{592*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{666*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{666*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{666*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{740*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{740*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{740*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{814*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{814*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{814*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{888*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{888*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{888*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{962*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{962*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{962*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1036*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1036*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1036*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1110*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1110*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1110*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1184*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1184*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1184*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1259*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1259*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080)},
		{1259*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080)},
	},
	["CraftingRecepts"] = {
	
	},
};

function Inventory.open()
	if(Inventory.openState == false)then
		if(isWindowOpen())then
			Inventory.fill();
			addEventHandler("onClientRender",root,Inventory.dxDraw);
			Inventory.openState = true;
			setWindowDatas();
		end
	else
		removeEventHandler("onClientRender",root,Inventory.dxDraw);
		Inventory.openState = false;
		dxClassClose();
	end
end
bindKey("i","down",Inventory.open)

function Inventory.dxDraw()
    dxDrawRectangle(620*(x/1920), 940*(y/1080), 677*(x/1920), 10*(y/1080), tocolor(235, 71, 0, 255), false)
    dxDrawRectangle(620*(x/1920), 950*(y/1080), 677*(x/1920), 93*(y/1080), tocolor(25, 25, 25, 200), false)
	dxDrawRectangle(628*(x/1920), 318*(y/1080), 659*(x/1920), 286*(y/1080), tocolor(25, 25, 25, 200), false)
	
	---------------------------------------------------------------------------------------------------------

	--//Schnellinventar-Felder
    dxDrawRectangle(630*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(704*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(778*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(852*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(926*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1000*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1074*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1148*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1222*(x/1920), 974*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)

    dxDrawText("Schnell Inventar", 630*(x/1920), 949*(y/1080), 778*(x/1920), 974*(y/1080), tocolor(255, 255, 255, 255), 1.30*(y/1080), "default-bold", "left", "center", false, false, false, false, false)
    dxDrawRectangle(582*(x/1920), 644*(y/1080), 751*(x/1920), 286*(y/1080), tocolor(25, 25, 25, 200), false)
    dxDrawRectangle(582*(x/1920), 614*(y/1080), 751*(x/1920), 30*(y/1080), tocolor(235, 71, 0, 255), false)
	
	---------------------------------------------------------------------------------------------------------
	
    dxDrawText("Xtreme Inventar", 582*(x/1920), 614*(y/1080), 1333*(x/1920), 644*(y/1080), tocolor(255, 255, 255, 255), 1.30*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
	
	--//Felder
	
    dxDrawRectangle(592*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(666*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(740*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(814*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(888*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(962*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1036*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1110*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1184*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1259*(x/1920), 654*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(592*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(592*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(592*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(666*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(666*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(666*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(740*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(740*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(740*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(814*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(814*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(814*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(888*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(888*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(888*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(962*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(962*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(962*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1036*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1036*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1036*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1110*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1110*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1110*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1184*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1184*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1184*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1259*(x/1920), 723*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1259*(x/1920), 792*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(1259*(x/1920), 861*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
	
	---------------------------------------------------------------------------------------------------------
	
	--//Crafting-Felder
    dxDrawRectangle(638*(x/1920), 328*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(712*(x/1920), 328*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(786*(x/1920), 328*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(860*(x/1920), 328*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(934*(x/1920), 328*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(638*(x/1920), 397*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(638*(x/1920), 466*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(638*(x/1920), 535*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(712*(x/1920), 397*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(712*(x/1920), 466*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(712*(x/1920), 535*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(786*(x/1920), 397*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(786*(x/1920), 466*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(786*(x/1920), 535*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(860*(x/1920), 397*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(860*(x/1920), 466*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(860*(x/1920), 535*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(934*(x/1920), 397*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(934*(x/1920), 466*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
    dxDrawRectangle(934*(x/1920), 535*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
	
    --//Finished Craftitem-Feld
	dxDrawRectangle(1008*(x/1920), 431*(y/1080), 64*(x/1920), 59*(y/1080), tocolor(11, 11, 11, 255), false)
	
    dxDrawText("Crafting", 1008*(x/1920), 401*(y/1080), 1072*(x/1920), 431*(y/1080), tocolor(255, 255, 255, 255), 1*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
    dxDrawRectangle(1082*(x/1920), 328*(y/1080), 195*(x/1920), 266*(y/1080), tocolor(11, 11, 11, 255), false)
end

function Inventory.fill()

end]]