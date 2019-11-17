--

Garagen = {};
local result = dbPoll(dbQuery(handler,"SELECT * FROM garagen"),-1);
if(#result >= 1)then
	for _,v in pairs(result)do
		Garagen[v["ID"]] = createObject(10575,v["SpawnxObject"],v["SpawnyObject"],v["SpawnzObject"],0,0,v["RotationObject"]);
		setElementData(Garagen[v["ID"]],"Besitzer",v["Besitzer"]);
		setElementData(Garagen[v["ID"]],"Status","Zu");
		setElementData(Garagen[v["ID"]],"Moved",false);
		local pickup = createPickup(v["SpawnxPickup"],v["SpawnyPickup"],v["SpawnzPickup"],3,1239,50);
		setElementData(pickup,"GaragenID",v["ID"]);
		
		addEventHandler("onPickupHit",pickup,function(player)
			if(not(isPedInVehicle(player)))then
				if(getElementDimension(player) == getElementDimension(source))then
					local ID = getElementData(source,"GaragenID");
					local Besitzer = getElementData(Garagen[ID],"Besitzer");
					setElementData(player,"savedGaragenID",ID);
					triggerClientEvent(player,"Garagen.openWindow",player,Besitzer);
				end
			end
		end)
	end
end

addEvent("Garagen.buy",true)
addEventHandler("Garagen.buy",root,function()
	local ID = getElementData(client,"savedGaragenID");
	local Besitzer = getElementData(Garagen[ID],"Besitzer");
	if(Besitzer == "Niemand")then
		if(getElementData(client,"Geld") >= 150000)then
			local result = dbPoll(dbQuery(handler,"SELECT * FROM garagen WHERE Besitzer = '"..getPlayerName(client).."'"),-1);
			if(#result == 0)then
				setElementData(client,"Geld",getElementData(client,"Geld")-150000);
				setElementData(Garagen[ID],"Besitzer",getPlayerName(client));
				dbExec(handler,"UPDATE garagen SET Besitzer = '"..getPlayerName(client).."' WHERE ID = '"..ID.."'");
				infobox(client,"Garage gekauft.",0,120,0);
				triggerClientEvent(client,"dxClassClose",client);
			else infobox(client,"Du hast bereits eine Garage!",120,0,0)end
		else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
	else infobox(client,"Diese Garage steht nicht zum Verkauf!",120,0,0)end
end)

addEvent("Garagen.sell",true)
addEventHandler("Garagen.sell",root,function()
	local ID = getElementData(client,"savedGaragenID");
	local Besitzer = getElementData(Garagen[ID],"Besitzer");
	if(Besitzer == getPlayerName(client))then
		setElementData(client,"Geld",getElementData(client,"Geld")+150000/100*75);
		setElementData(Garagen[ID],"Besitzer","Niemand");
		dbExec(handler,"UPDATE garagen SET Besitzer = '"..getPlayerName(client).."' WHERE ID = '"..ID.."'");
		infobox(client,"Garage verkauft, du hast 75% des Kaufpreises zurückbekommen.",0,120,0);
		triggerClientEvent(client,"dxClassClose",client);
	else infobox(client,"Die Garage gehört dir nicht!",120,0,0)end
end)

addCommandHandler("garage",function(player)
	if(getElementData(player,"loggedin") == 1)then
		for _,v in pairs(Garagen)do
			local Besitzer = getElementData(v,"Besitzer");
			if(Besitzer == getPlayerName(player))then
				local x,y,z = getElementPosition(v);
				if(getDistanceBetweenPoints(x,y,z,getElementPosition(player)) <= 15)then
					if(getElementDimension(player) == getElementDimension(v))then
						if(getElementData(v,"Moved") == false)then
							setElementData(v,"Moved",true);
							if(getElementData(v,"Status") == "Zu")then
								moveObject(v,5000,x,y,z-12.5);
								setElementData(v,"Status","Offen");
							else
								 moveObject(v,5000,x,y,z+12.5);
								setElementData(v,"Status","Zu");
							end
							setTimer(function(v)
								setElementData(v,"Moved",false);
							end,5000,1,v)
						end
					end
				end
				break
			end
		end
	end
end)