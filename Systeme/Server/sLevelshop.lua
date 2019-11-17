--

Levelshop = {}

addEvent("Levelshop.server",true)
addEventHandler("Levelshop.server",root,function(item,preis)
	local preis = tonumber(preis);
	if(getElementData(client,"Erfahrungspunkte") >= preis)then
		if(item == "Button1")then -- Premium Silber
			setElementData(client,"PremiumSilber",getElementData(client,"PremiumSilber")+1);
			infobox(client,"Premium Silber gekauft.",0,120,0);
			setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
		elseif(item == "Button2")then -- Premium Gold
			setElementData(client,"PremiumGold",getElementData(client,"PremiumGold")+1);
			infobox(client,"Premium Gold gekauft.",0,120,0);
			setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
		elseif(item == "Button3")then -- 10.000€
			setElementData(client,"Geld",getElementData(client,"Geld")+10000);
			infobox(client,"Du hast 10000€ bekommen.",0,120,0);
			setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
		elseif(item == "Button4")then -- Zivizeit löschen
			if(getElementData(client,"Zivizeit") ~= 0)then
				setElementData(client,"Zivizeit",0);
				infobox(client,"Deine Zivizeit wurde gelöscht.",0,120,0);
				setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-25000);
			else infobox(client,"Du hast keine Zivizeit!",120,0,0)end
		elseif(item == "Button5")then -- Ghettoblaster
			setElementData(client,"Ghettoblaster",getElementData(client,"Ghettoblaster")+1);
			infobox(client,"Ghettoblaster gekauft.",0,120,0);
			setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
		elseif(item == "Button6")then -- Reifenpumpe
			setElementData(client,"Reifenpumpe",getElementData(client,"Reifenpumpe")+1);
			infobox(client,"Reifenpumpe gekauft.",0,120,0);
			setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
		elseif(item == "Button7")then -- Big Smoke Skin
			if(getElementData(client,"BigSmokeSkin") == 0)then
				setElementData(client,"BigSmokeSkin",1);
				infobox(client,"Big Smoke Skin gekauft, du kannst ihn nun im Inventar auswählen.",0,120,0);
				setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
			else infobox(client,"Du hast den Big Smoke Skin bereits!",120,0,0)end
		elseif(item == "Button8")then -- Metall
			setElementData(client,"Metall",getElementData(client,"Metall")+100);
			setElementData(client,"Erfahrungspunkte",getElementData(client,"Erfahrungspunkte")-preis);
			infobox(client,"100 Metall gekauft.",0,120,0);
		end
		LevelshopLog:write(client.name, preis)
	else infobox(client,"Du hast nicht genug Erfahrungspunkte!",120,0,0)end
end)