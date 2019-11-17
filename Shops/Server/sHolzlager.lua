--

-- [[ TABLES ]] --

Holzlager = {};

-- [[ HOLZ VERKAUFEN ]] --

addEvent("Holzlager.sell",true)
addEventHandler("Holzlager.sell",root,function(menge)
	local menge = tonumber(menge);
	if(menge >= 1)then
		if(getElementData(client,"Holz") >= menge)then
			local money = menge*5;
			setElementData(client,"Holz",getElementData(client,"Holz")-menge);
			setElementData(client,"Geld",getElementData(client,"Geld")+money);
			infobox(client,"Du hast "..menge.." Holz für "..money.."€ verkauft.",0,120,0);
		else infobox(client,"So viel Holz hast du nicht!",120,0,0)end
	else infobox(client,"Die Menge muss mindestens 1 betragen!",120,0,0)end
end)