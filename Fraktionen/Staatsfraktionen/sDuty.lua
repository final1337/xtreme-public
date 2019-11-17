--

-- [[ TABLES ]] --

Duty = {
	["Pickups"] = {
		-- x,y,z,int,dim,faction
		{259.0178527832,108.15506744385,1003.21875,10,0,1},
		{327.0866394043,307.07821655273,999.1484375,5,0,2},
		{256.98779296875,70.263122558594,1003.640625,6,0,9},
		{-2160.34131,638.86981,1057.58606,1,0,4},
		{-1329.25,489.047,11.19,0,0,3}
	},
};

-- [[ PICKUPS ERSTELLEN ]] --

for _,v in pairs(Duty["Pickups"])do
	local pickup = createPickup(v[1],v[2],v[3],3,1239,50);
	setElementInterior(pickup,v[4]);
	setElementDimension(pickup,v[5]);
	
	addEventHandler("onPickupHit",pickup,function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementData(player,"Fraktion") == v[6])then
					triggerClientEvent(player,"Duty.openWindow",player);
				end
			end
		end
	end)
end

-- [[ DUTY GEHEN ]] --

addEvent("Duty.server",true)
addEventHandler("Duty.server",root,function()
	if(getElementData(client,"Duty") == true)then
		infobox(client,"Dienst verlassen.",120,0,0);
		setElementData(client,"Duty",false);
		setElementModel(client,getElementData(client,"Skin"));
		setElementHealth(client,100);
		setPedArmor(client,100);
		takeAllWeapons(client);
	else
		infobox(client,"Dienst betreten.",0,120,0);
		setElementData(client,"Duty",true);
		setElementHealth(client,100);
		setPedArmor(client,100);		
		giveFactionSkin(client);
		if(isCop(client))then
			local item = client:addItem(50, 500, "none", true)
			item:merge()
			local item = client:addItem(49, 500, "none", true)
			item:merge()
			local item = client:addItem(51, 500, "none", true)
			item:merge()
			local item = client:addItem(66, 1, "none", true)
			item:merge()
			if(getElementData(client,"Rang") >= 2)then
				local item = client:addItem(48, 500, "none", true)
				item:merge()
			end
		elseif(isFBI(client))then
			local item = client:addItem(50, 500, "none", true)
			item:merge()
			local item = client:addItem(49, 500, "none", true)
			item:merge()
			local item = client:addItem(51, 500, "none", true)
			item:merge()
			local item = client:addItem(66, 1, "none", true)
			item:merge()
			if(getElementData(client,"Rang") >= 2)then
				local item = client:addItem(48, 500, "none", true)
				item:merge()
			end
			if(getElementData(client,"Rang") >= 3)then
				local item = client:addItem(52, 50, "none", true)
				item:merge()
				local item = client:addItem(63, 10, "none", true)
				item:merge()
			end
		elseif(isArmy(client))then
			local item = client:addItem(50, 500, "none", true)
			item:merge()
			local item = client:addItem(49, 500, "none", true)
			item:merge()
			local item = client:addItem(51, 500, "none", true)
			item:merge()
			local item = client:addItem(48, 500, "none", true)
			item:merge()
			if(getElementData(client,"Rang") >= 2)then
				local item = client:addItem(52, 50, "none", true)
				item:merge()
				local item = client:addItem(63, 10, "none", true)
				item:merge()
			end
			if(getElementData(client,"Rang") >= 3)then
				local item = client:addItem(64, 10, "none", true)
				item:merge()
			end
			if(getElementData(client,"Rang") >= 4)then
				local item = client:addItem(65, 1, "none", true)
				item:merge()
			end
		elseif(isFeuerwehr(client))then
			local item = itemmanager:add(38, client:getId(), client:getId(), client:getId(), 9999, 0, 0, 100, 0, "none", client.m_Storages[1])
			client.m_Storages[1]:addItem(item)
			item:merge()
		elseif(isReporter(client)) then
			local item = client:addItem(61, 500, "none", true)
			item:merge()				
		end
	end
	triggerClientEvent(client,"dxClassClose",client);
end)

-- [[ IST SPIELER DUTY? ]] --

function isDuty(player)
	if(getElementData(player,"Duty") == true)then
		return true
	else
		return false
	end
end

-- [[ SWAT DIENST ]] --

addEvent("Duty.swat",true)
addEventHandler("Duty.swat",root,function()
	if(getElementData(client,"Rang") >= 3)then
		setElementHealth(client,100);
		setPedArmor(client,100);
		setElementModel(client,285);
		setElementData(client,"Duty",true);
		local item = client:addItem(52, 25, "none", true)
		item:merge()
		local item = client:addItem(50, 500, "none", true)
		item:merge()
		local item = client:addItem(49, 500, "none", true)
		item:merge()
		local item = client:addItem(51, 500, "none", true)
		item:merge()
		local item = client:addItem(63, 10, "none", true)
		item:merge()
	else infobox(client,"Du bist nicht befugt, diesen Dienst zu betreten!",120,0,0)end
end)

-- [[ SPIELER STIRBT ]] --

addEventHandler("onPlayerWasted",root,function()
	setElementData(source,"Duty",false);
end)