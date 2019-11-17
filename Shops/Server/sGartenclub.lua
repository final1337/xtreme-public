--

-- [[ TABLES ]] --

Gartenclub = {
	["Preise"] = {
		["Salat"] = {20,"Salatsamen"},
		["Hanf"] = {35,"Hanfsamen"},
		["Orangen"] = {50,"Orangensamen"},
		["Apfel"] = {100,"Apfelsamen"},
	},
};

-- [[ SAMEN KAUFEN ]] --

addEvent("Gartenclub.buy",true)
addEventHandler("Gartenclub.buy",root,function(type)
	local preis = tonumber(Gartenclub["Preise"][type][1]);
	local samen = tonumber(Gartenclub["Preise"][type][2]);
	if(getElementData(client,"Geld") >= preis)then
		setElementData(client,"Geld",getElementData(client,"Geld")-preis);
		if type == "Hanf" then
			local item = client:addItem(67, 1)
			item:merge()
		elseif type == "Orangen" then
			local item = client:addItem(87, 1)
			item:merge()			
		elseif type == "Apfel" then
			local item = client:addItem(89, 1)
			item:merge()				
		end
		infobox(client,"Samen gekauft.",0,120,0);
	else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
end)