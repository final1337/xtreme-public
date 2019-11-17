--

-- [[ TABLES ]] --

Bauernhof = {
	["Preise"] = {
		["Salat"] = {50,"Salat"},
		["Orange"] = {10,"Orangen"},
		["Apfel"] = {15,"Aepfel"},
	},
};

-- [[ VERKAUFEN ]] --

addEvent("Bauernhof.sell",true)
addEventHandler("Bauernhof.sell",root,function(type,menge)
	local menge = tonumber(menge);
	local item = Bauernhof["Preise"][type][2];
	if(menge >= 1)then
		if(getElementData(client,item) >= menge)then
			local geld = Bauernhof["Preise"][type][1];
			setElementData(client,item,getElementData(client,item)-menge);
			setElementData(client,"Geld",getElementData(client,"Geld")+menge*geld);
			infobox(client,"Du hast dein Obst für "..geld.."€ verkauft.",0,120,0);
		else infobox(client,"Du hast das Obst nicht oft genug!",120,0,0)end
	else infobox(client,"Die Menge muss mindestens 1 betragen!",120,0,0)end
end)