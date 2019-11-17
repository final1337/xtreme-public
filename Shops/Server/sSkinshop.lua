--

-- [[ SKIN KAUFEN ]] --

addEvent("Skinshop.buy",true)
addEventHandler("Skinshop.buy",root,function(SkinID,costs)
	local SkinID,costs = tonumber(SkinID),tonumber(costs);
	if(getElementData(client,"Geld") >= costs)then
		setElementData(client,"Geld",getElementData(client,"Geld")-costs);
		infobox(client,"Skin gekauft.",0,120,0);
		setElementData(client,"Skin",SkinID);
		setElementModel(client,SkinID);
		putMoneyInBusiness(7,costs);
	else infobox(client,"Du hast nicht genug Geld!",120,0,0)end
end)