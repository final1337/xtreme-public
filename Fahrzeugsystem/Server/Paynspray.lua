
local Garagen = {8,12,11,19,27,40,41,47};
for _,v in pairs(Garagen)do setGarageOpen(v,true) end

Paynspray = {
	-- X, Y, Z, GarageID, R, G, B, Alpha
	{2063.349609375,-1831.2890625,11.252596855164,8, 255, 255, 255, 0},
	{487.388671875,-1741.552734375,8.837544441223,12, 255, 255, 255, 0},
	{1025.044921875,-1020.9736328125,32.098804473877,11, 255, 255, 255, 0},
	{1977.2177734375,2162.5048828125,11.0703125,36, 255, 255, 255, 0},
	{-1420.5849609375,2584.3154296875,55.84326171875,40, 255, 255, 255, 0},
	{-100.0478515625,1117.5234375,19.74169921875,41, 255, 255, 255, 0},
	{719.955078125,-456.3466796875,16.3359375,47, 255, 255, 255, 0},
	{-1904.517578125,285.4404296875,41.046875,19, 255, 255, 255, 0},
	{-2425.642578125,1021.76953125,50.397659301758,27, 255, 255, 255, 0},
	{-1272.2255859375, -623.779296875, 14.1484375, 999, 255, 255, 255, 150},
};

for _,v in pairs(Paynspray)do
	local marker = createMarker(v[1],v[2],v[3],"cylinder",4,v[5],v[6],v[7],v[8]);
	setElementData(marker,"ID",v[4]);
	
	addEventHandler("onMarkerHit",marker,function(player)
		if(getElementType(player) == "vehicle")then
			local player = getVehicleOccupant(player,0);
			if(player)then
				if(getElementDimension(player) == getElementDimension(source))then
					local veh = getPedOccupiedVehicle(player);
					if(getElementHealth(veh) < 1000)then
						local price = 1000-getElementHealth(veh);
						local price = math.floor(price*0.5);
						if(getElementData(player,"Geld") >= price)then
							local ID = getElementData(source,"ID");
							local time = 1000-math.floor(getElementHealth(veh));
							setElementFrozen(veh,true);
							setGarageOpen(ID,false);
							setElementData(player,"GaragenID",ID);
							setElementData(player,"InPaynSpray",true);
							setTimer(function(player,marker,price)
								if(isElement(player))then
									if(getElementData(player,"Geld") >= price)then
										setElementData(player,"Geld",getElementData(player,"Geld")-price);
										fixVehicle(veh);
										setGarageOpen(getElementData(player,"GaragenID"),true);
										setElementFrozen(veh,false);
										removeElementData(player,"GaragenID");
										putMoneyInBusiness(8,price);
										infobox(player, "Du hast "..price.."€ für die Reparatur bezahlt!",0,120,0)
									else infobox(player,"Die Reperatur kostet "..price.."€, soviel Geld hast du nicht dabei!",120,0,0)end
								end
							end,2000+15*time,1,player,source,price)
						else infobox(player,"Die Reperatur kostet "..price.."€, soviel Geld hast du nicht dabei!",120,0,0)end
					else infobox(player,"Dein Fahrzeug muss nicht repariert werden!",120,0,0)end
				end
			end
		end
	end)
end

addEventHandler("onPlayerWasted",root,function()
	if(getElementData(source,"InPaynSpray") == true)then
		local ID = getElementData(source,"GaragenID");
		setGarageOpen(ID,true);
		removeElementData(source,"GaragenID");
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(getElementData(source,"InPaynSpray") == true)then
		local ID = getElementData(source,"GaragenID");
		setGarageOpen(ID,true);
		removeElementData(source,"GaragenID");
	end
end)