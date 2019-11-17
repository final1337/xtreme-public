--

-- [[ TABLES ]] --

Business = {pickup = {}, colshape = {}};

-- [[ BUSINESS LADEN ]] --

function Business.loadBusiness()
	local result = dbPoll(dbQuery(handler,"SELECT * FROM business"),-1);
	if(#result >= 1)then
		for _,v in pairs(result)do
			local x,y,z = v["Spawnx"],v["Spawny"],v["Spawnz"];
			Business.pickup[v["ID"]] = createPickup(x,y,z,3,1314,50);
			setElementData(Business.pickup[v["ID"]],"Besitzer",v["Besitzer"]);
			setElementData(Business.pickup[v["ID"]],"Preis",v["Preis"]);
			setElementData(Business.pickup[v["ID"]],"Mindestspielzeit",v["Mindestspielzeit"]);
			setElementData(Business.pickup[v["ID"]],"Name",v["Name"]);
			setElementData(Business.pickup[v["ID"]],"BusinessID",v["ID"]);
			Business.colshape[v["ID"]] = createColSphere(x,y,z,5);
			setElementData(Business.colshape[v["ID"]],"BusinessID",v["ID"]);
			
			addEventHandler("onPickupHit",Business.pickup[v["ID"]],function(player)
				if(not(isPedInVehicle(player)))then
					if(getElementDimension(player) == getElementDimension(source))then
						setElementData(player,"BusinessID",v["ID"]);
						if(getElementData(source,"Besitzer") == "Niemand")then
							triggerClientEvent(player,"Business.buyWindow",player);
						elseif(getElementData(source,"Besitzer") == getPlayerName(player))then
							triggerClientEvent(player,"Business.openVerwaltung",player,getPlayerData("business","ID",getElementData(source,"BusinessID"),"Kasse"));
						end
					end
				end
			end)
			
			addEventHandler("onColShapeHit",Business.colshape[v["ID"]],function(player)
				if (getElementType(player) == "player") then
					if(not(isPedInVehicle(player)))then
						if(getElementDimension(player) == getElementDimension(source))then
							local ID = getElementData(source,"BusinessID");
							local Besitzer,Preis,Mindestspielzeit,Name = getElementData(Business.pickup[ID],"Besitzer"),getElementData(Business.pickup[ID],"Preis"),getElementData(Business.pickup[ID],"Mindestspielzeit"),getElementData(Business.pickup[ID],"Name");
							local x,y,z = getElementPosition(Business.pickup[ID]);
							triggerClientEvent(player,"Business.renderDxDraw",player,Besitzer,Preis,Mindestspielzeit,Name,x,y,z);
						end
					end
				end
			end)
			
			addEventHandler("onColShapeLeave",Business.colshape[v["ID"]],function(player)
				triggerClientEvent(player,"Business.unrenderDxDraw",player);
			end)
		end
	end
end

-- [[ EIN- / AUSZAHLEN ]] --

addEvent("Business.auszahlen",true)
addEventHandler("Business.auszahlen",root,function(summe)
	local summe = tonumber(summe);
	local BusinessID = getElementData(client,"BusinessID");
	local money = getPlayerData("business","ID",BusinessID,"Kasse");
	if(money >= summe)then
		setElementData(client,"Geld",getElementData(client,"Geld")+summe);
		infobox(client,"Du hast "..summe.."€ ausgezahlt.",0,120,0);
		dbExec(handler,"UPDATE business SET Kasse = '"..money-summe.."' WHERE ID = '"..BusinessID.."'");
		triggerClientEvent(client,"Business.refreshKasse",client,money-summe);
	else infobox(client,"In der Bizkasse ist nicht genug Geld!",120,0,0)end
end)
Business.loadBusiness();

addEvent("Business.einzahlen",true)
addEventHandler("Business.einzahlen",root,function(summe)
	local summe = tonumber(summe);
	local BusinessID = getElementData(client,"BusinessID");
	local money = getPlayerData("business","ID",BusinessID,"Kasse");
	if(getElementData(client,"Geld") >= summe)then
		setElementData(client,"Geld",getElementData(client,"Geld")-summe);
		infobox(client,"Du hast "..summe.."€ eingezahlt.",0,120,0);
		dbExec(handler,"UPDATE business SET Kasse = '"..money+summe.."' WHERE ID = '"..BusinessID.."'");
		triggerClientEvent(client,"Business.refreshKasse",client,money+summe);
	else infobox(client,"Du hast nicht genug Geld bei dir!",120,0,0)end
end)

-- [[ KAUFEN ]] --

addEvent("Business.buy",true)
addEventHandler("Business.buy",root,function()
	local BusinessID = getElementData(client,"BusinessID");
	local owner = getPlayerData("business","ID",BusinessID,"Besitzer");
	if(owner == "Niemand")then
		local preis = getPlayerData("business","ID",BusinessID,"Preis");
		if(getElementData(client,"Geld") >= preis)then
			setElementData(client,"Geld",getElementData(client,"Geld")-preis);
			infobox(client,"Du hast das Business gekauft.",0,120,0);
			dbExec(handler,"UPDATE business SET Besitzer = '"..getPlayerName(client).."' WHERE ID = '"..BusinessID.."'");
			triggerClientEvent(client,"dxClassClose",client);
			setElementData(Business.pickup[BusinessID],"Besitzer",getPlayerName(client));
		else infobox(client,"Du hast nicht genug Geld bei dir!",120,0,0)end
	else infobox(client,"Dieses Business steht nicht mehr zum Verkauf!",120,0,0)end
end)

-- [[ VERKAUFEN ]] --

addEvent("Business.sell",true)
addEventHandler("Business.sell",root,function()
	local BusinessID = getElementData(client,"BusinessID");
	local owner = getPlayerData("business","ID",BusinessID,"Besitzer");
	if(owner == getPlayerName(client))then
		local preis = getPlayerData("business","ID",BusinessID,"Kasse");
		setElementData(client,"Geld",getElementData(client,"Geld")+preis/100*75);
		infobox(client,"Du hast dein Business verkauft und 75% des Kaufpreises zurückbekommen.",0,120,0);
		dbExec(handler,"UPDATE business SET Besitzer = 'Niemand' WHERE ID = '"..BusinessID.."'");
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(Business.pickup[BusinessID],"Besitzer","Niemand");
	else infobox(client,"Dieses Business gehört dir nicht!",120,0,0)end
end)

-- [[ GELD IN BUSINESSKASSE ]] --

function putMoneyInBusiness(id,money)
	local money = (money/100)*10;
	local kasse = getPlayerData("business","ID",id,"Kasse");
	dbExec(handler,"UPDATE business SET Kasse = '"..kasse+money.."' WHERE ID = '"..id.."'");
end