--

-- [[ TABLES ]] --

Sexshop = {};

-- [[ KAUFEN ]] --

addEvent("Sexshop.buy",true)
addEventHandler("Sexshop.buy",root,function(id,money)
	local money = tonumber(money);
	if(getElementData(client,"Geld") >= money)then
		local id = tonumber(id);
		if(id == 0)then
			if(isEvil(client))then
				infobox(client,"Als böser Fraktionist kannst du dir diesen Skin nicht kaufen!",120,0,0);
			else
				setElementModel(client,id);
				setElementData(client,"Skin",id);
				setElementData(client,"Geld",getElementData(client,"Geld")-money);
				infobox(client,"Skin gekauft.",0,120,0);
			end
		else
			infobox(client,"Artikel gekauft.",0,120,0);
			setElementData(client,"Geld",getElementData(client,"Geld")-money);
			giveWeapon(client,id,1,true);
		end
	else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
end)