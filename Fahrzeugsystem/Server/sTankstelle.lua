
Tankstelle = {
	["Marker"] = {	-- x,y,z,size
		{-1678.9851074219,410.03561401367,4.9296998977661,5},
		{-2406.7104492188,981.767578125,43.388900756836,5},
		{-1330.0046386719,2666.7614746094,48.971698760986,2},
		{-1329.4044189453,2672.1306152344,48.971698760986,2},
		{-1328.5791015625,2677.6826171875,48.971698760986,2},
		{-1327.8505859375,2683.0361328125,48.971698760986,2},
		{-1327.2797851563,2687.95703125,48.971698760986,2},
		{602.142578125,1709.1281738281,5.8888001441956,3},
		{605.06207275391,1704.5720214844,5.8762001991272,3},
		{608.37097167969,1699.5887451172,5.8762001991272,3},
		{611.67987060547,1694.60546875,5.8762001991272,3},
		{614.98876953125,1689.6223144531,5.8762001991272,3},
		{618.29772949219,1684.6391601563,5.8762001991272,3},
		{621.60662841797,1679.6560058594,5.8762001991272,3},
		{624.91552734375,1674.6728515625,5.8762001991272,3},
		{-1477.1450195313,1863.9484863281,31.456800460815,5},
		{-1465.8514404297,1864.4583740234,31.456800460815,5},
		{2640.0705566406,1106.3985595703,9.6078996658325,5},
		{2640.0222167969,1096.7507324219,9.6078996658325,5},
		{2202.4096679688,2474.8779296875,9.7210998535156,5},
		{1596.1640625,2190.25, 9.7082996368408,5},
		{1595.9741210938,2199.1618652344,9.7082996368408,5},
		{1945.1186523438,-1771.7932128906,12.253499984741,5},
		{1938.2359619141,-1771.4372558594,12.253499984741,5},
		{-93.530700683594,-1174.98046875,0.98530000448227,5},
		{-89.080101013184,-1163.4610595703,0.98530000448227,5},
		{-1598.7926025391,-2705.6044921875,47.418899536133,3},
		{-1602.4428710938,-2710.0808105469,47.418899536133,3},
		{-1605.7673339844,-2714.1574707031,47.418899536133,3},
		{-1609.373046875,-2718.5910644531,47.418899536133,3},
		{-1612.5788574219,-2722.4450683594,47.418899536133,3},
		{-1160.1711425781,-182.17570495605,12.881400108337,10},
	},
};

for _,v in pairs(Tankstelle["Marker"])do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",v[4],255,0,0);
	
	addEventHandler("onMarkerHit",marker,function(player, matchingDimension)
		if(getElementType(player) == "vehicle")then
			local player = getVehicleOccupant(player,0);
			-- if(isPedInVehicle(player))then
				if(getElementDimension(player) == getElementDimension(source))then
					triggerClientEvent(player,"Tankstelle.openWindow",player);
					if isPedInVehicle(player) then
						setElementFrozen(getPedOccupiedVehicle(player),true);
						setTimer(function(player)
							setElementFrozen(getPedOccupiedVehicle(player),false);
						end,500,1,player)
					end
				end
			-- end
		elseif getElementType(player) == "player" then
			local veh = player:getOccupiedVehicle()
			if veh then return end
			if matchingDimension then
				triggerClientEvent(player,"Tankstelle.openWindow",player);
			end
		end
	end)
end

addEvent("Tankstelle.tanken",true)
addEventHandler("Tankstelle.tanken",root,function(type,liter)
	local veh = getPedOccupiedVehicle(client);
	if not veh then
		client:sendNotification("Du bist in keinem Fahrzeug.", 120, 0, 0)
		return
	end
	local benzin = getElementData(veh,"Fuel");
	if(type == "Liter tanken")then
		local liter = tonumber(liter);
		local checkBenzin = 100-benzin;
		if(liter <= checkBenzin)then
			local preis = math.ceil(liter*4);
			if(getElementData(client,"Geld") >= preis)then
				infobox(client,"Dein Fahrzeug wird getankt, warte einen Moment.",0,120,0);
				setElementFrozen(veh,true);
				setElementData(client,"Geld", getElementData(client,"Geld")-preis);
				setTimer(function(client,veh)
					if(isElement(client))then infobox(client,"Dein Fahrzeug wurde getankt.",0,120,0)end
					setElementData(veh,"Fuel",100);
					setElementFrozen(veh,false);
				end,6500,1,client,veh)
				putMoneyInBusiness(5,preis);
			else infobox(client,"Du hast nicht genug Geld dabei! ("..preis.."€)",120,0,0)end
		else infobox(client,"Soviel Benzin benötigt dein Fahrzeug nicht!",120,0,0)end
	else
		local liter = 100-benzin;
		local preis = math.ceil(liter*4);
		if(getElementData(client,"Geld") >= preis)then
			infobox(client,"Dein Fahrzeug wird getankt, warte einen Moment.",0,120,0);
			setElementFrozen(veh,true);
			setElementData(client,"Geld",getElementData(client,"Geld")-preis);
			setTimer(function(client,veh)
				if(isElement(client))then infobox(client,"Dein Fahrzeug wurde getankt.",0,120,0)end
				setElementData(veh,"Fuel",100);
				setElementFrozen(veh,false);
			end,6500,1,client,veh)
			putMoneyInBusiness(5,preis);
		else infobox(client,"Du hast nicht genug Geld dabei! ("..preis.."€)",120,0,0)end
	end
end)

addEvent("Tankstelle.buyKanister",true)
addEventHandler("Tankstelle.buyKanister",root,function()
	if(getElementData(client,"Geld") >= 750)then
		setElementData(client,"Geld",getElementData(client,"Geld")-750);
		client:addItem(78, 1)
		infobox(client,"Benzinkanister gekauft.",0,120,0);
		putMoneyInBusiness(5,750);
	else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
end)