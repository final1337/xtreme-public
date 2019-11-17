
addEvent("AD.send",true)
addEventHandler("AD.send",root,function(text,type)
	if(type == "Premium")then preis = 2000 else preis = 350 end
	if(getElementData(client,"Geld") >= preis)then
		setElementData(client,"Geld",getElementData(client,"Geld")-preis);
		local Nummer = getElementData(client,"Telefonnummer");
		if(type == "Premium")then
			outputChatBox("===== Werbung von "..getPlayerName(client).." =====",root,255,255,0);
			outputChatBox(text,root,255,255,0);
			outputChatBox("Nummer: "..Nummer,root,200,200,0);
			outputChatBox("===== Werbung von "..getPlayerName(client).." =====",root,255,255,0);
		else
			outputChatBox("Werbung von "..getPlayerName(client).." (Nummer: "..Nummer.."): "..text,root,0,125,0);
		end
	else infobox(client,"Du hast nicht genug Geld!",120,0,0)end
end)