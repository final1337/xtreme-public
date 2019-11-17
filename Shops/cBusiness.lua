--

-- [[ TABLES ]] --

Business = {};

-- [ BUSINESS-INFO ]] --

function Business.dxDrawInfos()
	local px,py,pz = getElementPosition(localPlayer);
	if(isLineOfSightClear(px,py,pz,Business.x,Business.y,Business.z,true,false,false,true,false,false,false) and isWindowOpen())then
		local scx,scy = getScreenFromWorldPosition(Business.x,Business.y,Business.z+1);
		if(scx and scy)then
			dxDrawRectangle(scx-150,scy,300,120,tocolor(255,255,255,125));
			dxDrawText("Name: "..Business.name.."\nBesitzer: "..Business.besitzer.."\nPreis: "..Business.preis.."€\nMindestspielzeit: "..Business.mindestspielzeit.."h",scx,scy,scx,scy,tocolor(0,0,0,255),1,"pricedown","center","top");
		end
	end
end

addEvent("Business.renderDxDraw",true)
addEventHandler("Business.renderDxDraw",root,function(besitzer,preis,mindestspielzeit,name,x,y,z)
	Business.besitzer = besitzer;
	Business.preis = preis;
	Business.mindestspielzeit = mindestspielzeit;
	Business.name = name;
	Business.x = x;
	Business.y = y;
	Business.z = z;
	addEventHandler("onClientRender",root,Business.dxDrawInfos);
end)

addEvent("Business.unrenderDxDraw",true)
addEventHandler("Business.unrenderDxDraw",root,function()
	removeEventHandler("onClientRender",root,Business.dxDrawInfos);
end)

-- [[ FENSTER ÖFFNEN ]] --

addEvent("Business.buyWindow",true)
addEventHandler("Business.buyWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(1102, 731, 328, 159,"Business",1440,900);
		Elements.text[1] = Text:create(1112, 801, 1420, 847,"Dieses Business steht für "..Business.preis.."€ zum Verkauf. Zum Kauft benötigst du mindestens "..Business.mindestspielzeit.." Spielstunden.",1440,900);
		Elements.button[1] = Button:create(1112, 857, 308, 23,"Kaufen","Business.buy",1440,900);
		setWindowDatas();
	end
end)

-- [[ KAUFEN ]] --

function Business.buy()
	triggerServerEvent("Business.buy",localPlayer);
end

-- [[ VERWALTUNG ]] --

addEvent("Business.openVerwaltung",true)
addEventHandler("Business.openVerwaltung",root,function(kasse)
	if(isWindowOpen())then
		Elements.window[1] = Window:create(1102, 721, 328, 169,"Business",1440,900);
		Elements.text[1] = Text:create(1112, 791, 1420, 812,"Kasse: "..kasse.."€",1440,900);
		Elements.edit[1] = Edit:create(1208, 822, 212, 21,1440,900);
		Elements.text[2] = Text:create(1112, 822, 1198, 843,"Summe:",1440,900);
		Elements.button[1] = Button:create(1112, 853, 96, 27,"Einzahlen","Business.einzahlen",1440,900);
		Elements.button[2] = Button:create(1218, 853, 96, 27,"Auszahlen","Business.auszahlen",1440,900);
		Elements.button[3] = Button:create(1324, 853, 96, 27,"Verkaufen","Business.verkaufen",1440,900);
		setWindowDatas();
	end
end)

-- [[ EIN- / AUSZAHLEN ]] --

function Business.einzahlen()
	local summe = Elements.edit[1]:getText();
	if(#summe >= 1)then
		if(isOnlyNumbers(summe))then
			triggerServerEvent("Business.einzahlen",localPlayer,summe);
		end
	else infobox("Gib eine Summe an!",120,0,0)end
end

function Business.auszahlen()
	local summe = Elements.edit[1]:getText();
	if(#summe >= 1)then
		if(isOnlyNumbers(summe))then
			triggerServerEvent("Business.auszahlen",localPlayer,summe);
		end
	else infobox("Gib eine Summe an!",120,0,0)end
end

-- [[ VERKAUFEN ]] --

function Business.verkaufen()
	triggerServerEvent("Business.sell",localPlayer);
end

-- [[ KASSE ]] --

addEvent("Business.refreshKasse",true)
addEventHandler("Business.refreshKasse",root,function(summe)
	Elements.text[1]:setText("Kasse: "..summe.."€");
end)